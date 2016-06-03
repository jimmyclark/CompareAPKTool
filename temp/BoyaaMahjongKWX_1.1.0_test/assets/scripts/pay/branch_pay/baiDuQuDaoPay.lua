BaiDuQuDaoPay = class(BasePay)

function BaiDuQuDaoPay.getInstance()
	if not BaiDuQuDaoPay.m_instance then
		BaiDuQuDaoPay.m_instance = new(BaiDuQuDaoPay);
	end
	return BaiDuQuDaoPay.m_instance;
end	

function BaiDuQuDaoPay:ctor()
	self.desc = "百度渠道支付"
	self.pmode = UnitePmodeMap.BAIDUQUDAO_PAY
	self.payType = UnitePayIdMap.BAIDUQUDAO_PAY
end

-- 添加参数
function BaiDuQuDaoPay:mergeExtraParam(jsonData, param_data)
	BaiDuQuDaoPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.notify_url = jsonData.NOTIFY_URL or ""
	printInfo("BaiDuQuDaoPay.mergeExtraParam")
end

function BaiDuQuDaoPay:startRealPay(param_data)
	AlarmTip.play("正在打开支付...");
	printInfo("正在打开支付...")
	NativeEvent.getInstance():StartUnitePay(param_data)
end