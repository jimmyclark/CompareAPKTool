require("particle/particleBase");

--ParticleBubble --粒子类
--冒气泡
ParticleBubble = class(ParticleBase);

ParticleBubble.liveTime = 8;	--粒子生命时长
ParticleBubble.colortable = {{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},
								{1.0,1.0,1.0,1.0},{1.0,1.0,0.0,1.0},};
ParticleBubble.ctor = function(self)
end

ParticleBubble.init = function(self, len, index, node)
	self.m_fade = (math.random()*100)/1000.0 +0.05;--衰减速度
	self.m_active  = true;		--是否激活状态
 	self.m_live = node.moredata.liveTime or ParticleBubble.liveTime;--粒子生命
 	local h = node.moredata.h;
    local w = node.moredata.w;
 	self.m_frame = math.ceil(self.m_live/self.m_fade);
 	self.m_yi = -h/2/self.m_frame;
	self.m_alpha = 1.0;
	--移动速度/方向
	self.m_y0 = h*3/4+math.random(h*1/4);
	self.m_x = math.random(w);
	self.m_y = self.m_y0;
	self.m_scale = node.moredata.scale or 1.0;
    if node.moredata.scaleFlag then 
        self.m_scaleFlag = math.random()/2+0.5;
        self.m_scale = self.m_scaleFlag;
    end
	self.m_tick = 0;
	local imgW = node.m_texW;
	local imgH = node.m_texH;
	local t_vtx = node.m_vertexArr;
	t_vtx[len*8+1],t_vtx[len*8+3],t_vtx[len*8+5],t_vtx[len*8+7] = self.m_x,self.m_x+self.m_scale*imgW,self.m_x+self.m_scale*imgW,self.m_x;
	t_vtx[len*8+2],t_vtx[len*8+4],t_vtx[len*8+6],t_vtx[len*8+8] = self.m_y,self.m_y,self.m_y+self.m_scale*imgH,self.m_y+self.m_scale*imgH;
 	self.m_xi = 0;
end

ParticleBubble.update = function(self)
    if self.m_active then  --激活
        self.m_tick = self.m_tick + 1;
        if self.m_tick > self.m_frame then  self.m_tick = self.m_frame;end
        if self.m_scaleFlag then
            self.m_scale = self.m_scaleFlag*(1-self.m_tick/self.m_frame);
        end
        --重新设定粒子在屏幕的位置
    	self.m_x = self.m_x + self.m_xi;
    	self.m_y = self.m_y + self.m_yi; 
    	
    	self.m_alpha = (self.m_frame*1.5 - self.m_tick)/self.m_frame;
    	if self.m_alpha > 1.0 then self.m_alpha = 1.0;end
     
        -- 减少粒子的生命值
        self.m_live = self.m_live - self.m_fade;

        -- 如果粒子生命小于0
        if (self.m_live < 0.0) then 
        	self.m_active = false;
        	self.m_scale = 0;
        end
    end
end

ParticleBubble.dtor = function(self)
end
