-- image.lua
-- Author: Vicent Gong
-- Date: 2012-09-24
-- Last modification : 2013-06-25
-- Description: Wrap a class to create a image quickly

require("core/object");
require("core/res");
require("core/drawing");

Image = class(DrawingImage,false);

Image.ctor = function(self, file, fmt, filter, leftWidth, rightWidth, topWidth, bottomWidth)
	self.m_res = new(ResImage,file,fmt,filter);
	self.m_gray = false;
	super(self,self.m_res,leftWidth,rightWidth,topWidth,bottomWidth);
end

Image.setFile = function(self, file, ...)
	self.m_res:setFile(file, ...);
	Image.setResRect(self,0,self.m_res);
end

Image.setIsGray = function(self, flag, enable)
	local format = self.m_res and self.m_res.m_format;
	-- 已经支持 kRGBGray
	if format == kRGBGray then 
		self:setGray(flag and 1 or nil);
		if not enable then
			self:setPickable(not flag);
		else
			self:setPickable(true);
		end
	elseif format then  -- 没有支持 kRGBGray
		-- 拿到 图片名
		local fileName = self.m_res and self.m_res.m_file;
		if not fileName then return end;
		if flag then
			self:setFile(fileName, kRGBGray);
			self:setGray(1);
		else
			self:setGray();
		end
		if not enable then
			self:setPickable(not flag);
		else
			self:setPickable(true);
		end
	end
end

Image.dtor = function(self)
	delete(self.m_res);
	self.m_res = nil;
end
