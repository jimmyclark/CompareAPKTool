HuaWeiPay = class(BasePay)

function HuaWeiPay.getInstance()
	if not HuaWeiPay.m_instance then
		HuaWeiPay.m_instance = new(HuaWeiPay);
	end
	return HuaWeiPay.m_instance;
end	

function HuaWeiPay:ctor()
	self.desc = "华为支付"
	self.pmode = UnitePmodeMap.HUAWEI_PAY
	self.payType = UnitePayIdMap.HUAWEI_PAY
end

-- 添加参数
function HuaWeiPay:mergeExtraParam(jsonData, param_data)
	HuaWeiPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("HuaWeiPay.mergeExtraParam")
end

function HuaWeiPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	param_data.accessToken = UserData.getToken()
    NativeEvent.getInstance():RequestMutiPay(param_data);
end