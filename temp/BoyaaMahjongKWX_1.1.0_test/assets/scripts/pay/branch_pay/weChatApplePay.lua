-- 微信支付
WeChatApplePay = class(BasePay)

function WeChatApplePay.getInstance()
	if not WeChatApplePay.m_instance then
		WeChatApplePay.m_instance = new(WeChatApplePay);
	end
	return WeChatApplePay.m_instance;
end

function WeChatApplePay:ctor()
	self.desc 		= "苹果微信支付"
	self.pmode 		= UnitePmodeMap.WECHAT_APPLE_PAY
	self.payType 	= UnitePayIdMap.WECHAT_APPLE_PAY
end

-- 添加参数
function WeChatApplePay:mergeExtraParam(jsonData, param_data)
	WeChatApplePay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("WeChatApplePay.mergeExtraParam")
	param_data.appId 		= jsonData.appid;
	param_data.partnerId 	= jsonData.partnerid;
	param_data.nonceStr 	= jsonData.noncestr;
	param_data.package 		= jsonData.package;
	param_data.prepayId 	= jsonData.prepayid;
	param_data.sign 		= jsonData.sign;
	param_data.timeStamp 	= jsonData.timestamp;
end

function WeChatApplePay:startRealPay(param_data)
	AlarmTip.play("正在打开微信支付...");
	NativeEvent.getInstance():StartUnitePay(param_data)
end
