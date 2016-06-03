local RoomConfig = class()
local printInfo, printError = overridePrint("RoomConfig")

addProperty(RoomConfig, "tai", 100)
addProperty(RoomConfig, "di", 100)
addProperty(RoomConfig, "level", 0)
addProperty(RoomConfig, "isQuickStart", false)
addProperty(RoomConfig, "bankSeat", 0)
addProperty(RoomConfig, "eastSeat", 0)
addProperty(RoomConfig, "mySeat", 0)
addProperty(RoomConfig, "curQuan", 0)
addProperty(RoomConfig, "outTime", 10)
addProperty(RoomConfig, "opTime", 10)
addProperty(RoomConfig, "obTime", 10)
addProperty(RoomConfig, "chatHistory", {})
addProperty(RoomConfig, "remainNum", -1)
addProperty(RoomConfig, "ju", 0)
addProperty(RoomConfig, "gameType", 0)
addProperty(RoomConfig, "playType", 0)
addProperty(RoomConfig, "fanLeast", 0)
addProperty(RoomConfig, "diChanged", false)
addProperty(RoomConfig, "playChanged", false)
addProperty(RoomConfig, "isPlaying", false)
addProperty(RoomConfig, "isDealCard", false)

addProperty(RoomConfig, "lastOutPlayer", nil)  --最后一个出牌的玩家

addProperty(RoomConfig, "huaFen", -1)
addProperty(RoomConfig, "huangZhuang", -1)
addProperty(RoomConfig, "kaiBao", -1)
addProperty(RoomConfig, "diFen", -1)

-- 开房相关
addProperty(RoomConfig, "isCompart", 0)  --是否包间
addProperty(RoomConfig, "isMaster", false)  --是否房主
addProperty(RoomConfig, "isSendExitReq", false)  --是否发送退出请求
addProperty(RoomConfig, "fid", 0)  --包间fid
addProperty(RoomConfig, "roundNum", 0)  --局数
addProperty(RoomConfig, "curRound", 0)  --当前局
addProperty(RoomConfig, "inviteData", {})  --房主获得的邀请数据
addProperty(RoomConfig, "historyScore", {})

-- 房间名
addProperty(RoomConfig, "roomName", "")

function RoomConfig:ctor()
end

function RoomConfig:initInfo(roomInfo, mySeat)
	self:setTai(roomInfo.iTai or 0)
	self:setDi(roomInfo.iDi or 0)
	self:setCurQuan(roomInfo.iCurQuan or 0)
	self:setOutTime(roomInfo.iOutTime or 10)
	self:setOpTime(roomInfo.iOpTime or 10)
	self:setPlayType(roomInfo.iPlayType or 0)
	if mySeat then
		self:setMySeat(mySeat)
	end
	return self
end

function RoomConfig:getSeatOffset()
   return PLAYER_COUNT - self:getMySeat()
end

--把服务器座位id转换为本地座位id
function RoomConfig:getLocalSeatId(seatId)
	local localSeatId = (seatId + self:getSeatOffset() ) % PLAYER_COUNT + 1
	if PLAYER_COUNT == localSeatId then
		localSeatId = PLAYER_COUNT + 1
	end
   	return localSeatId
end

--把本地座位id转换为服务器座位id
function RoomConfig:getServerSeatId(seatId)
  	return (seatId - 1 + PLAYER_COUNT - self:getSeatOffset()) % PLAYER_COUNT
end

function RoomConfig:getLocalBankSeat()
	return self:getLocalSeatId(self:getBankSeat())
end

function RoomConfig:getLocalEastSeat()
	return self:getLocalSeatId(self:getEastSeat())
end

function RoomConfig:addChatRecord(nick, chatInfo)
	local chatHistory = self:getChatHistory()
	table.insert(chatHistory, {
		nick = nick, 
		chatInfo = chatInfo
	})
end

function RoomConfig:resetGameTable()
	self:setRemainNum(-1)
end

function RoomConfig:getFengju()
	local tb = {"东", "南", "西", "北"}
	return string.format("%s风%s局", tb[self:getCurQuan() + 1] or "东", tb[self:getJu() + 1] or "东")
end

function RoomConfig:reduceRemainNum(num)
	local remainNum = self:getRemainNum()
	remainNum = remainNum - num
	if remainNum < 0 then remainNum = 0 end
	self:setRemainNum(remainNum)
end

function RoomConfig:clearForExitRoom()
	self:setIsQuickStart(false)
	self:setLevel(0)
	self:setChatHistory({})
	self:setJu(-1)
	self:setIsPlaying(false)

	self:setIsCompart(0)
	self:setFid(0)
	self:setRoundNum(0)
	self:setCurRound(0)
	self:setIsMaster(false)
	self:setIsSendExitReq(false)
	self:setInviteData({})
	self:setHistoryScore({})

end

function RoomConfig:onGameOver(isLiuju)
	self:setIsPlaying(false)
	self:setJu(-1)
	self:setHuaFen(-1)
	self:setHuangZhuang(-1)
	self:setKaiBao(-1)
	if isLiuju then
		-- self:setRemainNum(0) -- 无奈
	end
end

return RoomConfig