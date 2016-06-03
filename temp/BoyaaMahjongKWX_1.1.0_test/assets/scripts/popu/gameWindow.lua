local GameWindow = class(BaseLayer)

function GameWindow:ctor(viewConfig, data, tag)
	self:setVisible(false)
	self:setFillParent(true, true)
	self.m_root:setFillParent(true, true)
	
	local bg = self.m_root:getChildByName("img_bg")
	if bg then
		bg:setEventTouch(nil, function() end)
		bg:setEventDrag(nil, function() end)
	end
	self:initView(data, tag)

	EventDispatcher.getInstance():register(HttpModule.s_event, self, self.onPHPRequestsCallBack);
end

function GameWindow:dtor()
	EventDispatcher.getInstance():unregister(HttpModule.s_event, self, self.onPHPRequestsCallBack);
end


function GameWindow:isBgTouchHide()
	return self.bgTouchHide
end

function GameWindow:isAutoRemove()
	return self.autoRemove
end

function GameWindow:isStateRemove()
	return self.stateRemove
end

function GameWindow:isPlayAnim()
	return self.animFlag
end

-- back键
function GameWindow:isBackHide()
	return self.backHide
end

function GameWindow:setConfigFlag(bgTouchHide, backHide, autoRemove, stateRemove)
	self.bgTouchHide = bgTouchHide
	self.backHide 	 = backHide
	self.autoRemove  = autoRemove
	self.stateRemove = stateRemove
end

function GameWindow:initView(data)

end

function GameWindow:updateView(data)
end

--@isOtherDismiss 是否非关闭按钮
function GameWindow:onHidenEnd(isOtherDismiss)
	self.animFlag = nil
	self:setVisible(false)
	self:getParent():onHidenEnd(self:getName(), self:isAutoRemove())
	EventDispatcher.getInstance():dispatch(Event.Message, "closePopu", {popuId = self:getName(), isOtherDismiss = isOtherDismiss});
end

function GameWindow:onShowEnd()
	printInfo("onShowEnd")
	self.animFlag = nil
	self:getParent():onShowEnd(self:getName())
end

function GameWindow:show(style)
	self.m_style = style or WindowStyle.POPUP
	if self.animFlag or self:getVisible() then
		return false
	end

	self:setVisible(true)
	self.animFlag = true
	if self.m_style == WindowStyle.NORMAL then
		self:onShowEnd()
	elseif self.m_style == WindowStyle.TRANSLATE_DOWN then
		local anim = self:addPropTranslateEase(1001, kAnimNormal, ResDoubleArrayBackOut, 300, -1, 0, 0, -display.cy * 2, 0)
		if anim then
			anim:setEvent(nil, function()
				self:removeProp(1001)
				self:onShowEnd()
			end)
		end
	elseif self.m_style == WindowStyle.POPUP then
		-- local anim = self:addPropScaleEase(1001, kAnimNormal, ResDoubleArrayBackOut, 300, 0, 0.3, 1, 0.3, 1, kCenterXY, display.cx, display.cy)
		-- if anim then
		-- 	anim:setEvent(nil, function()
		-- 		self:removeProp(1001)
		-- 		self:onShowEnd()
		-- 	end)
		-- end
    	local anim = self:addPropScaleWithEasing(1001, kAnimNormal, 250, -1, 'easeOutBack', 'easeOutBack', 0.5, 0.5)
		if anim then
			anim:setEvent(nil, function()
				self:removeProp(1001)
				self:onShowEnd()
			end)
		end
	elseif self.m_style == WindowStyle.MOVETO_DOWN then
		local anim = self:addPropTranslate(1001, kAnimNormal, 300, 0, 0, 0, -display.cy * 2, 0)
		if anim then
			anim:setEvent(nil, function()
				self:removeProp(1001)
				self:onShowEnd()
			end)
		end
	end
	return true
end

function GameWindow:dismiss(directFlag, isOtherDismiss)
	if self.animFlag or not self:getVisible() then
		return false
	end
	self.animFlag = true
	if directFlag or self.m_style == WindowStyle.NORMAL or not self.m_style then
		self:onHidenEnd(isOtherDismiss)
	elseif self.m_style == WindowStyle.TRANSLATE_DOWN then
		local anim = self:addPropTranslateEase(1002, kAnimNormal, ResDoubleArrayBackIn, 300, -1, 0, 0, 0, -display.cy * 2)
		if anim then
			anim:setEvent(nil, function()
				self:removeProp(1002)
				self:onHidenEnd(isOtherDismiss)
			end)
		end
	elseif self.m_style == WindowStyle.POPUP then
		-- local anim = self:addPropScaleEase(1002, kAnimNormal, ResDoubleArrayBackIn, 300, 0, 1, 0, 1, 0, kCenterXY, display.cx, display.cy)
		-- if anim then
		-- 	anim:setEvent(nil, function()
		-- 		self:removeProp(1002)
		-- 		self:onHidenEnd(isOtherDismiss)
		-- 	end)
		-- end
		local anim = self:addPropScaleWithEasing(1001, kAnimNormal, 250, -1, 'easeInBack', 'easeInBack', 1.0, -0.5)
		if anim then
			anim:setEvent(nil, function()
				self:removeProp(1001)
				self:onHidenEnd(isOtherDismiss)
			end)
		end
	elseif self.m_style == WindowStyle.MOVETO_DOWN then
		local anim = self:addPropTranslate(1001, kAnimNormal, 300, 0, 0, 0, 0, -display.cy * 2)
		if anim then
			anim:setEvent(nil, function()
				self:removeProp(1001)
				self:onHidenEnd(isOtherDismiss)
			end)
		end
	end

	return true
end

function GameWindow:onPHPRequestsCallBack(command, ...)
	if self.s_severCmdEventFuncMap[command] then
     	self.s_severCmdEventFuncMap[command](self,...)
	end 
end 


--[[
	通用的（大厅）协议
]]
GameWindow.s_severCmdEventFuncMap = {
}

return GameWindow
