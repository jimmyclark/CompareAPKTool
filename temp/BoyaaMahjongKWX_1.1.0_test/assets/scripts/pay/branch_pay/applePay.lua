ApplePay = class(BasePay)

function ApplePay.getInstance()
	if not ApplePay.m_instance then
		ApplePay.m_instance = new(ApplePay);
	end
	return ApplePay.m_instance;
end

function ApplePay:ctor()
	self.desc = "苹果支付"
	self.pmode = UnitePmodeMap.APPLE_PAY
	self.payType = UnitePayIdMap.APPLE_PAY
end

-- 添加参数
function ApplePay:mergeExtraParam(jsonData, param_data)
	ApplePay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.NOTIFY_URL = jsonData.NOTIFY_URL or ""
	printInfo("ApplePay.mergeExtraParam")
end

function ApplePay:startRealPay(param_data)
	AlarmTip.play("正在打开苹果支付...");
	NativeEvent.getInstance():StartUnitePay(param_data)
end
