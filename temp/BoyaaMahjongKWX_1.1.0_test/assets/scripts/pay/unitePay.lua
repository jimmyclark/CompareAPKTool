UnitePmodeMap = {
	SMS_PAY 		= 0,   -- 短信支付
	ALI_PAY		= -1,   -- 支付宝支付
	CREDITCARD_PAY	= 0,   -- 信用卡支付
	MOBILEMM_PAY	= 218,   -- 移动MM支付
	UNICOM_PAY		= 109,   -- 联通沃支付
	UNION_PAY		= 198,   -- 银联支付
	TELECOM_PAY		= 117,   -- 电信支付
	WECHAT_PAY		= 431,   -- 微信支付
	HUAFUBAO_PAY 	= 217,   -- 话付宝支付
	TELE_BARE_PAY   = 282,   -- 电信裸码支付
	OPPO_PAY 		= 215,   -- OPPO支付
	QIHOO_PAY 		= 136,   -- 360支付
	HUAWEI_PAY 		= 110,   -- 华为支付
	ANZHI_PAY 		= 238,   -- 安智支付
	MOBILE_PAY 		= 31,   -- 移动基地支付
	JIDI_LUOMA_PAY  = 292,	--移动基地裸码
	UNICOM_LUOMA_PAY = 298,	--联通盛峰裸码1
	UNICOM_LUOMA_PAY2 = 308,	--联通盛峰裸码2
	UNICOM_LUOMA_PAY3 = 308;	--联通盛峰裸码3
	ALI_WEB_PAY   = 26,         -- 阿里Web支付
	AYX_PAY       = 34,	        --爱游戏
	GAMEVIEW_PAY  = 314,        --马来版本支付
	LIANXIANGLUOMA_PAY = 328,	--联想裸码支付
	ALI_JIJIAN_PAY	= 265,
	WECHAT_APPLE_PAY = 463,		-- 苹果的微信支付，和安卓的不同（But why?）
	APPLE_PAY		= 99,		--苹果支付
	BAIDUQUDAO_PAY = 294,  -- 百度渠道支付
}

UnitePayIdMap = {
	SMS_PAY 		= -1,   -- 短信支付
	ALI_PAY			= 2,   -- 支付宝支付
	CREDITCARD_PAY	= 3,   -- 信用卡支付
	MOBILEMM_PAY	= 4,   -- 移动MM支付
	UNICOM_PAY		= 5,   -- 联通沃支付
	UNION_PAY		= 6,   -- 银联支付
	TELECOM_PAY		= 7,   -- 电信支付
	WECHAT_PAY		= 8,   -- 微信支付
	HUAFUBAO_PAY 	= 9,   -- 话付宝支付
	TELE_BARE_PAY   = 10,   -- 电信裸码支付
	OPPO_PAY 		= 11,   -- OPPO支付
	QIHOO_PAY 		= 12,   -- 360支付
	HUAWEI_PAY 		= 13,   -- 华为支付
	ANZHI_PAY 		= 14,   -- 安智支付
	MOBILE_PAY 		= 15,   -- 移动基地支付
	JIDI_LUOMA_PAY  = 16,   -- 移动基地裸码支付
	UNICOM_LUOMA_PAY = 17,	-- 联通盛峰裸码支付
	UNICOM_LUOMA_PAY2 = 18,	--联通盛峰裸码2
	ALI_WEB_PAY   = 19,     -- 阿里Web支付
	AYX_PAY 	  = 20,			--爱游戏
	UNICOM_LUOMA_PAY3 = 22,		--联通盛峰裸码3
	GAMEVIEW_PAY      = 23,      --马来版本支付
	-- LIANXIANGLUOMA_PAY = 24,	 --联想裸码支付
	ALI_JIJIAN_PAY = 24,  -- 支付宝极简支付
	WECHAT_APPLE_PAY = 25,	-- 苹果的微信支付，和安卓的不同（But why?）
	APPLE_PAY   		= 26,	-- 苹果支付
	BAIDUQUDAO_PAY = 2003,  -- 百度渠道支付
}

require("platform/platformPayCode");
require("pay/branch_pay/basePay")
require("pay/branch_pay/weChatPay")
require("pay/branch_pay/aliPay")
require("pay/branch_pay/unionPay")
require("pay/branch_pay/uniteSmsPay")
require("pay/branch_pay/luoMaPay")
require("pay/branch_pay/jidiLuoMaPay")
require("pay/branch_pay/unicomLuoMaPay2")
require("pay/branch_pay/unicomLuoMaPay3")
require("pay/branch_pay/aYXPay")
require("pay/branch_pay/aliWebPay")
require("pay/branch_pay/huaWeiPay")
require("pay/branch_pay/oppoPay")
require("pay/branch_pay/qiHuPay")
require("pay/branch_pay/anZhiPay")
require("pay/branch_pay/yiDongJiDiPay")
require("pay/branch_pay/gvPay")
require("pay/branch_pay/lianxiangLuoMaPay")
require("pay/branch_pay/weChatApplePay")
require("pay/branch_pay/applePay")
require("pay/branch_pay/baiDuQuDaoPay")


UnitePay = class()

--  支付id对应的图片等配置
UnitePayConfigMap = {
	-- [UnitePayIdMap.SMS_PAY] 			= {"msg.png", "短信支付", },  -- 短信支付

	-- [UnitePayIdMap.ALI_PAY]				= {"img_zhifubao.png", "支付宝"},  -- 支付宝支付
	-- [UnitePayIdMap.CREDITCARD_PAY]		= {"xinyongka.png", "信用卡", },  -- 信用卡支付

	-- [UnitePayIdMap.MOBILEMM_PAY]		= {"img_sms.png", "短信支付"},  -- 移动MM支付
	-- [UnitePayIdMap.UNICOM_PAY]			= {"img_sms.png", "短信支付"},  -- 联通沃支付
	-- [UnitePayIdMap.UNION_PAY]			= {"yinlian.png", "银联支付"},  -- 银联支付
	-- [UnitePayIdMap.TELECOM_PAY]			= {"img_sms.png", "短信支付"},  -- 电信支付
	-- [UnitePayIdMap.WECHAT_PAY]			= {"img_weixin.png", "微信支付"},  -- 微信支付
	-- [UnitePayIdMap.HUAFUBAO_PAY] 		= {"img_sms.png", "短信支付"},  -- 话付宝支付

	-- [UnitePayIdMap.TELE_BARE_PAY]   	= {"img_sms.png", "短信支付", }, -- 电信裸码支付
	-- [UnitePayIdMap.OPPO_PAY] 			= {"OPPO.png", "可币支付", }, -- OPPO支付
	-- [UnitePayIdMap.QIHOO_PAY] 			= {"360.png", "360支付", }, -- 360支付
	-- [UnitePayIdMap.HUAWEI_PAY] 			= {"huawei.png", "华为支付", }, -- 华为支付
	-- [UnitePayIdMap.ANZHI_PAY] 			= {"anzhi.png", "安智支付", }, -- 安智支付
	-- [UnitePayIdMap.MOBILE_PAY] 			= {"img_sms.png", "短信支付", }, -- 移动基地支付

	-- [UnitePayIdMap.JIDI_LUOMA_PAY]   	= {"img_sms.png", "短信支付", }, -- 移动基地裸码支付

	-- [UnitePayIdMap.UNICOM_LUOMA_PAY] 	= {"img_sms.png", "短信支付", }, -- 联通盛峰裸码支付(1)
	-- [UnitePayIdMap.UNICOM_LUOMA_PAY2] 	= {"img_sms.png", "短信支付", }, -- 联通盛峰裸码支付(2)
	-- [UnitePayIdMap.UNICOM_LUOMA_PAY3] 	= {"img_sms.png", "短信支付", }, -- 联通盛峰裸码支付(3)
	-- [UnitePayIdMap.AYX_PAY]			  	= {"img_sms.png", "短信支付", }, -- 爱游戏短信支付
	-- [UnitePayIdMap.ALI_WEB_PAY] 		= {"zhifubao.png", "阿里web支付"}, -- 阿里web支付
	-- [UnitePayIdMap.GAMEVIEW_PAY] 		= {"zhifubao.png", "GV支付"}, -- GameView支付

	-- [UnitePayIdMap.LIANXIANGLUOMA_PAY] = {"img_sms.png", "联想易迅SDK支付",},	--联想易迅SDK支付
	-- [UnitePayIdMap.ALI_JIJIAN_PAY]				= {"img_zhifubao.png", "支付宝"},  -- 支付宝支付
	[UnitePayIdMap.BAIDUQUDAO_PAY]				= {"img_baidu.png", "百度支付"},  -- 支付宝支付
}

GlobalUnitePayConfigMap = ToolKit.deepcopy(UnitePayConfigMap)

UnitePaySupportConfigMap = {
}

UniteBasePmode = UnitePmodeMap.ALI_JIJIAN_PAY

function UnitePay.getInstance()
	if not UnitePay.m_instance then
		UnitePay.m_instance = new(UnitePay)
	end
	return UnitePay.m_instance
end

function UnitePay:ctor()
	EventDispatcher.getInstance():register(HttpModule.s_event, self, self.onHttpRequestsCallBack);
	self:adjustUnitePayConfigMap()
end

function UnitePay:dtor()
	EventDispatcher.getInstance():unregister(HttpModule.s_event, self, self.onHttpRequestsCallBack);
end

function UnitePay:adjustUnitePayConfigMap()
	if System.getPlatform() == kPlatformIOS then
		printInfo("[UnitePayIdMap.APPLE_PAY] = "..UnitePayIdMap.APPLE_PAY)
		table.insert(UnitePayConfigMap, UnitePayIdMap.APPLE_PAY, {"img_apple.png", "苹果支付"})
		table.insert(UnitePayConfigMap, UnitePayIdMap.WECHAT_APPLE_PAY, {"img_weixin.png", "微信支付"})	-- 苹果的微信支付，和安卓的不同（But why?）
	end
end

function UnitePay:getPayByPmode(pmode)
	if pmode == UnitePmodeMap.HUAFUBAO_PAY
		or pmode == UnitePmodeMap.TELE_BARE_PAY
		or pmode == UnitePmodeMap.UNICOM_LUOMA_PAY then
		printInfo("LuoMaPay")
		return LuoMaPay.getInstance()
	elseif pmode == UnitePmodeMap.UNICOM_LUOMA_PAY2 then
		printInfo("UNICOM_LUOMA_PAY2")
		return UnicomLuoMaPay2.getInstance()
	elseif pmode == UnitePmodeMap.UNICOM_LUOMA_PAY3 then
		printInfo("UNICOM_LUOMA_PAY3")
		return UnicomLuoMaPay3.getInstance()

	elseif pmode == UnitePmodeMap.JIDI_LUOMA_PAY then
		printInfo("JIDI_LUOMA_PAY")
		return JidiLuoMaPay.getInstance()

	elseif pmode == UnitePmodeMap.MOBILEMM_PAY
		or pmode == UnitePmodeMap.UNICOM_PAY
		or pmode == UnitePmodeMap.TELECOM_PAY then
		printInfo("UniteSmsPay")
		return UniteSmsPay.getInstance()

	elseif pmode == UnitePmodeMap.WECHAT_PAY then  -- 微信
		printInfo("WeChatPay")
		return WeChatPay.getInstance()

	elseif pmode == UnitePmodeMap.ALI_JIJIAN_PAY then  -- 支付宝
		printInfo("AliPay")
		return AliPay.getInstance()

	elseif pmode == UnitePmodeMap.UNION_PAY then  -- 银联
		printInfo("UnionPay")
		return UnionPay.getInstance()

	elseif pmode == UnitePmodeMap.ALI_WEB_PAY then
		return AliWebPay.getInstance()
	elseif pmode == UnitePmodeMap.AYX_PAY then
		return AYXPay.getInstance();
	elseif pmode == UnitePmodeMap.HUAWEI_PAY then
		return HuaWeiPay.getInstance();
	elseif pmode == UnitePmodeMap.OPPO_PAY then
		return OppoPay.getInstance();
	elseif pmode == UnitePmodeMap.QIHOO_PAY then
		return QiHuPay.getInstance();
	elseif pmode == UnitePmodeMap.ANZHI_PAY then
		return AnZhiPay.getInstance();
	elseif pmode == UnitePmodeMap.MOBILE_PAY then
		return YiDongJiDiPay.getInstance();
	elseif pmode == UnitePmodeMap.GAMEVIEW_PAY then
		return GVPay.getInstance();
	elseif pmode == UnitePmodeMap.LIANXIANGLUOMA_PAY then
		return LianxiangLuoMaPay.getInstance();

	elseif pmode == UnitePmodeMap.WECHAT_APPLE_PAY then
		return WeChatApplePay.getInstance();
	elseif pmode == UnitePmodeMap.APPLE_PAY then
		return ApplePay.getInstance();
	elseif pmode == UnitePmodeMap.BAIDUQUDAO_PAY then
		return BaiDuQuDaoPay.getInstance()
	end
end

function UnitePay:getPayByPayId(payId)
	printInfo("开始获取支付实例" .. payId)
	if payId == UnitePayIdMap.MOBILEMM_PAY and PlatformConfig.simType == 1 then
		printInfo("MOBILEMM_PAY")
		return UniteSmsPay.getInstance()

	elseif payId == UnitePayIdMap.HUAFUBAO_PAY and PlatformConfig.simType == 1 then
		printInfo("HUAFUBAO_PAY")
		return LuoMaPay.getInstance()

	elseif payId == UnitePayIdMap.JIDI_LUOMA_PAY and PlatformConfig.simType == 1 then
		printInfo("JIDI_LUOMA_PAY")
		return JidiLuoMaPay.getInstance()

	elseif payId == UnitePayIdMap.UNICOM_LUOMA_PAY and PlatformConfig.simType == 2 then
		printInfo("UNICOM_LUOMA_PAY")
		return LuoMaPay.getInstance()
	elseif payId == UnitePayIdMap.UNICOM_LUOMA_PAY2 and PlatformConfig.simType == 2 then
		printInfo("UNICOM_LUOMA_PAY2")
		return UnicomLuoMaPay2.getInstance()
	elseif payId == UnitePayIdMap.UNICOM_LUOMA_PAY3 and PlatformConfig.simType == 2 then
		printInfo("UNICOM_LUOMA_PAY3")
		return UnicomLuoMaPay3.getInstance()
	elseif payId == UnitePayIdMap.UNICOM_PAY and PlatformConfig.simType == 2 then
		printInfo("UNICOM_PAY")
		return UniteSmsPay.getInstance()

	elseif payId == UnitePayIdMap.TELECOM_PAY and PlatformConfig.simType == 3 then
		printInfo("TELECOM_PAY")
		return UniteSmsPay.getInstance()

	elseif payId == UnitePayIdMap.TELE_BARE_PAY and PlatformConfig.simType == 3 then
		printInfo("TELE_BARE_PAY")
		return LuoMaPay.getInstance()

	elseif payId == UnitePayIdMap.AYX_PAY and PlatformConfig.simType == 3 then 	-- 爱游戏
		return AYXPay.getInstance();

	elseif payId == UnitePayIdMap.WECHAT_PAY then  -- 微信
		printInfo("WeChatPay")
		return WeChatPay.getInstance()

	elseif payId == UnitePayIdMap.ALI_JIJIAN_PAY then  -- 支付宝
		printInfo("AliPay")
		return AliPay.getInstance()

	elseif payId == UnitePayIdMap.UNION_PAY then  -- 银联
		printInfo("UnionPay")
		return UnionPay.getInstance()

	elseif payId == UnitePayIdMap.ALI_WEB_PAY then
		return AliWebPay.getInstance()
	elseif payId == UnitePayIdMap.HUAWEI_PAY then
		return HuaWeiPay.getInstance();
	elseif payId == UnitePayIdMap.OPPO_PAY then
		return OppoPay.getInstance();
	elseif payId == UnitePayIdMap.QIHOO_PAY then
		return QiHuPay.getInstance();
	elseif payId == UnitePayIdMap.ANZHI_PAY then
		return AnZhiPay.getInstance();
	elseif payId == UnitePayIdMap.MOBILE_PAY and PlatformConfig.simType == 1 then -- 移动基地
		return YiDongJiDiPay.getInstance();
	elseif payId == UnitePayIdMap.GAMEVIEW_PAY then
		return GVPay.getInstance();
	elseif payId == UnitePayIdMap.LIANXIANGLUOMA_PAY then
		return LianxiangLuoMaPay.getInstance();

	elseif payId == UnitePayIdMap.WECHAT_APPLE_PAY then
		return WeChatApplePay.getInstance();
	elseif payId == UnitePayIdMap.APPLE_PAY then
		return ApplePay.getInstance();
	elseif payId == UnitePayIdMap.BAIDUQUDAO_PAY then
		return BaiDuQuDaoPay.getInstance()
	end
end

function UnitePay:getSupportPayByPayId(payId)
	local isLocalSupport = function(payId)
		for _, v in pairs(UnitePayIdMap) do
			if payId == v then
				return true
			end
		end
	end

	-- 是否支持该支付
	local config = self:getConfig()
	for _, v in pairs(config) do
		if v.id == payId and isLocalSupport(payId) then
			return self:getPayByPayId(payId)
		end
	end
end

function UnitePay:isSupportSmsPayId(payId)
	if self:isSupportLuoMaPayId(payId)
		or (payId == UnitePayIdMap.MOBILEMM_PAY and PlatformConfig.simType == 1)
		or (payId == UnitePayIdMap.UNICOM_PAY and PlatformConfig.simType == 2)
		or (payId == UnitePayIdMap.TELECOM_PAY and PlatformConfig.simType == 3)
		or (payId == UnitePayIdMap.AYX_PAY and PlatformConfig.simType == 3)
		or (payId == UnitePayIdMap.MOBILE_PAY and PlatformConfig.simType == 1) then
		return true
	end
end

function UnitePay:isSupportLuoMaPayId(payId)
	if (payId == UnitePayIdMap.HUAFUBAO_PAY and PlatformConfig.simType == 1)
		or (payId == UnitePayIdMap.UNICOM_LUOMA_PAY and PlatformConfig.simType == 2)
		or (payId == UnitePayIdMap.UNICOM_LUOMA_PAY2 and PlatformConfig.simType == 2)
		or (payId == UnitePayIdMap.UNICOM_LUOMA_PAY3 and PlatformConfig.simType == 2)
		or (payId == UnitePayIdMap.JIDI_LUOMA_PAY and PlatformConfig.simType == 1)
		or (payId == UnitePayIdMap.TELE_BARE_PAY and PlatformConfig.simType == 3)
		or (payId == UnitePayIdMap.JIDI_LUOMA_PAY and PlatformConfig.simType == 1) then
		return true
	end
end

function UnitePay:isSmsPayId(payId)
	if self:isLuoMaPayId(payId)
		or (payId == UnitePayIdMap.MOBILEMM_PAY)
		or (payId == UnitePayIdMap.UNICOM_PAY)
		or (payId == UnitePayIdMap.TELECOM_PAY)
		or (payId == UnitePayIdMap.AYX_PAY)
		or (payId == UnitePayIdMap.MOBILE_PAY)
        or (payId == UnitePayIdMap.LIANXIANGLUOMA_PAY) then
		return true
	end
end

function UnitePay:isLuoMaPayId(payId)
	if (payId == UnitePayIdMap.HUAFUBAO_PAY)
		or (payId == UnitePayIdMap.UNICOM_LUOMA_PAY)
		or (payId == UnitePayIdMap.UNICOM_LUOMA_PAY2)
		or (payId == UnitePayIdMap.UNICOM_LUOMA_PAY3)
		or (payId == UnitePayIdMap.JIDI_LUOMA_PAY)
		or (payId == UnitePayIdMap.TELE_BARE_PAY)
		or (payId == UnitePayIdMap.JIDI_LUOMA_PAY) then
		return true
	end
end

function UnitePay:getConfig(isLuoMaFirst)
	if not isLuoMaFirst then
		return UnitePaySupportConfigMap
	else
		local tb = {}
		printInfo("getConfig支付种类" .. #UnitePaySupportConfigMap)
		for i=1, #UnitePaySupportConfigMap do
			local conf = UnitePaySupportConfigMap[i]
			if self:isLuoMaPayId(conf.id) then
				printInfo("找到一个裸码 = " .. conf.id)
				table.insert(tb, conf)
			end
		end
		if #tb == 0 then --裸码没找到 按照非裸码优先再找一次
			return self:getConfig()
		end
		return tb
	end
end

function UnitePay:isConfigAvaliable()
	return #UnitePaySupportConfigMap > 0
end

function UnitePay:autoSelectPayConfig(bundleData, isLuoMaFirst)
	-- 拿优先级最高的
	printInfo("是否优先裸码" .. (isLuoMaFirst and "true" or "false"))
	local config = self:getConfig(isLuoMaFirst)
	if #config > 0 then
		-- local lastPayId = GameConfig:getLastPayId() or 0 -- 卡五星看起来暂时没有自动使用上次成功的支付方式这种功能
		local payID = 0
		local startIndex = 0
		-- 如果打开支付的屏蔽开关，那么就只允许苹果支付
		if System.getPlatform() == kPlatformIOS and ShieldData:getMutiPayFlag() then
			payID = UnitePayIdMap.APPLE_PAY
		end
		-- 如果没有打开屏蔽开关，那么就不会返回任何支付实例，这样就会走原来的支付逻辑
		if UnitePayConfigMap[payID] then
			-- 支付实例
			for index, v in ipairs(config) do
				if v.id == payID then
					startIndex = index
					break
				end
			end
		end
		return config[startIndex], startIndex
	end
end

-- 修改了一下这个方法，因为要支持苹果的支付屏蔽功能，对安卓没有影响
-- 目前的实际效果是如果苹果的支付屏蔽打开了，那么就只允许苹果支付，否则弹出支付选择框
function UnitePay:autoSelectPay(bundleData, isLuoMaFirst)
	if bundleData then
		local config, startIndex = self:autoSelectPayConfig(bundleData, isLuoMaFirst)
		if config and startIndex then
			self:selectPay(bundleData, startIndex, isLuoMaFirst)
		else
			local config = self:getConfig(isLuoMaFirst)
			if #config > 0 then
				local conf = config[1]
				if not self:isSmsPayId(conf.id) then
					self:showMutiPay(bundleData)
				else
					self:selectPay(bundleData, 1, isLuoMaFirst)
				end
			else
				AlarmTip.play("商品获取失败，请您重新登录")
			end
		end
	end
end

function UnitePay:selectPay(bundleData, index, isLuoMaFirst)
	local config = self:getConfig(isLuoMaFirst)
	if config[index] then
		local createCallBack = function(index)
			local callBack = {
				-- 如果短信不支持或者 取消了短信支付 则显示
				onUnSupported = function(data)
					printInfo("onUnSupported =================== " .. index)
					local conf = config[index + 1]
					-- 超限额的情况下如果 下一个不是短信支付了则弹选择面板
					if conf and self:isSupportSmsPayId(conf.id) then
						printInfo("onUnSupported next =================== " .. conf.id)
						self:selectPay(data, index + 1, isLuoMaFirst)
					-- 如果裸码失败了 则重新非裸码优先来一次
					elseif isLuoMaFirst and self:isLuoMaPayId(conf.id) then  -- 注意是判断当前失败的是裸码
						self:autoSelectPay(bundleData, false)
					else
						self:showMutiPay(data)
					end
				end,
				onCanceled = function(data)
					self:showMutiPay(data)
				end
			}
			return callBack
		end


		pay = self:getSupportPayByPayId(config[index].id)
		if pay then
			pay:getInstance():pay(bundleData, createCallBack(index), isLuoMaFirst)
			self.m_lastPayData = bundleData
		-- 下一个如果是短信支付 则继续判断
		elseif index < #config and self:isSmsPayId(config[index + 1].id) then
			self:selectPay(bundleData, index + 1, isLuoMaFirst)
		else
			self:showMutiPay(bundleData)
		end
	else
		self:showMutiPay(bundleData)
	end
end

-- 根据平台来选择支付方式
function UnitePay:platformDefaultPay(bundleData)
	PlatformManager.getInstance():executeAdapter(PlatformManager.s_cmds.PlatformDefaultPay, bundleData);
end

-- 多平台支付的时候 屏蔽掉裸码 因为有裸码的话先前会使用裸码支付
function UnitePay:getMutiPaySupportTb(isLuoMaFirst)
	local tb = {}
	local config = self:getConfig(isLuoMaFirst)
	local smsTable = {"移动", "联通", "电信"}
	printInfo("我是%s卡", smsTable[PlatformConfig.smsType] or "未知")
	printInfo("支持的支付方式种类有======" .. #config )
	for i=1, #config do
		local conf = config[i]
		printInfo("支付方式======" .. conf.id )
		if self:getSupportPayByPayId(conf.id) then
			table.insert(tb, conf)
		end
	end
	printInfo("支持的支付方式种类有" .. #tb )
	return tb
end

function UnitePay:getMutiSmsPayTb(isLuoMaFirst)
	local tb = {}
	local config = self:getConfig(isLuoMaFirst)
	for i=1, #config do
		local conf = config[i]
		if self:isSupportSmsPayId(conf.id) then
			table.insert(tb, conf)
		end
	end
	printInfo("支持的短信支付方式种类有" .. #tb )
	return tb
end

-- 显示支付选择框
function UnitePay:showMutiPay(bundleData)
	-- 如果支持的支付方式大于1
	bundleData = bundleData or self.m_lastPayData
	if bundleData then
		dump(bundleData)
		-- local unitePayWnd = WindowRootView.getInstance():getWindowByTag(WindowTag.MutiPayWnd)
		-- unitePayWnd:updateGoodesInfo(bundleData)
		-- unitePayWnd:show(PopupWindowStyle.TRANSLATE)
		WindowManager:showWindow(WindowTag.PayPopu, bundleData);
		self.m_lastPayData = bundleData
	end
end

function UnitePay:hideMutiPay()
	WindowRootView.getInstance():removeWindowByTag(WindowTag.MutiPayWnd)
end

function UnitePay:needTwiceClick(payId)
	local config = self:getConfig()
	for k,v in pairs(config) do
		if v.tips == 1 then
			return true
		end
	end
end

-- 通过商品pamount查找计费码(pamount，根据本地存储的计费码信息查找)
function UnitePay:findPcodeByGoodPamount(pamount, isLuoMa)
	if not pamount or pamount == "" then
		printInfo("非法的查找pamount!" .. (pamount or 0));
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

function UnitePay:startPayWidthOrder(jsonData)
	if jsonData.status == 1 then
		printInfo("UnitePay:startPayWidthOrder")
		local orderTable = jsonData.data or {}

		orderTable.notify_url = orderTable.NOTIFY_URL or ""
		local goodsTable = PayController:getAllGoodsTable()

	    -- 支付宝相关
	    local count = #goodsTable
		for i = 1, count do
			local payData = goodsTable[i]
			if tonumber(orderTable.PAMOUNT) == tonumber(payData.pamount) then
				orderTable.productName 	= payData.pname
				orderTable.productDesc 	= payData.pdesc;
				break
			end
		end

		-- 微信相关
		orderTable.appid 		= orderTable.appid or ""
		orderTable.partnerId 	= orderTable.partnerid or ""
		orderTable.nonceStr 	= orderTable.noncestr or ""
		orderTable.package 		= orderTable.package or ""
		orderTable.prepayId 	= orderTable.prepayid or ""
		orderTable.sign 		= orderTable.sign or ""
		orderTable.timeStamp 	= orderTable.timestamp or 0

		-- 裸码相关下单从本地获取pcode
		if PlatformConfig.simType == 1 then
			orderTable.collingcode = self:findPcodeByGoodPamount(orderTable.PAMOUNT, true)
		elseif PlatformConfig.simType == 2 then
			orderTable.collingcode = self:findPcodeByGoodPamount(orderTable.PAMOUNT, true)
		elseif PlatformConfig.simType == 3 then
			orderTable.goodId, orderTable.sendAdress = self:findPcodeByGoodPamount(orderTable.PAMOUNT, true)
		end
		
		PayController:createOrderCallback(orderTable)
	else
		AlarmTip.play("订单创建失败")
	end
end

function UnitePay:onReceiveChargeList(jsonData)
	printInfo('UnitePay:onReceiveChargeList');
	--在commonPhpProcesser初始化
end

-- 拿到创建的订单
function UnitePay:onRequestOrderBack(jsonData)

	local status = jsonData.status;  --ADD没有的话 用-1表示失败了
	if status == 1 then
		printInfo("order suc");
		self:startPayWidthOrder(jsonData)
	else
        printInfo("order faild.");
		--创建订单返回提示
		AlarmTip.play(jsonData.msg or "创建订单失败");
		-- if status == -13 then --防刷自动调到下一个支付 或者显示选择面板
		-- 	if self.m_lastCallBack and self.m_lastCallBack.onUnSupported then
		-- 		self.m_lastCallBack.onUnSupported(self.m_lastPayData)
		-- 	else
		-- 		self:showMutiPay(self.m_lastPayData)
		-- 	end
		-- end
		-- return;
	end
end

function UnitePay:setChargeInfo(payId, bundleData, callBack)
	self.m_lastPayId = payId
	self.m_lastPayData = bundleData
	self.m_lastCallBack = callBack
end

-- 拉取商品列表
function UnitePay:requestChargeList(force)
	local pay = self:getPayByPmode(UniteBasePmode)
	if pay then
		pay:requestChargeList(force)
	else
		AlarmTip.play("默认支付pmode设置有误！");
	end
end

function UnitePay:requestChargeConfig(force)
	printInfo("检查充值配置信息")
	local config = self:getConfig()

	if PlatformConfig.currPlatform == PlatformConfig.basePlatform or
	PlatformConfig.currPlatform == PlatformConfig.GDTPlatform then
		if #config == 0 or force then
			printInfo("检查充值方式配置")
			GameSocketMgr:sendMsg(Command.PAY_CONFIG_PHP_REQUEST, {}, false);
		end
	else
	-- [[ 联运平台读取本地支付配置 ]]
		PlatformManager.getInstance():executeAdapter(PlatformManager.s_cmds.AdapteChargeConfig);
	end
end

function UnitePay:initPayConfig(jsonData)
	local status = jsonData.status;
	local msg = jsonData.msg;
	if status == 1 then
		local list = jsonData.data
		if list then
			UnitePaySupportConfigMap = {}
			for i = 1, #list do
				local id = tonumber(list[i].id);			-- 支付id
				local limit = tonumber(list[i].limit);  	-- 限额 -1：不限， 0：超过限额 >0:剩余额度
				local tips = tonumber(list[i].tips); 		-- 提示
				printInfo("initPayConfig id = " .. tostring(id) .. ", limit = " .. tostring(limit) .. ", tips = " .. tostring(tips))
				if limit ~= 0 and UnitePayConfigMap[id] then -- 未超过限额 则表示支持该支付
					table.insert(UnitePaySupportConfigMap, {
						id = id,
						limit = limit,
						tips = tips,
					})
				end
			end
			return true
		end
	else
		AlarmTip.play(msg)
	end
end

-- 登录成功后调用的接口返回
function UnitePay:onRequestPayConfig(data)
	printInfo("UnitePay:onRequestPayConfig")
	-- self:initPayConfig(data)
	local payconfigTable = {}
	for k, v in pairs(data.data) do
		local temp = {}
		temp.pclientid = v.id
		temp.plimit = v.limit
		temp.ptips = v.tips
		payconfigTable[#payconfigTable + 1] = temp
	end 
	PayController:initPayConfig(payconfigTable)
end

-- 支付流程为 pay -> requestPayConfigForLimit -> createOrder -> twiceClick -> createOrderReal
-- 每次下单之前调用的接口返回
function UnitePay:onRequestPayConfigForLimit(jsonData)
	if self:initPayConfig(jsonData) then
		if System.getPlatform() == kPlatformIOS and self.m_lastPayData then
			local pay
			-- 如果支付屏蔽开关没有变化，且之前选用的支付方式当前 还支持
			if not ShieldData:getMutiPayChanged() and self.m_lastPayId and UnitePayConfigMap[self.m_lastPayId] then
				pay = self:getPayByPayId(self.m_lastPayId)
			else
				-- 需要重新选择合适的支付方式
				local config = self:autoSelectPayConfig(self.m_lastPayData)
			 	pay = config and self:getPayByPayId(config.id)
			end
			-- 苹果不再判断限额了
			if pay then
				pay:createOrder(self.m_lastPayData)
			else
				self:showMutiPay(self.m_lastPayData)
			end
		elseif self.m_lastPayId and self.m_lastPayData then
			local pay = self:getPayByPayId(self.m_lastPayId)
			if pay then
				local pamount = self.m_lastPayData.goodsInfo and self.m_lastPayData.goodsInfo.pamount
				if not pay:isOverLimitByPamout(pamount) then
					pay:createOrder(self.m_lastPayData)
				else
					--TODO 超限额的时候 如果是最后一个短信 则弹选择面板
					if self.m_lastCallBack and self.m_lastCallBack.onUnSupported then
						self.m_lastCallBack.onUnSupported(self.m_lastPayData)
					else
						self:showMutiPay(self.m_lastPayData)
					end
				end
			else -- 已然不支持了
				AlarmTip.play("不支持当前支付方式");
				self:showMutiPay(self.m_lastPayData)
			end
		end
	end
end

-- UnitePay.httpRequestsCallBackFuncMap = {
-- 	[HttpModule.s_cmds.RequestChargeList] = UnitePay.onReceiveChargeList,
-- 	[HttpModule.s_cmds.RequestPayOrder] = UnitePay.onRequestOrderBack,下单HTTP回调
-- 	[HttpModule.s_cmds.RequestPayConfig] = UnitePay.onRequestPayConfig,
-- 	[HttpModule.s_cmds.RequestPayConfigForLimit] = UnitePay.onRequestPayConfigForLimit,
-- }

UnitePay.s_severCmdEventFuncMap = {
	[Command.PAY_PHP_REQUEST]				= UnitePay.onReceiveChargeList,
	[Command.PAY_CONFIG_PHP_REQUEST]		= UnitePay.onRequestPayConfig,
	[Command.ORDER_PHP_REQUEST]				= UnitePay.onRequestOrderBack,
	[Command.PAY_CONFIG_LIMIT_PHP_REQUEST]	= UnitePay.onRequestPayConfigForLimit,
}


function UnitePay:onHttpRequestsCallBack(command, ...)
	if self.s_severCmdEventFuncMap and self.s_severCmdEventFuncMap[command] then
     	self.s_severCmdEventFuncMap[command](self,...);
	end
end
