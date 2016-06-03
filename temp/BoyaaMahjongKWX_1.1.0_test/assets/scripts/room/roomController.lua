local TimerClock 	= import(".entity.timerClock")
local RoomCoord 	= import(".coord.roomCoord")
local Card 			= import(".entity.card")
local CardPanelCoord = import(".coord.cardPanelCoord")
local RoomController = class(BaseController)
local printInfo, printError = overridePrint("RoomController")

RoomController.s_controls = {
	bg = 1,
	desk = 2,
	timerView = 3,
	roomInfoView = 4,
}

function RoomController:ctor(viewConfig, stateRef, bundleData)
	printInfo("房间控制器ctor")
	self:initCommonView()
	self.m_root:setVisible(false);

	testRoomController = self
	GameSetting:setSoundType(SoundType.Common)
	--注册HTTP回调
	EventDispatcher.getInstance():register(HttpModule.s_event, self, self.onPHPRequestsCallBack);

	printInfo("添加监控")
	kMusicPlayer:play(Music.AudioGameBack, true)
	self:onEnsureGameType(bundleData)
end

function RoomController:handlerExitRoom()
	GameSocketMgr:sendMsg(Command.LogoutRoomReq)
	StateChange.changeState(States.Lobby)
	--用户基本信息 更新用户基本信息
    GameSocketMgr:sendMsg(Command.GET_BASEINFO_PHP_REQUEST, {infoParam = {s1 = 0xf, d1 = 0xff}}, false);
end

function RoomController:handlerCreateRoomBack()
	local curRound = G_RoomCfg:getCurRound()
	local totalRound = G_RoomCfg:getRoundNum()

	-- curRound = 1
	-- totalRound = 2
	-- 牌局开始前
	if curRound == 0 then
		local tipsStr = ""
		if G_RoomCfg:getIsMaster() then
			tipsStr = "您退出则解散房间，无法继续游戏，您确定要解散？"
		else
			tipsStr = "精彩牌局即将开始，您确定要退出吗？"
		end

		WindowManager:showWindow(WindowTag.MessageBox, {
			text = tipsStr,
			leftText = "确定",
			singleBtn = true,
			leftFunc = function()
				-- 退款
				if G_RoomCfg:getIsMaster() then
					-- GameSocketMgr:sendMsg(Command.REPAYMENT_BATTLE_PHP_REQUEST, {["boyaacoin"] = 1})
					AlarmTip.play("解散房间成功，退还1钻石")
				end
				-- 退出
				self:handlerExitRoom()	

			end
			}, WindowStyle.NORMAL)
		
	-- 未完成局数
	elseif curRound < totalRound then
		WindowManager:showWindow(WindowTag.MessageBox, {
			text = "您还没有完成初始设定的局数，退出需要其余玩家全部同意。您确定要退出吗？",
			leftText = "确定",
			singleBtn = true,
			leftFunc = function()
				AlarmTip.play("已向其他玩家发送请求，请等待...")
				G_RoomCfg:setIsSendExitReq(true)
				GameSocketMgr:sendMsg(Command.SERVER_EXIT_PRIVATEROOM_REQ, {
		    		iUserId = MyUserData:getId()	    		
				})

			end
			}, WindowStyle.NORMAL)

	elseif curRound == totalRound then
		self:handlerExitRoom()					
	end
end

function RoomController:onBack()
	if self:isPlaying() then
		AlarmTip.play("请在游戏结束后退出房间")
	else

		if 1 == G_RoomCfg:getIsCompart() then
			self:handlerCreateRoomBack()			
		else
			self:handlerExitRoom()					
		end
	end
end

function RoomController:resume(bundleData)
	RoomController.super.resume(self);
end

-- 适配添加新的ui控件
function RoomController:initCommonView()
	local bgView = self.m_root:findChildByName("bg")
	-- bgView:packDrawing(true)

	local exitBtn = self.m_root:findChildByName("btn_exit")
	exitBtn:setOnClick(nil, handler(self, self.onBack))

	local setBtn = self.m_root:findChildByName("btn_setting")
	setBtn:setOnClick(nil, function()
		WindowManager:showWindow(WindowTag.RoomSetting)
	end)

	local chatBtn = self.m_root:findChildByName("btn_chat")
	chatBtn:setOnClick(nil, function()
		WindowManager:showWindow(WindowTag.RoomChat)
	end)

-- 点击聊天
	self.m_root:findChildByName("img_paomadeng"):setEventTouch(self, function(self,  finger_action)
		-- body
		if finger_action == kFingerDown then
			WindowManager:showWindow(WindowTag.ChatViewPopu, nil)
		end
	end)

	local gainCoinBtn = self.m_root:findChildByName("btn_gainCoin")
	gainCoinBtn:setOnClick(nil, function()
		app:selectGoodsForChargeByLevel({
		    level = G_RoomCfg:getLevel(),
			chargeType = ChargeType.QuickCharge,
		})
	end)

	local timeText = self.m_root:findChildByName("time_text")
	local midText  = self.m_root:findChildByName("mid_text")
	local timeCallBack = function()
		local time = os.time()
		local strText = os.date("%H %M", time)
		midText:setVisible(time % 2 == 0)
		timeText:setText(strText);
	end
	local anim = timeText:addPropTranslate(1, kAnimRepeat, 1000, 0, 0, 0, 0, 0)
	anim:setDebugName("RoomController | RoomController.timeAnim");
	anim:setEvent(nil, timeCallBack)
	timeCallBack()

	-- local diText = self.m_root:findChildByName("di_text")
	-- UIEx.bind(diText, G_RoomCfg, "di", function(value)
	-- 	if G_RoomCfg:getGameType() == GameType.SHMJ then
	-- 		diText:setText(string.format("底分:%d", value))
	-- 	else
	-- 		diText:setText(string.format("底注:%d", value))
	-- 	end
	-- end)

	-- 添加玩法说明
	self.m_infoText = self.m_root:findChildByName("info_text")
	UIEx.bind(self.m_infoText, G_RoomCfg, "roomName", function(value)
		self.m_infoText:setText(value)
	end)
	-- 绑定换场动画
	UIEx.bind(self.m_infoText, G_RoomCfg, "playChanged", function(flag)
		checkAndRemoveOneProp(self.m_infoText, 1001)
		self.m_infoText:addPropScaleWithEasing(1001, kAnimNormal, 500, 0, 'easeOutBounce', 'easeOutBounce', 1.5, -0.5)

		if diText and diText:alive() then
			checkAndRemoveOneProp(diText, 1001)
    		diText:addPropScaleWithEasing(1001, kAnimNormal, 500, 0, 'easeOutBounce', 'easeOutBounce', 1.5, -0.5)
    	end
	end)

	self.m_centerInfoView = self.m_root:findChildByName("tableInfoView")
	self.m_infoBg = self.m_root:findChildByName("info_bg")
	local text_info = self.m_root:findChildByName("info_text")
	local text_di = self.m_root:findChildByName("di_text")
	local roundnum_text = self.m_root:findChildByName("roundnum_text")
	UIEx.bind(text_info, G_RoomCfg, "roomName", function(value)
		text_info:setText(value or "")
	end)
	UIEx.bind(text_di, G_RoomCfg, "di", function(value)
		text_di:setText(string.format("底注：%d", (value or 0)))
	end)
	UIEx.bind(roundnum_text, G_RoomCfg, "curRound", function(value)
		roundnum_text:setText(string.format("%d/%d局", (value or 0), G_RoomCfg:getRoundNum()))
	end)
	local view_paomadeng = self:findChildByName("view_paomadeng")
	BroadcastPaoMaDeng:setDelegate(self, view_paomadeng)

	self:initPrivateRoomView(false)


	--test historyscore
	-- local historyCfg = G_RoomCfg:getHistoryScore()
	-- historyCfg.historytab = {}
	-- historyCfg.seat2 = "玩家1"
	-- historyCfg.seat4 = "玩家2"
	-- -- historyCfg.headseat4 = "玩家2"
	-- -- historyCfg.headseat4 = "玩家2"
	-- for i = 1, 6 do
	-- 	local temp = {}
	-- 	temp.my = i+100
	-- 	temp.play2 = i+100
	-- 	temp.play4 = i+100
	-- 	table.insert(historyCfg.historytab, temp)
	-- end
	-- G_RoomCfg:setHistoryScore(historyCfg)
	-- local historyCfg = G_RoomCfg:getHistoryScore()

	local historyCfg = G_RoomCfg:getHistoryScore()
	if not historyCfg.historytab then historytab = {} end
	G_RoomCfg:setHistoryScore(historyCfg)

end

function RoomController:initPrivateRoomView( isShow )
	local btn_invateSeat4 = self:findChildByName("btn_invateSeat4")
	local btn_invateSeat2 = self:findChildByName("btn_invateSeat2")
	local btn_history = self:findChildByName("btn_history")
	local roundnum_text = self:findChildByName("roundnum_text")
	local di_text = self:findChildByName("di_text")
	local gainCoinBtn = self.m_root:findChildByName("btn_gainCoin")
	local btn_chest = self.m_root:findChildByName("btn_chest")
	local view_giveCoin = self.m_root:findChildByName("view_giveCoin")


	if isShow then
		if G_RoomCfg:getIsMaster() then
			local _player2 = self.m_players[SEAT_2]
			if SEAT_2 == _player2:getUserData():getSeatId() then
				btn_invateSeat2:hide()
			else
				btn_invateSeat2:show()
			end

			local _player4 = self.m_players[SEAT_4]
			if SEAT_4 == _player4:getUserData():getSeatId() then
				btn_invateSeat4:hide()
			else
				btn_invateSeat4:show()
			end 
		end

		btn_history:show()
		roundnum_text:show()

		di_text:hide()
		gainCoinBtn:hide()
		btn_chest:hide()
		view_giveCoin:hide()
	else
		btn_invateSeat4:hide()
		btn_invateSeat2:hide()
		btn_history:hide()

		roundnum_text:hide()
		di_text:show()
		gainCoinBtn:show()
		btn_chest:show()
		view_giveCoin:show()
		return
	end
	
	btn_invateSeat4:setOnClick(self, function( self )
		WindowManager:showWindow(WindowTag.inviteEntryPopu, G_RoomCfg:getInviteData())
	end)

	btn_invateSeat2:setOnClick(self, function( self )
		WindowManager:showWindow(WindowTag.inviteEntryPopu, G_RoomCfg:getInviteData())
	end)

	btn_history:setLevel(190)
	btn_history:setOnClick(self, function( self )
		WindowManager:showWindow(WindowTag.historyPopu, {},WindowStyle.MOVETO_DOWN)
	end)


	self:findChildByName("text_inviteSeat4"):setPickable(false)
	self:findChildByName("text_inviteSeat2"):setPickable(false)
end

function RoomController:unCoverSocketTool()
	if self.m_reader then
		GameSocketMgr:removeCommonSocketReader(self.m_reader);
    	GameSocketMgr:removeCommonSocketWriter(self.m_writer);
    	delete(self.m_reader);
		delete(self.m_writer);
		self.m_reader = nil;
		self.m_writer = nil;
	end
end

function RoomController:coverSocketTool(gameType)
	gameType = gameType or 0
	printInfo("gameType = %d", gameType)
	self:unCoverSocketTool()
	local config = GameSocketMap[gameType]
	if config then
		self.m_reader		= new(require(config.reader))
		self.m_writer		= new(require(config.writer))
		printInfo("绑定的socketreader = %s", self.m_reader.m_sockName or "weizhi")
		GameSocketMgr:addCommonSocketReader(self.m_reader);
    	GameSocketMgr:addCommonSocketWriter(self.m_writer);
	end
end

function RoomController:dtor()
	BroadcastPaoMaDeng:clearDelegate(self)
	EventDispatcher.getInstance():unregister(HttpModule.s_event, self, self.onPHPRequestsCallBack);
	G_RoomCfg:clearForExitRoom()
	-- GuideManager:stop()
	kMusicPlayer:stop(true);
	AnimManager:releaseAnimByTag(AnimationTag.RoomStart, AnimationTag.RoomEnd)
	self:unCoverSocketTool()

	if(self.addMoneyAnim) then -- isLevelUp = true 升级动画添加的金币数量动画资源释放
       delete(self.addMoneyAnim);
       self.addMoneyAnim = nil
	end

	if self.showGameOverWindowDelay then
		delete(self.showGameOverWindowDelay)
		self.showGameOverWindowDelay = nil
	end
	-- 停止心跳包
	GameSocketMgr:stopHeartBeat();
end

--终于确定了gameType
--由于这里会存在多次重复调用，请确保这里的方法有做重复处理
function RoomController:onEnsureGameType(data)
	local config = data.iConfig
	local gameType = config.iGameType
	printInfo("RoomController:onEnsureGameType")
	G_RoomCfg:setGameType(gameType)
	self:bindMethodByGameType(gameType)
	self:coverSocketTool(gameType)

	self:_initAllPlayers()
	-- 扩展添加新的ui
	self:adapterGameView()

	self:initCommandFuncMap()
	if data.iReconn then
		self:onReconnSuccess(data)
	else
		self:onEnterRoomSuccess(data)
	end
end

function RoomController:onRequestAi(aiType)
	self.mySelf:requestAi(aiType)
end

function RoomController:bindMethodByGameType(gameType)
	dump(gameType)
	dump(GameControllerMap)
	local controllerPath = GameControllerMap[gameType]
	dump(controllerPath)
	local bindFunc = require(controllerPath)
	if bindFunc then
		bindFunc(self)
	end
end

-----------------------  [[ Socket 事件]] -------------------------
-- 登录房间成功 0x1110
function RoomController:onEnterRoomSuccess(data, isReconn)
	-- 是否包间
	if 1 == data.iIsCreate then
		G_RoomCfg:setIsCompart(1)
	end
	-- 如果状态还是在玩牌 则提示牌局已结束
	if G_RoomCfg:getIsPlaying() then
		AlarmTip.play("牌局已经结束，请继续下一局吧")
		self:resetGameTable()
		G_RoomCfg:setIsPlaying(false)
		self.mySelf:showReadyView(true)
	else
		--为了准备按钮的交互
		-- 进房间时不显示准备按钮， 在0x1112的时候来判断是否显示
		G_RoomCfg:setIsPlaying(false)
		self.mySelf:showReadyView(false)
	end
	-- 初始化房间配置  并 同步金币
	G_RoomCfg:initInfo(data.iConfig, data.iMySeatId)
	MyUserData:setSeatId(data.iMySeatId)
	if 1 == G_RoomCfg:getIsCompart()  then MyUserData:setScore(data.iMyMoney)
	else MyUserData:setMoney(data.iMyMoney)	end
	MyUserData:refreshInfo() --刷新自己的数据，更新房间ui
	printInfo("登录房间结果 %d", data.iMySeatId);
	local player = self:_initPlayer(SEAT_1)
	--FIX 重连导致操作面板没有正常关闭 而引起的显示问题
	player:hideOperatePanel()
	player:onEnterRoom(data.iIsReady)
	local players = data.iPlayersInfo
	local existIds = {}
	for i, playerInfo in ipairs(players) do
		self:onUserEnter(playerInfo)
		existIds[playerInfo.iUserId] = true
	end
	-- 如果玩家在位置上 但是房间信息里面并没有这个玩家
	for seatId, _player in pairs(self.m_players) do
		if seatId ~= SEAT_1 and _player:getGameData():getIsExist() then
			if not existIds[_player:getUserData():getId()] then
				_player:onUserExit()
			end
		end
	end


	--开设包间进入
	if 1 == G_RoomCfg:getIsCompart() then
		G_RoomCfg:setIsCompart(1)
		G_RoomCfg:setFid(data.iExterConfig.iFid)
		G_RoomCfg:setRoundNum(data.iExterConfig.iRoundNum)
		G_RoomCfg:setCurRound(0)

	    -- GameSocketMgr:sendMsg(Command.PAYMENT_BATTLE_PHP_REQUEST, {["boyaacoin"] = 1})
		if MyUserData:getId() == data.iExterConfig.iUid then
			G_RoomCfg:setIsMaster(true)
			AlarmTip.play("创建房间成功，消耗1钻石")
		end

		self:initPrivateRoomView(true)
		-- 只有房主才能邀请
		if G_RoomCfg:getIsMaster() then
			GameSocketMgr:sendMsg(Command.INVITECON_GET_PHP_REQUEST, {
					["fid"] = data.iExterConfig.iFid,
					["fields"] = {
							["roundnum"] = data.iExterConfig.iRoundNum,
							["basepoint"] = data.iExterConfig.iBasePoint,
							["bei"] = data.iExterConfig.iKwxBei,
							["playtype"] = data.iExterConfig.iPlayType,
					}})
		end
	else
		G_RoomCfg:setIsCompart(0)
	end

	--检测进房间新手引导
	-- GuideManager:onEnterRoomGuide({
	-- 	arrowObj = self.m_infoBg
	-- })
end

function RoomController:onGetInviteContent( data )
	G_RoomCfg:setInviteData(data)
	self.showInviteWindowDelay = new(AnimInt, kAnimNormal, 0, 1, 500, 0)
			self.showInviteWindowDelay:setEvent(self, function(self)
				WindowManager:showWindow(WindowTag.MessageBox, {
				text = "是否立即邀请好友?",
				leftText = "邀请",
				singleBtn = true,
				leftFunc = function()
					WindowManager:showWindow(WindowTag.inviteEntryPopu, data)
				end
				}, WindowStyle.NORMAL)
		end)
end

function RoomController:onShowInviteWindow()
	
end


-- 广播玩家进入 0x100D
function RoomController:onUserEnter(playerInfo, isReconn)
   	kEffectPlayer:play(Effects.AudioEnter);
	printInfo("玩家进入房间 座位号 %d", playerInfo.iSeatId);
	local seatId = playerInfo.iSeatId
	local localSeatId = G_RoomCfg:getLocalSeatId(seatId)  -- 获取到本地座位
	local player = self:_initPlayer(localSeatId)
	player:clearTableForGame()
	player:initPlayerInfo(playerInfo)
	player:onEnterRoom(playerInfo.iIsReady)


	-- 包间处理
	if 1 == G_RoomCfg:getIsCompart() then
		local seat = self:findChildByName("btn_invateSeat"..localSeatId)
		if seat then seat:hide() end

		local playCount = 0
		for seatId, _player in pairs(self.m_players) do
			if 1 ==  _player:getGameData():getIsExist() then
				playCount = playCount +1
			end
		end

		if PLAYER_COUNT == playCount then
			WindowManager:closeWindowByTag(WindowTag.MessageBox)
			WindowManager:closeWindowByTag(WindowTag.inviteEntryPopu)
		end 

		local historyCfg = G_RoomCfg:getHistoryScore()
		if SEAT_2 == localSeatId then
			historyCfg.seat2 = self.m_players[localSeatId]:getUserData():getNick()
		elseif SEAT_4 == localSeatId then
			historyCfg.seat4 = self.m_players[localSeatId]:getUserData():getNick()
		end
		if not historyCfg.historytab then historyCfg.historytab = {} end
		G_RoomCfg:setHistoryScore(historyCfg)

	end

end

-- 广播玩家准备 0x4001
function RoomController:onUserReady(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local _player = self.m_players[localSeatId]
	if not _player then return end
	-- printInfo("房间内玩家准备 userId = %d", data.iUserId);
	-- printInfo("房间内玩家准备 localSeatId = %d", localSeatId);
   	kEffectPlayer:play(Effects.AudioReady);
	_player:clearTableForGame()
	_player:onUserReady()
	if localSeatId == SEAT_1 then
		self:showReadyView()
		-- 关闭结算弹窗
		WindowManager:closeWindowByTag(WindowTag.GameOverWinPopu)
		WindowManager:closeWindowByTag(WindowTag.GameOverLosePopu)
		WindowManager:closeWindowByTag(WindowTag.GameOverDrawPopu)
		WindowManager:closeWindowByTag(WindowTag.GameOverDetailPopu)
	end
	-- test胡牌显示
	-- _player:drawHuCardsLiang({1, 33})

end

-- 玩家退出房间 0x1008
function RoomController:onUserExit(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local _player = self.m_players[localSeatId]

   	kEffectPlayer:play(Effects.AudioLeft);
	if localSeatId == SEAT_1 then
		StateChange.changeState(States.Lobby)
	elseif _player then
		_player:onUserExit()
	end

	if 1 == G_RoomCfg:getIsCompart()  then
		if G_RoomCfg:getIsMaster() then
			local seat = self:findChildByName("btn_invateSeat"..localSeatId)
			if seat then seat:show() end
		end

		local historyCfg = G_RoomCfg:getHistoryScore()
		if SEAT_2 == localSeatId then
			historyCfg.seat2 = ""
		elseif SEAT_4 == localSeatId then
			historyCfg.seat4 = ""
		end
	end

end

function RoomController:onLogoutRoomRsp(data)
	local msgTips = ""
	if 0 == data.iExitType then
		AlarmTip.play("房主已解散房间")
		StateChange.changeState(States.Lobby)
	else
        msgTip  = "长时间未准备，请重新选择房间。"
		local bundleData = {
	        type    = StateEvent.ReadyTimeout,
	        msgTip  = msgTips,
	        reLogin = false,
    	}
		StateChange.changeState(States.Lobby, bundleData)
	end
end

-- 广播房间等级 0x1112
function RoomController:onRoomInfoBd(data)
	printInfo("0x1112================================")
	-- UIFactory.createText({
	-- 	text = string.format("房间id = 0x%08x", data.iTableId),
	-- 	size = 36,
	-- 	align = kAlignCenter,
	-- 	color = c3b(0, 0, 0),
	-- })
	-- :addTo(self)
	-- :pos(display.left + 50, display.top + 50)

	-- 判断是否触发换场
	local preLevel = G_RoomCfg:getLevel()
	G_RoomCfg:setLevel(data.iLevel)
			:setObTime(data.iObTime)
			:setFanLeast(data.iFanLeast)
			:setGameType(data.iGameType)
			:setRoomName(data.iRoomName)

	if preLevel > 0 and preLevel ~= data.iLevel then
		G_RoomCfg:setPlayChanged(true)
	end

	if 1 == G_RoomCfg:getIsCompart() then
		G_RoomCfg:setRoomName("房间ID："..G_RoomCfg:getFid())
	end

	-- self.m_userData:setMoney(self.m_userData:getMoney())

	self:onFreshRoomInfo(data)
	-- 进入房间成功之后拉取信息
	-- 请求道具列表
	if not MyPropData:getConfigByLevel(data.iLevel) then
		GameSocketMgr:sendMsg(Command.PROP_PHP_REQUEST, {level = data.iLevel}, false)
	end
	GameSocketMgr:sendMsg(Command.ROOM_GAME_BOX_STATUS_REQUEST, {level = data.iLevel}, false)
	GameSocketMgr:sendMsg(Command.ROOM_GAME_ACTIVITY_STATUS_REQUEST, {level = G_RoomCfg:getLevel() , act = "open"}, false)

	-- 快速开始需要放在这里，因为换桌时候的快速开始需要在setLevel更新等级后调用
	-- 否则会使用上次的level, 这样在降场情况下会再走支付
	local isReady = self.mySelf:getGameData():getIsReady() == 1
	if G_RoomCfg:getIsQuickStart() and not isReady then
		printInfo("要快速开始")
		self:requestReady()
	-- 非快速开始
	elseif not G_RoomCfg:getIsQuickStart() then
		self:showReadyView()
	end
	G_RoomCfg:setIsQuickStart(false)
end

-- 玩牌相关
function RoomController:onGameReadyStartBd(data)
	self.m_timer:stop()
	G_RoomCfg:setEastSeat(data.iBankSeatId)
		:setBankSeat(data.iBankSeatId)
		:setIsPlaying(true)

	-- 设置东风位置
	local localBankSeatId = G_RoomCfg:getLocalBankSeat()
	self.m_timer:setSeatInfo(localBankSeatId)

	WindowManager:closeWindowByTag(WindowTag.MessageBox)
	WindowManager:closeWindowByTag(WindowTag.inviteEntryPopu)
end

-- 广播发牌 0x3001
function RoomController:onDealCardBd(data)
	-- 拉取牌局宝箱
	GameSocketMgr:sendMsg(Command.ROOM_GAME_BOX_STATUS_REQUEST, {level = G_RoomCfg:getLevel()}, false)
	self.m_timer:stop()
	if self.mSelectPiaoNode then
		self.mSelectPiaoNode:hide()
	end
	self:resetRemainCards()
	G_RoomCfg:setBankSeat(data.iBankSeatId)
		:setIsPlaying(true)

	local localBankSeatId = G_RoomCfg:getLocalBankSeat()
	for seat, p in pairs(self.m_players) do
		p:onGameReadyStart(seat == localBankSeatId)
	end
	-- 摇骰子
	-- 保证数据立即生效
	self.mySelf:setHandAndHuaCards(data.iHandCards, data.iBuhuaCards)
	local otherTemp = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	for seatId = SEAT_2, SEAT_4 do
		self.m_players[seatId]:setHandAndHuaCards(otherTemp, {})
	end
	kEffectPlayer:play(Effects.AudioTing)
	AnimManager:play(AnimationTag.AnimFade, {
		file = "kwx_room/game_start.png",
		pos = ccp(display.cx, display.cy),
		showBg = true,
		fadeTime = 300,
		fadeSize = 3,
		bgSize = 1.5,
		scaleTime = 200,
		delayTime = 200,
		onComplete = function()
			kEffectPlayer:play(Effects.AudioShaizi)
			AnimManager:play(AnimationTag.ShaiZi, {
				eastSeatId = G_RoomCfg:getEastSeat(),
				bankSeatId = G_RoomCfg:getBankSeat(),
				iSH_ShaiziNum1 = data.iSH_ShaiziNum1,
				iSH_ShaiziNum2 = data.iSH_ShaiziNum2,
				onComplete = function()
					-- 等待发牌
					self:playZhuangAnimFor(G_RoomCfg:getLocalBankSeat())

					self.mySelf:onDealCardBd(data.iHandCards, data.iBuhuaCards)
					for seatId=SEAT_2, SEAT_4 do
						self.m_players[seatId]:onDealCardBd(otherTemp, {})
					end
					local startSeatId = G_RoomCfg:getLocalBankSeat()
					local cardNum = {{1, 4}, {5, 8}, {9, 12}, {13, 13}}
					local turn, totalTurn = 1, 4
					local seatId = startSeatId
					-- 每300ms发一次牌
					self.dealCardAnim = self:schedule(function()
						if seatId == startSeatId and turn == 1 then
							self.m_timer:playWait(5, TimerClock.DealCard)
						end
						local numTb = cardNum[turn] or {}
						local startIndex = numTb[1] or 0
						local endIndex = numTb[2] or 0
						G_RoomCfg:reduceRemainNum(endIndex - startIndex + 1)

						self.m_players[seatId]:onDealCardStep(startIndex, endIndex)
						if seatId == SEAT_4 then
							seatId = SEAT_3
						end
						seatId = seatId % PLAYER_COUNT + 1
						if seatId == SEAT_3 then
							seatId = SEAT_4
						end

						if seatId == startSeatId then  -- 进入下一轮
							turn = turn + 1
							if turn == totalTurn + 1 then
								self:onDealCardOver(true) -- 正常结束
							end
						end
						if seatId == SEAT_1 then
							kEffectPlayer:play(Effects.AudioDealCard);
						end
					end, 120, 700)
				end,
			})
			:pos(display.cx + 55, display.cy)
		end
	})
end

function RoomController:onDealCardOver(isNormal)
	delete(self.dealCardAnim)
	self.dealCardAnim = nil
	for i,v in ipairs(self.m_players) do
		v:onDealCardOver(isNormal)
	end
end

-- 发牌后广播开始游戏 0x4003 -- 用于补花
function RoomController:onGameStartBd(data)
	if self.dealCardAnim then
		self:onDealCardOver(false)
	end
	-- 四个玩家的花牌数目
	local huaInfos = data.iHuaInfos
	for _, record in pairs(huaInfos) do
		local localSeatId = self:_converUserToSeat(record.iUserId)
		printInfo("localSeatId : %d", localSeatId)
		local _player = self.m_players[localSeatId]
		_player:onGameStartBd(record)
	end
end

-- 广播自己抓牌 0x3002
function RoomController:onOwnGrabCardBd(data)
	local iOpInfo = {
		iOpValue = data.iOpValue,
		iAnCards = data.iAnCards,
		iBuCards = data.iBuCards,
		iCanTing = data.iCanTing,
		iTingInfos = data.iTingInfos,
		iLiangInfo = data.iLiangInfo,
		iFanLeast = data.iFanLeast,
	}
	self.mySelf:hideOperatePanel()
	self.mySelf:onAddCard(data.iCard, data.iHuaCards)
	self.mySelf:dealOpAfterAddCard(data.iCard, iOpInfo)
	G_RoomCfg:setLastOutPlayer(nil)
	self:hideBigOutCard(true)
	-- 如果我有操作
	if self.mySelf:isOperating() then
		printInfo("G_RoomCfg:getOpTime() : %s", G_RoomCfg:getOpTime())
		self.m_timer:play(SEAT_1, G_RoomCfg:getOpTime(), TimerClock.Operate)
	else
		printInfo("G_RoomCfg:getOutTime() : %s", G_RoomCfg:getOutTime())
		self.m_timer:play(SEAT_1, G_RoomCfg:getOutTime(), TimerClock.OutCard)
		GuideManager:showGuideOutCard(true, self.mySelf)
	end
end

-- 广播玩家抓牌 0x4006
function RoomController:onOtherGrabCardBd(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local _player = self.m_players[localSeatId]
	if not _player then return end
	G_RoomCfg:setLastOutPlayer(nil)
	_player:onAddCard(data.iCard or 0, data.iHuaCards)
	self.mySelf:hideOperatePanel()
	self:hideBigOutCard(true)
	self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.Operate)
end

-- 广播出牌  0x4004
function RoomController:onOutCardBd(data)
	self.mySelf:hideOperatePanel()
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local _player = self.m_players[localSeatId]
	if not _player then return end
	G_RoomCfg:setLastOutPlayer(_player)

	-- 如果不是自己出牌 则根据出的牌更新听牌信息
	if localSeatId ~= SEAT_1 then
		self.mySelf:reduceCardForTingInfo(data.iCard)
	end
	_player:onOutCard(data.iCard, data.iIsTing, data.iIsAi)
	self:showBigOutCard(data.iCard, localSeatId)
	-- 显示我对其他玩家出牌的操作 碰杠等
	if localSeatId ~= SEAT_1 then
		local iOpInfo = {
			iOpValue = data.iOpValue,
			iAnCards = {},
			iBuCards = {},
			iCanTing = 0,
			iTingInfos = {},
			iFanLeast = data.iFanLeast,
		}
		self.mySelf:dealOpAfterOtherOutCard(data.iCard, iOpInfo)
	end
	-- 如果我有操作
	if self.mySelf:isOperating() then
		self.m_timer:play(SEAT_1, G_RoomCfg:getOpTime(), TimerClock.Operate)
	else
		self.m_timer:playWait(G_RoomCfg:getOpTime(), TimerClock.Operate)
	end
	if 1 == data.iIsLiang then
		if localSeatId == SEAT_1 then
			playPiaoAndLiangDaoSound(2, MyUserData:getSex())
		end
		_player:reDrawHandCardsLiang(data.iLiangCards)

		-- 只有上家和下家显示亮倒后的胡牌
		if SEAT_1 ~= localSeatId then 
			_player:drawHuCardsLiang(data.iHuCard)
		end
	end
end

-- 广播玩家操作 0x4005
function RoomController:onOperateCardBd(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local targetSeatId = G_RoomCfg:getLocalSeatId(data.iTargetSeatId)
	local _player = self.m_players[localSeatId]
	self.mySelf:hideOperatePanel()
	-- 根据操作玩家, 操作牌和具体操作来更新自己的听牌信息
	self.mySelf:reduceOperateCardForTingInfo(localSeatId, data.iCard, data.iOpValue)
	if _player then
		local iOpInfo = {
			iOpValue = data.iOpValue,
			iAnCards = {},
			iBuCards = {},
			iCanTing = 0,
			iLiangInfo = data.iLiangInfo,
			iFanLeast = data.iFanLeast,
		}
		_player:onOperateCard(data.iCard, iOpInfo)
		-- 处理操作之后的东西 听牌等
		if localSeatId == SEAT_1 then
			_player:dealOpAfterOwnOperate(data.iCard, iOpInfo)
		end
		-- 抢杠胡时 将玩家的补杠变成碰
		if bit.band(data.iOpValue, kOpePengGangHu) > 0 then
			for i, _player in ipairs(self.m_players) do
				_player:switchBuGangToPeng(data.iCard)
			end
		end

		local _targetPlayer = self.m_players[targetSeatId] or G_RoomCfg:getLastOutPlayer()
		local success = false
		if _targetPlayer then
			success = _targetPlayer:judgeRemoveOperateCard(data.iOpValue, data.iCard)
		end
		-- 容错 删除出的牌
		if not success then
			for i,v in ipairs(self.m_players) do
				v:judgeRemoveOperateCard(data.iOpValue, data.iCard)
			end
		end
	end

	if isHuOperate(data.iOpValue) and localSeatId == SEAT_1 then
		local HuAnim = require("animation/animationWinGame");
		new(HuAnim, self)
			:addTo(self)
			:play();
	end

	-- 如果我有操作 比如听牌
	if self.mySelf:isOperating() then
		self.m_timer:play(SEAT_1, G_RoomCfg:getOpTime(), TimerClock.Operate)
	else -- 出牌
		self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.OutCard)
	end
	self:hideBigOutCard()
	self:hideOutCardFinger()
end

-- 广播玩家操作取消 进入等待出牌状态
function RoomController:onOperateCancelBd(data)
	local userId = data.iUserId
	local localSeatId = self:_converUserToSeat(userId)
	local _player = self.m_players[localSeatId]
	if _player then
		self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.OutCard)
	end
end

-- 广播抢杠胡 0x3005
function RoomController:onQiangGangHuBd(data)
	local iOpInfo = {
		iOpValue = kOpePengGangHu,
		iAnCards = {},
		iBuCards = {},
		iCanTing = 0,
		iTingInfos = {},
		iFanLeast = data.iFanLeast,
	}
	self.mySelf:onQiangGangHuBd(data.iCard, iOpInfo)
	-- 如果我有操作
	if self.mySelf:isOperating() then
		self.m_timer:play(SEAT_1, G_RoomCfg:getOpTime(), TimerClock.Operate)
	end
end

-- 广播一局结束 0x4021
function RoomController:onStopRoundBd(data)
	printInfo("RoomController onStopRoundBd")
	self.m_timer:stop()
	self:hideBigOutCard()
	self:hideOutCardFinger()

	local overType = data.iResultType  -- 0流局，1自摸 2放炮

	G_RoomCfg:onGameOver(overType == 0)
	G_RoomCfg:setBankSeat(-1)

	local historyItem = {}
	local huType = data.iHuType or 0  -- 0 平 1 输 2 赢
	for k, info in pairs(data.iPlayerInfo) do
		local localSeatId = self:_converUserToSeat(info.iUserId)
		local _player = self.m_players[localSeatId]

		info.iLocalSeatId 	= localSeatId
		info.iName 		= _player:getUserData():getNick()
		info.iHeadImg 	= _player.m_userData:getHeadName()
		_player:onGameOver(info)

		-- 如果自己赢钱就掉金币
		if _player.m_seat == SEAT_1 and 1 ~= G_RoomCfg:getIsCompart() then
			if info.iTurnMoney >= 0 then
				MyUserData:addMoney(0, true)
			end
		end

		if SEAT_1 == localSeatId then
			historyItem.my = info.iTurnMoney
		elseif SEAT_2 == localSeatId then
			historyItem.play2 = info.iTurnMoney
		elseif SEAT_4 == localSeatId then
			historyItem.play4 = info.iTurnMoney
		end

	end

	if 1 == G_RoomCfg:getIsCompart() then
		-- 结算数据存储
		local historyCfg = G_RoomCfg:getHistoryScore()
		table.insert(historyCfg.historytab, historyItem)
		G_RoomCfg:setHistoryScore(historyCfg)
	end


	if 1 == data.iIsPrivate then
		for k, info in pairs(data.iPrivateRoom.iPlayInfo) do
			local localSeatId = self:_converUserToSeat(info.iUserId)
			local _player = self.m_players[localSeatId]

			info.iLocalSeatId 	= localSeatId
			info.iName 		= _player:getUserData():getNick()
			info.iSex 		= _player:getUserData():getSex()
			info.iHeadImg 	= _player.m_userData:getHeadName()
		end
	end

	local delay = 0
	-- 声音
	if huType == 0 then
		kEffectPlayer:play(Effects.AudioLiuju);
	elseif huType == 1 then
		kEffectPlayer:play(Effects.AudioLose)
	elseif huType == 2 then
		kEffectPlayer:play(Effects.AudioWin)
		delay = 1500
	end

	-- 流局动画
	self:performWithDelay(function()
		if overType == 0 then
			AtomAnimManager.getInstance():playAnim("atomAnimTable/resultless", {
			 	width = 280,
		 		height = 160,
		 		parent = self,
		 		level = 51,
			 	onComplete = function()
			 		--AlarmTip.play("开始结算")
			 	end
		 	})
		end
	end, delay)

	-- ADD根据交互 先隐藏掉准备面板，等动画完成后再显示
	self.mySelf:showReadyView(false)

	if self.showGameOverWindowDelay then
		delete(self.showGameOverWindowDelay)
		self.showGameOverWindowDelay = nil
	end

	if 1 == G_RoomCfg:getIsCompart() then
   		WindowManager:showWindow(WindowTag.GameOverDetailPopu, data)
		return
	end


	self.showGameOverWindowDelay = new(AnimInt, kAnimNormal, 0, 1, 3000, 0)
	self.showGameOverWindowDelay:setEvent(self, function(self)
		local isReady = (self.mySelf:getGameData():getIsReady() == 1)
		if isReady then
			return
		end
		if huType == 0 then
	 		WindowManager:showWindow(WindowTag.GameOverDrawPopu, data)
		elseif huType == 1 then
			WindowManager:showWindow(WindowTag.GameOverLosePopu, data)
		elseif huType == 2 then
			WindowManager:showWindow(WindowTag.GameOverWinPopu, data)
		end
		self.mySelf:showReadyView(true)
	end)
end

function RoomController:playLevelUpAnim()
	-- 升级动画
	local levelUpAnimNode = new(Node)
	levelUpAnimNode:setSize(700, 700)
	self:addChild(levelUpAnimNode)
	levelUpAnimNode:setAlign(kAlignCenter)
	FrameAnimManager:playAnim(FrameAnimManager.m_ctr.iLevelUpTwo, levelUpAnimNode)
	local xingXingPosAndSize = {
		{
			animPos = { startX = 250, startY = 250 , endX = 200, endY = 180 },
			animSize = { w = 0.7, h =0.7 },
			delay = 1000,
			time = 2500,
		},
		{
			animPos = { startX = 150, startY = 270 , endX = 100, endY = 260 },
			animSize = { w = 0.6, h =0.6 },
			delay = 1200,
			time = 2500,
		},
		{
			animPos = { startX = 150, startY = 300 , endX = 130, endY = 300 },
			animSize = { w = 0.75, h =0.75 },
			delay = 1000,
			time = 2500,
		},
		{
			animPos = { startX = 230, startY = 360 , endX = 200, endY = 400 },
			animSize = { w = 0.7, h =0.7 },
			delay = 1000,
			time = 2500,
		},
		{
			animPos = { startX = 420, startY = 370 , endX = 450, endY = 400 },
			animSize = { w = 0.5, h =0.5 },
			delay = 1000,
			time = 2500,
		},
		{
			animPos = { startX = 460, startY = 300 , endX = 500, endY = 300 },
			animSize = { w = 0.7, h =0.7 },
			delay = 1000,
			time = 2500,
		},
		{
			animPos = { startX = 460, startY = 260 , endX = 500, endY = 250 },
			animSize = { w = 0.4, h =0.4 },
			delay = 1000,
			time = 2500,
		},
		{
			animPos = { startX = 420, startY = 200 , endX = 460, endY = 160 },
			animSize = { w = 0.8, h =0.8 },
			delay = 1000,
			time = 2500,
		},
	}
	local animEnd = false
	for i = 1, #xingXingPosAndSize do
		local diffX, diffY = xingXingPosAndSize[i].animPos.endX - xingXingPosAndSize[i].animPos.startX,
								xingXingPosAndSize[i].animPos.endY - xingXingPosAndSize[i].animPos.startY
		local xingxing = UIFactory.createImage("kwx_anim/levelUp/img_xingxing.png")
		xingxing:setPos(xingXingPosAndSize[i].animPos.startX, xingXingPosAndSize[i].animPos.startY)
		local xw, xh = xingxing:getSize()
		xingxing:setSize(xw * xingXingPosAndSize[i].animSize.w, xh * xingXingPosAndSize[i].animSize.h)
		levelUpAnimNode:addChild(xingxing)
		xingxing:hide()
		local delay = xingXingPosAndSize[i].delay
		local time = xingXingPosAndSize[i].time
		local transAnim = xingxing:addPropTransparency(0, kAnimNormal, delay, -1, 1.1, 1.1)
		transAnim:setEvent(self, function(self)
			xingxing:removeProp(0)
			xingxing:show()
			local tAnim = xingxing:addPropTranslate(0, kAnimNormal, time, -1, 0, diffX, 0, diffY)
			xingxing:addPropTransparency(1, kAnimNormal, time, -1, 1.0, 0.9)
			-- addPropRotate = function(self, sequence, animType, duration, delay, startValue, endValue, center, x, y)
			xingxing:addPropRotate(2, kAnimRepeat, 1800, -1, 0, -360, kCenterDrawing)
			if not animEnd then
				tAnim:setEvent(self, function( self )
					self:removeChild(levelUpAnimNode, true)
				end)
			end
		end)
	end
	AnimationParticles.play(AnimationParticles.DropCoin)
	FrameAnimManager:playAnim(FrameAnimManager.m_ctr.iLevelUp, levelUpAnimNode)
end

-- 广播游戏结束 0x4009
function RoomController:onStopGameBd(data)
	self.m_timer:stop()
	self:hideBigOutCard()
end

-- 聊天相关 0x1003
function RoomController:onUserChat(data)
	local chatInfo = data.iChatInfo
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local _player = self.m_players[localSeatId]
	if _player then
		printInfo("座位为%d的玩家说了一句话%s", localSeatId, chatInfo)
		G_RoomCfg:addChatRecord(_player:getUserData():getNick(), chatInfo)
		_player:showChatWord(chatInfo)
	end
end

-- 聊天相关 表情相关 0x1004
function RoomController:onUserFace(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local faceType = data.iFaceType
	local _player = self.m_players[localSeatId]
	if _player then
		_player:showChatFace(faceType)
	end
end

-- 道具相关 0x2030
function RoomController:onUserProp(data)
	if not data or data.flag == 0 then
		AlarmTip.play(data.msg or "网络繁忙，请稍候再试。")
		return
	end
	dump(data)
	local sendmid = data.mid;				--发送玩家mid
	local changeMoney = data.changeMoney or 0;	--使用道具消耗的金币数
	--更新金币
	for i, player in ipairs(self.m_players) do
		local userData = player:getUserData()
		if userData:getId() == sendmid then
			userData:addMoney(-changeMoney)
		end
	end
	-- 播放动画
	for k, v in pairs(data.data) do
		local tagmid =  v.tagmid or -1     --接收玩家mid
		if not tagmid or tagmid==-1 then
			return
		end
		local propId = v.pid		 --道具id
		local tagmid = v.tagmid  --debug

		local sendSeatId = self:_converUserToSeat(sendmid)
		local sendPlayer = self.m_players[sendSeatId]

		local targetSeatId = self:_converUserToSeat(tagmid)
		local targetPlayer = self.m_players[targetSeatId]

		sendPlayer:sendPropToPlayer(propId, targetPlayer)
	end
end

-- 玩家托管
function RoomController:onUserAiBd(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local _player = self.m_players[localSeatId]
	-- 我自己托管时 播放音效
	if localSeatId == 1 and data.iAiType == 1 then
		kEffectPlayer:play(Effects.AudioTwoGuan);
	end
	if _player then _player:onUserAi(data.iAiType) end
end

-- 玩家重连成功 0x1111
function RoomController:onReconnSuccess(data)
	if self.dealCardAnim then
		delete(self.dealCardAnim)
		self.dealCardAnim = nil
	end
	AnimManager:removeAnimByTag(AnimManager.AnimFade)
	AnimManager:removeAnimByTag(AnimManager.ShaiZi)

	--开设包间进
	if 1 == data.iPrivateFlag then
		G_RoomCfg:setIsCompart(1)
		G_RoomCfg:setFid(data.iExterConfig.iFid)
		G_RoomCfg:setRoundNum(data.iExterConfig.iRoundNum)
		G_RoomCfg:setCurRound(data.iExterConfig.iCurJu)

		if MyUserData:getId() == data.iExterConfig.iUid then
			G_RoomCfg:setIsMaster(true)
		end
		self:initPrivateRoomView(true)

		local historyCfg = G_RoomCfg:getHistoryScore()
		historyCfg.historytab = {}
		local myScore = {}
		for i=1, data.iExterConfig.iCurJu - 1 do
			local temp = {}
			temp.my = data.iExterConfig.iPlayInfo[1].iScoreTab[i]
			temp.play2 = data.iExterConfig.iPlayInfo[2].iScoreTab[i]
			temp.play4 = data.iExterConfig.iPlayInfo[3].iScoreTab[i]
			table.insert(historyCfg.historytab, temp)
		end
		G_RoomCfg:setHistoryScore(historyCfg)

	end

	-- 清除桌面
	self:resetGameTable()
	-- 拉取牌局宝箱
	GameSocketMgr:sendMsg(Command.ROOM_GAME_BOX_STATUS_REQUEST, {level = G_RoomCfg:getLevel()}, false)

	-- 重新初始化玩家
	self:_removeAllPlayers()
	self:_initAllPlayers()

	-- 初始化房间配置  并 同步金币
	G_RoomCfg:initInfo(data.iConfig, data.iMySeatId)
		:setEastSeat(data.iEastSeatId)
		:setBankSeat(data.iBankSeatId)
		

	self.m_timer:setSeatInfo(G_RoomCfg:getLocalSeatId(data.iEastSeatId))

	-- FIX 重连后出牌和箭头不知道是哪家，干脆隐藏
	self:hideBigOutCard()
	self:hideOutCardFinger()


	local player = self:_initPlayer(SEAT_1)
	-- 兼容server快速开始 以及客户端快速开始显示问题， 同时兼容server进房间未携带准备状态的问题
	player:getGameData():setIsReady(1)
	player:onEnterRoom(1)

	-- 关闭结算弹窗
	WindowManager:closeWindowByTag(WindowTag.GameOverWinPopu)
	WindowManager:closeWindowByTag(WindowTag.GameOverLosePopu)
	WindowManager:closeWindowByTag(WindowTag.GameOverDrawPopu)
	WindowManager:closeWindowByTag(WindowTag.GameOverDetailPopu)

	MyUserData:setSeatId(data.iMySeatId)
	-- 这里需要放在onEnterRoom之后 保证刷新界面
	-- MyUserData:setMoney(data.iMyMoney)
	if 1 == G_RoomCfg:getIsCompart() then 
        MyUserData:setScore(data.iMyMoney)
	else 
        MyUserData:setMoney(data.iMyMoney)	
    end   
	MyUserData:refreshInfo()


	local timerTb = {
		[SEAT_1] = #data.iMyHandCardTb
	}
	-- 其他玩家
	local players = data.iOtherPlayers
	for i, playerInfo in ipairs(players) do
		self:onUserEnter(playerInfo, true)
		-- 模拟其他玩家的手牌
		local localSeatId = self:_converUserToSeat(playerInfo.iUserId)
		printInfo("重连玩家座位号%d", localSeatId)
		local _player = self.m_players[localSeatId]
		if _player then
			_player:reconnTable(playerInfo.iHandCardTb, playerInfo.iExtraCards, playerInfo.iIsLiang, playerInfo.iCatchCard)
			_player:freshUserTingInfo(0, playerInfo.iIsTing, true)  -- true 表示重连的听牌信息
			timerTb[localSeatId] = playerInfo.iHandCount
			if 1 == data.iIsSelectPiao then
				_player:showSelectPiao(playerInfo.iPiao)
			end

			if SEAT_1 ~= localSeatId then 
				_player:drawHuCardsLiang(playerInfo.iHuCard)
			end
		end
	end
	
	-- 人手不够开牌处理
	if PLAYER_COUNT - 1  <= data.iPlayerCount then
			-- 重绘我的牌
		player:reconnTable(data.iMyHandCardTb, data.iMyExtraCards, data.iIsLiang, data.iCatchCard)
		player:freshUserTingInfo(0, data.iIsTing, true) -- true 表示重连的听牌信息

		G_RoomCfg:setIsPlaying(true)

		G_RoomCfg:setRemainNum(data.iRemainCount)

		-- 显示漂
		if 1 == data.iIsSelectPiao then
			player:showSelectPiao(data.iPiao)
		end
		-- 显示庄家
		self:playZhuangAnimFor(G_RoomCfg:getLocalBankSeat(), true)

		-- 听牌时发送托管
		self:requestAi(data.iIsTing == 1 and 0 or 1)

		-- 根据玩家的手牌数目 来确定时间显示
		self.m_timer:playWait(G_RoomCfg:getOpTime(), TimerClock.Operate)
	end

	for localSeatId, count in ipairs(timerTb) do
		if count % 3 == 2 then  --如果有玩家是需要出牌的牌型  332
			self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.OutCard)
			break
		elseif count == #timerTb then  --没有玩家是出牌的牌型 332则表示等待某玩家操作
			self.m_timer:playWait(G_RoomCfg:getOpTime(), TimerClock.Operate)
		end
	end

	--
	AlarmTip.play("重连成功")
end

--0x3012  --服务器通知开始换牌
function RoomController:onSwapCardStartBd(data)
	-- 计时器显示等待换牌
	local timeTb = {
		[GameType.GBMJ] = 9 * 1000,
		[GameType.KWXMJ] = 6 * 1000,
		[GameType.SHMJ] = 9 * 1000,
	}
	self:performWithDelay(function()
		if self.dealCardAnim then
			self:onDealCardOver(false)
		end
		self.m_timer:playWait(data.iHuanTime - 1, TimerClock.SwapCard)
		self.mySelf:onSwapCardStartBd(data)
	end, timeTb[G_RoomCfg:getGameType()] or 6 * 1000)
end

--0x3013  --换牌返回
function RoomController:onSwapCardRsp(data)
	self.m_timer:playWait(G_RoomCfg:getOpTime(), TimerClock.Operate)
	self.mySelf:onSwapCardRsp(data.iHandCards, data.iExchangeCards)
end

--0x6400  --公共业务
function RoomController:onFreshMoneyRsp(data)
	if data.iRect == 0 and data.iUserId ~= MyUserData:getMoney() then
		local _player = self:_converUserToSeat(data.iUserId)
		if _player then
			_player:onFreshMoneyRsp(data)
		end
	end
end

--0x2023 --金币变动返回
function RoomController:onNoticeMoneyChangeRsp(data)
	local userInfoJsons = data.iUserInfoJsons
	for i,v in ipairs(userInfoJsons) do
		local json = json.decode(v)
		if json then
			local userId = json.UID
			-- local vip = json.VIP
			local localSeatId = self:_converUserToSeat(userId)
			local _player = self.m_players[localSeatId]
			if _player then
				local money = json.MONEY or _player:getUserData():getMoney()
				if 1 == G_RoomCfg:getIsCompart() then _player:getUserData():setScore(money)
				else _player:getUserData():setMoney(money)	end 
				-- _player:getUserData():setMoney(money)
			end
		end
	end
end

-- 请求准备的时候 重置桌子
function RoomController:clearTableForGame()
	G_RoomCfg:setRemainNum(-1)  --隐藏
	G_RoomCfg:setJu(-1)
	if self.m_zhuangIcon then
		self.m_zhuangIcon:hide()
	end
	self:hideBigOutCard()
	self:hideOutCardFinger()
	self.m_timer:stop()
	if self.mSelectPiaoNode then
		self.mSelectPiaoNode:hide()
	end
end

-------------- socket发出请求 --------------------
function RoomController:resetGameTable()
	for i,v in ipairs(self.m_players) do
		v:clearTableForGame()
	end
	self:clearTableForGame()
end

function RoomController:requestReady()
	self:resetGameTable()
	app:requestRoomReady()
end

function RoomController:showReadyView()
	if self.mySelf then
		self.mySelf:showReadyView(not G_RoomCfg:getIsPlaying())
	end
end

function RoomController:requestChangeDesk(type)
	if self:isPlaying() then
		AlarmTip.play("请在游戏结束后进行")
		return
	end
	self:resetGameTable()
	app:requestChangeDesk(type)
end

-- 房间内触发重连
function RoomController:requestReconn()
	printInfo("房间内触发重连")
	self.mySelf:getGameData():setIsReady(0)
	G_RoomCfg:setIsQuickStart(false)
end

function RoomController:requestSendFace(faceType)
	if not faceType then return end
	GameSocketMgr:sendMsg(Command.SendFace, {
		iFaceType = faceType,
	})
end

function RoomController:requestSendWord(chatInfo)
	if not chatInfo then return end
	GameSocketMgr:sendMsg(Command.SendChat, {
		iChatInfo = chatInfo,
	})
end

function RoomController:requestAi(aiType)
	GameSocketMgr:sendMsg(Command.RequestAi, {
		iAiType = aiType,
	})
end

-----------------------  [[ private 方法]] ------------------------------


--------------	view func --------------------
function RoomController:onBgTouch(...)
	repeat
		local myPlayer = self.m_players[SEAT_1]
		if myPlayer and myPlayer:onTouch(...) then
			break
		end
	until true
end

function RoomController:_initPlayer(localSeatId)
	assert(localSeatId >= SEAT_1 and localSeatId <= SEAT_4, "座位ID必须为1~4")
	local player = self.m_players[localSeatId]
	if not player then
		printInfo("gameType = %s", G_RoomCfg:getGameType())
		local playerCls = GamePlayerMap[G_RoomCfg:getGameType()]
		player = new(require(playerCls), localSeatId)
			:addTo(self, RoomCoord.PlayerLevels[localSeatId])
		self.m_players[localSeatId] = player
	end
	return player
end

function RoomController:_initAllPlayers()
	self.m_players = self.m_players or {}
	-- 创建玩家
	for i = SEAT_1, SEAT_4 do
		self:_initPlayer(i)
	end
	self.mySelf = self.m_players[SEAT_1]
end

function RoomController:_removeAllPlayers()
	for i,v in ipairs(self.m_players) do
		v:removeSelf()
	end
	self.m_players = {}
end

function RoomController:isPlaying()
	return self.mySelf and self.mySelf:isPlaying()
end

function RoomController:_converUserToSeat(userId)
	for localSeatId, v in pairs(self.m_players) do
		if v:getUserData():getId() == userId then
			return localSeatId
		end
	end
	-- return SEAT_1
end

function RoomController:adapterGameView()
	local timerView = self:getControl(self.m_ctrl.timerView)
	if not self.m_timer then
		self.m_timer = new(TimerClock)
			:addTo(timerView)
			:setRoomRef(self)
	end
end

function RoomController:onCancelOperate()
	self:onTimerClockOver(TimerClock.Operate)
end

function RoomController:onSelectTing()
	self.m_timer:play(SEAT_1, G_RoomCfg:getOutTime(), TimerClock.TimeOut)
end

function RoomController:onSelectLiang()
	-- self.m_timer:play(SEAT_1, G_RoomCfg:getOutTime(), TimerClock.TimeOut)
end

function RoomController:onTimerClockEnd()
	if self.mySelf then
		self.mySelf:onTimerClockOver()
	end
end

function RoomController:onTimerClockOver(type, localSeatId)
	if self.mySelf then
		self.mySelf:onTimerClockOver()
	end
	local checkOutCardSeat = function()
		for seatId,player in ipairs(self.m_players) do
			local handCards = player:getHandCards()
			if #handCards % 3 == 2 then
				return seatId
			end
		end
		return 0
	end
	local outCardSeatId = checkOutCardSeat()
	if type == TimerClock.Operate then
		-- 如果操作超时了 并且玩家牌型为332 则开启出牌计时器
		if outCardSeatId ~= 0 then
			self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.OutCard)
			if localSeatId == SEAT_1 then
				GuideManager:showGuideOutCard(true, self.mySelf)
			end
		elseif localSeatId ~= 0 then
			self.m_timer:playWait(G_RoomCfg:getOutTime(), TimerClock.TimeOut)
		else
			-- 等待server驱动 或者 客户端做网络异常提示
		end
	elseif type == TimerClock.OutCard then
		-- 等待server驱动 或者 客户端做网络异常提示
		printInfo("等待server驱动 或者 客户端做网络异常提示")
		self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.TimeOut)
	elseif type == TimerClock.TimeOut then
		AlarmTip.play("您的网络状况不好")
		self.m_timer:play(localSeatId, G_RoomCfg:getOutTime(), TimerClock.TimeOutEnd)
	elseif type == TimerClock.TimeOutEnd then
		AlarmTip.play("网络中断")
		self.mySelf:getGameData():setIsPlaying(0)
		self:onBack()
	elseif type == TimerClock.Observer then
		self.m_timer:playWait(G_RoomCfg:getObTime(), TimerClock.TimeOut)
	elseif type == TimerClock.SwapCard then
		self.m_timer:playWait(G_RoomCfg:getOutTime(), TimerClock.TimeOut)
	elseif type == TimerClock.DealCard then
		self.m_timer:playWait(G_RoomCfg:getOutTime(), TimerClock.TimeOut)
	end
end

--TODO 是不是由server给 设置剩余张
function RoomController:resetRemainCards()

end

function RoomController:freshJuType()
	-- 设定风局
	local eastSeat = G_RoomCfg:getEastSeat()
	local bankSeat = G_RoomCfg:getBankSeat()
	G_RoomCfg:setJu((bankSeat - eastSeat + 4) % 4)
	dump(G_RoomCfg:getFengju())
end

function RoomController:deduceRemainCard(num)

end

function RoomController:showBigOutCard(cardValue, localSeatId)
	local extraCardImgFileReg 	= CardPanelCoord.extraCardImage[SEAT_1]
	if not self.m_bigOutCardBg then
		local extraCardBgFile 		= CardPanelCoord.extraCardBg[SEAT_1]
		self.m_bigOutCardBg = UIFactory.createImage("kwx_room/out_bg.png")
			:addTo(self, RoomCoord.BigOutCardLayer)

		local width, height = self.m_bigOutCardBg:getSize()
		self.m_bigOutCardBg:setSize(width*0.8, height*0.9)

		self.m_bigOutCard = new(Card, cardValue, extraCardBgFile, extraCardImgFileReg)
			:setBgAlign(kAlignCenter)
			:shiftCardMove(0, -15)
			:addTo(self.m_bigOutCardBg)
			:align(kAlignCenter, 0, 5)
	else
		self.m_bigOutCardBg:show()
		checkAndRemoveOneProp(self.m_bigOutCardBg, 1002)
		self.m_bigOutCard:resetImageByValueAndType(cardValue, extraCardImgFileReg)
	end
	self.m_bigOutCard:scaleCardTo(0.8, 0.8)
	local bigOutCardPos = CardPanelCoord.bigOutCardPos[localSeatId]
	local width, height = self.m_bigOutCardBg:getSize()
	self.m_bigOutCardBg:pos(bigOutCardPos.x - width/2, bigOutCardPos.y - height/2)
end

function RoomController:showOutCardFinger(pos)
	if not self.m_outCardFinger then
		self.m_outCardFinger = UIFactory.createImage("kwx_room/finger.png")
			:addTo(self.mySelf or self, RoomCoord.OutCardFingerLayer)
		self.m_outCardFinger:addPropTranslate(121, kAnimLoop, 500, 0, 0, 0, 0, -10)
	else
		self.m_outCardFinger:setVisible(G_RoomCfg:getIsPlaying())
	end
	self.m_outCardFinger:pos(pos.x, pos.y)
end

-- 站起的牌提示
function RoomController:showCardUpTip(value)
	for i, _player in ipairs(self.m_players) do
		_player:showCardUpTip(value)
	end
end

function RoomController:hideOutCardFinger()
	if self.m_outCardFinger then
		self.m_outCardFinger:hide()
	end
end

function RoomController:hideBigOutCard(animFlag)
	if self.m_bigOutCardBg then
		if animFlag then
			checkAndRemoveOneProp(self.m_bigOutCardBg, 1002)
			self.m_bigOutCardBg:addPropTransparency(1002, kAnimNormal, 100, 1000, 1.0, 0.0)
		else
			self.m_bigOutCardBg:hide()
		end
	end
end

-- 播放玩家的庄家动画
function RoomController:playZhuangAnimFor(localSeat, isReconn)
	local _player = self.m_players[localSeat]
	if not _player then return end
	if not self.m_zhuangIcon then
		self.m_zhuangIcon = UIFactory.createImage("kwx_room/img_zhuang.png")
			:addTo(self, RoomCoord.IconLayer)
		UIEx.bind(self.m_zhuangIcon, G_RoomCfg, "isPlaying", function(value)
			if not value then
				self.m_zhuangIcon:setVisible(value)
			end
		end)
	else
		self.m_zhuangIcon:removeProp(122)
		self.m_zhuangIcon:show()
		self.m_zhuangIcon:setLevel(RoomCoord.IconLayer)
	end
	local zhuangIconPos = _player:getZhuangPos() or ccp(0, 0)
	self.m_zhuangIcon:pos(zhuangIconPos.x, zhuangIconPos.y)
	if isReconn then return end
	local width, height = self.m_zhuangIcon:getSize()
	local diffX = display.cx - zhuangIconPos.x - width / 2
	local diffY = display.cy - zhuangIconPos.y - height / 2
	local anim = self.m_zhuangIcon:addPropTranslateEase(122, kAnimNormal, ResDoubleArraySinOut, 500, 0, diffX, 0, diffY, 0)
	if anim then
   		anim:setDebugName("RoomController | RoomController.m_zhuangIcon");
		anim:setEvent(nil, function()
			self.m_zhuangIcon:removeProp(122)
			AnimManager:play(AnimationTag.AnimFade, {
				node = self.m_zhuangIcon,
				fadeSize = 3.0,
				fadeTime = 200,
			})
		end)
	end
end

function RoomController:onDoneSelectPiao(data)
	data = data or 0
	GameSocketMgr:sendMsg(Command.CLIENT_COMMAND_PIAO, {iPiao = data})
	GuideManager:showGuideSelectPiao(false)
end

function RoomController:onFreshRoomInfo(data)
	local roomInfoView = self:getControl(self.m_ctrl.roomInfoView)
	dump(data, "房间信息")
end

function RoomController:serverBroadcastBankrupt(data)
	-- ToDo  广播破产之后
end

function RoomController:onServerStartSelectPiao(data)
	-- ToDo  广播玩家开始选漂
	self:showSelectPiaoView(data.iSelectTable)
    self.m_timer:play(SEAT_1, data.iSelectTime or 0, TimerClock.SelectPiao)
end

function RoomController:showSelectPiaoView(data)
	if not self.mSelectPiaoNode then
		self.mSelectPiaoNode = new(Node)
		self.mSelectPiaoNode:setAlign(kAlignBottom)
		self.mSelectPiaoNode:setPos(0, 260)
		self.mSelectPiaoNode:setFillParent(true, false)
		self.m_root:addChild(self.mSelectPiaoNode)
	end
	self.mSelectPiaoNode:removeAllChildren()
	self.mSelectPiaoNode:show()
	for i = 1, #data do
		local fileName = (data[i] <= 0 and "kwx_common/btn_blue_big.png" or "kwx_common/btn_red_big.png")
		local btn_temp = UIFactory.createButton(fileName)
		local w, h = btn_temp:getSize()
		local jianGe = 40
		local total = #data * w + (#data - 1) * jianGe
		btn_temp:setPos(-total/2 + (i - 1) * (w + jianGe) + w / 2, 0)
		btn_temp:setAlign(kAlignTop)
		self.mSelectPiaoNode:addChild(btn_temp)
		local params = {}
		params.size = 36
		params.text = (data[i] <= 0 and "不 漂" or "漂"..data[i])
		UIFactory.createText(params):align(kAlignCenter):addTo(btn_temp)
		btn_temp:setOnClick(self, function(self)
			self:onDoneSelectPiao(data[i])
			self.mSelectPiaoNode:hide()
		end)
		if i == #data then
			GuideManager:showGuideSelectPiao(true, btn_temp)
		end
	end
end

function RoomController:onServerBroadcastSelectPiao(data)
	-- ToDo  广播玩家选定漂之后
	printInfo("onServerBroadcastSelectPiao")
	local seatId = self:_converUserToSeat(data.iUserId)
	local player = self.m_players[seatId]
	if player then
		player:showSelectPiao(data.iPiao)
		if player.m_seat == SEAT_1 then
			playPiaoAndLiangDaoSound(1, MyUserData:getSex())
			if self.mSelectPiaoNode then
				self.mSelectPiaoNode:hide()
			end
		end
	end
end

function RoomController:onServerBroadcastGameStart(data)
	-- ToDo 广播游戏开始
	printInfo("RoomController:onServerBroadcastGameStart")
	G_RoomCfg:setIsPlaying(true)
	self.mySelf.m_gameData:setIsPlaying(1)

	if 1 == G_RoomCfg:getIsCompart() then
		if G_RoomCfg:getIsSendExitReq() then
			AlarmTip.play("其他玩家未全部同意，退出失败")
		end
		G_RoomCfg:setIsSendExitReq(false)

		G_RoomCfg:setCurRound(data.iCurRound)
	end
end

function RoomController:onServerKickOut(data)
	StateChange.changeState(States.Lobby)
end

function RoomController:onServerShowReadyTime(data)
	self.mySelf:onServerShowReadyTime(data)
end

function RoomController:onServerUpdateUserInfo(data)
	local userInfoJsons = data.iUserInfo
	local userInfo = json.decode(userInfoJsons)
	if userInfo then
		local userId = data.iUserId
		local localSeatId = self:_converUserToSeat(userId)
		local _player = self.m_players[localSeatId]
		if _player then
			_player:getUserData():updateUserInfo(userInfo)
		end
	end
end

function RoomController:onRoomGameBoxStatusResponse(data)
	if 1 ~= data.status or not data.data then
		return
	end
	data = data.data
	local btn_chest = self.m_root:findChildByName("btn_chest")
	local text_number = self.m_root:findChildByName("text_number")
	local open = tonumber(data.open) or 0
	local award = tonumber(data.award) or 0
	local boxtype = tonumber(data.boxtype) or 0
	local process = tonumber(data.process) or 0
	local need = tonumber(data.need) or 0
	if 1 == open and not ShieldData:getAllFlag() then		-- 宝箱里也有话费券，所以也要屏蔽，好蛋疼
		btn_chest:show()
		if 1 == award then
			local fileName = string.format("kwx_room/gamebox/btn_box_%s_2.png", (1 == boxtype) and "gold" or "silver")
			btn_chest:setFile(fileName)
		else
			local fileName = string.format("kwx_room/gamebox/btn_box_%s_1.png", (1 == boxtype) and "gold" or "silver")
			btn_chest:setFile(fileName)
		end
		text_number:setText(string.format("玩牌：%d/%d", process, need))
	else
		btn_chest:hide()
	end
	btn_chest:setOnClick(self, function(self)
		-- 请求详细数据
		GameSocketMgr:sendMsg(Command.ROOM_GAME_BOX_DETAIL_REQUEST, {level = G_RoomCfg:getLevel()}, false)
	end)
end

function RoomController:onRoomGameBoxDetailResponse(data)
	printInfo("RoomController.onRoomGameBoxDetailResponse")
	if 1 ~= data.status or not data.data then
		return
	end
	self:onRoomGameBoxStatusResponse(data)
	-- TODO 显示选择界面
	WindowManager:showWindow(WindowTag.GameBoxPopu, data.data)
end

function RoomController:onRoomGameBoxAwardResponse(data)
	printInfo("RoomController.onRoomGameBoxAwardResponse")
	if 1 ~= data.status or not data.data then
		return
	end
    if 1 == data.data.status then
    	MyUserData:addMoney(data.data.money or 0, true)
		MyUserData:setHuaFei(data.data.coupons or 0)
        AlarmTip.play(data.data.msg or "领取成功");
        self:onRoomGameBoxStatusResponse(data)
        GameSocketMgr:sendMsg(Command.NoticeMoneyChangeReq, { iUserId = MyUserData:getId() })
    else
		AlarmTip.play(data.data.msg or "领取失败")
    end
end

function RoomController:onRoomGameActivityStatusResponse(data)
	printInfo("RoomController.onRoomGameActivityStatusResponse")
	if 1 ~= data.status or not data.data then
		return
	end
	data = data.data
	local view_giveCoin = self.m_root:findChildByName("view_giveCoin")
	local btn_giveCoin = self.m_root:findChildByName("btn_giveCoin")
	local img_giveLight = self.m_root:findChildByName("img_giveLight")
	local open = tonumber(data.open) or 0
	printInfo("data.open : %d", open)
	local award = tonumber(data.award) or 0
	if 1 == open then
		-- 给赠送金币加上转光的特效
		checkAndRemoveOneProp(img_giveLight, 0)
		img_giveLight:addPropRotate(0, kAnimRepeat, 6000, -1, 0, -360, kCenterDrawing)
		view_giveCoin:show()
		if 1 == award then
			checkAndRemoveOneProp(view_giveCoin, 0)
			view_giveCoin:addPropTranslate(0, kAnimLoop, 500, -1, 0, 0, 0, -14)
		end
	else
		checkAndRemoveOneProp(img_giveLight, 0)
		checkAndRemoveOneProp(view_giveCoin, 0)
		view_giveCoin:hide()
	end
	btn_giveCoin:setOnClick(self, function(self)
		-- 请求详细数据
		GameSocketMgr:sendMsg(Command.ROOM_GAME_ACTIVITY_DETAIL_REQUEST, {level = G_RoomCfg:getLevel(), act = "detail"}, false)
	end)
end

function RoomController:onRoomGameActivityDetailResponse(data)
	printInfo("RoomController.onRoomGameActivityDetailResponse")
	if 1 ~= data.status or not data.data then
		return
	end
	WindowManager:showWindow(WindowTag.GiveCoinPopu, data.data)
end

function RoomController:onRoomGameActivityAwardResponse(data)
	printInfo("RoomController.onRoomGameActivityAwardResponse")
	if 1 ~= data.status or not data.data then
		return
	end
	data = data.data
	local status = data.status or 0
	local view_giveCoin = self.m_root:findChildByName("view_giveCoin")
	local img_giveLight = self.m_root:findChildByName("img_giveLight")
	if 1 == status then
		AlarmTip.play(data.msg or "领取成功")
		local money = data.data.money or 0
		MyUserData:addMoney(money , true)
		checkAndRemoveOneProp(img_giveLight, 0)
		checkAndRemoveOneProp(view_giveCoin, 0)
		view_giveCoin:hide()
		GameSocketMgr:sendMsg(Command.NoticeMoneyChangeReq, { iUserId = MyUserData:getId() })
	else
		checkAndRemoveOneProp(view_giveCoin, 0)
		AlarmTip.play(data.msg or "领取失败")
	end
end

function RoomController:onPHPRequestsCallBack(command, ...)
	if self.s_severCmdEventFuncMap[command] then
     	self.s_severCmdEventFuncMap[command](self,...)
	end
end

function RoomController:handlerPlayerExit( playid, state )
	GameSocketMgr:sendMsg(Command.SERVER_EXIT_PRIVATEROOM_HANDLER_REQ, { 
						iUserId = MyUserData:getId(), 
						iOpUid = playid,
						iOpt = state
	})
end

function RoomController:onExitPrivateRoomReq( data )

	local localSeatId = self:_converUserToSeat(data.iExitUid)
	local _player = self.m_players[localSeatId]
	local nick 		= _player:getUserData():getNick()
		
	WindowManager:showWindow(WindowTag.MessageBox, {
				text = "是否同意"..nick.."退出游戏？",
				leftText = "拒绝",
				rightText = "同意",
				leftFunc = function()
					self:handlerPlayerExit(data.iExitUid, 0)
				end,
				rightFunc = function()
					self:handlerPlayerExit(data.iExitUid, 1) 
				end
				
	}, WindowStyle.NORMAL)
end

function RoomController:onBroadcastStopBattle( data )
	-- 总结算
	for k, info in pairs(data.iPrivateRoom.iPlayInfo) do
		local localSeatId = self:_converUserToSeat(info.iUserId)
		local _player = self.m_players[localSeatId]

		info.iLocalSeatId 	= localSeatId
		info.iName 		= _player:getUserData():getNick()
		info.iSex 		= _player:getUserData():getSex()
		info.iHeadImg 	= _player.m_userData:getHeadName()
	end

	local accountCfg = {}
	for k, info in pairs(data.iPrivateRoom.iPlayInfo) do
		local temp = {}
		temp.mid = info.iUserId
		temp.money = info.iScore
		temp.nick = info.iName
		temp.sex = info.iSex
		temp.headImg = info.iHeadImg
		temp.url = ""
		table.insert(accountCfg, temp)
	end				
	WindowManager:closeWindowByTag(WindowTag.GameOverWinPopu)
	WindowManager:closeWindowByTag(WindowTag.GameOverLosePopu)
	WindowManager:closeWindowByTag(WindowTag.GameOverDrawPopu)
	WindowManager:closeWindowByTag(WindowTag.GameOverDetailPopu)

	WindowManager:showWindow(WindowTag.accountsPopu, accountCfg)
end

RoomController.s_severCmdEventFuncMap = {
	[Command.ROOM_GAME_BOX_STATUS_REQUEST]		= RoomController.onRoomGameBoxStatusResponse,
	[Command.ROOM_GAME_BOX_DETAIL_REQUEST]		= RoomController.onRoomGameBoxDetailResponse,
    [Command.ROOM_GAME_BOX_AWARD_REQUEST]		= RoomController.onRoomGameBoxAwardResponse,
	[Command.ROOM_GAME_ACTIVITY_STATUS_REQUEST]	= RoomController.onRoomGameActivityStatusResponse,
	[Command.ROOM_GAME_ACTIVITY_DETAIL_REQUEST]	= RoomController.onRoomGameActivityDetailResponse,
	[Command.ROOM_GAME_ACTIVITY_AWARD_REQUEST]	= RoomController.onRoomGameActivityAwardResponse,
	[Command.INVITECON_GET_PHP_REQUEST]	= RoomController.onGetInviteContent,
}


--[[---------------------------- UI config  ---------------------------]]
local userInfoView = {"topView", "userInfoView"}

RoomController.s_controlConfig =
{
	[RoomController.s_controls.bg] = {"bg"},
	[RoomController.s_controls.desk] = {"backGrundView"},
	[RoomController.s_controls.timerView] = {"backGrundView", "timerView"},
	[RoomController.s_controls.roomInfoView] = {"roomInfoView"},
}

RoomController.s_controlFuncMap =
{
	[RoomController.s_controls.bg] = RoomController.onBgTouch;
}

-----------------------   [[通知事件]]  --------------------------
RoomController.messageFunMap = {
	["requestReady"] = RoomController.requestReady,
	["showReadyView"] = RoomController.showReadyView,
	["requestChangeDesk"] = RoomController.requestChangeDesk,
	["requestReconn"] = RoomController.requestReconn,
	["sendChatFace"] = RoomController.requestSendFace,
	["sendChatWord"] = RoomController.requestSendWord,
	["ensureGameType"] = RoomController.onEnsureGameType,
	["requestAi"] = RoomController.onRequestAi,
}

-----------------------   [[ 映射 ]]---------------------------------------
function RoomController:initCommandFuncMap()
	self.commandFunMap = {
		[Command.UserReadyBd] 	= self.onUserReady,
		[Command.RoomInfoBd]	= self.onRoomInfoBd,

		-- 玩家进出房间
		[Command.UserEnterBd]	= self.onUserEnter,
		[Command.UserExitBd] 	= self.onUserExit,			--广播退出房间
		[Command.LogoutRoomRsp] = self.onLogoutRoomRsp,		--广播退出房间

		--特别注意 玩牌相关如果需要注册事件 需要在子类中注册

		[Command.UserAiBd] 			= self.onUserAiBd, 			-- 玩家托管

		--聊天
		[Command.UserChat]          = self.onUserChat,          -- 玩家发送聊天及表情
		[Command.UserFace]          = self.onUserFace,          -- 玩家发送表情
		[Command.UserProp]          = self.onUserProp,          -- 玩家发送表情

		-- 玩牌
		[Command.GameReadyStartBd] 	= self.onGameReadyStartBd,	--广播开局 东风东局
		[Command.DealCardBd] 		= self.onDealCardBd,			--广播发牌
		[Command.GameStartBd] 	    = self.onGameStartBd,	    	--发牌后 广播开始游戏


		[Command.OwnGrabCardBd] 	= self.onOwnGrabCardBd,	--广播自己抓牌
		[Command.OtherGrabCardBd] 	= self.onOtherGrabCardBd,	--广播玩家抓牌
		[Command.OperateBd]     	= self.onOperateCardBd,	--广播玩家操作
		[Command.OperateCancelBd]   = self.onOperateCancelBd, --广播玩家操作取消
		[Command.QiangGangHuBd]     = self.onQiangGangHuBd,	--广播抢杠胡
		[Command.StopGameBd]     	= self.onStopGameBd,		--广播结算
		-- 出牌
		[Command.OutCardBd]     	= self.onOutCardBd,		--广播出牌

		-- 换三张
		[Command.SwapCardStartBd]   = self.onSwapCardStartBd,  --0x3012  --服务器通知开始换牌
		[Command.SwapCardRsp]       = self.onSwapCardRsp,  	--0x3013  --换牌返回

    	--[[公共业务]]
    	[Command.FreshMoneyRsp]     = self.onFreshMoneyRsp,
	    [Command.NoticeMoneyChangeRsp] = self.onNoticeMoneyChangeRsp,

	    [Command.SERVERGB_BROADCAST_BANKRUPT]  = self.serverBroadcastBankrupt, -- 广播玩家破产
	    [Command.SERVER_COMMAND_SELECT_PIAO]	= self.onServerStartSelectPiao,	-- 广播开始选漂
		[Command.SERVER_COMMAND_BROADCAST_PIAO] = self.onServerBroadcastSelectPiao, -- 广播玩家选漂
		[Command.SERVER_COMMAND_BROADCAST_START_GAME] = self.onServerBroadcastGameStart, -- 广播牌局开始
		[Command.SERVER_COMMAND_KICK_OUT]	= self.onServerKickOut, -- 踢出用户
		[Command.SERVER_COMMAND_READY_COUNT_DOWN]	= self.onServerShowReadyTime, -- 踢出用户
		[Command.SERVER_COMMAND_UPDATE_USER_INFO]	= self.onServerUpdateUserInfo, -- 更新用户信息
		[Command.SERVER_EXIT_PRIVATEROOM_REQ] = self.onExitPrivateRoomReq,
		[Command.SERVER_BROADCAST_STOP_BATTLE] = self.onBroadcastStopBattle,

	}
end

return RoomController
