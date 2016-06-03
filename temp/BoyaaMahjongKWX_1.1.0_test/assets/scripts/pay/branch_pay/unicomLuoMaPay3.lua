UnicomLuoMaPay3 = class(BasePay)

function UnicomLuoMaPay3.getInstance()
	if not UnicomLuoMaPay3.m_instance then
		UnicomLuoMaPay3.m_instance = new(UnicomLuoMaPay3)
	end
	return UnicomLuoMaPay3.m_instance
end	

function UnicomLuoMaPay3:ctor()

	self.pmode = UnitePmodeMap.UNICOM_LUOMA_PAY3
	self.payType = UnitePayIdMap.UNICOM_LUOMA_PAY3
	self.desc = "联通裸码支付（3）";
end


-- 添加参数
function UnicomLuoMaPay3:mergeExtraParam(jsonData, param_data)
	LuoMaPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.collingcode = self:findPcodeByGoodPamount(param_data.pamount, true)
end

function UnicomLuoMaPay3:supportPamount(pamount)
	printInfo(self.desc	.. "判断额度是否支持" .. pamount)
	local payCode = self:getPayCodeByPamount(pamount)
	if PlatformConfig.simType == 2 then
		return payCode and payCode.SFCODE3
	else
		return false
	end
end