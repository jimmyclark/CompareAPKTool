-- button.lua
-- Author: Vicent Gong
-- Date: 2012-09-24
-- Last modification : 2013-06-25
-- Description: Implement a button 

require("core/constants");
require("core/object");
require("core/global");
require("ui/images");

Button = class(Images,false);

Button.ctor = function(self, normalFile, disableFile, fmt, filter, leftWidth, rightWidth, topWidth, bottomWidth)
	super(self,{normalFile, disableFile},fmt,filter,leftWidth,rightWidth,topWidth,bottomWidth);

	self.m_showEnbaleFunc = disableFile 
						and self.showEnableWithDisableImage 
						or self.showEnableWithoutDisableImage;
	
	self.m_enable = true;
	Button.setEventTouch(self,self,self.onClick);

	self.m_eventCallback = {};
	self.m_animFlag = true


	self.m_downX = 0;
	self.m_downY = 0;
	self.m_enableEvent = true;
end

Button.setEnable = function(self, enable)
	self.m_enable = enable;
	self.m_showEnbaleFunc(self,self.m_enable);
end

Button.getEnable = function(self)
	return self.m_enable;
end

Button.setOnClick = function(self, obj, func, responseType)
    self.m_eventCallback.func = func;
	self.m_eventCallback.obj = obj;

	self.m_responseType = responseType or kButtonUpInside;
end

Button.dtor = function(self)
	delete(self.m_resDisable);
	self.m_resDisable = nil;

	self.m_eventCallback = nil;
end

Button.enableAnim = function(self, flag)
	self.m_animFlag = flag
end
---------------------------------private functions-----------------------------------------

--virtual
Button.showEnableWithoutDisableImage = function(self, enable, anim)
	if enable then
		self:setColor(255,255,255);
	else
		self:setColor(220,220,220);
	end
	if anim and self.m_animFlag then
		local startScale = enable and 1.05 or 1.0
		local endScale = enable and 1.0 or 1.05
		local sequence = enable and 1234 or 4321 -- 避免影响其他
		local releaseSequence = enable and 4321 or 1234 -- 避免影响其他
		if self.m_props[releaseSequence] then
			self:removeProp(releaseSequence)
		end
		if self.m_props[sequence] then
			self:removeProp(sequence)
		end
		local scaleAnim = self:addPropScale(sequence, kAnimNormal, 200, 0, startScale, endScale, startScale, endScale, kCenterDrawing)
		if scaleAnim then
			scaleAnim:setEvent(nil, function()
				if enable then
					if self.m_props[releaseSequence] then
						self:removeProp(releaseSequence)
					end
					if self.m_props[sequence] then
						self:removeProp(sequence)
					end
				end
			end)
		end
	end
end	

--virtual
Button.showEnableWithDisableImage = function(self, enable)
	if enable then
		Button.setImageIndex(self,0);
	else
		Button.setImageIndex(self,1);
	end
end	

--virtual
Button.onClick = function(self, finger_action, x, y, drawing_id_first, drawing_id_current)
	if not self.m_enable then
		return;
	end

	if finger_action == kFingerDown then
		self.onceFlag = false
	   	self.m_showEnbaleFunc(self,false,true);

	   	self.m_downX, self.m_downY = self:getAbsolutePos();
	   	self.m_enableEvent = true;

	elseif finger_action == kFingerMove then
		if not self.onceFlag then
			if not (self.m_responseType == kButtonUpInside and drawing_id_first ~= drawing_id_current) then
				self.m_showEnbaleFunc(self,false);
			else
				self.m_showEnbaleFunc(self,true);
			end
			self.onceFlag = true
		end
		local downX, 	downY 	= self:getAbsolutePos();
		if self.m_enableEvent then
        	self.m_enableEvent 	= math.abs(self.m_downX - downX) < 50 and math.abs(self.m_downY - downY) < 50;
       	end
	elseif finger_action == kFingerUp then
		self.m_showEnbaleFunc(self,true,true);
		
		local responseCallback = function()
			if self.m_eventCallback.func then
				kEffectPlayer:play(Effects.AudioButtonClick);

				local downX, 	downY = self:getAbsolutePos();
				if  self.m_enableEvent 					and
					math.abs(self.m_downX - downX) < 50 and 
					math.abs(self.m_downY - downY) < 50 then
                	self.m_eventCallback.func(self.m_eventCallback.obj,finger_action,x,y,
                		drawing_id_first,drawing_id_current);
               	end
            end	
		end

		if self.m_responseType == kButtonUpInside then
			if drawing_id_first == drawing_id_current then
				responseCallback();
			end
	    elseif self.m_responseType == kButtonUpOutside then
	    	if drawing_id_first ~= drawing_id_current then
				responseCallback();
			end
		else
			responseCallback();
		end
	elseif finger_action==kFingerCancel then
		self.m_showEnbaleFunc(self,true,true);
	end
end
