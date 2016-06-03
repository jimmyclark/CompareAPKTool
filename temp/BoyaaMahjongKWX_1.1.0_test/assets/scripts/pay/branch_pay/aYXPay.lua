AYXPay = class(BasePay)

function AYXPay.getInstance()
	if not AYXPay.m_instance then
		AYXPay.m_instance = new(AYXPay);
	end
	return AYXPay.m_instance;
end	

function AYXPay:ctor()
	self.desc = "爱游戏支付"
	self.pmode = UnitePmodeMap.AYX_PAY
	self.payType = UnitePayIdMap.AYX_PAY
end

-- 添加参数
function AYXPay:mergeExtraParam(jsonData, param_data)
	AYXPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("AYXPay.mergeExtraParam")
end

function AYXPay:supportPamount(pamount)
	-- printInfo(self.desc	.. "判断额度是否支持" .. pamount .. PlatformConfig.mobileChargeKey)
	if PlatformConfig.simType == 3 then
		local payCode = self:getPayCodeByPamount(pamount)
		return payCode and payCode.AYX --跟电信天翼一样的额度支持
	end
end

function AYXPay:startRealPay(param_data)
	NativeEvent.getInstance():StartUnitePay(param_data)
end