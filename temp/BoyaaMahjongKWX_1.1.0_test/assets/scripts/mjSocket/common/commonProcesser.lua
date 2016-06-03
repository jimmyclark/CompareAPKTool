--[[
	通用的socket消息处理器  2015-03-03
]]
local CommonProcesser = class(SocketProcesser)
local printInfo, printError = overridePrint("CommonProcesser")

function CommonProcesser:ctor()
    testCommonProcesser = self
end

--0x1005
function CommonProcesser:onLoginRoomErr(data)
	local faultInfo = "加入房间异常，请您重试！"
	local errType = data.iErrType
	local reLogin
    if errType == 2 or errType == 3 then
    	reLogin = true
        faultInfo = "您的账号在别处登录，请重新登录！"
    elseif errType == 4 then
        faultInfo = "加入房间异常，请您重试！"
    elseif errType == 5 then
        faultInfo = "桌子不存在，请您重试！"
    elseif errType == 6 then
    	reLogin = true
        faultInfo = "加入房间错误，请重新登录！"
    elseif errType == 7 then
        faultInfo = "房间人数已满！"
    elseif errType == 8 then
        faultInfo = "房间人数已满！"
    elseif errType == 9 then
        faultInfo = string.format("您的金币数不足%d，无法进入房间！", data.iNeedMoney)
    elseif errType == 16 then
		local time = data.iTime
		local fcmStr1 = "亲，您还需要"
		--已经超过时间
		local fcmStr2 = "才可以进入游戏，请合理安排学习生活时间"
		--填写防沉迷信息
		local fcmStr3 = "才可以进入游戏，请填写防沉迷信息"
		--进入游戏
		local fcmStr4 = "才可以进入游戏"
        local hour 	= math.floor(time/3600)
        local min 	= math.floor((time%3600)/60)
        local tipStr = string.format("%d小时%d分钟", hour, min)
        if hour == 0 and min == 0 then
          	tipStr = string.format("%d秒", time % 60)
        elseif hour == 0 and min ~= 0 then
          	tipStr = string.format("%d分钟", time / 60)
        end
        local isAult = MyUserData:getIsAult()
        if isAult == 1 then
          	faultInfo= string.format(fcmStr1 .. "%s" .. fcmStr2, tipStr)
        elseif isAult == -1 or isAult == -2 then
          	faultInfo= string.format(fcmStr1 .. "%s" .. fcmStr3, tipStr)
        else
          	faultInfo= string.format(fcmStr1 .. "%s" .. fcmStr4, tipStr)
        end
    elseif errType == 28 then
        faultInfo = "找不到对应房间，请重试！"
    end
    local bundleData = {
    	type 	= StateEvent.LoginRoomError,
    	msgTip 	= faultInfo,
    	reLogin = reLogin,
    }
    if PhpManager:getIsTest() == 1 then
        bundleData.msgTip = bundleData.msgTip..("\n\nerrorCode = " .. errType)
    end
    StateChange.changeState(States.Lobby, bundleData)
    GlobalRoomLoading:stop()
end

function CommonProcesser:onLobbyKickOutBd(data)
    local bundleData = {
        type    = StateEvent.LoginRoomError,
        msgTip  = "您的账号登录异常，若非您本人操作，请及时修改密码；如有问题，请联系：400-663-1888。",
        reLogin = true,
    }
    StateChange.changeState(States.Lobby, bundleData)
    GlobalRoomLoading:stop()
end

function CommonProcesser:onLoginRoomOtherErr(data)
    local bundleData = {
        type    = StateEvent.LoginRoomError,
        msgTip  = "连接异常，请重新登录！",
        reLogin = true,
    }
    StateChange.changeState(States.Lobby, bundleData)
    GlobalRoomLoading:stop()
end

-- 0x20F 登录房间
function CommonProcesser:onLoginRoomServerErr(data)
    local bundleData = {
        type    = StateEvent.LoginRoomError,
        msgTip  = "找不到对应房间，请重试！",
        -- msgTip  = "服务器繁忙，请稍后重试！",
    }
    StateChange.changeState(States.Lobby, bundleData)
    GlobalRoomLoading:stop()
end

-- 广播台费 0x400d 直接处理提示语
function CommonProcesser:onGameCostBd(data)
    AlarmTip.play(data.iMessage)
end

function CommonProcesser:onDealCardBd(data)
    data.iBankSeatId = data.iBankSeatId or 0
end

-- 登录大厅成功
function CommonProcesser:onLoginLobbyRsp(data)
    local fid = PhpManager:getFid()
    local reConnInfo = data.reConnInfo
    app:onLoginLobbySuccess()
    if app:isInRoom() and 1 == tonumber(data.iReConn) then -- 如果是在房间
        EventDispatcher.getInstance():dispatch(Event.Message, "requestReconn")
        app:requestEnterRoom(false)
    elseif app:isInRoom() and 1 ~= tonumber(data.iReConn) then
        StateChange.changeState(States.Lobby)
    elseif string.len(PhpManager:getFid()) >=6 then
        app:requestEnterInviteRoom()
    end
end

-- 换桌相关 0x1114
function CommonProcesser:onChangeDeskErr(data)
    if data.iRect == -1 then
        AlarmTip.play(data.iMsg)
    end
    G_RoomCfg:setIsQuickStart(false)
end

function CommonProcesser:_ensureGameType(data, isReconnet)
    local config = data.iConfig
    G_RoomCfg:setGameType(config.iGameType)
    if GameSupportStateMap[config.iGameType] then
        GlobalRoomLoading:onEnsureGameType(data, isReconnet)
    else
        if app:isInRoom() then
            StateChange.changeState(States.Lobby)
        end
        GlobalRoomLoading:stop()
        AlarmTip.play("暂不支持该玩法")
    end
    printInfo("进房间成功，玩法为%d", config.iGameType)
end

-- 登录房间成功
function CommonProcesser:onEnterRoomSuccess(data)
    data.iReconn = false
    self:_ensureGameType(data)
end

--广播重连成功 0x1111
function CommonProcesser:onReconnSuccess(data)
    -- 模拟玩家的手牌
    local players = data.iOtherPlayers
    for i, playerInfo in ipairs(players) do
        for k, temp in pairs(playerInfo.iHandCardTb) do
            temp.iType = 1
            if tonumber(k) <= 3 then
                temp.iType = 0
            end
        end
    end

    data.iReconn = true
    self:_ensureGameType(data, true)
end

----------------[[--公共业务]]-----------------------------
function CommonProcesser:onFreshMoneyRsp(data)
    if data.iRet == 0 then
        if data.iUserId == MyUserData:getId() then
            MyUserData:setMoney(data.iMoney)
                :setExp(data.iExp)
                :setLevel(data.iLevel)
                :setZhanji(data.iWintimes, data.iLosetimes, data.iDrawtimes)
        end
    end
end

function CommonProcesser:onFreshMoneyBd(data)
    printInfo("onFreshMoneyBd")
    local userId = data.iUserId
    if userId ~= MyUserData:getId() then return end

    local infoTb = data.iInfoTb
    local itype = tonumber(infoTb.type) or -1
    local money     = tonumber(infoTb.money) or MyUserData:getMoney()
    local turnmoney = tonumber(infoTb.turnmoney)
    local vip       = infoTb.vip
    local coinflag  = tonumber(infoTb.coinflag) or 0
    local titleflag = infoTb.titleflag
    local msg       = infoTb.msg
    local coupons   = tonumber(infoTb.coupons)
    local jewel   = tonumber(infoTb.boyaacoin or MyUserData:getJewel())
    
    if turnmoney then
        MyUserData:addMoney(turnmoney, 1 == coinflag)
        --如果是在房间场景下，则通知server(不加金币变动限制了，避免已经被php同步金币)
        if app:isInRoom() then
            GameSocketMgr:sendMsg(Command.NoticeMoneyChangeReq, {
                iUserId = MyUserData:getId(),
            })
        end
    end

    if coupons then
        MyUserData:setHuaFei(coupons)
        if 1 == coinflag then
            MyUserData:addMoney(0, 1 == coinflag)
        end
    end

    if ToolKit.isValidString(msg) then
        if titleflag == 1 then
            AlarmTip.play(msg)
        elseif titleflag == 2 then
            AlarmNotice.play(msg)
        end
    end
    -- if coinflag == 1 then
    --     AnimationParticles.play(AnimationParticles.DropCoin)
    -- end

    --首充完成
    printInfo("onFreshMoneyBd itype = "..itype)
    if itype == 119 then
        MyBaseInfoData:setFirstPay(1);
    end
end

function CommonProcesser:onServergbBroadcastGoodsData( data )
    -- body
    if not data then return end
    
    local userId = data.iUserId
    if userId ~= MyUserData:getId() then return end

    if data.curType == Command.SERVER_MATCHAWARDCARD_RES then
        AlarmTip.play(data.showStr or "获得道具")

        local data = json.decode(data.iUserInfo) or ""
        if not data then return end
        
        for k, v  in pairs(data) do
            MyGoodsData:setGoodsNumById(tonumber(k), tonumber(v))
        end
        EventDispatcher.getInstance():dispatch(HttpModule.s_event, Command.SERVERGB_BROADCAST_GOODSDATA, data);

    elseif data.curType == Command.HALL_PUSH_MONEY then
        if data.money then
            MyUserData:setMoney(data.money, true)
        end
         --如果是在房间场景下，则通知server(不加金币变动限制了，避免已经被php同步金币)
        if app:isInRoom() then
            GameSocketMgr:sendMsg(Command.NoticeMoneyChangeReq, {
                iUserId = MyUserData:getId(),
            })
        end

    elseif data.curType == Command.SERVER_MATCHAWARDHUAFEI_RES then
        if data.huafeijuan then
            MyUserData:setHuaFei(data.huafeijuan)
        end


    end

    AlarmNotice.play(data.showStr or "")
  
end

function CommonProcesser:onMapDoNothing(data)
end

--[[
	通用的（大厅）协议
]]
local onMapDoNothing = CommonProcesser.onMapDoNothing

CommonProcesser.s_severCmdEventFuncMap = {
    [Command.LoginRoomErr]      = CommonProcesser.onLoginRoomErr,   --登录房间错误
    [Command.GameCostBd]        = CommonProcesser.onGameCostBd,     -- 广播台费
    [Command.DealCardBd]        = CommonProcesser.onDealCardBd,       --广播发牌
    [Command.ReconnSuccess]     = CommonProcesser.onReconnSuccess,  --重连成功

    [Command.LobbyKickOutBd]    = CommonProcesser.onLobbyKickOutBd,  -- 大厅在线人数返回
    [Command.LoginRoomOtherErr] = CommonProcesser.onLoginRoomOtherErr,
    [Command.LoginRoomServerErr] = CommonProcesser.onLoginRoomServerErr,  --大厅异常 请求方法失败

    [Command.LoginLobbyRsp]     = CommonProcesser.onLoginLobbyRsp,                  -- 登录大厅成功
    [Command.LoginRoomRsp]      = CommonProcesser.onEnterRoomSuccess,  --进入房间成功
    [Command.ChangeDeskErr]     = CommonProcesser.onChangeDeskErr,                  -- 换桌相关错误

    --[[公共业务]]
    [Command.FreshMoneyRsp]       = CommonProcesser.onFreshMoneyRsp,
    [Command.FreshMoneyBd]      = CommonProcesser.onFreshMoneyBd,

    [Command.SERVERGB_BROADCAST_GOODSDATA]      = CommonProcesser.onServergbBroadcastGoodsData,

    -- 没有业务处理
    [Command.HeatBeatReq]         = onMapDoNothing,
    [Command.HeatBeatRsp]         = onMapDoNothing,
    [Command.LoginLobbyReq]       = onMapDoNothing,
    [Command.LobbyOnlineReq]      = onMapDoNothing,
    [Command.LobbyOnlineRsp]      = onMapDoNothing,
    [Command.LOGIN_ROOM_ERROR]    = onMapDoNothing,
    [Command.NOT_ENOUGH_MONEY]    = onMapDoNothing,
    [Command.KICK_USER_OUT]       = onMapDoNothing,
    [Command.FANG_CHEN_MI]        = onMapDoNothing,
    [Command.UserEnterBd]         = onMapDoNothing,
    [Command.RoomInfoBd]          = onMapDoNothing,
    [Command.ReadyReq]            = onMapDoNothing,
    [Command.UserReadyBd]         = onMapDoNothing,
    [Command.UserExitBd]          = onMapDoNothing,
    [Command.LogoutRoomRsp]       = onMapDoNothing,
    [Command.GameReadyStartBd]    = onMapDoNothing,
    [Command.GameStartBd]         = onMapDoNothing,
    [Command.ObserverCardBd]      = onMapDoNothing,
    [Command.UserAiBd]            = onMapDoNothing,
    [Command.SendChat]            = onMapDoNothing,
    [Command.SendFace]            = onMapDoNothing,
    [Command.SendProp]            = onMapDoNothing,
    [Command.SendFace]            = onMapDoNothing,
    [Command.SendOperate]         = onMapDoNothing,
    [Command.LogoutRoomReq]       = onMapDoNothing,
    [Command.RequestOutCard]      = onMapDoNothing,
    [Command.RequestOperate]      = onMapDoNothing,
    [Command.RequestAi]           = onMapDoNothing,
    [Command.OwnGrabCardBd]       = onMapDoNothing,
    [Command.OtherGrabCardBd]     = onMapDoNothing,
    [Command.OutCardBd]           = onMapDoNothing,
    [Command.OperateBd]           = onMapDoNothing,
    [Command.OperateCancelBd]     = onMapDoNothing,
    [Command.StopGameBd]          = onMapDoNothing,
    [Command.QiangGangHuBd]       = onMapDoNothing,
    [Command.RoomOutCardReq]      = onMapDoNothing,
    [Command.UserChat]            = onMapDoNothing,
    [Command.UserFace]            = onMapDoNothing,
    [Command.JoinGameReq]         = onMapDoNothing,
    [Command.GB_StopRoundBd]      = onMapDoNothing,
    [Command.SH_StopRoundBd]      = onMapDoNothing,
    [Command.SH_ChengBaoBd]       = onMapDoNothing,   --上海承包
    [Command.GD_StopRoundBd]      = onMapDoNothing,

    [Command.SwapCardStartBd]     = onMapDoNothing,
    [Command.SwapCardReq]         = onMapDoNothing,
    [Command.SwapCardRsp]         = onMapDoNothing,
    [Command.DoubleHuReq]         = onMapDoNothing,
    [Command.DoubleHuBd]          = onMapDoNothing,
    [Command.DoubleFinishBd]      = onMapDoNothing,
    [Command.DoubleOutCardBd]     = onMapDoNothing,
    [Command.DoubleGrabCardBd]    = onMapDoNothing,
    [Command.GfxyBd]              = onMapDoNothing,
    [Command.NoticeMoneyChangeRsp] = onMapDoNothing,
    [Command.SERVER_COMMAND_SELECT_PIAO] = onMapDoNothing,
    [Command.SERVER_COMMAND_BROADCAST_PIAO] = onMapDoNothing,
    [Command.SERVER_COMMAND_BROADCAST_START_GAME] = onMapDoNothing,
    [Command.SERVERGB_BROADCAST_PAOMADENG] = onMapDoNothing,
    [Command.SERVER_COMMAND_KICK_OUT] = onMapDoNothing,
    [Command.SERVER_COMMAND_READY_COUNT_DOWN] = onMapDoNothing,
    [Command.SERVER_COMMAND_UPDATE_USER_INFO] = onMapDoNothing,
    [Command.SERVER_COMMAND_FRIEND_REQ] = onMapDoNothing,
    [Command.SERVER_CREATEROOM_REQ] = onMapDoNothing,
    [Command.SERVER_EXIT_PRIVATEROOM_REQ] = onMapDoNothing,
    [Command.SERVER_EXIT_PRIVATEROOM_HANDLER_REQ] = onMapDoNothing,
    [Command.SERVER_BROADCAST_STOP_BATTLE] = onMapDoNothing,
}

return CommonProcesser
