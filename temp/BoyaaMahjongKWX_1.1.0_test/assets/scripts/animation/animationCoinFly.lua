-- 震动动画(传入需要震动的节点即可)
-- require("animation/animBase");
require("common/uiFactory");
require("common/animFactory");


AnimationCoinFly = class();

--[[
	pos  :  动画出发和结束坐标
	delay  :  延迟多久开始播放
]]
AnimationCoinFly.ctor = function(self, pos, delay)
	self:load(pos, delay)
end

AnimationCoinFly.load = function(self, pos, delay)

	self.m_isPlaying = false;
	self.m_baseSequence = 10;
	self.m_coinNum = 15;
	self.m_baseDelay = delay or 300

	self.m_pos = {
		from = {x = pos.from.x, y = pos.from.y};	
		to = {x = pos.to.x, y = pos.to.y};
	};
	self.m_diffX = self.m_pos.to.x - self.m_pos.from.x
	self.m_diffY = self.m_pos.to.y - self.m_pos.from.y

	self.m_animRoot = new(Node);
	self.m_animRoot:setSize(44, 44);
	self.m_animRoot:addToRoot();
	self.m_animRoot:setPos(self.m_pos.from.x, self.m_pos.from.y)
	-- self.m_animRoot:setLevel(RoomPos.levels.anim);

	self.m_coins = {};
	for i=1,self.m_coinNum do
		self.m_coins[i] = new(Image, "kwx_lobby/img_coin.png")
		self.m_animRoot:addChild(self.m_coins[i])
	end

	self.m_animRoot:setVisible(false)
end

AnimationCoinFly.play = function(self, pos)
	if self.isPlaying then return; end
	
	self.m_delayAnim = self.m_animRoot:addPropTranslate(1, kAnimNormal, self.m_baseDelay, 0, 0,0, 0, 0);
	self.m_delayAnim:setDebugName("AnimationCoinFly | self.m_delayAnim")
	self.m_delayAnim:setEvent(self, self.startFly)
	kEffectPlayer:play(Effects.AudioGetGold);
end

AnimationCoinFly.startFly = function(self)
	self.m_isPlaying = true;
	self.m_animRoot:setVisible(true)

	for i=1,self.m_coinNum do
		self.m_coins[i]:addPropTranslate(0, kAnimNormal, 500, 50*i, 0, self.m_diffX, 0,self.m_diffY);
	end
	if self.m_flyAnim then
		delete(self.m_flyAnim)
		self.m_flyAnim = nil
	end
	self.m_flyAnim = self.m_animRoot:addPropTranslate(10, kAnimNormal, 700, 50*self.m_coinNum, 0,0, 0, 0);
	self.m_flyAnim:setDebugName("AnimationCoinFly | self.m_flyAnim")
	self.m_flyAnim:setEvent(self, self.stop)
end

AnimationCoinFly.stop = function(self)
	if self.m_animRoot then
		self.m_flyAnim = nil
		self.m_animRoot:removeAllChildren(true)
		delete(self.m_animRoot)
		self.m_animRoot = nil
	end
end

AnimationCoinFly.release = function(self)
	self:stop()
end