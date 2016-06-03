local RoomCoord 	= import("..coord.roomCoord")
local UserReadyView = import(".userReadyView")
local UserGameView = import(".userGameView")
local userPanel = require(ViewPath .. "userPanel")
local UserPanel = class(Node)
local printInfo, printError = overridePrint("UserPanel")

function UserPanel:ctor(seat, userData, gameData)
	self.m_seat = seat
	self.m_userData = userData
	self.m_gameData = gameData

	self:initView()
end

function UserPanel:initView()
end

function UserPanel:showUserReadyView()
	if self.m_userGameView then 
		self.m_userGameView:hideUserView()
	end
	if not self.m_userReadyView then
		local pos = RoomCoord.UserReadyPos[self.m_seat]
		self.m_userReadyView = new(UserReadyView, self.m_seat, self.m_userData, self.m_gameData)
			:addTo(self)
			:pos(pos.x, pos.y)
	else
		self.m_userReadyView:showUserView()
	end
	self:setLevel(RoomCoord.UserPanelLayer[self.m_seat] + 1)
end

function UserPanel:showUserGameView()
	if self.m_seat == SEAT_3 then
		return
	end
	if self.m_userReadyView then 
		self.m_userReadyView:hideUserView()
	end
	if not self.m_userGameView then
		self.m_userGameView = new(UserGameView, self.m_seat, self.m_userData, self.m_gameData)
			:addTo(self)
	else
		self.m_userGameView:showUserView()
	end
	self:setLevel(RoomCoord.UserPanelLayer[self.m_seat])
end

function UserPanel:clearTableForGame(isReconn)
	if self.m_userGameView then
		self.m_userGameView:clearGameNotStart()
	end
end

-- 进入房间
function UserPanel:onEnterRoom()
	-- if self.m_seat == SEAT_1 then
		-- if self.m_userGameView then
			self:showUserGameView()
			self.m_userGameView:onEnterRoom()
		-- else
		-- 	self:showUserReadyView()
		-- 	self.m_userReadyView:onEnterRoom()
		-- end
	-- else
	-- 	self:showUserReadyView()
	-- 	self.m_userReadyView:onEnterRoom()
	-- end
end

-- 显示选漂的结果
function UserPanel:showSelectPiaoInfo(info)
	if self.m_userGameView then
		self.m_userGameView:showSelectPiaoInfo(info)
	end
end

-- 开始游戏
function UserPanel:onGameReadyStart(isBank)
	self:showUserGameView()
end

function UserPanel:onUserExit()
	if self.m_userReadyView then
		self.m_userReadyView:onUserExit()
	end
	if self.m_userGameView then
		self.m_userGameView:onUserExit()
	end
end

function UserPanel:getPlayer()
	return self:getParent()
end

function UserPanel:getZhuangPos()
	return self.m_userGameView and self.m_userGameView:getZhuangPos()
end

function UserPanel:getAnimCoinFlyPos()
	return self.m_userGameView and self.m_userGameView:getAnimCoinFlyPos()
end

function UserPanel:getFaceAnimPos()
	if self.m_userReadyView and self.m_userReadyView:getVisible() then
		return self.m_userReadyView:getFaceAnimPos()
	elseif self.m_userGameView and self.m_userGameView:getVisible() then
		return self.m_userGameView:getFaceAnimPos()
	end
end

function UserPanel:getPropAnimPos()
	if self.m_userReadyView and self.m_userReadyView:getVisible() then
		return self.m_userReadyView:getPropAnimPos()
	elseif self.m_userGameView and self.m_userGameView:getVisible() then
		return self.m_userGameView:getPropAnimPos()
	end
end

-- 当前是否 在游戏位置
function UserPanel:getIsInGamePos()
	if self.m_userReadyView and self.m_userReadyView:getVisible() then
		return false
	end
	return true
end

function UserPanel:dtor()
	globalNick = nil
end

function UserPanel:getRoom()
	return self:getParent() and self:getParent():getParent()
end

return UserPanel