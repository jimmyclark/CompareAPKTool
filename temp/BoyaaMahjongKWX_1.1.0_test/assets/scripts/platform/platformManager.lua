require("platform/platformConfig")
local PlatformFactory = require("platform/platformFactory")
local PlatformManager = class();
local printInfo, printError = overridePrint("PlatformManager")

PlatformManager.s_cmds = {
	StartSceneInit 		= 1,
	RequestChargeList 	= 2,
	SelectPayWay 		= 3,
}

function PlatformManager:ctor()
	self.m_platformRef = PlatformFactory.initPlatform(PlatformConfig.currPlatform);
end

function PlatformManager:executeAdapter(configId, ...)
	if not configId then return end
	printInfo("executeAdapter command = %d", configId)
	local configFunc = PlatformManager.s_cmdConfig[configId];
	if configFunc and self.m_platformRef then
		return configFunc(self, ...);
	end
	return false;
end

-- 初始界面适配
PlatformManager.startSceneInit = function(self)
	self.m_platformRef:startSceneInit();
end

PlatformManager.requestChargeList = function(self, isLogin)
	self.m_platformRef:requestChargeList(isLogin);
end

PlatformManager.selectPayWay = function(self, goodsInfo, isLuoMaFirst, sceneChargeData)
	--相应平台下的支付方式
	self.m_platformRef:selectPayWay(goodsInfo, isLuoMaFirst, sceneChargeData)
end

PlatformManager.s_cmdConfig = {
	[PlatformManager.s_cmds.StartSceneInit] = PlatformManager.startSceneInit,
	[PlatformManager.s_cmds.RequestChargeList] = PlatformManager.requestChargeList,
	[PlatformManager.s_cmds.SelectPayWay] = PlatformManager.selectPayWay,
}



return PlatformManager