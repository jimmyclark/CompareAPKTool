JidiLuoMaPay = class(BasePay)

function JidiLuoMaPay.getInstance()
	if not JidiLuoMaPay.m_instance then
		JidiLuoMaPay.m_instance = new(JidiLuoMaPay)
	end
	return JidiLuoMaPay.m_instance
end	

function JidiLuoMaPay:ctor()

	if PlatformConfig.simType == 1 then
		self.pmode = UnitePmodeMap.JIDI_LUOMA_PAY
		self.payType = UnitePayIdMap.JIDI_LUOMA_PAY
		self.desc = "移动基地裸码支付"
	end
end


-- 添加参数
function JidiLuoMaPay:mergeExtraParam(jsonData, param_data)
	LuoMaPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.content = self:findPcodeByGoodPamount(param_data.pamount, true)
	if param_data.content then
		-- 拼凑订单号 注意空格
		param_data.content = param_data.content .. " 0 " .. string.sub(param_data.orderId, -12, -1);	--订单号只取后12位
	end
end

function JidiLuoMaPay:supportPamount(pamount)
	printInfo(self.desc	.. "判断额度是否支持" .. pamount)
	local payCode = self:getPayCodeByPamount(pamount)
	if PlatformConfig.simType == 1 then
		return payCode and payCode.JIDICODE
	else
		return false
	end
end