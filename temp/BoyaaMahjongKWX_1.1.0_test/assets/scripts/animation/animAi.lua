local AnimationBase = require("animation.animationBase")
local AnimAi = class(AnimationBase)

function AnimAi:load(aiFlag)
	printInfo("创建动画")
	if self.loaded then return end

	self.m_image = UIFactory.createImage("kwx_room/userAI.png")
		:addTo(self)	
	local width,height = self.m_image:getSize()
	self.m_image:align(kAlignBottomLeft, -width, 0)

	self.m_image:setEventTouch(self, function(obj, finger_action)
		if finger_action == kFingerDown then
			EventDispatcher.getInstance():dispatch(Event.Message, "requestAi", 0)
		end
	end);
	self.loaded = true
end

function AnimAi:play(aiFlag)
	if self.aiFlag == aiFlag then 
		printInfo("重复播放托管动画")
		return
	end
	self.aiFlag = aiFlag
	self:stop()
	self:load(aiFlag)
	self:show()
	checkAndRemoveOneProp(self.m_image, 123)
	local width,height = self.m_image:getSize()
	if aiFlag then
		self.mAnim = self.m_image:addPropTranslateEase(123, kAnimNormal, ResDoubleArrayBackIn, 300, 0, width, 0, 0, 0)
		if self.mAnim then
			self.mAnim:setEvent(nil, function()
				checkAndRemoveOneProp(self.m_image, 123)
			end)
		end
	else
		self.mAnim = self.m_image:addPropTranslateEase(123, kAnimNormal, ResDoubleArrayBackOut, 300, 0, 0, width, 0, 0)
		if self.mAnim then
			self.mAnim:setEvent(nil, function()
				self:hide()
				checkAndRemoveOneProp(self.m_image, 123)
			end)
		end
	end
end

function AnimAi:forceShow()
	local width,height = self.m_image:getSize()
	self.m_image:pos(-width, 0)
	self:show()
end

function AnimAi:stop()
	printInfo("停止动画")
end

function AnimAi:release()
	printInfo("销毁动画")
	self:stop()
	self.m_image:removeSelf()
	self.m_image = nil
	self.loaded = nil
end

return AnimAi