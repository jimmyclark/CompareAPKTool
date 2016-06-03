return function(HbmjRoomController)

local TimerClock 	= require("room.entity.timerClock")
local printInfo, printError = overridePrint("HbmjRoomController")


-- 适配添加新的ui控件
local adapterGameView = HbmjRoomController.adapterGameView
function HbmjRoomController:adapterGameView()
	GameSetting:setSoundType(GameSetting:getHbSoundType())
	adapterGameView(self)
end

-----------------------   [[ 映射 ]]---------------------------------------
local initCommandFuncMap = HbmjRoomController.initCommandFuncMap
function HbmjRoomController:initCommandFuncMap()
	initCommandFuncMap(self)
	local commandFunMap = {
	}
	-- 合并
	table.merge(self.commandFunMap, commandFunMap)
end

end