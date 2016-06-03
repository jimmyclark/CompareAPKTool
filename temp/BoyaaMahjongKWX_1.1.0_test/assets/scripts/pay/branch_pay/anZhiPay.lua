AnZhiPay = class(BasePay)

function AnZhiPay.getInstance()
	if not AnZhiPay.m_instance then
		AnZhiPay.m_instance = new(AnZhiPay);
	end
	return AnZhiPay.m_instance;
end	

function AnZhiPay:ctor()
	self.desc = "安智支付"
	self.pmode = UnitePmodeMap.ANZHI_PAY
	self.payType = UnitePayIdMap.ANZHI_PAY
end

-- 添加参数
function AnZhiPay:mergeExtraParam(jsonData, param_data)
	AnZhiPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("AnZhiPay.mergeExtraParam")
end

function AnZhiPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	param_data.accessToken = UserData.getToken()
    -- NativeEvent.getInstance():RequestMutiPay(param_data);
    for k,v in pairs(param_data) do
    	Log.w(k,v)
    end
    NativeEvent.getInstance():AnzhiPay(param_data);
end