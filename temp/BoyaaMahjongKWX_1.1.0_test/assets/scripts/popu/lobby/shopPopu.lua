
local ShopPopu = class(require("popu.gameWindow"))

local Tag_None = 0
local Tag_Coin = 1
local Tag_Goods = 2
local Tag_Exchange = 3
local Tag_Record = 4
local Tag_Jewels = 5

function ShopPopu:ctor()
    self:shieldFunction()
    GameSetting:setIsSecondScene(true)
    self.recordList = {}
end

--是否动画资源
function ShopPopu:dtor(viewConfig, data)
   ShopPopu.super.dtor(self,viewConfig,data)
   
   	if(type(self.coinflashs) == "table" ) then
      	for k,v in pairs(self.coinflashs) do
         	if( typeof(v,AtomAnimNode) ) then
            	v:release();
         	end
	  	end
   	end	
end

function ShopPopu:onClickTag(tag)
	if self.curTag == tag then
		return
	end
	self.curTag = tag
	printInfo("ShopPopu:onClickTag : %d", tag)
	local btn_coin = self:findChildByName("btn_coin"):show()
	local btn_goods = self:findChildByName("btn_goods"):show()
	local btn_exchange = self:findChildByName("btn_exchange"):show()
	-- local btn_record = self:findChildByName("btn_record"):show()
	local btn_jewel = self:findChildByName("btn_jewel"):show()

	local btn_coinClicked = self:findChildByName("btn_coinClicked"):hide()
	local btn_goodsClicked = self:findChildByName("btn_goodsClicked"):hide()
	local btn_exchangeClicked = self:findChildByName("btn_exchangeClicked"):hide()
	-- local btn_recordClicked = self:findChildByName("btn_jewelClicked"):hide()
	local btn_jewelClicked = self:findChildByName("btn_jewelClicked"):hide()

	if Tag_Coin == tag then
		btn_coin:hide()
		btn_coinClicked:show()
		self:showCoinTagView()
	elseif Tag_Goods == tag then
		btn_goods:hide()
		btn_goodsClicked:show()
		self:showGoodsTagView()
	elseif Tag_Exchange == tag then
		btn_exchange:hide()
		btn_exchangeClicked:show()
		self:showExchangeTagView()
	elseif Tag_Jewels == tag then
		btn_jewel:hide()
		btn_jewelClicked:show()
		self:showJewelTagView()
		-- self:showRecordTagView()
	end 
end

function ShopPopu:initView(data, tag)
	-- tag事件
	local btn_coin = self:findChildByName("btn_coin")
	local btn_goods = self:findChildByName("btn_goods")
	local btn_exchange = self:findChildByName("btn_exchange")
	local btn_jewel = self:findChildByName("btn_jewel")
	-- local btn_record = self:findChildByName("btn_record")
	btn_coin:setOnClick(self, function(self)
		self:onClickTag(Tag_Coin)
	end)
	btn_goods:setOnClick(self, function(self)
    if ShieldData:getAllFlag() then
      AlarmTip.play("敬请期待")
    else
      self:onClickTag(Tag_Goods)
    end
	end)
	btn_exchange:setOnClick(self, function(self)
    if ShieldData:getAllFlag() then
      AlarmTip.play("敬请期待")
    else
      self:onClickTag(Tag_Exchange)
    end
	end)
	btn_jewel:setOnClick(self, function(self)
    if ShieldData:getAllFlag() then
      AlarmTip.play("敬请期待")
    else
      self:onClickTag(Tag_Jewels)
    end
	end)

	self.coinflashs = {};
	local backBtn = self:findChildByName("btn_back");
	backBtn:setOnClick(self, function ( self )
		-- body
		self:dismiss(true);
	end);

	local btn_record = self:findChildByName("btn_record");
	btn_record:setOnClick(self, function ( self )
		-- body
		
	end);

	btn_record:enableAnim(false);

	--金币变化回调
	UIEx.bind(self, MyUserData, "money", function(value)
		self:setMoney(value)
	end)
	--钻石变化回调
	UIEx.bind(self, MyUserData, "jewel", function(value)
		self:setJewel(value)
	end)

	--初始化金币
	self:setMoney(MyUserData:getMoney());
	--初始化钻石
	self:setJewel(MyUserData:getJewel());

	UIEx.bind(self, MyUserData, "huaFei", function(value)
		self:setHuaFei(value)
	end)
	self:setHuaFei(MyUserData:getHuaFei())

	if #PayController:getAllGoodsTable() == 0 then
		GameSocketMgr:sendMsg(Command.PAY_PHP_REQUEST, {['sid']=PlatformConfig.sid, ['appid']=PlatformConfig.visitorPayAppid, ['pmode']=UniteBasePmode});
	end

	self.curTag = Tag_None
    self:onClickTag(tag or Tag_Jewels)
end

function ShopPopu:initjewel()
	-- body
	self.jewelTagView = self:findChildByName("view_jewel");
	self.jewelTagView:removeAllChildren();

	local viewWidth, viewHeight = self.jewelTagView:getSize();
	-- ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png");
	local scrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false);
	scrollView:setScrollBarWidth(8);
	local goodsTable = PayController:getAllGoodsTable(1)
	local count = #goodsTable
	for i = 1, count do
		local payData 	= goodsTable[i];
		local item 		= self:createCoinItem(payData);
		local w, h 		= item:getSize();
		item:setPos(30 + ((i-1) % 2) * (50 + w), 15 + math.floor((i-1) / 2) * (h+15))
		scrollView:addChild(item);
	end
	scrollView:setSize(scrollView:getSize());
	self.jewelTagView:addChild(scrollView);
end

function ShopPopu:initShop()
	-- body
	self.coinTagView = self:findChildByName("view_shop");
	self.coinTagView:removeAllChildren();

	local viewWidth, viewHeight = self.coinTagView:getSize();
	-- ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png");
	local shopScrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false);
	shopScrollView:setScrollBarWidth(8);
	local goodsTable = PayController:getAllGoodsTable(0)
	local count = #goodsTable
	for i = 1, count do
		local payData 	= goodsTable[i];
		local item 		= self:createCoinItem(payData);
		local w, h 		= item:getSize();
		item:setPos(30 + ((i-1) % 2) * (50 + w), 15 + math.floor((i-1) / 2) * (h+15))
		shopScrollView:addChild(item);
	end
	shopScrollView:setSize(shopScrollView:getSize());
	self.coinTagView:addChild(shopScrollView);
end

function ShopPopu:initGoods()
	self.goodsTagView = self:findChildByName("view_goods")
	self.goodsTagView:removeAllChildren();

	local viewWidth, viewHeight = self.goodsTagView:getSize();
	-- ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")
	local shopScrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false);
	shopScrollView:setScrollBarWidth(8);
	local count = MyGoodsData:count();
	for i = 1, count do
		local exchangeData 	= MyGoodsData:get(i);
		local item 		= self:createGoodsItem(exchangeData);
		local w, h 		= item:getSize();
		item:setPos(30 + ((i-1) % 2) * (50 + w), 15 + math.floor((i-1) / 2) * (h+15))
		shopScrollView:addChild(item);
	end
	shopScrollView:setSize(shopScrollView:getSize());
	self.goodsTagView:addChild(shopScrollView);
	if MyExchangeData:count() == 0 then
		GameSocketMgr:sendMsg(Command.EXCHANGE_LIST_REQUEST, {});
	end
end

function ShopPopu:initExchange()
	self.exchangeTagView = self:findChildByName("view_exchange")
	self.exchangeTagView:removeAllChildren();

	local viewWidth, viewHeight = self.exchangeTagView:getSize();
	-- ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")
	local shopScrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false);
	shopScrollView:setScrollBarWidth(8);
	local count = MyExchangeData:count();
	for i = 1, count do
		local exchangeData 	= MyExchangeData:get(i);
		local item 		= self:createExchangeItem(exchangeData);
		local w, h 		= item:getSize();
		item:setPos(30 + ((i-1) % 2) * (50 + w), 15 + math.floor((i-1) / 2) * (h+15))
		shopScrollView:addChild(item);
	end
	shopScrollView:setSize(shopScrollView:getSize());
	self.exchangeTagView:addChild(shopScrollView);
	if MyExchangeData:count() == 0 then
		GameSocketMgr:sendMsg(Command.EXCHANGE_LIST_REQUEST, {});
	end
end

function ShopPopu:initRecord()
	self.recordTagView = self:findChildByName("img_viewRecord")

	local viewWidth, viewHeight = self.recordTagView:getSize();
	-- ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")
	local shopScrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false);
	shopScrollView:setScrollBarWidth(8);
	local count = #self.recordList;
	printInfo("self.recordList count : %d",count)
	for i = 1, count do
		local recordData 	= self.recordList[i];
		local item 		= self:createRecordItem(recordData);
		local w, h 		= item:getSize();
		printInfo("pos x : %d, y : %d",50,h * (i - 1))
		item:setPos(50, h * (i - 1))
		shopScrollView:addChild(item);
	end
	shopScrollView:setSize(shopScrollView:getSize());
	self.recordTagView:addChild(shopScrollView);
	if #self.recordList == 0 then
		GameSocketMgr:sendMsg(Command.EXCHANGE_RECORD_REQUEST, {});
	end
end

function ShopPopu:setMoney( money )
	local LobbyCoinNode	= require("lobby/ui/lobbyCoinNode")
	local coinNode 		= new(LobbyCoinNode);
	coinNode:setNumber(ToolKit.skipMoney(money));
	local coinView 		= self:findChildByName("view_coin");
	coinView:removeAllChildren();
	coinView:addChild(coinNode);
	coinNode:setAlign(kAlignLeft);
end

function ShopPopu:setHuaFei( huaFei )
	local LobbyCoinNode	= require("lobby/ui/lobbyCoinNode")
	local coinNode 		= new(LobbyCoinNode);
	coinNode:setNumber(ToolKit.skipMoney(huaFei));
	local coinView 		= self:findChildByName("view_huaFei");
	coinView:removeAllChildren();
	coinView:addChild(coinNode);
	coinNode:setAlign(kAlignLeft);
end

function ShopPopu:setJewel( jewel )
	local LobbyCoinNode	= require("lobby/ui/lobbyCoinNode")
	local jewelNode 		= new(LobbyCoinNode);
	jewelNode:setNumber(ToolKit.skipMoney(jewel));
	local jewelView 		= self:findChildByName("view_jewelnode");
	jewelView:removeAllChildren();
	jewelView:addChild(jewelNode);
	jewelNode:setAlign(kAlignLeft);
end

-- private
function ShopPopu:showJewelTagView()
	if self.exchangeTagView then self.exchangeTagView:hide() end
	if self.goodsTagView then self.goodsTagView:hide() end
	if self.coinTagView then self.coinTagView:hide() end
	-- if self.recordTagView then self.recordTagView:hide() end
	if self.jewelTagView then
		self.jewelTagView:show()
		return
	end
	printInfo("ShopPopu:showCoinTagView，重新创建")
	self:initjewel()
end

function ShopPopu:showCoinTagView()
	if self.exchangeTagView then self.exchangeTagView:hide() end
	if self.goodsTagView then self.goodsTagView:hide() end
	if self.jewelTagView then self.jewelTagView:hide() end
	if self.coinTagView then
		self.coinTagView:show()
		return
	end
	printInfo("ShopPopu:showCoinTagView，重新创建")
	self:initShop()
end

function ShopPopu:showGoodsTagView( ... )
	-- body
	if self.exchangeTagView then self.exchangeTagView:hide() end
	if self.coinTagView then self.coinTagView:hide() end
	if self.jewelTagView then self.jewelTagView:hide() end
	if self.goodsTagView then
		self.goodsTagView:show()
		return
	end
	printInfo("ShopPopu:showCoinTagView，重新创建")
	self:initGoods()
end

function ShopPopu:showExchangeTagView()
	if self.coinTagView then self.coinTagView:hide() end
	if self.goodsTagView then self.goodsTagView:hide() end
	if self.jewelTagView then self.jewelTagView:hide() end
	if self.exchangeTagView then
		self.exchangeTagView:show()
		return
	end
	printInfo("ShopPopu:showExchangeTagView，重新创建")
	self:initExchange()
	self.exchangeTagView:show()
end

function ShopPopu:showRecordTagView()
	if self.exchangeTagView then self.exchangeTagView:hide() end
	if self.goodsTagView then self.goodsTagView:hide() end
	if self.coinTagView then self.coinTagView:hide() end
	if self.recordTagView then
		self.recordTagView:show()
		return
	end
	self:initRecord()
	self.recordTagView:show()
end

function ShopPopu:createCoinItem(data)
	local item = new(Node)
	local btn_select = UIFactory.createButton("kwx_shop/btn_select.png")
	local w , h = btn_select:getSize()
	item:setSize(w + 20, h)
	item:addChild(btn_select)
	btn_select:setPos(20, 0)

	local img_pic = UIFactory.createImage("kwx_shop/img_pic.png")
						:addTo(btn_select)
						:pos(17, 11)
    DownloadImage:downloadOneImage(data.pimg, img_pic)
	-- 添加动画
	local posTable = {
		{x = 8, y = 45},
		{x = 20, y = 60},
		{x = 40, y = 50},
		{x = 55, y = 30},
		{x = 60, y = 60},
		{x = 80, y = 50},
	}
	for i = 1, 6 do
		local tempLight = UIFactory.createImage("kwx_shop/img_light.png")
							:addTo(img_pic)
		tempLight:setPos(posTable[i].x, posTable[i].y)
		tempLight:addPropTransparency(1, kAnimLoop , 1000, 10 * i, 0.0, 1.0)
	end

	local prams = {}
	prams.text = data.pname
	prams.size = 30
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(160, 34)
	prams = {}
	prams.text = data.pamount.."元"
	prams.size = 30
	local color = {}
	color.r = 0xFF
	color.g = 0xf0
	color.b = 0x22
	prams.color = color
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(20, -32)
			:align(kAlignRight)
	UIFactory.createImage("kwx_shop/img_split.png")
			:addTo(btn_select)
			:pos(160, 82)
	prams = {}
	prams.text = data.pdesc
	prams.size = 26
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(160, 100)
	-- local img_tag = UIFactory.createImage("kwx_shop/img_pic.png")

	btn_select:setOnClick(self, function ( self )
		globalRequestCharge(data);
	end);

	-- 推广类型
	-- local sptype = data:getSptype()
	-- if 0 < sptype then
	-- 	local imgSptype = "kwx_shop/img_remen.png"
	-- 	if 1 == sptype then
	-- 		imgSptype = "kwx_shop/img_remen.png"
	-- 	elseif 2 == sptype then
	-- 		imgSptype = "kwx_shop/img_cuxiao.png"
	-- 	elseif 3 == sptype then
	-- 		imgSptype = "kwx_shop/img_zhekou.png"
	-- 	end
	-- 	local img_sptype = new(Image, imgSptype)
	-- 							:addTo(btn_select)
	-- end
	return item;
end


function ShopPopu:createGoodsItem(data)
	local item = new(Node)
	local btn_select = UIFactory.createButton("kwx_shop/btn_select.png")
	local w , h = btn_select:getSize()
	item:setSize(w + 20, h)
	item:addChild(btn_select)
	btn_select:setPos(20, 0)

	local img_pic = UIFactory.createImage("kwx_shop/img_defalutHuaFei.png")
						:addTo(btn_select)
						:pos(20, 20)
						-- :setSize(90,90)
	DownloadImage:downloadOneImage(data:getImage(), img_pic)

	local prams = {}
	prams.text = data:getName()
	prams.size = 30
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(160, 35)
	prams = {}
	prams.text = ""
	if data:getCoupons() > 0 then
		prams.text = data:getCoupons().."话费劵"
	elseif data:getMoney() > 0 then
		prams.text = data:getMoney().."金币"
	end
	prams.size = 30
	local color = {}
	color.r = 0xFF
	color.g = 0xf0
	color.b = 0x22
	prams.color = color
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(20, -32)
			:align(kAlignRight)
	UIFactory.createImage("kwx_shop/img_split.png")
			:addTo(btn_select)
			:pos(160, 82)
	prams = {}
	prams.text = data:getGoodsdes()
	prams.size = 26
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(160, 100)
	-- local img_tag = UIFactory.createImage("kwx_shop/img_pic.png")

	btn_select:setOnClick(self, function ( self )
		-- 如果话费劵不足
		-- local huaFei = MyUserData:getHuaFei()
		-- if huaFei < (data:getCoupons() or 0) then
		-- 	AlarmTip.play("您的话费劵不足，无法兑换该商品！")
		-- 	return
		-- end
		WindowManager:showWindow(WindowTag.GoodsBuyPopu, data)

	end);

	-- 推广类型
	local sptype = data:getSptype()
	if 0 < sptype then
		local imgSptype = "kwx_shop/img_remen.png"
		if 1 == sptype then
			imgSptype = "kwx_shop/img_remen.png"
		elseif 6 == sptype then
			imgSptype = "kwx_shop/img_cuxiao.png"
		elseif 3 == sptype then
			imgSptype = "kwx_shop/img_youhui.png"
		elseif 5 == sptype then
			imgSptype = "kwx_shop/img_zhekou.png"
		end
		local img_sptype = new(Image, imgSptype)
								:addTo(btn_select)
	end
	return item;
end

function ShopPopu:createExchangeItem(data)
	local item = new(Node)
	local btn_select = UIFactory.createButton("kwx_shop/btn_select.png")
	local w , h = btn_select:getSize()
	item:setSize(w + 20, h)
	item:addChild(btn_select)
	btn_select:setPos(20, 0)

	local img_pic = UIFactory.createImage("kwx_shop/img_defalutHuaFei.png")
						:addTo(btn_select)
						:pos(20, 20)
	DownloadImage:downloadOneImage(data:getImage(), img_pic)

	local prams = {}
	prams.text = data:getName()
	prams.size = 30
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(160, 35)
	prams = {}
	prams.text = ""
	if data:getCoupons() > 0 then
		prams.text = data:getCoupons().."话费劵"
	elseif data:getMoney() > 0 then
		prams.text = data:getMoney().."金币"
	end
	prams.size = 30
	local color = {}
	color.r = 0xFF
	color.g = 0xf0
	color.b = 0x22
	prams.color = color
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(20, -32)
			:align(kAlignRight)
	UIFactory.createImage("kwx_shop/img_split.png")
			:addTo(btn_select)
			:pos(160, 82)
	prams = {}
	prams.text = data:getGoodsdes()
	prams.size = 26
	UIFactory.createText(prams)
			:addTo(btn_select)
			:pos(160, 100)
	-- local img_tag = UIFactory.createImage("kwx_shop/img_pic.png")

	btn_select:setOnClick(self, function ( self )
		-- 如果话费劵不足
		local huaFei = MyUserData:getHuaFei()
		if huaFei < (data:getCoupons() or 0) then
			AlarmTip.play("您的话费劵不足，无法兑换该商品！")
			return
		end
		-- 如果是实物
		if 3 == data:getGoodstype() then
			WindowManager:showWindow(WindowTag.ExchangeInfoPopu, data)
			return
		end
		local goodsInfo = {};
		goodsInfo.id = data:getId();
		goodsInfo.cid = data:getCid();
		goodsInfo.num = 1
		GameSocketMgr:sendMsg(Command.EXCHANGE_GOODS_REQUEST, goodsInfo)
		self:dismiss()
	end);

	-- 推广类型
	local sptype = data:getSptype()
	if 0 < sptype then
		local imgSptype = "kwx_shop/img_remen.png"
		if 1 == sptype then
			imgSptype = "kwx_shop/img_remen.png"
		elseif 2 == sptype then
			imgSptype = "kwx_shop/img_cuxiao.png"
		elseif 3 == sptype then
			imgSptype = "kwx_shop/img_zhekou.png"
		end
		local img_sptype = new(Image, imgSptype)
								:addTo(btn_select)
	end

	return item;
end

function ShopPopu:createRecordItem(data)
	local exchangeRecordItem = require(ViewPath.."exchangeRecordItem")
	local item = SceneLoader.load(exchangeRecordItem)
	local img_picture = item:findChildByName("img_picture")
	local text_desc = item:findChildByName("text_desc")
	local text_title = item:findChildByName("text_title")
	local text_status = item:findChildByName("text_status")

	DownloadImage:downloadOneImage(data.img, img_picture)

	text_title:setText(data.gname or "")
	text_desc:setText("购买时间："..(data.time or ""))
	text_status:setText("状态："..(data.status or ""))
	local btn_look = item:findChildByName("btn_look")
	btn_look:setOnClick(self, function(self)
		data.isLook = true
		WindowManager:showWindow(WindowTag.ExchangeInfoPopu, data)
	end)
	return item;
end

function ShopPopu:onPayResponse(data)
	self:initShop();
end

function ShopPopu:onExchangeListResponse(data)
	self:initExchange();
end

function ShopPopu:onExchangeGoodsResponse(data)
	printInfo("ShopPopu:onExchangeGoodsResponse")
	if not data or 1 ~= data.status or not data.data then
		return
	end
	GameSocketMgr:sendMsg(Command.EXCHANGE_RECORD_REQUEST, {});
	data = data.data
	if 1 == data.status then
		local money = MyUserData:getMoney()
		local huaFei = MyUserData:getHuaFei()
		money = money - (data.money or 0)
		huaFei = huaFei - (data.coupons or 0)
		MyUserData:setMoney(money)
		MyUserData:setHuaFei(huaFei)
		AlarmTip.play(data.msg or "")
	else
		AlarmTip.play(data.msg or "")
	end
end

function ShopPopu:onExchangeRecordResponse(data)
	printInfo("ShopPopu:onExchangeRecordResponse")
	if 1 ~= data.status or not data.data then
		return
	end
	self.recordList = data.data
	self:initRecord()
end

function ShopPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return ShopPopu.super.dismiss(self, ...)
end

function ShopPopu:shieldFunction()
	local huafei = self.m_root:findChildByName("img_huaFeiBg")
	if ShieldData:getAllFlag() then
		if huafei then huafei:hide() end
	else
		if huafei then huafei:show() end
	end
end


--[[
	通用的（大厅）协议
]]
ShopPopu.s_severCmdEventFuncMap = {
	[Command.PAY_PHP_REQUEST]		= ShopPopu.onPayResponse,
	[Command.EXCHANGE_LIST_REQUEST]		= ShopPopu.onExchangeListResponse,
	--[Command.EXCHANGE_GOODS_REQUEST]				= ShopPopu.onExchangeGoodsResponse,
	[Command.EXCHANGE_RECORD_REQUEST]				= ShopPopu.onExchangeRecordResponse,
}

return ShopPopu