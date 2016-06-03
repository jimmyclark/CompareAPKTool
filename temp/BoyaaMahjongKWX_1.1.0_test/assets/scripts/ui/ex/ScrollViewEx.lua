if ScrollView then

local ctor = ScrollView.ctor
function ScrollView:ctor(...)
	ctor(self, ...)

	self.mReachBottomCallback 	= nil;
	self.mReachBottomObj 		= nil;
	self.mIsReachBottom 		= false;
end

function ScrollView:setOnReachBottom(obj, callback)
	self.mReachBottomCallback 	= callback;
	self.mReachBottomObj 		= obj;
end

function ScrollView:setOffset(offset)
end

local onScroll = ScrollView.onScroll
function ScrollView:onScroll(scroll_status, diffY, totalOffset)
	onScroll(self, scroll_status, diffY, totalOffset);
	if self:getFrameLength() - self:getViewLength() > totalOffset then
		if not self.mIsReachBottom and self.mReachBottomCallback then
			self.mReachBottomCallback(self.mReachBottomObj)
		end
		self.mIsReachBottom = true;
	else
		self.mIsReachBottom = false;
	end
end

end