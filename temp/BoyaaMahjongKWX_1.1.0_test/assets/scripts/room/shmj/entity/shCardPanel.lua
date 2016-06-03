local CardPanel = require("room.entity.cardPanel")
local RoomCoord = require("room.coord.roomCoord")

local ShCardPanel = class(CardPanel)

function ShCardPanel:onAddCard(iCard, iHuaCards)
	ShCardPanel.super.onAddCard(self, iCard, iHuaCards)
	
	local diffY = self.m_seat == SEAT_1 and -80 or -50;
	table.insert(iHuaCards, iCard)
	local cardValue = table.remove(iHuaCards, 1)
	local card = self:createOneHandCard(cardValue, true)
	card:setValue(iCard)

	local sequence1 = 431
	local sequence2 = 430
	local removeAddCardAnim = function()
		if card and card:alive() then
			checkAndRemoveOneProp(card, sequence1)
			checkAndRemoveOneProp(card, sequence2)
		end
	end

	local buHuaPlayed = false
	local playBuHuaAnim = function()
		local huaAnimPos = RoomCoord.OpAnimPos[self.m_seat]
		AtomAnimManager.getInstance():playAnim("atomAnimTable/flower", {
			x = huaAnimPos.x,
			y = huaAnimPos.y,
	 		width = 850,
	 		height = 400,
	 		parent = self,
	 		level = 51,
	 	})
		playOperateSound(kOpeBuHua, self.m_userData:getSex())
	end

	card:addPropTranslateWithEasing(sequence1, kAnimNormal, 200, 0, "easeOutBounce", "easeOutBounce", 0, -0, diffY, -diffY)
	local addCardAnim = card:addPropTransparency(sequence2, kAnimRepeat, 800, 0, 1.0, 1.0)
	addCardAnim:setDebugName("CardPanel || addCardAnim")
	addCardAnim:setEvent(nil, function()
		cardValue = table.remove(iHuaCards, 1)
		if not cardValue then
			return removeAddCardAnim()
		end
		if not buHuaPlayed then
			playBuHuaAnim()
			buHuaPlayed = true
		end
		if self.m_seat == SEAT_1 then
			card:resetImageByValueAndType(cardValue, self.m_handCardImgFileReg)
		end
		-- 抓完牌后如果没有操作面板就自动排序
		card:removeProp(sequence1)
		card:addPropTranslateWithEasing(sequence1, kAnimNormal, 200, 0, "easeOutBounce", "easeOutBounce", 0, -0, diffY, -diffY)
		if #iHuaCards == 0 then
			card:removeProp(sequence2)
		end
	end)
end

function ShCardPanel:onGaiPaiOver(...)
	ShCardPanel.super.onGaiPaiOver(self, ...)

	-- 为自己补一次花
	if self.m_seat == SEAT_1 then
		AtomAnimManager.getInstance():playAnim("atomAnimTable/flower", {
	 		width = 850,
	 		height = 400,
	 		parent = self,
	 		level = 51,
	 	})
		playOperateSound(kOpeBuHua, self.m_userData:getSex())
		for _, val in ipairs(self.m_huaCards) do
			for i, card in ipairs(self.m_cardsVector) do
				if card:getValue() > 0x50 then
					card:resetImageByValueAndType(val, self.m_handCardImgFileReg)
					break
				end
			end
		end
		for _, val in ipairs(self.m_huaCards) do
			for i,v in ipairs(self.m_handCards) do
				if v > 0x50 then
					self.m_handCards[i] = val
					break
				end
			end
		end
		self:freshHandCardsPos(true)
	end
end

-- 广播开始游戏（上海花牌）
function ShCardPanel:onGameStartBd(data)
	ShCardPanel.super.onGameStartBd(data)
	self.m_gameData:setDealHuaNum(#data.iHuaCards)
end

return ShCardPanel