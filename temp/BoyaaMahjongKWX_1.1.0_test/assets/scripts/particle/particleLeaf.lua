
require("particle/particleBase");

--ParticleLeaf --粒子类
ParticleLeaf = class(ParticleBase);

ParticleLeaf.liveTime = 8;    --粒子生命时长

ParticleLeaf.ctor = function(self)
end

ParticleLeaf.init = function(self, len, index, node, repeat_or_loop_num)
    if not node.moredata.repeat_or_loop_num then
        node.moredata.repeat_or_loop_num = repeat_or_loop_num;
    end
    
    self.m_fade = math.random()/100.0+0.05;--衰减速度
    self.m_active = true;--是否激活状态
    self.moredata = Copy(node.moredata);
    if self.moredata.rotation and math.random()>0.5 then
        self.moredata.rotation=-self.moredata.rotation;
    end
    self.m_live = node.moredata.liveTime or ParticleLeaf.liveTime;--粒子生命
    self.m_frame = math.ceil(self.m_live/self.m_fade);
    --移动速度
    self.m_yi = 4.5;
    self.m_xi = math.random()*1.0*(math.random()>0.5 and 1 or -1);
    -- 加速度
    self.m_xg = math.random()*0.2*(math.random()>0.5 and 1 or -1);
    self.m_yg = -math.random()*0.05;
    self.m_alpha = 1.0;
    --初始位置
    local h = node.moredata.h;
    local w = node.moredata.w;
    self.m_maxH = h*2/3;
    self.m_x = math.random(w);
    self.m_y = -math.random(h);
    self.m_scale = node.moredata.scale or 1.0;
    self.m_tick = 0;
    self.m_rotation = node.moredata.rotation;
end

ParticleLeaf.update = function(self)
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

ParticleLeaf.dtor = function(self)
end
