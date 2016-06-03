local SettingPopu = class(require("popu.gameWindow"))

function SettingPopu:initView(data)

	--返回
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		self:dismiss();
	end);
	local scrollview_setting = self:findChildByName("scrollview_setting")
	local titleBgFile = "kwx_tanKuang/notice/notice_bg.png"
	local titleW, titleH = scrollview_setting:getSize()
	local height = 10
	local startX = 40
	titleH = 55
	local x , y = 0, 0
	-- 账号
	local img_title = UIFactory.createImage(titleBgFile)
		:pos(x, y)
		:setSize(titleW, titleH)
		:addTo(scrollview_setting)
	local params = {}
	params.text = "切换账号"
	params.color = { r = 0x50, g = 0xb4, b = 0xff}
	params.size = 30
	UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(img_title)
	y = y + titleH + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = self:getLoginInfo()
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
		:pos(startX , 0)
		:align(kAlignRight)
		:addTo(loginInfoNode)
	btn_temp:setOnClick(self, function(self)
		WindowManager:showWindow(WindowTag.LoginPopu, {}, WindowStyle.POPUP);
		self:dismiss(true);
	end)
	params.text = "切换账号"
	local text_loginInfo = UIFactory.createText(params)
		:align(kAlignCenter)
		:addTo(btn_temp)
	-- 绑定手机
	-- 如果已经绑定，则不显示绑定。如果开启审核屏蔽，不显示绑定
	if 1 ~= MyUserData:getIsbind_phone() and not ShieldData:getAllFlag() then
		y = y + titleH + height
		local img_title = UIFactory.createImage(titleBgFile)
			:pos(x, y)
			:setSize(titleW, titleH)
			:addTo(scrollview_setting)
		params.text = "绑定手机"
		params.color = { r = 0x50, g = 0xb4, b = 0xff}
		UIFactory.createText(params)
			:pos(startX , 0)
			:align(kAlignLeft)
			:addTo(img_title)
		y = y + titleH + height
		local loginInfoNode = new(Node)
		loginInfoNode:setPos(x , y)
		loginInfoNode:setSize(titleW, titleH)
		scrollview_setting:addChild(loginInfoNode)
		params.text = "绑定手机"
		params.color = { r = 0xff, g = 0xff, b = 0xff }
		local text_loginInfo = UIFactory.createText(params)
			:pos(startX , 0)
			:align(kAlignLeft)
			:addTo(loginInfoNode)
		local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
			:pos(startX , 0)
			:align(kAlignRight)
			:addTo(loginInfoNode)
		btn_temp:setOnClick(self, function(self)
			WindowManager:showWindow(WindowTag.TelRegisterPopu, {}, WindowStyle.POPUP);
			self:dismiss(true);
		end)
		params.text = "绑  定"
		local text_loginInfo = UIFactory.createText(params)
			:align(kAlignCenter)
			:addTo(btn_temp)
	end
	-- 清除缓存
	y = y + titleH + height
	local img_title = UIFactory.createImage(titleBgFile)
		:pos(x, y)
		:setSize(titleW, titleH)
		:addTo(scrollview_setting)
	params.text = "清除缓存"
	params.color = { r = 0x50, g = 0xb4, b = 0xff}
	UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(img_title)
	y = y + titleH + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "清空缓存，不影响您的账号及财产"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
		:pos(startX , 0)
		:align(kAlignRight)
		:addTo(loginInfoNode)
	btn_temp:setOnClick(self, function(self)
		self:clearCacheData()
		self:dismiss(true)
	end)
	params.text = "清  除"
	local text_loginInfo = UIFactory.createText(params)
		:align(kAlignCenter)
		:addTo(btn_temp)
	-- 声音
	y = y + titleH + height
	local img_title = UIFactory.createImage(titleBgFile)
		:pos(x, y)
		:setSize(titleW, titleH)
		:addTo(scrollview_setting)
	params.text = "声音"
	params.color = { r = 0x50, g = 0xb4, b = 0xff}
	UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(img_title)
	y = y + titleH + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "音效"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	self:createSoundSlider(loginInfoNode, 1)

	y = y + titleH + height + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "音乐"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	self:createSoundSlider(loginInfoNode, 2)
	-- 教学
	y = y + titleH + height
	local img_title = UIFactory.createImage(titleBgFile)
		:pos(x, y)
		:setSize(titleW, titleH)
		:addTo(scrollview_setting)
	params.text = "教学"
	params.color = { r = 0x50, g = 0xb4, b = 0xff}
	UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(img_title)
	y = y + titleH + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "教学"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
		:pos(startX , 0)
		:align(kAlignRight)
		:addTo(loginInfoNode)
	btn_temp:setOnClick(self, function(self)
		WindowManager:showWindow(WindowTag.HelpPopu, {}, WindowStyle.NORMAL, 2);
		self:dismiss(true);
	end)
	params.text = "教  学"
	local text_loginInfo = UIFactory.createText(params)
		:align(kAlignCenter)
		:addTo(btn_temp)
	-- 版本
	y = y + titleH + height
	local img_title = UIFactory.createImage(titleBgFile)
		:pos(x, y)
		:setSize(titleW, titleH)
		:addTo(scrollview_setting)
	params.text = "版本"
	params.color = { r = 0x50, g = 0xb4, b = 0xff}
	UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(img_title)
	y = y + titleH + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "意见反馈"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
		:pos(startX , 0)
		:align(kAlignRight)
		:addTo(loginInfoNode)
	btn_temp:setOnClick(self, function(self)
		WindowManager:showWindow(WindowTag.HelpPopu, {}, WindowStyle.NORMAL);
		self:dismiss(true);
	end)
	params.text = "反  馈"
	local text_loginInfo = UIFactory.createText(params)
		:align(kAlignCenter)
		:addTo(btn_temp)
	-- 如果开启审核屏蔽，不显示更新
	if not ShieldData:getAllFlag() then
		y = y + titleH + height + height
		local loginInfoNode = new(Node)
		loginInfoNode:setPos(x , y)
		loginInfoNode:setSize(titleW, titleH)
		scrollview_setting:addChild(loginInfoNode)
		params.text = "版本更新"
		params.color = { r = 0xff, g = 0xff, b = 0xff }
		local text_loginInfo = UIFactory.createText(params)
			:pos(startX , 0)
			:align(kAlignLeft)
			:addTo(loginInfoNode)
		local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
			:pos(startX , 0)
			:align(kAlignRight)
			:addTo(loginInfoNode)
		btn_temp:setOnClick(self, function(self)
			printInfo("MyUpdateData:getStatus() = " ..MyUpdateData:getStatus());
			if MyUpdateData:getStatus() == 1 then
				WindowManager:showWindow(WindowTag.UpdatePopu, {}, WindowStyle.POPUP);
				self:dismiss(true);
			else
				AlarmTip.play("您的版本已经是最新版本了");
			end
		end)
		if MyUpdateData:getStatus() == 1 then
			UIFactory.createImage("kwx_lobby/img_red.png")
					:addTo(btn_temp)
					:align(kAlignTopRight)
		end
		params.text = "更  新"
		local text_loginInfo = UIFactory.createText(params)
			:align(kAlignCenter)
			:addTo(btn_temp)
	end
	-- 其他
	y = y + titleH + height
	local img_title = UIFactory.createImage(titleBgFile)
		:pos(x, y)
		:setSize(titleW, titleH)
		:addTo(scrollview_setting)
	params.text = "其他"
	params.color = { r = 0x50, g = 0xb4, b = 0xff}
	UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(img_title)
	y = y + titleH + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "用户条款"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
		:pos(startX , 0)
		:align(kAlignRight)
		:addTo(loginInfoNode)
	params.text = "查  看"
	local text_loginInfo = UIFactory.createText(params)
		:align(kAlignCenter)
		:addTo(btn_temp)
	btn_temp:setOnClick(self, function ( self )
		self:dismiss(true);
		WindowManager:showWindow(WindowTag.UserRulePopu, {
			title = 1,
			url   = kPhpCommonUrl .. "?m=html&p=load&file=privacy_policy"
			}, WindowStyle.NORMAL);
	end);
	
	y = y + titleH + height + height
	local loginInfoNode = new(Node)
	loginInfoNode:setPos(x , y)
	loginInfoNode:setSize(titleW, titleH)
	scrollview_setting:addChild(loginInfoNode)
	params.text = "服务条款"
	params.color = { r = 0xff, g = 0xff, b = 0xff }
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local text_loginInfo = UIFactory.createText(params)
		:pos(startX , 0)
		:align(kAlignLeft)
		:addTo(loginInfoNode)
	local btn_temp = UIFactory.createButton("kwx_common/btn_blue_small.png")
		:pos(startX , 0)
		:align(kAlignRight)
		:addTo(loginInfoNode)
	btn_temp:setOnClick(self, function ( self )
		self:dismiss(true);
		WindowManager:showWindow(WindowTag.UserRulePopu, {
			title = 2,
			url   = kPhpCommonUrl ..  "?m=html&p=load&file=terms_of_service"
			}, WindowStyle.NORMAL);
	end);
	params.text = "查  看"
	local text_loginInfo = UIFactory.createText(params)
		:align(kAlignCenter)
		:addTo(btn_temp)

	-- --用户条款
	-- local btnUserRule = self:findChildByName("btn_user_rule");
	-- btnUserRule:setOnClick(self, function ( self )
	-- 	-- body
	-- 	self:dismiss(true);
	-- 	WindowManager:showWindow(WindowTag.UserRulePopu, {
	-- 		title = "用户条款",
	-- 		url   = kPhpCommonUrl .. "?m=html&p=load&file=privacy_policy"
	-- 		}, WindowStyle.NORMAL);

	-- end);

	-- local userRule = new(Text, "用户条款", 0, 0, kAlignCenter, kFontTextUnderLine, 30, 0xFF, 0x17, 0x17);
	-- btnUserRule:addChild(userRule);
	-- --服务条款
	-- local btnServiceRule = self:findChildByName("btn_service_rule");
	-- btnServiceRule:setOnClick(self, function ( self )
	-- 	-- body
	-- 	self:dismiss(true);
	-- 	WindowManager:showWindow(WindowTag.UserRulePopu, {
	-- 		title = "服务条款",
	-- 		url   = kPhpCommonUrl ..  "?m=html&p=load&file=terms_of_service"
	-- 		}, WindowStyle.NORMAL);
	-- end);
	-- local serviceRule = new(Text, "服务条款", 0, 0, kAlignCenter, kFontTextUnderLine, 30, 0xFF, 0x17, 0x17);
	-- btnServiceRule:addChild(serviceRule);
end

function SettingPopu:getLoginInfo()
	local ret = ""
	if not MyUserData:getIsLogin() then
		ret = "未登录"
	else
		local nameTable = {
			[UserType.Visitor] = "游客用户：",
			[UserType.WeChat] = "微信用户：",
			[UserType.Phone] = "手机用户：",
		}
		ret = nameTable[MyUserData:getUserType()] or nameTable[UserType.Visitor]
		ret = ret .. MyUserData:getFormatNick(18)
	end
	return ret
end

function SettingPopu:createSoundSlider(node, _type)
	local params = {}
	params.width = 582
	params.height = 42
	params.bgImage = "kwx_tanKuang/lobbySetting/img_processBg.png"
	params.fgImage = "kwx_tanKuang/lobbySetting/img_processFg.png"
	params.buttonImage = "kwx_tanKuang/lobbySetting/btn_process.png"
	local sliderSound = UIFactory.createSlider(params)
								:pos(210, 0)
								:align(kAlignLeft)
								:addTo(node)

	if 1 == _type then
		printInfo("GameSetting:getMusicVolume() : "..GameSetting:getMusicVolume())
		sliderSound:setProgress(GameSetting:getSoundVolume())
	elseif 2 == _type then
		printInfo("GameSetting:getSoundVolume() : "..GameSetting:getSoundVolume())
		sliderSound:setProgress(GameSetting:getMusicVolume())
	end
	sliderSound:setOnChange(self, function(self, pos)
		if 1 == _type then
			GameSetting:setSoundVolume(pos)
			kEffectPlayer:setVolume(pos)
		elseif 2 == _type then
			GameSetting:setMusicVolume(pos)
			kMusicPlayer:setVolume(pos)
		end
	end)

	local btn_minSound = UIFactory.createButton("kwx_tanKuang/lobbySetting/btn_minSound.png")
								:align(kAlignLeft)
								:pos(130, 0)
								:addTo(node)
	btn_minSound:setOnClick(self, function()
		sliderSound:setProgress(0)
		if 1 == _type then
			GameSetting:setSoundVolume(0.0)
			kEffectPlayer:setVolume(0.0)
		elseif 2 == _type then
			GameSetting:setMusicVolume(0.0)
			kMusicPlayer:setVolume(0.0)
		end
	end)

	local btn_maxSound = UIFactory.createButton("kwx_tanKuang/lobbySetting/btn_maxSound.png")
								:align(kAlignLeft)
								:pos(840, 0)
								:addTo(node)
	btn_maxSound:setOnClick(self, function()
		sliderSound:setProgress(1)
		if 1 == _type then
			GameSetting:setSoundVolume(1.0)
			kEffectPlayer:setVolume(1.0)
		elseif 2 == _type then
			GameSetting:setMusicVolume(1.0)
			kMusicPlayer:setVolume(1.0)
		end
	end)
end

function SettingPopu:clearCacheData()
	MahjongCacheData_clearData()
	GameSocketMgr.m_isNotReconnect = true
	GameSocketMgr:closeSocketSync()
	AlarmTip.play("清除缓存成功")
end

function SettingPopu:onHidenEnd(...)
	SettingPopu.super.onHidenEnd(self, ...)
	GameSetting:save()
end

return SettingPopu