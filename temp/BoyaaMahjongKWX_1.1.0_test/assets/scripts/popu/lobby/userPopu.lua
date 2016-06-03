
local UserPopu = class(require("popu.gameWindow"))
local goodsInfoItem = require(ViewPath .. "goodsInfoItem")

local printInfo, printError = overridePrint("UserPopu")


-- [标签]
local Label_MyUserInfo 	= 1
local Label_GoodsInfo 	= 2

function UserPopu:ctor()
	EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
    GameSetting:setIsSecondScene(true)
    self.m_sex = MyUserData:getSex()
		self:shieldFunction()
end

function UserPopu:dtor()

	EventDispatcher.getInstance():unregister(Event.Call, self, self.onNativeCallBack);
end

function UserPopu:dismiss()
	printInfo("UserPopu:dismiss")
	local nick 		= MyUserData:getNick();
	local nickText 	= self:findChildByName("et_nick"):getText();

	local param 	= {};

	local doit = false

	if nick ~= nickText then
		doit = true;
		param['nick'] = nickText;
	end

	local sex = MyUserData:getSex() or 0
	if self.m_sex and self.m_sex ~= sex then
		doit = true
		param['sex'] = self.m_sex
	end

	-- "do":0,                          // 修改项 （0:基础信息（nick,sex,tid） 1:头像）
 --        /*******************基础信息******************/
 --        "nick":"哈哈",                    // 昵称
 --        "sex":1,                         // 性别
 --        "tid":1,                         // 称号

 	if doit then
		GameSocketMgr:sendMsg(Command.MODIFY_USERINFO_PHP_REQUEST, param, false);
	end
	GameSetting:setIsSecondScene(false)
	return self.super.dismiss(self);
end

function UserPopu:initView(data)
	--返回
	local bgImage = self:findChildByName("img_bg");

	-- 物品list
	self.mGoodsList				= {}
	self.mGoodsDataList			= {}
	self.mCurOptionGoodsId		= 0

	-- 标签按钮
	self:findChildByName("btn_myInfo"):setOnClick(self, function ( self )
		-- body
		self:changeLabel(Label_MyUserInfo)
	end) 
	
	self:findChildByName("btn_goodsInfo"):setOnClick(self, function ( self )
		-- body
		self:changeLabel(Label_GoodsInfo)
	end) 

	local backBtn = self:findChildByName("btn_back");
	backBtn:setOnClick(self, function ( self )
		-- body
		self:dismiss(true);
	end);

	backBtn:enableAnim(false);
	--修改头像
	self:findChildByName("btn_portrait"):setOnClick(self, function ( self )
		-- body
		WindowManager:showWindow(WindowTag.PortraitPopu, {});
	end);

	--男
	self:findChildByName("btn_male"):setOnClick(self, function ( self )
		self:setSex(0)
	end);

	--女
	self:findChildByName("btn_female"):setOnClick(self, function ( self )
		self:setSex(1)
	end);

	--充值
	self:findChildByName("btn_recharge"):setOnClick(self, function ( self )
		-- body
		app:selectGoodsForChargeVarMoney()
	end);

	--使用
	self:findChildByName("btn_use"):setOnClick(self, function ( self )
		-- body
		self:showWindowForGoodsId(self.mCurOptionGoodsId)
	end);

	local btnAuthenticate = self:findChildByName("btn_authenticate");

	UIEx.bind(btnAuthenticate, MyBaseInfoData, "antiAddiction", function(value)
		if value == 0 then
			btnAuthenticate:setOnClick(self, function ( self )
				WindowManager:showWindow(WindowTag.AntiAddictionPopu, {});
			end);
			local hasAuthNode = self:findChildByName("view_renZheng")
			hasAuthNode:setVisible(false)
			btnAuthenticate:setVisible(true)
		else
			local hasAuthNode = self:findChildByName("view_renZheng")
			hasAuthNode:setVisible(true)
			btnAuthenticate:setVisible(false)
		end
	end)

	local text_huaFei = self:findChildByName("text_huaFei")
	text_huaFei:setText(MyUserData:getHuaFei())

	local text_jewel = self:findChildByName("text_jewel")
	text_jewel:setText(MyUserData:getJewel())

	MyBaseInfoData:setAntiAddiction(MyUserData:getVerifyed());

	local editNick = self:findChildByName("et_nick");

	editNick:setOnTextChange(self, function ( self )
		if string.len(editNick:getText()) > 20 then
			editNick:setText(ToolKit.subStr(editNick:getText(), 20, 1, true));
		end
	end);

	-- GameSocketMgr:sendMsg(Command.USERINFO_PHP_REQUEST, {}, false);

	self:changeLabel(Label_MyUserInfo)

	-- 初始化用户数据
	self:init(MyUserData);


end

--
function UserPopu:init( userData )
	-- body
	self:setNickname(userData:getNick());
	self:setSex(userData:getSex());
	self:setId(userData:getId());
	self:setCoin(userData:getMoney());
	self:setUserHead(userData:getHeadName())
	self:setUserLevel(userData:getLevel(), userData:getNeedExp() > 0 and userData:getCurExp() * 100 / userData:getNeedExp() or 0);
	self:setRecord(userData:getWintimes(), userData:getDrawtimes(), userData:getLosetimes(), userData:getZhanjiRate());
end

--设置昵称
function UserPopu:setNickname( nickname )
	-- body
	self:findChildByName("et_nick"):setText(nickname or "");
end

function UserPopu:setUserHead(headName)

	if self.m_headImage then
		self.m_headImage:removeSelf()
		self.m_headImage = nil;
	end

	local headView 		= self:findChildByName("img_portrait")
	local width, height = headView:getSize()

	--如果是默认头像，不加遮罩

	self.m_headImage = new(Mask, headName, "kwx_uesrInfo/mask_head.png");

	self.m_headImage:setSize(width , height)
	self.m_headImage:setName("headImage")
	self.m_headImage:addTo(headView):align(kAlignCenter)
	UIEx.bind(self.m_headImage, MyUserData, "headName", function(value)
		if MyUserData:getId() ~= 0 then
			self:setUserHead(MyUserData:getHeadName())
		end
	end)
end

--设置性别
function UserPopu:setSex( sex )
	if not sex or sex == 0 then
		self:findChildByName("btn_male"):setFile("kwx_tanKuang/login/img_checked.png");
		self:findChildByName("btn_female"):setFile("kwx_tanKuang/login/img_check.png");
		self.m_sex = 0;
	elseif sex == 1 then
		self:findChildByName("btn_male"):setFile("kwx_tanKuang/login/img_check.png");
		self:findChildByName("btn_female"):setFile("kwx_tanKuang/login/img_checked.png");
		self.m_sex = 1;
	end
	self:setUserHead(MyUserData:getHeadName(sex))
end

--设置金币
function UserPopu:setCoin( coin )
	-- body
	local coinText = self:findChildByName("text_coin")
	coinText:setText(ToolKit.skipMoney(coin or ""));
	UIEx.bind(coinText, MyUserData, "money", function(value)
		if MyUserData:getId() ~= 0 then
			coinText:setText(ToolKit.skipMoney(value or ""))
		end
	end)
end

--设置战绩
function UserPopu:setRecord( wintimes, drawtimes, losetimes, zhanjiRate )
	-- body
	local total 	= wintimes + drawtimes + losetimes;
	self:findChildByName("text_record"):setText(string.format("%d胜/%d负/%d平(胜率：%s)", wintimes, losetimes, drawtimes, zhanjiRate));
end

--设置等级
function UserPopu:setUserLevel( lv, percent )
	-- body
	self:findChildByName("text_lv"):setText("Lv." .. lv);
end


--设置玩家ID
function UserPopu:setId( id )
	-- body
	self:findChildByName("text_userid"):setText("游客ID：" .. id or "");
end


function UserPopu:onUserInfoResponse(data)
	printInfo("UserPopu:onUserInfoResponse");
	if data.status == 1 then
		MyUserData:setId(data.data.mid);
		MyUserData:setNick(data.data.nick);
		MyUserData:setSex(data.data.sex)
		MyUserData:setMoney(data.data.money);
		MyUserData:setWintimes(data.data.wintimes);
		MyUserData:setDrawtimes(data.data.drawtimes);
		MyUserData:setLosetimes(data.data.losetimes);
		MyUserData:setExp(data.data.exp);
		MyUserData:setCurExp(data.data.exp_cur);
		MyUserData:setNeedExp(data.data.exp_need);
		MyUserData:setLevel(data.data.level);
		self:init(MyUserData);
	else
		printInfo("error");
	end
end

function UserPopu:onAntiAddictionResponse( data )
	if not data or 1 ~= data.status then
		return
	end
	-- body
	if data.data and tonumber(data.data.status) == 1 then
		MyUserData:setVerifyed(1)
		MyBaseInfoData:setAntiAddiction(MyUserData:getVerifyed());
		AlarmTip.play(data.data.msg or "认证成功");
	else
		AlarmTip.play(data.data.msg or "认证失败");
	end
end


--native callback
function UserPopu:onNativeCallBack(key, result)
	if key == kTakePhoto or key == kPickPhoto then
		if result then
			MyUserData:setUploadTemp(result.name:get_value())
			self.m_headImage:setFile(result.name:get_value())
			-- upload image
			---- NativeEvent.getInstance():uploadImage(HallConfig:getDomain()..HallConfig:getUploadHost(), result.name:get_value(), 1);
			NativeEvent.getInstance():uploadImage(
						ConnectModule.getInstance():getDomain()..
						ConnectModule.getInstance():getUploadHost(), result.name:get_value(), 1);
		else
			AlarmTip.play("保存头像失败")
		end
	end
end

function UserPopu:onSignBQGetAwardResponse( data )
	-- body
	for i = 1, table.getn(self.mGoodsList) do

		if self.mGoodsList[i].id == MyGoodsData.TypeBqCard then
			self.mGoodsList[i].itemNum:setText(MyGoodsData:getGoodsNumById(MyGoodsData.TypeBqCard))
			return
		end
	end
end

function UserPopu:shieldFunction()
	local huafei = self:findChildByName("view_huaFei")
	local shiming = self:findChildByName("btn_authenticate")
	if ShieldData:getAllFlag() then
		if huafei then huafei:hide() end
		if shiming then shiming:hide() end
	end
end

function UserPopu:changeLabel( label )
	-- body
	if Label_GoodsInfo == label then
		self:findChildByName("btn_myInfo"):setEnable(true)
		self:findChildByName("btn_goodsInfo"):setEnable(false)

		self:findChildByName("img_myInfoN"):show()
		self:findChildByName("img_myInfoP"):hide()
		self:findChildByName("img_goodsInfoN"):hide()
		self:findChildByName("img_goodsInfoP"):show()	

		self:findChildByName("view_myUserInfo"):hide()	
		self:findChildByName("view_goodsInfo"):show()	

		self:showGoodsList()
		
	elseif Label_MyUserInfo == label then
		self:findChildByName("btn_myInfo"):setEnable(false)
		self:findChildByName("btn_goodsInfo"):setEnable(true)

		self:findChildByName("img_myInfoN"):hide()
		self:findChildByName("img_myInfoP"):show()
		self:findChildByName("img_goodsInfoN"):show()
		self:findChildByName("img_goodsInfoP"):hide()

		self:findChildByName("view_myUserInfo"):show()	
		self:findChildByName("view_goodsInfo"):hide()	

	end
end

function UserPopu:showMyUserInfo( ... )
	-- body
	local bqGoodsItem = self:findChildByName(MyGoodsData.TypeBqCard)
	if bqGoodsItem then
		bqGoodsItem:findChildByName("text_goodsNum"):setText(data:getNum())
	end
end

function UserPopu:createGoodsListItem( data )
	-- body
	item = SceneLoader.load(goodsInfoItem):findChildByName("view_goodsItem")


	item:findChildByName("text_goodsName"):setText(ToolKit.formatNick(data:getName(), 5))
	-- item:findChildByName("text_goodsName"):setText(data:getName())

	-- 设置道具图片
	local img_goodsMark = item:findChildByName("img_goodsIco")
	local img_pic = UIFactory.createImage("kwx_shop/img_defalutHuaFei.png")
	    :addTo(img_goodsMark)
	    :pos(0, 0)
	    -- :setSize(100,100)
	img_pic:setAlign(kAlignCenter);
  	DownloadImage:downloadOneImage(data:getImage(), img_pic)

  	-- 设置选择中状态
  	local imgOptionState = item:findChildByName("img_optionState")
  	imgOptionState:hide()
	imgOptionState:setName(data:getId())

	-- 数量
	local count = data:getNum()
	text_goodsNum = item:findChildByName("text_goodsNum")
	if count > 99 then count = "…" end
	text_goodsNum:setText(count)

	-- 道具item单击
	local btn_item = item:findChildByName("btn_goodsItem")
	btn_item:setOnClick(self, function ( self )

		for i = 1, table.getn(self.mGoodsList)  do

			local itemData = self.mGoodsList[i]

			if itemData then
				-- 选中
				if itemData.id == data:getCid() then
					self.mCurOptionGoodsId = data:getCid()
					itemData.imgOptionState:show()
					itemData.item:findChildByName("text_goodsName"):setColor(0xff, 0xff, 0x00)

				else
					itemData.imgOptionState:hide()
					itemData.item:findChildByName("text_goodsName"):setColor(0xff, 0xff, 0xff)
				end
			end
		end
		-- 道具说明
		self:findChildByName("textview_goodsDes"):setText(data:getGoodsdes())

		if data:getCid() == MyGoodsData.TypeBqCard or 
			data:getCid() == MyGoodsData.TypeHorn or
			data:getCid() == MyGoodsData.TypeBackGift then
			self:findChildByName("btn_use"):setIsGray(false)

		else
			self:findChildByName("btn_use"):setIsGray(true)
		end

	end);


	return item, text_goodsNum, imgOptionState
end

function UserPopu:showGoodsList( ... )
	-- body
	local scrollViewGoodsList = self:findChildByName("scrollview_goodsList")
	scrollViewGoodsList:removeAllChildren(true)
	self.mGoodsList = {}

	-- 将两个表集合成一个表
	self.mGoodsDataList = {}
	for i = 1, MyGoodsData:count() do
		local data = MyGoodsData:get(i)
	    if data:getNum() > 0 then
			table.insert(self.mGoodsDataList, data)
		end
	end
	for i = 1, MyGiftPackData:count() do
		local data = MyGiftPackData:get(i)
	    if data:getNum() > 0 then
			table.insert(self.mGoodsDataList, data)
		end
	end

	local count = table.getn(self.mGoodsDataList);

	self:findChildByName("btn_use"):setIsGray(true)

	-- 无道具跳转商城
	if count <= 0 then
		self:findChildByName("text_goodstips"):show()
		local linkText = new(TextView, "前往商城", 130, 0, kAlignTopLeft, kFontTextUnderLine, 26, 0xFF, 0x00, 0x00);
		self:findChildByName("view_link"):addChild(linkText)
		linkText:setEventTouch(self, function(self, finger_action)
			if finger_action == kFingerDown then
				WindowManager:showWindow(WindowTag.ShopPopu, nil, WindowStyle.NORMAL, 2)
			end
		end);
		return
	else
	    self:findChildByName("text_goodstips"):hide()
	end

	local topH ,itemDisX ,itemDisY = 18, 235, 270

	local validCount = 0
	for i = 1, count do
	    local itemData = self.mGoodsDataList[i]

	    if itemData:getNum() > 0 then

	    	validCount = validCount + 1
		    local item, itemNum, imgOptionState = self:createGoodsListItem(itemData)
		    item:setPos( ((validCount - 1) % 3 ) * itemDisX, 18 + math.floor((validCount-1) / 3) * itemDisY )

		    scrollViewGoodsList:addChild(item)
			table.insert(self.mGoodsList, { 
				id = itemData:getCid(), 
				item = item, 
				itemNum = itemNum,
				imgOptionState = imgOptionState})

		end
	end
	
end

function UserPopu:showWindowForGoodsId( goodsid )
	-- body
	if MyGoodsData.TypeBqCard == goodsid then
		self:enter2Scene(WindowTag.SignAwardPopu, true, WindowStyle.POPUP);
		
	elseif MyGoodsData.TypeHorn == goodsid then 
		self:enter2Scene(WindowTag.ChatViewPopu, true);

	elseif goodsid == MyGoodsData.TypeBackGift then
		local goodsInfo = {};
	    goodsInfo.id = goodsid;
	    goodsInfo.num = 1
	    GameSocketMgr:sendMsg(Command.EXCHANGE_GOODS_REQUEST, goodsInfo)
	end
end

function UserPopu:updataGoodsListNum()
	-- body
	local curGoodsNum  = MyGoodsData:getGoodsNumById(self.mCurOptionGoodsId) or MyGiftPackData:getGoodsNumById(self.mCurOptionGoodsId)
	if curGoodsNum and curGoodsNum <= 0 then
		self:showGoodsList()
		return
	end

	for i = 1, table.getn(self.mGoodsList) do
		local item = self.mGoodsList[i]

		local count = MyGoodsData:getGoodsNumById(item.id) or MyGiftPackData:getGoodsNumById(item.id)
		if count and count > 99 then count = "…" end
		item.itemNum:setText(count)
	end
end

function UserPopu:enter2Scene( type, needLogin, style, tag )
	-- body
	WindowManager:showWindow(type, nil, style, tag);
end

function UserPopu:onExchangeGoodsResponse(data)
    -- body
    if self.mCurOptionGoodsId == MyGoodsData.TypeBackGift then
    	local count = MyGiftPackData:getGoodsNumById(self.mCurOptionGoodsId)
	    MyGiftPackData:setGoodsNumById(self.mCurOptionGoodsId, count-1)
    end

    self:updataGoodsListNum()
end

function UserPopu:onSignBQGetAwardResponse( data )
	-- body
	self:updataGoodsListNum()
end

function UserPopu:onSendHornMsgResponse( data )
	-- body
	self:updataGoodsListNum()
end

function UserPopu:onServergbBroadcastGoodsData( data )
	-- body
	self:updataGoodsListNum()
end

--[[
	通用的（大厅）协议
]]
UserPopu.s_severCmdEventFuncMap = {
	[Command.USERINFO_PHP_REQUEST]			= UserPopu.onUserInfoResponse,
	[Command.ANTI_ADDICTION_PHP_REQUEST] 	= UserPopu.onAntiAddictionResponse,
    [Command.SIGN_BQ_GETAWARD_PHP_REQUEST] = UserPopu.onSignBQGetAwardResponse,
    [Command.EXCHANGE_GOODS_REQUEST]                = UserPopu.onExchangeGoodsResponse,
    [Command.SIGN_BQ_GETAWARD_PHP_REQUEST] = UserPopu.onSignBQGetAwardResponse,
	[Command.HORN_SEND_PHP_REQUEST]					= UserPopu.onSendHornMsgResponse,
    [Command.SERVERGB_BROADCAST_GOODSDATA]      = UserPopu.onServergbBroadcastGoodsData,
}


return UserPopu
