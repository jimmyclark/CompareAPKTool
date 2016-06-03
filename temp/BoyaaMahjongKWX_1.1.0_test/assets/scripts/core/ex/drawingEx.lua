if DrawingBase then

local ctor = DrawingImage.ctor
function DrawingImage:ctor(...)
	ctor(self, ...)
	self.m_originWidth = self.m_width
	self.m_originHeight = self.m_height
end

function DrawingImage:getResSize()
	return self.m_res:getWidth(), self.m_res:getHeight()
end

function DrawingBase:getOriginSize()
	return self.m_originWidth or 1, self.m_originHeight or 1
end

function DrawingBase:getScale()
	return self.m_scaleX or 1, self.m_scaleY or 1
end

local setSize = DrawingBase.setSize
function DrawingBase:setSize(width, height)
	setSize(self, width, height)
	return self
end

function DrawingBase:setScale(scaleX, scaleY)
	scaleY = scaleY or scaleX
	local originWidth, originHeight = self:getOriginSize()
	self:setSize(scaleX * originWidth, scaleY * originHeight)

	self.m_scaleX = scaleX
	self.m_scaleY = scaleY
	return self
end

function DrawingBase:addTo(parent, level)
	parent:addChild(self)
	if level then self:setLevel(level) end
	return self
end

function DrawingBase:pos(x, y)
	self:setPos(x, y)
	return self
end

function DrawingBase:align(align, x, y)
	self:setAlign(align)
	if x and y then
		self:setPos(x, y)
	end
	return self
end

function DrawingBase:removeSelf()
	local parent = self:getParent()
	if parent then
		return parent:removeChild(self, true)
	else
		delete(self)
	end
end

function DrawingBase:show()
	self:setVisible(true)
	return self
end

function DrawingBase:hide()
	self:setVisible(false)
	return self
end

function DrawingBase:_addAnim(animLoop, animTime, delayTime)
	self._anims = self._anims or {}
	local anim = AnimFactory.createAnimDouble(animLoop, 0, 1, animTime, delayTime or 0)
	local animId = anim:getID()
	self._anims[animId] = anim
	return anim
end

function DrawingBase:schedule(func, perTime, delayTime)
	local anim = self:_addAnim(kAnimRepeat, perTime, delayTime)
	anim:setEvent(nil, func)
	return anim
end

function DrawingBase:performWithDelay(func, delayTime)
	local anim = self:_addAnim(kAnimNormal, delayTime)
	anim:setEvent(nil, func)
	return anim
end

function DrawingBase:getActionByTag(tag)
	return self._anims and self._anims[tag]
end

function DrawingBase:stopActionByTag(tag)
	if not self._anims then return end
	for k,v in pairs(self._anims) do
		if v:getTag() == tag then
			delete(v)
			self._anims[k] = nil
			break
		end
	end
end

function DrawingBase:stopAllActions()
	if type(self.m_props) == "table" then
		for sequence, v in pairs(self.m_props) do 
			drawing_prop_remove(self.m_drawingID, sequence)
			delete(v["prop"]);
			if v["anim"] then
				for _,anim in pairs(v["anim"]) do 
					delete(anim);
				end
			end
			if v["res"] then
				for _,res in pairs(v["res"]) do 
					delete(res);
				end
			end
		end
	end
	self.m_props = {};

	if type(self._anims) == "table" then
		for k,v in pairs(self._anims) do
			delete(v)
		end
	end
	self._anims = {}
end

local dtor = DrawingBase.dtor
function DrawingBase:dtor()
	self:stopAllActions()
	dtor(self)
end

function DrawingBase:setDebugNameByPropAndAnim(sequence , name)
	name = name or "";
	if self.m_props[sequence] then
		local prop = self.m_props[sequence]["prop"];
		if prop then
			prop:setDebugName(name);
			for _,v in pairs(self.m_props[sequence]["anim"]) do 
				if v then
					v:setDebugName(name);
				end
			end
		end
	end
end

-------------Blend---------------------------
function DrawingBase:setBlend(blendSrc, blendDst)
	drawing_set_blend_mode(self.m_drawingID, blendSrc, blendDst);
end

end