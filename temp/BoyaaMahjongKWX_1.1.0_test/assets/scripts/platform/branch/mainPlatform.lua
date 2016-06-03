local BasePlatform = require("platform.branch.basePlatform")
-- 主版本

local MainPlatform = class(BasePlatform);
local printInfo, printError = overridePrint("MainPlatform")

return MainPlatform