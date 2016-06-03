YiDongJiDiPay = class(BasePay)

function YiDongJiDiPay.getInstance()
	if not YiDongJiDiPay.m_instance then
		YiDongJiDiPay.m_instance = new(YiDongJiDiPay);
	end
	return YiDongJiDiPay.m_instance;
end	

function YiDongJiDiPay:ctor()
	self.desc = "移动基地支付"
	self.pmode = UnitePmodeMap.MOBILE_PAY
	self.payType = UnitePayIdMap.MOBILE_PAY
end

-- 添加参数
function YiDongJiDiPay:mergeExtraParam(jsonData, param_data)
	YiDongJiDiPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.collingcode = GetStrFromJsonTable(jsonData, "collingcode")
	param_data.out_trade_no = GetStrFromJsonTable(jsonData, "ORDER")
	printInfo("YiDongJiDiPay.mergeExtraParam")
end

function YiDongJiDiPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
    NativeEvent.getInstance():MobilePay(param_data);
end