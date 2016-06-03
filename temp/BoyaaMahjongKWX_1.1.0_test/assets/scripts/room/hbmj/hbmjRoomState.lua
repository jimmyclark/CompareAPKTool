local RoomState = require("room.roomState")
local HbmjRoomController 	= require("room/hbmj/hbmjRoomController")

local HbmjRoomState 		= class(RoomState);
local printInfo, printError = overridePrint("HbmjRoomState")

require(ViewPath .. "room")

function HbmjRoomState:load()
	self.m_controller = new(HbmjRoomController, room, self);
	return true;
end

return HbmjRoomState