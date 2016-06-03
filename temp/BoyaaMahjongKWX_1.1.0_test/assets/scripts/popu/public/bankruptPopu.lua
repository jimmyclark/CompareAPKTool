local BankruptPopu = class(require("popu.gameWindow"))

function BankruptPopu:ctor()
	printInfo("BankruptPopu:ctor")
end

function BankruptPopu:initView(data)
	local chargeType = data.chargeType
	local level = data.level
	local gameType = data.gameType
	local title = self.m_root:findChildByName("text_title")
	local tipText = self.m_root:findChildByName("text_brokeTips")
	local closeBtn = self.m_root:findChildByName("btn_close")

	closeBtn:setOnClick(nil, function()
		self:dismiss(true)
	end)

	local chargeBtn = self.m_root:findChildByName("btn_confirm")
	chargeBtn:setOnClick(nil, function()
		-- 根据goodsInfo
		dump(self.goodsInfo)
		if self.goodsInfo then
			globalRequestCharge(self.goodsInfo, {}, false);
		end
		self.m_chargeFlag = true
		self:dismiss(true)
	end)
	self.goodsTable = PayController:getAllGoodsTable(0)
	local count = #self.goodsTable
	local switchBtn = self.m_root:findChildByName("btn_switch")
	switchBtn:setOnClick(nil, function()
		printInfo("count = %d, index = %d", count, self.goodsIndex)
		if self.goodsIndex >= count then
			self:switchGoodsByIndex(1)
		else
			self:switchGoodsByIndex(self.goodsIndex + 1)				
		end
	end)

	self.btn_getAward = self:findChildByName("btn_getAward")
	self.btn_getAward:setPickable(false)
	self.btn_getAward:setOnClick(self, function(self)
		GameSocketMgr:sendMsg(Command.PO_CHAN_PHP_REQUEST, {}, false)
	end)

	self.chargeType = chargeType
	self.goodsIndex = data.goodsIndex
	self.goodsInfo = data.goodsInfo
	self:switchGoodsByIndex(self.goodsIndex)

	GameSocketMgr:sendMsg(Command.PO_CHAN_TIME_PHP_REQUEST, {act = "gettime"}, false)
end

function BankruptPopu:switchGoodsByIndex(goodsIndex)
	local paySubject  	= self.m_root:findChildByName("pay_subject")
	local payDesc 		= self.m_root:findChildByName("pay_desc")
	local imgIcon 		= self.m_root:findChildByName("img_icon")
	local goodsInfo 	= self.goodsTable[goodsIndex]

	if goodsInfo then
		paySubject:setText(goodsInfo.pdesc)
		payDesc:setText(string.format("%s=%s元", goodsInfo.pname, goodsInfo.pamount))
		self.goodsInfo = goodsInfo
		self.goodsIndex = goodsIndex
	end
end

function BankruptPopu:onPoChanAwardResponse(data)
	local status = data.data.status or 0
	AlarmTip.play(data.data.msg or "")
	if 1 == status then
		printInfo("BankruptPopu:onPoChanTimeResponse")
		MyUserData:addMoney(data.data.money or 0, true)
		if app:isInRoom() then
			GameSocketMgr:sendMsg(Command.NoticeMoneyChangeReq, { iUserId = MyUserData:getId() })
		end
		self.btn_getAward:setFile("kwx_common/btn_gray_small.png")
		self.btn_getAward:setPickable(false)
	elseif 0 == status then
		self.btn_getAward:setFile("kwx_common/btn_gray_small.png")
		self.btn_getAward:setPickable(false)
		local time = tonumber(data.data.time)
		if not time then
			return
		end
		delete(self.mTimeAnim)
		self.mTimeAnim = nil
		self.mTimeAnim = new(AnimInt, kAnimRepeat, 0, 1000, 1000, 0)
		self.mTimeAnim:setEvent(self, function(self)
			self:showBankruptTime(time)
			time = time - 1
			if time < 0 then
				delete(self.mTimeAnim)
				self.mTimeAnim = nil
				self.btn_getAward:setFile("kwx_common/btn_blue_small.png")
				self.btn_getAward:setPickable(true)
			end
		end)
	end
end

function BankruptPopu:onPoChanTimeResponse(data)
	local status = data.data.status or 0
	if 1 == status then
		printInfo("BankruptPopu:onPoChanTimeResponse")
		local time = tonumber(data.data.time) or 10
		delete(self.mTimeAnim)
		self.mTimeAnim = nil
		self.mTimeAnim = new(AnimInt, kAnimRepeat, 0, 1000, 1000, 0)
		self.mTimeAnim:setEvent(self, function(self)
			self:showBankruptTime(time)
			time = time - 1
			if time < 0 then
				delete(self.mTimeAnim)
				self.mTimeAnim = nil
				self.btn_getAward:setFile("kwx_common/btn_blue_small.png")
				self.btn_getAward:setPickable(true)
			end
		end)
	else
		AlarmTip.play(data.data.msg or "");
	end
end

function BankruptPopu:showBankruptTime(time)
	if not time then
		return
	end
	local t = {}
		for i = 1, 4 do
			t[i] = 0
		end
	local m, n = math.modf(time / 60)
	m = m % 100
	if m >= 10 then
		t[1] , t[2] = math.modf(m / 10)
		t[2] = m % 10
	else
		t[1] , t[2] = 0, m
	end
	n = time % 60
	if n >= 10 then
		t[3] , t[4] = math.modf(n / 10)
		t[4] = n % 10
	else
		t[3] , t[4] = 0, n
	end
	for i = 1, 4 do
		local img_di = self:findChildByName(string.format("img_number%d",i))
		local img_number = img_di:findChildByName("img_number")
		img_number:setFile(string.format("kwx_tanKuang/bankrupt/%d.png",t[i]))
	end
end

function BankruptPopu:onPHPRequestsCallBack(command, ...)
	if self.s_severCmdEventFuncMap[command] then
     	self.s_severCmdEventFuncMap[command](self,...)
	end 
end

function BankruptPopu:onHidenEnd(...)
	printInfo("BankruptPopu:onHidenEnd")
    BankruptPopu.super.onHidenEnd(self, ...)
end

function BankruptPopu:dtor()
	printInfo("BankruptPopu:dtor")
	delete(self.mTimeAnim)
	self.mTimeAnim = nil
end

BankruptPopu.s_severCmdEventFuncMap = {
    [Command.PO_CHAN_PHP_REQUEST]   = BankruptPopu.onPoChanAwardResponse,
    [Command.PO_CHAN_TIME_PHP_REQUEST]   = BankruptPopu.onPoChanTimeResponse,
}

return BankruptPopu