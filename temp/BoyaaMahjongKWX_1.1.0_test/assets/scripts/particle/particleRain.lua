
require("particle/particleBase");

--ParticleRain --粒子类
ParticleRain = class(ParticleBase);

ParticleRain.liveTime = 6;    --粒子生命时长
ParticleRain.colortable = {{1.0,0.435,0.482,0.5},{1.0,0.243,0.0,0.5},{1.0,0.702,0.0,0.5},{0.5,0.596,1.0,0.5},{0.322,1.0,0.0,0.5},{1.0,0.267,0.8510,0.5}};

ParticleRain.ctor = function(self, file)
end

ParticleRain.init = function(self, len, index, node)
    self.m_fade = math.random()/50.0 +0.05;--衰减速度
    self.m_active  = true;      --是否激活状态
    self.moredata = Copy(node.moredata);
    if self.moredata.rotation and math.random()>0.5 then
        self.moredata.rotation=-self.moredata.rotation;
    end
    self.m_live = node.moredata.liveTime or ParticleRain.liveTime;--粒子生命
    self.m_frame = math.ceil(self.m_live/self.m_fade);
    local h = node.moredata.h;
    local w = node.moredata.w;
    self.m_yi = 3.5;
    self.m_xi = math.random()*0.2*(math.random()>0.5 and 1 or -1);
    -- 加速度
    self.m_xg = math.random()*0.1*(math.random()>0.5 and 1 or -1);
    self.m_yg = -math.random()*0.02;
    self.m_alpha = 1.0;
    --移动速度/方向
    self.m_y0 = math.random(h/3)-30;
    self.m_x = math.random(w);
    self.m_y = self.m_y0;
    self.m_scale = node.moredata.scale or 1.0;
    self.m_tick = 0;
    local t_clr = node.m_colorArr;
    local color = ParticleRain.colortable[math.random(#ParticleRain.colortable)];
    if t_clr then
        for i = 1, 4 do 
            t_clr[len*16 + i*4 - 3] = color[1];
            t_clr[len*16 + i*4 - 2] = color[2];
            t_clr[len*16 + i*4 - 1] = color[3];
            t_clr[len*16 + i*4 - 0] = self.m_alpha;
        end
    end
    self.m_rotation = 0;
end

ParticleRain.update = function(self)
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
        if self.m_xi>2 then self.m_xg = -0.1;end
        if self.m_xi< -2 then self.m_xg = 0.1;end
        -- 减少粒子的生命值
        self.m_live = self.m_live - self.m_fade;
        -- 如果粒子生命小于0
        if (self.m_live < 0.0) then 
            self.m_active = false;
            self.m_scale = 0;
        end
        self.m_rotation = self.m_rotation+(self.moredata.rotation or 0);
    end
end

ParticleRain.dtor = function(self)
end
