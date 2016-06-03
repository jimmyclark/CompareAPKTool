-- 微信支付
WeChatPay = class(BasePay)

function WeChatPay.getInstance()
	if not WeChatPay.m_instance then
		WeChatPay.m_instance = new(WeChatPay);
	end
	return WeChatPay.m_instance;
end	

function WeChatPay:ctor()
	self.desc 		= "微信支付"
	self.pmode 		= UnitePmodeMap.WECHAT_PAY
	self.payType 	= UnitePayIdMap.WECHAT_PAY
end

-- 添加参数
function WeChatPay:mergeExtraParam(jsonData, param_data)
	WeChatPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("WeChatPay.mergeExtraParam")
	param_data.appId 		= jsonData.appid;
	param_data.partnerId 	= jsonData.partnerid;
	param_data.nonceStr 	= jsonData.noncestr;
	param_data.package 		= jsonData.package;
	param_data.prepayId 	= jsonData.prepayid;
	param_data.sign 		= jsonData.sign;
	param_data.timeStamp 	= jsonData.timestamp;
end

function WeChatPay:startRealPay(param_data)
	AlarmTip.play("正在打开微信支付...");
	NativeEvent.getInstance():StartUnitePay(param_data)
end