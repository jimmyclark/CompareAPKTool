return function(GbmjRoomController)

local RoomCoord 	= require("room.coord.roomCoord")
local TimerClock 	= require("room.entity.timerClock")
local printInfo, printError = overridePrint("GbmjRoomController")

-- 适配添加新的ui控件
local adapterGameView = GbmjRoomController.adapterGameView
function GbmjRoomController:adapterGameView()
	GameSetting:setSoundType(GameSetting:getGbSoundType())
	adapterGameView(self)
end

--------------协议 -----------------------
-- 广播游戏发牌
-- 国标麻将
local onDealCardBd = GbmjRoomController.onDealCardBd
function GbmjRoomController:onDealCardBd(data)
	onDealCardBd(self, data)
	G_RoomCfg:setBankSeat(data.iBankSeatId)
		:setCurQuan(data.iCurQuan)
	dump("庄家位置" .. data.iBankSeatId)
	self:freshJuType()
end

-- 广播开始
local onGameStartBd = GbmjRoomController.onGameStartBd
function GbmjRoomController:onGameStartBd(data)
	onGameStartBd(self, data)
end

-- 广播重连
local onReconnSuccess = GbmjRoomController.onReconnSuccess
function GbmjRoomController:onReconnSuccess(data)
	onReconnSuccess(self, data)
	local config = data.iConfig
	G_RoomCfg:setCurQuan(config.iCurQuan)
	printInfo("刷新风局信息")
	self:freshJuType()
end

-- 广播开始看牌
function GbmjRoomController:onObserverCardBd(data)
	self.m_timer:playWait(G_RoomCfg:getObTime(), TimerClock.Observer)
	-- self.mySelf:onObserverCardBd(data)
end

--------------	update view --------------------
--TODO 是不是由server给 设置剩余张 
function GbmjRoomController:resetRemainCards()
	G_RoomCfg:setRemainNum(144)
end

local initCommandFuncMap = GbmjRoomController.initCommandFuncMap
function GbmjRoomController:initCommandFuncMap()
	initCommandFuncMap(self)
	local commandFunMap = {
		[Command.ObserverCardBd] 	= self.onObserverCardBd,	--广播开始看牌
		[Command.GB_StopRoundBd] 	= self.onStopRoundBd,	--广播开始看牌
	}
	-- 合并
	table.merge(self.commandFunMap, commandFunMap)
end

end