
require("common/uiFactory");
require("common/animFactory");
local AnimationBase = require("animation.animationBase")
local RoomCoord = require("room.coord.roomCoord")
local Card 	= require("room.entity.card")
local CardPanelCoord = require("room.coord.cardPanelCoord")
local extraCardBgFile 		= CardPanelCoord.extraCardBg[SEAT_1]
local extraCardImgFileReg 	= CardPanelCoord.extraCardImage[SEAT_1]
local extraAnCardBgFile     = CardPanelCoord.extraAnGangImage[SEAT_1]
local extraCardDiff         = CardPanelCoord.extraCardDiff[SEAT_1]
--[[
	吃、碰、杠、暗杠、加倍、听 动画
]]
local OperateAnim = class(AnimationBase);

OperateAnim.chi = 1;
OperateAnim.peng = 2;
OperateAnim.gang = 3;
OperateAnim.angang = 4;
OperateAnim.double = 5;
OperateAnim.ting = 6;
OperateAnim.hu = 7;
OperateAnim.gameStart = 8;
OperateAnim.liang = 9;

OperateMap = {
	{kOpeGameStart, OperateAnim.gameStart},
	
	{kOpeZiMo, 		OperateAnim.hu},
	{kOpeHu, 		OperateAnim.hu},
	{kOpePengGangHu, OperateAnim.hu},
	{kOpeAnGang, 	OperateAnim.angang},
	{kOpeBuGang, 	OperateAnim.gang},
	{kOpePengGang, 	OperateAnim.gang},
	{kOpePeng, 		OperateAnim.peng},
	{kOpeLeftChi, 	OperateAnim.chi},
	{kOpeMiddleChi, OperateAnim.chi},
	{kOpeRightChi, 	OperateAnim.chi},
	{kOpeTing,      OperateAnim.ting},
	{kOpeLiang,     OperateAnim.liang},
}

OperateAnim.myPositionY = 100;
OperateAnim.oppoPositionY = -60;

--[[
	opValue : 动画类型
	card ：操作的牌值 
	cards : 吃的3张牌
]]
function OperateAnim:ctor()
	self.baseSequence = 20;
end

function OperateAnim:getOpValue()
	return self.m_opValue or 0
end

function OperateAnim:load(params)
	self.m_cardValue = params.cardValue;
	self.m_cards = ToolKit.deepcopy(params.cards);
	self.m_callback = params.onComplete
	self.m_opValue = params.opValue
	local opValue = params.opValue
	for i=1, #OperateMap do
		local op, _type = unpack(OperateMap[i])
		if bit.band(op, opValue) > 0 then
			self.m_type	= _type
			break
		end
	end
	local pos = params.pos

	if self.m_type == OperateAnim.chi then
		for index,val in ipairs(self.m_cards) do
            if val == self.m_cardValue then
                table.remove(self.m_cards,index);
            end	
		end	
	end

	self.m_root = new(Node)
		:addTo(self)
	self.m_root:setLevel(RoomCoord.AnimLayer);

	if pos then
		self:setPos(pos.x, pos.y)
	end

	self.m_moji = new(Image, "animation/roomAnim/commonMojiBg.png")
	self.m_moji:setPos(20, 0)
	
	self.m_root:addChild(self.m_moji);
	self.m_moji:setAlign(kAlignCenter)
	printInfo("self.m_type : %d", self.m_type)
	if self.m_type == OperateAnim.chi then
		if type(self.m_cards) ~= "table" then 
			Log.w("OperateAnim.load || self.m_cards err")
			return
		end

		self.m_text_img_1 = new(Image, "animation/roomAnim/chi.png")
		self.m_text_img_2 = new(Image, "animation/roomAnim/chi.png")

	elseif self.m_type == OperateAnim.peng then
		self.m_text_img_1 = new(Image, "animation/roomAnim/peng.png")
		self.m_text_img_2 = new(Image, "animation/roomAnim/peng.png")

	elseif self.m_type == OperateAnim.gang or self.m_type == OperateAnim.angang then
		self.m_text_img_1 = new(Image, "animation/roomAnim/gang.png")
		self.m_text_img_2 = new(Image, "animation/roomAnim/gang.png")

	elseif self.m_type == OperateAnim.ting then
		self.m_text_img_1 = new(Image, "animation/roomAnim/ming.png")
		self.m_text_img_2 = new(Image, "animation/roomAnim/ming.png")

	elseif self.m_type == OperateAnim.hu then		
		self.m_text_img_1 = new(Image, "animation/roomAnim/hu.png")
		self.m_text_img_2 = new(Image, "animation/roomAnim/hu.png")

	elseif self.m_type == OperateAnim.gameStart then

		self.m_text_img_1 = new(Image, room_pin_map["game_start.png"])
		self.m_text_img_2 = new(Image, room_pin_map["game_start.png"])
	elseif self.m_type == OperateAnim.liang then
		self.m_text_img_1 = new(Image, "animation/roomAnim/ming.png")
		self.m_text_img_2 = new(Image, "animation/roomAnim/ming.png")
	end

	self.m_moji:addChild(self.m_text_img_1)
	self.m_moji:addChild(self.m_text_img_2)
	self.m_text_img_1:setAlign(kAlignCenter)
	self.m_text_img_2:setAlign(kAlignCenter)
	self.m_text_img_1:setPos(-7, 0)
	self.m_text_img_2:setPos(-7, 0)

	local cardPosY = 120
	self.m_cardWidth = 0
	local function createExtraCard(cardValue,hideDesign)
		local card = new(Card, cardValue, cardValue > 0 and extraCardBgFile or extraAnCardBgFile, extraCardImgFileReg)
			:align(kAlignCenter)
			:setBgAlign(kAlignCenter)
			:setScale(0.8, 0.8)
			:scaleCardTo(0.6, 0.6)
			:shiftCardMove(0, -14)

            if hideDesign then
			   card:hideDesign();
			end

		if self.m_cardWidth == 0 then
			local width = card:getSize()
			self.m_cardWidth = width - 5
		end
		return card
	end

	if self.m_type == OperateAnim.chi  then
		self.m_cardback_1 = createExtraCard(self.m_cards[1],true)
		self.m_cardback_2 = createExtraCard(self.m_cardValue)
		self.m_cardback_3 = createExtraCard(self.m_cards[2],true)

		self.m_root:addChild(self.m_cardback_1);
		self.m_root:addChild(self.m_cardback_2);
		self.m_root:addChild(self.m_cardback_3);

		self.m_cardback_1:setAlign(kAlignCenter)
		self.m_cardback_2:setAlign(kAlignCenter)
		self.m_cardback_3:setAlign(kAlignCenter)

		local width = self.m_cardWidth
		if self.m_type == OperateAnim.chi then
			self.m_cardback_1:setPos(-width*2, cardPosY)
			self.m_cardback_2:setPos(0, cardPosY)
			self.m_cardback_3:setPos(width*2, cardPosY)
		else
			self.m_cardback_1:setPos(-width, cardPosY)
			self.m_cardback_2:setPos(0, cardPosY)
			self.m_cardback_3:setPos(width*2, cardPosY)
		end
	elseif	self.m_type == OperateAnim.peng then

		self.m_cardback_1 = createExtraCard(self.m_cards[1],true)
		self.m_cardback_2 = createExtraCard(self.m_cards[2],true)
		self.m_cardback_3 = createExtraCard(self.m_cardValue)

		self.m_root:addChild(self.m_cardback_1);
		self.m_root:addChild(self.m_cardback_2);
		self.m_root:addChild(self.m_cardback_3);

		self.m_cardback_1:setAlign(kAlignCenter)
		self.m_cardback_2:setAlign(kAlignCenter)
		self.m_cardback_3:setAlign(kAlignCenter)

		local width = self.m_cardWidth
		if self.m_type == OperateAnim.chi then
			self.m_cardback_1:setPos(-width*2, cardPosY)
			self.m_cardback_2:setPos(0, cardPosY)
			self.m_cardback_3:setPos(width*2, cardPosY)
		else
			self.m_cardback_1:setPos(-width, cardPosY)
			self.m_cardback_2:setPos(0, cardPosY)
			self.m_cardback_3:setPos(width*2, cardPosY)
		end

	elseif self.m_type == OperateAnim.gang  then

		self.m_cardback_1 = createExtraCard(self.m_cardValue,true)
		self.m_cardback_2 = createExtraCard(self.m_cardValue,true)
		self.m_cardback_3 = createExtraCard(self.m_cardValue,true)
		self.m_cardback_4 = createExtraCard(self.m_cardValue)

		self.m_root:addChild(self.m_cardback_1);
		self.m_root:addChild(self.m_cardback_2);
		self.m_root:addChild(self.m_cardback_3);
		self.m_root:addChild(self.m_cardback_4);

		self.m_cardback_1:setAlign(kAlignCenter)
		self.m_cardback_2:setAlign(kAlignCenter)
		self.m_cardback_3:setAlign(kAlignCenter)
		self.m_cardback_4:setAlign(kAlignCenter)

		local width = self.m_cardWidth

		self.m_cardback_1:setPos(-width * 1.5, cardPosY)
		self.m_cardback_2:setPos(-width * 0.5, cardPosY)
		self.m_cardback_3:setPos(width * 0.5, cardPosY)
		self.m_cardback_4:setPos(width * 2.5, cardPosY)
	
	elseif	self.m_type == OperateAnim.angang then

		self.m_cardback_1 = createExtraCard(0)
		self.m_cardback_2 = createExtraCard(0)
		self.m_cardback_3 = createExtraCard(0)
		self.m_cardback_4 = createExtraCard(0)

		self.m_root:addChild(self.m_cardback_1);
		self.m_root:addChild(self.m_cardback_2);
		self.m_root:addChild(self.m_cardback_3);
		self.m_root:addChild(self.m_cardback_4);

		self.m_cardback_1:setAlign(kAlignCenter)
		self.m_cardback_2:setAlign(kAlignCenter)
		self.m_cardback_3:setAlign(kAlignCenter)
		self.m_cardback_4:setAlign(kAlignCenter)

		local width = self.m_cardWidth

		self.m_cardback_1:setPos(-width * 1.5, cardPosY)
		self.m_cardback_2:setPos(-width * 0.5, cardPosY)
		self.m_cardback_3:setPos(width * 0.5, cardPosY)
		self.m_cardback_4:setPos(width * 2.5, cardPosY)
	end

	self.m_text_img_1:setVisible(false)

end

function OperateAnim:play(params)
	OperateAnim.super.play(self, params)

	if self.m_type == OperateAnim.gang or self.m_type == OperateAnim.angang then
		self:startShake(self.m_text_img_2);
	else
		self:playSate();
	end
end

function OperateAnim:playSate()
	self.m_text_img_1:setVisible(true)
	checkAndRemoveOneProp(self.m_text_img_1,1);
	checkAndRemoveOneProp(self.m_text_img_1,2);
	self.m_text_img_1:addPropTransparency(1,kAnimNormal,600, 50, 0.6,0);
	self.m_text_img_1:addPropScale(2,kAnimNormal,250, 50, 1,3,1,3,kCenterDrawing);
    checkAndRemoveOneProp(self.m_text_img_2,1);
	self.m_showAnim = self.m_text_img_2:addPropScale(1,kAnimNormal,250,50, 1,1.5,1,1.5,kCenterDrawing);
	self.m_showAnim:setDebugName("OperateAnim || self.m_showAnim");
	self.m_showAnim:setEvent(self, self.onTime)
end

----------[[ 开始震动 ]]
function OperateAnim:startShake(_ctrl)

	self.m_shakeNode = _ctrl
	self.shakeCount = 0;
	checkAndRemoveOneProp(self.m_shakeNode,self.baseSequence+5);
	self.animShake = self.m_shakeNode:addPropScale(self.baseSequence+5,kAnimLoop,50, 50, 0.9,1.1, 0.9,1.1,kCenterDrawing);
	self.animShake:setDebugName("AnimDouble|OperateAnim.animShake");
	self.animShake:setEvent(self, self.onShakeFinish);
end

function OperateAnim:stopShake()
	if self.animShake then
		checkAndRemoveOneProp(self.m_shakeNode,self.baseSequence+5);
		delete(self.propShake);
		self.propShake=nil;
		self.animShake = nil;
		self.m_shakeNode = nil;
	end
	self:playSate()
end

function OperateAnim:onShakeFinish()
	self.shakeCount = self.shakeCount+1;
	if self.shakeCount>=1 then
		self:stopShake();
	end
end
-------------

function OperateAnim:onTime()


	checkAndRemoveOneProp(self.m_text_img_2,1);
	checkAndRemoveOneProp(self.m_text_img_2,80);
	self.m_text_img_2:addPropScale(1,kAnimNormal,50,200,1.5,1,1.5,1,kCenterDrawing);
	self:playCardAnim()
	self.m_delay_anim = self.m_text_img_2:addPropScale(80,kAnimNormal,1000,0, 1,1,1,1,kCenterDrawing);
	if self.m_delay_anim then
		self.m_delay_anim:setDebugName("OperateAnim || self.m_delay_anim");
		self.m_delay_anim:setEvent(self, OperateAnim.release);
	else
		self:release()
	end
end

function OperateAnim:release()
	OperateAnim.super.release(self)
	if self.m_callback then
		self.m_callback()
	end
end

-- 牌子碰撞动画
function OperateAnim:playCardAnim()
	if self.m_type == OperateAnim.chi then
		checkAndRemoveOneProp(self.m_cardback_1,1);
		checkAndRemoveOneProp(self.m_cardback_3,1);
		self.m_cardback_1:addPropTranslate(1, kAnimNormal, 50, 0, 0, self.m_cardWidth, 0, 0);
		self.m_quanquanAnim = self.m_cardback_3:addPropTranslate(1, kAnimNormal, 50, 0, 0, -self.m_cardWidth, 0, 0);
	elseif self.m_type == OperateAnim.peng then
		checkAndRemoveOneProp(self.m_cardback_3,1);
		self.m_quanquanAnim = self.m_cardback_3:addPropTranslate(1, kAnimNormal, 50, 0, 0, -self.m_cardWidth, 0, 0);
	elseif self.m_type == OperateAnim.gang or self.m_type == OperateAnim.angang  then
		checkAndRemoveOneProp(self.m_cardback_4,1);
		self.m_quanquanAnim = self.m_cardback_4:addPropTranslate(1, kAnimNormal, 50, 0, 0, -self.m_cardWidth, 0, 0);
	end

	if self.m_quanquanAnim then
		self.m_quanquanAnim:setDebugName("OperateAnim || m_quanquanAnim")
		self.m_quanquanAnim:setEvent(self, function(self)

			self.m_quanquan = new(Image, "animation/roomAnim/quanquan1.png")
			self.m_quanquan2 = new(Image, "animation/roomAnim/quanquan2.png")
			if self.m_type == OperateAnim.chi then
				self.m_cardback_3:addChild(self.m_quanquan)
				self.m_cardback_3:addChild(self.m_quanquan2)
				self.m_quanquan:setPos(-55,0)
				self.m_quanquan2:setPos(-55,0)
				self.m_quanquan:setAlign(kAlignCenter)
				self.m_quanquan2:setAlign(kAlignCenter)
				self.m_cardback_2:hideDesign()
				self.m_cardback_1:durationShowDesin(50);
				self.m_cardback_2:durationShowDesin(50);
				self.m_cardback_3:durationShowDesin(50);

				
			elseif self.m_type == OperateAnim.peng then
				self.m_cardback_3:addChild(self.m_quanquan)
				self.m_cardback_3:addChild(self.m_quanquan2)
				self.m_quanquan:setPos(-55,0)
				self.m_quanquan2:setPos(-55,0)
				self.m_quanquan:setAlign(kAlignCenter)
				self.m_quanquan2:setAlign(kAlignCenter)
				self.m_cardback_3:hideDesign()
				self.m_cardback_1:durationShowDesin(50);
				self.m_cardback_2:durationShowDesin(50);
				self.m_cardback_3:durationShowDesin(50);


			elseif self.m_type == OperateAnim.gang then
				self.m_cardback_4:addChild(self.m_quanquan)
				self.m_cardback_4:addChild(self.m_quanquan2)
				self.m_quanquan:setAlign(kAlignCenter);
				self.m_quanquan2:setAlign(kAlignCenter);
				self.m_quanquan:setPos(-80,0)
				self.m_quanquan2:setPos(-80,0)
				self.m_cardback_4:hideDesign()
				self.m_cardback_1:durationShowDesin(50);
				self.m_cardback_2:durationShowDesin(50);
				self.m_cardback_3:durationShowDesin(50);
				self.m_cardback_4:durationShowDesin(50);

			elseif self.m_type == OperateAnim.angang then

				self.m_cardback_4:addChild(self.m_quanquan)
				self.m_cardback_4:addChild(self.m_quanquan2)
				self.m_quanquan:setPos(-80,0)
				self.m_quanquan2:setPos(-80,0)
				self.m_quanquan:setAlign(kAlignCenter);
				self.m_quanquan2:setAlign(kAlignCenter);
			end

			if self.m_quanquan and self.m_quanquan2 then
				checkAndRemoveOneProp(self.m_quanquan,1);
				checkAndRemoveOneProp(self.m_quanquan,2);
				self.m_quanquan:addPropTransparency(1,kAnimNormal,300,0,1.0,0);
				self.m_quanquan:addPropScale(2,kAnimNormal,300,0,1,2,1,2,kCenterDrawing);
                
                checkAndRemoveOneProp(self.m_quanquan2,1);
				checkAndRemoveOneProp(self.m_quanquan2,2);
				self.m_quanquan2:addPropTransparency(1,kAnimNormal,500,100,1.0,0);
				self.m_quanquan2:addPropScale(2,kAnimNormal,500,100,1,1.3,1,1.3,kCenterDrawing);

			end

		end)

	end

end

return OperateAnim