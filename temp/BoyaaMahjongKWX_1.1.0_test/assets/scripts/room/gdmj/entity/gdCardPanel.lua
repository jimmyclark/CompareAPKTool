local CardPanel = require("room.entity.cardPanel")

local GdCardPanel = class(CardPanel)

-- 没有补花
function GdCardPanel:onAddCard(iCard, iHuaCards)
	self.super.onAddCard(self, iCard, iHuaCards)
	
	local card = nil
	local diffY = self.m_seat == SEAT_1 and -80 or -50;
	-- if 1 == self.m_gameData:getIsTing() then
	-- 	local index = 14
	-- 	local extraBgFile = self:formatExtraCardBg(self.m_extraCardBgFile, math.ceil(index / 3), (index - 1) % 3 + 1)
	-- 	local needDiffFlag = true
	-- 	card = self:createOneExtraHandCard(iCard, extraBgFile, self.m_extraCardImgFileReg, needDiffFlag)
	-- else
		card = self:createOneHandCard(iCard, true)
	-- end
	card:setValue(iCard)

	local sequence1 = 431
	card:addPropTranslateWithEasing(sequence1, kAnimNormal, 200, 0, "easeOutBounce", "easeOutBounce", 0, -0, diffY, -diffY)
end


function GdCardPanel:createOneHandCardLiang(iCard, isAddCard)
	if not self.m_handCardPosX or not self.m_cardLayer then
		self:resetHandCardPosAndLayer()
	end
	local diff 
	if isAddCard then
		diff = self.m_addCardDiff
	else
		diff = { x = 0, y = 0} 
	end
	if self.m_seat ~= SEAT_1 and value ~= 0 then value = 0 end
	local card = new(Card, value, self.m_handCardBgFile, self.m_handCardImgFileReg)
			:setOriginPos(self.m_handCardPosX + diff.x, self.m_handCardPosY + diff.y)
			:setBgAlign(self.m_cardAlign)
	card:setScale(self.m_handCardScale)
	card:shiftCardMove(0, 2)

	table.insert(self.m_cardsVector, card)
	local width, height = card:getOriginSize()
	self.m_handCardPosX = self.m_handCardPosX + self.m_handCardDiff.xDouble * width * self.m_handCardScale + diff.x
	self.m_handCardPosY = self.m_handCardPosY + self.m_handCardDiff.yDouble * height * self.m_handCardScale + diff.y
	-- 第二号玩家的手牌受顺序影响 需要处理层级关系
	if self.m_seat == SEAT_2 then
		self.m_cardLayer = self.m_cardLayer - 1
	end
	card:addTo(self, self.m_cardLayer)
	return card
end

return GdCardPanel