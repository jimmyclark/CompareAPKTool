local CardPanelCoord = require("room.coord.cardPanelCoord")
local Card = class(Node)
local printInfo, printError = overridePrint("Card")
local RotateSequence = 123
local UpAnimId = 1002
local UpDistanceY = 40
local bgPath = ""
local imgPath = ""

function Card:ctor(value, bgImage, fileReg, index)
	self.m_value = value or 0
	self.m_bgFile = bgImage
	self.m_fileReg = fileReg
	self.m_index = index or 1
	self.m_isCanOut = true
	self.m_bgCard = UIFactory.createImage(card_pin_map[bgPath .. bgImage])
		:addTo(self)

	if fileReg and self.m_value > 0 then
		self.m_card = self:createImgCard(self:getImageFile(fileReg, self.m_index, self.m_value))
	end
	self.m_scale = 1.0
	self.m_tingTips = nil
end

function Card:setBgAlign(align)
	if self.m_bgCard then
		self.m_bgCard:setAlign(align)
	end
	self.m_bgAlign = align
	return self
end

function Card:addTouchEvent(obj, func)
	if self.m_bgCard then
		self.m_bgCard:setEventTouch(obj, func)
	end
end

function Card:getDrawingId()
	return self.m_bgCard and self.m_bgCard.m_drawingID
end

function Card:containsPoint(x, y)
	local tx, ty = self:getPos()
	local width, height = self:getOriginSize()
	local rect
	local bottomDiffY = self.m_isUp and 15 - UpDistanceY or 15
	if self.m_bgAlign == kAlignBottomLeft then
		rect = ccrect(tx, ty - height, width, height - bottomDiffY)
	elseif self.m_bgAlign == kAlignBottom then
		rect = ccrect(tx - width / 2, ty - height, width, height - bottomDiffY)
	elseif self.m_bgAlign == kAlignTopLeft then
		rect = ccrect(tx, ty, width, height - bottomDiffY)
	elseif self.m_bgAlign == kAlignTop then
		rect = ccrect(tx - width / 2, ty, width, height - bottomDiffY)
	elseif self.m_bgAlign == kAlignCenter then
		rect = ccrect(tx - width / 2, ty - height / 2, width, height - bottomDiffY)
	else
		rect = ccrect(tx, ty, width, height - bottomDiffY)
	end
	return containsPoint(rect, ccp(x, y))
end

function Card:setOriginPos(x, y)
	self.m_originX = x
	self.m_originY = y
	self:setPos(x, y)
	return self
end

function Card:saveDstPos(x, y)
	self.m_savePosX = x
	self.m_savePosY = y
end

function Card:isPosChanged()
	local x, y = self:getPos()
	return self.m_savePosX ~= x or self.m_savePosY ~= y
end

function Card:getDstPos()
	return {x = self.m_savePosX, y = self.m_savePosY}
end

function Card:getValue()
	return self.m_value
end

function Card:setValue(value)
	self.m_value = value
	return self
end

function Card:getCardIndex()
	return bit.brshift(self.m_value or 0, 4), bit.band(self.m_value or 0, 0x0F)
end

function Card:getOriginPos()
	return self.m_originX, self.m_originY
end

--缩放花色
function Card:scaleCardTo(scaleWidth, scaleHeight)
	if self.m_card then
		local width, height = self.m_card:getOriginSize()
		width = width * (scaleWidth or 1)
		height = height * (scaleHeight or 1) 
		self.m_card:setSize(width, height)
	end
	return self
end
-- 缩放背景
function Card:scaleBgTo(scaleWidth, scaleHeight)
	if self.m_bgCard then
		local width, height = self.m_bgCard:getOriginSize()
		width = width * (scaleWidth or 1)
		height = height * (scaleHeight or 1) 
		self.m_bgCard:setSize(width, height)
	end
	return self
end

function Card:showTingTips(isShow)
	if isShow and self.m_tingTips then
		return
	end
	if not isShow then
		delete(self.m_tingTips)
		self.m_tingTips = nil
	end
	if isShow then
		self.m_tingTips = UIFactory.createImage("kwx_room/gameOpeation/img_tingtips.png")
		self.m_tingTips:setPos(0, 25)
		self.m_bgCard:addChild(self.m_tingTips)
	end
end

function Card:setScale(scale)
	self.m_scale = scale
	self:scaleBgTo(scale, scale)
	self:scaleCardTo(scale, scale)
	return self
end

function Card:getOriginSize()
	return self.m_bgCard:getSize()
end

-- 获取bgCard的size
function Card:getSize()
	return self.m_bgCard:getSize()
end

-- 用于相对初始位置做平移
function Card:selectCardUpDiff(diffX, diffY)
	local width, height = self:getOriginSize()
	local x, y = self:getOriginPos()
	y = y - UpDistanceY
	printInfo("diffX = %d, diffY = %d", diffX, diffY)
	self:setPos(x + diffX, y + diffY);
	return self
end

function Card:shiftMove(diffX, diffY)
	local x, y = self:getPos()
	self:setPos(x + diffX, y + diffY)
	return self
end

function Card:savePos()
	self.lastPosX = self.m_originX
	self.lastPosY = self.m_originY
	return self
end

function Card:getSavePos()
	return self.lastPosX, self.lastPosY
end

function Card:getPlayer()
	return self:getParent()
end

function Card:createImgCard(cardFile)
	return UIFactory.createImage(card_pin_map[cardFile])
		:addTo(self.m_bgCard)
		:align(kAlignCenter)
end

-------------------------------------------------------------
------------------操作动画所有 start-------------------------

function Card:hideDesign()
    if self.m_card then
       self.m_card:setVisible(false);
    end	
end

function Card:showDesign()
    if self.m_card then
       self.m_card:setVisible(true);
    end	
end	

function Card:durationShowDesin(duration)

	local function m_showDesign()
        self:showDesign()
        delete(self.m_timer)
	end
	self.m_timer = new(AnimInt,kAnimNormal,0, 1,duration,-1);
	self.m_timer:setDebugName("Card || m_timer");
	self.m_timer:setEvent(self,m_showDesign);
end	

------------------操作动画所有 end-------------------------
-----------------------------------------------------------

function Card:getImageFile(fileReg, index, value)
	local imgFile = imgPath .. string.format(fileReg, index or 1, value)
	return imgFile
end

function Card:resetImageByValueAndType(value, fileReg, bgFile)
	self.m_isGaiPai = false
	value = value or 0
	if bgFile then
		self.m_bgFile = bgFile
		self.m_bgCard:setFile(card_pin_map[bgPath .. bgFile])
		self.m_bgCard:setSize(self.m_bgCard:getResSize())
		self.m_bgCard:show()
	end
	if fileReg and value > 0 then
		self.m_fileReg = fileReg
		-- 不被花牌覆盖
		if value < 0x50 then self.m_value = value end

		self:resetImageCard(self:getImageFile(fileReg, self.m_index, value))
	end
	return self
	-- printInfo("重置麻将子%d", value or -1)
end

function Card:resetImageCard(imgFile)
	if not self.m_card then
		self.m_card = self:createImgCard(imgFile)
	else
		self.m_card:setFile(card_pin_map[imgFile])
	end
	self.m_card:show()
end

function Card:setRotation(rotation)
	if self.m_card then
		if not self.m_card:checkAddProp(RotateSequence) then
			self.m_card:removeProp(RotateSequence)
		end
		self.m_card:addPropRotateSolid(RotateSequence, rotation, kCenterXY)
	end
	return self
end

function Card:setAngle(angle)

end

function Card:shiftCardMove(x, y)
	if self.m_card then
		self.m_card:pos(x, y)
	end
	return self
end

function Card:getImgPos()
	if self.m_card then
		return self.m_card:getAbsolutePos()
	end
	return 0, 0
end

function Card:getImgSize()
	if self.m_card then
		return self.m_card:getSize()
	end
	return 0, 0
end

-- 还原位置
function Card:resetPos(animFlag, time, callback)
	self:setPos(self.m_originY + (self.m_isUp and UpDistanceY or 0), self.m_originY)
	return self
end

function Card:setUp(noScale)
	self.m_isUp = true
	local width, height = self:getOriginSize()
	local diffX = 0
	self:setPos(self.m_originX, self.m_originY - UpDistanceY)
	self:setLevel(CardPanelCoord.handCardLayer[1] + 1)
	if not noScale then
		self:setScale(CARD_UP_SCALE)
		diffX = width - self:getOriginSize()
	end
	return -diffX
end

-- 只有自己才会用
function Card:gaiPai(fileName)
	self.m_bgCard:setFile(card_pin_map[bgPath .. fileName])
	self.isGaiPai = true
	if self.m_card then
		self.m_card:hide()
	end
end

function Card:gaiPaiOver()
	self.m_bgCard:setFile(card_pin_map[bgPath .. self.m_bgFile])
	if self.m_card then
		self.m_card:show()
	end
end

function Card:setDown()
	printInfo("self:getPlayer().m_gameData:getIsTing() : %d",self:getPlayer().m_gameData:getIsTing())
	if 1 == self:getPlayer().m_gameData:getIsTing() then
		return
	end
	self.m_isUp = false
	self:setScale(1.0)
	self:setPos(self.m_originX, self.m_originY)
	self:setLevel(CardPanelCoord.handCardLayer[1])
end

function Card:isUp()
	return self.m_isUp
end

-- 设置该牌已经被出了
function Card:setOuted(flag)
	self.m_outed = flag;
end

function Card:setTingInfo(tingInfo)
	self.m_tingInfo = tingInfo
	if not tingInfo or #tingInfo <= 0 then 
		self:showTingTips(false)
	else
		self:showTingTips(true)
	end
end

function Card:getTingInfo()
	return self.m_tingInfo
end

function Card:isOuted()
	return self.m_outed;
end

function Card:setLightColor()
	self.m_isCanOut = true
	self.m_bgCard:setColor(255,255,255);
end

function Card:setDarkColor()
	self.m_isCanOut = false
	self.m_bgCard:setColor(200,200,200);
end

return Card