local GameServer = class(Node)

function GameServer:ctor()
	EventDispatcher.getInstance():register(Event.ConsoleSocket, self, self.onSocketReceive)
	self.m_players = {}
end

function GameServer:onLoginRoomRsp(data)
	printInfo("单机模拟返回消息")	
	self:performWithDelay(function()
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.LoginRoomRsp, {
			iConfig = {
				iTai 		= 100,
				iDi  		= 100,
				iTotalQuan 	= 4,
				iOutTime 	= 10,
				iOpTime 	= 10,
				iStandard 	= 0,
			}, 					--房间配置（客户端做计时器，显示等）
			iMySeatId = 0,		--我的seatId
			iMyMoney = 1111,
			iIsReady = 0,
			iGameType = data.iGameType,
			iPlayersInfo = {
				{
					iUserId = 1,
					iSeatId = 1,
					iIsReady = 1,
					iUserInfo = json.encode({
								nick = "玩家1",
								money = 11111,
								sex = math.random(0, 2)
							}),
					iMoney = 1111,
				},
				{
					iUserId = 2,
					iSeatId = 2,
					iIsReady = 1,
					iUserInfo = json.encode({
								nick = "玩家2",
								money = 11111,
								sex = math.random(0, 2)
							}),
					iMoney = 2222,
				},
				{
					iUserId = 3,
					iSeatId = 3,
					iIsReady = 0,
					iUserInfo = json.encode({
								nick = "玩家3",
								money = 33333,
								sex = math.random(0, 2)
							}),
					iMoney = 3333,
				},
			},--房间当前有哪些玩家
		})
	end, 500)

	-- self:performWithDelay(function()
	-- 	EventDispatcher.getInstance():dispatch(Event.Socket, Command.UserReadyBd, {
	-- 		iUserId = 3,
	-- 	})
	-- end, 2000)

	self.iUserTb = {MyUserData:getId(), 1, 2, 3}
	self.curSeatId = 1
end

function GameServer:onUserReadyBd(data)
	self:performWithDelay(function()
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.UserReadyBd, {
			iUserId = MyUserData:getId(),
		})
	end, 150)

	-- 广播庄家开局
	local bankSeatId = math.random(0, 3)
	self:performWithDelay(function()
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.GameReadyStartBd, {
			iBankSeatId = bankSeatId,
		})
	end, 1000)

	-- 开始发牌
	self:performWithDelay(function()
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.DealCardBd, {
			iShaiziNum  = (bankSeatId + 1) + 4 * math.random(1, 2),
			iCurQuan	= 0,
			iBankSeatId = bankSeatId,
			iHandCards  = {
				0x31, 0x32, 0x33, 0x34, 0x41, 0x42, 0x43, 0x04, 0x04, 0x06, 0x09, 0x09, 0x09,
			},
			iBuhuaCards	= {
				0x02, 0x03, 0x04
			},
		})
	end, 3000)

	-- 开始开局补花
	self:performWithDelay(function()
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.GameStartBd, {
			iHuaInfos = {
				{
					iUserId = MyUserData:getId(),
					iHuaCards = { 0x51, 0x52, 0x53},
				},
				{
					iUserId = 1,
					iHuaCards = { 0x55, 0x54},
				},
				{
					iUserId = 2,
					iHuaCards = { 0x56, 0x57, 0x58},
				},
				{
					iUserId = 3,
					iHuaCards = {},
				},
			}
		})

		self.curSeatId = bankSeatId

		self:performWithDelay(function()
			self:onGrabCardBd()
		end, 1000)
	end, 6000)
end

function GameServer:onGrabCardBd()
	self.curSeatId = self.curSeatId % 4 + 1
	local userId = self.iUserTb[self.curSeatId]
	printInfo("玩家self.curSeatId %d抓牌", self.curSeatId)

	local card 
	if math.random(0, 1) == 0 then
		card = tonumber("0x" .. math.random(0, 2) .. math.random(1, 9))
	else
		card = tonumber("0x" .. math.random(3, 4) .. math.random(1, 3))
	end
	if self.curSeatId == SEAT_1 then
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.OwnGrabCardBd, {
			iCard 		= card,
			iHuaCards 	= math.random(1, 31) < 16 and { 0x51, 0x52, 0x53} or {},
			iOpValue 	= 0,
			iAnCards 	= {},
			iBuCards 	= {},
			iCanTing 	= 0,
			iTingInfos 	= {},
			iFanLeast  	= 0,
		})
	else
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.OtherGrabCardBd, {
			iUserId 	= userId,
			iCard 		= 0,
			iHuaCards 	= math.random(1, 50) < 16 and { math.random( 0x51, 0x58) } or {},
		})
		-- 自动出牌
		self:performWithDelay(function()
			self:onOutCardBd({
				iUserId = userId,
				iCard = card,
				iOpValue = 0,
			})
		end, 1500)
	end
end

function GameServer:onOutCardBd(data)
	printInfo("出牌" .. (data.iUserId or MyUserData:getId()) .. ":" .. data.iCard)
	--iCard
	--iIsTing
	self:performWithDelay(function()
		EventDispatcher.getInstance():dispatch(Event.Socket, Command.OutCardBd, {
			iUserId = data.iUserId or MyUserData:getId(),
			iCard = data.iCard,
			iOpValue = 0,
			iIsTing = 0,
			iFanLeast = 0,
		})
		self:performWithDelay(function()
			self:onGrabCardBd()
		end, 1500)
	end, 100)


end

function GameServer:onSendChatBd(data)
	EventDispatcher.getInstance():dispatch(Event.Socket, Command.UserChat, {
		iUserId = MyUserData:getId(),
		iChatInfo = data.iChatInfo
	})
end

function GameServer:onSendFaceBd(data)
	printInfo("玩家发送表情= %d", data.iFaceType)
	EventDispatcher.getInstance():dispatch(Event.Socket, Command.UserFace, {
		iUserId = MyUserData:getId(),
		iFaceType = data.iFaceType,
	})
end


GameServer.commandFunMap = {
	[Command.JoinGameReq]  = GameServer.onLoginRoomRsp,
	[Command.ReadyReq] = GameServer.onUserReadyBd,
	[Command.RequestOutCard] = GameServer.onOutCardBd,
	[Command.SendChat] = GameServer.onSendChatBd,
	[Command.SendFace] = GameServer.onSendFaceBd,
}

function GameServer:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

return GameServer