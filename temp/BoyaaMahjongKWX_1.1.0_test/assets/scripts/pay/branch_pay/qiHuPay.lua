QiHuPay = class(BasePay)

function QiHuPay.getInstance()
	if not QiHuPay.m_instance then
		QiHuPay.m_instance = new(QiHuPay);
	end
	return QiHuPay.m_instance;
end	

function QiHuPay:ctor()
	self.desc = "QiHu360支付"
	self.pmode = UnitePmodeMap.QIHOO_PAY
	self.payType = UnitePayIdMap.QIHOO_PAY
end

-- 添加参数
function QiHuPay:mergeExtraParam(jsonData, param_data)
	QiHuPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("QiHuPay.mergeExtraParam")
end

function QiHuPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)

    ToastShade.getInstance():play();
	chargeInfo360 = {};
	chargeInfo360 = param_data;
	for k,v in pairs(chargeInfo360) do
		Log.w(k,v)
	end
	local paramData = {};
	HttpModule.s_config[HttpModule.s_cmds.refresh360Token][1] = "https://openapi.360.cn/oauth2/access_token?grant_type=refresh_token&refresh_token="
				..kQiHu360RefreshToken.."&client_id="..kQiHu360Appkey.."&client_secret="..kQiHu360Appsecret or "".."&scope=basic";
	HttpModule.getInstance():execute(HttpModule.s_cmds.refresh360Token, paramData, false);
end