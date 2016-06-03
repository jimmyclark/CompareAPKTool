local CardPanelCoord = import("..coord.cardPanelCoord")
local Card = import(".card")
local CardUpDistance = 50
local DEAL_CARD_ACTION = 1
local ADD_CARD_ACTION = 2
local OUT_CARD_ANIM_TIME = 0.2
local OUT_CARD_ANIM_END_TIME = 0.2

local CardPanel = class(Node)
local printInfo, printError = overridePrint("CardPanel")
local UpCardDiffY = -130

function CardPanel:ctor(seat, userData, gameData)
	self.m_seat = seat
	self.m_userData = userData
	self.m_gameData = gameData
	globalCardPanel = globalCardPanel or {}
	globalCardPanel[seat] = self
	self.m_showHuCardLayer = nil

	self.m_cardsVector = {}
	self.m_outCardsVector = {}
	self.m_extraCardsVector = {}
	self.m_huCardsVector = {}


	-- 亮牌的变量
	self.m_selectNoLiangCards = {}
	self.m_selectLiangInfo = {}
	self.m_selectLiang = false

	self.m_cardAlign            = CardPanelCoord.cardAlign[seat]
	self.m_gaiPaiFileName 		= CardPanelCoord.gaiPaiFileName[seat]
	self.m_handCardBgFile 		= CardPanelCoord.handCardBg[seat]
	self.m_handCardImgFileReg 	= CardPanelCoord.handCardImage[seat]
	self.m_handCardDiff 		= CardPanelCoord.handCardDiff[seat]
	self.m_handToExtraDiff 		= CardPanelCoord.handToExtraDiff[seat]
	self.m_handCardScale  		= CardPanelCoord.handCardScale[seat]
	self.m_extraHandCardDiff    = CardPanelCoord.extraHandCardDiff[seat]
	-- 出牌配置
	self.m_outCardLine 			= 1
	self.m_outCardBgFile 		= CardPanelCoord.outCardBg[seat]
	self.m_outCardImgFileReg 	= CardPanelCoord.outCardImage[seat]
	self.m_outCardDiff 			= CardPanelCoord.outCardDiff[seat]
	self.m_outCardScale 		= CardPanelCoord.outCardScale[seat]

	self.m_bigOutCardBgFile 	= CardPanelCoord.bigOutCardBg
	self.m_bigOutCardImgFileReg = CardPanelCoord.bigOutCardImg

	self.m_extraCardBgFile 		= CardPanelCoord.extraCardBg[seat]
	self.m_extraCardImgFileReg 	= CardPanelCoord.extraCardImage[seat]
	self.m_extraCardDiff 		= CardPanelCoord.extraCardDiff[seat]
	self.m_extraCardScale		= CardPanelCoord.extraCardScale[seat]
	self.m_extraAnGangImageFile = CardPanelCoord.extraAnGangImage[seat]
	self.m_extraCardGroupSpace  = CardPanelCoord.extraCardGroupSpace[self.m_seat]
	self.m_extraToHandDiff 		= CardPanelCoord.extraToHandDiff[self.m_seat]
	self.m_huCardShowDiff 		= CardPanelCoord.handCardDiff[SEAT_1]

	self.m_pointerDiff 			= CardPanelCoord.pointerDiff[seat]
	self.m_bigOutCardPos 		= CardPanelCoord.bigOutCardPos[seat]
	self.m_addCardDiff 			= CardPanelCoord.addCardDiff[seat]
	self.m_outBigCard 			= nil

	self.tingCardBgFile        = CardPanelCoord.handCardBg[SEAT_1]

	self:initView(userData)
	self:clearTableForGame()
end

function CardPanel:initView(userData)
end

function CardPanel:clearTableForGame(isReconn)
	self.m_handCards 	= {}
	self.m_huaCards     = {}
	self.m_outCards 	= {}
	self.m_extraCards 	= {}
	self.m_huCards 		= {}

	self:resetOutCardPosAndLayer()
	self:resetExtraCardPosAndLayer()
	self:resetHandCardPosAndLayer()

	self:clearDealCard()
	self.m_lastOutHandCard = nil

	self:clearHandCards()
	self:clearOutCards()
	self:clearExtraCards()
	
	self.isDealCard = false
	self.m_isHu 	= false
end

function CardPanel:onDealCardBd(handCards, buhuaCards)
	self:clearHandCards()
	self:resetHandCardPosAndLayer()
	self.m_handCards = handCards
	self.m_huaCards = buhuaCards
	self:enableSelect(false)
end

function CardPanel:clearDealCard()
end

function CardPanel:enableSelect(flag)
	self.m_selectFlag = flag
end

function CardPanel:onDealCardStep(cardIndexStart, cardIndexEnd)
	if self.m_seat ~= SEAT_1 then
		for i=cardIndexStart, cardIndexEnd do
			self:createOneHandCard(self.m_handCards[i]);
		end 
	else
		local cardAnimTb = {};
		for i=cardIndexStart, cardIndexEnd do
			local card = self:createOneHandCard(self.m_handCards[i]);
			table.insert(cardAnimTb, card);
		end 
		local startY = -80;
		for k,v in pairs(cardAnimTb) do
			local anim = v:addPropTranslate(0, kAnimNormal, 200, 0, 0, 0, startY, 0);
			anim:setDebugName("CardPanel.onDealCardStep")
			anim:setEvent(nil, function()
				v:removeProp(0)
			end)
		end
	end
	printInfo("cardIndexStart = " .. cardIndexStart)
	printInfo("cardIndexEnd = " .. cardIndexEnd)
end

function CardPanel:setHandAndHuaCards(handCards, huaCards)
	self.m_handCards = handCards
	self.m_huaCards = huaCards
end

-- 发牌结束
-- isNormal true 正常动画时间内结束 false 被抓牌中断
function CardPanel:onDealCardOver(isNormal)
	local dealHuaNum = self.m_gameData:getDealHuaNum()
	self.m_gameData:setHuaNum(dealHuaNum)
	G_RoomCfg:reduceRemainNum(dealHuaNum)

	-- 动画
	if self.m_seat == SEAT_1 then
		self:enableSelect(false)
		if isNormal then
			for i,v in ipairs(self.m_cardsVector) do
				v:gaiPai(self.m_extraAnGangImageFile)
			end
			kEffectPlayer:play(Effects.AudioDealCard);
			self.m_gaiPaiAnim = self:performWithDelay(function()
				self:onGaiPaiOver(isNormal)
			end, 600)
		else  --异常结束
			self:onGaiPaiOver(isNormal)
		end
	end
end

-- isNormal 是否正常结束
function CardPanel:onGaiPaiOver(isNormal)
	delete(self.m_gaiPaiAnim)
	self.m_gaiPaiAnim = nil
	self:reDrawHandCards(self.m_handCards)
	self:freshHandCardsPos(self.m_seat == SEAT_1)
	if isNormal then
		kEffectPlayer:play(Effects.AudioDealCard);
	end
end

-- 广播开始游戏（国标花牌）
function CardPanel:onGameStartBd(data)
end

function CardPanel:onOutCard(card)
	self.m_gameData:setIsSelectLiang(0)
	self:dealServerOutCard(card)
	if self.m_selectFlag then
		self.m_gameData:setIsSelectTing(0)
		self:cancelTing()
	end
end

function CardPanel:clearLiang()
	self.m_selectLiang = false
	self.m_selectNoLiangCards = {}
	self.m_selectLiangInfo = {}
	self.m_gameData:setIsSelectLiang(0)
end

function CardPanel:onAddCard(iCard, iHuaCards)
	printInfo("抓牌 0x%04x", iCard)
	self:clearLiang()
	kEffectPlayer:play(Effects.AudioGetCard)
	table.insert(self.m_handCards, iCard)
	if 1 ~= self.m_gameData:getIsTing() then
		self:freshHandCardsPos(false)
	else
		self:resetHandCardPosAndLayerLiang()
	end
	if iHuaCards and #iHuaCards > 0 then
		self.m_gameData:addHuaNum(#iHuaCards)
	end
end

function CardPanel:onOperateCard(card, iOpValue)
	local extraTb = {}
	local delTb = {}
	local operateValue = 0
	if bit.band(iOpValue, kOpeLeftChi) > 0 then
		extraTb = {card, card + 1, card + 2}
		delTb = {card + 1, card + 2}
		operateValue = kOpeLeftChi

	elseif bit.band(iOpValue, kOpeMiddleChi) > 0 then
		extraTb = {card - 1, card, card + 1}
		delTb = {card - 1, card + 1}
		operateValue = kOpeMiddleChi

	elseif bit.band(iOpValue, kOpeRightChi) > 0 then
		extraTb = {card - 2, card - 1, card}
		delTb = {card - 2, card - 1}
		operateValue = kOpeRightChi

	elseif bit.band(iOpValue, kOpePeng) > 0 then
		extraTb = {card, card, card}
		delTb = {card, card}
		operateValue = kOpePeng

	elseif bit.band(iOpValue, kOpePengGang) > 0 then
		extraTb = {card, card, card, card}
		delTb = {card, card, card}
		operateValue = kOpePengGang

	elseif bit.band(iOpValue, kOpeAnGang) > 0 then
		extraTb = {card, card, card, card}
		delTb = {card, card, card, card}
		operateValue = kOpeAnGang

	elseif bit.band(iOpValue, kOpeBuGang) > 0 then
		delTb = {card}
		self:switchPengToBuGang(card)
		operateValue = kOpeBuGang

	elseif bit.band(iOpValue, kOpeZiMo) > 0 then
		operateValue = kOpeZiMo
		self:onDisplayHu(card, true)

	elseif bit.band(iOpValue, kOpeHu) > 0 then
		operateValue = kOpeHu
		self:onDisplayHu(card, false)
	elseif bit.band(iOpValue, kOpePengGangHu) then
		operateValue = kOpePengGangHu
		self:onDisplayHu(card, false)
	end
	-- 播放动画
	playOperateSound(operateValue, self.m_userData:getSex())

	for _, value in ipairs(delTb) do
		printInfo("操作删除牌0x%04x", value)
		self:deleteCardImageAndValueByValue(value)
	end
	if #extraTb > 0 then
		local opTable = {
			operateValue = operateValue,
			cards = extraTb,
		}
		table.insert(self.m_extraCards, opTable)
		self:createOneExtraCardTb(opTable)
	end
	self:freshHandCardsPos(self.m_seat == SEAT_1)
	return extraTb
end

--
function CardPanel:freshTingInfo(iTingInfos)
	if self.m_seat ~= SEAT_1 then return end
	-- 为手牌添加 或者 清除听牌信息
	dump("为手牌添加 或者 清除听牌信息")
	dump(iTingInfos)
	iTingInfos = iTingInfos or {}
	self.m_gameData:setTingInfos(iTingInfos)
	-- 初始化听牌信息
	for i, v in ipairs(self.m_cardsVector) do
		v:setTingInfo(nil)
	end
	for k, info in pairs(iTingInfos) do 
		local count = 0
		for i, v in pairs(self.m_selectNoLiangCards) do
			if info.iOutCard == v.iCard then
				count = v.iCount
				break
			end
		end
		for i, v in ipairs(self.m_cardsVector) do
			if info.iOutCard == v:getValue() then
				printInfo("info.iOutCard %d , count : %d", info.iOutCard, count)
				if count > 0 then 
					count = count - 1
				else
					v:setTingInfo(info.iTingCards)
				end
			end
		end
	end
end

-- 显示胡
function CardPanel:onDisplayHu(hucard, isZiMo)
	-- 非自摸时 加进手牌列表
	-- if not isZiMo then
	-- 	self:createOneHandCard(hucard)
	-- end
	-- self:convertToHuCards()
end

function CardPanel:convertToHuCards()
end

function CardPanel:onGameOver(handCards, huCard)
	-- 有胡牌且 符合胡牌牌型 332
	handCards = ToolKit.deepcopy(handCards)
	if huCard then
		if #handCards % 3 == 2 then
			for i, cardValue in ipairs(handCards) do
				if cardValue == huCard then
					table.remove(handCards, i)
					break
				end
			end
			table.insert(handCards, huCard)
		else
			table.insert(handCards, huCard)
		end
	end
	self:reDrawExtraHandCards(handCards)
	self:switchAnGangToMing()
end

function CardPanel:switchAnGangToMing()
	for k, v in pairs(self.m_extraCardsVector) do
		if bit.band(v.operateValue, kOpeAnGang) > 0 then
			local card = table.remove(v.cards, 4)
			if card then card:removeSelf() end

			local secondCard = v.cards[2]
			local extraBgFile = self:formatExtraCardBg(self.m_extraCardBgFile, k, 4)
			local mingCard = new(Card, secondCard:getValue(), extraBgFile, self.m_extraCardImgFileReg)
				:addTo(self, secondCard:getLevel() + 3)
				:setBgAlign(self.m_cardAlign)

			mingCard:setScale(self.m_extraCardScale)
			self:adapterExtraCard(mingCard, k, 4)

			local width, height = mingCard:getOriginSize()
			local curPosX, curPosY = secondCard:getPos()
			mingCard:setOriginPos(curPosX + self.m_extraCardDiff.xGangDouble * width, 
				curPosY + self.m_extraCardDiff.yGangDouble * height)
			table.insert(v.cards, mingCard)
			break
		end	
	end
end

function CardPanel:resetExtraCardPosAndLayer()
	local pos = CardPanelCoord.extraCardStartPos[self.m_seat]
	local startDiff = CardPanelCoord.extraCardStartDiff[self.m_seat]
	self.m_extraCardPosX, self.m_extraCardPosY = pos.x, pos.y

	if self.m_seat == SEAT_1 then
		local width = 82 * math.abs(self.m_handCardDiff.xDouble * self.m_handCardScale) * 14
		self.m_extraCardPosX = display.cx - width / 2 + startDiff.x
	elseif self.m_seat == SEAT_3 then
		local width = 48 * math.abs(self.m_handCardDiff.xDouble * self.m_handCardScale) * 14 - 15
		self.m_extraCardPosX = display.cx + width / 2 + startDiff.x + 20
	-- 2 、 4
	elseif self.m_seat == SEAT_2 then
		local height = (60 * math.abs(self.m_handCardDiff.yDouble * self.m_handCardScale) * 14)
		self.m_extraCardPosY = display.cy + height / 2 + startDiff.y

	elseif self.m_seat == SEAT_4 then
		local height = (60 * math.abs(self.m_handCardDiff.yDouble * self.m_handCardScale) * 14)
		self.m_extraCardPosY = display.cy - height / 2 + startDiff.y
	end
	if not avoidLayer then
		self.m_extraCardLayer = CardPanelCoord.extraCardLayer[self.m_seat]
	end

	local pos = CardPanelCoord.huCardPos[self.m_seat]
	self.m_huCardPosX, self.m_huCardPosY = pos.x, pos.y

end

-- 重置手牌位置
local extraCardsDiffX2 = {
	95, 70, 40, 15, -10	
}
local extraCardsDiffX4 = {
	95, 70, 40, 15, -10	
}
function CardPanel:resetHandCardPosAndLayer()
	if not self.m_extraCardPosX or not self.m_extraCardLayer then
		self:resetExtraCardPosAndLayer()
	end

	self.m_handCardPosX = self.m_extraCardPosX + self.m_handToExtraDiff.x 
	self.m_handCardPosY = self.m_extraCardPosY + self.m_handToExtraDiff.y
	local groupNum = #self.m_extraCardsVector
	if self.m_seat == SEAT_2 then
		local diffX = extraCardsDiffX2[groupNum] or 120
		self.m_handCardPosX	= self.m_handCardPosX + diffX
	elseif self.m_seat == SEAT_4 then
		local diffX = extraCardsDiffX4[groupNum] or 120
		self.m_handCardPosX	= self.m_handCardPosX + diffX
	end
	if not avoidLayer then
		-- 重置层
		self.m_cardLayer = CardPanelCoord.handCardLayer[self.m_seat]
	end
end

local lineDiff = {
	{
		lineDiffX = {0, 3, 6},
		lineDiffY = {0, 0, 3},
	},
	{
		lineDiffX = {-1, 0, 0},
		lineDiffY = {0, 0, 0},
	},
	{
		lineDiffX = {-8, -3, 0},
		lineDiffY = {1, 1, 6},
	},
	{
		lineDiffX = {0, 0, -2},
		lineDiffY = {0, 0, 0},
	},
}
function CardPanel:freshOutCardLineStartPos()
	local pos = CardPanelCoord.outCardStartPos[self.m_seat]
	self.m_outCardLineNum = CardPanelCoord.outCardLineNum + CardPanelCoord.outCardLineStep * (self.m_outCardLine - 1)
	local outCardLineDiff = CardPanelCoord.outCardLineDiff[self.m_seat]
	local half = math.floor(self.m_outCardLineNum / 2)
	local isDouble = self.m_outCardLineNum % 2 == 0
	local diff = isDouble and (half - 0.5) or half
	local cardDiff = self.m_outCardDiff
	local lineDiffX = lineDiff[self.m_seat].lineDiffX
	local lineDiffY = lineDiff[self.m_seat].lineDiffY
	if self.m_seat == SEAT_1 then
		self.m_outCardPosX = pos.x - cardDiff.xDouble * diff * 56 * self.m_outCardScale + (lineDiffX[self.m_outCardLine] or 0) - 25
		self.m_outCardPosY = pos.y + outCardLineDiff.yDouble * 74 * (self.m_outCardLine - 1) * self.m_outCardScale + (lineDiffY[self.m_outCardLine] or 0)
	elseif self.m_seat == SEAT_3 then
		self.m_outCardPosX = pos.x - cardDiff.xDouble * diff * 46 * self.m_outCardScale + (lineDiffX[self.m_outCardLine] or 0) - 25
		self.m_outCardPosY = pos.y + outCardLineDiff.yDouble * 58 * (self.m_outCardLine - 1) * self.m_outCardScale + (lineDiffY[self.m_outCardLine] or 0)
	else
		self.m_outCardPosX = pos.x + outCardLineDiff.xDouble * 46 * (self.m_outCardLine - 1) * self.m_outCardScale + (lineDiffX[self.m_outCardLine] or 0)
		self.m_outCardPosY = pos.y - cardDiff.yDouble * diff * 55 * self.m_outCardScale + (lineDiffY[self.m_outCardLine] or 0) - 20
	end
end

function CardPanel:resetOutCardPosAndLayer()
	self.m_outCardLine = 1
	self:freshOutCardLineStartPos()
	if not avoidLayer then
		self.m_outCardLayer = CardPanelCoord.outCardLayer[self.m_seat]
	end
end

function CardPanel:clearHandCards()
	for k,v in pairs(self.m_cardsVector) do
		v:removeSelf()
	end

	for i = 1, #self.m_huCardsVector do
		self.m_huCardsVector[i]:removeSelf()
	end

	self.m_cardsVector = {}
	self.m_handCards = {}
	self.m_huCardsVector = {}

	if self.m_showHuCardLayer then
		self.m_showHuCardLayer:removeAllChildren(true)
		self.m_showHuCardLayer:removeSelf()
		self.m_showHuCardLayer = nil
	end
end

function CardPanel:clearOutCards()
	for k,v in pairs(self.m_outCardsVector) do
		v:removeSelf()
	end
	self.m_outCardsVector = {}
	self.m_outCards = {}
end

function CardPanel:clearExtraCards()
	for k,v in pairs(self.m_extraCardsVector) do
		for _, card in pairs(v.cards) do
			card:removeSelf()
		end
	end
	self.m_extraCardsVector = {}
	self.m_extraCards = {}
end

-- handCards 如果有则覆盖刷新  为nil则用缓存的手牌刷新显示
function CardPanel:reDrawHandCards(handCardsTb)
	self:clearHandCards()
	self.m_handCards = handCardsTb or {}
	self:resetHandCardPosAndLayer()
	for i,v in ipairs(self.m_handCards) do
		self:createOneHandCard(v)
	end
end

function CardPanel:resetHandCardPosAndLayerLiang()
	if not self.m_extraCardPosX or not self.m_extraCardLayer then
		self:resetExtraCardPosAndLayer()
	end
	printInfo("seat : %d , self.m_extraCardPosX :%d , self.m_extraCardPosY : %d", self.m_seat, self.m_extraCardPosX , self.m_extraCardPosY)

	self.m_handCardPosX = self.m_extraCardPosX + self.m_handToExtraDiff.x 
	self.m_handCardPosY = self.m_extraCardPosY + self.m_handToExtraDiff.y
	local groupNum = #self.m_extraCardsVector
	if self.m_seat == SEAT_2 then
		local diffX = extraCardsDiffX2[groupNum] or 120
		-- self.m_handCardPosX	= self.m_handCardPosX + diffX
	elseif self.m_seat == SEAT_4 then
		local diffX = extraCardsDiffX4[groupNum] or 120
		-- self.m_handCardPosX	= self.m_handCardPosX + diffX
	end
	if not avoidLayer then
		-- 重置层
		self.m_cardLayer = CardPanelCoord.handCardLayer[self.m_seat]
	end
	printInfo("seat : %d , self.m_handCardPosX :%d , self.m_handCardPosY : %d", self.m_seat, self.m_handCardPosX , self.m_handCardPosY)

	-- 重置顺序
	for i = 1, #self.m_cardsVector do
		local diff = { x = 0, y = 0}
		local card = self.m_cardsVector[i]
		card:setLevel(self.m_cardLayer)
		local width, height = card:getOriginSize()
		self.m_handCardPosX = self.m_handCardPosX + self.m_extraCardDiff.xDouble * width + diff.x
		self.m_handCardPosY = self.m_handCardPosY + self.m_extraCardDiff.yDouble * height + diff.y
		if self.m_seat == SEAT_2 then
			self.m_cardLayer = self.m_cardLayer - 1
		end
	end
	printInfo("seat : %d , self.m_handCardPosX :%d , self.m_handCardPosY : %d", self.m_seat, self.m_handCardPosX , self.m_handCardPosY)
end

-- 绘制亮倒
function CardPanel:reDrawHandCardsLiang(handCardsTb)
	if not handCardsTb then
		return
	end
	self:clearHandCards()
	local handCards = {}
	for k, v in pairs(handCardsTb) do
		handCards[#handCards + 1] = v.iCard
	end
	self.m_handCards = handCards
	-- self:resetHandCardPosAndLayerLiang()
	self.m_handCardPosX = self.m_extraCardPosX + self.m_extraHandCardDiff.x
	self.m_handCardPosY	= self.m_extraCardPosY + self.m_extraHandCardDiff.y
	local preExtraNum = #self.m_extraCardsVector * 3
	for i, v in pairs(handCardsTb) do
		local index = i + preExtraNum
		local imgFileReg = self.m_extraCardImgFileReg
		local extraBgFile = self:formatExtraCardBg(self.m_extraCardBgFile, math.ceil(index / 3), (index - 1) % 3 + 1)
		-- 如果不亮出来
		if 1 ~= v.iType and self.m_seat ~= SEAT_1 then
			imgFileReg = nil
			extraBgFile = self:formatExtraCardBg(self.m_extraAnGangImageFile, math.ceil(index / 3), (index - 1) % 3 + 1)	
		end
		local needDiffFlag = i == #self.m_handCards and i % 3 == 2
		local card = self:createOneExtraHandCard(v.iCard, extraBgFile, imgFileReg, needDiffFlag)
		if self.m_seat == SEAT_1 and 1 ~= v.iType then
			if card then
				card:setDarkColor()
			end
		end
	end
	printInfo("seat : %d , self.m_extraCardPosX :%d , self.m_extraCardPosY : %d", self.m_seat, self.m_extraCardPosX , self.m_extraCardPosY)
end

function CardPanel:drawHuCardsLiang( huCardsTb )
	if not huCardsTb then return end

	local card = nil
	for i = 1, #huCardsTb do
		card = self:createOneHuCard(huCardsTb[i])
		table.insert(self.m_huCardsVector, card)
	end

	if self.m_huCardsVector and 0 < #self.m_huCardsVector then
		local width, height = card:getOriginSize()
		self.m_showHuCardLayer = new(Image, "kwx_room/img_hu_bg.png", nil, nil, 15,15,15,15)
		self.m_showHuCardLayer:setSize(#huCardsTb*width + 60, height + 10)
		self.m_showHuCardLayer:setPos(self.m_huCardPosX - 40, self.m_huCardPosY-33)
		self.m_showHuCardLayer:addTo(self, self.m_cardLayer-1)

		local huIco = new(Image, "kwx_room/img_strhu.png")
		huIco:setAlign(kAlignLeft)
		self.m_showHuCardLayer:addChild(huIco)

		for i = 1, #self.m_huCardsVector do
			self.m_huCardsVector[i]:addTo(self, self.m_cardLayer)
		end
	end
end

function CardPanel:reDrawExtraHandCards(handCardsTb)
	self:clearHandCards()
	self.m_handCards = handCardsTb or {}
	self.m_handCardPosX = self.m_extraCardPosX + self.m_extraHandCardDiff.x
	self.m_handCardPosY	= self.m_extraCardPosY + self.m_extraHandCardDiff.y
	local preExtraNum = #self.m_extraCardsVector * 3
	for i,v in ipairs(self.m_handCards) do
		local index = i + preExtraNum 
		local extraBgFile = self:formatExtraCardBg(self.m_extraCardBgFile, math.ceil(index / 3), (index - 1) % 3 + 1)
		local needDiffFlag = i == #self.m_handCards and i % 3 == 2
		self:createOneExtraHandCard(v, extraBgFile, self.m_extraCardImgFileReg, needDiffFlag)
	end
end

function CardPanel:reDrawOutCards(outCardsTb)
	self:clearOutCards()
	self:resetOutCardPosAndLayer()
	self.m_outCards = outCardsTb
	for i=1, #outCardsTb do
		local card = outCardsTb[i]
		self:createOneOutCard(card)
	end
end

function CardPanel:reDrawExtraCards(extraCards)
	self:clearExtraCards()
	self:resetExtraCardPosAndLayer()
	for i=1, #extraCards do
		local info = extraCards[i]
		local card = info.card
		local opValue = info.opValue
		local cards = getCardsTbByOpAndCard(info.opValue, info.card)
		if #cards == 4 then
			for i=1, #cards do
				cards[i] = info.card
			end
		end
		local opTable = {
			operateValue = opValue,
			cards = cards,
		}
		table.insert(self.m_extraCards, opTable)
		self:createOneExtraCardTb(opTable)
	end
end

function CardPanel:setHandCards(byteCards)
	self.m_handCards = byteCards
end

function CardPanel:getHandCards()
	return self.m_handCards
end

function CardPanel:getExtraCards()
	return self.m_extraCards
end

function CardPanel:_freshHandCardPos()
	self:resetHandCardPosAndLayer()
	-- 重置顺序
	for i=1, #self.m_cardsVector do
		local card = self.m_cardsVector[i]
		card:setOriginPos(self.m_handCardPosX, self.m_handCardPosY)
		card:setLevel(self.m_cardLayer)
		local width, height = card:getOriginSize()
		self.m_handCardPosX = self.m_handCardPosX + self.m_handCardDiff.xDouble * width * self.m_handCardScale
		self.m_handCardPosY = self.m_handCardPosY + self.m_handCardDiff.yDouble * height * self.m_handCardScale
		if self.m_seat == SEAT_2 then
			self.m_cardLayer = self.m_cardLayer -1
		end
		if i == #self.m_cardsVector and i % 3 == 2 then
			card:shiftMove(self.m_addCardDiff.x, self.m_addCardDiff.y)
		end
	end
end

function CardPanel:freshHandCardsPos(sortFlag)
	if 1 == self.m_gameData:getIsTing() then
		return
	end
	if self.m_seat == SEAT_1 then
		self:resetHandCards()
	end
	if #self.m_cardsVector == 0 then return end

	if sortFlag and self.m_seat == SEAT_1 then
		for i,v in ipairs(self.m_cardsVector) do
			v.sortId = i
		end
		-- 稳定排序
		table.sort(self.m_cardsVector, function(card1, card2)
			local value1, value2 = card1:getValue(), card2:getValue()
			if card1:isOuted() and card2:isOuted() then
				return value1 < value2
			elseif card1:isOuted() then
				return false
			elseif card2:isOuted() then
				return true
			elseif value1 == value2 then
				return card1.sortId < card2.sortId
			else
				return value1 < value2
			end
		end)
	end
	self:_freshHandCardPos()
end

-- isAddCard 是否摸牌
function CardPanel:createOneHandCard(value, isAddCard)
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
	-- card:setEventTouch(self, self.onTouch);

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

function CardPanel:changeExtraLayer(group, index)
	local num = (group - 1) * 3 + (index == 4 and 2 or index)
	if self.m_seat == SEAT_2 then 
		self.m_extraCardLayer = self.m_extraCardLayer - 1
	elseif self.m_seat == SEAT_3 and num > 4 then
		printInfo("layer降低1")
		self.m_extraCardLayer = self.m_extraCardLayer - 1
	end
end

function CardPanel:createOneHuCard(value)
	if not self.m_huCardPosX or not self.m_cardLayer then
		self:resetHandCardPosAndLayer()
	end

	-- x 间距
	local diff = { x = -30, y = 30} 


	local card = new(Card, value, self.tingCardBgFile, CardPanelCoord.extraCardImage[SEAT_1])
			:setOriginPos(self.m_huCardPosX + diff.x, self.m_huCardPosY + diff.y)
			:setBgAlign(kAlignBottomLeft)
			:setScale(0.4)
			
	local width, height = card:getOriginSize()
	self.m_huCardPosX = self.m_huCardPosX + self.m_handCardDiff.xDouble * width * self.m_handCardScale + diff.x
	--self.m_handCardPosY = self.m_handCardPosY + self.m_handCardDiff.yDouble * height * self.m_handCardScale + diff.y
	-- 第二号玩家的手牌受顺序影响 需要处理层级关系
	if self.m_seat == SEAT_2 then
		self.m_cardLayer = self.m_cardLayer - 1
	end
	return card
end

-- 吃碰杠
function CardPanel:createOneExtraHandCard(value, bgFile, imgFileReg, isLastCard)
	if not self.m_handCardPosX or not self.m_cardLayer then
		self:resetHandCardPosAndLayer()
	end
	local diff 
	if isLastCard then
		diff = self.m_addCardDiff
	else
		diff = { x = 0, y = 0} 
	end
	-- 该张牌的数量
	local num = #self.m_cardsVector + 1
	-- 换算成组
	local groupNum = math.ceil(num / 3) + #self.m_extraCardsVector
	local index = (num - 1) % 3 + 1
	local card = new(Card, value, bgFile, imgFileReg, self:getExtraCardIndex(groupNum, index))
		:setOriginPos(self.m_handCardPosX + self.m_extraToHandDiff.x + diff.x, self.m_handCardPosY + self.m_extraToHandDiff.y + diff.y)
		:addTo(self, self.m_extraCardLayer)
		:setBgAlign(self.m_cardAlign)

	card:setScale(self.m_extraCardScale)
	table.insert(self.m_cardsVector, card)

	local index = (#self.m_cardsVector - 1) % 3 + 1
	if self.m_seat == SEAT_1 then
		card:setScale(1.2)
		self:adapterExtraCard(card, groupNum, index)
		card:scaleCardTo(0.9, 0.9)
	else
		self:adapterExtraCard(card, groupNum, index)
	end
	local width, height = card:getOriginSize()
	self.m_handCardPosX = self.m_handCardPosX + self.m_extraCardDiff.xDouble * width + diff.x
	self.m_handCardPosY = self.m_handCardPosY + self.m_extraCardDiff.yDouble * height + diff.y

	-- 第二号玩家的手牌受顺序影响 需要处理层级关系
	self:changeExtraLayer(groupNum,	index)
	return card
end

function CardPanel:getTotalLineCardNeed()
	local num = CardPanelCoord.outCardLineNum
	local step = CardPanelCoord.outCardLineStep
	local needNum = (num + num + (self.m_outCardLine - 1) * step) * self.m_outCardLine / 2
	return needNum
end

local cardBgDiffX1 = {
	{-3, -3, -4, -8, -11, -5, -8, -10, -13, -4}, 
	{0, -2, -4, -6, -1, -4, -5, 0, 0, 0}, 
	{-1, -3, -4, -1, -1, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
}

local cardBgDiffY1 = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
}

-- 玩家2
local cardBgDiffX2 = {
	--1   2   3    4    5    6    7    8
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
}
local cardBgDiffY2 = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{},
}

-- 玩家3
local cardBgDiffX3 = {
	{3, 3, 5, 8, 11, 12, 12, 14, 15, 14}, 
	{0, 1, 3, 5, 3, 4, 4, 2, 2, 2}, 
	{-2, -2, -2, -2, -2, -2, 0, 0, 0, 0}, 
	{-2, -2, -2, -2, -2, -2, 0, 0, 0, 0}, 
}
local cardBgDiffY3 = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
}

-- 玩家4
local cardBgDiffX4 = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
}
local cardBgDiffY4 = {
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
}

local cardBgDiffX = { cardBgDiffX1, cardBgDiffX2, cardBgDiffX3, cardBgDiffX4}
local cardBgDiffY = { cardBgDiffY1, cardBgDiffY2, cardBgDiffY3, cardBgDiffY4}

function CardPanel:getOutCardIndex(index)
	if self.m_seat == SEAT_2 or self.m_seat == SEAT_4 then
		return 1
	end
	if self.m_seat == SEAT_3 then
		index = self.m_outCardLineNum - index + 1
	end
	-- 根据递增当前行数的偏移量
	index = index + (self.m_outCardLine - 1)
	if self.m_seat == SEAT_1 then
		printInfo("seat1 Index = %d", index)
	end
	-- 第六个位置用的是第五套花色
	if index == 6 then index = 5 end
	if self.m_seat == SEAT_3 then
		if index == 4 then
			index = 2
		elseif index == 7 then
			index = 9
		elseif index == 1 then
			index = 0
		elseif index <= 3 then
			index = 1
		elseif index >= 8 then
			index = 10
		end
	end
	return index
end

function CardPanel:createOneOutCard(value)
	if not self.m_outCardPosX or not self.m_outCardLayer then
		self:resetOutCardPosAndLayer()
	end
	local line = self.m_outCardLine  -- 当前多少行
	local originLineNum = CardPanelCoord.outCardLineNum
	local nowNum = 0
	if line == 1 then 
		nowNum = #self.m_outCardsVector
	else
		local lines = line - 1
		local step = CardPanelCoord.outCardLineStep
		local preNum = originLineNum * lines + (lines - 1) * step
		nowNum = #self.m_outCardsVector - preNum
	end
	-- printInfo("line = %d", line)
	-- printInfo("nowNum = %d", nowNum)
	if line > 3 then line = 3 end  --麻将子多于三行 显示容错
	if nowNum > 10 then nowNum = 10 end
	-- line - num
	local bgFile = string.format(self.m_outCardBgFile, line, nowNum + 1)

	local bgDiffY = cardBgDiffY[self.m_seat] or {}
	local diffX = cardBgDiffX[self.m_seat][self.m_outCardLine][nowNum] or 0
	local diffY = cardBgDiffY[self.m_outCardLine] and bgDiffY[self.m_outCardLine][nowNum] or 0
	local card = new(Card, value, bgFile, self.m_outCardImgFileReg, self:getOutCardIndex(nowNum + 1))
			:setOriginPos(self.m_outCardPosX + diffX, self.m_outCardPosY + diffY)
			:addTo(self, self.m_outCardLayer)
			:setBgAlign(self.m_cardAlign)

	-- card:setScale(self.m_outCardScale)
	table.insert(self.m_outCardsVector, card)

	local needNum = self:getTotalLineCardNeed()	
	self:adapterOutCard(card, needNum, nowNum + 1)

	-- 备份上一次的层和麻将子数
	self.m_lastOutCardLayer = self.m_outCardLayer
	self.m_lastOutCardLine  = self.m_outCardLine
	self.m_lastOutCardPosX, self.m_lastOutCardPosY = self.m_outCardPosX, self.m_outCardPosY

	local width, height = card:getOriginSize()
	self.m_outCardPosX = self.m_outCardPosX + self.m_outCardDiff.xDouble * width * self.m_outCardScale
	self.m_outCardPosY = self.m_outCardPosY + self.m_outCardDiff.yDouble * height * self.m_outCardScale
	-- 换行

	if #self.m_outCardsVector == needNum then
		self.m_outCardLine = self.m_outCardLine + 1
		self:freshOutCardLineStartPos()
		if self.m_seat == SEAT_1 then
			self.m_outCardLayer = self.m_outCardLayer - (self.m_outCardLineNum - CardPanelCoord.outCardLineStep) - 2
		elseif self.m_seat == SEAT_2 then
			self.m_outCardLayer = self.m_outCardLayer + (self.m_outCardLineNum - CardPanelCoord.outCardLineStep) + 2
		elseif self.m_seat == SEAT_3 then
			self.m_outCardLayer = self.m_outCardLayer + (self.m_outCardLineNum - CardPanelCoord.outCardLineStep) + 2
		elseif self.m_seat == SEAT_4 then
			self.m_outCardLayer = self.m_outCardLayer + (self.m_outCardLineNum - CardPanelCoord.outCardLineStep) + 2
		end
	elseif self.m_seat == SEAT_2 then
		self.m_outCardLayer = self.m_outCardLayer - 1
	elseif self.m_seat == SEAT_1 then
		if nowNum < self.m_outCardLineNum / 2 then
			self.m_outCardLayer = self.m_outCardLayer + 1
		else
			self.m_outCardLayer = self.m_outCardLayer - 1
		end
	elseif self.m_seat == SEAT_3 then
		if nowNum < self.m_outCardLineNum / 2 then
			self.m_outCardLayer = self.m_outCardLayer + 1
		else
			self.m_outCardLayer = self.m_outCardLayer - 1
		end
	end
	return card
end

function CardPanel:getExtraCardIndex(groupNum, k)
	if self.m_seat ~= SEAT_3 then return 1 end
	-- 自己的花色固定返回格式串1
	local index = (groupNum - 1) * 3 + (k == 4 and 2 or k)
	local totalNum = 14
	-- 对家花色逆序，另外多两个花色
	if index > totalNum then index = totalNum end
	index = totalNum - index + 1
	index = index - 2
	if index == 6 then index = 5 end
	if index == 12 then index = 11 end
	if index == 4 then index = 5 end
	if index == 2 then index = 1 end
	if index == 3 then index = 1 end
	if index == 1 then index = 0 end
	return index
end

function CardPanel:formatExtraCardBg(bgRegFile, groupNum, k)
	if self.m_seat == SEAT_1 then return bgRegFile end
	local index = (groupNum - 1) * 3 + (k == 4 and 2 or k)
	local totalNum = 12
	-- if self.m_seat == SEAT_3 then
	-- 	index = totalNum - index + 1
	-- end
	if index > totalNum then index = totalNum end
	local imgFileName = string.format(bgRegFile, index)
	return imgFileName
end

local outCardDiffX1 = {
	{1, 2, 2, 3, 4, 4, -3, -2, -2, -1},
	{1, 1, 3, 4, 4, -2, -1, -1},
	{1, 2, 3, 4, -1, -1, },
}
local outCardDiffY1 = {
	{-16, -16, -16, -16, -16, -16, -16, -16, -16, -16},
	{-16, -16, -16, -16, -16, -16, -16, -16, -16, -16},
	{-17, -17, -17, -17, -17, -17, -17, -17, -17, -17},
}

local outCardDiffX2 = {
	--从右到左
	{30, 23, 15, 8, 0, -8, -15, -22, -30, -37},
	{19, 13, 6, 0, -7, -13, -20, -26, -35},
	{10, 4, -2, -7, -11, -16, -28, -35},
}
local outCardDiffY2 = {
	{-15, -16, -16, -16, -16, -16, -16, -16, -17, -17},
	{-15, -16, -16, -16, -16, -16, -17, -17, -16},
	{-15, -16, -16, -17, -17, -16, -16, -16},
}

local outCardDiffX3 = {
	--从右到左
	{0, -1, 0, -1, -2, -2, -1, 0, 0, 0},
	{0, 0, 0, -1, -2, 1, 0, 1, 0, 0},
	{0, 1, 1, 1, 0, 0, 0, 0, 0, 0},
}
local outCardDiffY3 = {
	{-7, -7, -7, -7, -7, -7, -7, -7, -7, -7},
	{-7, -7, -7, -7, -7, -7, -7, -7, -7, -7},
	{-9, -9, -9, -9, -9, -9, -9, -9, -9, -9},
}

local outCardDiffX4 = {
	--从右到左
	{37, 30, 22, 15, 7, -1, -8, -14, -22, -29},
	{26, 19, 14, 7, 1, -6, -12, -19, -28},
	{17, 12, 7, 2, -3, -9, -20, -28},
}
local outCardDiffY4 = {
	{-17, -17, -17, -16, -16, -16, -16, -16, -16, -16},
	{-17, -17, -16, -16, -16, -16, -16, -15, -15},
	{-17, -17, -17, -16, -16, -15, -15, -15},
}

local outCardDiffXTb = {outCardDiffX1, outCardDiffX2, outCardDiffX3, outCardDiffX4}
local outCardDiffYTb = {outCardDiffY1, outCardDiffY2, outCardDiffY3, outCardDiffY4}

function CardPanel:adapterOutCard(card, needNum, nowNum)
	local lineNum = self.m_outCardLineNum
	local isHalf = (needNum - #self.m_outCardsVector) < lineNum / 2
	local outCardDiffX = outCardDiffXTb[self.m_seat] or {}
	local outCardDiffY = outCardDiffYTb[self.m_seat] or {}

	local diffXTb = outCardDiffX[self.m_outCardLine] or {}
	local diffYTb = outCardDiffY[self.m_outCardLine] or {}

	local diffX = diffXTb[nowNum] or 0
	local diffY = diffYTb[nowNum] or -5
	if self.m_seat == SEAT_2 then
		card:shiftCardMove(diffX, diffY)
	elseif self.m_seat == SEAT_4 then
		card:shiftCardMove(diffX, diffY)
	elseif self.m_seat == SEAT_3 then
		card:scaleCardTo(0.87, 0.725)
		card:shiftCardMove(diffX, diffY)
	elseif self.m_seat == SEAT_1 then
		card:shiftCardMove(diffX, diffY)
	end
end

-- 吃碰杠的牌坐标偏移  玩家 2 4 固定
local extraCardDiff = {
	{
		diffX = {},
		diffY = {},
	},
	{
		diffX = {0, 0, 0,  0, 0, 0,  0, 0, 0,  0, 0, 0,  -9, -15, 0,  },
		diffY = {},
	},
	{				
		diffX = {-1, -1, -1,  -1, -1, -1,  -1, -2, -2,  -2, -1, -1,  -1, -1, -1,  },
		diffY = {},
	},
	{
		diffX = {0, 0, 0,  0, 0, 0,  0, 0, 0,  0, 0, 0,  -9, -15, 0,  },
		diffY = {},
	},
}

local extraHuaDiffX1 = {
	1, 2, 3, 3, 4, 4, -2, -1, -1, -1,
}
local extraHuaDiffY1 = {
	-14, -14, -14, -14, -14, -14, -14, -14, -14, -14,
}
local extraHuaDiffX2 = {
	--从右到左
	50, 42, 34,    25, 18, 9,    1, -9, -16,     -25, -34, -43,   -43, -46
}
local extraHuaDiffY2 = {
	-16, -15, -15,    -15, -16, -16,    -16, -16, -16,   -16, -16, -16, -16, -16, -14,
}
local extraHuaDiffX3 = {
	--从右到左
	0, 0, 0, 0, -1, -1, -2, -1, -1, 0, 0, 1, 1, 1,
}
local extraHuaDiffY3 = {
	-8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8,
}
local extraHuaDiffX4 = {
	--从右到左
	63, 53, 44,    37, 28, 18,    10, 0, -9,     -17, -25, -34,   -35, -35
}
local extraHuaDiffY4 = {
	-16, -15, -16,    -16, -16, -16,    -16, -16, -16,  -16, -16, -16, -16, -16, -16,
}
local extraHuaDiffXTb = {extraHuaDiffX1, extraHuaDiffX2, extraHuaDiffX3, extraHuaDiffX4}
local extraHuaDiffYTb = {extraHuaDiffY1, extraHuaDiffY2, extraHuaDiffY3, extraHuaDiffY4}

function CardPanel:adapterExtraCard(card, groupNum, index)
	local diffX, diffY = 0, 0	
	-- printInfo("groupNum = %d, index = %d", groupNum, index)
	local num = (groupNum - 1) * 3 + (index == 4 and 2 or index)
	diffX = extraCardDiff[self.m_seat].diffX[num] or 0
	diffY = extraCardDiff[self.m_seat].diffY[num] or 0
	-- printInfo("diffX = %d, diffY = %d", diffX, diffY)
	local huaDiffX = extraHuaDiffXTb[self.m_seat]
	local huaDiffY = extraHuaDiffYTb[self.m_seat]
	if self.m_seat == SEAT_2 then	--
		card:shiftMove(diffX, diffY)
		card:shiftCardMove(huaDiffX[num], huaDiffY[num])
	elseif self.m_seat == SEAT_4 then --
		card:shiftMove(diffX, diffY)
		card:shiftCardMove(huaDiffX[num], huaDiffY[num])
	elseif self.m_seat == SEAT_3 then --
		card:scaleCardTo(0.783, 0.65)
		card:shiftMove(diffX, diffY)
		card:shiftCardMove(huaDiffX[num], huaDiffY[num])
	elseif self.m_seat == SEAT_1 then  --Card
		card:shiftMove(diffX, diffY)
		card:scaleCardTo(0.8, 0.8)
		card:shiftCardMove(0, -14)
	end
end

function CardPanel:createOneExtraCardTb(opTable)
	if not self.m_extraCardPosX or not self.m_extraCardLayer then
		self:resetExtraCardPosAndLayer()
	end
	local cards = {}
	local operateValue = opTable.operateValue
	local groupNum = #self.m_extraCardsVector + 1
	if bit.band(operateValue, kOpePeng) > 0 or
		bit.band(operateValue, kOpeLeftChi) > 0 or
		bit.band(operateValue, kOpeRightChi) > 0 or
		bit.band(operateValue, kOpeMiddleChi) > 0 then
		for k,value in ipairs(opTable.cards) do
			local card = new(Card, value, self:formatExtraCardBg(self.m_extraCardBgFile, groupNum, k), self.m_extraCardImgFileReg, self:getExtraCardIndex(groupNum, k))
				:setOriginPos(self.m_extraCardPosX + self.m_extraToHandDiff.x, self.m_extraCardPosY + self.m_extraToHandDiff.y)
				:addTo(self, self.m_extraCardLayer)
				:setBgAlign(self.m_cardAlign)

			card:setScale(self.m_extraCardScale)
			self:adapterExtraCard(card, groupNum, k)
			local width, height = card:getOriginSize()
			self.m_extraCardPosX = self.m_extraCardPosX + self.m_extraCardDiff.xDouble * width
			self.m_extraCardPosY = self.m_extraCardPosY + self.m_extraCardDiff.yDouble * height

			table.insert(cards, card)

			self:changeExtraLayer(groupNum, k)
		end
	elseif bit.band(operateValue, kOpePengGang) > 0 or bit.band(operateValue, kOpeBuGang) > 0 then
		for k,value in ipairs(opTable.cards) do
			local card 
			if k ~= 4 then
				card = new(Card, value, self:formatExtraCardBg(self.m_extraCardBgFile, groupNum, k), self.m_extraCardImgFileReg, self:getExtraCardIndex(groupNum, k))
					:setOriginPos(self.m_extraCardPosX + self.m_extraToHandDiff.x, self.m_extraCardPosY + self.m_extraToHandDiff.y)
					:addTo(self, self.m_extraCardLayer)
					:setBgAlign(self.m_cardAlign)

				card:setScale(self.m_extraCardScale)
				local width, height = card:getOriginSize()
				self.m_extraCardPosX = self.m_extraCardPosX + self.m_extraCardDiff.xDouble * width
				self.m_extraCardPosY = self.m_extraCardPosY + self.m_extraCardDiff.yDouble * height
				self:changeExtraLayer(groupNum, k)
			else
				local curLayer = self.m_extraCardLayer + 3
				card = new(Card, value, self:formatExtraCardBg(self.m_extraCardBgFile, groupNum, k), self.m_extraCardImgFileReg, self:getExtraCardIndex(groupNum, k))
					:addTo(self, curLayer)
					:setBgAlign(self.m_cardAlign)

				card:setScale(self.m_extraCardScale)
				local width, height = card:getOriginSize()
				local curPosX = self.m_extraCardPosX - 2*self.m_extraCardDiff.xDouble * width
				local curPosY = self.m_extraCardPosY - 2*self.m_extraCardDiff.yDouble * height
				card:setOriginPos(curPosX + self.m_extraCardDiff.xGangDouble * width + self.m_extraToHandDiff.x, 
					curPosY + self.m_extraCardDiff.yGangDouble * height + self.m_extraToHandDiff.y)
			end
			self:adapterExtraCard(card, groupNum, k)
			table.insert(cards, card)
		end
	elseif bit.band(operateValue, kOpeAnGang) > 0 then
		for k,value in ipairs(opTable.cards) do
			local card 
			if k ~= 4 then
				card = new(Card, 0, self:formatExtraCardBg(self.m_extraAnGangImageFile, groupNum, k), nil, nil)
					:setOriginPos(self.m_extraCardPosX + self.m_extraToHandDiff.x, self.m_extraCardPosY + self.m_extraToHandDiff.y)
					:addTo(self, self.m_extraCardLayer)
					:setBgAlign(self.m_cardAlign)
					:setValue(value)
				card:setScale(self.m_extraCardScale)
				local width, height = card:getOriginSize()
				self.m_extraCardPosX = self.m_extraCardPosX + self.m_extraCardDiff.xDouble * width
				self.m_extraCardPosY = self.m_extraCardPosY + self.m_extraCardDiff.yDouble * height
				self:changeExtraLayer(groupNum, k)
			else
				--自己的暗杠最上面的明牌
				if self.m_seat == SEAT_1 then
					card = new(Card, value, self:formatExtraCardBg(self.m_extraCardBgFile, groupNum, k), self.m_extraCardImgFileReg, self:getExtraCardIndex(groupNum, k))
				else
					card = new(Card, 0, self:formatExtraCardBg(self.m_extraAnGangImageFile, groupNum, k), nil, nil)
				end
				local curLayer = self.m_extraCardLayer + 3
				card:setBgAlign(self.m_cardAlign)
					:addTo(self, curLayer)
					:setValue(value)
					
				card:setScale(self.m_extraCardScale)
				local width, height = card:getOriginSize()
				local curPosX = self.m_extraCardPosX - 2*self.m_extraCardDiff.xDouble * width
				local curPosY = self.m_extraCardPosY - 2*self.m_extraCardDiff.yDouble * height
				card:setOriginPos(curPosX + self.m_extraCardDiff.xGangDouble * width + self.m_extraToHandDiff.x, 
					curPosY + self.m_extraCardDiff.yGangDouble * height + self.m_extraToHandDiff.y)
			end
			self:adapterExtraCard(card, groupNum, k)
			table.insert(cards, card)
		end
	end
	self.m_extraCardPosX = self.m_extraCardPosX + self.m_extraCardGroupSpace.x
	self.m_extraCardPosY = self.m_extraCardPosY + self.m_extraCardGroupSpace.y
	table.insert(self.m_extraCardsVector, {
		operateValue = operateValue,
		cards = cards
	})
	return card
end

function CardPanel:switchPengToBuGang(card)
	for k, v in pairs(self.m_extraCardsVector) do
		if bit.band(v.operateValue, kOpePeng) > 0 and v.cards[1]:getValue() == card then
			local secondCard = v.cards[2]
			local extraBgFile = self:formatExtraCardBg(self.m_extraCardBgFile, k, 4)
			local buCard = new(Card, card, extraBgFile, self.m_extraCardImgFileReg)
				:addTo(self, secondCard:getLevel())
				:setBgAlign(self.m_cardAlign)

			buCard:setScale(self.m_extraCardScale)
			self:adapterExtraCard(buCard, k, 4)

			local width, height = buCard:getOriginSize()
			local curPosX, curPosY = secondCard:getPos()
			buCard:setOriginPos(curPosX + self.m_extraCardDiff.xGangDouble * width, 
				curPosY + self.m_extraCardDiff.yGangDouble * height)
			-- 去掉杠 加补杠
			v.operateValue = bit.bxor(v.operateValue, kOpePeng)
			v.operateValue = bit.bor(v.operateValue, kOpeBuGang)
			table.insert(v.cards, buCard)

			break
		end	
	end

	for k,v in pairs(self.m_extraCards) do
		-- 找到了碰 转成 暗杠
		if bit.band(v.operateValue, kOpePeng) > 0 and v.cards[1] == card then
			-- 去掉杠 加补杠
			v.operateValue = bit.bxor(v.operateValue, kOpePeng)
			v.operateValue = bit.bor(v.operateValue, kOpeBuGang)
			v.cards = {card, card, card, card}
			break
		end
	end	
end

function CardPanel:switchBuGangToPeng(card)
	for k, v in pairs(self.m_extraCardsVector) do
		if bit.band(v.operateValue, kOpeBuGang) > 0 and v.cards[1]:getValue() == card then
			local lastCard = table.remove(v.cards, 4)
			if lastCard then
				lastCard:removeSelf()
			end
			v.operateValue = bit.bxor(v.operateValue, kOpeBuGang)
			v.operateValue = bit.bor(v.operateValue, kOpePeng)
			break
		end	
	end

	for k,v in pairs(self.m_extraCards) do
		-- 找到了碰 转成 暗杠
		if bit.band(v.operateValue, kOpeBuGang) > 0 and v.cards[1] == card then
			table.remove(v.cards, 4)
			v.operateValue = bit.bxor(v.operateValue, kOpeBuGang)
			v.operateValue = bit.bor(v.operateValue, kOpePeng)
			break
		end
	end
end

function CardPanel:playOutCardAnim(cardValue, card)
	if self.lastOutCard and card then
		local dstX, dstY = self.lastOutCard:getPos()
		local posX, posY = card:getPos()
		local diffX, diffY = posX - dstX, posY - dstY
		local width1 = self.lastOutCard:getSize()
		local width2 = card:getSize()
		local scale  = width2 / width1
		local animTime = 250
		local isDouble = self.m_seat % 2 == 0
		local lastOutCard = self.lastOutCard
		local anim1 = lastOutCard:addPropTranslateEase(1001, kAnimNormal, isDouble and ResDoubleArraySinOut or ResDoubleArraySinIn, animTime, 0, diffX, 0, 0, 0)
		local anim2 = lastOutCard:addPropTranslateEase(1002, kAnimNormal, isDouble and ResDoubleArraySinIn or ResDoubleArraySinOut, animTime, 0, 0, 0, diffY, 0)
		local anim3 = lastOutCard:addPropScale(1003, kAnimNormal, animTime, 0, scale, 1.0, scale, 1.0)
		local level = lastOutCard:getLevel()
		if self.m_seat == SEAT_1 then
			lastOutCard:setLevel(35)
		end
		if anim3 then 
			anim3:setEvent(nil, function() 
				lastOutCard:removeProp(1001) 
				lastOutCard:removeProp(1002)
				lastOutCard:removeProp(1003)
				-- 调用房间 将 出牌指针 放到该出牌的麻将子上面
				local x, y = lastOutCard:getImgPos()
				local width, height = lastOutCard:getImgSize()
				if self.m_seat == SEAT_1 then
					y = y - 45
				elseif self.m_seat == SEAT_2 then
					x = x + width / 8
					y = y - 45
				elseif self.m_seat == SEAT_3 then
					y = y - 45
				elseif self.m_seat == SEAT_4 then
					x = x + width / 8
					y = y - 45
				end
				local fingerPos = ccp(x, y)
				self:getRoom():showOutCardFinger(fingerPos)
				lastOutCard:setLevel(level)
			end) 
		end
	end
end

function CardPanel:dealServerOutCard(cardValue)
	table.insert(self.m_outCards, cardValue)
	self:clearLiang()
	GuideManager:showGuideOutCard(false)
	if self.m_seat ~= SEAT_1 then
		self.lastOutCard = self:createOneOutCard(cardValue)  

		local card, index = self:findCardByValue(cardValue)
		self:playOutCardAnim(cardValue, card)
		--本地删除一张牌
		self:deleteCardImageAndValueByValue(cardValue)
		self:freshHandCardsPos(false)
		playOutCardSound(cardValue, self.m_userData:getSex())
	else
		-- 我的
		local forceReconn = false
		-- 出牌成功
		if self.m_lastOutHandCard then
			local lastValue = self.m_lastOutHandCard:getValue()
			if lastValue == cardValue then
				-- 删除最后出的这个牌
				self:deleteCardImageByCard(self.m_lastOutHandCard)
				self:deleteCardValueByValue(cardValue)
			else  --不匹配
				-- 恢复 手动出的牌
				self.m_lastOutHandCard:show()
				self.m_lastOutHandCard:setOuted(false)
				-- 同时删除server出的 麻将子和值
				if self.lastOutCard then
					self.lastOutCard:resetImageByValueAndType(cardValue, self.m_outCardImgFileReg)
				end
				self:deleteCardImageAndValueByValue(cardValue)
				self:freshHandCardsPos(true)
			end
		else -- 托管出牌
			kEffectPlayer:play(Effects.AudioCardOut)
			self.lastOutCard = self:createOneOutCard(cardValue)
			local card, cardIndex = self:findCardByValue(cardValue)
			-- 找到了牌
			if cardIndex then
				self:playOutCardAnim(cardValue, card)
				self:deleteCardImageAndValueByValue(cardValue)
				self:playOutCardSwitchAnim(cardIndex)
				self:freshHandCardsPos(true)
			else --托管出的牌手牌中没有。则重连重置一次
				forceReconn = true
			end
			playOutCardSound(cardValue, self.m_userData:getSex())
		end
		if forceReconn then
			GameSocketMgr:closeSocketSync(true)
		end
		-- 出了一张牌
		self.m_lastOutHandCard = nil
		printInfo("当前手牌麻将子数目=%d, 麻将子值数目%d", #self.m_cardsVector, #self.m_handCards)
	end
end

function CardPanel:deleteCardImageAndValueByValue(cardValue, repeatNum)
	repeatNum = repeatNum or 1
	local result = false
	for i=1, repeatNum do
		-- 删除麻将子
		result = self:deleteCardImageByValue(cardValue)
		-- 删除麻将子的值
		result = self:deleteCardValueByValue(cardValue)
	end
	return result
end

function CardPanel:deleteCardImageByValue(cardValue)
	if self.m_seat ~= SEAT_1 then
		local card = table.remove(self.m_cardsVector, #self.m_cardsVector)
		if card then 
			card:removeSelf() 
		end
	else
		for i=#self.m_cardsVector, 1, -1 do
			local card = self.m_cardsVector[i]
			if card:getValue() == cardValue then
				local card = table.remove(self.m_cardsVector, i)
				card:removeSelf()
				break
			end
		end
	end
end

function CardPanel:deleteCardValueByValue(cardValue)
	if self.m_seat ~= SEAT_1 then
		return table.remove(self.m_handCards, #self.m_handCards)
	else
		for i=1, #self.m_handCards do
			if self.m_handCards[i] == cardValue then
				return table.remove(self.m_handCards, i)
			end
		end
	end
end

function CardPanel:findCardByValue(cardValue)
	if self.m_seat == SEAT_1 then
		-- 从后面往前面找
		for i=#self.m_cardsVector, 1, -1 do
			local card = self.m_cardsVector[i]
			-- 根据值找到麻将子
			if card:getValue() == cardValue then
				return card, i
			end
		end
	else
		return self.m_cardsVector[#self.m_cardsVector], #self.m_cardsVector
	end	
end

function CardPanel:getPlayer()
	return self:getParent()
end

function CardPanel:getRoom()
	return self:getParent() and self:getParent():getParent()
end

-----------玩家自己专用的方法 -------------
function CardPanel:resetHandCards(force)
	if self.m_gameData:getIsHuaning() == 1 and not force then return end
	-- dump("resetHandCards" .. self.m_gameData:getIsHuaning())
	-- 参数为空时所有出的麻将子不灰显示
	self:getRoom():showCardUpTip()
	if self.m_gameData:getIsSelectTing() == 1 then
		self:getPlayer():hideTingTipView()
	end

	if 1 ~= self.m_gameData:getIsTing() then
		for k,v in pairs(self.m_cardsVector) do
			v:setDown()
		end
	end
end

function CardPanel:showCardUpTip(value)
	for i,v in ipairs(self.m_outCardsVector) do
		if v:getValue() == value then
			v:setColor(200, 200, 200)
		else
			v:setColor(255, 255, 255)
		end
	end
end

function CardPanel:setCardUp(index, card, noScale)
	local diffX = card:setUp(noScale)
	-- 参数为空时所有出的麻将子不灰显示
	self:getRoom():showCardUpTip(card:getValue())
	for i=index+1, #self.m_cardsVector do
		local card = self.m_cardsVector[i]
		card:shiftMove(diffX, 0)
	end
end

function CardPanel:judgeShowTingTipView(index, card)
	self:getPlayer():hideTingTipView()
	-- 如果还没有听牌 并且有听牌信息
	if self.m_gameData:getIsSelectTing() == 1 and self.m_gameData:getIsTing() ~= 1 and card:getTingInfo() then
		local tingInfo = card:getTingInfo()
		-- local x, y = card:getPos()
		-- local width, height = card:getOriginSize()
		-- local pos = ccp(x, y - height - 30)
		self:getPlayer():showTingTipView(tingInfo)
	end
end

function CardPanel:judgeRemoveOperateCard(iOpValue, iCard)
	local lastOutCard = self.m_outCardsVector[#self.m_outCardsVector]
	if not lastOutCard then return end
	local value = lastOutCard:getValue()
	if value ~= iCard then return end

	local opTable = {kOpePeng, kOpeMiddleChi, kOpeRightChi, kOpeLeftChi, kOpePengGang, kOpeHu}
	for i,v in ipairs(opTable) do
		if bit.band(v, iOpValue) > 0 then
			self.m_outCardLine  = self.m_lastOutCardLine
			self.m_outCardLayer = self.m_lastOutCardLayer 
			self.m_outCardPosX, self.m_outCardPosY = self.m_lastOutCardPosX, self.m_lastOutCardPosY
			local card = table.remove(self.m_outCardsVector, #self.m_outCardsVector)
			card:removeSelf()
			return true
		end
	end
end

function CardPanel:_getUpCards()
	local tb = {}
	for i, card in ipairs(self.m_cardsVector) do
		if card:isUp() then
			table.insert(tb, card)
		end
	end
	return tb
end

function CardPanel:onSwapCardStartBd(huanCardsTb)
	self:enableSelect(true)
	local indexTb = {}
	printInfo("推荐换的牌站起")
	for i,value in ipairs(huanCardsTb) do
		printInfo("推荐换的牌站起")
		for index=#self.m_cardsVector, 1, -1 do
			local card = self.m_cardsVector[index]
			if not indexTb[index] and not card:isUp() and card:getValue() == value then 
				card:setUp(true)
				indexTb[index] = true
				break
			end
		end
	end
end

-- 换掉哪几张牌 回来哪几张
function CardPanel:onSwapCardRsp(handCards, exchangeCards)
	if self.m_seat ~= SEAT_1 then return end
	dump("换牌结果")
	dump(self.m_handCards)
	dump(handCards)
	dump(exchangeCards)
	if #exchangeCards == 0 then
		self:resetHandCards()
		return
	end
	-- 找出被换掉的牌
	table.sort(self.m_handCards)
	table.sort(handCards)
	local preCards = ToolKit.deepcopy(handCards)
	for i=1, #exchangeCards do
		for j=1, #preCards do
			if exchangeCards[i] == preCards[j] then
				table.remove(preCards, j)
				break
			end
		end
	end
	dump(self.m_handCards)
	dump(handCards)
	dump(exchangeCards)
	dump(preCards)
	local swapCards = {}
	local countTb = {}
	for i=1, #self.m_handCards do
		for k=1, #preCards do
			if not countTb[k] and preCards[k] == self.m_handCards[i] then
				printInfo("%d=%d下找到一个相同的%d=%d", i, self.m_handCards[i], k, preCards[k])
				countTb[k] = true
				break
			end
			if k==#preCards then --没有找到
				printInfo("%d将被换出", self.m_handCards[i])
				table.insert(swapCards, self.m_handCards[i])
			end
		end
	end
	dump("swapCards")
	dump(swapCards)
	-- 同步手牌
	self.m_handCards = handCards
	-- 找到被换出的手牌  站起的优先
	local indexTb = {}
	local num = 0
	for k, val in ipairs(swapCards) do
		for i,v in ipairs(self.m_cardsVector) do
			if not indexTb[i] and val == v:getValue() and v:isUp() then
				num = num + 1
				indexTb[i] = exchangeCards[num]  -- 该张麻将子 被exchangeCards覆盖
				printInfo("num = %d", num)
				printInfo("第%d个麻将子%d要变成%d", i, v:getValue(), exchangeCards[num])
				break
			end
		end
	end
	-- 重来一次
	if num ~= #exchangeCards then
		for k, val in ipairs(swapCards) do
			for i,v in ipairs(self.m_cardsVector) do
				if not indexTb[i] and val == v:getValue() then
					num = num + 1
					indexTb[i] = exchangeCards[num]  -- 该张麻将子 被exchangeCards覆盖
					break
				end
			end
		end
	end
	dump(indexTb)
	-- 出现异常 直接重绘
	if table.nums(indexTb) ~= #exchangeCards then
		self:reDrawHandCards(self.m_handCards)
		return
	end
	-- 播放换牌动画
	local swapCardsVector = {}  --隐藏的牌
	for i, value in pairs(indexTb) do
		local card = self.m_cardsVector[i]
		printInfo("麻将子%d变成%d", card:getValue(), value)
		-- 创建一个麻将子
		card:setUp(true)
		local x, y = card:getPos()
		local tempCard = new(Card, card:getValue(), self.m_handCardBgFile, self.m_handCardImgFileReg)
			:setBgAlign(self.m_cardAlign)
			:addTo(self)
			:pos(x, y)
		tempCard:setScale(self.m_handCardScale)

		card:hide()
		card:setDown()
		card:resetImageByValueAndType(value, self.m_handCardImgFileReg)
		table.insert(swapCardsVector, card)
		-- 移动且渐隐
		local outAnim = tempCard:addPropTranslate(112, kAnimNormal, 500, 50, 0, 0, 0, -100)
		tempCard:addPropTransparency(113, kAnimNormal, 500, 0, 1.0, 0.0)
		outAnim:setDebugName("CardPanel | onSwapCardRsp outAnim")
		outAnim:setEvent(nil, function()
			tempCard:removeSelf()
			-- 换出的牌移出去之后  再排序， 再换回来牌
			local cardsTb = {}
			-- 保存没有换牌的牌坐标
			for index, card in ipairs(self.m_cardsVector) do
				if not indexTb[index] then
					card:savePos()	
					table.insert(cardsTb, card)
				end
			end
			self:freshHandCardsPos(true)
			local animTb = {}
			local downFunc = function()
				for _, inCard in ipairs(swapCardsVector) do
					inCard:show()
					local downAnim = inCard:addPropTranslate(112, kAnimNormal, 500, 0, 0, 0, -100, 0)
					if downAnim then
						downAnim:setDebugName("CardPanel | onSwapCardRsp downAnim")
						downAnim:setEvent(nil, function()
							-- 排序刷新
							inCard:removeProp(112)
							self:freshHandCardsPos(true)
						end)
					end
				end
			end
			for i,v in ipairs(cardsTb) do
				if v:isPosChanged() then
					local pX, pY = v:getSavePos()
					local x, y = v:getPos()
					local diffX = pX - x
					local moveTime = 300
					table.insert(animTb, v)
					local anim = v:addPropTranslate(121, kAnimNormal, moveTime, 0, diffX, 0, 0, 0)
					if anim then
						anim:setEvent(nil, function()
							if v and v:alive() then
								v:removeProp(121)
							end
							-- 最后一个动画完毕
							if v == animTb[#animTb] then
								downFunc()
							end
						end)
					end
				end
			end
			if #animTb == 0 then
				downFunc()
			end
		end)
	end
end

function CardPanel:setSelectLiangCardUp(index, card, finger_action)
	if not index or not card then return end
	if not card.m_isCanOut then return end
	if self.m_cardsVector[index] ~= card then return end
	if self.m_gameData:getIsSelectLiang() == 1 then
		local liangTb = self.m_selectLiangInfo or {}
		if finger_action == kFingerDown and card:isUp() then
			card:setDown()
			-- self.m_lastHuanDownCard = card
			kEffectPlayer:play(Effects.AudioCardClick);
			local cardValue = card:getValue()
			for k, tCard in ipairs(self.m_cardsVector) do
				local tCardValue = tCard:getValue()
				if cardValue == tCardValue and tCard ~= card and tCard:isUp() then
					tCard:setDown()
				end
			end
			for i = 1, #self.m_selectNoLiangCards do
				if self.m_selectNoLiangCards[i].iCard == cardValue then
					table.remove(self.m_selectNoLiangCards, i)
					break
				end
			end
		elseif not card:isUp() and kFingerDown == finger_action then
			local cardValue = card:getValue()
			local isCanBeUp = false
			local temp = {}
			temp.iCard = cardValue
			temp.iCount = 3
			self.m_selectNoLiangCards[#self.m_selectNoLiangCards + 1] = temp
			
			for j, noLiangInfo in pairs(liangTb) do
				local count = 0
				for k, info in pairs(noLiangInfo.iNoLiangCards) do
					for i = 1, #self.m_selectNoLiangCards do
						if self.m_selectNoLiangCards[i].iCard == info.iCard then
							count = count + 1
						end
					end
					if count == #self.m_selectNoLiangCards then
						isCanBeUp = true
						break
					end
				end
			end
			if not isCanBeUp then
				AlarmTip.play("选此牌不符合游戏规则")
				table.remove(self.m_selectNoLiangCards, #self.m_selectNoLiangCards)
				return
			end
			self:setCardUp(index, card, true)
			kEffectPlayer:play(Effects.AudioCardClick);
			
			for k, tCard in ipairs(self.m_cardsVector) do
				local tCardValue = tCard:getValue()
				if cardValue == tCardValue and tCard ~= card and not tCard:isUp() and tCard.m_isCanOut then
					self:setCardUp(k, tCard, true)
				end
			end
		end
	end
end

function CardPanel:setSelectCardUp(index, card, finger_action)
	if not index or not card then return end
	if self.m_cardsVector[index] ~= card then return end
	if self.m_gameData:getIsHuaning() == 1 then
		-- 判断是否已经站起三张牌
		if #self:_getUpCards() > 3 then
			AlarmTip.play("换牌不能多于3张，请重新选择")
		-- 如果是手指按下 且牌已经站起
		elseif finger_action == kFingerDown and card:isUp() then
			card:setDown()
			self.m_lastHuanDownCard = card
			kEffectPlayer:play(Effects.AudioCardClick);
		elseif #self:_getUpCards() >= 3 then
			for i,v in ipairs(self:_getUpCards()) do
				print(i,v:getValue())
			end
			AlarmTip.play("已经选够三张牌了")
		-- 如果是按下操作 或者是移动操作且牌不是刚刚被放下
		elseif not card:isUp() and (kFingerDown == finger_action or self.m_lastHuanDownCard ~= card) then
			--站起
			self.m_lastHuanDownCard = nil
			self:setCardUp(index, card, true)
			kEffectPlayer:play(Effects.AudioCardClick);
		end
	else
		self:resetHandCards();
		self:setCardUp(index, card)
		self:judgeShowTingTipView(index, card)
		kEffectPlayer:play(Effects.AudioCardClick);
	end
end

function CardPanel:onTouch(finger_action, x, y, drawing_id_first, drawing_id_current)
	if not self.m_selectFlag then return end
	if self.m_gameData:getIsPlaying() == 0 then return end
	if self.m_gameData:getIsTing() == 1 then return end
	if self.m_gameData:getIsAi() == 1 then return end
	-- 用来标记手指移动时是优先站起的牌还是优先没站起来的牌
	if finger_action == kFingerDown then
		self.m_fingerY = y
	end
	local upIndex, upCard = self:_getUpCard()
	local index, card = self:_getTouchCardByPos(x, y, upIndex)
	local canOutCard = self.m_gameData:getIsMyTurn() == 1
	local singleClickOutcard = false

	-- 在换三张的场景下特殊处理
	if self.m_gameData:getIsHuaning() == 1 then
		self:setSelectCardUp(index, card, finger_action)
		return
	end
	if self.m_gameData:getIsSelectLiang() == 1 then
		self:setSelectLiangCardUp(index, card, finger_action)
		return
	end
	if finger_action == kFingerDown then
		self.m_touchBegin = true
		if upCard and upIndex then
			if upCard == card and upIndex == index and canOutCard and card.m_isCanOut then  --这张就是站起的牌
				self:dealLocalOutCard(card, index);
			elseif index and upIndex ~= index then  -- 
				self:setSelectCardUp(index, card, finger_action);
				self.m_selectX, self.m_selectY = x, y
			elseif not card then
				self:resetHandCards()
			end
		elseif card then  -- 不是站起的牌
			-- 设置麻将子站起啦
			self:setSelectCardUp(index, card, finger_action);
			self.m_selectX, self.m_selectY = x, y
		else
			self:resetHandCards()
		end
	elseif finger_action == kFingerMove then
		if not self.m_touchBegin then return end
		if upIndex then  -- 有站起的牌
			if index and index ~= upIndex then  -- 停留在某张牌 两个牌不一致
				self:setSelectCardUp(index, card, finger_action); -- 选中的牌站起
				self.m_selectX, self.m_selectY = x, y
			elseif singleClickOutcard and not index and y < upCard.m_originY then
				self:resetHandCards();
			elseif y < upCard.m_originY and canOutCard and not singleClickOutcard then -- 没有停留在某个牌
				upCard:selectCardUpDiff(x - self.m_selectX, y - self.m_selectY);
			end
		elseif index then
			self:setSelectCardUp(index, card, finger_action);
			self.m_selectX, self.m_selectY = x, y
		end
	elseif finger_action == kFingerUp then
		if not self.m_touchBegin then return end
		if upIndex and upCard then  -- 有站起的牌
			--如果有站起的牌 且位置已经离开了一定区域 则手指up后判断是否出牌
			local m_x, m_y = upCard:getPos();
			local m_originX, m_originY = upCard:getOriginPos();
			local isOutSide = m_originY - m_y > CardPanelCoord.outCardDiffY;
			if singleClickOutcard and canOutCard and upCard.m_isCanOut then
				self:dealLocalOutCard(upCard, upIndex);
			else
				if isOutSide and canOutCard and upCard.m_isCanOut then
					self:dealLocalOutCard(upCard, upIndex);
				else
					upCard:setUp(true);
				end
			end
		end
	end
	return true
end

-- 开始选择听牌出牌
function CardPanel:onSelectTing()
	self:enableSelect(true)
	self.m_gameData:setIsSelectTing(1)
	for i,v in ipairs(self.m_cardsVector) do
		if v:getTingInfo() then
			v:setLightColor()
		else
			v:setDarkColor()
		end
	end
end

-- 开始选择亮牌
function CardPanel:onSelectLiang(data)
	if not data then return end
	self.m_gameData:setIsSelectLiang(1)
	self.m_gameData:setIsSelectTing(1)
	self.m_selectLiangInfo = data
	self.m_selectNoLiangCards = {}
	self.m_selectLiang = true
	printInfo("CardPanel:onSelectLiang")
	self:enableSelect(true)
	-- 如果没有可以不亮的
	if #data <= 1 then
		self:getPlayer():onSelectLiangOutCard()
		return
	end
	-- 有可以不亮的
	local noLiangCards = {}
	for k , v in pairs(data) do
		for i, info in pairs(v.iNoLiangCards) do
			local isHas = false
			for j, tInfo in pairs(noLiangCards) do
				if info.iCard == tInfo.iCard then
					isHas = true
					break
				end
			end
			if not isHas then
				table.insert(noLiangCards, info)
			end
		end
	end
	for i, v in ipairs(self.m_cardsVector) do
		local cardValue = v:getValue()
		v:setDarkColor()
		for j, info in pairs(noLiangCards) do
			if cardValue == info.iCard and info.iCount > 0 then
				info.iCount = info.iCount - 1
				v:setLightColor()
				break
			end
		end
	end
end

-- 选择不亮的牌后设置出牌
function CardPanel:onSelectLiangOutCard()
	self.m_gameData:setIsSelectLiang(0)
	for k, v in ipairs(self.m_cardsVector) do
		v:setDarkColor()
		if v:isUp() then
			v:setDown()
		end
	end
	-- 找到听牌信息
	local canOutCards = {}
	local noLiangCards = self.m_selectNoLiangCards
	printInfo("sdsdsdsdcsacsdsdcsadsa")
	dump(self.m_selectNoLiangCards)
	for k , noLiangInfo in pairs(self.m_selectLiangInfo) do
		local isMatch = true
		dump(noLiangInfo)
		if #noLiangInfo.iNoLiangCards == #noLiangCards then
			for i, info in pairs(noLiangInfo.iNoLiangCards) do
				printInfo("i = %s, info.iCard : %d", i, info.iCard)
				local isHas = false
				for j, cards in pairs(noLiangCards) do
					printInfo("j = %s, cards.iCard : %d", j, cards.iCard)
					if info.iCard == cards.iCard then
						isHas = true
						break
					end
				end
				if not isHas then
					isMatch = false
					break
				end
			end
			if isMatch then
				canOutCards = noLiangInfo.iTingInfos
				break
			end
		end
	end
	if canOutCards then 
		self:freshTingInfo(canOutCards)
		for k, v in ipairs(self.m_cardsVector) do
			if v:getTingInfo() then
				v:setLightColor()
			end
		end
	end
end

function CardPanel:cancelTing()
	printInfo("CardPanel:cancelTing")
	self:enableSelect(true)
	self.m_gameData:setIsSelectTing(0)
	for i,v in ipairs(self.m_cardsVector) do
		v:setTingInfo(nil)
		if 1 ~= self.m_gameData:getIsTing() then
			v:setLightColor()
		end
	end
end

function CardPanel:dealLocalOutCard(card, cardIndex)
	self.m_gameData:setIsSelectLiang(0)
	GuideManager:showGuideOutCard(false)
	-- 大小相公重连
	if #self:getHandCards() % 3 ~= 2 or #self.m_cardsVector % 3 ~= 2 then
		-- 重连
		GameSocketMgr:closeSocketSync(true)
		return
	end
	kEffectPlayer:play(Effects.AudioCardOut)
	local cardValue = card:getValue()

	self.m_lastOutHandCard = card
	self.m_touchBegin = false
	self.lastOutCard = self:createOneOutCard(cardValue)
	self:playOutCardAnim(cardValue, card)
	playOutCardSound(cardValue, self.m_userData:getSex())

	card:hide()
	card:setOuted(true)
	self:playOutCardSwitchAnim(cardIndex)

	-- 请求出牌
	-- 是否听牌出牌 满足没听牌且有听牌信息
	-- 还没有听牌的时候 出牌携带听牌标记请求
	local iIsTing = 0
	if self.m_gameData:getIsSelectTing() == 1 then
		local tingInfo = card:getTingInfo()
		iIsTing = self.m_gameData:getIsTing() ~= 1 and tingInfo and 1 or 0
		self:cancelTing()
		self.m_gameData:setIsSelectTing(0)
	end
	local isLiang = self.m_selectLiang and 1 or 0
	self.m_gameData:setIsMyTurn(0)
	self:getPlayer():requestOutCard(cardValue, isLiang, self.m_selectNoLiangCards)
	self:clearLiang()
end

function CardPanel:playOutCardSwitchAnim(index)
	local cardsTb = self.m_cardsVector
	local lastCard = cardsTb[#cardsTb] 
	if index == #cardsTb or not lastCard then
		self:freshHandCardsPos(true)
		return
	end
	for i,v in ipairs(self.m_cardsVector) do
		v:savePos()
	end
	self:freshHandCardsPos(true)
	local width, height = lastCard:getSize()
	for i,v in ipairs(cardsTb) do
		if v:isPosChanged() and not v:isOuted() then
			local pX, pY = v:getSavePos()
			local x, y = v:getPos()
			local diffX = pX - x
			if v ~= lastCard or math.abs(diffX) < 1.5 * width then
				printInfo("平移麻将子0x%04x 从%d 移动到 %d", v:getValue(), pX, x)
				local moveTime = math.abs(diffX * 2)
				local anim = v:addPropTranslate(1111, kAnimNormal, moveTime, 0, diffX, 0, 0, 0)
				if anim then
					anim:setEvent(nil, function()
						if v and v:alive() then
							v:removeProp(1111)
						end
					end)
				end
			else
				printInfo("变换麻将子0x%04x 从%d 移动到 %d", v:getValue(), pX, x)
				local moveTime = math.abs(diffX) * 3 / 5
				local anim = v:addPropTranslateEase(1111, kAnimNormal, ResDoubleArrayBackOut, 167, 0, diffX, diffX, 0, UpCardDiffY)
				anim:setEvent(nil, function()
					v:removeProp(1111)
					local anim = v:addPropTranslateEase(1111, kAnimNormal, ResDoubleArraySinIn, moveTime, 0, diffX, 0, UpCardDiffY, UpCardDiffY)
					anim:setEvent(nil, function()
						v:removeProp(1111)
						local anim = v:addPropTranslateEase(1111, kAnimNormal, ResDoubleArrayBackIn, 167, 0, 0, 0, UpCardDiffY, 0)
						anim:setEvent(nil, function()
							v:removeProp(1111)
						end)
					end)
				end)
			end
		end
	end
	printInfo("手牌数目为不0")
end

-- 删除指定手牌
function CardPanel:deleteCardImageByCard(handCard)
	for i,v in pairs(self.m_cardsVector) do
		if v == handCard then
			local card = table.remove(self.m_cardsVector, i)
			card:removeSelf()
		end
	end
end

--优先没有站起的牌
function CardPanel:_getTouchCardByPos(x, y, upIndex)
	-- 有站起的牌 且手指在y方向向上移动超过20像素
	-- 则表示移动的时候应该还是优先一起站起的牌
	-- 否则优先未站起的牌
	if upIndex and self.m_fingerY and self.m_fingerY - y > 30 then
		--优先站起的牌
		local card = self.m_cardsVector[upIndex]
		if card and card:containsPoint(x, y) then
			return upIndex, card
		end
		for k,v in pairs(self.m_cardsVector) do
			if v:containsPoint(x, y) then
				return k, v
			end
		end
	else --优先未站起的牌
		for k,v in pairs(self.m_cardsVector) do
			if k ~= upIndex and v:containsPoint(x, y) then
				return k, v
			end
		end
		local card = self.m_cardsVector[upIndex]
		if card and card:containsPoint(x, y) then
			return upIndex, card
		end
	end
end

function CardPanel:_findCardByDrawingId(drawingId)
	for k,v in ipairs(self.m_cardsVector) do
		if v:getDrawingId() == drawingId then
			return k, v
		end
	end
end

--拿到站起的牌
function CardPanel:_getUpCard()
	for k,v in pairs(self.m_cardsVector) do
		if v:isUp() then
			return k, v
		end
	end
end

return CardPanel