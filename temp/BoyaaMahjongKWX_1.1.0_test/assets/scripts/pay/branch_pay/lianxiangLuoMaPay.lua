LianxiangLuoMaPay = class(BasePay)

function LianxiangLuoMaPay.getInstance()
	if not LianxiangLuoMaPay.m_instance then
		LianxiangLuoMaPay.m_instance = new(LianxiangLuoMaPay);
	end
	return LianxiangLuoMaPay.m_instance;
end	

function LianxiangLuoMaPay:ctor()
	self.desc = "联想易迅SDK支付"
	self.pmode = UnitePmodeMap.LIANXIANGLUOMA_PAY
	self.payType = UnitePayIdMap.LIANXIANGLUOMA_PAY
end

function LianxiangLuoMaPay:supportPamount(pamount)
	local flag = LianxiangLuoMaPay.CHARGE_POINT[pamount] and true or false
	printInfo("联想易迅SDK支付 是否支持该金额 : ".. pamount .. " || " .. tostring(flag))
	return flag
end

-- 添加参数
function LianxiangLuoMaPay:mergeExtraParam(jsonData, param_data)
	LianxiangLuoMaPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("LianxiangLuoMaPay.mergeExtraParam")
	param_data.payPoint = LianxiangLuoMaPay.CHARGE_POINT[param_data.pamount];
	local userBusiness = UserData.getUserBusiness();
	local firstPayData = userBusiness:getFirstPayData();
	local sceneChargeData = getChargeSceneData();  -- 充值场景
	-- 判断是否首冲，且不在商城
	if firstPayData.isopen == 1 and firstPayData.pstatus ~= 3 and sceneChargeData.flow ~= 1 and param_data.pamount == 6 then
		param_data.isFirstPay = 1;
	else
		param_data.isFirstPay = 0;
	end
end

function LianxiangLuoMaPay:startRealPay(param_data)
	Log.w("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	param_data.accessToken = UserData.getToken()
    NativeEvent.getInstance():LianxiangLuoMaPay(param_data);
end

-- 计费点信息
LianxiangLuoMaPay.CHARGE_POINT = {
	-- [金额] = 计费点
	[2] = 1;
	[6] = 2;
	[10] = 3;
	[15] = 4;
}