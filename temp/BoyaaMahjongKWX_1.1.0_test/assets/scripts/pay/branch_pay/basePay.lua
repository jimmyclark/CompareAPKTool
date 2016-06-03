BasePay = class()

function BasePay.getInstance()
	if not BasePay.m_instance then
		BasePay.m_instance = new(BasePay);
	end
	return BasePay.m_instance;
end

function BasePay:ctor()
	self.pmode = 0
	self.payType = 0
	self.desc = "未定义支付方式"
end

function BasePay:getPmode()
	return self.pmode
end

function BasePay:getImage()
	return "msg.png"
end

function BasePay:getDesc()
	return self.desc
end

function BasePay:mergeExtraParam(jsonData, param_data)
	param_data.payType 	= self.payType
	param_data.orderId 	= jsonData.ORDER or "";
	param_data.pamount 	= tonumber(jsonData.PAMOUNT or 0);
	param_data.goodId 	= tonumber(jsonData.PAYCONFID or 0);
	param_data.sitemid 	= jsonData.SITEMID or "";
	param_data.chips 	= jsonData.PCHIPS or "";

	local count = MyPayData:count();
	for i = 1, count do
		local payData = MyPayData:get(i);
		if tonumber(param_data.pamount) == tonumber(payData:getPamount()) then
			param_data.subject 	= payData:getPname();
			param_data.body 	= payData:getPdesc();
			break
		end
	end
end

function BasePay:reportPayData()
	if self.orderSceneData then
		printInfo("开始上报支付场景")
	   	HttpModule.getInstance():execute(HttpModule.s_cmds.RequestReportOrder, self.orderSceneData, false);
		self.orderSceneData = nil
	end
end

function BasePay:startRealPay(param_data)
	printInfo("开始调用支付：" .. self.desc .. ", 支付ID:" .. self.payType)
	NativeEvent.getInstance():StartUnitePay(param_data)
end

function BasePay:requestChargeList(force)

	if force then
		PayController:clear();
	end

	if #(PayController:getAllGoodsTable()) == 0 then
		self:requestChargeListReal();
	end

	return true
end

function BasePay:requestChargeListReal()
	printInfo("正在请求商品列表")
	local appid = PlatformConfig.getAppidAndPmode(MyUserData:getUserType());
	GameSocketMgr:sendMsg(Command.PAY_PHP_REQUEST, {['sid']=PlatformConfig.sid, ['appid']=PlatformConfig.visitorPayAppid, ['pmode']=UniteBasePmode}, false);
end

-- avoidTwiceClick 是否略过二次确认
function BasePay:pay(bundleData, callBack, avoidTwiceClick)

	self.avoidTwiceClick_ = avoidTwiceClick
	if MyPayData:count() == 0 then
		AlarmTip.play("正在获取商品信息...")
		self:requestChargeList()
		return
	end
	if self:supportPamount(bundleData.goodsInfo.pamount) then
		printInfo(self.desc .. "额度支持 开始判断限额")
		self:updateChargeLimit(bundleData, callBack)
	elseif callBack and callBack.onUnSupported then
		callBack.onUnSupported(bundleData)
	end
end

function BasePay:updateChargeLimit(bundleData, callBack)
	UnitePay.getInstance():setChargeInfo(self.payType, bundleData, callBack)
	-- 如果是苹果设备，就先查找是否屏蔽其他支付
	if System.getPlatform() == kPlatformIOS then
		GameSocketMgr:sendMsg(Command.IOS_MUTI_PAY_PHP_REQUEST, {})
	-- 如果 是主版本和广点通小包 则查找限额
	elseif PlatformConfig.currPlatform == PlatformConfig.basePlatform or
	PlatformConfig.currPlatform == PlatformConfig.GDTPlatform then

		GameSocketMgr:sendMsg(Command.PAY_CONFIG_LIMIT_PHP_REQUEST, {}, false);

	else -- 其他联运版本之间请求订单
		self:createOrder(bundleData)
	end
end

function BasePay:supportPamount(pamount)
	return true
end

function BasePay:needTwiceClick()
	local config = UnitePay.getInstance():getConfig()
	for k,v in pairs(config) do
		if v.tips == 1 and v.id == self.payType then
			return true
		end
	end
	printInfo("配置中" .. self.desc .. "不需要二次确认")
end

function BasePay:isOverLimitByPamout(pamount)
	local config = UnitePay.getInstance():getConfig()
	for k,v in pairs(config) do
		if v.id == self.payType then
			if (v.limit == 0 or (v.limit ~= -1 and pamount - v.limit > 0)) then
				printInfo(self.desc .. "超限额111111")
				return true
			else
				printInfo(self.desc .. "未超限额11111111")
				return false
			end
		end
	end
end

function BasePay:getBaseParam(appid, pamount)
	return {
		appid = appid,
		is_change = 1,
		pmode = self:getPmode(),
		is_limit = 1,
		sid = PlatformConfig.sid,
		pamount = pamount,
		ptype = 0,
		payid = self.payType,
		phone = PlatformConfig.phone,
	};
end

function BasePay:createOrderReal(bundleData)

	AlarmTip.play("正在创建订单...");

	local goodsInfo 		= bundleData.goodsInfo
	local isLuoMaFirst 		= bundleData.isLuoMaFirst
	local sceneChargeData 	= bundleData.sceneChargeData
	local appid 			= PlatformConfig.getAppidAndPmode(MyUserData:getUserType());
	local pmode 			= self:getPmode();
	local id 				= goodsInfo.id;
	local pamount 			= goodsInfo.pamount;
	local ptype 			= goodsInfo.ptype;
	local iscn = 1;		-- 苹果支付下单要走国际线路，其他支付都是国内线路，需要加以区分
	if self.payType == UnitePayIdMap.APPLE_PAY then
		iscn = 0;
	end
	printInfo("创建订单，iscn = " .. tostring(iscn))
	GameSocketMgr:sendMsg(Command.ORDER_PHP_REQUEST, {sid = PlatformConfig.sid, appid = appid, id = id, pmode = pmode, pamount = pamount, ptype = ptype, iscn = iscn}, false);

	-- local param_data = self:getBaseParam(appid, goodsInfo.pamount)
	-- local userId = tonumber(UserData.getId())
	-- local goodId = goodsInfo.id

	-- -- 支付场景上报参数
	-- local orderSceneData = {}
	-- orderSceneData.pcoins 	= 	goodsInfo.pcoins;
	-- orderSceneData.pchips 	= 	goodsInfo.pchips;         --
	-- orderSceneData.currency_num = goodsInfo.pamount;  -- 上报充值金额
	-- -- 覆盖合并参数
	-- if sceneChargeData then
	-- 	for k,v in pairs(sceneChargeData) do
	-- 		orderSceneData[k] = v;
	-- 	end
	-- end
	-- self.orderSceneData = orderSceneData

	-- if self:getPmode() == UnitePmodeMap.UNICOM_LUOMA_PAY
	-- 	or self:getPmode() == UnitePmodeMap.UNICOM_LUOMA_PAY2 then
	-- 	local ip = PlatformConfig.ipAddress or"";
	-- 	HttpModule.s_config[HttpModule.s_cmds.RequestPayOrder][1] = kPhpCommonUrl ..
	-- 		"?m=pay&p=createOrderProxy&id="..goodId..
	-- 		"&sitemid="..userId.."&user_ip="..ip.."&mid="..UserData.getId()..
	-- 		"&imei="..PlatformConfig.imei.."&pmode="..self:getPmode();
	-- 	HttpModule.getInstance():execute(HttpModule.s_cmds.RequestPayOrder, param_data);
	-- else
	-- 	HttpModule.getInstance():formatRequestUrl(HttpModule.s_cmds.RequestPayOrder, goodId, userId, self:getPmode());
	-- 	HttpModule.getInstance():execute(HttpModule.s_cmds.RequestPayOrder, param_data)
	-- end
end

-- 小包裸码专用  因为有单独的限额 二次确认接口
function BasePay:freshLimitInfo(twice_click, usable)
	self.twice_click = twice_click
	self.usable = usable
end

function BasePay:createOrder(bundleData)
	-- 配置是否需要二次确认，或者sceneChargeData中有强制二次确认且是裸码
	if not self.avoidTwiceClick_ and self:needTwiceClick() then
		self:showTwiceClickWnd(bundleData)
	else
		self:createOrderReal(bundleData)
	end
end

-- 展示裸码支付窗口
function BasePay.showTwiceClickWnd(self, bundleData)
	--printInfo("弹出二次确认框")

	WindowManager:showWindow(WindowTag.PayComfirmPopu, {
		text = string.format(PayConfirmTip, bundleData.goodsInfo.pname, bundleData.goodsInfo.pamount),
		titleText = "温馨提示",
		leftText = "确定",
		singleBtn=true,
		closeFunc = handler(self, function ()
									if not bundleData.mutiEntrance then
										UnitePay.getInstance():showMutiPay(bundleData)
									end
								 end),
		leftFunc = handler(self, function ()
									self:createOrderReal(bundleData)
								 end),
	})


end

-- 处理拉取到商品列表之后的业务
function BasePay:continueDealCharge(chargeListInfo)
	Log.w(self.desc .. ":处理商品列表拉取到之后的业务")

	if UserData.getMoney() < MyBaseInfoData:getBrokenMoney() and UserData.getIsLogin() then
		globalBrokeAllowanceRequestLimit(true);
	end
	if UserData.getNeedFreshGuide() ~= 1 then
		globalJudgeShowFirstPayWnd()
		SortWindowManager.showWindow()
	end
	EventDispatcher.getInstance():dispatch(kMessageNotifyEvent , kShowMarketGoodsList , chargeListInfo);
end

-- 通过商品pamount查找计费码(pamount，根据本地存储的计费码信息查找)
function BasePay:findPcodeByGoodPamount(pamount, isLuoMa)
	if not pamount or pamount == "" then
		Log.w("非法的查找pamount!" .. (pamount or 0));
		return;
	end
	if isLuoMa then
		for k,v in pairs(PlatformPayCode) do
			if tonumber(v.pamount) == pamount then
				if PlatformConfig.simType == 1 then
					if self:getPmode() == UnitePmodeMap.JIDI_LUOMA_PAY then
						return v.JIDICODE
					elseif self:getPmode() == UnitePmodeMap.HUAFUBAO_PAY then
						return v.CONSUMECODE
					end
				elseif PlatformConfig.simType == 2 then
					if self:getPmode() == UnitePmodeMap.UNICOM_LUOMA_PAY then
						return v.SFCODE
					elseif self:getPmode() == UnitePmodeMap.UNICOM_LUOMA_PAY2 then
						return v.SFCODE2
					end
				elseif PlatformConfig.simType == 3 then
					return v.goodId, v.sendAdress
				end
			end
		end
	else
		for k,v in pairs(PlatformPayCode) do
			if tonumber(v.pamount) == pamount then
				if PlatformConfig.simType == 1 then
					return v.YDMMIAP
				elseif PlatformConfig.simType == 2 then
					return v.UNICOM,string.sub(v.UNICOMOTHER,-3)
				elseif PlatformConfig.simType == 3 then

				end
			end
		end
	end
end

function BasePay:getPayCodeByPamount(pamount)
	for k,v in pairs(PlatformPayCode) do
		if tonumber(v.pamount) == pamount then
			return v
		end
	end
end
