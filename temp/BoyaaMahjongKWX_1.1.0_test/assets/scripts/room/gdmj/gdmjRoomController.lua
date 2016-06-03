return function(GdmjRoomController)

local TimerClock 	= require("room.entity.timerClock")
local printInfo, printError = overridePrint("GdmjRoomController")

-- 适配添加新的ui控件
local adapterGameView = GdmjRoomController.adapterGameView
function GdmjRoomController:adapterGameView()
	GameSetting:setSoundType(GameSetting:getGdSoundType())
	adapterGameView(self)
end

-- 广播游戏发牌
-- 广东麻将
local onDealCardBd = GdmjRoomController.onDealCardBd
function GdmjRoomController:onDealCardBd(data)
	onDealCardBd(self, data)

	local bankUserId = data.iGD_BankUserId
	local localSeatId = self:_converUserToSeat(bankUserId)
	printInfo("localSeatId : %d", localSeatId)
	local _player = self.m_players[localSeatId]

	G_RoomCfg:setBankSeat(_player:getUserData():getSeatId())
		:setCurQuan(data.iCurQuan)
		
	G_RoomCfg:setCurQuan(data.iCurQuan)
	-- printInfo("刷新风局信息")
	-- printInfo("我的座位id %d", G_RoomCfg:getMySeat())
	-- printInfo("东家位置 %d", G_RoomCfg:getEastSeat())
	-- printInfo("庄家座位id %d", G_RoomCfg:getBankSeat())
	self:freshJuType()
end

-- 广播重连
local onReconnSuccess = GdmjRoomController.onReconnSuccess
function GdmjRoomController:onReconnSuccess(data)
	onReconnSuccess(self, data)
	local config = data.iConfig
	G_RoomCfg:setCurQuan(config.iCurQuan)
	-- printInfo("刷新风局信息")
	-- printInfo("我的座位id %d", G_RoomCfg:getMySeat())
	-- printInfo("东家位置 %d", G_RoomCfg:getEastSeat())
	-- printInfo("庄家座位id %d", G_RoomCfg:getBankSeat())
	self:freshJuType()
end

-- 广东的刮风下雨
function GdmjRoomController:onGfxyBd(data)
	local localSeatId = self:_converUserToSeat(data.iUserId)
	local turnMoney = data.iTurnMoney or 0
	local curMoney = data.iMoney or 0
	local _player = self.m_players[localSeatId]
	_player:onGfxyBd(turnMoney, curMoney)

	for i,v in ipairs(data.userList) do
		local tlocalSeatId = self:_converUserToSeat(v.iUserId)
		local _tplayer = self.m_players[tlocalSeatId]
		_tplayer:onGfxyBd(v.iTurnMoney or 0, v.iMoney or 0)
		if localSeatId == SEAT_1 or tlocalSeatId == SEAT_1 then
			local pos = {
				from = _tplayer:getAnimCoinFlyPos();
				to = _player:getAnimCoinFlyPos();
			}
			if pos and pos.from and pos.to then
				require("animation/animationCoinFly")
				new(AnimationCoinFly, pos):play()
			end
		end
	end

	if 1 == data.iIsLiang then
		_player:reDrawHandCardsLiang(data.iHandCards)
	end
end

--------------	update view --------------------
--TODO 是不是由server给 设置剩余张 
function GdmjRoomController:resetRemainCards()
	G_RoomCfg:setRemainNum(84)
end


-----------------------   [[ 映射 ]]---------------------------------------
local initCommandFuncMap = GdmjRoomController.initCommandFuncMap
function GdmjRoomController:initCommandFuncMap()
	initCommandFuncMap(self)
	local commandFunMap = {
		[Command.GD_StopRoundBd] 	= self.onStopRoundBd,	--广播牌局结束
		[Command.GfxyBd]            = self.onGfxyBd,
	}
	-- 合并
	table.merge(self.commandFunMap, commandFunMap)
end

end