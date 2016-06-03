-- 银联支付

UnionPay = class(BasePay)

function UnionPay.getInstance()
	if not UnionPay.m_instance then
		UnionPay.m_instance = new(UnionPay);
	end
	return UnionPay.m_instance;
end	

function UnionPay:ctor()
	self.desc = "银联支付"
	self.pmode = UnitePmodeMap.UNION_PAY
	self.payType = UnitePayIdMap.UNION_PAY
end

-- 添加参数
function UnionPay:mergeExtraParam(jsonData, param_data)
	UnionPay.super.mergeExtraParam(self, jsonData, param_data)

	param_data.respCode = jsonData.respCode;
	param_data.tn = jsonData.tn;
	param_data.signMethod = jsonData.signMethod;
	param_data.transType = jsonData.transType;
	param_data.charset = jsonData.charset;
	param_data.signature = jsonData.signature;
	param_data.version = jsonData.version;

end
function UnionPay:startRealPay(param_data)
	AlarmTip.play("正在打开银联支付...");
	NativeEvent.getInstance():StartUnitePay(param_data)
end

