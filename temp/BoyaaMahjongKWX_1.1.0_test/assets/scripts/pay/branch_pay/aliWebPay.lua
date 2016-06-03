AliWebPay = class(BasePay)

function AliWebPay.getInstance()
	if not AliWebPay.m_instance then
		AliWebPay.m_instance = new(AliWebPay);
	end
	return AliWebPay.m_instance;
end	

function AliWebPay:ctor()
	self.desc = "阿里web支付"
	self.pmode = UnitePmodeMap.ALI_WEB_PAY
	self.payType = UnitePayIdMap.ALI_WEB_PAY
end

-- 添加参数
function AliWebPay:mergeExtraParam(jsonData, param_data)
	AliWebPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.url = GetStrFromJsonTable(jsonData, "URL", "")
	printInfo("AliWebPay.mergeExtraParam")
end

function AliWebPay:startRealPay(param_data)
	AlarmTip.play("正在打开阿里web支付...");
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	NativeEvent.getInstance():StartUnitePay(param_data)
end