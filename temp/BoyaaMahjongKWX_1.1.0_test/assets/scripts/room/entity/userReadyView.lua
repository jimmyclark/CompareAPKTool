local RoomCoord 	= import("..coord.roomCoord")
local UserReadyView = class(Node)
local printInfo, printError = overridePrint("UserReadyView")

function UserReadyView:ctor(seat, userData, gameData)
	self.m_seat = seat
	self.m_userData = userData
	self.m_gameData = gameData
	
	self:initView()
end

function UserReadyView:initView()
	local pos = RoomCoord.UserReadyPos[self.m_seat]

	self.m_headView = new(Node)
		:addTo(self)
		:pos(-130, 0)

	self.m_infoView = new(Node)
		:addTo(self)
		:pos(-30, 0)
end

function UserReadyView:onEnterRoom()
	self:showUserView()
	self:initUserInfo()
end

function UserReadyView:showUserView()
	self:show()
end

function UserReadyView:hideUserView()
	self:hide()
end

function UserReadyView:initUserInfo()
	-- local headView = self.m_headView
	-- if not self.m_headImage then
	-- 	self.m_headImage = new(Mask, self.m_userData:getHeadName(), "room/head_mask.png")
	-- 		:addTo(headView)
	-- 		:pos(2, -42)
	-- 	self.m_headImage:setSize(84, 84)

	-- 	-- 绑定用户头像
	-- 	UIEx.bind(self.m_headImage, self.m_userData, "headName", function(value)
	-- 		self.m_headImage:setFile(value)
	-- 		self.m_userData:checkHeadAndDownload()
	-- 	end)

	-- 	self.m_headBtn = UIFactory.createButton(room_pin_map["head_bg.png"])
	-- 		:addTo(headView)
	-- 		:pos(0, -42)
	-- 	self.m_headBtn:setOnClick(nil, function()
	-- 		WindowManager:showWindow(WindowTag.UserInfoPopu, {
	-- 			userData = self.m_userData, 
	-- 			gameData = self.m_gameData,
	-- 		})
	-- 	end)

	-- end

	-- local infoView = self.m_infoView
	-- if not self.m_nickView then
	-- 	self.m_nickView = new(Node)
	-- 		:addTo(infoView)
	-- 		:pos(0, -20)

	-- 	self.m_nickText = UIFactory.createText({
	-- 		text = self.m_userData:getFormatNick(10),
	-- 		size = 26,
	-- 		color = c3b(255, 255, 255),
	-- 	})
	-- 	:addTo(self.m_nickView)
	-- 	:align(kAlignLeft)

	-- 	-- 绑定用户昵称显示
	-- 	UIEx.bind(self.m_nickText, self.m_userData, "nick", function(value)
	-- 		self.m_nickText:setText(self.m_userData:getFormatNick(10))
	-- 	end)
	-- end

	-- if not self.m_moneyView then
	-- 	self.m_moneyView = new(Node)
	-- 		:addTo(infoView)
	-- 		:pos(-10, 20)

	-- 	self.m_moneyBg = UIFactory.createImage("room/money_bg.png", fmt, filter, 10, 10, 10, 10)
	-- 		:addTo(self.m_moneyView)
	-- 		:align(kAlignLeft)
	-- 		:setSize(200, 40)

	-- 	self.m_moneyIcon = UIFactory.createImage("lobby/lobby_coin.png")
	-- 		:addTo(self.m_moneyView)
	-- 		:align(kAlignLeft)

	-- 	local width, _ = self.m_moneyIcon:getSize()
	-- 	self.m_moneyText = new(require("lobby.ui.lobbyCoinNode"))
	-- 		:addTo(self.m_moneyView)
	-- 		:align(kAlignLeft, width + 2, 0)
	-- 	self.m_moneyText:setNumber(ToolKit.formatNumber(self.m_userData:getMoney()))
	-- 	-- 绑定用户金币显示
	-- 	UIEx.bind(self.m_moneyView, self.m_userData, "money", function(value)
	-- 		self.m_moneyText:setNumber(ToolKit.formatNumber(value))
	-- 	end)

	-- 	if self.m_seat == SEAT_1 then
	-- 		local moneyBtn = UIFactory.createButton(room_pin_map["add_money_btn.png"])
	-- 			:addTo(self.m_moneyBg)
	-- 			:align(kAlignRight)
	-- 			:pos(-25, 0)
	-- 		moneyBtn:setOnClick(nil, function()
	-- 			app:selectGoodsForChargeByLevel({
	-- 				level = G_RoomCfg:getLevel(),
	-- 				chargeType = ChargeType.QuickCharge,
	-- 			})
	-- 		end)
             
 --            -- 给背景加触发touch事件
	-- 		local touchEvent = function(obj, finger_action)
	-- 		   if finger_action == kFingerDown then
	-- 			  app:selectGoodsForChargeByLevel({
	-- 			     level = G_RoomCfg:getLevel(),
	-- 				 chargeType = ChargeType.QuickCharge,
	-- 			  })
	-- 		   end
	-- 	    end	
	-- 	   self.m_moneyBg:setEventTouch(nil,touchEvent);
	-- 	end
	-- end
end

function UserReadyView:getFaceAnimPos()
	local x, y = self.m_headBtn:getAbsolutePos()
	x = x + 100
	y = y - 100
	-- if self.m_seat == SEAT_1 then
	-- 	x = x + 100
	-- 	y = y - 100
	-- elseif self.m_seat == SEAT_2 then
	-- 	x = x + 100
	-- 	y = y - 100
	-- elseif self.m_seat == SEAT_3 then
	-- 	x = x + 100
	-- 	y = y - 100
	-- elseif self.m_seat == SEAT_4 then
	-- 	x = x + 100
	-- 	y = y - 100
	-- end
	return x, y
end

function UserReadyView:getPropAnimPos()
	return self.m_headBtn:getAbsolutePos()
end

function UserReadyView:onUserExit()
	self:hideUserView()
end

return UserReadyView