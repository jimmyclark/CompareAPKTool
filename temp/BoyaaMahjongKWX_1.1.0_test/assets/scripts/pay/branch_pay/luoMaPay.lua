LuoMaPay = class(BasePay)

function LuoMaPay.getInstance()
	if not LuoMaPay.m_instance then
		LuoMaPay.m_instance = new(LuoMaPay)
	end
	return LuoMaPay.m_instance
end	

function LuoMaPay:ctor()

	if PlatformConfig.simType == 1 then
		self.pmode = UnitePmodeMap.HUAFUBAO_PAY
		self.payType = UnitePayIdMap.HUAFUBAO_PAY
		self.desc = "话付宝裸码支付"
	elseif PlatformConfig.simType == 2 then
		self.pmode = UnitePmodeMap.UNICOM_LUOMA_PAY
		self.payType = UnitePayIdMap.UNICOM_LUOMA_PAY
		self.desc = "联通裸码支付"
	elseif PlatformConfig.simType == 3 then
		self.pmode = UnitePmodeMap.TELE_BARE_PAY
		self.payType = UnitePayIdMap.TELE_BARE_PAY
		self.desc = "电信裸码支付"
	end
end

-- 添加参数
function LuoMaPay:mergeExtraParam(jsonData, param_data)
	LuoMaPay.super.mergeExtraParam(self, jsonData, param_data)
	printInfo("LuoMaPay.mergeExtraParam")
	-- 移动下单从本地获取pcode
	if PlatformConfig.simType == 1 then
		param_data.collingcode = self:findPcodeByGoodPamount(param_data.pamount, true)
	elseif PlatformConfig.simType == 2 then
		param_data.collingcode = self:findPcodeByGoodPamount(param_data.pamount, true)
	elseif PlatformConfig.simType == 3 then
		param_data.goodId, param_data.sendAdress = self:findPcodeByGoodPamount(param_data.pamount, true)
	end
end

function LuoMaPay:supportPamount(pamount)
	local payCode = self:getPayCodeByPamount(pamount)
	printInfo(self.desc	.. "判断额度是否支持" .. pamount)
	if PlatformConfig.simType == 1 then
		return payCode and payCode.CONSUMECODE
	elseif PlatformConfig.simType == 2 then
		return payCode and payCode.SFCODE
	elseif PlatformConfig.simType == 3 then
		return payCode and payCode.sendAdress and payCode.goodId
	else
		return false
	end
end