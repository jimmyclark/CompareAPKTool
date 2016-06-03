--[[
	场次准入，充值推荐配置
]]

local LevelConfigData = class(require('data.dataList'))

addProperty(LevelConfigData, "time", 0)

--	根据场次level
function LevelConfigData:getPamountByLevel(level)
	if not self:getInit() then return end
	level = level or G_RoomCfg:getLevel()
	local levelData = self:getData()
	for key, val in ipairs(levelData) do
		if val:getLevel() == level then
			return val:getRecommend()
		end
	end
	local lastLevelData = levelData[#levelData]
	if lastLevelData then
		printInfo("找不到配置, 返回等级为%s配置额度", lastLevelData:getRecommend() or 0)
		return lastLevelData:getRecommend()
	end
end

-- 根据当前金币返回可进入的level
function LevelConfigData:getSuggestLevelConfigVarMoney(money)
	money 	 = money or MyUserData:getMoney()
	local levelData = self:getData()
	local config = nil
	for key, val in ipairs(levelData) do
		if money >= val:getRequire() and money <= val:getUppermost() then
			config = val
		end
	end
	return config
end

-- 根据不同的levelType 返回场次集合
function LevelConfigData:getLevelConfigByType(levelType)
	levelType = levelType or 1
	local levelData = self:getData()
	local typeTable = {}
	for k , v in ipairs(levelData) do
		if levelType == tonumber(v:getType()) then
			table.insert(typeTable, v)
		end
	end
	return typeTable
end

-- 根据某一个场次得到具体信息
function LevelConfigData:getLevelConfig(level)
	local levelData = self:getData()
	for key, val in ipairs(levelData) do
		if val:getLevel() == level then
			return val
		end
	end
end

return LevelConfigData