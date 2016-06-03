--[[
	通用的（大厅）接收协议  2015-03-03
]]
local CommonReader = class(SocketReader)
local printInfo, printError = overridePrint("CommonReader")

function CommonReader:ctor()
	self.m_sockName = "通用"
end

--PHP 透传
function CommonReader:onPhpResponse(packetId)
	local cmd 	= self.m_socket:readInt(packetId, 0)
	local data 	= self.m_socket:readBinary(packetId)
	printInfo("读取到的命令0x%x", cmd or "nil")
	printInfo("读取到的二进制数据为%s", data or "nil")
	data = json.decode(data)
	return {["cmd"] = cmd, ['data'] = data}
end

function CommonReader:onPhpTimeout(packetId)
	local info = {}
	return info
end

function CommonReader:onHeatBeatRsp(packetId)
	printInfo("心跳包返回")
	return {}
end

function CommonReader:onLoginLobbySuccess(packetId)
	-- 废弃参数
	local listNum = self.m_socket:readInt(packetId, -1)
	for i=1, listNum do
		local num = self.m_socket:readInt(packetId, -1)
	end
	local friendNum = self.m_socket:readInt(packetId, -1)

	-- 重连信息
	local info =  {
		iReConn, --1代表重连
		reConnInfo,
	}
	info.iReConn = self.m_socket:readInt(packetId, -1)
	if(info.iReConn == 1) then
		local connInfo = {}
		connInfo.iRoomId = self.m_socket:readInt(packetId, -1)
		connInfo.iSid = self.m_socket:readInt(packetId, -1)
		connInfo.iRoomIp = self.m_socket:readString(packetId, -1)
		connInfo.iRoomPort = self.m_socket:readInt(packetId, -1)
		connInfo.iIsMatch = self.m_socket:readInt(packetId, -1)
		connInfo.iMatchId = self.m_socket:readString(packetId, -1)
		connInfo.iMatchType = self.m_socket:readInt(packetId, -1)
		connInfo.iGameType = self.m_socket:readInt(packetId, -1)
		info.reConnInfo = connInfo
	else
		info.reConnInfo = nil
	end

	return info
end

-- 在线人数 0x311
function CommonReader:onLobbyOnlineRsp(packetId)
	local info = {}
	return info
end

-- 被T出大厅 0x203
function CommonReader:onLobbyKickOutBd(packetId)
	return {}
end

function CommonReader:onChangeDeskErr(packetId)
	local info = {}
	info.iRect = self.m_socket:readInt(packetId, 0)
	info.iMsg = self.m_socket:readString(packetId)
	return info
end

-------------------房间相关-----------------------------
-- 登录房间成功 0x1110
function CommonReader:onEnterRoomSuccess(packetId)
	local loginData = {
		iConfig = {},
		iExterConfig = {},
		iMySeatId = 0,
		iMyMoney = 0,
		iPlayersInfo = {},
		iIsReady = 0,
		iOutTime = 0,
		iOpTime = 0,
		iStandard = 0,
		iIsCreate = 0,
	}
	local config = loginData.iConfig
	local playersInfo = loginData.iPlayersInfo
	local exterCfg = loginData.iExterConfig
	local selectPiao = loginData.iSelectPiao

	config.iGameType = self.m_socket:readInt(packetId, -1)
	config.iPlayType = self.m_socket:readByte(packetId, -1)
	config.iDi = self.m_socket:readInt(packetId, -1)			--底
	config.iTai = self.m_socket:readInt(packetId, -1)			--台
	config.iTotalQuan = self.m_socket:readShort(packetId, -1)	--圈

	loginData.iMySeatId = self.m_socket:readInt(packetId, -1)	--我的座位
	loginData.iMyMoney = self.m_socket:readInt(packetId, -1)		--我的钱

	-- 读取玩家的数量
	local playerCount = self.m_socket:readInt(packetId, -1)	--玩家人数
	printInfo("playerCount = %d", playerCount)
	for i = 1, playerCount do
		local temp = {}
		temp.iUserId    = self.m_socket:readInt(packetId, -1)
		temp.iSeatId    = self.m_socket:readInt(packetId, -1)
		temp.iIsReady   = self.m_socket:readInt(packetId, -1)
		temp.iUserInfo  = self.m_socket:readString(packetId)
		temp.iMoney 	= self.m_socket:readInt(packetId, -1)
		table.insert(playersInfo, temp)
	end

	-- 读取操作时间和出牌时间
	config.iOutTime 	= self.m_socket:readShort(packetId, -1)
	config.iOpTime 		= self.m_socket:readShort(packetId, -1)

	-- 为好友开房新加字段
	-- response.WriteInt(pTable->m_battle_conf.fid);  //房间号,用于客户端用这个进入房间
	-- response.WriteInt(pTable->m_battle_conf.tid);
	-- response.WriteInt(pTable->m_battle_conf.uid);
	-- response.WriteInt(pTable->m_battle_conf.mahjongCode);
	-- response.WriteInt(pTable->m_battle_conf.roundNum);
	-- response.WriteInt(pTable->m_battle_conf.playtype);
	-- response.WriteInt(pTable->m_battle_conf.basePoint);
	-- response.WriteInt(pTable->m_battle_conf.kwx_Bei);
	-- response.WriteInt(pTable->m_battle_conf.b_changeCard);
	-- response.WriteInt(pTable->m_battle_conf.isPiao);
	loginData.iIsCreate = self.m_socket:readByte(packetId, -1)	-- 房间号
	if 1 == loginData.iIsCreate then
		exterCfg.iFid = self.m_socket:readInt(packetId, -1)	-- 房间号
		exterCfg.iTid = self.m_socket:readInt(packetId, -1)	-- 无用
		exterCfg.iUid = self.m_socket:readInt(packetId, -1)	-- 无用
		exterCfg.iMjCode = self.m_socket:readInt(packetId, -1)
		exterCfg.iRoundNum = self.m_socket:readInt(packetId, -1)
		exterCfg.iPlayType = self.m_socket:readInt(packetId, -1)
		exterCfg.iBasePoint = self.m_socket:readInt(packetId, -1)
		exterCfg.iKwxBei = self.m_socket:readInt(packetId, -1)
		exterCfg.iCHangeCard = self.m_socket:readInt(packetId, -1)
		exterCfg.iIsPiao = self.m_socket:readInt(packetId, -1)
	end

	return loginData
end


function CommonReader:onReconnSuccess(packetId)
	local gameType = self.m_socket:readInt(packetId, -1)	
	if gameType == GameType.GBMJ then
		return self:onGbmjReconnSuccess(packetId, gameType)
	elseif gameType == GameType.KWXMJ then
		return self:onGdmjReconnSuccess(packetId, gameType)
	elseif gameType == GameType.SHMJ then
		return self:onShmjReconnSuccess(packetId, gameType)
	end
end

--[[国标麻将重连信息]]
function CommonReader:onGbmjReconnSuccess(packetId, gameType)
	local info = {
		iConfig = {
			iGameType = gameType,
		},
		iMySeatId = 0,
		iMyMoney = 0,
		iIsTing = 0,
		iCurQuan = 0,
		iEastSeatId = 0,
		iBankSeatId = 0,
		iShaiziNum  = 0,
		iRemainCount = 0,
		iOtherPlayers = {},     --其他玩家的信息
		iMyHandCardTb = {},     --我的手牌
		iMyExtraCards = {},  	--我的其他牌
	}
	local config = info.iConfig
	config.iPlayType = self.m_socket:readByte(packetId, -1)	-- 
	info.iMySeatId = self.m_socket:readShort(packetId, -1)
	info.iMyMoney 	= self.m_socket:readInt(packetId, -1)
	info.iIsTing = self.m_socket:readShort(packetId, -1)

	config.iTai = self.m_socket:readInt(packetId, -1)
	config.iDi = self.m_socket:readInt(packetId, -1)
	config.iTotalQuan = self.m_socket:readShort(packetId, -1)
	config.iOutTime = self.m_socket:readShort(packetId, -1)
	config.iOpTime = self.m_socket:readShort(packetId, -1)

	info.iCurQuan = self.m_socket:readShort(packetId, -1)

	info.iEastSeatId = self.m_socket:readShort(packetId, -1)
	info.iBankSeatId = self.m_socket:readShort(packetId, -1)
	info.iShaiziNum  = self.m_socket:readShort(packetId, -1)
	info.iRemainCount = self.m_socket:readShort(packetId, -1)

	local playerCount = self.m_socket:readShort(packetId, -1)
	for i=1, playerCount do
		local playerInfo = {}
		playerInfo.iUserId 		= self.m_socket:readInt(packetId, -1)
		playerInfo.iSeatId 		= self.m_socket:readShort(packetId, -1)
		playerInfo.iIsAi   		= self.m_socket:readShort(packetId, -1)
		playerInfo.iIsTing 		= self.m_socket:readShort(packetId, -1)
		playerInfo.iHandCount 	= self.m_socket:readShort(packetId, -1)
		playerInfo.iUserInfo 	= self.m_socket:readString(packetId) or ""
		playerInfo.iMoney  		= self.m_socket:readInt(packetId, -1)
		playerInfo.iExtraCards 	= self:_readGbmjReconnCardsInfo(packetId)
		-- playerInfo.iApi			= self.m_socket:readInt(packetId, 0)
		-- dump("iApi" .. playerInfo.iApi)
		table.insert(info.iOtherPlayers, playerInfo)
	end
	local handCount = self.m_socket:readShort(packetId, -1)
	for i=1, handCount do
		local card = self.m_socket:readByte(packetId, -1)
		table.insert(info.iMyHandCardTb, card)
	end
	info.iMyExtraCards = self:_readGbmjReconnCardsInfo(packetId)

	-- info.iStandard, info.iCuoHuResult = self:_readCuoHuInfo(packetId, true)
	-- config.iStandard = info.iStandard
	return info
end

-- [[国标麻将重连]]
function CommonReader:_readGbmjReconnCardsInfo(packetId)
	local cardsInfo = {}
	-- 花牌
	cardsInfo.iHuaCardTb = {}
	local huaCount = self.m_socket:readShort(packetId, -1)
	for i=1, huaCount do 
        local card = self.m_socket:readByte(packetId, -1)
        table.insert(cardsInfo.iHuaCardTb, card)
    end

    cardsInfo.iExtraCardsTb = {}
    -- 吃牌
	local chiCount = self.m_socket:readShort(packetId, -1)
	for i=1, chiCount do 
        local card = self.m_socket:readByte(packetId, -1)
        if i % 3 == 2 then
        	table.insert(cardsInfo.iExtraCardsTb, {
        		opValue = kOpeMiddleChi,
        		card = card
        	})
    	end
    end

    --碰牌
    local pengCount = self.m_socket:readShort(packetId, -1)
    for i=1,pengCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	table.insert(cardsInfo.iExtraCardsTb, {
    		opValue = kOpePeng,
    		card = card,
    	})
    end

    --杠牌
    local gangCount = self.m_socket:readShort(packetId, -1)
    for i=1,gangCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	local isAn = self.m_socket:readByte(packetId, -1)  -- 杠牌类型 0明杠 1暗杠
    	if isAn == 1 then
    		table.insert(cardsInfo.iExtraCardsTb, {
    			opValue = kOpeAnGang,
    			card = card,
    		})
    	else
			table.insert(cardsInfo.iExtraCardsTb, {
    			opValue = kOpePengGang,
    			card = card,
    		})
    	end
    end

    --出牌
    cardsInfo.iOutCardTb = {}
    local outCount = self.m_socket:readShort(packetId, -1)
    for i=1,outCount do
    	local card 	  = self.m_socket:readByte(packetId, -1)
  		local isTips  = self.m_socket:readByte(packetId, -1)   --是否碰杠过0表示没有吃碰杠过的牌 1表示吃碰杠过的牌
  		if isTips == 0 then
    		table.insert(cardsInfo.iOutCardTb, card)
    	end
    end	

    return cardsInfo
end

--[[ 广东麻将重连 ]]
function CommonReader:onGdmjReconnSuccess(packetId, gameType)
	printInfo("卡五星先用这个接口")
	local info = {
		iConfig = {
			iGameType = gameType,
		},
		iMySeatId = 0,
		iMyMoney = 0,
		iIsTing = 0,
		iCurQuan = 0,
		iEastSeatId = 0,
		iBankSeatId = 0,
		iShaiziNum  = 0,
		iRemainCount = 0,
		iOtherPlayers = {},     --其他玩家的信息
		iMyHandCardTb = {},     --我的手牌
		iMyExtraCards = {},  	--我的其他牌
		iPrivateFlag = 0,		-- 是否私人房 0 不是 1 是
		iExterConfig = {},	-- 私人房配置
		iPlayerCount = 0,

		-- 广东
		iDoubleInfos = {}, --鸡平胡 加倍信息
	}
	local config = info.iConfig
	config.iPlayType = self.m_socket:readByte(packetId, -1)	-- --(1表示鸡平胡,2推倒胡) 
	-- config.iLevel    = self.m_socket:readInt(packetId, -1)
	-- local playType 	 = self.m_socket:readShort(packetId, -1) --麻将类型

	info.iMySeatId = self.m_socket:readShort(packetId, -1)
	info.iMyMoney 	= self.m_socket:readInt(packetId, -1)
	info.iIsTing = self.m_socket:readShort(packetId, -1)
	info.iIsSelectPiao = self.m_socket:readByte(packetId, -1)
	info.iPiao = self.m_socket:readInt(packetId, -1)
	info.iIsLiang = self.m_socket:readInt(packetId, -1)

	config.iTai = self.m_socket:readInt(packetId, -1)
	config.iDi = self.m_socket:readInt(packetId, -1)
	config.iTotalQuan = self.m_socket:readShort(packetId, -1)
	config.iOutTime = self.m_socket:readShort(packetId, -1)
	config.iOpTime = self.m_socket:readShort(packetId, -1)

	info.iCurQuan = self.m_socket:readShort(packetId, -1)

	info.iEastSeatId = self.m_socket:readShort(packetId, -1)
	info.iBankSeatId = self.m_socket:readShort(packetId, -1)
	info.iShaiziNum  = self.m_socket:readShort(packetId, -1)
	info.iRemainCount = self.m_socket:readShort(packetId, -1)

	info.iPlayerCount = self.m_socket:readShort(packetId, -1)
	for i = 1, info.iPlayerCount do
		local playerInfo = {}
		playerInfo.iUserId 		= self.m_socket:readInt(packetId, -1)
		playerInfo.iSeatId 		= self.m_socket:readShort(packetId, -1)
		playerInfo.iIsAi   		= self.m_socket:readShort(packetId, -1)
		playerInfo.iIsTing 		= self.m_socket:readShort(packetId, -1)
		playerInfo.iHandCount 	= self.m_socket:readShort(packetId, -1)
		playerInfo.iUserInfo 	= self.m_socket:readString(packetId) or ""
		playerInfo.iMoney  		= self.m_socket:readInt(packetId, -1)
		playerInfo.iPiao = self.m_socket:readInt(packetId, -1)
		playerInfo.iIsLiang = self.m_socket:readInt(packetId, -1)
		playerInfo.iExtraCards 	= self:_readGdmjReconnCardsInfo(packetId)
		playerInfo.iHuCard 		= {}
		local iHandCardTb = {}
		local handCount = self.m_socket:readShort(packetId, 0)
		for i = 1, handCount do
			local temp = {}
			temp.iCard = self.m_socket:readByte(packetId, 0)
			temp.iType = self.m_socket:readByte(packetId, 0)
			iHandCardTb[#iHandCardTb + 1] = temp
		end
		playerInfo.iIsCatch = self.m_socket:readByte(packetId, 0)
		if 1 == playerInfo.iIsCatch then
			playerInfo.iCatchCard = self.m_socket:readByte(packetId, 0)
		end
		playerInfo.iHandCardTb = iHandCardTb
		table.insert(info.iOtherPlayers, playerInfo)
		
	end
	local handCount = self.m_socket:readShort(packetId, -1)
	for i=1, handCount do
		local temp = {}
		temp.iCard = self.m_socket:readByte(packetId, 0)
		temp.iType = self.m_socket:readByte(packetId, 0)
		table.insert(info.iMyHandCardTb, temp)
	end
	info.iIsCatch = self.m_socket:readByte(packetId, 0)
	if 1 == info.iIsCatch then
		info.iCatchCard = self.m_socket:readByte(packetId, 0)
	end
	info.iMyExtraCards = self:_readGdmjReconnCardsInfo(packetId)

	for i = 1, info.iPlayerCount do
		local huCardCound 	= self.m_socket:readInt(packetId, -1)
		for j = 1, huCardCound do
			local card = self.m_socket:readByte(packetId, 0)
			table.insert(info.iOtherPlayers[i].iHuCard, card)
		end
	end

	info.iPrivateFlag = self.m_socket:readByte(packetId, -1)
	if 1 == info.iPrivateFlag then
		local exterConfig = info.iExterConfig
		exterConfig.iFid = self.m_socket:readInt(packetId, -1)
		exterConfig.iTid = self.m_socket:readInt(packetId, -1)
		exterConfig.iUid = self.m_socket:readInt(packetId, -1)
		exterConfig.iMjCode = self.m_socket:readInt(packetId, -1)
		exterConfig.iRoundNum = self.m_socket:readInt(packetId, -1)
		exterConfig.iPlayType = self.m_socket:readInt(packetId, -1)
		exterConfig.iBasePoint = self.m_socket:readInt(packetId, -1)
		exterConfig.iBei = self.m_socket:readInt(packetId, -1)
		exterConfig.iChangeCard = self.m_socket:readInt(packetId, -1)
		exterConfig.iIsPiao = self.m_socket:readInt(packetId, -1)
		exterConfig.iCurJu = self.m_socket:readInt(packetId, -1)
		exterConfig.iPlayCount = self.m_socket:readInt(packetId, -1)

		exterConfig.iPlayInfo = {}
		for i = 1, exterConfig.iPlayCount do
			local playItem = {}
			playItem.iUserId = self.m_socket:readInt(packetId, -1)
			playItem.iSeatId = self.m_socket:readShort(packetId, -1)
			playItem.iScoreTab = {}
			for j = 1, exterConfig.iCurJu - 1 do
				local score = self.m_socket:readInt(packetId, -1)
				table.insert(playItem.iScoreTab, score)
			end
			table.insert(exterConfig.iPlayInfo, playItem)
		end
	end 


	return info
end

--[[广东麻将重连麻将子信息]]
function CommonReader:_readGdmjReconnCardsInfo(packetId)
	local cardsInfo = {}
	-- 花牌
	cardsInfo.iHuaCardTb = {}
	local huaCount = self.m_socket:readShort(packetId, -1)
	for i=1, huaCount do 
        local card = self.m_socket:readByte(packetId, -1)
        table.insert(cardsInfo.iHuaCardTb, card)
    end

    cardsInfo.iExtraCardsTb = {}
    -- 吃牌
	local chiCount = self.m_socket:readShort(packetId, -1)
	for i=1, chiCount do 
        local card = self.m_socket:readByte(packetId, -1)
        if i % 3 == 2 then
        	table.insert(cardsInfo.iExtraCardsTb, {
        		opValue = kOpeMiddleChi,
        		card = card
        	})
    	end
    end

    --碰牌
    local pengCount = self.m_socket:readShort(packetId, -1)
    printInfo("碰的数目%d", pengCount)
    for i=1,pengCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	printInfo("杠的数目0x%04x", card)
    	table.insert(cardsInfo.iExtraCardsTb, {
    		opValue = kOpePeng,
    		card = card,
    	})
    end

    --杠牌
    local gangCount = self.m_socket:readShort(packetId, -1)
    printInfo("杠的数目%d", gangCount)
    for i=1,gangCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	local isAn = self.m_socket:readByte(packetId, -1)  -- 杠牌类型 0明杠 1暗杠
    	printInfo("杠的数目0x%04x", card)
    	if isAn == 1 then
    		table.insert(cardsInfo.iExtraCardsTb, {
    			opValue = kOpeAnGang,
    			card = card,
    		})
    	else
			table.insert(cardsInfo.iExtraCardsTb, {
    			opValue = kOpePengGang,
    			card = card,
    		})
    	end
    end

    --出牌
    cardsInfo.iOutCardTb = {}
    local outCount = self.m_socket:readShort(packetId, -1)
    for i=1,outCount do
    	local card 	  = self.m_socket:readByte(packetId, -1)
  		local isTips  = self.m_socket:readByte(packetId, -1)   --是否碰杠过0表示没有吃碰杠过的牌 1表示吃碰杠过的牌
  		if isTips == 0 then
    		table.insert(cardsInfo.iOutCardTb, card)
    	end
    end	

    return cardsInfo
end

function CommonReader:onShmjReconnSuccess(packetId, gameType)
	local info = {
		iConfig = {
			iGameType = gameType,
		},
		iMySeatId = 0,
		iMyMoney = 0,
		iIsTing = 0,
		iCurQuan = 0,
		iEastSeatId = 0,
		iBankSeatId = 0,
		iShaiziNum  = 0,
		iRemainCount = 0,
		iOtherPlayers = {},     --其他玩家的信息
		iMyHandCardTb = {},     --我的手牌
		iMyExtraCards = {},  	--我的其他牌

		-- 广东
		iDoubleInfos = {}, --鸡平胡 加倍信息
	}
	local config = info.iConfig
	config.iPlayType  = self.m_socket:readByte(packetId, -1)
	info.iMySeatId = self.m_socket:readShort(packetId, -1)
	info.iMyMoney 	= self.m_socket:readInt(packetId, -1)
	info.iIsTing = self.m_socket:readShort(packetId, -1)

	config.iDi = self.m_socket:readInt(packetId, -1)
	config.iTai = self.m_socket:readInt(packetId, -1)

	config.iTotalQuan = self.m_socket:readShort(packetId, -1)
	config.iSH_LeZi = self.m_socket:readShort(packetId, -1)
	config.iSH_DiFen = self.m_socket:readShort(packetId, -1)
	config.iSH_HuaZhi = self.m_socket:readShort(packetId, -1)
	config.iSH_HuangZhuang = self.m_socket:readShort(packetId, -1)
	config.iSH_KaiBao = self.m_socket:readShort(packetId, -1)

	config.iOutTime = self.m_socket:readShort(packetId, -1)
	config.iOpTime = self.m_socket:readShort(packetId, -1)

	dump(info)
	config.iCurQuan = self.m_socket:readShort(packetId, -1)
	
	info.iEastSeatId = self.m_socket:readShort(packetId, -1)
	info.iBankSeatId = self.m_socket:readShort(packetId, -1)
	info.iShaiziNum  = self.m_socket:readShort(packetId, -1)
	info.iRemainCount = self.m_socket:readShort(packetId, -1)

	dump(info)

	local playerCount = self.m_socket:readShort(packetId, -1)
	dump(info)

	for i=1, playerCount do
		local playerInfo = {}
		playerInfo.iUserId 		= self.m_socket:readInt(packetId, -1)
		playerInfo.iSeatId 		= self.m_socket:readShort(packetId, -1)
		playerInfo.iIsAi   		= self.m_socket:readShort(packetId, -1)
		playerInfo.iIsTing 		= self.m_socket:readShort(packetId, -1)
		playerInfo.iHandCount 	= self.m_socket:readShort(packetId, -1)
		playerInfo.iUserInfo 	= self.m_socket:readString(packetId) or ""
		playerInfo.iMoney  		= self.m_socket:readInt(packetId, -1)
		playerInfo.iExtraCards 	= self:_readShmjReconnCardsInfo(packetId)
		table.insert(info.iOtherPlayers, playerInfo)
	end
	local handCount = self.m_socket:readShort(packetId, -1)
	for i=1, handCount do
		local card = self.m_socket:readByte(packetId, -1)
		table.insert(info.iMyHandCardTb, card)
	end
	info.iMyExtraCards = self:_readShmjReconnCardsInfo(packetId)
	return info
end

--[[ 上海重连麻将子信息 ]]
-- [[国标麻将重连]]
function CommonReader:_readShmjReconnCardsInfo(packetId)
	local cardsInfo = {}
	-- 花牌
	cardsInfo.iHuaCardTb = {}
	local huaCount = self.m_socket:readShort(packetId, -1)
	for i=1, huaCount do 
        local card = self.m_socket:readByte(packetId, -1)
        table.insert(cardsInfo.iHuaCardTb, card)
    end

    cardsInfo.iExtraCardsTb = {}
    -- 吃牌
	local chiCount = self.m_socket:readShort(packetId, -1)
	for i=1, chiCount do 
        local card = self.m_socket:readByte(packetId, -1)
        if i % 3 == 2 then
        	table.insert(cardsInfo.iExtraCardsTb, {
        		opValue = kOpeMiddleChi,
        		card = card
        	})
    	end
    end

    --碰牌
    local pengCount = self.m_socket:readShort(packetId, -1)
    for i=1,pengCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	table.insert(cardsInfo.iExtraCardsTb, {
    		opValue = kOpePeng,
    		card = card,
    	})
    end

    --杠牌
    local gangCount = self.m_socket:readShort(packetId, -1)
    for i=1,gangCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	local isAn = self.m_socket:readByte(packetId, -1)  -- 杠牌类型 0明杠 1暗杠
    	if isAn == 1 then
    		table.insert(cardsInfo.iExtraCardsTb, {
    			opValue = kOpeAnGang,
    			card = card,
    		})
    	else
			table.insert(cardsInfo.iExtraCardsTb, {
    			opValue = kOpePengGang,
    			card = card,
    		})
    	end
    end

    --出牌
    cardsInfo.iOutCardTb = {}
    local outCount = self.m_socket:readShort(packetId, -1)
    for i=1,outCount do
    	local card 	  = self.m_socket:readByte(packetId, -1)
  		local isTips  = self.m_socket:readByte(packetId, -1)   --是否碰杠过0表示没有吃碰杠过的牌 1表示吃碰杠过的牌
  		if isTips == 0 then
    		table.insert(cardsInfo.iOutCardTb, card)
    	end
    end	

    return cardsInfo
end

-- 登录房间出错 0x1005
function CommonReader:onLoginRoomErr(packetId)
	local info = {
		iErrType = -1,
	}
	info.iErrType = self.m_socket:readInt(packetId, 0)
	if info.iErrType == Command.LOGIN_ROOM_ERROR then
		info.iTableId = self.m_socket:readInt(packetId, -1)
	elseif info.iErrType == Command.NOT_ENOUGH_MONEY then
		info.iGameType = self.m_socket:readInt(packetId, -1)
		info.iNeedMoney = self.m_socket:readInt(packetId, -1)
	elseif info.iErrType == Command.FANG_CHEN_MI then
		info.iTime = self.m_socket:readInt(packetId, -1)
	end
	return info
end

-- 登录房间 其他错误 0x1006
function CommonReader:onLoginRoomOtherErr(packetId)
	local info = {
		iErrType = -1,
	}
    info.iErrType = self.m_socket:readInt(packetId, -1) 
    return info
end

function CommonReader:onLoginRoomServerErr(packetId)
	local info = {}
	-- 没用到
	local msg = self.m_socket:readString(packetId)
	return info
end

-- 广播房间等级 0x1112
function CommonReader:onRoomInfoBd(packetId)
	local info = {
		iGameType  = 0,
		iLevel 		= -1,
		iTableType 	= -1,
		iTableId 	= -1,
		iRoomName 	= -1,
		iIsPiao    = -1,
	}
	info.iGameType = self.m_socket:readInt(packetId, -1)
	info.iLevel = self.m_socket:readInt(packetId, -1)
    info.iTableType = self.m_socket:readInt(packetId, -1)  	--- 麻将code：9代表国标
    info.iTableId = self.m_socket:readInt(packetId, -1)
    info.iRoomName = self.m_socket:readString(packetId)   	 		---- 房间名
    info.iIsPiao = self.m_socket:readInt(packetId, 0)    -- 是否是选漂场
	return info
end

-- 广播台费 0x400d
function CommonReader:onGameCostBd(packetId)
	local info = {
		iMessage = nil,
	}
	info.iMessage = self.m_socket:readString(packetId, -1)
	return info
end

-- 广播玩家进入 0x100D
function CommonReader:onUserEnter(packetId)
	local info = 
	{
		iUserId = -1,
		iSeatId = -1,
		iIsReady = -1,
		iUserInfo = nil,
		iMoney = nil,
		iOriginApi = nil
	}
	info.iUserId  		= self.m_socket:readInt(packetId, -1)
	info.iSeatId  		= self.m_socket:readInt(packetId, -1)
	info.iIsReady 		= self.m_socket:readInt(packetId, -1)
	info.iUserInfo 		= self.m_socket:readString(packetId, -1)
	info.iMoney 		= self.m_socket:readInt(packetId, -1)
	info.iOriginApi 	= self.m_socket:readInt(packetId, 0)
	return info
end

-- 广播玩家准备 0x4001
function CommonReader:onUserReady(packetId)
	local info = {
		iUserId = -1
	}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	return info
end

-- 玩家退出房间 0x1008
function CommonReader:onUserExit(packetId)
	local info = {
		iUserId = -1
	}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	return info
end

-- 登出房间成功
function CommonReader:onLogoutRoomRsp(packetId)
	local info = {}
	info.iExitType = self.m_socket:readInt(packetId, -1)
	return info
end

-- 玩牌相关
-- 广播开局 0x4002
function CommonReader:onGameReadyStartBd(packetId)
	local info = {
		iBankSeatId = -1,
	}
	-- 定庄家 -- 在国标麻将中 发这个命令字就代表东风东局了
	info.iBankSeatId = self.m_socket:readInt(packetId, -1)
	return info
end

-- 聊天相关 聊天消息 0x1003
function CommonReader:onUserChat(packetId) 
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iChatInfo = self.m_socket:readString(packetId)
	return info
end

-- 聊天相关 表情相关 0x1004
function CommonReader:onUserFace(packetId)
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iFaceType = self.m_socket:readInt(packetId, -1)
	return info
end

function CommonReader:onUserProp(packetId)
	local info = {}
	info.flag = self.m_socket:readInt(packetId , -1)
	if info.flag == 0 then
		info.msg = self.m_socket:readString(packetId)
		return info
	end
	info.mid = self.m_socket:readInt(packetId , -1)
	info.changeMoney = self.m_socket:readInt(packetId , -1)
	info.count = self.m_socket:readInt(packetId , -1)
	info.data = {}
	for i = 1, info.count do
		local tab = {}
		tab.tagmid = self.m_socket:readInt(packetId , -1)	--赠送者ID,赠给谁了
		tab.pid = self.m_socket:readInt(packetId , -1)		--道具类型
		tab.charm = self.m_socket:readInt(packetId , -1)	--魅力值 二人无用
		table.insert(info.data , tab)
	end
	return info
end

-- 玩牌 广播玩家Ai 0x4007
function CommonReader:onUserAiBd(packetId)
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iAiType = self.m_socket:readInt(packetId, -1)
	return info
end

-- 换三张相关
--0x3012  --服务器通知开始换牌
function CommonReader:onSwapCardStartBd(packetId)
	local info = {
		iHuanNum = 0,
		iHuanTime = 0,
		iHuanCards = {}
	}
	info.iHuanNum = self.m_socket:readByte(packetId, -1)
	info.iHuanTime = self.m_socket:readByte(packetId, -1)
	for i=1, info.iHuanNum do
		local card = self.m_socket:readByte(packetId, -1)
		table.insert(info.iHuanCards, card)
	end
	return info
end

--0x3013  --换牌返回
function CommonReader:onSwapCardRsp(packetId)
	local info = {
		iHandCards = {},
		iExchangeCards = {},
	}
	info.iHandCards = self:readCardsTb(packetId)
	info.iExchangeCards = self:readCardsTb(packetId)
	return info
end

 -- 花牌 以及 (byte类型的数量)的牌
function CommonReader:readCardsTb(packetId)
	local cardsTb = {}
    local cardCount = self.m_socket:readByte(packetId, -1)
    for i=1, cardCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	table.insert(cardsTb, card)
    end
    return cardsTb
end

function CommonReader:onOperateCancelBd(packetId)
	local info = {
		iUserId = 0,
		iSeatId = 0,
		iOutTime = 0,
	}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iSeatId = self.m_socket:readInt(packetId, -1)
	info.iOutTime = self.m_socket:readShort(packetId, -1)
	return info
end

----------------[[--公共业务]]-----------------------------
-- 0x6400
function CommonReader:onFreshMoneyRsp(packetId)
	local userId = self.m_socket:readInt(packetId, -1)
	self.m_socket:readShort(packetId, -1)
	local ret = self.m_socket:readByte(packetId, -1)
	local info = {
		iRet = ret,
		iUserId = userId
	}
	if ( 0 == ret ) then
		info.iMoney 	= self.m_socket:readInt(packetId, 0)
		info.iExp 		= self.m_socket:readInt(packetId, 0)
		info.iLevel 	= self.m_socket:readInt(packetId, 0)
		info.iWintimes 	= self.m_socket:readInt(packetId, 0)
		info.iLosetimes = self.m_socket:readInt(packetId, 0)
		info.iDrawtimes = self.m_socket:readInt(packetId, 0)
	end
 	return info
end

-- 广播一局结束 0x4021
function CommonReader:onStopRoundBd(packetId)
	local info = {}  
	printInfo("卡五星麻将结算了")
	info.iTaiFei = self.m_socket:readInt(packetId, -1)
	info.iDiZhu = self.m_socket:readInt(packetId, -1)
	info.iResultType = self.m_socket:readShort(packetId, -1)
	info.iRoundTime = self.m_socket:readInt(packetId, -1)
	info.iPlayerCount = self.m_socket:readInt(packetId, -1)
	info.iHuType = self.m_socket:readByte(packetId, -1)
	info.iPlayerInfo = {}
	for i = 1, info.iPlayerCount do
		local player = {}
		player.iUserId = self.m_socket:readInt(packetId, -1)
		player.iSeatId = self.m_socket:readByte(packetId, -1)
		player.iHuType = self.m_socket:readByte(packetId, -1)
		player.iPiao = self.m_socket:readInt(packetId, -1)
		player.iIsLiang = self.m_socket:readInt(packetId, -1)
		player.iMoney = self.m_socket:readInt(packetId, -1)
		player.iTurnMoney = self.m_socket:readInt(packetId, -1)
		player.iGangMoney = self.m_socket:readInt(packetId, -1)
		player.iLevel = self.m_socket:readInt(packetId, -1)
		player.iIsLevelUp = self.m_socket:readByte(packetId, -1)
		player.iLevelReward = self.m_socket:readInt(packetId, -1)
		player.iIsPiao = self.m_socket:readByte(packetId, -1)
		if player.iIsPiao > 0 then
			player.iPiaoTurnMoney = self.m_socket:readInt(packetId, -1)
		end
		player.iOpCount = self.m_socket:readShort(packetId, -1)
		player.iOpTable = {}
		for j = 1, player.iOpCount do
			local temp = {}
			temp.iCard = self.m_socket:readByte(packetId, -1)
			temp.iOpValue = self.m_socket:readByte(packetId, -1)
			table.insert(player.iOpTable, temp)
		end
		player.iCardCount = self.m_socket:readShort(packetId, -1)
		player.iInhandCrads = {}
		for j = 1, player.iCardCount do
			table.insert(player.iInhandCrads, self.m_socket:readByte(packetId, -1))
		end
		player.iIsHu = self.m_socket:readByte(packetId, -1)
		if player.iIsHu > 0 then
			player.iHuCard = self.m_socket:readByte(packetId, -1)
		end
		player.iFanCount = self.m_socket:readShort(packetId, -1)
		player.iFanTable = {}
		for j = 1, player.iFanCount do
			local temp = {}
			temp.iFan = self.m_socket:readInt(packetId, -1)
			temp.iFanName = self.m_socket:readString(packetId)
			table.insert(player.iFanTable, temp)
		end
		player.iTotalFan = self.m_socket:readInt(packetId, -1)
		player.iMingMoney = self.m_socket:readInt(packetId, -1)
		table.insert(info.iPlayerInfo, player)
	
	end

	-- 开房总结算
	info.iIsPrivate = self.m_socket:readInt(packetId, -1)
	if 1 == info.iIsPrivate then
		info.iPrivateRoom = {}
		info.iPrivateRoom.iPlayCount = self.m_socket:readInt(packetId, -1)
		info.iPrivateRoom.iPlayInfo = {}
		for i = 1, info.iPrivateRoom.iPlayCount do
			local temp = {}
			temp.iUserId = self.m_socket:readInt(packetId, -1)
			temp.iSeatId = self.m_socket:readByte(packetId, -1)
			temp.iScore = self.m_socket:readInt(packetId, -1)
			table.insert(info.iPrivateRoom.iPlayInfo, temp)
		end
	end
	
	return info
end

-- 收到金币变动通知
function CommonReader:onFreshMoneyBd(packetId)
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, 0)
	local infoStr = self.m_socket:readString(packetId)
	info.iInfoTb = json.decode(infoStr) or {}
	dump(info.iInfoTb)
	return info
end

-- 金币变动返回 0x2023
function CommonReader:onNoticeMoneyChangeRsp(packetId)
	local info = {
		iUserInfoJsons = {}
	}
	local count = self.m_socket:readByte(packetId, 0)
	for i=1, count do
		local jsonStr = self.m_socket:readString(packetId)
		table.insert(info.iUserInfoJsons, jsonStr)
	end
	return info
end

-- 广播用户破产
function CommonReader:serverBroadcastBankrupt(packetId)
	local info = {}
	local count = self.m_socket:readShort(packetId, 0)
	for i = 1 , count do
		local user = {}
		user.mid = self.m_socket:readInt(packetId, 0)
		user.money = self.m_socket:readInt64(packetId, 0)
		table.insert(info, user)
	end
	return info
end

-- 广播开始选漂
function CommonReader:onServerStartSelectPiao(packetId)
	local info = {}
	info.iSelectTime = self.m_socket:readInt(packetId, 0)
	info.iSelectNum = self.m_socket:readInt(packetId, 0)
	info.iSelectTable = {}
	for i = 1 , info.iSelectNum do 
		local temp = self.m_socket:readInt(packetId, 0)
		table.insert(info.iSelectTable, temp)
	end
	return info
end

-- 广播玩家选定漂
function CommonReader:onServerBroadcastSelectPiao(packetId)
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, 0)
	info.iPiao = self.m_socket:readInt(packetId, 0)
	return info
end

-- 广播游戏开始
function CommonReader:onServerBroadcastGameStart(packetId)
	local info = {}
	info.iCurRound= self.m_socket:readInt(packetId, -1)
	return info
end

-- 广播跑马灯
function CommonReader:onServerBroadcastPaoMaDeng(packetId)
 	local info = {}
  	-- 系统 = 1，公告 = 2，玩家 = 3
  	info.iMsgType = self.m_socket:readInt(packetId, 0)
  	info.iMsgTimes = self.m_socket:readInt(packetId, 0)
  	-- 去掉没用的
  	info.iMsg = self.m_socket:readString(packetId, "")
  	info.iMsgStamp = self.m_socket:readInt(packetId, 0)

 	info.data = self.m_socket:readString(packetId, "")
 	return info
end 

function CommonReader:onServerKickOut(packetId)
	local info = {}
	return info
end

function CommonReader:onServerShowReadyTime(packetId)
	local info = {}
	info.iTime = self.m_socket:readByte(packetId, -1)
	info.iReadyCount = self.m_socket:readByte(packetId, -1)
	for i = 1, info.iReadyCount do
		self.m_socket:readInt(packetId, -1)
	end
	return info
end

function CommonReader:onServerUpdateUserInfo(packetId)
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iUserInfo = self.m_socket:readString(packetId, "")
	return info
end

function CommonReader:onServerHornPlayerInfo( packetId )
	-- body
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iUserInfo = self.m_socket:readString(packetId, "")
	return info
end

function CommonReader:onServergbBroadcastGoodsData( packetId )
	-- body
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.curType = self.m_socket:readShort(packetId, -1)
	
	if info.curType == Command.SERVER_MATCHAWARDCARD_RES then
		info.iUserInfo = self.m_socket:readString(packetId, "")
		info.showFlag = self.m_socket:readInt(packetId, -1)
		info.showStr = self.m_socket:readString(packetId, "")

	elseif info.curType == Command.HALL_PUSH_MONEY then
		info.money = self.m_socket:readInt(packetId, -1)
		info.showFlag = self.m_socket:readInt(packetId, -1)
		info.showStr = self.m_socket:readString(packetId, "")

	elseif info.curType == Command.HALL_SERVER_UPDATE_MONEY then
		local subTab = {}
		subTab.reason = self.m_socket:readByte(packetId, -1)
		subTab.money = self.m_socket:readInt(packetId, -1)
		subTab.bycoin = self.m_socket:readInt(packetId, -1)
		subTab.msg = self.m_socket:readString(packetId, "")
		subTab.chips = self.m_socket:readInt(packetId, -1)
		subTab.ptype = self.m_socket:readInt(packetId, -1)
		subTab.pmode = self.m_socket:readInt(packetId, -1)

		info.updateMoneyTable = subTab

	elseif info.curType == Command.SERVER_MATCHAWARDHUAFEI_RES then
		info.huafeijuan = self.m_socket:readInt(packetId, -1)
		info.showFlag = self.m_socket:readInt(packetId, -1)
		info.showStr = self.m_socket:readString(packetId, "")
	end
	
	return info
end

function CommonReader:onFriendInfoReq(packetId)
	local info = {}
	info.mid = self.m_socket:readInt(packetId, -1)
	info.command = self.m_socket:readShort(packetId, -1)
	
	if Command.FRIEND_CMD_ENDTY_CHANNEL == info.command then
		info.userList = {}
		info.userNum = self.m_socket:readInt(packetId, -1)
		for i = 1, info.userNum do
			local userId = self.m_socket:readInt(packetId, -1)
			table.insert(info.userList, userId)
		end

	elseif Command.FRIEND_CMD_EXIT_CHANNEL == info.command then
		info.userNum = self.m_socket:readInt(packetId, -1)
		info.iMid = self.m_socket:readInt(packetId, -1)


	elseif Command.FRIEND_CMD_ADD_CHANNEL_FRI == info.command then
		info.sucList = {}
		info.faiList = {}
		info.sucstate = self.m_socket:readInt(packetId, -1)
		local userNum = self.m_socket:readInt(packetId, -1)
		for i = 1, userNum do
			table.insert(info.sucList, self.m_socket:readInt(packetId, -1))
		end
		info.faistate = self.m_socket:readInt(packetId, -1)
		userNum = self.m_socket:readInt(packetId, -1)
		for i = 1, userNum do
			table.insert(info.faiList, self.m_socket:readInt(packetId, -1))
		end
	end
	
	return info
end

function CommonReader:onCreateRoomReq(packetId)
	local info = {}
	return info
end

function CommonReader:onExitPrivateRoomReq(packetId)
	local info = {}
	info.iExitUid = self.m_socket:readInt(packetId, -1)
	return info
end

function CommonReader:onExitPrivateRoomHandlerReq( packetId )
	local info = {}
	return info
end

function CommonReader:onBroadcastStopBattle( packetId )
	local info = {}

	-- 开房总结算
	info.iPrivateRoom = {}
	info.iPrivateRoom.iPlayCount = self.m_socket:readInt(packetId, -1)
	info.iPrivateRoom.iPlayInfo = {}
	for i = 1, info.iPrivateRoom.iPlayCount do
		local temp = {}
		temp.iUserId = self.m_socket:readInt(packetId, -1)
		temp.iSeatId = self.m_socket:readByte(packetId, -1)
		temp.iScore = self.m_socket:readInt(packetId, -1)
		table.insert(info.iPrivateRoom.iPlayInfo, temp)
	end

	return info
end
--[[
	通用的（大厅）接收协议
]]
CommonReader.s_severCmdFunMap = {
	[Command.PHP_CMD_RESPONSE]	= CommonReader.onPhpResponse,
	[Command.SERVER_CMD_PHP_OUT_TIME] = CommonReader.onPhpTimeout,
	[Command.HeatBeatRsp]		= CommonReader.onHeatBeatRsp,

	-- 大厅业务命令字
	[Command.LoginLobbyRsp]		= CommonReader.onLoginLobbySuccess,
	[Command.LobbyOnlineRsp]    = CommonReader.onLobbyOnlineRsp,  -- 大厅在线人数返回
	[Command.LobbyKickOutBd]    = CommonReader.onLobbyKickOutBd,  -- 被t
    [Command.ChangeDeskErr]     = CommonReader.onChangeDeskErr,   -- 换桌相关错误

	-- 房间公共命令字
	-- 登录相关
	[Command.LoginRoomRsp] 		= CommonReader.onEnterRoomSuccess,	--进入房间成功
	[Command.ReconnSuccess]     = CommonReader.onReconnSuccess,	--重连成功

	[Command.LoginRoomErr] 		= CommonReader.onLoginRoomErr,	--进入房间成功
	[Command.LoginRoomOtherErr] = CommonReader.onLoginRoomOtherErr,
	[Command.LoginRoomServerErr] = CommonReader.onLoginRoomServerErr,  --大厅异常 请求方法失败
	[Command.RoomInfoBd]		= CommonReader.onRoomInfoBd,  -- 广播房间等级
	[Command.GameCostBd]		= CommonReader.onGameCostBd,  -- 广播台费

	-- 玩家
	[Command.UserEnterBd] 		= CommonReader.onUserEnter,			--广播玩家进入
	[Command.UserReadyBd] 		= CommonReader.onUserReady,			--广播准备
	[Command.UserExitBd] 		= CommonReader.onUserExit,			--广播玩家推出房间
	[Command.LogoutRoomRsp] 	= CommonReader.onLogoutRoomRsp,		--退出房间返回

	-- 玩牌开局相关
	[Command.GameReadyStartBd] 	= CommonReader.onGameReadyStartBd,	--广播游戏开始
	[Command.UserAiBd] 			= CommonReader.onUserAiBd, 			-- 玩家托管
	-- 聊天相关
	[Command.UserChat]          = CommonReader.onUserChat,          -- 玩家发送聊天及表情
	[Command.UserFace]          = CommonReader.onUserFace,          -- 玩家发送表情
	[Command.UserProp]          = CommonReader.onUserProp,          -- 玩家发送表情

	-- 换三张
	[Command.SwapCardStartBd]   = CommonReader.onSwapCardStartBd,  --0x3012  --服务器通知开始换牌
	[Command.SwapCardRsp]       = CommonReader.onSwapCardRsp,  	--0x3013  --换牌返回
	[Command.OperateCancelBd] 	= CommonReader.onOperateCancelBd, --0x4023 --有玩家操作取消

	--刷新用户金币
	[Command.FreshMoneyRsp]     = CommonReader.onFreshMoneyRsp,  	--0x6400  --请求刷新信息返回
	[Command.FreshMoneyBd]      = CommonReader.onFreshMoneyBd,  	--0x3013  --换牌返回

	[Command.NoticeMoneyChangeRsp] = CommonReader.onNoticeMoneyChangeRsp,

	[Command.GD_StopRoundBd]    = CommonReader.onStopRoundBd,		--广播牌局结束

	[Command.SERVERGB_BROADCAST_BANKRUPT]  = CommonReader.serverBroadcastBankrupt, -- 广播玩家破产
	[Command.SERVER_COMMAND_SELECT_PIAO]	= CommonReader.onServerStartSelectPiao,	-- 广播开始选漂
	[Command.SERVER_COMMAND_BROADCAST_PIAO] = CommonReader.onServerBroadcastSelectPiao, -- 广播玩家选漂
	[Command.SERVER_COMMAND_BROADCAST_START_GAME] = CommonReader.onServerBroadcastGameStart, -- 广播玩家选漂

	[Command.SERVERGB_BROADCAST_PAOMADENG]	= CommonReader.onServerBroadcastPaoMaDeng, -- 广播跑马灯
	[Command.SERVERGB_BROADCAST_GOODSDATA]      = CommonReader.onServergbBroadcastGoodsData,
	[Command.SERVER_COMMAND_KICK_OUT]		= CommonReader.onServerKickOut, -- 踢出
	[Command.SERVER_COMMAND_READY_COUNT_DOWN]	= CommonReader.onServerShowReadyTime, -- 准备倒计时
	[Command.SERVER_COMMAND_UPDATE_USER_INFO]	= CommonReader.onServerUpdateUserInfo,

	-- 好友相关
	[Command.SERVER_COMMAND_FRIEND_REQ] = CommonReader.onFriendInfoReq,

	-- 好友对战申请创建房间
	[Command.SERVER_CREATEROOM_REQ] = CommonReader.onCreateRoomReq,
	--申请退出私人房
	[Command.SERVER_EXIT_PRIVATEROOM_REQ] = CommonReader.onExitPrivateRoomReq,

	[Command.SERVER_EXIT_PRIVATEROOM_HANDLER_REQ] = CommonReader.onExitPrivateRoomHandlerReq,
	[Command.SERVER_BROADCAST_STOP_BATTLE] = CommonReader.onBroadcastStopBattle,


}
return CommonReader
