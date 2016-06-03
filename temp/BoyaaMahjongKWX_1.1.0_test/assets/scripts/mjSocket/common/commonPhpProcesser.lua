--[[
	通用的Php消息处理器  2015-03-04
]]
local CommonPhpProcesser = class(SocketProcesser)
local printInfo, printError = overridePrint("CommonPhpProcesser")

function CommonPhpProcesser:requestLogin()

end

function CommonPhpProcesser:onPhpResponse( data )
	-- printf("========[[ 接收PHP命令 0x%04x ]] ============================", data.cmd)
	-- dump(data);
	-- server访问不到php
	if data.status == 404 then
		AlarmTip.play(data.msg)
		return
	end
	local func = self.s_severCmdEventFuncMap[data.cmd];
	if func then
		if data.data then
			func(self, data.data);
		else
			printInfo(string.format("0x%04X数据异常, 请稍后重试", data.cmd))
			AlarmTip.play(string.format("0x%04X数据异常, 请稍后重试", data.cmd))
		end
	end
	GameLoading:onCommandResponse(data.cmd)
end

function CommonPhpProcesser:onPhpTimeout( data )
end

function CommonPhpProcesser:onLoginResponse( data )
	if not app:checkResponseOk(data) then
		return
	end
	-- 本地没有缓存的游戏类型 或者 新注册 则按照推荐的选择玩法
	-- if GameConfig:getLastType() == 0 or MyUserData:getIsRegister() == 1 then
	-- 	local gameId = data.data.game_id or GameType.GBMJ
	-- 	local gameType = GameSupportStateMap[gameId] and gameId or GameType.GBMJ
	-- 	GameConfig:setLastType(gameType)
	-- 		:save()
	-- 	-- 通知选择游戏类型
	-- 	EventDispatcher.getInstance():dispatch(Event.Message, "SelectGameType", gameType)
	-- end

	MyUserData:initUserInfo(data.data)
	GameConfig:setLastUserType(data.data.usertype or MyUserData:getUserType())
		:save()
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.LOGIN_PHP_REQUEST, data);
end

function CommonPhpProcesser:onUserInfoResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.USERINFO_PHP_REQUEST, data);
end
--系统公告
function CommonPhpProcesser:onNoticeResponse( data )

	if app:checkResponseOk(data, true) then

		MyNoticeData:clear();

		for i = 1, #data.data do

			local notice = setProxy(new(require("data.notice")));

			notice:setTitle(data.data[i].title);
			notice:setContent(data.data[i].content)
			notice:setLink_type(data.data[i].link_type);
			notice:setLink_content(data.data[i].link_content);
			notice:setStart_time(data.data[i].start_time);

			MyNoticeData:add(notice);
		end

		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.NOTICE_PHP_REQUEST, data);
	end
end

--商城
function CommonPhpProcesser:onPayResponse( data )
	printInfo("CommonPhpProcesser:onPayResponse");
	if app:checkResponseOk(data) then
		-- MyPayData:clear();
		-- for i = 1, #data.data do
		-- 	local shop = new(require("data.shop"));

		-- 	shop:setId(data.data[i].id);
		-- 	shop:setPamount(data.data[i].pamount)
		-- 	shop:setPcard(data.data[i].pcard);
		-- 	shop:setPchips(data.data[i].pchips);
		-- 	shop:setPcoins(data.data[i].pcoins);
		-- 	shop:setPdesc(data.data[i].pdesc);
		-- 	shop:setPimg(data.data[i].pimg);
		-- 	shop:setPname(data.data[i].pname);
		-- 	shop:setPnum(data.data[i].pnum);
		-- 	shop:setPsort(data.data[i].psort);
		-- 	shop:setPtype(data.data[i].ptype);

		-- 	MyPayData:add(shop);
		-- end
		-- MyPayData:setInit(true)
		-- EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.PAY_PHP_REQUEST, data);
		PayController:privateRequestGoodsTableCallback(data.data)
	end
end

--计费配置
function CommonPhpProcesser:onPayConfigResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.PAY_CONFIG_PHP_REQUEST, data);
end

--计费配置
function CommonPhpProcesser:onPayConfigLimitResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.PAY_CONFIG_LIMIT_PHP_REQUEST, data);
end

--下单
function CommonPhpProcesser:onOrderResponse( data )

	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ORDER_PHP_REQUEST, data);
end


--日常任务
function CommonPhpProcesser:onTaskRcResponse( data )

	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.TASK_RC_PHP_REQUEST, data);

end
--成长任务
function CommonPhpProcesser:onTaskCzResponse( data )

	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.TASK_CZ_PHP_REQUEST, data);

end
--领取任务奖励
function CommonPhpProcesser:onTaskAwardResponse( data )
	if data.status == 1 then
		MyUserData:addMoney(tonumber(data.data.money or 0), true);
		-- local taskAwardNum = MyBaseInfoData:getTaskAward();
		-- if(tonumber(taskAwardNum) > 0) then -- 可以领奖数目减一
  --          MyBaseInfoData:setTaskAward(taskAwardNum-1);
  --          MyBaseInfoData:setCzTaskAward(taskAwardNum-1);
  --          MyBaseInfoData:setRcTaskAward(taskAwardNum-1);
		-- end
		--用户基本信息 更新用户基本信息
	    GameSocketMgr:sendMsg(Command.GET_BASEINFO_PHP_REQUEST, {infoParam = {s1 = 0xf, d1 = 0xff}}, false);
	end

	AlarmTip.play(data.msg);

	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.TASK_AWARD_PHP_REQUEST, data);

end

--更新任务
function CommonPhpProcesser:onUpdateResponse( data )
	-- 参数 true 表示 不提示status非1的msg信息
	if app:checkResponseOk(data, true) then
		local status = data.data.status
		MyUpdateData:setStatus(status);
		if 1 == status then
			MyUpdateData:setAward(data.data.award);
			MyUpdateData:setAwardstr(data.data.awardstr)
			MyUpdateData:setDesc(data.data.desc);
			MyUpdateData:setForce(data.data.force);
			MyUpdateData:setMode(data.data.mode);
			MyUpdateData:setTitle(data.data.title);
			MyUpdateData:setUmeng(data.data.umeng);
			MyUpdateData:setUpdate(data.data.update);
			MyUpdateData:setUrl(data.data.url);
			MyUpdateData:setVerstr(data.data.verstr);

			if (MyUpdateData:getAward() == 1 or MyUpdateData:getUpdate() == 1) then
				MyUpdateData:setStatus(1)
			else
				MyUpdateData:setStatus(0)
			end

			MyUpdateData:setInit(true);

			EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.UPDATE_PHP_REQUEST, data);
		end
	end
	--触发弹窗
	EventDispatcher.getInstance():dispatch(Event.Message, "closePopu", {popuId = WindowTag.UpdatePopu});
end

--签到奖励
function CommonPhpProcesser:onSignAwardResponse(data)
	-- 弹出签到领奖弹出
	if app:checkResponseOk(data) then
        MySignAwardData:clear();
        MySignAwardData:setSign_count(data.data.sign_count);
        MySignAwardData:setToday_sign(data.data.today_sign);
        MySignAwardData:setSignMoney(data.data.signMoney)
        MySignAwardData:setBqk_count(data.data.bqk_count)
        MySignAwardData:setLq_count(data.data.lq_count)

        local gifarr = data.data.gifarr

        for i = 1, #gifarr do
            local signAward = setProxy(new(require("data.signAward")));
            signAward:setTimes(gifarr[i].times);
            signAward:setTips(gifarr[i].tips);
            signAward:setTitle(gifarr[i].title);
            signAward:setImg(gifarr[i].img);
            signAward:setDesc(gifarr[i].desc);
            MySignAwardData:add(signAward);
        end
        MySignAwardData:setInit(true);
		EventDispatcher.getInstance():dispatch(Event.Message, "closePopu", {popuId = 0});
    end
    -- EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.SIGN_AWARD_PHP_REQUEST, data);
end

--签到领奖返回
function CommonPhpProcesser:onSignGetAwardResponse(data)
	-- 处理金币变动
	if app:checkResponseOk(data) then
		-- MyUserData:setMoney(data.data.money or 0, true)
		-- 成功后通知到签到面板
    	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.SIGN_GETAWARD_PHP_REQUEST, data);
    end
end

-- 补签领奖返回
function CommonPhpProcesser:onSignBQGetAwardResponse( data )
	-- body
	if app:checkResponseOk(data) then
		MyGoodsData:setGoodsNumById(MyExchangeData.TypeBqCard, data.data.bqk_count)
		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.SIGN_BQ_GETAWARD_PHP_REQUEST, data);
	end
end

--签到大礼包领奖返回
function CommonPhpProcesser:onSignGetGiftAwardResponse(data)
	-- 处理金币变动
	if app:checkResponseOk(data) then
		-- MyUserData:setMoney(data.data.money or 0, true)
		-- 成功后通知到签到面板
    	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.SIGN_GETGIFTAWARD_PHP_REQUEST, data);
    end
end

-- 破产补助返回
function CommonPhpProcesser:onPoChanAwardResponse(data)
	if app:checkResponseOk(data, true) then
		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.PO_CHAN_PHP_REQUEST, data)
	end
end

-- 破产补助时间返回
function CommonPhpProcesser:onPoChanTimeResponse(data)
	if app:checkResponseOk(data, true) then
        EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.PO_CHAN_TIME_PHP_REQUEST, data)
	end
end

-- 充值推荐金币额度
function CommonPhpProcesser:onPayRecommendResponse(data)
	if app:checkResponseOk(data) then
		local MoneyRecommend = require("data.moneyRecommend")
		for i, v in ipairs(data.data.money) do
            local moneyRecommend = new(MoneyRecommend)
            	:setPrice(v.price)
            	:setMin(v.min)
            	:setMax(v.max)
            MyMoneyRecommendData:add(moneyRecommend)
		end
		MyMoneyRecommendData:setInit(true)
	end
end

--根据level返回道具配置
function CommonPhpProcesser:onPropResponse(data)
	if app:checkResponseOk(data) then
		local propRecord = new(require("data.prop"))
		propRecord:setLevel(data.data.level)
		propRecord:setLimit(data.data.limit)
		propRecord:setPropList(data.data.list)
		MyPropData:add(propRecord)
	end
end

-- 房间场次配置，场次推荐金额
function CommonPhpProcesser:onRoomConfigResponse(data)
	printInfo("onRoomConfigResponse")
	if app:checkResponseOk(data) then
		printInfo("onRoomConfigResponse is ok")
		local LevelConfig = require("data.levelConfig")
		for i,v in ipairs(data.data.list) do
			local levelConfig = new(LevelConfig)
				:setType(tonumber(v.type))
				:setLevel(tonumber(v.level))
				:setIndex(tonumber(v.index))
				:setRecommend(tonumber(v.recommend))
				:setValue(tonumber(v.value))
				:setUppermost(tonumber(v.uppermost))
				:setRequire(tonumber(v.require))
				:setXzrequire(tonumber(v.xzrequire))

            if v.piao_num_arr then
			    local piaoTab = {}
			    for j, k in pairs(v.piao_num_arr) do
				    table.insert(piaoTab,tonumber(k))
			    end
			    levelConfig:setPiaoTab(piaoTab)
			end
			MyLevelConfigData:add(levelConfig)
		end
		-- 根据准入金币 从小到大排序
		MyLevelConfigData:sort(function(s1, s2)
			return s1:getRequire() < s2:getRequire()
		end)
		MyLevelConfigData:setTime(data.data.time)
		MyLevelConfigData:setInit(true)
		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_CONFIG_PHP_REQUEST, data);
	end
end

--根据活动相关数据
function CommonPhpProcesser:onActivitiesResponse(data)
	if app:checkResponseOk(data) then
		if System.getPlatform() == kPlatformIOS then		-- iOS木有活动SDK，需要用这个来获取活动数量
			MyActivitiesData:setActnum(data.data.act_num);
		end
		-- printInfo(MyActivitiesData:getActnum());
	end
end

--首充礼包
function CommonPhpProcesser:onFirstPayBagResponse(data)
   	if app:checkResponseOk(data) then
   		local status = tonumber(data.data.status) or 0
        MyFirstPayBagData:setStatus(status)
        MyUserData:setAvoidFirstPay(1 ~= (tonumber(data.data.open) or 0))
        if status == 1 then
	        MyFirstPayBagData:setDesc(data.data.desc)
	        MyFirstPayBagData:setPrice(tonumber(data.data.price) or 6)
	        MyFirstPayBagData:setBtn_type(tonumber(data.data.btn_type) or 1)
	        MyFirstPayBagData:setOpen(tonumber(data.data.open) or 0)
	        MyFirstPayBagData:setGift_price(data.data.gift_price)
	        MyFirstPayBagData:setGift_title(data.data.gift_title)
	   	 	MyFirstPayBagData:setInit(true)
	   	 	local goods = data.data.goods or {}
	   	 	local FirstPayData = require("data.firstPayData")
	   	 	for i = 1, #goods do
	   	 		local firstPayData = new(FirstPayData)
	   	 		firstPayData:setImg(goods[i].img or "")
	   	 		firstPayData:setName(goods[i].name or "")
	   	 		MyFirstPayBagData:add(firstPayData)
	   	 	end
	   	 	-- 分发到界面
		    EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.FIRST_PAY_BAG_PHP_REQUEST, data);
		end
    end
end

--注册验证码
function CommonPhpProcesser:onRegisterSecurityCodeResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.REGISTER_SECURITY_CODE_PHP_REQUEST, data);
end

--找回密码
function CommonPhpProcesser:onForgotPasswordResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.FORGOT_PASSWORD_PHP_REQUEST, data);
end
--排行榜(巅峰)
function CommonPhpProcesser:onRankDianFengResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.RANK_DIANFENG_PHP_REQUEST, data);
end
--排行榜(战神)
function CommonPhpProcesser:onRankZhangShenResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.RANK_ZHANSHEN_PHP_REQUEST, data);
end
--排行榜(土豪)
function CommonPhpProcesser:onRankFuHaoResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.RANK_FUHAO_PHP_REQUEST, data);
end

--防沉迷
function CommonPhpProcesser:onAntiAddictionResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ANTI_ADDICTION_PHP_REQUEST, data);
end

--排行榜领取
function CommonPhpProcesser:onDianFengGetAwardResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.RANK_DIANFENG_GET_AWARD_PHP_REQUEST, data);
end


function CommonPhpProcesser:onModifyUserInfoResponse( data )
	if app:checkResponseOk(data) then
		AlarmTip.play(data.msg)

		if data.data.nick then
			MyUserData:setNick(data.data.nick);
		end

		if data.data.sex then
			MyUserData:setSex(data.data.sex);
		end
	end
end
--更新奖励
function CommonPhpProcesser:onUpdateAwardResponse( data )
	if isPlatform_IOS then
		local update = ToolKit.getDict("UPDATE", {'isupdated'})
		-- 如果是使用系统一键更新的，当领奖完毕后，重置状态
		if update.isupdated and update.isupdated == 1 then
			ToolKit.setDict("UPDATE", {isupdated = 0})
		end
	end

	--加金币
	if data.status == 1 then
		MyUserData:addMoney(tonumber(data.data.money or 0), true);
		MyUpdateData:setAward(0)
		MyUpdateData:setStatus(0)
		GameSocketMgr:sendMsg(Command.UPDATE_PHP_REQUEST, {}, false);
		ToolKit.setDict("UPDATE", { version = ""});
	else
		AlarmTip.play(data.msg);
	end
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.UPDATE_AWARD_PHP_REQUEST, data);
end

function CommonPhpProcesser:onSetUpdateResponse( data )
	-- 安卓不用处理，iOS需要判断是否可以领奖
	if isPlatform_IOS then
		local update = ToolKit.getDict("UPDATE", {'isupdated'})
		-- 判断是否已更新
		if update.isupdated and update.isupdated == 1 then
			-- 已更新则领奖
			GameSocketMgr:sendMsg(Command.UPDATE_AWARD_PHP_REQUEST, {}, false);
		end
	end
end

--通知更新奖励
function CommonPhpProcesser:onNotifyUpdateAwardResponse( data )
	--加金币
	if data.status == 1 then
		ToolKit.setDict("UPDATE", { version = "" });
	end
end

--获取基础信息
function CommonPhpProcesser:onGetBaseInfoResponse( data )
	if not data.data then
		return
	end

	if data.status == 1 then
		local s1 = data.data.s1;
		if s1 then
			MyBaseInfoData:setBindTip(s1["1"] or "")
			MyBaseInfoData:setDefaultImage(s1["2"] or "")
			MyBaseInfoData:setBrokenMoney(s1["4"] or 2000)
			MyBaseInfoData:setNetUpdateTime(s1["8"] or 0);  --网络配置 位
		end
		local d1 = data.data.d1;
		if d1 then
			MyBaseInfoData:setBind(d1["1"] or 0)
			MyBaseInfoData:setFirstPay(d1["2"] or 0)
			local taskAward = d1["4"] or {}
			if type(taskAward) == "table" then
				MyBaseInfoData:setRcTaskAward(taskAward.rc or 0);
				MyBaseInfoData:setCzTaskAward(taskAward.cz or 0);
			end
			MyBaseInfoData:setTaskAward(MyBaseInfoData:getRcTaskAward() + MyBaseInfoData:getCzTaskAward());

			-- MyBaseInfoData:setRankAward(d1["8"] or 0);
			MyBaseInfoData:setFeedBack(d1["16"] or 0);
			MyBaseInfoData:setAntiAddiction(d1["32"] or 0);
			-- MyBaseInfoData:setTomorrowAward(d1["64"] or 0);
			MyBaseInfoData:setMaxWin(d1["128"] or 0)
		end
	end
	
	ConnectModule.getInstance():getCDNNetConfig()
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.GET_BASEINFO_PHP_REQUEST, data);
end

--获取道具列表
function CommonPhpProcesser:onExchangeListResponse( data )
	if app:checkResponseOk(data) then
		MyExchangeData:clear();
		MyGoodsData:clear();

		if data.data.type_kind then 

		    -- 实物类list
		    for i = 1, #data.data.type_kind do
			    local exchange = new(require("data.exchange"));

			    exchange:setId(tonumber(data.data.type_kind[i].id))
			    exchange:setName(data.data.type_kind[i].name)
			    exchange:setSptype(tonumber(data.data.type_kind[i].sptype))
			    exchange:setImage(data.data.type_kind[i].image)
			    exchange:setCoupons(tonumber(data.data.type_kind[i].coupons))
			    exchange:setMoney(tonumber(data.data.type_kind[i].money))
			    exchange:setGoodsdes(data.data.type_kind[i].goodsdes)
			    exchange:setGoodstype(tonumber(data.data.type_kind[i].goodstype))
			    exchange:setCid(tonumber(data.data.type_kind[i].cid))
			    exchange:setNum(tonumber(data.data.type_kind[i].curnum))

			    MyExchangeData:add(exchange);
		    end
		    MyExchangeData:setInit(true)
        end

		if data.data.type_card then 
		    -- 道具list
		    for i = 1, #data.data.type_card do
			    local exchange = new(require("data.exchange"));

			    exchange:setId(tonumber(data.data.type_card[i].id))
			    exchange:setName(data.data.type_card[i].name)
			    exchange:setSptype(tonumber(data.data.type_card[i].sptype))
			    exchange:setImage(data.data.type_card[i].image)
			    exchange:setCoupons(tonumber(data.data.type_card[i].coupons))
			    exchange:setMoney(tonumber(data.data.type_card[i].money))
			    exchange:setGoodsdes(data.data.type_card[i].goodsdes)
			    exchange:setGoodstype(tonumber(data.data.type_card[i].goodstype))
			    exchange:setCid(tonumber(data.data.type_card[i].cid))
			    exchange:setNum(tonumber(data.data.type_card[i].curnum))

			    MyGoodsData:add(exchange);
		    end
		    MyGoodsData:setInit(true)
        end

		if data.data.type_gift then  
		    -- 礼包list
		    MyGiftPackData:clear()
		    for i = 1, #data.data.type_gift do
			    local exchange = new(require("data.exchange"));

			    exchange:setId(tonumber(data.data.type_gift[i].id))
			    exchange:setName(data.data.type_gift[i].name)
			    exchange:setSptype(tonumber(data.data.type_gift[i].sptype))
			    exchange:setImage(data.data.type_gift[i].image)
			    exchange:setCoupons(tonumber(0))
			    exchange:setMoney(tonumber(0))
			    exchange:setGoodsdes(data.data.type_gift[i].desc)
			    exchange:setGoodstype(tonumber(data.data.type_gift[i].goodstype))
			    exchange:setCid(tonumber(data.data.type_gift[i].cid))
			    exchange:setNum(tonumber(data.data.type_gift[i].curnum))

			    MyGiftPackData:add(exchange);
		    end
		    MyGiftPackData:setInit(true)
        end


		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.EXCHANGE_LIST_REQUEST, data);
	end
end

-- 兑换商品
function CommonPhpProcesser:onExchangeGoodsResponse( data )

	if not data or 1 ~= data.status or not data.data then
		return
	end

	if 1 ~= data.data.status then
		AlarmTip.play(data.data.msg or "")
		return
	end
    
	if app:checkResponseOk(data) then
		MyGoodsData:setGoodsNumById(tonumber(data.data.cid), data.data.curnum)
		MyGiftPackData:setGoodsNumById(tonumber(data.data.cid), data.data.curnum)
		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.EXCHANGE_GOODS_REQUEST, data);
	end
end

-- 兑换记录
function CommonPhpProcesser:onExchangeRecordResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.EXCHANGE_RECORD_REQUEST, data);
end

-- 牌局宝箱状态
function CommonPhpProcesser:onRoomGameBoxStatusResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_GAME_BOX_STATUS_REQUEST, data);
end

-- 牌局宝箱详情
function CommonPhpProcesser:onRoomGameBoxDetailResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_GAME_BOX_DETAIL_REQUEST, data);
end

-- 牌局宝箱领奖
function CommonPhpProcesser:onRoomGameBoxAwardResponse(data)
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_GAME_BOX_AWARD_REQUEST, data);
end


-- 房间活动
function CommonPhpProcesser:onRoomGameActivityStatusResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_GAME_ACTIVITY_STATUS_REQUEST, data);
end

-- 房间活动
function CommonPhpProcesser:onRoomGameActivityDetailResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_GAME_ACTIVITY_DETAIL_REQUEST, data);
end

-- 房间活动
function CommonPhpProcesser:onRoomGameActivityAwardResponse( data )
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.ROOM_GAME_ACTIVITY_AWARD_REQUEST, data);
end

function CommonPhpProcesser:onOneKeyHideResponse(data)
	if data.status == 1 then
		ShieldData:initData(data.data)
			:setInit(true)
		-- 拉取到屏蔽信息后处理业务
		app:dealBusinessAfterShield()
		--重新对大厅进行屏蔽判断
		EventDispatcher.getInstance():dispatch(Event.Shield)
	end
end

function CommonPhpProcesser:onMutiPayConfigResponse(data)
	-- 如果之前屏蔽 之后没有屏蔽
	local preFlag = ShieldData:getMutiPayFlag()
	if data.status == 1 then
		-- 如果审核屏蔽没有屏蔽多重支付，而该接口又屏蔽了 则重新设置
		local open = data.data and data.data.open or 0 --默认为0 屏蔽
		printInfo("CommonPhpProcesser:onMutiPayConfigResponse open = ".. open)
		ShieldData:setMutiPayFlag(open == 0)
		if not theOriginUnitePayConfigMap then
			theOriginUnitePayConfigMap = UnitePayConfigMap
		end
		if ShieldData:getMutiPayFlag() then
    	UnitePayConfigMap = {
			[UnitePayIdMap.APPLE_PAY]			= {"img_apple.png", "苹果支付"},  --苹果支付
		}
		else
    	UnitePayConfigMap = theOriginUnitePayConfigMap
		end
	end
	ShieldData:setMutiPayChanged(ShieldData:getMutiPayFlag() ~= preFlag)
  	GameSocketMgr:sendMsg(Command.PAY_CONFIG_LIMIT_PHP_REQUEST, {}, false);
end

function CommonPhpProcesser:onReportAPNSToken(data)
	printInfo("onReportAPNSToken")
end

function CommonPhpProcesser:onSendHornMsgResponse( data )
	-- body
	if not data or 1 ~= data.status or not data.data then return end

	if 1 ~= data.data.status then
		AlarmTip.play(data.data.msg or "")
		return
	end

	if app:checkResponseOk(data) then
		MyGoodsData:setGoodsNumById(MyGoodsData.TypeHorn, data.data.num)
		EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.HORN_SEND_PHP_REQUEST, data);
	end
end

function CommonPhpProcesser:onGetUserInfoResponse( data )
	-- body
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.USERINFO_GET_PHP_REQUEST, data);
end

function CommonPhpProcesser:onGetAllfriendResponse( data )
	-- body
	if not data or 1 ~= data.status or not data.data then return end

	local friendslist = data.data.friends
	MyFriendData = {}

    if not friendslist then return end

    for i = 1, #friendslist do
	    local item = new(require("data.friendData"));
	    item:setMid(tonumber(friendslist[i].mid))
	    item:setNick(friendslist[i].mnick)
	    item:setSex(tonumber(friendslist[i].sex))
	    item:setLevel(tonumber(friendslist[i].level))
	    item:setMoney(tonumber(friendslist[i].money))
	    item:setHeadurl(friendslist[i].small_image)
	    item:setDrawtimes(tonumber(friendslist[i].drawtimes))
	    item:setWintimes(tonumber(friendslist[i].wintimes))
	    item:setLosttimes(tonumber(friendslist[i].losttimes))

	    table.insert(MyFriendData, item)
    end
    table.sort(MyFriendData, function ( a, b )
		-- body
		return a:getMoney() > b:getMoney()
	end)
	
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.FRIEND_GET_ALLFRIEND_PHP_REQUEST);
end

function CommonPhpProcesser:onGetRecfriendResponse( data )
	-- body
	if not data or 1 ~= data.status or not data.data then return end

    local data = data.data.friends
    if not data then return end

	MyRecFriendData:clear()
    for i = 1, #data do
    	local item = new(require("data.friendData"));
	    item:setMid(tonumber(data[i].mid))
	    item:setNick(data[i].mnick)
	    item:setSex(tonumber(data[i].sex))
	    item:setLevel(tonumber(data[i].level))
	    item:setMoney(tonumber(data[i].money))
	    item:setHeadurl(data[i].small_image)
	    item:setDrawtimes(tonumber(data[i].drawtimes))
	    item:setWintimes(tonumber(data[i].wintimes))
	    item:setLosttimes(tonumber(data[i].losttimes))

	    MyRecFriendData:add(item)
    end
    MyRecFriendData:setInit(true)
	
end


function CommonPhpProcesser:onGetSystemMsgResponse( data )
	-- body
	if not data or 1 ~= data.status or not data.data then return end

	data = data.data.data
	MyMailSystemData:clear()
    for i = 1, #data do
	    local item = new(require("data.mailSystemData"));
	    item:setId(tonumber(data[i].id))
	    item:setType(tonumber(data[i].type))
	    item:setAward(tonumber(data[i].award))
	    item:setContent(data[i].content)
	    item:setTitle(data[i].title)

	    -- table.insert(MyMailSystemData, item)
	    MyMailSystemData:add(item)
    end
    MyMailSystemData:setInit(true)
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.MAIL_GET_SYSTEMMSG_PHPREQUEST);
end

function CommonPhpProcesser:onGetSystemAwardMsgResponse( data )
	-- body
    if not data or 1 ~= data.status or not data.data then
		return
	end

	if 1 ~= data.data.status then
		AlarmTip.play(data.data.msg or "")
		return
	end

    for i = 1, MyMailSystemData:count() do
        local item = MyMailSystemData:get(i)
        if data.data.msgid == item:getId() then
           item:setAward(1)
           EventDispatcher.getInstance():dispatch(
		           	HttpModule.s_event, 
		           	Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST, 
		           	data.data.msgid);
           return
        end
    end
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST);
end

function CommonPhpProcesser:onGetFriendMsgResponse( data )
	-- body
    if not data or 1 ~= data.status or not data.data then
		return
	end

	data = data.data
	MyMailFriendData:clear()
    for i = 1, #data do
	    local item = new(require("data.mailFriendData"));
	    item:setId(tonumber(data[i].mid))
	    item:setType(tonumber(data[i].type))
	    item:setSendtime(tonumber(data[i].sendtime))
	    item:setTime(tonumber(data[i].time))
	    item:setSex(tonumber(data[i].sex))
	    item:setMoney(tonumber(data[i].money))
	    item:setContent(data[i].content)
	    item:setMnick(data[i].mnick)
	    item:setPoto(data[i].poto)

	    -- table.insert(MyMailSystemData, item)
	    MyMailFriendData:add(item)
    end
    MyMailFriendData:setInit(true)
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.MAIL_GET_FRIENDMSG_PHPREQUEST);
	
end

function CommonPhpProcesser:onDelSystemMsgResponse( data )
	-- body
	if not data or 1 ~= data.status or not data.data then
		return
	end

	if 1 ~= data.data.status then
		AlarmTip.play(data.data.msg or "")
		return
	end

	AlarmTip.play(data.data.msg or "")
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.MAIL_DEL_SYSTEMMSG_PHPREQUEST);
end

function CommonPhpProcesser:onTaskSubmitResponse( data )
	-- body
	if not data or 1 ~= data.status or not data.data then
		return
	end

	if 1 ~= data.data.status then
		AlarmTip.play(data.data.msg or "")
		return
	end
	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.TASKSUBMIT_PHP_REQUEST);
end

function CommonPhpProcesser:onGetCreateRoomConfig( data )
	if not data or 1 ~= data.status or not data.data then
		return
	end

	--MyCreateRoomCfg = {}
	local tempList = {}
	if data.data.basepoint then
		for k,v in pairs(data.data.basepoint) do
			local item = {key = tonumber(k), name = v}
			table.insert(tempList, 1, item)
		end
	end
	MyCreateRoomCfg:setBasePoint(tempList)

	tempList = {}
	if data.data.bei then
		for k,v in pairs(data.data.bei) do
			local item = {key = tonumber(k), name = v}
			table.insert(tempList, 1, item)
		end
	end
	MyCreateRoomCfg:setBei(tempList)

	tempList = {}
	if data.data.playtype then
		for k,v in pairs(data.data.playtype) do
			local item = {key = tonumber(k), name = v}
			table.insert(tempList, 1, item)
		end
	end
	MyCreateRoomCfg:setPlayType(tempList)

	tempList = {}
	if data.data.roundnum then
		for k,v in pairs(data.data.roundnum) do
			local item = {key = tonumber(k), name = v}
			table.insert(tempList, 1, item)
		end
	end
	MyCreateRoomCfg:setRoundNum(tempList)
end

function CommonPhpProcesser:onGetInviteContent( data )
	if not data or 1 ~= data.status or not data.data then
		return
	end

	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.INVITECON_GET_PHP_REQUEST, data);
end

function CommonPhpProcesser:onGetBillingInfo( data )
	if not data or 1 ~= data.status then
		return
	end

	EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.BILLINGINFO_GET_PHP_REQUEST, data);
end

function CommonPhpProcesser:onPaymentBattleResponse( data )
	if not data or 1 ~= data.status or not data.data then
		return
	end

	MyUserData:setJewel(tonumber(data.data.boyaacoin))
end

function CommonPhpProcesser:onRePaymentBattleResponse( data )
	if not data or 1 ~= data.status or not data.data then
		return
	end

	MyUserData:setJewel(tonumber(data.data.boyaacoin))
end

function CommonPhpProcesser:onAnnounceSystemResponse( data )
	if app:checkResponseOk(data, true) then

		MyNoticeData:clear();

		for i = 1, #data.data do

			local notice = setProxy(new(require("data.notice")));

			notice:setTitle(data.data[i].title);
			notice:setContent(data.data[i].content)
			notice:setLink_type(data.data[i].link_type);
			notice:setLink_content(data.data[i].link_content);
			notice:setStart_time(data.data[i].start_time);

			MyNoticeData:add(notice);
		end
		WindowManager:showWindow(WindowTag.NoticePopu, {}, WindowStyle.POPUP)
	end
end

--[[
	通用的（大厅）协议
]]
CommonPhpProcesser.s_severCmdEventFuncMap = {
	[Command.PHP_CMD_RESPONSE] 						= CommonPhpProcesser.onPhpResponse,
	[Command.SERVER_CMD_PHP_OUT_TIME] 				= CommonPhpProcesser.onPhpTimeout,
	[Command.LOGIN_PHP_REQUEST]						= CommonPhpProcesser.onLoginResponse,
	[Command.USERINFO_PHP_REQUEST]					= CommonPhpProcesser.onUserInfoResponse,
	[Command.NOTICE_PHP_REQUEST]					= CommonPhpProcesser.onNoticeResponse,
	[Command.PAY_PHP_REQUEST]						= CommonPhpProcesser.onPayResponse,
	[Command.PAY_CONFIG_PHP_REQUEST]				= CommonPhpProcesser.onPayConfigResponse,
	[Command.PAY_CONFIG_LIMIT_PHP_REQUEST]			= CommonPhpProcesser.onPayConfigLimitResponse,
	[Command.ORDER_PHP_REQUEST]						= CommonPhpProcesser.onOrderResponse,
	[Command.TASK_RC_PHP_REQUEST]					= CommonPhpProcesser.onTaskRcResponse,
	[Command.TASK_CZ_PHP_REQUEST]					= CommonPhpProcesser.onTaskCzResponse,
	[Command.TASK_AWARD_PHP_REQUEST]				= CommonPhpProcesser.onTaskAwardResponse,
	[Command.UPDATE_PHP_REQUEST] 					= CommonPhpProcesser.onUpdateResponse,
	[Command.SETUPDATE_PHP_REQUEST] 				= CommonPhpProcesser.onSetUpdateResponse,
	[Command.REGISTER_SECURITY_CODE_PHP_REQUEST] 	= CommonPhpProcesser.onRegisterSecurityCodeResponse,
	[Command.FORGOT_PASSWORD_PHP_REQUEST] 			= CommonPhpProcesser.onForgotPasswordResponse,
	[Command.RANK_DIANFENG_PHP_REQUEST]				= CommonPhpProcesser.onRankDianFengResponse,
	[Command.RANK_ZHANSHEN_PHP_REQUEST]			    = CommonPhpProcesser.onRankZhangShenResponse,
	[Command.RANK_FUHAO_PHP_REQUEST]				= CommonPhpProcesser.onRankFuHaoResponse,

	[Command.SIGN_AWARD_PHP_REQUEST]                = CommonPhpProcesser.onSignAwardResponse,
    [Command.FIRST_PAY_BAG_PHP_REQUEST]             = CommonPhpProcesser.onFirstPayBagResponse,

    [Command.ANTI_ADDICTION_PHP_REQUEST] 			= CommonPhpProcesser.onAntiAddictionResponse,
    [Command.SIGN_GETAWARD_PHP_REQUEST] 			= CommonPhpProcesser.onSignGetAwardResponse,
    [Command.SIGN_BQ_GETAWARD_PHP_REQUEST] 			= CommonPhpProcesser.onSignBQGetAwardResponse,
    [Command.SIGN_GETGIFTAWARD_PHP_REQUEST] 		= CommonPhpProcesser.onSignGetGiftAwardResponse,

    [Command.PO_CHAN_PHP_REQUEST] 					= CommonPhpProcesser.onPoChanAwardResponse,
    [Command.PO_CHAN_TIME_PHP_REQUEST] 				= CommonPhpProcesser.onPoChanTimeResponse,
    [Command.PAY_RECOMMEND_PHP_REQUEST] 			= CommonPhpProcesser.onPayRecommendResponse,
    [Command.MODIFY_USERINFO_PHP_REQUEST] 			= CommonPhpProcesser.onModifyUserInfoResponse,
    [Command.PROP_PHP_REQUEST] 						= CommonPhpProcesser.onPropResponse,
    [Command.ROOM_CONFIG_PHP_REQUEST] 				= CommonPhpProcesser.onRoomConfigResponse,
    [Command.GET_ACTRELATED_PHP_REQUEST] 			= CommonPhpProcesser.onActivitiesResponse,
    [Command.RANK_DIANFENG_GET_AWARD_PHP_REQUEST]	= CommonPhpProcesser.onDianFengGetAwardResponse,
    [Command.UPDATE_AWARD_PHP_REQUEST]				= CommonPhpProcesser.onUpdateAwardResponse,
    [Command.NOTIFY_UPDATE_AWARD_PHP_REQUEST]		= CommonPhpProcesser.onNotifyUpdateAwardResponse,
    [Command.GET_BASEINFO_PHP_REQUEST]				= CommonPhpProcesser.onGetBaseInfoResponse,
    [Command.EXCHANGE_LIST_REQUEST]					= CommonPhpProcesser.onExchangeListResponse,
    [Command.EXCHANGE_GOODS_REQUEST]				= CommonPhpProcesser.onExchangeGoodsResponse,
    [Command.EXCHANGE_RECORD_REQUEST]				= CommonPhpProcesser.onExchangeRecordResponse,

    [Command.ROOM_GAME_BOX_STATUS_REQUEST]			= CommonPhpProcesser.onRoomGameBoxStatusResponse,
    [Command.ROOM_GAME_BOX_DETAIL_REQUEST]			= CommonPhpProcesser.onRoomGameBoxDetailResponse,
    [Command.ROOM_GAME_BOX_AWARD_REQUEST]		    = CommonPhpProcesser.onRoomGameBoxAwardResponse,

    [Command.ROOM_GAME_ACTIVITY_STATUS_REQUEST]		= CommonPhpProcesser.onRoomGameActivityStatusResponse,
    [Command.ROOM_GAME_ACTIVITY_DETAIL_REQUEST]		= CommonPhpProcesser.onRoomGameActivityDetailResponse,
    [Command.ROOM_GAME_ACTIVITY_AWARD_REQUEST]		= CommonPhpProcesser.onRoomGameActivityAwardResponse,

	--[[ 一键屏蔽功能 ]]
	[Command.ONEKEY_HIDE_PHP_REQUEST]				= CommonPhpProcesser.onOneKeyHideResponse,  --一键屏蔽
	[Command.IOS_MUTI_PAY_PHP_REQUEST]				= CommonPhpProcesser.onMutiPayConfigResponse,  --苹果多支付屏蔽
	[Command.IOS_REPORT_PUSH_TOKEN_REQUEST]			= CommonPhpProcesser.onReportAPNSToken,

	[Command.HORN_SEND_PHP_REQUEST]					= CommonPhpProcesser.onSendHornMsgResponse,
	[Command.USERINFO_GET_PHP_REQUEST]				= CommonPhpProcesser.onGetUserInfoResponse,

	[Command.TASKSUBMIT_PHP_REQUEST]				= CommonPhpProcesser.onTaskSubmitResponse,
	-- 好友相关
	[Command.FRIEND_GET_ALLFRIEND_PHP_REQUEST]		= CommonPhpProcesser.onGetAllfriendResponse,
	[Command.FRIEND_GET_RECOMMEND_PHP_REQUEST]		= CommonPhpProcesser.onGetRecfriendResponse,
	
	-- 邮件相关
	[Command.MAIL_GET_SYSTEMMSG_PHPREQUEST]			= CommonPhpProcesser.onGetSystemMsgResponse,
	[Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST]	= CommonPhpProcesser.onGetSystemAwardMsgResponse,
	[Command.MAIL_DEL_SYSTEMMSG_PHPREQUEST]			= CommonPhpProcesser.onDelSystemMsgResponse,

	[Command.CREATEROOMFIG_GET_PHP_REQUEST]			= CommonPhpProcesser.onGetCreateRoomConfig,
	[Command.INVITECON_GET_PHP_REQUEST]			= CommonPhpProcesser.onGetInviteContent,

	[Command.BILLINGINFO_GET_PHP_REQUEST]			= CommonPhpProcesser.onGetBillingInfo,
	[Command.PAYMENT_BATTLE_PHP_REQUEST]			= CommonPhpProcesser.onPaymentBattleResponse,
	[Command.REPAYMENT_BATTLE_PHP_REQUEST]			= CommonPhpProcesser.onRePaymentBattleResponse,
	[Command.ANNOUNCE_SYSTEM_PHP_REQUEST]			= CommonPhpProcesser.onAnnounceSystemResponse,
	
}

return CommonPhpProcesser
