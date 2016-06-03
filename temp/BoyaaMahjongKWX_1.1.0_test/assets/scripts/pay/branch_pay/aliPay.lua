AliPay = class(BasePay)

function AliPay.getInstance()
	if not AliPay.m_instance then
		AliPay.m_instance = new(AliPay);
	end
	return AliPay.m_instance;
end	

function AliPay:ctor()
	self.desc = "支付宝支付"
	self.pmode = UnitePmodeMap.ALI_JIJIAN_PAY
	self.payType = UnitePayIdMap.ALI_JIJIAN_PAY
end

-- 添加参数
function AliPay:mergeExtraParam(jsonData, param_data)
	AliPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.notify_url = jsonData.NOTIFY_URL or ""
	printInfo("AliPay.mergeExtraParam")
end

function AliPay:startRealPay(param_data)
	AlarmTip.play("正在打开支付宝支付...");
	printInfo("正在打开支付宝支付...")
	NativeEvent.getInstance():StartUnitePay(param_data)
end