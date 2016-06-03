GVPay = class(BasePay)

function GVPay.getInstance()
	if not GVPay.m_instance then
		GVPay.m_instance = new(GVPay);
	end
	return GVPay.m_instance;
end	

function GVPay:ctor()
	self.desc = "OPPO支付"
	self.pmode = UnitePmodeMap.GAMEVIEW_PAY
	self.payType = UnitePayIdMap.GAMEVIEW_PAY
end

-- 添加参数
function GVPay:mergeExtraParam(jsonData, param_data)
	GVPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.coin = tonumber(GetStrFromJsonTable(jsonData, "PCHIPS", "0")) or 0;
	printInfo("GVPay.mergeExtraParam")
end

function GVPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	param_data.accessToken = UserData.getToken()
    NativeEvent.getInstance():RequestMutiPay(param_data);
end