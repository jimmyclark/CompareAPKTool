return function(ShmjRoomController)

local TimerClock 	= require("room.entity.timerClock")
local printInfo, printError = overridePrint("ShmjRoomController")


-- 适配添加新的ui控件
local adapterGameView = ShmjRoomController.adapterGameView
function ShmjRoomController:adapterGameView()
	GameSetting:setSoundType(GameSetting:getShSoundType())
	adapterGameView(self)
end

--------------协议 -----------------------
-- 广播游戏发牌
-- 国标麻将
local onDealCardBd = ShmjRoomController.onDealCardBd
function ShmjRoomController:onDealCardBd(data)
	onDealCardBd(self, data)
	G_RoomCfg:setBankSeat(data.iBankSeatId)
		:setCurQuan(data.iCurQuan)
		:setHuaFen(data.iSH_HuaZhi)
		:setHuangZhuang(data.iSH_HuangZhuang)
		:setKaiBao(data.iSH_KaiBao)
	dump("庄家位置" .. data.iBankSeatId)
	self:freshJuType()
end

-- 广播开始
local onGameStartBd = ShmjRoomController.onGameStartBd
function ShmjRoomController:onGameStartBd(data)
	onGameStartBd(self, data)
end

-- 广播重连
local onReconnSuccess = ShmjRoomController.onReconnSuccess
function ShmjRoomController:onReconnSuccess(data)
	onReconnSuccess(self, data)
	
	local config = data.iConfig
	G_RoomCfg:setCurQuan(config.iCurQuan)
		:setHuaFen(config.iSH_HuaZhi)
		:setHuangZhuang(config.iSH_HuangZhuang)
		:setKaiBao(config.iSH_KaiBao)
	printInfo("刷新风局信息")
	self:freshJuType()
end

function ShmjRoomController:onChengBaoBd(data)
	AlarmTip.play(data.iMsg)
end

--TODO 是不是由server给 设置剩余张 
function ShmjRoomController:resetRemainCards()
	G_RoomCfg:setRemainNum(144)
end

-----------------------   [[ 映射 ]]---------------------------------------
local initCommandFuncMap = ShmjRoomController.initCommandFuncMap
function ShmjRoomController:initCommandFuncMap()
	initCommandFuncMap(self)
	local commandFunMap = {
		[Command.SH_StopRoundBd] 	= self.onStopRoundBd,	--广播开始看牌
		[Command.SH_ChengBaoBd] 	= self.onChengBaoBd,	--广播开始看牌
	}
	-- 合并
	table.merge(self.commandFunMap, commandFunMap)
end

end