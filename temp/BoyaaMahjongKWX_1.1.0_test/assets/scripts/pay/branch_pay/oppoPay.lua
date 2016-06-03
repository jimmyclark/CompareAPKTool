OppoPay = class(BasePay)

function OppoPay.getInstance()
	if not OppoPay.m_instance then
		OppoPay.m_instance = new(OppoPay);
	end
	return OppoPay.m_instance;
end	

function OppoPay:ctor()
	self.desc = "OPPO支付"
	self.pmode = UnitePmodeMap.OPPO_PAY
	self.payType = UnitePayIdMap.OPPO_PAY
end

-- 添加参数
function OppoPay:mergeExtraParam(jsonData, param_data)
	OppoPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("OppoPay.mergeExtraParam")
end

function OppoPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	param_data.accessToken = UserData.getToken()
    NativeEvent.getInstance():RequestMutiPay(param_data);
end