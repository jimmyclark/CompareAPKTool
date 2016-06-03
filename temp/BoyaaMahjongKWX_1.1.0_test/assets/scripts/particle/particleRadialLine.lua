require("particle/particleBase");

--ParticleRadialLine --粒子类
--辐射光线

ParticleRadialLine = class(ParticleBase);
ParticleRadialLine.liveTime = 5;	--粒子生命时长
ParticleRadialLine.colortable = {{1.0,1.0,1.0,1.0}};
ParticleRadialLine.ctor = function(self, file)
end

ParticleRadialLine.init = function(self, len, index, node)
	self.m_fade = 0.2;--衰减速度
	self.m_active = true;		--是否激活状态
 	self.m_live = ParticleRadialLine.liveTime;--粒子生命
 	self.m_rotation = (15*len)%360;
	if self.m_rotation%45==15 then
	 	self.m_rotation=self.m_rotation-5;
	elseif self.m_rotation%45==30 then
	 	self.m_rotation=self.m_rotation+5;
 	end
 	
 	local r = node.moredata.r;
 	
 	self.m_frame = math.ceil(self.m_live/self.m_fade);
 	self.m_yi = math.sin(math.rad(self.m_rotation))*r/self.m_frame;
--	if math.random(10) > 5 then self.m_yi = -self.m_yi;end 
	self.m_alpha = 0.0;
	--移动速度/方向
	self.m_y0 = node.m_y0;
	self.m_x = node.m_x0;
	self.m_y = self.m_y0;
	if self.m_rotation%45==0 then
		self.m_x=math.cos(math.rad(self.m_rotation))*18;
		self.m_y=math.sin(math.rad(self.m_rotation))*18;
	end
	self.m_scale = 1;
	self.m_tick = 0;
	local imgW = node.m_texW;
	local imgH = node.m_texH;
	local t_vtx = node.m_vertexArr;
	t_vtx[len*8+1],t_vtx[len*8+3],t_vtx[len*8+5],t_vtx[len*8+7] = self.m_x,self.m_x+self.m_scale*imgW,self.m_x+self.m_scale*imgW,self.m_x;
	t_vtx[len*8+2],t_vtx[len*8+4],t_vtx[len*8+6],t_vtx[len*8+8] = self.m_y,self.m_y,self.m_y+self.m_scale*imgH,self.m_y+self.m_scale*imgH;
	local t_clr = node.m_colorArr;
	local color = ParticleRadialLine.colortable[1];
	if t_clr then
	 	for i = 1, 4 do 
	 		t_clr[len*16 + i*4 - 3] = color[1];
	 		t_clr[len*16 + i*4 - 2] = color[2];
	 		t_clr[len*16 + i*4 - 1] = color[3];
	 		t_clr[len*16 + i*4 - 0] = self.m_alpha;
	 	end
	end
 	self.m_xi = math.cos(math.rad(self.m_rotation))*r/self.m_frame;
end

ParticleRadialLine.update = function(self)
    if self.m_active then  --激活
        -- 返回X，Y轴的位置
        local x = self.m_x;
        local y = self.m_y;
        self.m_tick = self.m_tick + 1;
        if self.m_tick > self.m_frame then  self.m_tick = self.m_frame;end
        
        --重新设定粒子在屏幕的位置
        x = x + self.m_xi ;
        y = y + self.m_yi ;
    	self.m_x, self.m_y = x, y; 
    	--self.m_scale = self.m_tick/self.m_frame;
    	self.m_alpha =( self.m_frame*1.5 - self.m_tick)/self.m_frame;
    	if self.m_alpha > 1.0 then self.m_alpha = 1.0;end
    	local temp=1/3.0*ParticleRadialLine.liveTime;
    	if temp<=self.m_live then self.m_alpha = (ParticleRadialLine.liveTime-self.m_live)/temp/2;
    	else self.m_alpha = self.m_live/temp;end
        -- 减少粒子的生命值
        self.m_live = self.m_live - self.m_fade;
        -- 如果粒子生命小于0
        if (self.m_live < 0.0) then 
        	self.m_active = false;
        	self.m_scale = 0;
        end
    end
end

ParticleRadialLine.dtor = function(self)
end
