--[[
	广东麻将（房间）接收协议  2015-03-03
]]
local BaseReader = require("mjSocket.game.baseReader")
local GdmjReader = class(BaseReader)
local printInfo, printError = overridePrint("GdmjReader")
function GdmjReader:ctor()
	self.m_sockName = "广东"
end

-- 广播发牌 0x3001
function GdmjReader:onDealCardBd(packetId)
	local info = {
		iGD_FengInfos = {},
		iGD_DicNum = 0,
		iGD_DicFlag = 0, 
		iGD_BankUserId = 0,
		iGD_QuanNum  = 0,

		iShaiziNum  = 0,
		iCurQuan    = 0,
		iHandCards  = {},
		iBuhuaCards = {},
	}
	info.iGD_DicNum = self.m_socket:readShort(packetId, -1)
	info.iGD_DicFlag = self.m_socket:readByte(packetId, -1)
	info.iShaiziNum  = self.m_socket:readShort(packetId, -1)
	info.iGD_BankUserId = self.m_socket:readInt(packetId, -1)
	
	info.iHandCards = self:readHandCardsTb(packetId)
    return info
end

-- 广播自己抓牌 0x3002
function GdmjReader:onOwnGrabCardBd(packetId)
	local info = {
		iCard = nil,
		iHuaCards = {},
		iOpValue = 0,
		iAnCards = {},
		iBuCards = {},
		iTingInfos = {},
		iLiangInfo = {},
	}
	local tingInfos = info.iTingInfos
	local liangInfos = info.iLiangInfo
	local count = self.m_socket:readInt(packetId, 0)
	for i=1, count do
		info.iCard = self.m_socket:readByte(packetId, -1)
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
	local liangInfoCount = self.m_socket:readInt(packetId, 0)
	for i = 1, liangInfoCount do
		local liangInfo = {}
		local noLiangCards = {}
		local noLiangCount = self.m_socket:readInt(packetId, 0)
		for j = 1, noLiangCount do
			local temp = {}
			temp.iCard = self.m_socket:readByte(packetId, 0)
			temp.iCount = self.m_socket:readByte(packetId, 0)
			table.insert(noLiangCards, temp)
		end
		local tingCount = self.m_socket:readInt(packetId, 0)
		local tingInfo = {}
		for j = 1, tingCount do
			local temp = {}
			temp.iOutCard = self.m_socket:readByte(packetId, 0)
			temp.iTingCardsCount = self.m_socket:readInt(packetId, 0)
			temp.iTingCards = {}
			for k = 1, temp.iTingCardsCount do
				local tingCard = {}
				tingCard.iHuCard = self.m_socket:readByte(packetId, 0)
				tingCard.iTotalFan = self.m_socket:readInt(packetId, 0)
				tingCard.iFanXing = self.m_socket:readString(packetId, "")
				tingCard.iRemainNum = self.m_socket:readInt(packetId, 0)
				temp.iTingCards[#temp.iTingCards + 1] = tingCard
			end
			tingInfo[#tingInfo + 1] = temp
		end
		liangInfo.iNoLiangCards = noLiangCards
		liangInfo.iTingInfos = tingInfo
		liangInfos[#liangInfos + 1] = liangInfo
	end
	return info
end

-- 广播玩家抓牌 0x4006
-- 相同
function GdmjReader:onOtherGrabCardBd(packetId)
	local info = {
		iUserId = 0,
		iHuaCards = {},
	}

	info.iUserId = self.m_socket:readInt(packetId, -1)
	local count = self.m_socket:readInt(packetId, -1)  -- 花牌数目
	for i=1, count do
		local card = self.m_socket:readByte(packetId, -1)
	end
	local grabFinal = self.m_socket:readByte(packetId, -1)
	return info
end

-- 广播玩家出牌 0x4004 
-- 相同
function GdmjReader:onOutCardBd(packetId)
	local info = {
		iUserId = 0,
		iCard = 0,
		iOpValue = 0,
		iIsTing = 0,
		iFanLeast = 0,
		iIsAi     = 0,
		iLiangCards = {},
		iHuCard = {}
	}
	info.iUserId 	= self.m_socket:readInt(packetId, -1)
	info.iCard 		= self.m_socket:readByte(packetId, -1)
	info.iOpValue 	= self.m_socket:readInt(packetId, -1)
	info.iIsTing 	= self.m_socket:readByte(packetId, -1)
	info.iFanLeast 	= self.m_socket:readByte(packetId, -1)
	info.iIsAi      = self.m_socket:readInt(packetId, 0)  --是否托管出牌
	info.iIsLiang 	= self.m_socket:readByte(packetId, 0)
	if 1 == info.iIsLiang then
		local liangCount = self.m_socket:readShort(packetId, 0)
		for i = 1, liangCount do
			local temp = {}
			temp.iCard = self.m_socket:readByte(packetId, 0)
			temp.iType = self.m_socket:readByte(packetId, 0)
			table.insert(info.iLiangCards, temp)
		end
		
		local huCardCound 	= self.m_socket:readInt(packetId, -1)
		for i = 1, huCardCound do
			local card = self.m_socket:readByte(packetId, 0)
			table.insert(info.iHuCard, card)
		end

	end
	return info
end

-- 广播玩家操作 0x4005
function GdmjReader:onOperateCardBd(packetId)
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
	-- info.iCanTing       = self.m_socket:readByte(packetId, -1)
	info.iLiangCount 	= self.m_socket:readInt(packetId, 0)
	-- TODO 是否可以亮
	info.iLiangInfo = {}
	liangInfos = info.iLiangInfo
	for i = 1, info.iLiangCount do
		local liangInfo = {}
		local noLiangCards = {}
		local noLiangCount = self.m_socket:readInt(packetId, 0)
		for j = 1, noLiangCount do
			local temp = {}
			temp.iCard = self.m_socket:readByte(packetId, 0)
			temp.iCount = self.m_socket:readByte(packetId, 0)
			table.insert(noLiangCards, temp)
		end
		local tingCount = self.m_socket:readInt(packetId, 0)
		local tingInfo = {}
		for j = 1, tingCount do
			local temp = {}
			temp.iOutCard = self.m_socket:readByte(packetId, 0)
			temp.iTingCardsCount = self.m_socket:readInt(packetId, 0)
			temp.iTingCards = {}
			for k = 1, temp.iTingCardsCount do
				local tingCard = {}
				tingCard.iHuCard = self.m_socket:readByte(packetId, 0)
				tingCard.iTotalFan = self.m_socket:readInt(packetId, 0)
				tingCard.iFanXing = self.m_socket:readString(packetId, "")
				tingCard.iRemainNum = self.m_socket:readInt(packetId, 0)
				temp.iTingCards[#temp.iTingCards + 1] = tingCard
			end
			tingInfo[#tingInfo + 1] = temp
		end
		liangInfo.iNoLiangCards = noLiangCards
		liangInfo.iTingInfos = tingInfo
		liangInfos[#liangInfos + 1] = liangInfo
	end
	return info
end

-- 广播抢杠胡 0x3005
-- 相同
function GdmjReader:onQiangGangHuBd(packetId)
	local info = {
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

-- 广播游戏结束 0x4009
function GdmjReader:onStopGameBd(packetId)
	local info = {}
	for i=1,4 do
		local userId 		= self.m_socket:readInt(packetId, -1) --			
		local ralativeMoney = self.m_socket:readInt(packetId, -1) -- 相对钱数			
		local money 		= self.m_socket:readInt(packetId, -1) --绝对钱数			
		local status 		= self.m_socket:readShort(packetId, -1) -- 是否在线,0:不在线,1:在线
  	end
	return info
end

function GdmjReader:onGfxyBd(packetId)
	local info = {}
	info.iUserId = self.m_socket:readInt(packetId, -1)
	info.iTurnMoney  = self.m_socket:readInt(packetId, -1)
	info.iMoney = self.m_socket:readInt64(packetId, -1)
	info.iType   = self.m_socket:readShort(packetId, -1)	--1是刮风，2是下雨
	info.ziGang = self.m_socket:readByte(packetId, -1) -- 0是自杠，1是杠别人的

	info.userList = {}; -- 被杠的user集合
	local count = self.m_socket:readByte(packetId,-1);
	if count > 0 and count <= 4 then 
		for i = 1 , count do 
			local user = {};
			user.iUserId = self.m_socket:readInt(packetId,-1);
			user.iTurnMoney  = self.m_socket:readInt(packetId, -1)
			user.iMoney = self.m_socket:readInt64(packetId,-1);
			table.insert(info.userList, user);
		end
	end
	info.iIsLiang = self.m_socket:readByte(packetId, 0)
	info.iHandCards = {}
	if 1 == info.iIsLiang then
		local handCount = self.m_socket:readShort(packetId, 0)
		for i = 1, handCount do
			local temp = {}
			temp.iCard = self.m_socket:readByte(packetId, 0)
			temp.iType = self.m_socket:readByte(packetId, 0)
			info.iHandCards[#info.iHandCards + 1] = temp
		end
	end
	return info
end

------------------------------------ private---------------------------------------
-- 读取流局数据
function GdmjReader:_readLiujuData(packetId)
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
-- overType
function GdmjReader:_readHuPaiData(packetId, overType, playType)
	local result = {
		iPlayerResult = {},
		iPlayType = playType,  --1:鸡平胡 ; 2:推倒胡
		-- 鸡平胡
		iGD_JPH_HuInfos = {},

		-- 推倒胡
		iGD_HuUserId = 0,
		iQiangGangInfo = nil,
		iGangHuaInfo = nil,
		iGD_TDH_BigFan = nil,
	}

	local playerResult = result.iPlayerResult
	if playType == GdmjPlayType.JPH then
		-- 鸡平胡
		local huNum = self.m_socket:readByte(packetId, -1)
		for i=1, huNum do
			local userId 	= self.m_socket:readInt(packetId, -1)
			local card 		= self.m_socket:readByte(packetId, -1)
			local paoUserId = self.m_socket:readInt(packetId, -1)
			local fanNum 	= self.m_socket:readInt(packetId, -1)
			
			result.iGD_JPH_HuInfos[userId] = {
				iUserId 	= userId,
				iCard 		= card,
				iPaoUserId 	= paoUserId,
				iFanNum    	= fanNum,
			}
		end
		for i=1, PLAYER_COUNT do
			local userId = self.m_socket:readInt(packetId, -1)
			local online = self.m_socket:readShort(packetId, -1)
			local money  = self.m_socket:readInt(packetId, -1)
			local turnMoney = self.m_socket:readInt(packetId, -1)
			local exp       = self.m_socket:readInt(packetId, -1)
			local level  	= self.m_socket:readInt(packetId, -1)
			local isBaoHu 		= self.m_socket:readInt(packetId, -1)   --是否爆胡
	      	local isBaoSanjia 	= self.m_socket:readInt(packetId, -1)   --是否包三家 传 特殊类型的id
	      	local isBaoZiMo 	= self.m_socket:readInt(packetId, -1)   --是否包自摸 传 特殊类型的id
	      	local doubleNum 	= self.m_socket:readInt(packetId,-1)	--加倍胡的倍数

	      	local handCards = {}
	      	local cardNum = self.m_socket:readInt(packetId, -1)
	      	for i=1, cardNum do
	      		local card = self.m_socket:readByte(packetId, -1)
	      		table.insert(handCards, card)
	      	end
	      	local fanSize = self.m_socket:readShort(packetId, -1)
	      	local fansTb = {}
	      	for i=1, fanSize do
	      		local fanId   = self.m_socket:readByte(packetId, -1)
	      		local fanNum  = self.m_socket:readByte(packetId, -1)
	      		table.insert(fansTb, {
	      			iFanId = fanId,
	      			iFanNum = fanNum,
	      		})
	      	end
	      	playerResult[userId] = {
	      		iUserId = userId,
	      		iOnline = online,
	      		iMoney = money,
	      		iTurnMoney = turnMoney,
	      		iExp 		= exp,
				iLevel  	= level,
	      		iIsBaoHu   = isBaoHu,
	      		iIsBaoSanjia = isBaoSanjia,
	      		iIsBaoZiMo = isBaoZiMo,
	      		iDoubleNum = doubleNum,
	      		iHandCards = handCards,
	      		iFansTb    = fansTb,
	      	}
		end
      	local stopGame = self.m_socket:readByte(packetId, -1) 
	else 
		-- 推倒胡
		local huUserId = self.m_socket:readInt(packetId, -1)
		local card     = self.m_socket:readByte(packetId, -1)
		result.iGD_HuUserId = huUserId
		result.iHuCard = card

		-- 抢杠胡
		local qiangGangHu = self.m_socket:readByte(packetId, -1)
		if qiangGangHu == 1 then
			local beiQiangUserId = self.m_socket:readInt(packetId, -1)
			result.iQiangGangInfo = {
				iBeiQiangUserId = beiQiangUserId,
			}
		end

		-- 杠上开花
		local gangShangKaiHua = self.m_socket:readByte(packetId, -1)
		if gangShangKaiHua == 1 then
			local gangHuaUserId = self.m_socket:readInt(packetId, -1) 
			result.iGangHuaInfo = {
				iGangHuaUserId = gangHuaUserId,
			}
		end

		local bigBu	= self.m_socket:readByte(packetId, -1)
		-- 大番型
		if bigBu == 1 then
			local fanId = self.m_socket:readByte(packetId, -1)
			local fanNum = self.m_socket:readByte(packetId, -1)
			result.iGD_TDH_BigFan = {
				iFanId = fanId,
          		iFanNum = fanNum,
			}
		end
		dump(result)
		for i=1, PLAYER_COUNT do
			local userId 		= self.m_socket:readInt(packetId, -1)

       		local gfxyMoney 	= self.m_socket:readInt(packetId, -1)

       		local online 		= self.m_socket:readShort(packetId , -1);
       		local money 		= self.m_socket:readInt(packetId , -1);
       		local turnMoney 	= self.m_socket:readInt(packetId , -1);
       		local exp       = self.m_socket:readInt(packetId, -1)
			local level  	= self.m_socket:readInt(packetId, -1)
       		local handCards 	= self:readHandCardsTb(packetId) 
       		local bigHu2 		= self.m_socket:readByte(packetId, -1)

      	 	local fansTb = {}
       		if bigHu2 == 1 then
       			local fanId = self.m_socket:readByte(packetId, -1)
          		local fanNum = self.m_socket:readByte(packetId , -1);
          		table.insert(fansTb, {
	       			iFanId = fanId,
	       			iFanNum = fanNum,
	       		})
       		end

       		playerResult[userId] = {
       			iUserId 	= userId,
       			iGfxyMoney  = gfxyMoney,
       			iMoney 		= money,
       			iTurnMoney 	= turnMoney,
       			iExp 	= exp,
				iLevel  = level,
       			iHandCards 	= handCards,
       			iFansTb 	= fansTb,
       		}
		end
		local stopRound = self.m_socket:readByte(packetId, -1)
	end
	return result
end

function GdmjReader:initCommandFuncMap()
	GdmjReader.super.initCommandFuncMap(self)
	
	--[[
		麻将（房间）接收协议
	]]
	local s_severCmdFunMap = {
		[Command.DealCardBd] 		= self.onDealCardBd,		--广播发牌

		-- 通用有差异类型命令
		[Command.OwnGrabCardBd] 	= self.onOwnGrabCardBd,	--广播自己抓牌
		[Command.OtherGrabCardBd] 	= self.onOtherGrabCardBd,	--广播玩家抓牌
		[Command.OutCardBd] 		= self.onOutCardBd,		--广播玩家出牌
		[Command.OperateBd]     	= self.onOperateCardBd,	--广播玩家操作
		[Command.QiangGangHuBd]     = self.onQiangGangHuBd,	--广播抢杠胡
		
		[Command.StopGameBd]     	= self.onStopGameBd,		--广播结算
		[Command.GfxyBd]            = self.onGfxyBd,
	}

	-- 避免覆盖baseReader的方法
	table.merge(self.s_severCmdFunMap, s_severCmdFunMap)
end

return GdmjReader