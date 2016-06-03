-- 好友 送玫瑰动画
local AnimCurve = require("animation/friendsAnim/animCurve");
require("animation/friendsAnim/friendAnim_pin");


local AnimationSendRose = class(Node);


function AnimationSendRose.ctor( self, p1, p2 )

	self.m_p1 = p1;
	self.m_p2 = p2;
	self.m_h = 220;	--弧线高度
	self.m_pnum = 55;
	self.isPlaying = false;
	self.baseSequence = 10;

	self:load();
	--创建飞行路径
	self.m_flyCurve_1 = {};
	if math.abs(p1.x-p2.x) <=100 then
		self.m_flyCurve_1 = AnimCurve.createLineCurve(self.m_p1, self.m_p2, self.m_pnum);
	else
		self.m_flyCurve_1 = AnimCurve.createParabolaCurve(self.m_p1, self.m_p2, self.m_h, self.m_pnum);
	end
end

function AnimationSendRose.load( self )
	self.m_root = new(Node);
	self.m_root:addToRoot();

	--花
	self.m_target = UIFactory.createImage(sendRose_pin_map["start_6.png"]);
	self.m_root:addChild(self.m_target);
	self.m_target:setVisible(false);
	self.m_target:setPos(self.m_p1.x, self.m_p1.y);
	local tW, tH = self.m_target:getSize();

	--花束
	self.m_flowers = UIFactory.createImage(sendRose_pin_map["flowers.png"]);
	self.m_root:addChild(self.m_flowers);
	self.m_flowers:setVisible(false);
	local rW, rH = self.m_flowers:getSize();
	self.m_flowers:setPos(self.m_p2.x - rW/5, self.m_p2.y);

	--heart
	local dirs = {};
	for i=1,7 do
		table.insert(dirs, sendRose_pin_map[string.format("heart_%d.png",i)]);
	end
	self.m_hearts = UIFactory.createImages(dirs);
	self.m_root:addChild(self.m_hearts);
	self.m_hearts:setVisible(false);
	local gW, gH = self.m_hearts:getSize();
	self.m_hearts:setPos(self.m_p2.x - gW/2 + rW/4, self.m_p2.y - gH/3);

	--endAnim
	self.m_endDirs = {};
	for i=1,8 do
		table.insert(self.m_endDirs, sendRose_pin_map[string.format("end_%d.png",i)]);
	end	
	self.m_ends = UIFactory.createImages(self.m_endDirs);
	self.m_root:addChild(self.m_ends);
	self.m_ends:setVisible(false);
	local gW, gH = self.m_ends:getSize();
	self.m_ends:setPos(self.m_p2.x - gW/2 + rW/4, self.m_p2.y - gH/3);


	--startAnim
	self.m_startDirs = {};
	for i=1,6 do
		table.insert(self.m_startDirs, sendRose_pin_map[string.format("start_%d.png",i)]);
	end	
	self.m_starts = UIFactory.createImages(self.m_startDirs);
	self.m_root:addChild(self.m_starts);
	self.m_starts:setVisible(false);
	local gW, gH = self.m_starts:getSize();
	self.m_starts:setPos(self.m_p1.x - gW/2 + tW/2, self.m_p1.y);

	--星光
	self.m_flushs = {};
	for i=1,5 do
		self.m_flushs[i] = UIFactory.createImage(sendRose_pin_map["flush.png"]);
		self.m_starts:addChild(self.m_flushs[i]);
		self.m_flushs[i]:setVisible(false);
	end
	self.m_flushs[1]:setPos(10,20);
	self.m_flushs[2]:setPos(34,0);
	self.m_flushs[3]:setPos(25,50);
	self.m_flushs[4]:setAlign(kAlignCenter);
	self.m_flushs[5]:setPos(40,30);
end

function AnimationSendRose.play( self )
	if self.isPlaying then
		return;
	end
	self.isPlaying = true;
	self:playStartAnim();
end

--[[播放动画]]
function AnimationSendRose.playStartAnim( self )

	for i=1,#self.m_flushs do
		self.m_flushs[i]:setVisible(true);
		self.m_flushs[i]:addPropScale(self.baseSequence, kAnimLoop, 600, 200+300*math.random(), 0, 1, 0, 1, kCenterDrawing);
	end
	self.imgIndex = 0;
	self.m_startAnim = self.m_starts:addPropRotate(0,kAnimRepeat, 150,0,0,0,kCenterDrawing);
	self.m_startAnim:setDebugName("AnimationSendRose || self.m_startAnim");
	self.m_startAnim:setEvent(self, self.showStartOnTime);

  	kEffectPlayer:play(Effects.PropRose1);
end

function AnimationSendRose.showStartOnTime( self )
	if self.m_starts.m_reses then
		local index = self.imgIndex;
		if index > 5 then
			index = 5;
		else
			self.m_starts:setImageIndex(index);
			self.m_starts:setVisible(true);
		end
	else
		delete(self.m_starts);
		self.m_starts = nil;
		self:stop();
		return;
	end
	self.imgIndex = self.imgIndex + 1;
	if self.imgIndex > 13 then
		delete(self.m_starts);
		self.m_starts = nil;
		delete(self.m_flushs);
		self.m_flushs = nil;
		self:throwTargetAnim();
	end

end

--[[]]
function AnimationSendRose.throwTargetAnim( self )

	self.m_index = 1;
	self.m_speed = 50;	-- 速度
	self.m_targetAnim = new(AnimInt, kAnimRepeat, 0, 1, 20, 0);
  	kEffectPlayer:play(Effects.PropRose2);
	self.m_targetAnim:setEvent(nil, function()
		
		self.m_target:setVisible(true)
		self.m_target:setPos(self.m_flyCurve_1[self.m_index].x, self.m_flyCurve_1[self.m_index].y);
		self.m_index = self.m_index + 1;
		
		if self.m_index >= #self.m_flyCurve_1 then
			self.m_index = 1;
			self.m_target:setVisible(false);
			delete(self.m_targetAnim);
			self.m_targetAnim = nil;
			self:showEndAnim();
			self:showFlowers();
		end

	end);
end

function AnimationSendRose.showFlowers( self )
	self.m_flowers:setVisible(true);
	self.m_flowersAnim = self.m_flowers:addPropScale(self.baseSequence, kAnimLoop, 200, 0, 0.8, 1.1, 0.8, 1.1, kCenterDrawing);
	self.m_m_flowersCount = 0;
	self.m_flowersAnim:setEvent(nil, function()
		if self.m_m_flowersCount >= 1 then
			self.m_flowers:removeProp(self.baseSequence);
		end
		self.m_m_flowersCount = self.m_m_flowersCount + 1;
	end);
end

--[[]]
function AnimationSendRose.showEndAnim( self )

	if self.m_endAnim then
		delete(self.m_endAnim);
		self.m_endAnim = nil;
	end
	self.imgIndex2 = 0;
	self.imgIndex3 = 0;
  	kEffectPlayer:play(Effects.PropRose3);
	self.m_endAnim = self.m_ends:addPropRotate(0,kAnimRepeat,180,0,0,0,kCenterDrawing);
	self.m_endAnim:setDebugName("AnimationSendRose || self.m_endAnim");
	self.m_endAnim:setEvent(self, self.showEndAnimOnTime);

end

function AnimationSendRose.showEndAnimOnTime( self )
	if self.m_ends.m_reses then
		local index2 = self.imgIndex2;
		local index3 = self.imgIndex3;
		if index2 > 7 then
			index2 = 7;
		end
		if index3 > 6 then
			index3 = 6;
		end
		
		self.m_ends:setImageIndex(index2);
		self.m_ends:setVisible(true);
		self.m_hearts:setImageIndex(index3);
		self.m_hearts:setVisible(true);
	else
		delete(self.m_ends);
		self.m_ends = nil;
		self:stop();
		return;
	end
	self.imgIndex2 = self.imgIndex2 + 1;
	if self.imgIndex2 > 18 then
		delete(self.m_ends);
		self.m_ends = nil;
		self:stop();
	end
end


function AnimationSendRose.stop( self )
	self.isPlaying = false;
	self:dtor();
end

function AnimationSendRose.dtor( self )

	if self.m_targetAnim then
		delete(self.m_targetAnim);
		self.m_targetAnim = nil;
	end	

	if self.m_starts then
		delete(self.m_starts);
		self.m_starts = nil;
	end

	if self.m_ends then
		delete(self.m_ends);
		self.m_ends = nil;
	end

	if self.m_root then
		delete(self.m_root);
		self.m_root = nil;
	end
end

return AnimationSendRose