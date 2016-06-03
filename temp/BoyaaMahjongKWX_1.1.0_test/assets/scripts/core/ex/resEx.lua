require("core/res")
--------------------------------------ResDoubleRase---------------------------------------------

---------------------------------------ResDoubleArraySin-----------------------------------------
ResDoubleArraySinIn = class(ResBase);

ResDoubleArraySinIn.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_sinin(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArraySinIn.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArraySinIn.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArraySinOut = class(ResBase);

ResDoubleArraySinOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_sinout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArraySinOut.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArraySinOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArraySinInOut = class(ResBase);

ResDoubleArraySinInOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_sininout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArraySinInOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArraySinInOut.dtor = function(self)
	res_delete(self.m_resID);
end 

---------------------------------------ResDoubleArrayExp-----------------------------------------

ResDoubleArrayExpIn = class(ResBase);

ResDoubleArrayExpIn.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_expin(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayExpIn.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayExpIn.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayExpOut = class(ResBase);

ResDoubleArrayExpOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_expout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayExpOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayExpOut.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayExpInOut = class(ResBase);

ResDoubleArrayExpInOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_expinout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayExpInOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayExpInOut.dtor = function(self)
	res_delete(self.m_resID);
end 

---------------------------------------ResDoubleArrayelastic---------------------------------------

ResDoubleArrayElasticIn = class(ResBase);

ResDoubleArrayElasticIn.ctor = function(self,duration,startV,endV,period)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_elasticin(0,self.m_resID,self.m_arrayLength,startV,endV,period or 0.3);
end 

ResDoubleArrayElasticIn.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayElasticIn.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayElasticOut = class(ResBase);

ResDoubleArrayElasticOut.ctor = function(self,duration,startV,endV,period)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_elasticout(0,self.m_resID,self.m_arrayLength,startV,endV,period or 0.3);
end 

ResDoubleArrayElasticOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayElasticOut.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayElasticInOut = class(ResBase);

ResDoubleArrayElasticInOut.ctor = function(self,duration,startV,endV,period)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_elasticinout(0,self.m_resID,self.m_arrayLength,startV,endV,period or 0.3);
end 

ResDoubleArrayElasticInOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayElasticInOut.dtor = function(self)
	res_delete(self.m_resID);
end 


-----------------------------------------ResDoubleArrayBounce-----------------------------

ResDoubleArrayBounceIn = class(ResBase)

ResDoubleArrayBounceIn.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_bouncein(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayBounceIn.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayBounceIn.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayBounceOut = class(ResBase)

ResDoubleArrayBounceOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_bounceout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayBounceOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayBounceOut.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayBounceInOut = class(ResBase)

ResDoubleArrayBounceInOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_bounceinout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayBounceInOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayBounceInOut.dtor = function(self)
	res_delete(self.m_resID);
end 

------------------------------------------ResDoubleArrayBack------------------------------------

ResDoubleArrayBackIn = class(ResBase)

ResDoubleArrayBackIn.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_backin(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayBackIn.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayBackIn.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayBackOut = class(ResBase)

ResDoubleArrayBackOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_backout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayBackOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayBackOut.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayBackInOut = class(ResBase)

ResDoubleArrayBackInOut.ctor = function(self,duration,startV,endV)
	self.m_arrayLength = math.floor(60 * duration /1000);
	res_create_double_array_backinout(0,self.m_resID,self.m_arrayLength,startV,endV);
end 

ResDoubleArrayBackInOut.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayBackInOut.dtor = function(self)
	res_delete(self.m_resID);
end 

------------------------------------------ResDoubleExtra----------------------------------------

ResDoubleArrayCurve = class(ResBase)

ResDoubleArrayCurve.ctor = function(self,duration,startV,endV,control)
	self.m_arrayLength = math.floor(60 * duration / 1000);
	res_create_double_array_curve(0,self.m_resID,self.m_arrayLength,startV,endV,control);
end 

ResDoubleArrayCurve.getLength = function(self)
	return self.m_arrayLength;
end 

ResDoubleArrayCurve.dtor = function(self)
	res_delete(self.m_resID);
end

ResDoubleArrayEllipseX = class(ResBase);

ResDoubleArrayEllipseX.ctor = function(self,duration,centerX,axisX,angle)
	self.m_arrayLength = math.floor(60 * duration / 1000);
	res_create_double_array_ellipseX(0,self.m_resID,self:getLength(),centerX,axisX,angle);
end 

ResDoubleArrayEllipseX.getLength = function(self)
	return self.m_arrayLength or 0;
end 

ResDoubleArrayEllipseX.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayEllipseY = class(ResBase);

ResDoubleArrayEllipseY.ctor = function(self,duration,centerY,axisY,angle)
	self.m_arrayLength = math.floor(60 * duration / 1000);
	res_create_double_array_ellipseY(0,self.m_resID,self:getLength(),centerY,axisY,angle);
end 

ResDoubleArrayEllipseY.getLength = function(self)
	return self.m_arrayLength or 0;
end 

ResDoubleArrayEllipseY.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayJumpX = class(ResBase);

ResDoubleArrayJumpX.ctor = function(self,duration,startX,endX,times,height)
	self.m_arrayLength = math.floor(60 * duration / 1000);
	res_create_double_array_jumpX(0,self.m_resID,self:getLength(),startX,endX,times,height);
end 

ResDoubleArrayJumpX.getLength = function(self)
	return self.m_arrayLength or 0;
end 

ResDoubleArrayJumpX.dtor = function(self)
	res_delete(self.m_resID);
end 

ResDoubleArrayJumpY = class(ResBase);

ResDoubleArrayJumpY.ctor = function(self,duration,startY,endY,times,height)
	self.m_arrayLength = math.floor(60 * duration / 1000);
	times = times or 2
	height = height or 100
	res_create_double_array_jumpY(0,self.m_resID,self:getLength(),startY,endY,times,height);
end 

ResDoubleArrayJumpY.getLength = function(self)
	return self.m_arrayLength or 0;
end 

ResDoubleArrayJumpY.dtor = function(self)
	res_delete(self.m_resID);
end 