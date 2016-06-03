require("config")
require("utils.init")
require("core.init")
require("ui.init")
require("common.init")
require("gameBase.init")
require("pay.unitePay")
require("animation.init")
local printInfo, printError = overridePrint("main")

local systemTonumber = tonumber
function tonumber(value, base)
	local ret = nil
	base = base or 10
	local valueType = type(value)
	local pre = nil
	if valueType == "number" then return value end
	if valueType == "string" then
		local valueLen = string.len(value)
		for i = 1, valueLen do
			local t = string.sub(value, i, i)
			t = systemTonumber(t , base)
			if not t then return end
			if not ret then ret = 0 end
			ret = ret * base + t
		end
	end
	return ret
end

function event_load ( width, height )
  	math.randomseed(tostring(os.time()):reverse():sub(1, 6))

	System.setEventResumeEnable(true);
	System.setEventPauseEnable(true);
    -- System.setWin32ConsoleColor(10);
    System.setAndroidLogEnable(true);
    -- System.setClearBackgroundEnable(true);
    
    UIConfig.setScrollViewScrollBarWidth(0);
    local filterPickCallback = function(imagePath , fileName)
		return kFilterLinear;
	end
	System.setImageFilterPicker(filterPickCallback); --线性变换
	ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")

	GameString.load("string", "zh");
	new(require("app")):run()
end
