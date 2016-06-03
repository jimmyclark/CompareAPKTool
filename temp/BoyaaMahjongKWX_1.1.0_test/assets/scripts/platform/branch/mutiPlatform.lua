-- 多平台基类
--[[
	需要添加中间界面的
]]
local BasePlatform = require("platform.branch.basePlatform")
local MutiPlatform = class(BasePlatform);
local printInfo, printError = overridePrint("MutiPlatform")

function MutiPlatform:startSceneInit()
	-- StateChange.changeState(States.Lobby);
	-- xx
end

return MutiPlatform