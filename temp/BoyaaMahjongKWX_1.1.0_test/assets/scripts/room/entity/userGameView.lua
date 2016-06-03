local roomPlyerInfo = require(ViewPath .. "roomPlyerInfo")
local roomPlayerInfoOther = require(ViewPath .. "roomPlayerInfoOther")

local RoomCoord 	= import("..coord.roomCoord")
local UserGameView = class(Node)
local printInfo, printError = overridePrint("UserGameView")

function UserGameView:ctor(seat, userData, gameData)
	self.m_seat = seat
	self.m_userData = userData
	self.m_gameData = gameData

	local money = self.m_userData:getMoney()
	local nick = self.m_userData:getNick()

	self:initView()
	self:shieldFunction()
end

function UserGameView:initView()
	self.m_infoView = new(Node)
		:addTo(self)

	if self.m_seat == SEAT_1 then
		self:initMineInfo()
	else
		self:initOtherInfo()
	end
end

function UserGameView:showSelectPiaoInfo(info)
	if not info or info < 0 then
		return
	end
	self.m_viewPiao:show()
	self.m_piaoText:setNumber(ToolKit.formatNumber(info))
end

function UserGameView:clearGameNotStart()
	printInfo("UserGameView:clearGameNotStart")
	self.m_viewPiao:hide()
	-- self:showRemainView()
end

function UserGameView:initMineInfo()
	local infoView = self.m_infoView
	infoView:setPos(0, 0)
	infoView:setSize(display.width, display.height)
	self.m_view = SceneLoader.load(roomPlyerInfo)
	infoView:addChild(self.m_view)
	local w, h = self.m_view:getSize()
	self.m_view:setPos(0, display.bottom - h)
	self.m_view:setSize(display.width, h)

	self.m_bg = self.m_view:findChildByName("view_playerInfo")
	self.m_headBtn = self.m_view:findChildByName("btn_head")

	self.m_headImage = new(Mask, self.m_userData:getHeadName(), "kwx_room/img_headMask.png")
		:addTo(self.m_headBtn)
		:pos(0, 0)
	self.m_headImage:setSize(100,98)

	-- 绑定用户头像
	UIEx.bind(self.m_headImage, self.m_userData, "headName", function(value)
		self.m_headImage:setFile(value)
	end)

	self.m_headBtn:setOnClick(nil, function()
		WindowManager:showWindow(WindowTag.UserInfoPopu, {
			userData = self.m_userData,
			gameData = self.m_gameData,
		})
	end)

	self.m_nickText = self.m_view:findChildByName("nickName")
	self.m_nickText:setText(self.m_userData:getFormatNick(10))

	self.m_moneyBg = self.m_view:findChildByName("img_coinBg")

	-- 给背景加触发touch事件
	local touchEvent = function(obj, finger_action)
	   	if finger_action == kFingerDown then
		  	app:selectGoodsForChargeByLevel({
		     	level = G_RoomCfg:getLevel(),
			 	chargeType = ChargeType.QuickCharge,
		  	})
	   	end
    end
    self.m_moneyBg:setEventTouch(nil,touchEvent);
    self.m_view:findChildByName("btn_addCoin"):setOnClick(self, function(self)
    	app:selectGoodsForChargeByLevel({
		   	level = G_RoomCfg:getLevel(),
			chargeType = ChargeType.QuickCharge,
		})
    end)
    ----------------------------------------------
    local view_coin = self.m_view:findChildByName("view_coin")
	self.m_moneyText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(view_coin)
		:align(kAlignLeft)
	self.m_moneyText:setNumber(ToolKit.formatNumber(self.m_userData:getMoney()))
	-- 绑定用户昵称显示
	UIEx.bind(self.m_nickText, self.m_userData, "nick", function(value)
		self.m_nickText:setText(self.m_userData:getFormatNick(10))
	end)
	-- 绑定用户金币显示
	UIEx.bind(self.m_moneyText, self.m_userData, "money", function(value)
		self.m_moneyText:setNumber(ToolKit.formatNumber(value))
	end)

	self.m_viewPiao = self.m_view:findChildByName("img_piao")
	self.m_viewPiao:hide()
	self.m_piaoText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(self.m_view:findChildByName("view_piao"))
		:align(kAlignLeft)

	local view_huaFie = self.m_view:findChildByName("view_huaFei")
	local m_huaFeiText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(view_huaFie)
		:align(kAlignLeft)
	m_huaFeiText:setNumber(ToolKit.formatNumber(self.m_userData:getHuaFei()))
	UIEx.bind(self.m_moneyText, self.m_userData, "huaFei", function(value)
		m_huaFeiText:setNumber(ToolKit.formatNumber(value))
	end)
	self.m_imgShowTips = self.m_view:findChildByName("img_showtips")
	self.m_imgShowTips:hide()
	view_huaFie:setEventTouch(self, function(self, finger_action)
		if self.m_imgShowTips:getVisible() then return end
		if finger_action == kFingerDown then
			self.m_imgShowTips:show()
			-- DrawingBase.addPropTransparency = function(self, sequence, animType, duration, delay, startValue, endValue)
			local showAnim = self.m_imgShowTips:addPropTransparency(0, kAnimNormal, 3000, -1, 1.0, 1.0)
			showAnim:setDebugName("UserGameView | self.m_imgShowTips")
			showAnim:setEvent(self, function(self)
				self.m_imgShowTips:removeProp(0)
				self.m_imgShowTips:hide()
			end)
		end
	end)
	self:showRemainView()
	self.m_view:setVisible(true)

	local view_jewel = self.m_view:findChildByName("view_jewel")
	local jewelText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(view_jewel)
		:align(kAlignLeft)
	jewelText:setNumber(ToolKit.formatNumber(self.m_userData:getJewel()))
	UIEx.bind(jewelText, self.m_userData, "jewel", function(value)
		jewelText:setNumber(ToolKit.formatNumber(value))
	end)

	local myScore = self.m_userData:getScore()
	local view_score = self.m_view:findChildByName("view_score")
	local scoreText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(view_score)
		:align(kAlignLeft)
	scoreText:setNumber(ToolKit.formatNumber(self.m_userData:getScore()))
	UIEx.bind(scoreText, self.m_userData, "score", function(value)
		scoreText:setNumber(ToolKit.formatNumber(value))
	end)

	local view_privateroom = self.m_view:findChildByName("view_privateroom")
	local view_commonroom = self.m_view:findChildByName("view_commonroom")

	UIEx.bind(self, G_RoomCfg, "isCompart", function(value)
		if 1 == G_RoomCfg:getIsCompart() then
			view_privateroom:show()
			view_commonroom:hide()
		else
			view_privateroom:hide()
			view_commonroom:show()
		end
	end)
	
end

function UserGameView:initOtherInfo()
	local infoView = self.m_infoView
	local pos = RoomCoord.GameHeadPos[self.m_seat]
	local function getPlayerImage(sex)
		local sex = sex or self.m_userData:getSex()
		local prefix = sex == 0 and "man_" or "woman_"
		return string.format("kwx_room/room_player/%s%d.png", prefix, self.m_seat)
	end
	local headImg = getPlayerImage(self.m_userData:getSex())
	self.m_headBtn = UIFactory.createButton(headImg)
		:addTo(infoView)
	UIEx.bind(self.m_headBtn, self.m_userData, "sex", function(value)
		local headImg = getPlayerImage(value)
		self.m_headBtn:setFile(headImg)
	end)

	local width, height = self.m_headBtn:getSize()
	local x = pos.x + pos.xDouble * width
	local y = pos.y + pos.yDouble * height
	self.m_headBtn:pos(x, y)

	local x, y = self.m_headBtn:getAbsolutePos()
	local width, height = self.m_headBtn:getSize()
	local rect = ccrect(x, y, width, height * 4 / 5)
	self.m_headBtn:setEventTouch(nil, function(obj, finger_action, x, y, drawing_id_first, drawing_id_current)
		if finger_action == kFingerDown then
			if containsPoint(rect, ccp(x, y)) then
				kEffectPlayer:play(Effects.AudioButtonClick);
				WindowManager:showWindow(WindowTag.UserInfoPopu, {
					userData = self.m_userData,
					gameData = self.m_gameData,
				})
			end
		end
	end)

	self:createViewScore()
	if self.m_seat == SEAT_2 then
		self.m_viewScore:setPos(-48 , -45)
	elseif self.m_seat == SEAT_4 then
		self.m_viewScore:setPos(10, -45)
	end
	self.m_viewScore:hide()

	self:createViewPiao()
	if self.m_seat == SEAT_2 then
		self.m_viewPiao:setPos(-48 , 5)
		-- self.m_viewPiao:setLevel(1000)
	elseif self.m_seat == SEAT_4 then
		self.m_viewPiao:setPos(10, 5)
	end
	self.m_viewPiao:hide()

	self:createViewGold()
	if self.m_seat == SEAT_2 then
		self.m_viewGold:setPos(-48 , -45)
	elseif self.m_seat == SEAT_4 then
		self.m_viewGold:setPos(10, -45)
	end

	self.m_goldText:setNumber(ToolKit.formatNumber(self.m_userData:getMoney()))

	UIEx.bind(self.m_goldText, self.m_userData, "money", function(value)
		self.m_goldText:setNumber(ToolKit.formatNumber(value))
	end)
	if 1 == G_RoomCfg:getIsCompart() then
		self.m_viewGold:hide()
		self.m_viewScore:show()
	else
		self.m_viewScore:hide()
	end


	local otherPlayerInfo = SceneLoader.load(roomPlayerInfoOther)

	otherPlayerInfo:setVisible(1 ~= self.m_gameData:getIsReady())
	UIEx.bind(otherPlayerInfo, self.m_gameData, "isReady", function(value)
		otherPlayerInfo:setVisible(1 ~= value)
	end)

	infoView:addChild(otherPlayerInfo)
	local ow , oh = otherPlayerInfo:getSize()
	if self.m_seat == SEAT_2 then
		otherPlayerInfo:setPos(display.right - ow - 150, display.cy - oh / 2)
	elseif self.m_seat == SEAT_4 then
		otherPlayerInfo:setPos(display.left + 150, display.cy - oh / 2)
	end
	local imgHead = otherPlayerInfo:findChildByName("img_head")

	local headImage = new(Mask, self.m_userData:getHeadName(), "kwx_room/img_headMask.png")
		:addTo(imgHead)
		:pos(0, 0)
	headImage:setSize(100,98)
	-- 绑定用户头像
	UIEx.bind(headImage, self.m_userData, "headName", function(value)
		headImage:setFile(value)
	end)

	local textNick = otherPlayerInfo:findChildByName("text_nick")
	UIEx.bind(textNick, self.m_userData, "nick", function(value)
		textNick:setText(self.m_userData:getFormatNick(10))
	end)
	textNick:setText(self.m_userData:getFormatNick(10))
	local viewCoin = otherPlayerInfo:findChildByName("view_coin")
	local moneyText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(viewCoin)
		:align(kAlignLeft)
	UIEx.bind(moneyText, self.m_userData, "money", function(value)
		moneyText:setNumber(ToolKit.formatNumber(value))
	end)
	moneyText:setNumber(ToolKit.formatNumber(self.m_userData:getMoney()))

end

function UserGameView:createViewScore()
	if self.m_viewScore then
		return
	end
	self.m_viewScore = UIFactory.createImage("kwx_common/img_bg3.png",nil,nil,20,20,0,0)
								:addTo(self.m_headBtn)
								:setSize(150,40)
								:pos(0,0)
	local img = UIFactory.createImage("kwx_room/img_score.png"):pos(-3,0):addTo(self.m_viewScore)
	local viewText = new(Node)
	viewText:setPos(45, 5)
	viewText:setSize(90, 34)
	self.m_viewScore:addChild(viewText)
	self.m_scoreText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(viewText)
		:align(kAlignLeft)
	self.m_scoreText:setNumber(ToolKit.formatNumber(self.m_userData:getScore()))
	UIEx.bind(self.m_scoreText, self.m_userData, "score", function(value)
		self.m_scoreText:setNumber(ToolKit.formatNumber(value))
	end)
end

function UserGameView:createViewPiao()
	if self.m_viewPiao then
		return
	end
	self.m_viewPiao = UIFactory.createImage("kwx_common/img_bg3.png",nil,nil,20,20,0,0)
								:addTo(self.m_headBtn)
								:setSize(150,40)
								:pos(0,0)
	local img = UIFactory.createImage("kwx_room/img_piao.png"):pos(-3,-5):addTo(self.m_viewPiao)
	local viewText = new(Node)
	viewText:setPos(54, 2)
	viewText:setSize(90, 34)
	self.m_viewPiao:addChild(viewText)
	self.m_piaoText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(viewText)
		:align(kAlignLeft)
end

function UserGameView:createViewGold()
	if self.m_viewGold then
		return
	end
	self.m_viewGold = UIFactory.createImage("kwx_common/img_bg3.png",nil,nil,20,20,0,0)
								:addTo(self.m_headBtn)
								:setSize(150,40)
								:pos(0,0)
	local img = UIFactory.createImage("kwx_lobby/img_coin.png"):pos(0,0):addTo(self.m_viewGold)
	local viewText = new(Node)
	viewText:setPos(40, 5)
	viewText:setSize(90, 34)
	self.m_viewGold:addChild(viewText)

	self.m_goldText = new(require("lobby.ui.lobbyCoinNode"))
		:addTo(viewText)
		:align(kAlignLeft)

end

function UserGameView:onEnterRoom()
	self:showUserView()
	if self.m_seat ~= SEAT_1 then
		GuideManager:showGuideClickPlayer(true, self.m_headBtn)
	end
end

function UserGameView:showUserView()
	self.m_infoView:show()
end

function UserGameView:hideUserView()
	self.m_infoView:hide()
end

function UserGameView:getVisible()
	return self.m_infoView:getVisible()
end

function UserGameView:onUserExit()
	local x, y
	local animType = "left_oppo"
	local scale = 1.0
	local width, height = 512, 369

	if self.m_seat == SEAT_2 then
		x = display.right - 100
		y = display.cy - 65
		scale = 0.7
		animType = "left_side"
	elseif self.m_seat == SEAT_3 then
		x = display.cx
		y = display.top + 100
		scale = 1.0
		animType = "left_oppo"
	elseif self.m_seat == SEAT_4 then
		x = display.left - 100
		y = display.cy - 65
		scale = 0.7
		animType = "left_side"
	end
	-- 自己离开不需要动画
	if self.m_seat ~= SEAT_1 and self:getVisible() then
		AtomAnimManager.getInstance():playAnim("atomAnimTable/" .. animType, {
			x = x,
			y = y,
			width = width * scale,
			height = height * scale,
			parent = self,
			level = 51,
		})
	end

	self:hideUserView()
end

function UserGameView:showRemainView()
	self.m_remainText = self.m_view:findChildByName("text_remainCard")
	local viewRemain = self.m_view:findChildByName("view_remainCard")
	UIEx.bind(self.m_remainText, G_RoomCfg, "remainNum", function(value)
		if not value or value < 0 then
			viewRemain:hide()
		else
			viewRemain:show()
			self.m_remainText:setText(string.format("剩牌：%d张", value or 0))
		end
	end)
end

function UserGameView:getZhuangPos()
	local pos = {x = 0, y = 0}
	if self.m_headBtn then
		local w, h = self.m_headBtn:getSize()
		local x, y = self.m_headBtn:getAbsolutePos()
		if self.m_seat == SEAT_1 then
			return ccp(display.right - 290, display.bottom - 50)
		elseif self.m_seat == SEAT_2 then
			return ccp(x - 50, y + 100)
		elseif self.m_seat == SEAT_4 then
			return ccp(x + w + 20, y + 100)
		elseif self.m_seat == SEAT_3 then
			return ccp(x + 50, y + 100)
		end
	end
	return pos
end

function UserGameView:getAnimCoinFlyPos()
	local pos = {x = 0, y = 0}
	if self.m_headBtn then
		local w, h = self.m_headBtn:getSize()
		local x, y = self.m_headBtn:getAbsolutePos()
		-- if self.m_seat == SEAT_1 then
			return ccp(x + w / 2, y + h / 2)
		-- elseif self.m_seat == SEAT_2 then
		-- 	return ccp(x - 50, y + 100)
		-- elseif self.m_seat == SEAT_4 then
		-- 	return ccp(x + w + 20, y + 100)
		-- elseif self.m_seat == SEAT_3 then
		-- 	return ccp(x + 50, y + 100)
		-- end
	end
	return pos
end

function UserGameView:getChatWordPos()
	local pos = {x = 0, y = 0}
	if self.m_headBtn then
		local w, h = self.m_headBtn:getSize()
		local x, y = self.m_headBtn:getAbsolutePos()
		if self.m_seat == SEAT_1 then
			return ccp(x + w - 22, y)
		elseif self.m_seat == SEAT_2 then
			return ccp(x + 10, y + h - 30 - 50)
		elseif self.m_seat == SEAT_4 then
			return ccp(x + w - 50, y + h - 30 - 50)
		elseif self.m_seat == SEAT_3 then
			return ccp(x + w, y + h * 2 / 3 - 14)
		end
	end
	return pos
end

function UserGameView:getFaceAnimPos()
	local x, y = self.m_headBtn:getAbsolutePos()
	if self.m_seat == SEAT_1 then
		x = x + 50
		y = y - 100
	elseif self.m_seat == SEAT_2 then
		x = x - 200
		y = y + 60
	elseif self.m_seat == SEAT_3 then
		x = x
		y = y + 40
	elseif self.m_seat == SEAT_4 then
		x = x + 100
		y = y + 60
	end
	return x, y
end

function UserGameView:getPropAnimPos()
	local x, y = self.m_headBtn:getAbsolutePos()
	if self.m_seat == SEAT_1 then
	elseif self.m_seat == SEAT_2 then
		y = y + 70
	elseif self.m_seat == SEAT_3 then
		x = x + 50
		y = y + 20
	elseif self.m_seat == SEAT_4 then
		x = x + 20
		y = y + 70
	end
	return x, y
end

function UserGameView:shieldFunction()
	if not self.m_view then return end
	local huafei = self.m_view:findChildByName("img_huaFeiBg")
	if ShieldData:getAllFlag() then
		if huafei then huafei:hide() end
	end
end

return UserGameView
