local TingTipView = class(Node)
local Card = import(".card")
local CardPanelCoord = import("..coord.cardPanelCoord")
local tingCardBgFile        = CardPanelCoord.tingCardBg
local extraCardImgFileReg 	= CardPanelCoord.extraCardImage[SEAT_1]
local fanxingTb = require("data.fanxing")

function TingTipView:ctor(tingInfo, pos)
	self:freshTingView(tingInfo, pos)
end

function TingTipView:getBgSize()
	return self.m_bgSize or ccs(0, 0)
end

function TingTipView:freshTingView(tingInfo, pos)
	self:removeAllChildren()
	if not tingInfo then return end
	local itemSize = {width = 152, height = 184}
	local scale = 1.0
	local card, fanLabel, leftLabel
	local info, sWidth
	local bgSize = {width = (itemSize.width - 10) * #tingInfo, height = itemSize.height}
	self.m_bgSize = bgSize
	if pos then
		local rightPosX = bgSize.width + pos.x
		if rightPosX > display.width then
			pos.x = pos.x - (rightPosX - display.width) - 20
		end
	else --居中显示
		pos = ccp(display.cx - bgSize.width / 2, display.bottom - 200)	
	end
	self:pos(pos.x, pos.y)
	local diffX = 10
	local x, y = 0, 0
	for i=1, #tingInfo do
		local bg = UIFactory.createImage("kwx_room/gameOpeation/ting_bg.png", nil, nil, 10, 10, 10, 10)
			:addTo(self)
			:align(kAlignBottomLeft, x, y)

		bg:setSize(itemSize.width, itemSize.height)

		info = tingInfo[i]
		dump(info)
		card = new (Card, info.iHuCard, tingCardBgFile, extraCardImgFileReg)
			:addTo(bg)
			:align(kAlignTop, 0, 25)
		card:setBgAlign(kAlignTop)
		card:scaleCardTo(0.7, 0.7)
		card:shiftCardMove(0, 5)

		leftLabel = UIFactory.createText({
				text = string.format("剩%d张", info.iRemainNum),
				size = 18,
				color = c3b( 0x50, 0x50, 0x50),
			})
			:addTo(bg)
			:align(kAlignBottom, -25, 50)

		if info.iFan ~= 0 then
			fanLabel = UIFactory.createText({
					text = string.format("%d番", info.iTotalFan),
					size = 18,
					color = c3b( 0x50, 0x50, 0x50),
				})
				:addTo(bg)
				:align(kAlignBottom, 30, 50)
		else
			leftLabel:pos(0, 50)
		end

		local fanName = info.iFanXing or ""
		if fanName then
			UIFactory.createText({	
				text = fanName,
				size = 20,
				color = c3b( 0xFF, 0x80, 0x0), 
			})
			:addTo(bg)
			:align(kAlignBottom, 0, 20)
		end
		x = x + itemSize.width - 10
	end
end

return TingTipView