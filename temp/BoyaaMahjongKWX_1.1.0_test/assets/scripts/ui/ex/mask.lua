--region NewFile_1.lua
--Author : OwenDou
--Date   : 2015/3/12
--此文件由[BabeLua]插件自动生成
require("ui/node");
require("core/system");
require("core/constants")
require("core/ex/drawingEx");

Mask = class(Node);

Mask.ctor = function (self, imageFile, imageMask)
    if not (imageFile and imageMask) then return end;
    self:loadRes(imageFile,imageMask);
    self:renderMask();
end

Mask.dtor = function (self)
    delete(self.m_prifileImage);
    delete(self.m_maskImage);

    self.m_prifileImage = nil;
    self.m_maskImage = nil;
end

Mask.setSize = function (self, w, h)  
    self.m_width = w or 0;
    self.m_height = h or 0;
          
    self.m_prifileImage:setSize(self.m_width, self.m_height);
    self.m_maskImage:setSize(self.m_width, self.m_height);
end

Mask.getSize = function (self)
    return self:getRealSize();
end

-----------------------private function---------------------------------
Mask.loadRes = function (self, imageFile, imageMask)

    self.m_prifileImage = new(Image, imageFile, nil, 1);
    self.m_maskImage = new(Image, imageMask, nil, 1);
     
    self:addChild(self.m_maskImage);
    self:addChild(self.m_prifileImage);

    self.m_width, self.m_height = self.m_prifileImage:getSize();
end

Mask.renderMask= function (self)
    if self.m_prifileImage and self.m_maskImage then
        self.m_maskImage:setBlend(kBlendSrcOneMinusSrcAlpha, kBlendDstOneMinusSrcColor);
        self.m_prifileImage:setBlend(kBlendSrcOneMinusDstAlpha, kBlendDstDstAlpha);
	 end
end

Mask.getRealSize =function(self)
    return self.m_width*System.getLayoutScale(), self.m_height*System.getLayoutScale();
end

Mask.setFile = function(self, ...)
    if self.m_prifileImage then
        self.m_prifileImage:setFile(...)
    end
end
