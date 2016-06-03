
require("particle/particleBase");

--ParticleSnow --粒子类
ParticleSnow = class(ParticleBase);

ParticleSnow.liveTime = 15;    --粒子生命时长

ParticleSnow.ctor = function(self)
end

ParticleSnow.init = function(self, len, index, node)
    
    self.m_fade = math.random()/100.0+0.05;--衰减速度
    self.m_active = true;--是否激活状态
    self.moredata = Copy(node.moredata);
    if self.moredata.rotation and math.random()>0.5 then
        self.moredata.rotation=-self.moredata.rotation;
    end
    self.m_live = node.moredata.liveTime or ParticleSnow.liveTime;--粒子生命
    self.m_live = ParticleSnow.liveTime + 5*math.random()
    self.m_frame = math.ceil(self.m_live/self.m_fade);
    --移动速度
    self.m_yi = 0.2;
    self.m_xi = math.random()*0.02*(math.random()>0.5 and 1 or -1);
    self.m_xi = 0
    -- 加速度
    self.m_xg = math.random()*0.005*(math.random()>0.5 and 1 or -1);
    self.m_yg = -math.random()*0.001;
    self.m_yg = 0
    self.m_alpha = 1.0;
    --初始位置
    local h = node.moredata.h;
    local w = node.moredata.w;
    self.m_maxH = h*2/3;
    self.m_x = math.random(w);
    self.m_y = -math.random(h);
    self.m_scale = node.moredata.scale or 1.0;
    self.m_scale = (math.random(70)+30)/100.0*System.getLayoutScale();
    self.m_tick = 0;
    self.m_rotation = math.random(3.14);
end

ParticleSnow.update = function(self)
    if self.m_active then
        self.m_tick = self.m_tick + 1;
        if self.m_tick>self.m_frame then self.m_tick = self.m_frame;end
        self.m_alpha = 1.2-self.m_tick/self.m_frame;
        
        --重新设定粒子在屏幕的位置
        self.m_x = self.m_x + self.m_xi; 
        self.m_y = self.m_y + self.m_yi; 
        -- 更新X,Y轴方向速度大小
        self.m_xi = self.m_xi + self.m_xg;
        self.m_yi = self.m_yi + self.m_yg;
        if self.m_xi>5 then self.m_xg = -0.3;end
        if self.m_xi< -5 then self.m_xg = 0.3;end
        if self.m_yi<2.2 then self.m_yi=2.2;end
        -- 减少粒子的生命值
        self.m_live = self.m_live - self.m_fade;
        -- 如果粒子生命小于0
        if (self.m_live < 0.0) then -- or self.m_y>self.m_maxH
            self.m_active = false;
            self.m_scale = 0;
        end
        self.m_rotation = self.m_rotation+(self.moredata.rotation or 0);
    end
end

ParticleSnow.dtor = function(self)
end
