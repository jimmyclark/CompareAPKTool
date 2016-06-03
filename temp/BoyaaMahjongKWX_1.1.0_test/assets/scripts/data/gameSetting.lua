local GameSetting = class()

addProperty(GameSetting, "isSecondScene", false)
addProperty(GameSetting, "disableReconn", false)
addProperty(GameSetting, "updateTime", 0)
addProperty(GameSetting, "soundVolume", 0.5)
addProperty(GameSetting, "musicVolume", 0.5)
addProperty(GameSetting, "soundType", SoundType.Common)
addProperty(GameSetting, "gbSoundType", SoundType.Common)
addProperty(GameSetting, "gdSoundType", SoundType.Common)
addProperty(GameSetting, "shSoundType", SoundType.Common)
addProperty(GameSetting, "hbSoundType", SoundType.Common)

function GameSetting:load()
	self.m_set = new(Dict, "gameSetting")
	self.m_set:load()

	self:setUpdateTime(self.m_set:getInt("updateTime", 0))
	self:setSoundVolume(self.m_set:getDouble("soundVolume", 0.5))
	self:setMusicVolume(self.m_set:getDouble("musicVolume", 0.5))

	local soundType = self.m_set:getInt("soundType", SoundType.Common)
	local gdSoundType = self.m_set:getInt("gdSoundType", SoundType.Common)
	local gbSoundType = self.m_set:getInt("gbSoundType", SoundType.Common)
	if PhpManager:getGdmjCanUse() ~= 1 then
		-- 如果广东声音未下载 则广东和国标全部置为普通话
		gdSoundType = SoundType.Common
		gbSoundType = SoundType.Common
		if soundType == SoundType.KWXMJ then
			soundType = SoundType.Common
		end
	end

	local shSoundType = self.m_set:getInt("shSoundType", SoundType.Common)
	if PhpManager:getShmjCanUse() ~= 1 then
		shSoundType = SoundType.Common
		if soundType == SoundType.SHMJ then
			soundType = SoundType.Common
		end
	end
	self:setSoundType(soundType)
	self:setGbSoundType(gbSoundType)
	self:setGdSoundType(gdSoundType)
	self:setShSoundType(shSoundType)
	self:setHbSoundType(SoundType.Common)
end

function GameSetting:save()
	self.m_set = new(Dict, "gameSetting")
	self.m_set:load()

	self.m_set:setInt("updateTime", self:getUpdateTime() or 0)
	self.m_set:setDouble("soundVolume", self:getSoundVolume() or 0.5)
	self.m_set:setDouble("musicVolume", self:getMusicVolume() or 0.5)
	self.m_set:setInt("soundType", self:getSoundType() or SoundType.Common)
	self.m_set:setInt("gbSoundType", self:getGbSoundType() or SoundType.Common)
	self.m_set:setInt("gdSoundType", self:getGdSoundType() or SoundType.Common)
	self.m_set:setInt("shSoundType", self:getShSoundType() or SoundType.Common)
	self.m_set:setInt("hbSoundType", self:getHbSoundType() or SoundType.Common)
	self.m_set:save()
end

return GameSetting