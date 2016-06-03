require("particle/particleBase");
--ParticleFlower --粒子类

--必有的属性：m_x,m_y,m_alpha(number);m_active(boolean)
ParticleFlower = class(ParticleBase);

ParticleFlower.liveTime = 4;	--粒子生命时长

ParticleFlower.ctor = function(self)
end

ParticleFlower.init = function(self, len, index, node)
	self.m_fade = (math.random()*100)/1000.0 +0.05;--衰减速度
	self.node = node;
	self.m_active  = true;		--是否激活状态
 	self.m_live = node.moredata.liveTime or ParticleFlower.liveTime;--粒子生命
 	local h = node.moredata.h;
    local w = node.moredata.w;
 	self.m_frame = math.ceil(self.m_live/self.m_fade);
 	local yi = 0--h/self.m_frame/20;
 	local xi = 0--w/self.m_frame/20;
	--移动速度/方向
	local pos = len/node.m_maxNum;
    if pos>1 then pos = pos-1;end
	if pos<0.25 then--left
		self.m_xi = -xi;
		self.m_yi = 0;
		self.m_x = 0;
		self.m_y = h*pos*4;
	elseif pos<0.5 then--top
		self.m_xi = 0;
		self.m_yi = -yi;
		self.m_x = w*(pos-0.25)*4;
		self.m_y = 0;
	elseif pos<0.75 then--rights
		self.m_xi = xi;
		self.m_yi = 0;
		self.m_x = w;
		self.m_y = h*(pos-0.5)*4;
	else
		self.m_xi = 0;
		self.m_yi = yi;
		self.m_x = w*(pos-0.75)*4;
		self.m_y = h;
	end

	self.m_scale = math.random();
	if self.m_scale<0.2 then self.m_scale=0.2;end
	self.m_tick = 0;

	local imgW = node.m_texW;
	local imgH = node.m_texH;
	local t_vtx = node.m_vertexArr;
	t_vtx[len*8+1],t_vtx[len*8+3],t_vtx[len*8+5],t_vtx[len*8+7] = self.m_x,self.m_x+self.m_scale*imgW,self.m_x+self.m_scale*imgW,self.m_x;
	t_vtx[len*8+2],t_vtx[len*8+4],t_vtx[len*8+6],t_vtx[len*8+8] = self.m_y,self.m_y,self.m_y+self.m_scale*imgH,self.m_y+self.m_scale*imgH;
	self.m_rotation = 0;
end

ParticleFlower.update = function(self)
	--匀速移动+旋转
    if self.m_active then  --激活
		self.m_rotation = self.m_rotation+self.node.moredata.rotation;
        -- 返回X，Y轴的位置
        self.m_tick = self.m_tick + 1;
        if self.m_tick > self.m_frame then  self.m_tick = self.m_frame;end
        
        --重新设定粒子在屏幕的位置
    	--self.m_x, self.m_y = self.m_x + self.m_xi, self.m_x + self.m_yi; --TODO
        -- 减少粒子的生命值
        self.m_live = self.m_live - self.m_fade;
        if self.m_live<0.0 then
        	self.m_active = false;
        	self.m_scale = 0;
        end
    end	
end

ParticleFlower.dtor = function(self)
end
