require("particle/particleBase");

--ParticleFireWork --粒子类
--爆炸喷发
ParticleFireWork = class(ParticleBase);

ParticleFireWork.liveTime = 4;	--粒子生命时长
ParticleFireWork.colortable = {{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,1.0,1.0},{1.0,1.0,0.0,1.0},};

ParticleFireWork.ctor = function(self, file)
end

ParticleFireWork.init = function(self, len, index, node)
	self.m_fade = (math.random()*100)/1000.0 +0.05;--衰减速度
	self.m_active  = true;		--是否激活状态
 	self.m_live = node.moredata.liveTime or ParticleFireWork.liveTime;--粒子生命
 	local h = node.moredata.h;
    local w = node.moredata.w;
 	self.m_frame = math.ceil(self.m_live/self.m_fade);
 	self.m_yi = math.random(h)/self.m_frame;
	if math.random(10) > 5 then self.m_yi = -self.m_yi;end 
	--移动速度/方向
	self.m_y0 = node.m_y0;
	self.m_x = node.m_x0;
	self.m_y = self.m_y0;
	self.m_scale = 0;
	self.m_tick = 0;
	local imgW = node.m_texW;
	local imgH = node.m_texH;
	local t_vtx = node.m_vertexArr;
	t_vtx[len*8+1],t_vtx[len*8+3],t_vtx[len*8+5],t_vtx[len*8+7] = self.m_x,self.m_x+self.m_scale*imgW,self.m_x+self.m_scale*imgW,self.m_x;
	t_vtx[len*8+2],t_vtx[len*8+4],t_vtx[len*8+6],t_vtx[len*8+8] = self.m_y,self.m_y,self.m_y+self.m_scale*imgH,self.m_y+self.m_scale*imgH;
 	self.m_xi = math.random(w)/self.m_frame;
	if math.random(10) > 5 then self.m_xi = -self.m_xi;end 
end

ParticleFireWork.update = function(self)
    if self.m_active then  --激活
        self.m_tick = self.m_tick + 1;
        if self.m_tick > self.m_frame then self.m_tick = self.m_frame;end
        
        --重新设定粒子在屏幕的位置
    	self.m_x = self.m_x + self.m_xi;
    	self.m_y = self.m_y + self.m_yi; 
    	self.m_scale = self.m_tick/self.m_frame;
    	self.m_alpha = (self.m_frame*1.5 - self.m_tick)/self.m_frame;
    	if self.m_alpha > 1.0 then self.m_alpha = 1.0;end
     
        -- 减少粒子的生命值
        self.m_live = self.m_live - self.m_fade;

        -- 如果粒子生命小于0
        if self.m_live < 0.0 then
        	self.m_active = false;
        	self.m_scale = 0;
        end
    end
end

ParticleFireWork.dtor = function(self)
end
