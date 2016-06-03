local LevelConfig = class()

addProperty(LevelConfig, "type", 0)
addProperty(LevelConfig, "level", 0)
addProperty(LevelConfig, "index", 0)
addProperty(LevelConfig, "recommend", 0)
addProperty(LevelConfig, "require", 0)
addProperty(LevelConfig, "value", 0)
addProperty(LevelConfig, "xzrequire", 0)
addProperty(LevelConfig, "piaoTab",{})
-- addProperty(LevelConfig, "uppermost", 0)

function LevelConfig:setUppermost(value)
	value = value or -1
	if value < 0 then
		value = 20000000000
	end
	self["uppermost"] = value
	return self
end

function LevelConfig:getUppermost()
	return self["uppermost"] or 0
end

return LevelConfig