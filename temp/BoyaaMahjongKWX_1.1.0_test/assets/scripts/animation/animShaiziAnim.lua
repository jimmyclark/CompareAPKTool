local AnimationBase = require("animation.animationBase")
local AniShaiziAnim = class(AnimationBase)

local PATH = "animation/shaizi/"
function AniShaiziAnim:play(data)
	self.onComplete = data.onComplete
	self:analysShaiziNum(data.eastSeatId, data.bankSeatId, data.iSH_ShaiziNum1, data.iSH_ShaiziNum2)
	self:stop();
	self:load();
	self:setVisible(true);

	self.randomTb = {};
	for i=4, 11 do
		table.insert(self.randomTb, i);
	end
	self.animIndex = new(AnimInt,kAnimRepeat,0, 1, 60,0);
	self.animIndex:setDebugName("AniShaiziAnim|AniShaiziAnim.animIndex");
	self.animIndex:setEvent(self, self.onTimer);

	self.rotateImgLeft:addPropTranslateEase(121, kAnimNormal, ResDoubleArraySinIn, 200, 0, -200, 0, 0, 0)
	self.rotateImgLeft:addPropTranslateEase(122, kAnimNormal, ResDoubleArraySinOut, 200, 0, 0, 0, -100, 0)

	self.rotateImgRight:addPropTranslateEase(121, kAnimNormal, ResDoubleArraySinIn, 200, 0, -200, 0, 0, 0)
	self.rotateImgRight:addPropTranslateEase(122, kAnimNormal, ResDoubleArraySinOut, 200, 0, 0, 0, -100, 0)
	return self
end

-- @shaiziNum1 shaiziNum2 上海
function AniShaiziAnim:analysShaiziNum(eastSeatId, bankSeatId, shaiziNum1, shaiziNum2)
	self.result = {};
	shaiziNum1 = shaiziNum1 or 0
	shaiziNum2 = shaiziNum2 or 0
	if G_RoomCfg:getGameType() == GameType.SHMJ and shaiziNum1 > 0 and shaiziNum2 > 0 then
		self.result[1] = shaiziNum1
		self.result[2] = shaiziNum2
		return
	end

  	local resultAll ={};
  	local shaiziNum = (eastSeatId - bankSeatId + PLAYER_COUNT) % PLAYER_COUNT + 1
	for i=1,6 do
	    for j=1,6 do
	        if((i+j-1) % 4 + 1== shaiziNum) then
	           	local result = {};
	           	result.i=i;
	           	result.j=j;
	           	table.insert(resultAll,result);
	        end
	    end
	end
    local index = math.random(1, #resultAll);
   	self.result[1]=resultAll[index].i;
   	self.result[2]=resultAll[index].j;
end

function AniShaiziAnim:load()
	if self.loaded then
		return;
	end
	local leftImages = {};  --shaizi_anmi1.png   
	local rightImages = {};  --shaizi_anmi1.png   
	local leftRandomTb = {1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6,}
	local rightRandomTb = {1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6,}
	for i=1, 11 do
		local index = (i - 1) % 4 + 1
		local leftIndex = table.remove(leftRandomTb, math.random(1, #leftRandomTb))
		table.insert(leftImages, PATH .. string.format("%d-%d.png", leftIndex, index));
		local rightIndex = table.remove(rightRandomTb, math.random(1, #rightRandomTb))
		table.insert(rightImages, PATH .. string.format("%d-%d.png", rightIndex, index));
	end
	table.insert(leftImages, PATH .. string.format("%d-1.png", self.result[1]))
	table.insert(rightImages, PATH .. string.format("%d-1.png", self.result[2]))
	self.rotateImgLeft = new(Images, leftImages);
	self.rotateImgRight = new(Images, rightImages);

	local w,h =  self.rotateImgLeft:getSize()
	local w1,h1 =  self.rotateImgRight:getSize()
	self:setSize(w + w1, h);
	self:setPos(display.cx, display.cy);
	self:setAlign(kAlignCenter);

	self.loaded = true;

	self.rotateImgLeft:pos(-w/2, 0)
	self.rotateImgRight:pos(w/2, 0)
	self:addChild(self.rotateImgLeft);
	self:addChild(self.rotateImgRight);
	
	self:setVisible(false);
end

function AniShaiziAnim:onTimer(amim_type, anim_id, repeat_or_loop_num)	
	self.step = self.step + 1;

	if self.step <= 12 then
		self.rotateImgLeft:setImageIndex(self.step);
		self.rotateImgRight:setImageIndex(self.step);
	elseif self.step > 20 then
		self:release()
	end
end 

function AniShaiziAnim:stop()
	if self.animIndex then
		delete(self.animIndex);
		self.animIndex = nil;
	end
	self.step = 0;
end

function AniShaiziAnim:release()
	self:stop();
	if self.onComplete then
		self.onComplete()
	end
	self:removeSelf()
end

return AniShaiziAnim