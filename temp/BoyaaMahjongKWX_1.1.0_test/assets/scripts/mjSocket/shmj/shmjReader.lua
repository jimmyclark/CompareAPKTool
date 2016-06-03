--[[
	广东麻将（房间）接收协议  2015-03-03
]]
local BaseReader = require("mjSocket.game.baseReader")
local ShmjReader = class(BaseReader)
local printInfo, printError = overridePrint("ShmjReader")
function ShmjReader:ctor()
	self.m_sockName = "上海"
end

-- 广播发牌 0x3001
function ShmjReader:onDealCardBd(packetId)
	local info = {
		iShaiziNum  = 0,
		iBankSeatId = 0,
		iHandCards  = {},
		iBuhuaCards = {},
		iSH_LeZi = 0,
		iSH_HuaZhi = 0,
		iSH_HuangZhuang = 0,
		iSH_KaiBao = 0,

		iSH_ShaiziNum1 = 0,
		iSH_ShaiziNum2 = 0,
	}
	info.iShaiziNum = self.m_socket:readShort(packetId, -1)
	info.iBankSeatId = self.m_socket:readShort(packetId, -1)
	info.iSH_LeZi = self.m_socket:readShort(packetId, -1)
	info.iSH_DiFen = self.m_socket:readShort(packetId, -1)
	info.iSH_HuaZhi = self.m_socket:readShort(packetId, -1)
	info.iSH_HuangZhuang = self.m_socket:readShort(packetId, -1)
	info.iSH_KaiBao = self.m_socket:readShort(packetId, -1)

	info.iHandCards = self:readHandCardsTb(packetId)
    -- 补花牌
    info.iBuhuaCards = self:readCardsTb(packetId)

    info.iSH_ShaiziNum1 = self.m_socket:readInt(packetId, -1)
    info.iSH_ShaiziNum2 = self.m_socket:readInt(packetId, -1)
	return info
end

function ShmjReader:onChengBaoBd(packetId)
	local info = {}
	info.iMsg = self.m_socket:readString(packetId)
	return info
end

-- 广播自己抓牌 0x3002
function ShmjReader:onOwnGrabCardBd(packetId)
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
function ShmjReader:onOtherGrabCardBd(packetId)
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
function ShmjReader:onOutCardBd(packetId)
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
function ShmjReader:onOperateCardBd(packetId)
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
function ShmjReader:onQiangGangHuBd(packetId)
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
function ShmjReader:onStopRoundBd(packetId)
	local info = {}  
	info.iPlayType = self.m_socket:readByte(packetId, -1) 
	info.iType = self.m_socket:readShort(packetId, -1)  -- 0 流局 
	--TODO 删除宝箱时间？
  	local activetime = self.m_socket:readInt(packetId, -1) -- 宝箱时间 当局所玩时长
  	-- dump(info.iType)
	if info.iType == 0 then
		info.iResult = self:_readLiujuData(packetId)
	else
		info.iResult = self:_readHuPaiData(packetId, info.iType)
	end
	return info
end

-- 广播游戏结束 0x4009
function ShmjReader:onStopGameBd(packetId)
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
function ShmjReader:_readLiujuData(packetId)
	local result = {
		iPlayerResult = {},
	}
	-- 组装玩家金币变动
	local playerResult = result.iPlayerResult
	for i=1, PLAYER_COUNT do
		local userId 	= self.m_socket:readInt(packetId, -1)
		local money 	= self.m_socket:readInt(packetId, -1)
		playerResult[userId] = {
			iUserId = userId,
			iMoney 	= money,
			iHandCards 	= handCards or {},
		}
	end
	-- TODO 合并到上面？
	for i=1, PLAYER_COUNT do
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
			iExp 		= exp,
			iLevel  	= level,
			iHandCards 	= handCards,
		})
	end
	return result
end

-- 读取胡牌数据
function ShmjReader:_readHuPaiData(packetId, overType)
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
		-- 写入承包
		local cbUsers = {}
		local cbCount = self.m_socket:readShort(packetId, 0)
		for i=1, cbCount do
			local userId = self.m_socket:readInt(packetId, -1)
			cbUsers[userId] = userId
		end

       	local cardNum 	= self.m_socket:readInt(packetId, -1)
       	printInfo("玩家的胡牌cardNum = %d", cardNum)
       	local handCards = {}
       	for k=1, cardNum do
       		local card 	= self.m_socket:readByte(packetId, -1)
			table.insert(handCards, card)
       	end

       	--有几种胡牌类型
       	local fanSize = self.m_socket:readShort(packetId, -1)
       	printInfo("玩家的胡牌番size = %d", fanSize)
       	local fansTb = {}
       	for k=1, fanSize do
       		local fanId 	= self.m_socket:readInt(packetId, -1)
       		table.insert(fansTb, {
       			iFanId = fanId,
       			iFanNum = 0,
       		})
       	end
       	playerResult[userId] = {
       		iUserId 	= userId,
       		iStatus     = status,
			iMoney	    = money,
			iExp 		= exp or MyUserData:getExp(),
			iLevel  	= level or MyUserData:getLevel(),
			iTurnMoney 	= turnMoney,
			iHandCards 	= handCards,
			iHuType     = huType,
			iFansTb	    = fansTb,
			iCbUsers    = cbUsers,
        }
	end
	result.iHuCard 	= self.m_socket:readByte(packetId, -1)
	local stopRound = self.m_socket:readByte(packetId, -1)
	return result
end

-- 读取听牌信息 --国标专用
-- SOCKET_TODO 二人是根据 huCount 判断是否有听牌信息
-- TODO 国标是根据iCanTing来判断是否有听牌信息？
function ShmjReader:_readTingInfo(packetId)
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

function ShmjReader:initCommandFuncMap()
	ShmjReader.super.initCommandFuncMap(self)
	
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
		[Command.SH_StopRoundBd]    = self.onStopRoundBd,		--广播牌局结束
		[Command.StopGameBd]     	= self.onStopGameBd,		--广播结算

		[Command.SH_ChengBaoBd]     = self.onChengBaoBd,
	}
	-- 避免覆盖baseReader的方法
	table.merge(self.s_severCmdFunMap, s_severCmdFunMap)
end

return ShmjReader