UnicomLuoMaPay2 = class(BasePay)

function UnicomLuoMaPay2.getInstance()
	if not UnicomLuoMaPay2.m_instance then
		UnicomLuoMaPay2.m_instance = new(UnicomLuoMaPay2)
	end
	return UnicomLuoMaPay2.m_instance
end	

function UnicomLuoMaPay2:ctor()

	self.pmode = UnitePmodeMap.UNICOM_LUOMA_PAY2
	self.payType = UnitePayIdMap.UNICOM_LUOMA_PAY2
	self.desc = "联通裸码支付（2）";
end


-- 添加参数
function UnicomLuoMaPay2:mergeExtraParam(jsonData, param_data)
	LuoMaPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.collingcode = self:findPcodeByGoodPamount(param_data.pamount, true)
end

function UnicomLuoMaPay2:supportPamount(pamount)
	printInfo(self.desc	.. "判断额度是否支持" .. pamount)
	local payCode = self:getPayCodeByPamount(pamount)
	if PlatformConfig.simType == 2 then
		return payCode and payCode.SFCODE2
	else
		return false
	end
end