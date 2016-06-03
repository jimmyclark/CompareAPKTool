local RoomController 	= require("room.roomController")

local RoomState 		= class(BaseState);
local printInfo, printError = overridePrint("RoomState")

local room = require(ViewPath .. "room")

function RoomState:ctor(bundleData)
	self.m_controller = new(RoomController, room, self, bundleData);
end

function RoomState:load()
	return true;
end

function RoomState:unload()
	RoomState.super.unload(self);
	delete(self.m_controller);
	self.m_controller = nil;
end

return RoomState