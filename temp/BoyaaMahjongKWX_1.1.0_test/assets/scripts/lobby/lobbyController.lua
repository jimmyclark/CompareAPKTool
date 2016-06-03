require("ui/ex/mask")
local LobbyCoinNode			= require("lobby/ui/lobbyCoinNode")

local LobbyController = class(BaseController)
local printInfo, printError = overridePrint("LobbyController")

LobbyController.s_controls = {

	nickName			= 14, --大厅昵称
	headView 			= 15, --大厅头像节点,用来添加头像
	coinView 			= 16, --大厅金币节点,用来添加金币
	quickStartBtn       = 17, --快速开始按钮
	settingBtn 			= 18, --大厅设置按钮
}

GameMode = {
	quickGame 	= 1, -- 快速娱乐
	createRoom 	= 2, -- 开设包间
	entryRoom 	= 3, -- 进入包间
}

function LobbyController:ctor(viewConfig, ...)
	testLobbyScene = self
	printInfo("大厅控制器ctor")
	printInfo("display.width, height = "..display.width..", "..display.height)
	self:loadUi();
	--注册HTTP回调
	EventDispatcher.getInstance():register(HttpModule.s_event, self, self.onHttpRequestsCallBack);
	EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
	EventDispatcher.getInstance():register(Event.Shield, self, self.shieldFunction);
	--连接服务器
	if not LobbyAutoLogin then
		GameSocketMgr:openSocket();
		LobbyAutoLogin = true
	end
	-- 第二次回到大厅更新配置
	--HallConfig:freshNetConfig()
	local view_paomadeng = self:findChildByName("view_paomadeng")
	BroadcastPaoMaDeng:setDelegate(self, view_paomadeng)
	--大厅有些显示内容审核的时候需要屏蔽，所以先进行一次屏蔽，防止没拉到屏蔽配置就显示大厅。后面会再次进行屏蔽判断。
	self:shieldFunction()

end

function LobbyController:setQuickStartBtnAnim()
	if not self.quickStartAnim then
		self:quickStartBtnAddAnim()
		self.quickStartAnim = new(AnimInt, kAnimRepeat, 0, 1, 8000, -1)
		self.quickStartAnim:setEvent(self, function(self)
			self:quickStartBtnAddAnim()
		end)
	end
end

function LobbyController:quickStartBtnAddAnim()
	local quickStart = self:findChildByName("btn_quickStart")
	quickStart:removeAllChildren()
	quickStart:setOnClick(self, function( self )
		self:onStartBtnClick()
	end)

	local w, h = quickStart:getSize()
	local iw, ih = 27, 27
	self.img_lightTable = {}
	local lightPosAndSize = {
		{
			animPos = { startX = 0.5, startY = 0.45, endX = 0.5, endY = 0.2},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 1.0, h = 1.0},
			time = 1000,
			delay = 100,
		},
		{
			animPos = { startX = 0.3, startY = 0.50, endX = 0.3, endY = 0.25},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.7, h = 0.7},
			time = 1000,
			delay = 150,
		},
		{
			animPos = { startX = 0.4, startY = 0.52, endX = 0.4, endY = 0.34},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.5, h = 0.5},
			time = 1000,
			delay = 200,
		},
		{
			animPos = { startX = 0.7, startY = 0.55, endX = 0.7, endY = 0.32},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.6, h = 0.6},
			time = 1000,
			delay = 500,
		},
		{
			animPos = { startX = 0.8, startY = 0.60, endX = 0.8, endY = 0.37},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.7, h = 0.7},
			time = 1000,
			delay = 600,
		},
		{
			animPos = { startX = 0.63, startY = 0.62, endX = 0.63, endY = 0.40},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.5, h = 0.5},
			time = 1000,
			delay = 700,
		},
		{
			animPos = { startX = 0.56, startY = 0.58, endX = 0.56, endY = 0.39},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.7, h = 0.7},
			time = 1000,
			delay = 800,
		},
		{
			animPos = { startX = 0.32, startY = 0.59, endX = 0.32, endY = 0.40},
			animTrans = { startT = 1.0, endT = 0.6 },
			size = { w = 0.5, h = 0.5},
			time = 1000,
			delay = 900,
		},
	}
	local img_big = UIFactory.createImage("kwx_anim/lobbyQuick/img_big.png")
	img_big:setSize(348, 124)
	quickStart:addChild(img_big)
	local scaleAnim = img_big:addPropScale(0, kAnimNormal, 1000, -1, 1.0, 1.15, 1.0, 1.15, kCenterDrawing)
	img_big:addPropTransparency(1, kAnimNormal, 1000, -1, 1.0, 0.3)
	scaleAnim:setEvent(self, function(self)
		img_big:removeProp(0)
		img_big:removeProp(1)
		img_big:hide()
		for i = 1 , #lightPosAndSize do
			local img_light = UIFactory.createImage("kwx_anim/lobbyQuick/img_light.png")
			img_light:setPos(lightPosAndSize[i].animPos.startX * w, lightPosAndSize[i].animPos.startY * h)
			img_light:setSize(lightPosAndSize[i].size.w * iw, lightPosAndSize[i].size.h * ih)
			quickStart:addChild(img_light)
			local diffX, diffY = lightPosAndSize[i].animPos.endX * w - lightPosAndSize[i].animPos.startX * w,
									lightPosAndSize[i].animPos.endY * h - lightPosAndSize[i].animPos.startY * h

			local startT, endT = lightPosAndSize[i].animTrans.startT, lightPosAndSize[i].animTrans.endT
			local delay = lightPosAndSize[i].delay
			local time = lightPosAndSize[i].time
			if delay > 0 then
				local tAnim = img_light:addPropTransparency(0, kAnimNormal, delay, -1, 1.1, 1.1)
				img_light:hide()
				tAnim:setEvent(self, function(self)
					img_light:removeProp(0)
					img_light:show()
					local transAnim = img_light:addPropTranslate(0, kAnimNormal, time, -1, 0, diffX, 0, diffY)
					-- addPropTransparency = function(self, sequence, animType, duration, delay, startValue, endValue)
					img_light:addPropTransparency(1, kAnimNormal, time, -1, startT, endT)
					img_light:addPropScale(2, kAnimNormal, time, -1, 1.0, 0.7, 1.0, 0.7, kCenterDrawing)
					transAnim:setEvent(self, function(self)
						quickStart:removeChild(img_light, true)
					end)
				end)
			else
				local transAnim = img_light:addPropTranslate(0, kAnimNormal, time, delay, 0, diffX, 0, diffY)
				-- addPropTransparency = function(self, sequence, animType, duration, delay, startValue, endValue)
				img_light:addPropTransparency(1, kAnimNormal, time, delay, startT, endT)
				img_light:addPropScale(2, kAnimNormal, time, delay, 1.0, 0.7, 1.0, 0.7, kCenterDrawing)
				transAnim:setEvent(self, function(self)
					quickStart:removeChild(img_light, true)
				end)
			end
		end
	end)
	FrameAnimManager:playAnim(FrameAnimManager.m_ctr.iLobbyQuick, quickStart)
end

function LobbyController:showSelectView()
	for i = 1, 3 do
		local btn_level = self:findChildByName(string.format("btn_level%d", i)) or self:findChildByName("btn_level1")
		local animNode = btn_level:findChildByName("animNode")
		-- FrameAnimManager:clearAnim(FrameAnimManager.m_ctr.iLobbySelectType, animNode)
	end
	local levelConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney()
	local btn_type = 1
	if levelConfig then
		btn_type = levelConfig:getType() or 1
		local btn_level = self:findChildByName(string.format("btn_level%d", btn_type)) or self:findChildByName("btn_level1")
		local animNode = btn_level:findChildByName("animNode")
		-- FrameAnimManager:playAnim(FrameAnimManager.m_ctr.iLobbySelectType, animNode)
		self:setQuickStartBtnAnim()
	end
end

--与大厅布局相关(适配分辨率)
function LobbyController:loadUi( )
    --播放入场动画
    local lastType = GameType.KWXMJ;
	self:bindUiNotice()

	-- 大厅一级界面按钮
	self.m_root:findChildByName("btn_quickgame"):setOnClick(self, function(self)
		self:onClickBtn_Select(GameMode.quickGame)
	end)
	self.m_root:findChildByName("btn_createroom"):setOnClick(self, function(self)
		self:onClickBtn_Select(GameMode.createRoom)
	end)
	self.m_root:findChildByName("btn_entryroom"):setOnClick(self, function(self)
		self:onClickBtn_Select(GameMode.entryRoom)
	end)

	self.m_root:findChildByName("btn_level1"):setOnClick(self, function(self)
		self:onclickBtn_level(1)
	end)
	self.m_root:findChildByName("btn_level2"):setOnClick(self, function(self)
		self:onclickBtn_level(2)
	end)
	self.m_root:findChildByName("btn_level3"):setOnClick(self, function(self)
		self:onclickBtn_level(3)
	end)

	--首充
	self.m_root:findChildByName("btn_firstCharge"):setOnClick(self, function ( self )
		-- body
		app:selectGoodsForChargeVarMoney()
	end);
	-- 签到
	self.m_root:findChildByName("btn_sign"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.SignAwardPopu, true, WindowStyle.POPUP);
	end);
	--账单
	self.m_root:findChildByName("btn_billing"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.billingPopu, true, WindowStyle.NORMAL);
	end);
	--商城
	self.m_root:findChildByName("btn_shop"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL);
	end);
	--排行
	self.m_root:findChildByName("btn_rank"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.RankPopu, true, WindowStyle.NORMAL);
	end);
	--任务
	self.m_root:findChildByName("btn_task"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.TaskPopu, true, WindowStyle.NORMAL);
	end);
	--活动
	self.m_root:findChildByName("btn_activity"):setOnClick(self, function ( self )
		-- body
		-- self:enter2Scene(WindowTag.ActivityPopu, true, WindowStyle.NORMAL);
		if ShieldData:getAllFlag() then
			AlarmTip.play("敬请期待")
			return
		end
		if app:checkCanEnter2Scene() then
			if System.getPlatform() == kPlatformIOS then
				self:enter2Scene(WindowTag.ActivityPopu, true, WindowStyle.NORMAL);
			else
				NativeEvent.getInstance():openWebView({})
			end
		end
		-- self:enter2Scene(WindowTag.ActivityPopu, true, WindowStyle.NORMAL);

	end);

	--兑换
	self.m_root:findChildByName("btn_exchange"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL, 3);
	end);

	--头像
	self.m_root:findChildByName("btn_head"):setOnClick(self, function ( self )
		-- body
		if not ShieldData:getAllFlag() then
			self:enter2Scene(WindowTag.UserPopu, true, WindowStyle.NORMAL);
		end

	end);

	--设置
	self.m_root:findChildByName("btn_setting"):setOnClick(self, function ( self )
		-- body
		self:enter2Scene(WindowTag.SettingPopu, false);
	end);

	--帮助
	self.m_root:findChildByName("btn_help"):setOnClick(self, function ( self )
		self:enter2Scene(WindowTag.HelpPopu, false, WindowStyle.NORMAL);
	end);

	-- 邮件
	self.m_root:findChildByName("btn_msg"):setOnClick(self, function ( self )
		self:enter2Scene(WindowTag.EMailPopu, false, WindowStyle.NORMAL);
	end);
	self:updateMailMsgNum()

	-- 点击金币
	self.m_root:findChildByName("img_coinBg"):setEventTouch(self, function(self, finger_action)
		if finger_action == kFingerDown then
			self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL, 1)
		end
	end);
	-- 点击话费
	self.m_root:findChildByName("img_huaFeiBg"):setEventTouch(self, function(self, finger_action)
		if finger_action == kFingerDown then
			self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL, 3)
		end
	end);
	-- 点击钻石
	self.m_root:findChildByName("img_jewel"):setEventTouch(self, function(self, finger_action)
		if finger_action == kFingerDown then
			self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL, 5)
		end
	end);
	-- 点击聊天
	self.m_root:findChildByName("view_paomadeng"):setEventTouch(self, function(self,  finger_action)
		-- body
		if finger_action == kFingerDown then
			self:enter2Scene(WindowTag.ChatViewPopu, true);
		end
	end)

	

	--返回
	self.m_root:findChildByName("btn_back"):setOnClick(self, function ( self )
		self:changeGameMode(1)
	end);

	self:changeGameMode(1)

end

function LobbyController:updateMailMsgNum()

	local count  = MyMailSystemData:count()
	local noReadCount = 0
	for i = 1, count do
		local data = MyMailSystemData:get(i)
		if 1 ~= data:getAward() then noReadCount = noReadCount + 1 end 
	end

	if 0 == noReadCount then
		self.m_root:findChildByName("img_mailmsgnum"):hide()
	else
		self.m_root:findChildByName("img_mailmsgnum"):show()

		if 9 < noReadCount then
			self.m_root:findChildByName("text_mailnum"):setText("…")
		else
			self.m_root:findChildByName("text_mailnum"):setText(noReadCount)
		end
	end
end

function LobbyController:changeGameMode( type )

	local view_bottom1 = self.m_root:findChildByName("view_bottom_1")
	local view_bottom2 = self.m_root:findChildByName("view_bottom_2")

	local view_top1 = self.m_root:findChildByName("view_top1")
	local view_top2 = self.m_root:findChildByName("view_top2")

	local view_quickgame = self.m_root:findChildByName("view_quickgame")
	local view_select = self.m_root:findChildByName("view_select")

	local view_logo = self.m_root:findChildByName("view_logo")
	local view_quicktitle = self.m_root:findChildByName("view_quicktitle")

	local buttom_bg = self.m_root:findChildByName("buttom_bg")

	if 1 == type then
		-- 一级界面
		view_top1:show()
		view_bottom1:show()
		view_select:show()
		view_logo:show()

		view_top2:hide()
		view_bottom2:hide()
		view_quickgame:hide()
		view_quicktitle:hide()

		buttom_bg:show()

	elseif 2 == type then
		-- 二级界面
		view_top1:hide()
		view_bottom1:hide()
		view_select:hide()
		view_logo:hide()

		view_top2:show()
		view_bottom2:show()
		view_quickgame:show()
		view_quicktitle:show()
		buttom_bg:hide()
	end
end

function LobbyController:onClickBtn_Select( type )
	if GameMode.quickGame == type then
		if 0 == GameConfig:getIsFristGame() then
			GameConfig:setIsFristGame(1)
			:save()
			app:quickStartGame()
		else
   			self:updateRoomConfigView()
			self:changeGameMode(2)
		end
	elseif GameMode.createRoom == type then
		local roundNUm = MyCreateRoomCfg:getRoundNum()
		local bei = MyCreateRoomCfg:getBei()
		if #roundNUm <= 0 or #bei <= 0 then
			AlarmTip.play("正在拉取配置，请稍后重试")
		else
			self:enter2Scene(WindowTag.createRoomPopu, true);
		end
	elseif GameMode.entryRoom == type then
		self:enter2Scene(WindowTag.entryRoomPopu, true);

	end 
end

function LobbyController:onclickBtn_level(levelType)
	if not app:checkCanEnter2Scene() then
		return
	end
	--printInfo("domain : HallConfig:getDomain() : %s", HallConfig:getDomain())
	printInfo("onclickBtn_level : %d",levelType)
	local money = MyUserData:getMoney()
	local newConfig = nil
	local hallConfigTable = MyLevelConfigData:getLevelConfigByType(levelType)
	-- 首先判断是不是破产了
	if app:checkIsBroke() then
		app:selectGoodsForChargeVarMoney({
			chargeType = ChargeType.BrokeCharge,
		})
		return
	end

	local minRequire , maxRequire
	for k , v in pairs(hallConfigTable) do
		printInfo("v:getUppermost() : %d", v:getUppermost())
		if not minRequire or minRequire > v:getRequire() then minRequire = v:getRequire() end
		if not maxRequire or maxRequire < v:getUppermost() then maxRequire = v:getUppermost() end
	 	if money >= v:getRequire() and money <= v:getUppermost() then
			if newConfig then
				if newConfig:getValue() < v:getValue() then
					newConfig = v
				end
			else
				newConfig = v
			end
		end
	end
	printInfo("minRequire ：%d, maxRequire: %d", (minRequire or 0), (maxRequire or 0))
	if not newConfig then
		-- 金币过少
		if minRequire and money < minRequire then
			printInfo("金币过少")
			app:selectGoodsForChargeByLevel({
				level = hallConfigTable[1],
				chargeType = ChargeType.NotEnoughMoney,
			})
		-- 金币过多
		elseif maxRequire and money > maxRequire then
			printInfo("金币过多")
			WindowManager:showWindow(WindowTag.MessageBox, {
				text = "您当前金币过高,去和高手过招吧！",
				leftText = "确认",
				singleBtn = true,
				leftFunc = function()
					self:onStartBtnClick()
				end
			}, WindowStyle.NORMAL)
		end
	else
		-- 我要进场
		printInfo("我要进的场次的金币底注是 : %d", newConfig:getValue())
		app:requestEnterRoom(newConfig:getLevel(), false)
	end
end

function LobbyController:enter2Scene( type, needLogin, style, tag )
	if needLogin and not app:checkCanEnter2Scene() then return end
	if app:checkEnterSceneIsShield(type) then return end
	-- body
	WindowManager:showWindow(type, nil, style, tag);
end

function LobbyController:resume(bundleData)
	LobbyController.super.resume(self)
	self:dealBundleData(bundleData)
	self:updateUserInfo()

	self:setTaskAwardsNum(MyBaseInfoData:getTaskAward());
	self:setActivitiesNum(MyActivitiesData:getActnum());

	NativeEvent.getInstance():CloseStartScreen()

	--ADD 返回大厅之后触发一次弹窗优先级
	EventDispatcher.getInstance():dispatch(Event.Message, "closePopu", {popuId = 0});


	FrameAnimManager:playAnim(FrameAnimManager.m_ctr.iLobbyBottom, self:findChildByName("buttom_bg"))
end

function LobbyController:setSettingNum(value)
	printInfo("LobbyController:setSettingNum : %d", value)
	local bubble_setting_img = self:findChildByName("bubble_setting_img")
	if value == 1 then
		bubble_setting_img:show()
	else
		bubble_setting_img:hide()
	end
end

function LobbyController:updateUserInfo()
	if MyUserData:getIsLogin() then
		self:setHeadImg(MyUserData:getHeadName())
		self:setCoin(MyUserData:getMoney())
		self:setHuaFei(MyUserData:getHuaFei())
		self:setJewel(MyUserData:getJewel())
		self:getControl(self.m_ctrl.nickName):setText(ToolKit.formatNick(MyUserData:getNick(),5))
	end
    app:judgeRequestSignInfo()
end

-- 切换到大厅界面后做些啥子
function LobbyController:dealBundleData(bundleData)
	printInfo("切换完成后，初始化信息")
	if not bundleData then return end
	printInfo("bundleData .. type =%d", bundleData.type)
	if bundleData.type == StateEvent.LoginRoomError then
		local reLogin = bundleData.reLogin
		-- 异地登陆， 禁止自动重连
		GameSetting:setDisableReconn(reLogin)
		if reLogin then
			GameSocketMgr:closeSocketSync()
		end
		WindowManager:showWindow(WindowTag.MessageBox, {
			text = bundleData.msgTip,
			leftText = reLogin and "重新登录" or "确认",
			singleBtn = true,
			leftFunc = function()
				if reLogin then
					GameSocketMgr:openSocket()
				end
			end
		}, WindowStyle.NORMAL)
	elseif bundleData.type == StateEvent.SocketClosed then
		WindowManager:showWindow(WindowTag.MessageBox, {
			text = "网络断开",
			leftText = "重新连接",
			singleBtn = true,
			leftFunc = function()
				GameSocketMgr:openSocket()
			end
		}, WindowStyle.NORMAL)
	elseif bundleData.type == StateEvent.ReadyTimeout then
		WindowManager:showWindow(WindowTag.MessageBox, {
			text = bundleData.msgTip,
			singleBtn = true,
			leftText = "确认",
			leftFunc = function()
				local levelConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney()
				if levelConfig then
					app:requestEnterRoom(levelConfig:getLevel(), true)
				end
			end
		})
	end
end

function LobbyController:pause()
	LobbyController.super.pause(self)
end

function LobbyController:dtor()
    delete(self.quickStartAnim)
    self.quickStartAnim = nil
    BroadcastPaoMaDeng:clearDelegate(self)
	EventDispatcher.getInstance():unregister(HttpModule.s_event, self, self.onHttpRequestsCallBack);
	EventDispatcher.getInstance():unregister(Event.Call, self, self.onNativeCallBack);
	EventDispatcher.getInstance():unregister(Event.Shield, self, self.shieldFunction);
end

function LobbyController:onBack()
	-- if true then
	-- 	NativeEvent.getInstance():platformManagerExit()
	-- 	return
	-- end
	local window = WindowManager:showWindow(WindowTag.ExitGamePopu)
	window.enterHuoDongFunc = function()
		if app:checkCanEnter2Scene() then
			NativeEvent.getInstance():openWebView({})
		end
	end
	window.leftFunc = handler(self, self.exitGame)
	window.rightFunc = function()
		self:onStartBtnClick()
	end
end

function LobbyController:exitGame()
	NativeEvent.getInstance():Exit()
end

--HTTP回调
function LobbyController:onHttpRequestsCallBack(command, ...)
	if self.s_severCmdEventFuncMap[command] then
     	self.s_severCmdEventFuncMap[command](self,...)
	end
end

-- 业务方法
-------------------------[[ 与view交互的方法 ]] -----------------------
-- 设置头像
function LobbyController:setHeadImg(fileName)
	local headView = self.m_root:findChildByName("view_head");

	if not self.m_headImage then
		self.m_headImage = new(Mask, fileName, "kwx_lobby/img_touXiangMask.png");
		self.m_headImage:setSize(headView:getSize());
		headView:addChild(self.m_headImage);
	else
		self.m_headImage:setVisible(true)
		self.m_headImage:setFile(fileName)
	end
end

--设置金币
function LobbyController:setCoin(coin)
	printInfo("LobbyController:setCoin : %d", coin)
	local coinBg = self.m_root:findChildByName("img_coinBg")
	local coinNode = new(LobbyCoinNode);
	coinNode:setNumber(ToolKit.formatNumber(coin));
	-- coinNode:setNumber(ToolKit.formatNumber(1300000000));
	local coinView = coinBg:findChildByName("view_coin");
	coinView:removeAllChildren();
	coinView:addChild(coinNode);
	coinNode:setAlign(kAlignLeft);
	-- coinBg:packDrawing(true)

	self:showSelectView()
end

--设置话费劵
function LobbyController:setHuaFei(huaFei)
	printInfo("LobbyController:setHuaFei : %d",huaFei)
	if huaFei < 0 then huaFei = 0 end
	local huaFeiBg = self.m_root:findChildByName("img_huaFeiBg")
	local huaFeiNode = new(LobbyCoinNode);
	huaFeiNode:setNumber(ToolKit.formatNumber(huaFei));
	local huaFeiView = self.m_root:findChildByName("view_huaFei");
	huaFeiView:removeAllChildren();
	huaFeiView:addChild(huaFeiNode);
	huaFeiNode:setAlign(kAlignLeft);
	-- huaFeiBg:packDrawing(true)
end

function LobbyController:setJewel( jewel )
	printInfo("LobbyController:setJewel : %d",jewel)
	if jewel < 0 then jewel = 0 end
	local jewelNode = new(LobbyCoinNode);
	jewelNode:setNumber(ToolKit.formatNumber(jewel));
	local view = self.m_root:findChildByName("view_jewel");
	view:removeAllChildren();
	view:addChild(jewelNode);
	jewelNode:setAlign(kAlignLeft);
end

--设置活动个数
function LobbyController:setActivitiesNum(num)
   	local bubble_act_img = self.m_root:findChildByName("bubble_act_img")
   	local bubble_act_txt = self.m_root:findChildByName("bubble_act_txt")
   	local bubble_act_img_l = self.m_root:findChildByName("bubble_act_img_l")
   	local bubble_act_txt_l = self.m_root:findChildByName("bubble_act_txt_l")
   	num = tonumber(num) or 0
   	if num > 0 and num < 10 then
       	bubble_act_img:setVisible(false)
       	bubble_act_img_l:setVisible(true)
       	bubble_act_txt_l:setText(num)
    elseif num >= 10 and num < 100 then
    	bubble_act_img:setVisible(true)
    	bubble_act_img_l:setVisible(false)
       	bubble_act_txt:setText(num)
   	else
	   	bubble_act_img:setVisible(false)
    	bubble_act_img_l:setVisible(false)
   	end
end

--设置任务领奖个数
function LobbyController:setTaskAwardsNum(num)
   	local bubble_task_img = self.m_root:findChildByName("bubble_task_img")
   	local bubble_task_txt = self.m_root:findChildByName("bubble_task_txt")
   	local bubble_task_img_l = self.m_root:findChildByName("bubble_task_img_l")
   	local bubble_task_txt_l = self.m_root:findChildByName("bubble_task_txt_l")
   	num = tonumber(num) or 0
   	if num > 0 and num < 10 then
       	bubble_task_img:setVisible(false)
       	bubble_task_img_l:setVisible(true)
       	bubble_task_txt_l:setText(num)
    elseif num >= 10 and num < 100 then
    	bubble_task_img:setVisible(true)
    	bubble_task_img_l:setVisible(false)
       	bubble_task_txt:setText(num)
   	else
	   	bubble_task_img:setVisible(false)
    	bubble_task_img_l:setVisible(false)
   	end
end

--设置排行榜领奖个数
function LobbyController:setRankAwardsNum(num)
	local bubble_rank_img = self.m_root:findChildByName("bubble_rank_img")
   	local bubble_rank_txt = self.m_root:findChildByName("bubble_rank_txt")
   	local bubble_rank_img_l = self.m_root:findChildByName("bubble_rank_img_l")
   	local bubble_rank_txt_l = self.m_root:findChildByName("bubble_rank_txt_l")
   	num = tonumber(num) or 0
   	if num > 0 and num < 10 then
       	bubble_rank_img:setVisible(false)
       	bubble_rank_img_l:setVisible(true)
       	bubble_rank_txt_l:setText(num)
    elseif num >= 10 and num < 100 then
    	bubble_rank_img:setVisible(true)
    	bubble_rank_img_l:setVisible(false)
       	bubble_rank_txt:setText(num)
   	else
	   	bubble_rank_img:setVisible(false)
    	bubble_rank_img_l:setVisible(false)
   	end
end

function LobbyController:updateRoomConfigView()
	for levelType = 1, 3 do
		local hallConfigTable = MyLevelConfigData:getLevelConfigByType(levelType)
		local text_di = self.m_root:findChildByName("text_di"..levelType)
		text_di:setText("")
		local diNode = new(LobbyCoinNode,"kwx_lobby/di")
		diNode:setNumber(hallConfigTable[1].value)
		text_di:addChild(diNode)

		self.m_root:findChildByName("text_needgold"..levelType):setText(hallConfigTable[1].require.."准入")
		local piaotab = hallConfigTable[1]:getPiaoTab()
		if 1 <= #piaotab then 
		    self.m_root:findChildByName("text_piao"..levelType):setText("漂:"..piaotab[1].."-"..piaotab[#piaotab])
		end
	end
end

function LobbyController:onRoomConfigResponse(data)
	self:showSelectView()
	if 1 == MyUserData:getIsRegister() and ShieldData:getAllFlag() and ShieldData:getIsQuickEntryGame() then
   		self:onStartBtnClick()
   	end

   	self:updateRoomConfigView()
end

function LobbyController:bindUiNotice()
	UIEx.bind(self, MyUserData, "money", function(value)
		self:setCoin(value)
	end)
	UIEx.bind(self, MyUserData, "huaFei", function(value)
		self:setHuaFei(value)
	end)
	UIEx.bind(self, MyUserData, "jewel", function(value)
		self:setJewel(value)
	end)
	UIEx.bind(self, MyUserData, "nick", function(value)
		if isPlatform_IOS then
			self:getControl(self.m_ctrl.nickName):setText(value)		-- iOS如果输入表情超过长度，截取之后就变空白了，估计可能是截取方法的问题，暂时不做截取处理，留给后台处理。PS：目前后端不支持表情的存储，所以重新登陆之后昵称的表情就没啦
		else
			self:getControl(self.m_ctrl.nickName):setText(ToolKit.isAllAscci(value) and ToolKit.subStr(value, 12) or ToolKit.subStr(value, 18));
		end
	end)
	UIEx.bind(self, MyUserData, "userType", function(value)
		local imgTypeTable = {
			[UserType.Visitor] = "kwx_lobby/img_guest.png",
			[UserType.WeChat] = "kwx_lobby/img_weixin.png",
			[UserType.Phone] = "kwx_lobby/img_phone.png",
		}
		local fileName = imgTypeTable[value] or imgTypeTable[UserType.Visitor]
		self:findChildByName("img_login"):setFile(fileName)
	end)
	MyUserData:setUserType(MyUserData:getUserType())

	-- 为头像绑定数据源
	UIEx.bind(self, MyUserData, "headName", function(value)
		self:setHeadImg(value)
		MyUserData:checkHeadAndDownload()
	end)

	-- 为头像绑定数据源
	UIEx.bind(self, MyUserData, "sex", function(value)
		local headName = MyUserData:getHeadName()
		self:setHeadImg(headName)
	end)

	UIEx.bind(self, MyUserData, "isLogin", function(value)
		if value then return end
		if self.m_headImage then
			self.m_headImage:setVisible(false)
		end
	end)

    -- 绑定活动数量
    UIEx.bind(self, MyActivitiesData, "actnum", function(num)
		num = ShieldData:getAllFlag() and 0 or num
	   	self:setActivitiesNum(num);
	end)

	-- 绑定任务领奖个数
    UIEx.bind(self, MyBaseInfoData, "taskAward", function(num)
	   self:setTaskAwardsNum(num);
	end)

    UIEx.bind(self.m_root, GameSetting, "isSecondScene", function(flag)
    	-- AlarmNotice.play("可见" .. ((not flag) and "是" or "否"))
    	self.m_root:setVisible(not flag)
    end)

    UIEx.bind(self, MyUpdateData, "status", function(value)
    	self:setSettingNum(value)
    end)
end

-----------------------  [[ private 方法]] ------------------------------


-----------------------  [[ Socket 事件]] -------------------------


-------------------------[[ UI 绑定]]
------------------------------------------------------------------------------
function LobbyController:onHeadBtnBtnClick()
	printInfo("onHeadBtnBtnClick")
end

function LobbyController:onBottomShopBtnClick()

end

function LobbyController:onStartBtnClick()
	printInfo("onStartBtnClick")
	-- if true then
	-- 	ToastShade.getInstance():play()
	-- 	return
	-- end
	app:quickStartGame()
end

-- 清除配置
function LobbyController:onSettingBtnClick()
	printInfo("清除数据，断开连接")
	GameSocketMgr:closeSocketSync(true) --断开后重连
end

--native callback
function LobbyController:onNativeCallBack(key, data,result)
	printInfo("LobbyController onNativeCallBack key : %s", key)
	if key == kActivityGoFunction then
	    self:onActivityToFunction(data);
	end
end

-- 处理活动界面事件
function LobbyController:onActivityToFunction(data)
	local target = data.target:get_value() or ""
	printInfo("活动界面跳转=====>>"..target)
	if kTargetLobby == target then -- 大厅

	elseif kTargetInfo == target then -- 个人信息
		self:enter2Scene(WindowTag.UserPopu, true, WindowStyle.NORMAL)
	elseif kTargetRoom == target then -- 房间
		self:onStartBtnClick()
	elseif kTargetStore == target then -- 商城
		self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL)
	elseif kTargetRecharge == target then -- 充值指定额度
		if not data.count then
			return
		end
		local pamount = tonumber(data.count:get_value() or "6");
		-- 根据额度查找商品
		local goodsIndex, goodsInfo = PayController:getGoodsInfoByPamount(pamount, 0)
		if not goodsIndex then
			AlarmTip.play("商品不存在")
			globalRequestChargeList(true);
		else
			if app:checkIsBroke() then
				WindowManager:showWindow(WindowTag.BankruptPopu, {
					goodsIndex = goodsIndex,
					goodsInfo = goodsInfo,
				});
			else
				WindowManager:showWindow(WindowTag.RechargePopu, {
					goodsIndex = goodsIndex,
					goodsInfo = goodsInfo,
					-- 需要不在牌局中才弹破产
					chargeType = app:checkIsBroke() and ChargeType.BrokeCharge or ChargeType.QuickCharge,
				});
			end
		end
	elseif kTargetTask == target then --每日任务
		self:enter2Scene(WindowTag.TaskPopu, true, WindowStyle.NORMAL)
	elseif kQuickBuy == target then -- 快速购买
		app:selectGoodsForChargeVarMoney()
	elseif kTargetFeedback == target then -- 反馈
		self:enter2Scene(WindowTag.FeedbackPopu, true, WindowStyle.NORMAL)
	elseif kTargetPropStore == target then -- 道具商城
		self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL, 2)
	elseif kTargetSign == target then -- 签到
		self:enter2Scene(WindowTag.SignAwardPopu, true, WindowStyle.POPUP)
	elseif kTargetActivityNumber == target then -- 活动数量
		local count = tonumber(data.count:get_value() or "0")
		MyActivitiesData:setActnum(count);
	elseif kTargetQQGroup == target then -- 跳转到QQ群
		local QQGroup = data.qqcode:get_value() or ""
		NativeEvent.getInstance():jumpToQQGroup({["QQGroup"] = QQGroup})
	end
end

-- 公告跳转 跳转标识 1 活动 2商城 3任务 4快速开始 5快速充值 6更新弹窗

function LobbyController:onNoticeToFunction(link_type)

   	if(not link_type) then return  end
   	printInfo("link_type : %d", link_type)
   	local link_type = tonumber(link_type);
   	if( link_type == 1) then
      	if app:checkCanEnter2Scene() then
			NativeEvent.getInstance():openWebView({})
		end
   	elseif( link_type == 2 ) then
      	self:enter2Scene(WindowTag.ShopPopu, true, WindowStyle.NORMAL);
  	elseif( link_type == 3 ) then
      	self:enter2Scene(WindowTag.TaskPopu, true, WindowStyle.NORMAL);
   	elseif( link_type == 5 ) then
      	self:onStartBtnClick();
   	elseif( link_type == 6 ) then
      	app:selectGoodsForChargeVarMoney()
   	elseif( link_type == 7 ) then
      	self:enter2Scene(WindowTag.UpdatePopu, true, WindowStyle.NORMAL);
   	end
end

function LobbyController:shieldFunction()
	local huafei = self.m_root:findChildByName("img_huaFeiBg")
	local exchange = self.m_root:findChildByName("btn_exchange")
	local notice = self.m_root:findChildByName("btn_msg")
	local setting = self.m_root:findChildByName("btn_setting")
	local help = self.m_root:findChildByName("btn_help")
	local xinshouchang = self.m_root:findChildByName("btn_level1")
	local gaojichang = self.m_root:findChildByName("btn_level2")
	local huafeichang = self.m_root:findChildByName("btn_level3")
	local firstcharge = self.m_root:findChildByName("btn_firstCharge")
	local sign = self.m_root:findChildByName("btn_sign")
	if not gaojichangOriginPos and gaojichang then
		gaojichangOriginPos = gaojichang:getPos()
	end
	if ShieldData:getAllFlag() then
		if huafei then huafei:hide() end
		if exchange then exchange:hide() end
		if notice then notice:hide() end
		if huafeichang then huafeichang:hide() end
		if firstcharge then firstcharge:hide() end
		if sign then sign:hide() end
		if gaojichang then gaojichang:setPos(huafeichang:getPos()) end
	else
		if huafei then huafei:show() end
		if exchange then exchange:show() end
		if notice then notice:show() end
		if huafeichang then huafeichang:show() end
		if firstcharge then firstcharge:show() end
		if sign then sign:show() end
		if gaojichang then gaojichang:setPos(gaojichangOriginPos) end
		gaojichangOriginPos = nil
	end

	-- 隐藏
	if exchange then exchange:hide() end
end

function LobbyController:onGetSystemAwardMsgResponse( data )
	self:updateMailMsgNum()
end

function LobbyController:onGetSystemMsgResponse( data )
	self:updateMailMsgNum()
end

function LobbyController:onDelSystemMsgResponse( data )
	self:updateMailMsgNum()
end


--[[----------------------------UI  config  ---------------------------]]
local view_right = {"view_ui","view_right"};

LobbyController.s_controlConfig =
{
	[LobbyController.s_controls.nickName] 			= {"view_ui", "view_top", "view_nickName", "text_nick"},
	[LobbyController.s_controls.headView] 			= {"view_ui", "view_right", "view_player", "btn_head", "view_head"},
	[LobbyController.s_controls.coinView] 			= {"view_ui", "view_right", "view_player", "img_coinBg", "view_coin"},
	[LobbyController.s_controls.quickStartBtn] 		= {"view_ui", "view_bottom", "btn_quickStart"},
	[LobbyController.s_controls.settingBtn] 		= {"view_ui", "view_right", "view_tool", "View1", "Button2"},

}
LobbyController.s_controlFuncMap =
{
	-- [LobbyController.s_controls.quickStartBtn]   	= LobbyController.onStartBtnClick,
}

-----------------------   [[通知事件]]  --------------------------
LobbyController.messageFunMap = {
	["SelectGameType"] 			= LobbyController.onSelectGameType,
	["NoticeLinkType"] 			= LobbyController.onNoticeToFunction,
}

-----------------------   [[ 映射 ]]---------------------------------------
LobbyController.s_severCmdEventFuncMap = {
	[Command.ROOM_CONFIG_PHP_REQUEST]  = LobbyController.onRoomConfigResponse,
    [Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST]	= LobbyController.onGetSystemAwardMsgResponse,
    [Command.MAIL_GET_SYSTEMMSG_PHPREQUEST]	= LobbyController.onGetSystemMsgResponse,
	[Command.MAIL_DEL_SYSTEMMSG_PHPREQUEST]			= LobbyController.onDelSystemMsgResponse,

}

return LobbyController
