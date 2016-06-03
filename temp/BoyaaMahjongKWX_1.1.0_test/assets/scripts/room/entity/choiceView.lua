local ChoiceView = class(Node)
local Card = import(".card")
local CardPanelCoord = import("..coord.cardPanelCoord")
local extraCardBgFile 		= CardPanelCoord.extraCardBg[SEAT_1]
local extraCardImgFileReg 	= CardPanelCoord.extraCardImage[SEAT_1]
local extraAnCardBgFile     = CardPanelCoord.extraAnGangImage[SEAT_1]
local extraCardDiff         = CardPanelCoord.extraCardDiff[SEAT_1]
function ChoiceView:ctor(opTable, opPriority)
	self:initView(opTable, opPriority)
end

function ChoiceView:initView(opTable, opPriority)
	self:removeAllChildren()
	if not opTable then return end
	local itemSize = {width = 218, height = 134}
	local scale = 1.0
	local card, fanLabel, leftLabel
	local info, sWidth
	local bgSize = {width = itemSize.width * #opTable, height = itemSize.height}
	self:pos(display.cx - bgSize.width / 2, display.bottom - 195)
	local diffX = 10
	local x, y = 0, 0
	for k, record in ipairs(opTable) do
		printInfo("创建记录")
		local choiceBtn = UIFactory.createButton("kwx_room/gameOpeation/img_cardBg.png")
			:addTo(self)
			:align(kAlignBottomLeft, x, y)
		-- choiceBtn:setSize(218, 134)

		choiceBtn:setSize(itemSize.width - 20, itemSize.height)
		choiceBtn:setOnClick(nil, function()
			self:getParent():requestTakeOperate(record.operation, record.card)
		end)
		local posX
		local posY = 0
		local cards = getCardsTbByOpAndCard(record.operation, record.card)
		for i, cardValue in ipairs(cards) do
			card = new (Card, cardValue, cardValue > 0 and extraCardBgFile or extraAnCardBgFile, extraCardImgFileReg)
				:addTo(choiceBtn)
				:align(kAlignCenter)
			card:setBgAlign(kAlignCenter)
			card:shiftCardMove(0, -13)
			card:setScale(0.8)
			card:scaleCardTo(0.64, 0.64)
			local width, height = card:getOriginSize()
			posX = posX or -width * extraCardDiff.xDouble
			if i == 4 then
				posX = posX - width * extraCardDiff.xDouble * 2
				card:pos(posX, height * extraCardDiff.yGangDouble + 3)
			else
				card:pos(posX, 3)
				posX = posX + width * extraCardDiff.xDouble
			end
		end
		x = x + itemSize.width
	end
end

return ChoiceView