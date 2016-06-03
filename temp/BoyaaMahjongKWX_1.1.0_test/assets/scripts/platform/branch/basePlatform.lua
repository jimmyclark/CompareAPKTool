-- 各种子平台的基类，子平台需继承该类，覆盖有区别的方法即可
local BasePlatform = class();
local printInfo, printError = overridePrint("BasePlatform")

function BasePlatform:ctor()
end

function BasePlatform:startSceneInit()
	StateChange.changeState(States.Lobby)
end

function BasePlatform:requestChargeList(isLogin)
	-- 注意先后 先初始化配置 再拉取商品列表
	UnitePay.getInstance():requestChargeConfig(isLogin)
	UnitePay.getInstance():requestChargeList(isLogin)
end

-- isLuoMaFirst 为是否优先选裸码  
-- 由于联运版本的存在 所以默认 [[不开启]]
-- 由主版本覆盖该方法 让isLuoMaFirst生效 
BasePlatform.selectPayWay = function(self, goodsInfo, isLuoMaFirst, sceneChargeData)
	--调用支付
	self:startNativePay(goodsInfo, false, sceneChargeData)
end

BasePlatform.startNativePay = function(self, goodsInfo, isLuoMaFirst, sceneChargeData)
	-- 如果是短信支付则 走一下查找限额的路径
	local bundleData = {
		goodsInfo 		= goodsInfo,
		sceneChargeData = sceneChargeData
	}
	-- UnitePay.getInstance():autoSelectPay(bundleData, isLuoMaFirst)
	PayController:payForGoods(true, goodsInfo, true)
end

return BasePlatform