-- scrollView.lua
-- Author: Vicent.Gong
-- Date: 2012-10-08
-- Last modification : 2013-07-05
-- Description: Implemented ScrollView 

require("core/constants");
require("core/object");
require("core/global");
require("ui/scrollableNode");

ScrollView = class(ScrollableNode,false);

ScrollView.s_defaultScrollBarWidth = 8;

ScrollView.setDefaultScrollBarWidth = function(width)
	ScrollView.s_scrollBarWidth = width or ScrollView.s_defaultScrollBarWidth;
end

ScrollView.ctor = function(self, x, y, w, h, autoPositionChildren)
	super(self,kVertical,ScrollView.s_scrollBarWidth or ScrollView.s_defaultScrollBarWidth);

	ScrollableNode.setPos(self,x,y);
	ScrollableNode.setSize(self,w or 1,h or 1);
    local x,y = ScrollView.getUnalignPos(self);
    local w,h = ScrollView.getSize(self);
	ScrollView.setClip(self,x,y,w,h);
	
	ScrollView.setEventTouch(self,self,self.onEventTouch);
	ScrollView.setEventDrag(self,self,self.onEventDrag);
	
	self.m_autoPositionChildren = autoPositionChildren;

	self.m_mainNode = new(Node);
    self.m_mainNode:setSize(ScrollView.getSize(self));
	ScrollableNode.addChild(self,self.m_mainNode);
	self.m_nodeW = 0;
	self.m_nodeH = 0;

	ScrollView.update(self);
end

ScrollView.setScrollBarWidth = function(self, width)
	width = width 
		or ScrollView.s_scrollBarWidth 
		or ScrollView.s_defaultScrollBarWidth;

	ScrollableNode.setScrollBarWidth(self,width);
end

ScrollView.setDirection = function(self, direction)
	if (not direction) or self.m_direction == direction then
		return;
	end

	ScrollableNode.setDirection(self,direction);
end

ScrollView.setSize = function(self, w, h)
    ScrollableNode.setSize(self,w,h);
    self.m_mainNode:setSize(ScrollView.getSize(self));
end

ScrollView.getChildByName = function(self, name)
	return self.m_mainNode:getChildByName(name);
end

ScrollView.getChildren = function(self)
	return self.m_mainNode:getChildren();
end

ScrollView.addChild = function(self, child)
	self.m_mainNode:addChild(child);

	if self.m_autoPositionChildren then
		child:setAlign(kAlignTopLeft);
		child:setPos(self.m_nodeW,self.m_nodeH);
		local w,h = child:getSize();
		if self.m_direction == kVertical then
			self.m_nodeH = self.m_nodeH + h;
		else
			self.m_nodeW = self.m_nodeW + w;
		end
	else
		local x,y = child:getUnalignPos();
		local w,h = child:getSize();
		
		if self.m_direction == kVertical then
			self.m_nodeH = (self.m_nodeH > y + h) and self.m_nodeH or (y + h);
		else
			self.m_nodeW = (self.m_nodeW > x + w) and self.m_nodeW or (x + w);
		end
	end
	
	ScrollView.update(self);
end

ScrollView.removeChild = function(self, child, doCleanup, anim, deltaH)

	if not anim then
		return self.m_mainNode:removeChild(child,doCleanup);
	end

	local x, y = child:getPos();
	local w, h = child:getSize();

	local nodeAnimIndex = {};
	local needAnim = false;

	for index, child in pairs(self:getChildren()) do
		local _x, _y = child:getPos();
		if _y > y then
			nodeAnimIndex[index] = index;
			needAnim = true;
		end
	end

	self.m_mainNode:removeChild(child,doCleanup);

	if not needAnim then
		self.m_nodeH = self.m_nodeH - deltaH;
		ScrollView.update(self);
		return;
	end

	local step  = 15;
	local animH = 0;

	self.mAnimId = self.mAnimId or 0;
	self.mAnimId = self.mAnimId + 1;

	local animId = tonumber(self.mAnimId);
    
    local closeAnim = self:addPropTransparency(animId, kAnimRepeat, 50, 0, 1, 1);
    closeAnim:setDebugName("ScrollView || anim");
    closeAnim:setEvent(self, function ( self )
        -- body
        animH = animH + step;

        if animH >= deltaH then
            self:removeProp(animId);
            
            for index, child in pairs(self:getChildren()) do
            	if nodeAnimIndex[index] then
					local _x, _y = child:getPos();
					child:setPos(_x, _y - (deltaH - (animH - step)));
				end
			end
			self.m_nodeH = self.m_nodeH - deltaH;

			ScrollView.update(self);
            return;
        end

		for index, child in pairs(self:getChildren()) do
			if nodeAnimIndex[index] then
				local _x, _y = child:getPos();
				child:setPos(_x, _y - step);
			end
		end
    end);

end

ScrollView.removeAllChildren = function(self, doCleanup)
	if self.m_autoPositionChildren then
		self.m_nodeW = 0;
		self.m_nodeH = 0;
	end
	return self.m_mainNode:removeAllChildren(doCleanup);
end

ScrollView.dtor = function(self)
	
end

ScrollView.rollToTop = function(self)
    local w, h = ScrollView.getSize(self)
    local curx, cury = self.m_mainNode:setPos();

    if self.m_direction == kVertical then
		self.m_mainNode:setPos(nil,0);
	else
		self.m_mainNode:setPos(0,nil);
	end

end

---------------------------------private functions-----------------------------------------

--virtual
ScrollView.setParent = function(self, parent)
	ScrollableNode.setParent(self,parent);
	local x,y = ScrollView.getUnalignPos(self);
    local w,h = ScrollView.getSize(self);
	ScrollView.setClip(self,x,y,w,h);
end

ScrollView.getFrameLength = function(self)
    local w,h = ScrollView.getSize(self);
	if self.m_direction == kVertical then
		return h;
	else
		return w;
	end
end

ScrollView.getViewLength = function(self)
	if self.m_direction == kVertical then
		return self.m_nodeH;
	else
		return self.m_nodeW;
	end
end

ScrollView.getUnitLength = function(self)
	return 1;
end

ScrollView.needScroller = function(self)
	return true;
end

ScrollView.getFrameOffset = function(self)
	return 0;
end

ScrollView.onEventTouch =  function(self, finger_action, x, y, drawing_id_first, drawing_id_current)
	
end

ScrollView.onEventDrag =  function(self, finger_action, x, y,drawing_id_first, drawing_id_current)
	if not ScrollView.hasScroller(self) then return end

	self.m_scroller:onEventTouch(finger_action,x,y,drawing_id_first,drawing_id_current);

end

ScrollView.onScroll = function(self, scroll_status, diffY, totalOffset)
	ScrollableNode.onScroll(self,scroll_status,diffY,totalOffset);

	if self.m_direction == kVertical then
		self.m_mainNode:setPos(nil,totalOffset);
	else
		self.m_mainNode:setPos(totalOffset,nil);
	end
end

require("ui/ex/ScrollViewEx")