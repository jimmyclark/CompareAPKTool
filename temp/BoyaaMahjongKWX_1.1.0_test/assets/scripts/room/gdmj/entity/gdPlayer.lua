local Player = require("room.entity.player")
local RoomCoord = require(".room.coord.roomCoord")
local UserData = require("data.userData")

local GdPlayer = class(Player)

function GdPlayer:onGfxyBd(turnMoney, money)
	self.m_userData:setMoney(money)
	-- 播放金币动画
	local AddMoneyAnim = require("animation.animAddMoney")
	new(AddMoneyAnim)
		:addTo(self, RoomCoord.AnimLayer)
		:play( {
			money = turnMoney,
			pos = RoomCoord.OpAnimPos[self.m_seat],
		})
end

--------------------ui交互------------------------

return GdPlayer