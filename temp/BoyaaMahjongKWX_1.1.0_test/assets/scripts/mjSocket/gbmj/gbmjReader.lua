--[[
	国标麻将（房间）接收协议  2015-03-03
]]
local BaseReader = require("mjSocket.game.baseReader")
local GbmjReader = class(BaseReader)
local printInfo, printError = overridePrint("GbmjReader")
function GbmjReader:ctor()
	self.m_sockName = "国标"
end

-- 开始看牌 0x2020
function GbmjReader:onObserverCardBd(packetId)
end

-- 广播发牌 0x3001
function GbmjReader:onDealCardBd(packetId)
	local info = {
		iShaiziNum  = 0,
		iCurQuan    = 0,
		iBankSeatId = 0,
		iHandCards  = {},
		iBuhuaCards = {},
	}
	info.iShaiziNum = self.m_socket:readShort(packetId, -1)
	info.iCurQuan = self.m_socket:readShort(packetId, -1)
	info.iBankSeatId = self.m_socket:readShort(packetId, -1)

	info.iHandCards = self:readHandCardsTb(packetId)
    -- 补花牌
    info.iBuhuaCards = self:readCardsTb(packetId)
	return info
end

-- 广播自己抓牌 0x3002
function GbmjReader:onOwnGrabCardBd(packetId)
	local info = {
		iCard = nil,
		iHuaCards = {},
		iOpValue = 0,
		iAnCards = {},
		iBuCards = {},
		iCanTing = 0,
		iTingInfos = {},
		iFanLeast  = 0,
	}
	local count = self.m_socket:readInt(packetId, 0)
	for i=1, count do
		local card = self.m_socket:readByte(packetId, -1)
		if card > 0x50 then
			table.insert(info.iHuaCards, card)
		else  --实际摸到的牌
			info.iCard = card
		end
	end
	info.iOpValue = self.m_socket:readInt(packetId, 0)
	-- SOCKET_TODO
	for i=1, 4 do
		local card = self.m_socket:readByte(packetId, 0)
		table.insert(info.iAnCards, card)
	end
	for i=1, 4 do
		local card = self.m_socket:readByte(packetId, 0)
		table.insert(info.iBuCards, card)
	end
	local grabFinal = self.m_socket:readByte(packetId, -1)
	-- 读取听牌信息
	info.iCanTing, info.iTingInfos = self:_readTingInfo(packetId)
    -- 国标 起胡番
    info.iFanLeast = self.m_socket:readByte(packetId, -1)
	return info
end

-- 广播玩家抓牌 0x4006
function GbmjReader:onOtherGrabCardBd(packetId)
	local info = {
		iUserId = 0,
		iHuaCards = {},
	}

	info.iUserId = self.m_socket:readInt(packetId, -1)
	local count = self.m_socket:readInt(packetId, -1)  -- 花牌数目
	for i=1, count do
		local card = self.m_socket:readByte(packetId, -1)
		table.insert(info.iHuaCards, card)
	end
	local grabFinal = self.m_socket:readByte(packetId, -1)
	return info
end

-- 广播玩家出牌 0x4004
function GbmjReader:onOutCardBd(packetId)
	local info = {
		iUserId = 0,
		iCard = 0,
		iOpValue = 0,
		iIsTing = 0,
		iFanLeast = 0,
		iIsAi   = 0,
	}
	info.iUserId 	= self.m_socket:readInt(packetId, -1)
	info.iCard 		= self.m_socket:readByte(packetId, -1)
	info.iOpValue 	= self.m_socket:readInt(packetId, -1)
	info.iIsTing 	= self.m_socket:readByte(packetId, -1)
	info.iFanLeast 	= self.m_socket:readByte(packetId, -1)
	info.iIsAi      = self.m_socket:readInt(packetId, 0)  --是否托管出牌
	return info
end

-- 广播玩家操作 0x4005
function GbmjReader:onOperateCardBd(packetId)
	local info = {
		iUserId = 0,
		iCard = 0,
		iOpValue = 0,
		iCanTing = 0,
		iTingInfos = {},
		iFanLeast = 0,
		iTargetSeatId = 0,
	}
	info.iUserId 		= self.m_socket:readInt(packetId, -1)
	info.iOpValue 		= self.m_socket:readInt(packetId, -1)
	info.iCard 			= self.m_socket:readByte(packetId, -1)
	info.iTargetSeatId  = self.m_socket:readInt(packetId, -1)
	-- 读取听牌信息
	info.iCanTing, info.iTingInfos = self:_readTingInfo(packetId)
	info.iFanLeast 		= self.m_socket:readByte(packetId, -1)	
	return info
end

-- 广播抢杠胡 0x3005
function GbmjReader:onQiangGangHuBd(packetId)
	local info = {
		iOpValue = 0,
		iCard = 0,
		iSeatId = 0,
		iFanLeast	= 0,
	}
	info.iOpValue = self.m_socket:readShort(packetId, -1)
	info.iCard = self.m_socket:readByte(packetId, -1)
	info.iSeatId = self.m_socket:readByte(packetId, -1)
	info.iFanLeast = self.m_socket:readByte(packetId, -1)
	return info
end

-- 国标广播一局结束 0x4014
function GbmjReader:onStopRoundBd(packetId)
	local info = {}  
	info.iPlayType = self.m_socket:readByte(packetId, -1) 
	info.iType = self.m_socket:readShort(packetId, -1)  -- 0 流局 
	--TODO 删除宝箱时间？
  	local activetime = self.m_socket:readInt(packetId, -1) -- 宝箱时间 当局所玩时长

	if info.iType == 0 then
		info.iResult = self:_readLiujuData(packetId)
	else
		info.iResult = self:_readHuPaiData(packetId, info.iType)
	end
	return info
end

-- 广播游戏结束 0x4009
function GbmjReader:onStopGameBd(packetId)
	local info = {}
	for i=1,4 do
		local userId 		= self.m_socket:readInt(packetId, -1) --			
		local ralativeMoney = self.m_socket:readInt(packetId, -1) -- 相对钱数			
		local money 		= self.m_socket:readInt(packetId, -1) --绝对钱数			
		local status 		= self.m_socket:readShort(packetId, -1) -- 是否在线,0:不在线,1:在线
  	end
	return info
end

------------------------------------ private---------------------------------------
-- 读取流局数据
function GbmjReader:_readLiujuData(packetId)
	local result = {
		iPlayerResult = {},
		iStandard = 0,
		iCuoHuResult = {},
	}
	local playerCount 	= self.m_socket:readInt(packetId, - 1)
	-- 组装玩家金币变动
	local playerResult = result.iPlayerResult
	for i=1, playerCount do
		local userId 	= self.m_socket:readInt(packetId, -1)
		local money 	= self.m_socket:readInt(packetId, -1)
		playerResult[userId] = {
			iUserId = userId,
			iMoney 	= money,
		}
	end
	-- TODO 合并到上面？
	for i=1, playerCount do
		local userId 	= self.m_socket:readInt(packetId, -1)
		local turnMoney = self.m_socket:readInt(packetId, -1)
		local exp       = self.m_socket:readInt(packetId, -1)
		local level  	= self.m_socket:readInt(packetId, -1)
		local cardSize 	= self.m_socket:readInt(packetId, -1)
		local handCards = {}
		for j=1, cardSize do
			local card 	= self.m_socket:readByte(packetId, -1)
			table.insert(handCards, card)
		end
		playerResult[userId] = playerResult[userId] or {}
		table.merge(playerResult[userId], {
			iUserId 	= userId,
			iTurnMoney 	= turnMoney,
			iHandCards 	= handCards,
			iExp 		= exp,
			iLevel  	= level,
		})
	end

	-- result.iStandard, result.iCuoHuResult = self:_readCuoHuInfo(packetId)
	return result
end

-- 读取胡牌数据
function GbmjReader:_readHuPaiData(packetId, overType)
	local result = {
		iPlayerResult = {},
		iStandard = 0,
		iCuoHuResult = {},
	}
	local huOrPaoUserId = self.m_socket:readInt(packetId, -1)
	result.iHuOrPaoUserId = huOrPaoUserId
	-- TODO 
	local playerResult = result.iPlayerResult
	for i=1, PLAYER_COUNT do
		local userId 	= self.m_socket:readInt(packetId, -1)
		local status 	= self.m_socket:readShort(packetId, -1)
		local money  	= self.m_socket:readInt(packetId, -1)
		local turnMoney = self.m_socket:readInt(packetId, -1)
		local exp       = self.m_socket:readInt(packetId, -1)
		local level  	= self.m_socket:readInt(packetId, -1)
		-- huType = 1 自摸 2 胡牌 3放炮 4 正常 5 错胡 6 放炮加错胡
		local huType = 0
		if overType == 1 then
		 	huType = self.m_socket:readInt(packetId, -1)
		elseif overType == 2 then
		 	huType = self.m_socket:readInt(packetId, -1)
		end
       	local cardNum 	= self.m_socket:readInt(packetId, -1)
       	printInfo("玩家的胡牌cardNum = %d", cardNum)
       	local handCards = {}
       	for k=1, cardNum do
       		local card 	= self.m_socket:readByte(packetId, -1)
			table.insert(handCards, card)
       	end
       	local fanSize = self.m_socket:readShort(packetId, -1)
       	printInfo("玩家的胡牌番size = %d", fanSize)
       	local fansTb = {}
       	for k=1, fanSize do
       		local fanId 	= self.m_socket:readInt(packetId, -1)
       		local fanNum 	= self.m_socket:readInt(packetId, -1)
       		table.insert(fansTb, {
       			iFanId = fanId,
       			iFanNum = fanNum,
       		})
       	end
       	playerResult[userId] = {
       		iUserId 	= userId,
       		iStatus     = status,
			iMoney	    = money,
			iExp 		= exp,
			iLevel  	= level,
			iTurnMoney 	= turnMoney,
			iHandCards 	= handCards,
			iHuType     = huType,
			iFansTb	    = fansTb,
        }
	end
	result.iHuCard 	= self.m_socket:readByte(packetId, -1)
	local stopRound = self.m_socket:readByte(packetId, -1)
	-- result.iStandard, result.iCuoHuResult = self:_readCuoHuInfo(packetId)
	return result
end

-- 读取听牌信息 --国标专用
-- SOCKET_TODO 二人是根据 huCount 判断是否有听牌信息
-- TODO 国标是根据iCanTing来判断是否有听牌信息？
function GbmjReader:_readTingInfo(packetId)
	local tingInfos = {}
	local canTing = self.m_socket:readByte(packetId, -1)
	if canTing == 1 then
		local huCount = self.m_socket:readInt(packetId, -1) -- 可以胡的牌数目
    	for i=1, huCount do
    		local record = {}
    		local card = self.m_socket:readByte(packetId, 0) --打出的牌
    		local tingSize = self.m_socket:readInt(packetId, 0) --可以胡哪几张
    		tingInfos[card] = tingInfos[card] or {}
    		-- 这个牌
    		for j=1, tingSize do
    			local tingInfo = {}
    			tingInfo.iOutCard = card
    			tingInfo.iHuCard = self.m_socket:readByte(packetId, -1)
    			tingInfo.iFan = self.m_socket:readInt(packetId, 0)
    			tingInfo.iRemain = self.m_socket:readInt(packetId, 0)
    			local value = self.m_socket:readInt(packetId, 0)
		        tingInfo.iFanxing = bit.band(value, 0xff)
		        tingInfo.iHuTip = bit.brshift(bit.band(value, 0xff00), 8)
		        tingInfo.iFanId = self.m_socket:readShort(packetId, -1)
		        table.insert(tingInfos[card], tingInfo)
    		end
    	end
	end
    return canTing, tingInfos
end

-- 错胡信息
function GbmjReader:_readCuoHuInfo(packetId, isReconn)
	local cuoHuInfo = {}
	local isStandard = self.m_socket:readInt(packetId, -1)
	if isStandard ~= 1 then
		return isStandard, cuoHuInfo
	end
	local playerCount = self.m_socket:readShort(packetId, -1)
	for i=1, playerCount do
		local cuoHuRecord = {}
		local userId 	= self.m_socket:readInt(packetId, -1)
		-- TODO 几个地方的错胡信息 就这里不一致
		if isReconn then
			local cuoHuMoney = self.m_socket:readInt(packetId, -1)
			cuoHuRecord.iCuoHuMoney = cuoHuMoney
		end
		local isCuoHu 	= self.m_socket:readByte(packetId, -1)  -- 该玩家是否错胡
		cuoHuRecord.iUserId = userId
		cuoHuRecord.iIsCuoHu = isCuoHu
		-- 该玩家是否错胡
		if isCuoHu == 1 then
			local pCount = self.m_socket:readShort(packetId, -1)
			for k=1, pCount do
       	        local userId = socket_hall_read_int(packetId, -1);
       	        local money = socket_hall_read_int(packetId, -1);
       	    end
       	    local huaCardTb = {}
       	    local handCardTb = {}
       	    local holdSize = self.m_socket:readShort(packetId, -1)
       	    for k=1, holdSize do
       	    	local card = self.m_socket:readByte(packetId, -1)
       	    	if card > 0x50 then
       	    		huaCardTb[#huaCardTb + 1] = card 
       	    	else
       	    		handCardTb[#handCardTb + 1] = card
       	    	end
       	    end
       	    -- 错胡吃的牌
       	    local chiCardSize = self.m_socket:readShort(packetId, -1)
       	    local chiCardTb = {}
       	    for k=1, chiCardSize do
       	    	chiCardTb[#chiCardTb] = self.m_socket:readByte(packetId, -1)
       	    end
       	    -- 错胡碰的牌
       	    local pengCardSize = self.m_socket:readShort(packetId, -1)
       	    local pengCardTb = {}
       	    for k=1, pengCardSize do
       	    	pengCardTb[#pengCardTb] = self.m_socket:readByte(packetId, -1)
       	    end
       	    -- 错胡明杠的牌
       	    local mingCardSize = self.m_socket:readShort(packetId, -1)
       	    local mingCardTb = {}
       	    for k=1, mingCardSize do
       	        mingCardTb[#mingCardTb + 1] = self.m_socket:readByte(packetId, -1);
       	    end
       	    -- 错胡暗杠的牌
       	    local anCardSize = self.m_socket:readShort(packetId, -1)
       	    local anCardTb = {}
       	    for k=1, anCardSize do
       	        anCardTb[#anCardTb + 1] = self.m_socket:readByte(packetId, -1);
       	    end
       	    -- 错胡所得番型
       	    local fanSize = self.m_socket:readShort(packetId, -1)
       	    local fansTb = {}
       	    for k=1, fanSize do
       	    	local fanId = self.m_socket:readInt(packetId, -1)
       	        local fanNum = self.m_socket:readInt(packetId, -1);
       	        table.insert(fansTb, {
       	        	iFanId = fanId,
       	        	iFanNum = fanNum,
       	    	})
       	    end
       	    local cuoHuCard = self.m_socketk:readByte(packetId, -1)
       	    local cuoHuFan = self.m_socket:readInt(packetId, -1)
       	    local qihuFan = self.m_socket:readInt(packetId, -1)
       	    table.merge(cuoHuRecord, {
       	       	iHuaCardTb 	= huaCardTb,
       	       	iHandCardTb = handCardTb,
       	       	iChiCardTb 	= chiCardTb,
				iPengCardTb = pengCardTb,
				iMingCardTb = mingCardTb,
				iAnCardTb 	= anCardTb,
				iFansTb 	= fansTb,
				iCuoHuCard 	= cuoHuCard,
				iCuoHuFan 	= cuoHuFan,
				iQihuFan 	= qihuFan,
           	})
		end
		table.insert(cuoHuInfo, cuoHuRecord)
	end
	return isStandard, cuoHuInfo
end


function GbmjReader:initCommandFuncMap()
	GbmjReader.super.initCommandFuncMap(self)
	
	--[[
		国标麻将（房间）接收协议
	]]
	local s_severCmdFunMap = {
		[Command.ObserverCardBd] 	= self.onObserverCardBd,	--广播开始看牌
		[Command.DealCardBd] 		= self.onDealCardBd,		--广播发牌

		[Command.OwnGrabCardBd] 	= self.onOwnGrabCardBd,	--广播自己抓牌
		[Command.OtherGrabCardBd] 	= self.onOtherGrabCardBd,	--广播玩家抓牌
		[Command.OutCardBd] 		= self.onOutCardBd,		--广播玩家出牌
		[Command.OperateBd]     	= self.onOperateCardBd,	--广播玩家操作
		[Command.QiangGangHuBd]     = self.onQiangGangHuBd,	--广播抢杠胡
		[Command.GB_StopRoundBd]    = self.onStopRoundBd,		--广播牌局结束
		[Command.StopGameBd]     	= self.onStopGameBd,		--广播结算
	}
	-- 避免覆盖baseReader的方法
	table.merge(self.s_severCmdFunMap, s_severCmdFunMap)
end

return GbmjReader
