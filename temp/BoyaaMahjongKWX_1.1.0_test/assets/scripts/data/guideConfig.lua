--[[
	新手教程
]]
local GuideConfig = class()

addProperty(GuideConfig, "isFinish", 1)

addProperty(GuideConfig, "firstEnterGbmj", 0)	  -- 国标第一次进房间
addProperty(GuideConfig, "firstEnterGdmjTdh", 0)	  -- 广东第一次进房间  推倒胡
addProperty(GuideConfig, "firstEnterGdmjJph", 0)	  -- 广东第一次进房间  鸡平胡
addProperty(GuideConfig, "firstEnterShmj", 0)	  -- 上海第一次进房间

addProperty(GuideConfig, "firstChi", 0)           -- 通用第一次吃
addProperty(GuideConfig, "firstPeng", 0)		  -- 通用第一次碰
addProperty(GuideConfig, "firstGang", 0)		  -- 通用第一次碰
addProperty(GuideConfig, "firstHu", 0)			  -- 通用第一次胡

addProperty(GuideConfig, "firstMingGangGdmj", 0)  -- 广东麻将第一次明杠
addProperty(GuideConfig, "firstAnGangGdmj", 0)	  -- 广东麻将第一次暗杠
addProperty(GuideConfig, "firstChengBaoShmj", 0)  -- 上海麻将第一次承包

function GuideConfig:load(userId)
	self.dictName = "GuideConfig" .. (userId or MyUserData:getId())
	self.m_set = new(Dict, self.dictName)
	self.m_set:load()

	self:setIsFinish(self.m_set:getInt("isFinish", 0))
	
	self:setFirstEnterGbmj(self.m_set:getInt("firstEnterGbmj", 0))
	self:setFirstEnterGdmjTdh(self.m_set:getInt("firstEnterGdmjTdh", 0))
	self:setFirstEnterGdmjJph(self.m_set:getInt("firstEnterGdmjJph", 0))
	self:setFirstEnterShmj(self.m_set:getInt("firstEnterShmj", 0))

	self:setFirstChi(self.m_set:getInt("firstChi", 0))
	self:setFirstPeng(self.m_set:getInt("firstPeng", 0))
	self:setFirstGang(self.m_set:getInt("firstGang", 0))
	self:setFirstHu(self.m_set:getInt("firstHu", 0))

	self:setFirstMingGangGdmj(self.m_set:getInt("firstMingGangGdmj", 0))
	self:setFirstAnGangGdmj(self.m_set:getInt("firstAnGangGdmj", 0))
	self:setFirstChengBaoShmj(self.m_set:getInt("firstChengBaoShmj", 0))
end

function GuideConfig:save()
	self.m_set = new(Dict, self.dictName)
	
	self.m_set:setInt("isFinish", 		self:getIsFinish())
	self.m_set:setInt("firstEnterGbmj", self:getFirstEnterGbmj())
	self.m_set:setInt("firstEnterGdmjTdh", self:getFirstEnterGdmjTdh())
	self.m_set:setInt("firstEnterGdmjJph", self:getFirstEnterGdmjJph())
	self.m_set:setInt("firstEnterShmj", self:getFirstEnterShmj())
	
	self.m_set:setInt("firstChi", 		self:getFirstChi())
	self.m_set:setInt("firstPeng", 		self:getFirstPeng())
	self.m_set:setInt("firstGang", 		self:getFirstGang())
	self.m_set:setInt("firstHu", 		self:getFirstHu())

	self.m_set:setInt("firstMingGangGdmj", 	self:getFirstMingGangGdmj())
	self.m_set:setInt("firstAnGangGdmj", 	self:getFirstAnGangGdmj())
	self.m_set:setInt("firstChengBaoShmj", 	self:getFirstChengBaoShmj())

	self.m_set:save()
end

return GuideConfig