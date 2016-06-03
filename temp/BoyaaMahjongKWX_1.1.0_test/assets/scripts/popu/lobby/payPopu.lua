local PayPopu = class(require("popu.gameWindow"))

function PayPopu:initView(data)
	--返回
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		self:dismiss();
	end);

	self:findChildByName("text_goodsInfo"):setText("商品："..(data.goodInfo.pname or ""));
	self:findChildByName("text_goodsPrice"):setText("价格："..(data.goodInfo.pamount or "").."元");

	local pamount 			= data.goodInfo and data.goodInfo.pamount
	local name 				= data.goodInfo and data.goodInfo.name

	-- SMS_PAY 		= -1,   -- 短信支付
	-- ALI_PAY			= 2,   -- 支付宝支付
	-- CREDITCARD_PAY	= 3,   -- 信用卡支付
	-- MOBILEMM_PAY	= 4,   -- 移动MM支付
	-- UNICOM_PAY		= 5,   -- 联通沃支付
	-- UNION_PAY		= 6,   -- 银联支付
	-- TELECOM_PAY		= 7,   -- 电信支付
	-- WECHAT_PAY		= 8,   -- 微信支付

	local btnCount = #data.paySelectInfo

	for i = 1, btnCount do
		local payBtn = self:findChildByName(string.format("btn_pay_%d", i))
		payBtn:findChildByName("text_text"):setText(data.paySelectInfo[i].ptypename or "")
		payBtn:findChildByName("img_payIcon"):setFile("kwx_tanKuang/selectPay/"..data.paySelectInfo[i].pimage);
		payBtn:show()
		payBtn:setOnClick(self, function(self)
			printInfo("payBtn setOnClick")
			local goodInfo = data.goodInfo
			goodInfo.pmode = data.paySelectInfo[i].pmode
			goodInfo.pclientid = data.paySelectInfo[i].pclientid
			PayController:payForGoods(false, goodInfo)
			self:dismiss()
		end)
	end
end

function PayPopu:pay( type )
	-- body
end

return PayPopu