ToastShade = class();

ToastShade.s_defaultShadeBg = "ui/shade.png";

ToastShade.s_level = 51;

ToastShade.getInstance = function()
	if not ToastShade.s_instance then 
		ToastShade.s_instance = new(ToastShade);
	end
	return ToastShade.s_instance;
end

ToastShade.ctor = function(self)
	self.m_level = ToastShade.s_level
	self.m_shadeBgImg = ToastShade.s_defaultShadeBg
	self.m_commandCount = 0
	self.m_isPlaying = false
end

ToastShade.dtor = function(self)
	self:stopTimer();
end

------------------------------------------------public--------------------
ToastShade.setLevel = function(self , level)
	self.m_level = level or ToastShade.s_level;
end

ToastShade.play = function(self)
	if not self.loaded then
		self:load();
	end
	self.m_root:show()
	if not self.m_isPlaying then
		self.m_swfPlayer:play(1, false, -1)
		self.m_swfPlayer:show()
	end
	self.m_isPlaying = true
	self.m_commandCount = self.m_commandCount + 1
end

------------------------------------private------------------------------------------
ToastShade.load = function(self)
	self.m_root = new(Node)
	self.m_root:addToRoot()
	self.m_root:setLevel(self.m_level)
	self.m_root:setFillParent(true, true)

	self.m_shadeBg = new(Image , self.m_shadeBgImg)
	self.m_root:addChild(self.m_shadeBg)
	self.m_shadeBg:setFillParent(true , true)
	self.m_shadeBg:setEventTouch(self , self.onShadeBgTouch)
	self.m_shadeBg:setEventDrag(self,  self.onShadeBgTouch )

	require("swfPin/loading_swf_pin")
	self.m_swfPlayer = new(SwfPlayer, require("swfPin/loading_swf_info"))
	self.m_swfPlayer:setAlign(kAlignCenter)
	self.m_root:addChild(self.m_swfPlayer)
	self.m_swfPlayer:hide()

	self.loaded = true;
end

ToastShade.setTouchFunc = function(self, callback)
	self.m_touchFunc = callback
end

ToastShade.stopCommand = function(self)
	self.m_commandCount = self.m_commandCount - 1
	if self.m_commandCount <= 0 then
		self:stopTimer()
	end
end

ToastShade.stopTimer = function(self)
	if self.m_root then
		self.m_root:hide()
	end
	self.m_isPlaying = false
	self.m_commandCount = 0
	if self.m_swfPlayer then
		-- self.m_swfPlayer:hide()
		self.m_swfPlayer:stopTimer()
		self.m_swfPlayer:gotoAndStop(1)
	end
end

ToastShade.onShadeBgTouch = function(self , finger_action,x,y,drawing_id_first,drawing_id_current)
	if finger_action == kFingerDown then
		if self.m_touchFunc then
			self.m_touchFunc()
		end
		self:stopTimer()
	end
end
