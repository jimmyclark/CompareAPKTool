--[[
	------------------ Please ReadMe ------------------
	业务侧必须要做的事
	1.配置并实现二次确认弹框，请参考 ctor 函数
	2.初始化 PayController，请参考 ctor 函数
	3.初始化支付配置 请参考函数 initPayConfig
	4.配置支付选择框
	4.点击商品，请参考函数 payForGoods
	5.配置实现下单接口，在 payConfigMap 文件中配置 PayConfigMap.createOrderIdObj 和 PayConfigMap.createOrderIdFuc
	6.下单成功则调用下单回调，请参考函数 createOrderCallback
]] 

local PayController = class()

--[[
	func ：初始化PayController
	mapPath : (string) 
]]
function PayController:ctor(mapPath)
	EventDispatcher.getInstance():register(Event.Call, self,self.onNativeCallDone)

	require(mapPath.."payConfigMap")
	self.m_supportConfigTable = {}
	self.m_canPayConfig = {}
	self.m_curPayInfo = {}
	self.m_nativePayConfigTable = {}
	-- 关于商品配置
	self.m_sid = nil
	self.m_appid = nil
	-- 商品列表
	self.m_goodsTable = {}
	self:privateInitSupportConfig()
end

-- 析构函数
function PayController:dtor()
	EventDispatcher.getInstance():unregister(Event.Call, self,self.onNativeCallDone)
end

-- 初始化支付配置, 必须调用，
-- 调用时机，登陆成功后拉取配置/支付成功或支付失败
--[[
	configTable table{
		pclientid : (int or string)   支付方式
		plimit : (int or string)  今天还能支付多少钱 -1是不限制  
		ptips : (int or string)   0/1 是否有二次弹框
	}
]]
function PayController:initPayConfig(configTable)
	self:privateInitPayConfig(configTable)
end

--[[
	func : 获取商品列表成功,从业务侧给到
	param table{
		{
			id : (int or string)     商品ID
			ptype : (int)            商品类型 0:金币
	        pamount : (int)          商品价格
	        pchips : (int)       对等金币
	        pcoins : (int)              对等博雅币
	        pcard : (int)                对等道具ID
	        pnum : (int)            数量
	        pname : (string)  商品名称
	        pimg : (string)  商品图片
	        pdesc : (string) 商品描述
	        psort : (int)    商品排序
		} 
	}
]] 
function PayController:requestGoodsTableCallback(goodsTable)
	self:privateRequestGoodsTableCallback(goodsTable)
end

--[[
	func : 获得能支持该商品的支付方式

	goodInfo : table{    商品信息
		pamount : (int or string) 商品金额
		pid  : (int or string) 商品id
		pname : (string) 商品名称
		ptype : (int or string) 商品类型，金币/钻石/博雅币(支付中心定义)
	}

	return : table{
		
	}
]]
function PayController:getPaySelectInfo(goodInfo)
	return self:privateGetPaySelectInfo(goodInfo)
end

--[[
	func : 调用支付的唯一入口
	isQuickPay : (bool) 是否为快速支付
		true : 快速支付，先判断第一优先级的支付方式是否可用，如果不行则使用第二优先级，以此类推...
		false : 弹出支付选择框
	goodInfo : table{    商品信息
		pamount : (int or string) 商品金额
		pid  : (int or string) 商品id
		pname : (string) 商品名称
		ptype : (int or string) 商品类型，金币/钻石/博雅币(支付中心定义)
		pmode : (int) 支付方式，由支付中心定义，(快速支付可以不传)
		pclientid : (int) 客户端自定义支付类型，(快速支付可以不传)
	}
	isShowChoose : (bool) 取消快速支付后显示选择支付框,(如果不是快速支付，可以忽略)
]]
function PayController:payForGoods(isQuickPay, goodInfo, isShowChoose)
	self:privatePayForGoods(isQuickPay, goodInfo, isShowChoose)
end

--[[
	func : 显示支付选择框

	goodInfo table{
		pamount : (int or string) 商品金额
		pid  : (int or string) 商品id
		pname : (string) 商品名称
		ptype : (int or string) 商品类型，金币/钻石/博雅币(支付中心定义)
	}

	return : bool 如果为false,则表示没有可用的支付方式
]]
function PayController:showPaySelectWindow(goodInfo)
	self:privateShowPaySelectWindow(goodInfo)
end

--[[
	func : 创建订单成功，从业务侧给到
	param table{
		order : (table) 支付中心下单的信息
		mid   :  (string or int) 业务侧的用户id
	}
]]
function PayController:createOrderCallback( orderTable )
	self:privateCreateOrderCallback(orderTable)
end

--[[
	func : 获取所有商品列表
	ptype : (int) 商品类型(不传则为所有)  0 (金币)  1 (钻石) 
	return : (table) 商品列表
]]
function PayController:getAllGoodsTable(ptype)
	return self:privateGetAllGoodsTable(ptype)
end

--[[
	func : 获取特定額度的商品信息
	pamount : (int) 商品額度
	ptype : (int) 商品类型(不传则为所有)  0 (金币)  1 (钻石)
	return : (table) 商品信息
]]
function PayController:getGoodsInfoByPamount(pamount, ptype)
	return self:privateGetGoodsInfoByPamount(pamount, ptype)
end

--[[
	func : 清除商品列表
]]
function PayController:clear()
	self:privateClear()
end

-- private
------------------------------ 这里是私有函数，不得侵犯 -------------------------------
-- 先初始化该平台下支持的支付方式
function PayController:privateInitSupportConfig()
	self.m_supportConfigTable = {}
	local config = self:paivateGetSupportPayConfig()
	self.m_nativePayConfigTable = config.payInfo
	if config.id then
		self.m_sid = config.id.sid
		self.m_appid = config.id.appid
	end
	for k , v in pairs(self.m_nativePayConfigTable) do
		local pclientid = tonumber(v.payType) or 0
		local quotaPamount = v.quotaPamount
		local pamountTable = {}
		if quotaPamount then pamountTable = string.split(quotaPamount, ",") end
		for p, q in pairs(PayConfigMap.m_allPayConfig) do
			if pclientid == tonumber(q.pclientid) then
				q.pamountTable = pamountTable
				self.m_supportConfigTable[#self.m_supportConfigTable + 1] = q
				break
			end
		end
	end
end

-- 初始化支付配置
function PayController:privateInitPayConfig(configTable)
	-- 这里必须先强校验
	if not self:checkConfigTable(configTable) then return end
	-- 将支持的支付方式和配置合并
	self.m_canPayConfig = {}
	for k, v in pairs(configTable) do
		for p, q in pairs(self.m_supportConfigTable) do
			if tonumber(v.pclientid) == tonumber(q.pclientid) then
				q.plimit = tonumber(v.plimit)
				q.ptips = tonumber(v.ptips)
				self.m_canPayConfig[#self.m_canPayConfig + 1] = q
			end
		end
	end
end

-- 获得能支持该商品的支付方式
function PayController:privateGetPaySelectInfo(goodInfo)
	local paySelectTable = {}
	if not goodInfo or not goodInfo.pamount then return paySelectTable end
	local pamount = tonumber(goodInfo.pamount)
	local tempTable = {}
	-- 先查找是否支付该额度,且短信只加一個
	local hasSms = false
	for k, v in pairs(self.m_canPayConfig) do
		if #v.pamountTable > 0 then
			for p, q in pairs(v.pamountTable) do
				if tonumber(q) == pamount then
					if v.ptypesim ~= kNoneSIM and not hasSms then
						hasSms = true
						tempTable[#tempTable + 1] = v
					end
					if v.ptypesim == kNoneSIM then
						tempTable[#tempTable + 1] = v
					end
					break
				end
			end
		else
			if v.ptypesim ~= kNoneSIM and not hasSms then
				hasSms = true
				tempTable[#tempTable + 1] = v
			end
			if v.ptypesim == kNoneSIM then
				tempTable[#tempTable + 1] = v
			end
		end
	end
	paySelectTable = tempTable
	tempTable = {}
	-- 当前限额是否满足该额度
	for k, v in pairs(paySelectTable) do
		plimit = v.plimit or -1
		if plimit == -1 or plimit >= pamount then
			tempTable[#tempTable + 1] = v
		end
	end
	paySelectTable = tempTable
	tempTable = {}
	return paySelectTable
end

-- 调用支付的唯一入口
function PayController:privatePayForGoods(isQuickPay, goodInfo, isShowChoose)
	if #self.m_canPayConfig <= 0 or not goodInfo then
		return
	end
	local paySelectTable = self:privateGetPaySelectInfo(goodInfo)
	if #paySelectTable <= 0 then return end
	local config = nil
	self.m_curPayInfo = {}
	self.m_curPayInfo.goodInfo = goodInfo
	-- 如果是快速充值，则直接走下单流程
	if isQuickPay then
		self.m_curPayInfo.isShowChoose = isShowChoose
		self.m_curPayInfo.goodInfo.pmode = paySelectTable[1].pmode
		self.m_curPayInfo.pclientid = paySelectTable[1].pclientid
		config = paySelectTable[1]
	else
		-- 从可用支付中找到该支付方式
		local pclientid = tonumber(goodInfo.pclientid)
		self.m_curPayInfo.pclientid = pclientid
		self.m_curPayInfo.goodInfo.pclientid = nil
		for k, v in pairs(paySelectTable) do
			if pclientid == v.pclientid then
				config = v
				break
			end
		end
	end
	if not config then return end
	-- 判断是否有营销页
	if config.ptips == 1 then
		if self:privateIsShowXiaoMiWindow() then return end
		local obj = PayConfigMap.showPayConfirmWindowObj
		local func = PayConfigMap.showPayConfirmWindowFuc

		local cancelFuc = self.closePayConfirmView
		local confrimFuc = self.privateCreateOrder
		func(obj, self.m_curPayInfo.goodInfo, confrimFuc, cancelFuc)
	else
		self:privateCreateOrder()
	end
end

-- 私有显示支付选择框
function PayController:privateShowPaySelectWindow(goodInfo)
	local paySelectInfo = self:getPaySelectInfo(goodInfo)
	-- printInfo("#paySelectInfo : %s", #paySelectInfo)
	if not paySelectInfo or #paySelectInfo <= 0 then  return false end
	local payInfo = {}
	payInfo.goodInfo = goodInfo
	payInfo.paySelectInfo = paySelectInfo
	local obj = PayConfigMap.showPaySelectWindowObj
	local func = PayConfigMap.showPaySelectWindowFuc
	func(obj, payInfo)
	return true
end

-- 调用原生获得该平台支持的支付方式
function PayController:paivateGetSupportPayConfig()
	local key = "native_getSupportPayConfig"
	dict_set_string(key, key..kparmPostfix, "")
	-- dict_set_string(kLuaCallEvent, kLuaCallEvent, key)
	-- call_native("OnLuaCall")
	call_native(key)
	local payStr = dict_get_string(key, key..kResultPostfix)
	if not payStr then
		payStr = "{\"id\":{\"sid\":\"7\",\"appid\":\"186\"},\"payInfo\":[{\"payType\":\"3\",\"quotaPamount\":\"2,6,10\"},{\"payType\":\"6\"},{\"payType\":\"1005\",\"quotaPamount\":\"0.1,1,2,5,6,10,20,30\"},{\"payType\":\"4\",\"quotaPamount\":\"0.01,0.1,0.5,1,2,6,10,15,20,30\"},{\"payType\":\"9\",\"quotaPamount\":\"1,2,5,6,30\"},{\"payType\":\"24\"},{\"payType\":\"27\"},{\"payType\":\"26\",\"quotaPamount\":\"2,6,20,30\"},{\"quotaPamount\":\"2,6,10,20,30\",\"appname\":\"博雅四川麻将\",\"imei\":\"865174029451074\",\"appversion\":\"5.1.5\",\"payType\":\"5\",\"serviceids\":\"130426000651,130426000652,130426000653,140326030379,140326030380\",\"mac\":\"3c:47:11:66:85:2a\",\"pmode\":\"109\",\"ext_appids\":\"001,002,003,005,006\",\"channelid\":\"00021488\"}]}"
	end
	local retTable
	if payStr then
		retTable = json.decode(payStr)
		-- printInfo("payStr : %s", payStr)
	end
	-- dump(retTable)
	return retTable
end

-- 取消营销页
function PayController:closePayConfirmView(isShowChoose)
	-- printInfo("PayController:closePayConfirmView")
	if self.m_curPayInfo.isShowChoose then
		-- printInfo("self.m_curPayInfo.isShowChoose is true")
		self:privateShowPaySelectWindow(self.m_curPayInfo.goodInfo)
	end
end

-- 是否顯示小米的提示信息
function PayController:privateIsShowXiaoMiWindow()
	-- 通過pmode找到支付方式
	local payConfig = {}
	for p, q in pairs(PayConfigMap.m_allPayConfig) do
		if tonumber(self.m_curPayInfo.goodInfo.pmode) == tonumber(q.pmode) then
			payConfig = q
			break
		end
	end
	if not payConfig then return end
	if payConfig.ptypesim ~= kNoneSIM then
		local func = PayConfigMap.showXiaoMiSmsWindowFuc
		local obj = PayConfigMap.showXiaoMiSmsWindowObj
		local cancelFuc = self.closePayConfirmView
		if func and obj and func(obj, cancelFuc) then
			self.m_curPayInfo.isShowChoose = true
			return true
		end
	end
end

-- 下单, 即创建订单
function PayController:privateCreateOrder()
	if not self.m_curPayInfo.goodInfo then return end
	if self:privateIsShowXiaoMiWindow() then return end
 	local obj = PayConfigMap.createOrderIdObj
	local func = PayConfigMap.createOrderIdFuc
	if self.m_sid and self.m_appid then
		-- self.m_curPayInfo.goodInfo.pmode = 109
		-- self.m_curPayInfo.goodInfo.pclientid = 5
		self.m_curPayInfo.goodInfo.sid = self.m_sid
		self.m_curPayInfo.goodInfo.appid = self.m_appid
		-- 联通沃支付特殊处理
		local pmode = tonumber(self.m_curPayInfo.goodInfo.pmode)
		if pmode == 109 or pmode == 437 then
			-- 首先从原生支持支付方式中找到联通沃的信息
			local pclientid = tonumber(self.m_curPayInfo.pclientid)
			-- 是第几个商品
			local index = 1
			for k, v in pairs(self.m_supportConfigTable) do
				local pamount = tonumber(self.m_curPayInfo.goodInfo.pamount)
				if tonumber(v.pclientid) == pclientid then
					for p, q in pairs(v.pamountTable) do
						if tonumber(q) == pamount then
							index = tonumber(p)
							break
						end
					end
				end
			end
			for k, v in pairs(self.m_nativePayConfigTable) do
				local tpclientid = tonumber(v.payType) or 0
				if pclientid == tpclientid then
					self.m_curPayInfo.goodInfo.appname = v.appname or ""
					self.m_curPayInfo.goodInfo.feename = self.m_curPayInfo.goodInfo.pname
					self.m_curPayInfo.goodInfo.mac = v.mac or "00000000"
					self.m_curPayInfo.goodInfo.mac = string.gsub(self.m_curPayInfo.goodInfo.mac, ":", "")
					self.m_curPayInfo.goodInfo.imei = v.imei or ""
					self.m_curPayInfo.goodInfo.appversion = v.appversion or ""
					self.m_curPayInfo.goodInfo.channelid = v.channelid or ""
					local serviceids = v.serviceids
					local serviceidsTable = {}
					if serviceids then serviceidsTable = string.split(serviceids, ",") end
					local ext_appids = v.ext_appids
					local ext_appidsTable = {}
					if ext_appids then ext_appidsTable = string.split(ext_appids, ",") end
					self.m_curPayInfo.goodInfo.serviceid = serviceidsTable[index] or ""
					self.m_curPayInfo.goodInfo.ext_appid = ext_appidsTable[index] or ""
				end
			end 
		end
		-- dump(self.m_curPayInfo.goodInfo)
		func(obj, self.m_curPayInfo.goodInfo)
	end
end

-- 调起支付进行支付
function PayController:callPay(orderTable)
	local key = "payPlatform"
	orderTable.payType = self.m_curPayInfo.pclientid

	dict_set_string(key, key..kparmPostfix, json.encode(orderTable))
	dict_set_string(kLuaCallEvent, kLuaCallEvent, key)

	-- printInfo("PayController:callPay")
	-- dump(orderTable)

	call_native(key)
end

-- 校验支付配置是否合理
function PayController:checkConfigTable(configTable)
	if type(configTable) ~= "table" then return end
	for k, v in pairs(configTable) do
		if not tonumber(v.pclientid) then return end
		if not tonumber(v.plimit) then return end
		if not tonumber(v.ptips) then return end
	end
	return true
end

-- 校验下单数据是否完整
function PayController:checkOrderTable(orderTable)
	if type(orderTable) ~= "table" then return end
	local orderId = orderTable.ORDER
	if not orderId or tonumber(orderId) == 0 or tostring(orderId) == "0" or tostring(orderId) == "" then
		return
	end
	return true
end

-- 原生调用,支付失败，或者取消
function PayController:onNativeCallDone()
	local key = dict_get_string(kcallEvent, kcallEvent)
	if "SubmitPay" == key then
		local jsonData = dict_get_string(key, key .. kResultPostfix)
		local luaTable = json.decode(jsonData)
		local status = tonumber(luaTable.status) or 0
	 	-- 支付取消，失败，限制等等
		if 1 ~= status then
			if self.m_curPayInfo.isShowChoose then
				self:privateShowPaySelectWindow(self.m_curPayInfo.goodInfo)
			end
		end
	end
end

-- 创建订单成功，从业务侧给到
function PayController:privateCreateOrderCallback(orderTable)
	-- 校验数据
	if not self:checkOrderTable(orderTable) then return end
	-- 调用原生开启支付之路
	self:callPay(orderTable)
end

-- 获取商品列表成功，从业务侧给到
function PayController:privateRequestGoodsTableCallback(goodsTable)
	printInfo("PayController:privateRequestGoodsTableCallback")
	if not goodsTable or #goodsTable <= 0 then return end
	self.m_goodsTable = goodsTable
end

-- 获取所有商品列表
function PayController:privateGetAllGoodsTable(ptype)
	self.m_goodsTable = self.m_goodsTable or {}
	ptype = tonumber(ptype)
	if not ptype then return self.m_goodsTable end
	local tempGoodsTable = {}
	for k , v in pairs(self.m_goodsTable) do
		if ptype == v.ptype then
			tempGoodsTable[#tempGoodsTable + 1] = v
		end
	end
	return tempGoodsTable
end

-- 获取特定額度的商品信息
function PayController:privateGetGoodsInfoByPamount(pamount, ptype)
	if not pamount then return end
	local tempGoodsTable = self:privateGetAllGoodsTable(ptype)
	for k, v in pairs(tempGoodsTable) do
		if tonumber(pamount) == tonumber(v.pamount) then
			return tonumber(k), v
		end
	end
end

-- 清除商品列表
function PayController:privateClear()
	self.m_goodsTable = {}
end

return PayController

