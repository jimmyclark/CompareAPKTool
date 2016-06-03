
require("manager/windowManager")

local App = class()

function App:run()
	app = self
	StateMachine.getInstance():changeState(States.Load)
end

function App:ctor()
	-- body
	EventDispatcher.getInstance():register(Event.Message, self, self.onMessageCallBack);

	self.mCheckPopu = {};
	self.mCheckPopu[WindowTag.UpdatePopu] = {status = false};
	self.mCheckPopu[WindowTag.NoticePopu] = {status = false};
	self.mCheckPopu[WindowTag.SignAwardPopu] = {status = false};
	self.mCheckPopu[WindowTag.GuidePopu] = {status = false};
end

function App:dtor()
	-- body
	EventDispatcher.getInstance():unregister(Event.Message, self, self.onMessageCallBack);
end

function App:isInRoom()
	return kCurrentState == States.Room
end

function App:isInGame()
	return G_RoomCfg:getIsPlaying()
end

function App:checkIsBroke()
	return MyUserData:getIsLogin() and MyUserData:getMoney() < MyBaseInfoData:getBrokenMoney()
end

function App:checkResponseOk(data, avoidErrorTip)
	if data and data.status == 1 and data.data then
		return true
	elseif not avoidErrorTip and data.msg then
        AlarmTip.play(data.msg)
	end
end

function App:checkCanEnter2Scene()
	-- 未登录
	local isLogin = MyUserData:getIsLogin()
	if not isLogin then
		WindowManager:showWindow(WindowTag.LoginPopu, {}, WindowStyle.NORMAL);
	end
	return isLogin
end

-- 判断是否展示首充
function App:judgeShowFirstPayPopu(chargeType)
	--本月是否完成首充
	if not ShieldData:getAllFlag() and MyBaseInfoData:getFirstPay() == 0 then
		WindowManager:showWindow(WindowTag.FirstPayBagPopu, {
			chargeType = chargeType,
		})
		return true
	end
end

function App:judgeRequestSignInfo()
	local reconnWindow = WindowManager:containsWindowByTag(WindowTag.ReconnMessageBox)
	local guideWindow = WindowManager:containsWindowByTag(WindowTag.GuidePopu)
	if not self:isInRoom() and not reconnWindow and not guideWindow and MyUserData:getIsLogin() and not MySignAwardData:getInit() then
        GameSocketMgr:sendMsg(Command.SIGN_AWARD_PHP_REQUEST, {}, false);
    end
end

function App:checkPopu( popuId )
	-- body
	for k, v in pairs(self.mCheckPopu) do
		if k == popuId and not v.status then
			return true;
		end
	end
	return false;
end

function App:clearPopu()
	-- body
	for k, v in pairs(self.mCheckPopu) do
		v.status = false;
	end
end

function App:setPopuStatus( popuId, status )
	-- body
	self.mCheckPopu[popuId].status = status;
end

function App:onMessageCallBack(key, data)
	if key == 'closePopu' then
		-- 如果是重连弹窗 并且不是closeBtn关闭则不处理弹窗优先级
		if (data.popuId == WindowTag.ReconnMessageBox or
			data.popuId == WindowTag.SignAwardPopu) and data.isOtherDismiss then
			return
		end
		if #WindowManager:getVisibleTb() == 0 and kCurrentState == States.Lobby and not ShieldData:getAllFlag() then
			--非新用户
			if MyUserData:getIsRegister() ~= 1 then
				if self:checkPopu(WindowTag.UpdatePopu) and MyUpdateData:getInit() and  --是否有更新
					(MyUpdateData:getAward() == 1 or MyUpdateData:getUpdate() == 1) then
					WindowManager:showWindow(WindowTag.UpdatePopu, {}, WindowStyle.POPUP);
					self:setPopuStatus(WindowTag.UpdatePopu, true);
				elseif self:checkPopu(WindowTag.NoticePopu) and MyNoticeData:count() > 0 then--是否有更新
					WindowManager:showWindow(WindowTag.NoticePopu, {}, WindowStyle.POPUP);
					self:setPopuStatus(WindowTag.NoticePopu, true);
				elseif self:checkPopu(WindowTag.SignAwardPopu) and MySignAwardData:getInit() then --是否有签到奖励
					WindowManager:showWindow(WindowTag.SignAwardPopu, {}, WindowStyle.POPUP);
					self:setPopuStatus(WindowTag.SignAwardPopu, true);
				end
			else--新用户
				if self:checkPopu(WindowTag.SignAwardPopu) and MySignAwardData:getInit() and MySignAwardData:getToday_sign() == 1 then --是否有签到奖励
					WindowManager:showWindow(WindowTag.SignAwardPopu, {}, WindowStyle.POPUP);
					self:setPopuStatus(WindowTag.SignAwardPopu, true);
				end
			end
		end
	end
end

-- 点击快充按钮 通过金币判断
function App:selectGoodsForChargeVarMoney(params)
	params = params or {}
	local chargeType = params.chargeType or ChargeType.QuickCharge
	-- 根据金币自动查找额度
	local isBroke = self:checkIsBroke()
	repeat
		-- 如果可以弹出首充 则根据此回合是否破产设置下回合不弹首充
		if not MyUserData:getAvoidFirstPay() and self:judgeShowFirstPayPopu(chargeType) then
			if isBroke and not self:isInRoom() then
				printInfo("App:selectGoodsForChargeByLevel setAvoidFirstPay true")
			end
			MyUserData:setAvoidFirstPay(isBroke and not self:isInRoom())
			break
		end
		-- 根据金币查找推荐额度
		local pamount = MyMoneyRecommendData:getPamountByMoney(MyUserData:getMoney())
		if not pamount then
			AlarmTip.play("没有相应的额度")
			GameSocketMgr:sendMsg(Command.PAY_RECOMMEND_PHP_REQUEST, {})
			break
		end
		-- 根据额度查找商品
		local goodsIndex, goodsInfo = PayController:getGoodsInfoByPamount(pamount, 0)
		if not goodsIndex then
			AlarmTip.play("商品不存在")
			globalRequestChargeList(true);
			break
		end
		-- 在游戏中 或者 未破产的快充都直接下单 不走弹窗
		if (app:isInGame() or not isBroke) and chargeType == ChargeType.QuickCharge then
			globalRequestCharge(goodsInfo, {}, false);
		else
			if isBroke then
				WindowManager:showWindow(WindowTag.BankruptPopu, {
					goodsIndex = goodsIndex,
					goodsInfo = goodsInfo,
				});
			else
				WindowManager:showWindow(WindowTag.RechargePopu, {
					goodsIndex = goodsIndex,
					goodsInfo = goodsInfo,
					-- 需要不在牌局中才弹破产
					chargeType = ChargeType.QuickCharge,
				});
			end
		end
	until true
end

--@defineType 自定义的类型
function App:selectGoodsForChargeByLevel(params)
	params = params or {}
	local level = params.level or G_RoomCfg:getLevel()
	local chargeType = params.chargeType
	local isBroke = self:checkIsBroke()
	local avoidFirstPay = params.avoidFirstPay
	repeat
		-- 如果可以弹出首充 则根据此回合是否破产设置下回合不弹首充
		if not MyUserData:getAvoidFirstPay() and not avoidFirstPay and self:judgeShowFirstPayPopu(chargeType) then
			if isBroke and not self:isInRoom() then
				printInfo("App:selectGoodsForChargeByLevel setAvoidFirstPay true")
			end
			MyUserData:setAvoidFirstPay(isBroke and not self:isInRoom())
			break
		end
		-- 根据场次查找推荐额度
		local pamount = MyLevelConfigData:getPamountByLevel(level)
		if not pamount then
			AlarmTip.play("没有相应的额度")
			GameSocketMgr:sendMsg(Command.ROOM_CONFIG_PHP_REQUEST, {})
			break
		end
		-- 根据额度查找商品
		local goodsIndex, goodsInfo = PayController:getGoodsInfoByPamount(pamount, 0)
		if not goodsIndex then
			AlarmTip.play("商品不存在")
			globalRequestChargeList(true);
			break
		end
		-- 在游戏中 或者 未破产的快充都直接下单 不走弹窗
		if (app:isInGame() or not isBroke) and chargeType == ChargeType.QuickCharge then
			globalRequestCharge(goodsInfo, {}, false);
		else
			if isBroke then
				WindowManager:showWindow(WindowTag.BankruptPopu, {
					goodsIndex = goodsIndex,
					goodsInfo = goodsInfo,
				});
			else
				WindowManager:showWindow(WindowTag.RechargePopu, {
					goodsIndex = goodsIndex,
					goodsInfo = goodsInfo,
					-- 需要不在牌局中才弹破产
					chargeType = (isBroke and ChargeType.BrokeCharge) or chargeType or ChargeType.QuickCharge,
				});
			end
		end
	until true
end

-- 大厅连接成功
function App:onSocketConnected()
	dump("连接大厅成功 自动登录大厅")
	-- 开始心跳包
	GameSetting:setDisableReconn(false)
	GameLoading:onCommandResponse(Command.SOCKET_EVENT_CONNECTED)
	LoginMethod:autoRequestLogin()
	GameSocketMgr:startHeartBeat();

	ConnectModule.getInstance():onSocketConnected()
end

--登录php成功后  server会自动返回登录大厅成功， 此时再进行业务操作
function App:onLoginLobbySuccess()
	printInfo("LobbyController:onLoginResponse");
	GameSocketMgr:sendMsg(Command.ONEKEY_HIDE_PHP_REQUEST, {})
	--清除弹窗状态
	self:setPopuStatus(WindowTag.SignAwardPopu, false);
	--清楚所有弹框
	WindowManager:clearAllWindow()

	if self.mLastMid and self.mLastMid ~= MyUserData:getId() then
		self:clearPopu();
	end
	self.mLastMid = MyUserData:getId();

	--用户基本信息
	GameSocketMgr:sendMsg(Command.GET_BASEINFO_PHP_REQUEST, {infoParam = {s1 = 0xf, d1 = 0xff}}, false);
	--公告
	-- 放到后面了，拉到屏蔽信息之后再拉公告
	-- GameSocketMgr:sendMsg(Command.NOTICE_PHP_REQUEST, {}, false);
	--商城
	globalRequestChargeList(true);

	--首充
    GameSocketMgr:sendMsg(Command.FIRST_PAY_BAG_PHP_REQUEST, {}, false);

	--更新
	--保持在最后
	-- 放到后面了，拉到屏蔽信息之后再拉更新
	-- GameSocketMgr:sendMsg(Command.UPDATE_PHP_REQUEST, {}, false);

	if not ShieldData:getAllFlag() then
		app:judgeRequestSignInfo()
	end

    -- 房间配置
    if not MyLevelConfigData:getInit() then
		GameSocketMgr:sendMsg(Command.ROOM_CONFIG_PHP_REQUEST, {})
    end
    -- 充值推荐金币区间配置
    if not MyMoneyRecommendData:getInit() then
    	-- 拉取推荐额度
		GameSocketMgr:sendMsg(Command.PAY_RECOMMEND_PHP_REQUEST, {})
	end

	-- 很多情况下iOS用户会使用系统自带的一键更新功能，或者是在AppStore更新，此时需要做额外处理才能保证更新领奖功能的正常
	if isPlatform_IOS then
		local update = ToolKit.getDict("UPDATE", {'version'});
		-- 判断之前保存的版本信息，如果与当前版本不同（也就是当前为新版本），则进行更新领奖流程
		if update.version and update.version ~= "" and update.version ~= PhpManager:getVersionName() then
			-- 保存是否已更新
			ToolKit.setDict("UPDATE", { isupdated = 1 })
			-- 当前的更新领奖流程为：上报新版本版本号给PHP记录->更新完毕后再上报版本号，让PHP对比是否为之前上报的版本号，若是则进行更新
			GameSocketMgr:sendMsg(Command.SETUPDATE_PHP_REQUEST, {}, false);
		end
		-- 保存当前版本号
		ToolKit.setDict("UPDATE", { version = PhpManager:getVersionName() });
	end

	kRoomTable = "kwx_room/roomTable.png"		-- iPad需要其他分辨率的牌桌，为了兼容安卓在这里先设定原始牌桌，然后在后面根据设备类型选择牌桌。好蛋疼
	NativeEvent.getInstance():lobbyLoginSuccessed()		-- 登陆成功通知原生，方便进行一些操作

    
   	--ConnectModule.getInstance():startIpTurnConnect()
end

function App:quickStartGame()
	if App:isInRoom() then return end
	if not self:checkCanEnter2Scene() then
		return
	end
	-- 首先判断是不是破产了
	if self:checkIsBroke() then
		self:selectGoodsForChargeVarMoney({
			chargeType = ChargeType.BrokeCharge,
		})
		return
	end
	local levelConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney()
	if levelConfig then
		self:requestEnterRoom(levelConfig:getLevel(), true)
	else
		printInfo("金币过少")
		self:selectGoodsForChargeByLevel({
			chargeType = ChargeType.NotEnoughMoney,
		})
	end
end

function App:onNetErrorBackToLobby()
	-- 如果网络正常 更新域名配置
   	if NativeEvent.getInstance():GetNetAvaliable() == 1 then
   		---- HallConfig:freshNetConfig(true)
   		ConnectModule.getInstance():startIpTurnConnect()
   	end
	GameLoading:stop()
	StateChange.changeState(States.Lobby, {
		type = StateEvent.SocketClosed,
	})
end

function App:onSocketTimeOut()
	printInfo("App:onSocketTimeOut");
	GameLoading:timeoutStop()
end

function App:onSocketSendError()
	GameLoading:timeoutStop()
	printInfo("App:onSocketSendError");
end

-- 请求进入房间
-- @ reconnFlag 是否重连情况下的进房间
function App:requestEnterRoom(level, iQuickStart, reconnFlag)
	if not GameSocketMgr:checkSocketOk() then return end
	if not self:checkCanEnter2Scene() then return end
	if not reconnFlag and self:checkIsBroke() then
		self:selectGoodsForChargeVarMoney({
			chargeType = ChargeType.BrokeCharge,
		})
		return
	end

    printInfo("在房间内发送请求房间命令")
	GlobalRoomLoading:play()
	G_RoomCfg:setIsQuickStart(iQuickStart)
    GameSocketMgr:sendMsg(Command.JoinGameReq, {
		iGameType = GameType.KWXMJ,
		iMoney = MyUserData:getMoney(),
		iUserInfoJson = json.encode(MyUserData:packPlayerInfo()),
		iMtKey = MyUserData:getMtkey(),
		iOriginAPI = PhpManager:getApi(),
		iVersion = PhpManager:getVersionCode(),
		iVersionName = PhpManager:getVersionName(),
		iChangeDesk = 0,
		iQuickStart = iQuickStart and 1 or 0,
		iLevel = tonumber(level),
	})
end

-- 进入邀请的房间
function App:requestEnterInviteRoom()
	GlobalRoomLoading:play()
    GameSocketMgr:sendMsg(Command.JoinGameReq, {
		iGameType = GameType.KWXMJ,
		iMoney = MyUserData:getMoney(),
		iUserInfoJson = json.encode(MyUserData:packPlayerInfo()),
		iMtKey = MyUserData:getMtkey(),
		iOriginAPI = PhpManager:getApi(),
		iVersion = PhpManager:getVersionCode(),
		iVersionName = PhpManager:getVersionName(),
		iChangeDesk = 0,
		iQuickStart = 0,
		iLevel = 21,
		iFid = tonumber( PhpManager:getFid() ),
	})
end

-- 点击房间或者 在房间内点准备
function App:checkReadyByGameAndLevel(gameType, level)
	-- 根据金币判断是否可以准备
	printInfo("检查玩法%d，level=%d", gameType, level)
	local money = MyUserData:getMoney()
	local levelConfig = MyLevelConfigData:getLevelConfig(level)
	-- 根据玩法和当前level 判断是否可继续游戏
	if not levelConfig or money >= levelConfig:getXzrequire() then
		-- printInfo("money : %d, getRequire() : %s, getXzrequire() : %s", money, levelConfig:getRequire(), levelConfig:getXzrequire())
		return true
	end
end

function App:requestRoomReady(gameType, level)
	gameType = gameType or G_RoomCfg:getGameType()
	level = level or G_RoomCfg:getLevel()
	repeat
		printInfo("看看")
		-- 如果不能准备
		if not self:checkReadyByGameAndLevel(gameType, level) then
			printInfo("真的")
			-- 降场
			local newConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney(money)
			-- 低倍场
			if self:checkIsBroke() then
				self:selectGoodsForChargeVarMoney({
					chargeType = ChargeType.BrokeCharge,
				})
				return
			elseif newConfig then
				self:selectGoodsForChargeByLevel({
					level = level,
					chargeType = ChargeType.NotEnoughMoney,
				})
				return
			end
		end
		-- 可以正常准备
		GameSocketMgr:sendMsg(Command.ReadyReq)
	until true
end

function App:findChangeRoomConfig()
	return MyLevelConfigData:getLevelConfig(G_RoomCfg:getLevel()),
		MyLevelConfigData:getSuggestLevelConfigVarMoney(MyUserData:getMoney())
end

--@changeType 是否指定换场类型
function App:requestChangeDesk(changeType)
	if not changeType then
		-- 如果没有指定 则重新判断
		changeType = ChangeDeskType.Change
		local levelConfig, suggestConfig = self:findChangeRoomConfig()
		-- 升场
		if levelConfig and suggestConfig and suggestConfig:getRequire() > levelConfig:getRequire() then
			changeType = ChangeDeskType.Up
		end
	end
	printInfo("请求切换桌子 %d", changeType)
	if changeType == ChangeDeskType.Change then
		-- 判断是否发生了降场(弹充值提示)
		if not self:checkReadyByGameAndLevel(G_RoomCfg:getGameType(), G_RoomCfg:getLevel()) then
			self:selectGoodsForChargeByLevel({
				level = G_RoomCfg:getLevel(),
				chargeType = ChargeType.NotEnoughMoney,
			})
			return ChangeDeskType.Down
		end
	end
	printInfo("请求切换桌子 %d", changeType)
	printInfo("切换桌子 设置快速开始")
	local iQuickStart = true
	G_RoomCfg:setIsQuickStart(iQuickStart)
	GameSocketMgr:sendMsg(Command.ChangeDeskReq, {
		iChangeType = changeType,
		iQuickStart = iQuickStart and 1 or 0,
	})
	return changeType
end

-- 主要用于server命令字的超时
function App:onCommandTimeout(cmd)
	--进房间超时
	if cmd == Command.JoinGameReq then
		StateChange.changeState(States.Lobby)
		GameSocketMgr:sendMsg(Command.LogoutRoomReq)
	elseif cmd == Command.SOCKET_EVENT_CONNECTED then --连接服务器失败
		GameSocketMgr:onSocketConnectFailed()
	end
end

-- 判断二级界面是否被屏蔽
-- 返回flag 是否被屏蔽
function App:checkEnterSceneIsShield(tag)
	if tag == WindowTag.SignAwardPopu then
		return ShieldData:getAllFlag()
	end
	-- 默认没有屏蔽
	local flag = false
	if tag == WindowTag.ActivityPopu then
		flag = ShieldData:getAllFlag()
	elseif tag == WindowTag.RankPopu then
		flag = ShieldData:getAllFlag()
	end
	if flag then
		AlarmTip.play("敬请期待")
	end
	return flag
end

function App:dealBusinessAfterShield()
	-- 公告
	if not ShieldData:getAllFlag() then
		GameSocketMgr:sendMsg(Command.NOTICE_PHP_REQUEST, {}, false);
	end
	-- 更新
	if not ShieldData:getAllFlag() then
		GameSocketMgr:sendMsg(Command.UPDATE_PHP_REQUEST, {}, false);
	end
	if not ShieldData:getAllFlag() and isPlatform_IOS() then
		--拉取活动相关数据
		GameSocketMgr:sendMsg(Command.GET_ACTRELATED_PHP_REQUEST, {})
	end
	-- 签到
	if not ShieldData:getAllFlag() then
		app:judgeRequestSignInfo()
	end

	-- 拉取兑换商品
	-- if MyExchangeData:count() == 0 then
	GameSocketMgr:sendMsg(Command.EXCHANGE_LIST_REQUEST, {});
	-- end

	-- 好友相关
	-- GameSocketMgr:sendMsg(Command.FRIEND_GET_ALLFRIEND_PHP_REQUEST, {}, false);  
	-- GameSocketMgr:sendMsg(Command.FRIEND_GET_RECOMMEND_PHP_REQUEST, {}, false);
    -- 拉取邮件消息
	GameSocketMgr:sendMsg(Command.MAIL_GET_SYSTEMMSG_PHPREQUEST, {}, false);  
	-- GameSocketMgr:sendMsg(Command.MAIL_GET_FRIENDMSG_PHPREQUEST, {}, false);  

	GameSocketMgr:sendMsg(Command.CREATEROOMFIG_GET_PHP_REQUEST, {}, false);  
end

-- 下单
function App:createOrderReal(goodsInfo)
	AlarmTip.play("正在创建订单...");
	local appid 			= goodsInfo.appid
	local pmode 			= goodsInfo.pmode
	local id 				= goodsInfo.id
	local pamount 			= goodsInfo.pamount
	-- local ptype 			= goodsInfo.ptype
	local iscn = 1;		-- 苹果支付下单要走国际线路，其他支付都是国内线路，需要加以区分
	-- if self.payType == UnitePayIdMap.APPLE_PAY then
-- 	iscn = 0;
	-- end
	-- local param = {}
	-- param.sid = PlatformConfig.sid
	-- param.appid = appid
	-- param.id = id
	-- param.pmode = pmode
	-- param.pamount = pamount
	-- param.ptype = ptype
	-- param.iscn = iscn
	dump(goodsInfo)
    -- printInfo("createOrderReal sid:"..param.sid.." appid:"..param.appid.." pmode:"..param.pmode.." ptype:"..param.ptype.." iscn"..param.iscn);
	GameSocketMgr:sendMsg(Command.ORDER_PHP_REQUEST, {["param"] = goodsInfo}, false);
end

-- 显示营销页
function App:showPayConfirmWindow(goodsInfo, confrimFuc, cancelFuc)
	dump(goodsInfo)
	WindowManager:showWindow(WindowTag.PayComfirmPopu, {
		text = string.format(PayConfirmTip, goodsInfo.pname, goodsInfo.pamount),
		titleText = "温馨提示",
		leftText = "确定",
		singleBtn = true,
		closeFunc = handler(nil, function ()
									cancelFuc(PayController);
								end),
		leftFunc = handler(nil, function ()
									confrimFuc(PayController)
								end),
	})
end

-- 显示支付选择框
function App:showPaySelectWindow(payInfo)
	WindowManager:showWindow(WindowTag.PayPopu, payInfo);
end

return App
