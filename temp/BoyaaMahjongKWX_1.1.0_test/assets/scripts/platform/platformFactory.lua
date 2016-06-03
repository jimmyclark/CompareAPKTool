local PlatformFactory = {};
local PATH = "platform.branch."
-- [[新平台需在此处配置]]
PlatformFactory.initPlatform = function(platType)
	if platType == PlatformConfig.basePlatform then
		PlatformConfig.currPlatformName = "主版本";
		return new(require(PATH .. "mainPlatform"));
	end
end

return PlatformFactory