UniteSmsPay = class(BasePay)

function UniteSmsPay.getInstance()
	if not UniteSmsPay.m_instance then
		UniteSmsPay.m_instance = new(UniteSmsPay);
	end
	return UniteSmsPay.m_instance;
end	

function UniteSmsPay:ctor()

	if PlatformConfig.simType == 1 then
		self.pmode = UnitePmodeMap.MOBILEMM_PAY
		self.payType = UnitePayIdMap.MOBILEMM_PAY
		self.desc = "MM短信支付"

	elseif PlatformConfig.simType == 2 then
		self.pmode = UnitePmodeMap.UNICOM_PAY
		self.payType = UnitePayIdMap.UNICOM_PAY
		self.desc = "联通短信支付"

	elseif PlatformConfig.simType == 3 then
		self.pmode = UnitePmodeMap.TELECOM_PAY
		self.payType = UnitePayIdMap.TELECOM_PAY
		self.desc = "天翼短信支付"

	end
end

-- 添加参数
function UniteSmsPay:mergeExtraParam(jsonData, param_data)
	UniteSmsPay.super.mergeExtraParam(self, jsonData, param_data)
	param_data.notify_url = jsonData.notify_url or ""  -- 联通专用
	if PlatformConfig.simType == 1 then
		param_data.orderId = string.sub(param_data.orderId, -16, -1);	--订单号只取后16位
		param_data.collingcode = self:findPcodeByGoodPamount(param_data.pamount)
	elseif PlatformConfig.simType == 2 then
		param_data.orderId = string.sub(param_data.orderId, -24, -1);	--订单号只取后24位
		param_data.pcode_vac, param_data.pcode_other = self:findPcodeByGoodPamount(param_data.pamount)
	elseif PlatformConfig.simType == 3 then
		-- 电信下单从订单里面获取 collingcode
		param_data.collingcode = GetStrFromJsonTable(jsonData, "collingcode")
	end
	printInfo("UniteSmsPay.mergeExtraParam")
end

function UniteSmsPay:createOrderReal(bundleData)
	printInfo(self.desc .. ":开始创建订单1")
	if PlatformConfig.simType ~= 2 then
		printInfo(self.desc .. ":开始创建订单3")
		UniteSmsPay.super.createOrderReal(self, bundleData)
	else
		local goodsInfo 		= bundleData.goodsInfo
		local isLuoMaFirst 		= bundleData.isLuoMaFirst
		local sceneChargeData 	= bundleData.sceneChargeData
		local appid 			= PlatformConfig.getAppidAndPmode(MyUserData:getUserType());
		local pmode 			= self:getPmode();
		local pamount 			= goodsInfo.pamount
		local id 				= goodsInfo.id
		local ptype 			= goodsInfo.ptype;

		GameSocketMgr:sendMsg(Command.ORDER_PHP_REQUEST, {sid = PlatformConfig.sid, appid = appid, id = id, pmode = pmode, pamount = pamount, ptype = ptype}, false);

	-- 	local pamount = goodsInfo.pamount
	-- 	local pcode_vac, pcode_other = self:findPcodeByGoodPamount(pamount)
	-- 	local appid = "90349971220140304185526037300";	--沃商店应用id
	-- 	local appname = "博雅二人麻将";
	-- 	local fid = "00012243";							--渠道码
	-- 	local appversion = PlatformConfig.versionName;
	-- 	local imei = PlatformConfig.imei;
	-- 	local mac = string.gsub(PlatformConfig.mac, ":", "");
	-- 	local sitemid = MyUserData:getSitemid();
	-- 	local feename = goodsInfo.name;
	-- 	local ip = PlatformConfig.ipAddress or"";

	-- 	if not ToolKit.isValidString(pcode_vac) or not ToolKit.isValidString(pcode_other) then
	-- 		--没有计费码即不支持该额度
	-- 		AlarmTip.play(GameString.get("thisFeeNotSupportTip"));
	-- 		return;
	-- 	end
	-- -- http://paycn.boyaa.com/create_order.php?id=<商品id>&sitemid=<用户站内id>&appname=<在联通wo的应用名称>
	-- -- &feename=计费点名称&mac=MAC地址去掉冒号&appid=沃商店应用id&userip=IP地址&serviceid=沃商店计费点&channelid=渠道ID
	-- -- &appversion=应用版本号&imei=设备标识号 接口返回json格式数据

	-- 	HttpModule.s_config[HttpModule.s_cmds.RequestPayOrder][1] = kPhpCommonUrl .. "?m=pay&p=createOrderProxy&id="..
	-- 		goodId.."&sitemid="..userId.."&appname="..appname.."&feename="..feename.."&mac="..mac.."&appid="..appid..
	-- 		"&userip="..ip.."&serviceid="..pcode_other.."&channelid="..fid.."&appversion="..appversion.."&imei="..imei.."&pmode="..
	-- 		UnitePmodeMap.UNICOM_PAY;
	-- 	HttpModule.getInstance():execute(HttpModule.s_cmds.RequestPayOrder, param_data);
	end
end

function UniteSmsPay:supportPamount(pamount)
	-- printInfo(self.desc	.. "判断额度是否支持" .. pamount .. PlatformConfig.mobileChargeKey)
	local payCode = self:getPayCodeByPamount(pamount)
	if PlatformConfig.simType == 1 then
		return payCode and payCode.YDMMIAP
	elseif PlatformConfig.simType == 2 then
		return payCode and payCode.UNICOM
	elseif PlatformConfig.simType == 3 then
		return payCode and payCode.TIANYI --电信支持
	end
end