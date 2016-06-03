-- images.lua
-- Author: Vicent Gong
-- Date: 2012-09-24
-- Last modification : 2013-06-25
-- Description: Implement Images

require("core/object");
require("core/global");
require("ui/image");

Images = class(Image,false);

Images.ctor = function(self, filenameArray, fmt, filter, leftWidth, rightWidth, topWidth, bottomWidth)
	super(self,filenameArray[1],fmt,filter,leftWidth,rightWidth,topWidth,bottomWidth);

	self.m_reses = {};
	for i=2,#filenameArray do 
		local res = new(ResImage,filenameArray[i],fmt,filter);
		Images.addImage(self,res,i-1);
		self.m_reses[i-1] = res;
	end
end

Images.setImageIndex = function(self, index)
    if index < 0 or index > #self.m_reses then 
        FwLog("Imgaes setIndex , index < 0 or index > resCounts");
        return;
    end

    Image.setImageIndex(self,index);
end

Images.dtor = function(self)
	printInfo("Images.dtor")
	for _,v in pairs(self.m_reses) do
		delete(v);
	end
	
	self.m_reses = nil;
end
