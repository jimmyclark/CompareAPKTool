local GameConfig = class()

addProperty(GameConfig, "lastType", 0)
addProperty(GameConfig, "lastSuffix", "")
addProperty(GameConfig, "lastUserType", UserType.Visitor)
addProperty(GameConfig, "lastLoginData", nil)
addProperty(GameConfig, "isFristGame", 0)

function GameConfig:load()
	self.m_set = new(Dict, "gameConfig")
	self.m_set:load()
	local lastType = self.m_set:getInt("lastType")
	local lastSuffix = self.m_set:getString("lastSuffix")
	local lastUserType = self.m_set:getInt("lastUserType", UserType.Visitor)
	local isFristGame = self.m_set:getInt("isFristGame")
	-- 默认国标麻将
	self:setLastType(lastType or 0)
	self:setLastSuffix(lastSuffix or "")
	self:setLastUserType(lastUserType or UserType.Visitor)
	self:setIsFristGame(isFristGame)
end

function GameConfig:save()
	self.m_set = new(Dict, "gameConfig")
	
	self.m_set:setInt("lastType", self:getLastType())
	self.m_set:setString("lastSuffix", self:getLastSuffix())
	self.m_set:setInt("lastUserType", self:getLastUserType())
	self.m_set:setInt("isFristGame", self:getIsFristGame())
	self.m_set:save()
end

return GameConfig