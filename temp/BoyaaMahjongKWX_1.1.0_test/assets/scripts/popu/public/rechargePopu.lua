local RechargePopu = class(require("popu.gameWindow"))

function RechargePopu:initView(data)
	local chargeType = data.chargeType
	local level = data.level
	local gameType = data.gameType
	local title = self.m_root:findChildByName("text_title")
	local tipText = self.m_root:findChildByName("text_brokeTips")
	local leftBtn = self.m_root:findChildByName("left_btn")
	local closeBtn = self.m_root:findChildByName("btn_close")

	closeBtn:setOnClick(nil, function()
		self:dismiss(true)
	end)

	local chargeBtn = self.m_root:findChildByName("btn_confirm")
	chargeBtn:setOnClick(nil, function()
		-- 根据goodsInfo
		dump(self.goodsInfo)
		if self.goodsInfo then
			globalRequestCharge(self.goodsInfo);
		end
		self.m_chargeFlag = true
		self:dismiss(true)
	end)

	
	if chargeType == ChargeType.NotEnoughMoney then
		title:setText("金币不足")
		tipText:setText("亲，您持有的金币不足，无法继续游戏！")
		leftBtn:show()
		leftBtn:setOnClick(nil, function()
			--可以正常准备
			if app:isInRoom() then
				app:requestChangeDesk(ChangeDeskType.Down)
				self:dismiss(true)
			else
				local levelConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney()
				if levelConfig then
					app:requestEnterRoom(levelConfig:getLevel(), true)
				end
			end
		end)
		chargeBtn:pos(150, 0)
	elseif chargeType == ChargeType.BrokeCharge and not app:isInGame() then
		title:setText("您破产了")
		tipText:setText("亲，您被打破产了！无法继续游戏。")

	elseif chargeType == ChargeType.JewelCharge then
		title:setText("钻石不足")
		tipText:setText("亲，您拥有的钻石不足，无法开设包厢。")

	else
		title:setText("快速购买")
		tipText:setText("购买超值金币, 体验精彩游戏！")
	end
	
	self.goodsTable = {}
	if ChargeType.JewelCharge == chargeType then
		self.goodsTable = PayController:getAllGoodsTable(1)
	else 
		self.goodsTable = PayController:getAllGoodsTable(0)
	end

	local switchBtn = self.m_root:findChildByName("btn_switch")
	switchBtn:setOnClick(nil, function()
		local count = #self.goodsTable
		printInfo("count = %d, index = %d", count, self.goodsIndex)
		if self.goodsIndex >= count then
			self:switchGoodsByIndex(1)
		else
			self:switchGoodsByIndex(self.goodsIndex + 1)				
		end
	end)

	self.chargeType = chargeType
	self.goodsIndex = data.goodsIndex
	self.goodsInfo = data.goodsInfo
	self:switchGoodsByIndex(self.goodsIndex)
end

function RechargePopu:switchGoodsByIndex(goodsIndex)
	local paySubject  	= self.m_root:findChildByName("pay_subject")
	local payDesc 		= self.m_root:findChildByName("pay_desc")
	local cionCoin 		= self.m_root:findChildByName("icon_coin")
	local cionJewel		= self.m_root:findChildByName("icon_jewel")
	local imgIcon 		= self.m_root:findChildByName("img_icon")
	local goodsInfo 	= self.goodsTable[goodsIndex]

	if self.chargeType == ChargeType.JewelCharge then
		cionCoin:hide()
		cionJewel:show()
	else
		cionCoin:show()
		cionJewel:hide()
	end

	if goodsInfo then
		paySubject:setText(goodsInfo.pdesc)
		payDesc:setText(string.format("%s=%s元", goodsInfo.pname, goodsInfo.pamount))
		self.goodsInfo = goodsInfo
		self.goodsIndex = goodsIndex
	end
end

function RechargePopu:onHidenEnd(...)
    RechargePopu.super.onHidenEnd(self, ...)
end

function RechargePopu:dtor()
end

return RechargePopu