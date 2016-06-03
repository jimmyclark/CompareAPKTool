local LobbyController 	= require("lobby/lobbyController")
local LobbyState 		= class(BaseState);
local LobbyLayout = require(ViewPath .. "LobbyLayout")

function LobbyState:load()
	LobbyState.super.load(self);
	self.m_controller = new(LobbyController, LobbyLayout, self, bundleData);
	return true;
end

function LobbyState:unload()
	LobbyState.super.unload(self);
	delete(self.m_controller);
	self.m_controller = nil;
end

return LobbyState