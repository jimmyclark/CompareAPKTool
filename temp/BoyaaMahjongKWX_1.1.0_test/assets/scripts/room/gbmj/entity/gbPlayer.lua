local Player = require("room.entity.player")
local RoomCoord = require(".room.coord.roomCoord")
local UserData = require("data.userData")

local GbPlayer = class(Player)

-- function GbPlayer:onObserverCardBd(data)
-- 	self.m_gameData:setIsObing(1)
-- 	local alarmNode = UIFactory.createImage("animation/awardTipBg.png")
-- 		:addTo(self)
-- 		:align(kAlignCenter)
-- 	local tipText = UIFactory.createText({
-- 			text = string.format("您有%d秒的时间观察牌型", G_RoomCfg:getObTime()),
-- 			size = 36,
-- 			width = 0,
-- 			height = 0,
-- 			align = kAlignCenter,
-- 			color = c3b(198, 12, 0),
-- 		})
-- 		:addTo(alarmNode)
-- 		:align(kAlignCenter)
-- 	local second = G_RoomCfg:getObTime()
-- 	local anim = alarmNode:addPropTranslate(121, kAnimRepeat, 1000, 0, 0, 0, 0, 0)
-- 	if anim then
-- 		anim:setEvent(nil, function()
-- 			second = second - 1
-- 			tipText:setText(string.format("您有%d秒的时间观察牌型", second))
-- 			if second < 0 then
-- 				alarmNode:removeSelf()
-- 			end
-- 		end)
-- 	end
-- 	-- 状态改变后自动
-- 	UIEx.bind(alarmNode, self.m_gameData, "isObing", function(value)
-- 		if value ~= 1 then alarmNode:removeSelf() end
-- 	end)
-- end

--iCard iOpInfo iHuaCards
function GbPlayer:onAddCard(iCard, iHuaCards, ...)
	if self.m_gameData:getIsObing() == 1 then
		self.m_gameData:setIsObing(0)
	end
	GbPlayer.super.onAddCard(self, iCard, iHuaCards, ...)
end

-- 显示自己抓牌时的操作
function GbPlayer:dealOpAfterAddCard(iCard, iOpInfo, ...)
	if self.m_seat == SEAT_1 and self.m_gameData:getIsAi() ~= 1 then
		local iFanLeast = iOpInfo.iFanLeast or 0
		if iFanLeast ~= 0 and iFanLeast < 100 then
			-- AlarmNotice.play("不足" .. G_RoomCfg:getFanLeast() .. "番， 不能胡牌")
		elseif iFanLeast ~= 0 and iFanLeast > 100 then
			-- AlarmNotice.play("不足" .. G_RoomCfg:getFanLeast() .. "番， 不能听牌")
		end
	end
	-- 继续显示其他操作
	GbPlayer.super.dealOpAfterAddCard(self, iCard, iOpInfo, ...)
end

-- 显示别人出牌时自己的操作
function GbPlayer:dealOpAfterOtherOutCard(iCard, iOpInfo, ...)
	if self.m_seat == SEAT_1 and self.m_gameData:getIsAi() ~= 1 then
		local iFanLeast = iOpInfo.iFanLeast or 0
		if iFanLeast ~= 0 and iFanLeast < 100 then
			-- AlarmNotice.play("不足" .. G_RoomCfg:getFanLeast() .. "番， 不能胡牌")
		end
	end
	GbPlayer.super.dealOpAfterOtherOutCard(self, iCard, iOpInfo, ...)
end

function GbPlayer:dealOpAfterOwnOperate(iCard, iOpInfo, ...)
	if self.m_seat == SEAT_1 and self.m_gameData:getIsAi() ~= 1 then
		local iFanLeast = iOpInfo.iFanLeast or 0
		if iFanLeast ~= 0 and iFanLeast > 100 then
			-- AlarmNotice.play("不足" .. G_RoomCfg:getFanLeast() .. "番， 不能听牌")
		end
	end
	GbPlayer.super.dealOpAfterOwnOperate(self, iCard, iOpInfo, ...)
end

-- 显示别人操作后我的操作 用于抢杠胡
function GbPlayer:onQiangGangHuBd(iCard, iOpInfo, ...)
	if self.m_seat == SEAT_1 and self.m_gameData:getIsAi() ~= 1 then
		local iFanLeast = iOpInfo.iFanLeast or 0
		printInfo("国标判断抢杠胡")
		if iFanLeast ~= 0 and iFanLeast < 100 then
			-- AlarmNotice.play("不足" .. G_RoomCfg:getFanLeast() .. "番， 不能胡牌")
			-- 自动取消操作
			self:requestTakeOperate(kOpeCancel, 0)
		end
	end
	GbPlayer.super.onQiangGangHuBd(self, iCard, iOpInfo, ...)
end

-----------------国标麻将补花------------------

return GbPlayer