YueduJiDiLuoMa = class(BasePay)

function YueduJiDiLuoMa.getInstance()
	if not YueduJiDiLuoMa.m_instance then
		YueduJiDiLuoMa.m_instance = new(YueduJiDiLuoMa)
	end
	return YueduJiDiLuoMa.m_instance
end	

function YueduJiDiLuoMa:ctor()

	self.pmode   = UnitePmodeMap.YUEDUJIDI_LUOMA_PAY;
	self.payType = UnitePayIdMap.YUEDUJIDI_LUOMA_PAY;
	self.desc = "移动阅读支付";
end


-- 添加参数
function YueduJiDiLuoMa:mergeExtraParam(jsonData, param_data)
	LuoMaPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.MO_CODE=GetStrFromJsonTable(jsonData, "MO_CODE", "");  -- 发送短信内容
end

function YueduJiDiLuoMa:supportPamount(pamount)
	Log.d(self.desc	.. "判断额度是否支持" .. pamount)
	local payCode = self:getPayCodeByPamount(pamount)
	if PlatformConfig.simType == 1 then
		return payCode and payCode.YUEDUCODE
	else
		return false
	end
end

function YueduJiDiLuoMa:createOrderReal(bundleData)
	Log.w(self.desc .. ":开始创建订单2")
	AlarmNotice.play("正在创建订单...");

	local goodsInfo = bundleData.goodsInfo
	local quickChargeFlag = bundleData.quickChargeFlag
	local sceneChargeData = bundleData.sceneChargeData
	local appid = PlatformConfig.getAppidAndPmode(UserData.getUserType());

	local param_data = self:getBaseParam(appid, goodsInfo.pamount)
	local userId = tonumber(UserData.getId())
	local goodId = goodsInfo.id
		
	local ip = PlatformConfig.ipAddress or"";
	local mobile=PlatformConfig.phone or "";
	local feecode=self:findPcodeByGoodPamount(goodsInfo.pamount, true) or "";
	
	HttpModule.s_config[HttpModule.s_cmds.RequestPayOrder][1] = kPhpCommonUrl .."?m=pay&p=createOrderProxy&id="..goodId..
		"&sitemid="..userId.."&user_ip="..ip.."&mobile="..mobile.."&feecode="..feecode.."&mid="..UserData.getId().."&imei="..PlatformConfig.imei.."&pmode="..self:getPmode();

	HttpModule.getInstance():execute(HttpModule.s_cmds.RequestPayOrder, param_data);
	
end