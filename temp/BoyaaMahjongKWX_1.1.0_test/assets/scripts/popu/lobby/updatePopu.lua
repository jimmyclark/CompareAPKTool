local UpdatePopu = class(require("popu.gameWindow"))

function UpdatePopu:ctor()
	EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
end

function UpdatePopu:dtor()

	EventDispatcher.getInstance():unregister(Event.Call, self, self.onNativeCallBack);
end

function UpdatePopu:initView(data)
	local closeBtn = self:findChildByName("btn_close");
	closeBtn:setOnClick(self, function ( self )
		-- body
		self:dismiss(true);
	end);

	if not MyUpdateData:getInit() then
		GameSocketMgr:sendMsg(Command.UPDATE_PHP_REQUEST, {}, false);
	else
		self:_initView();
	end
end

function UpdatePopu:dismiss(param)
	if MyUpdateData:getForce() == 1 then
		return ;
	end

	self.super.dismiss(self);
	return true
end


function UpdatePopu:_initView()
	-- body
	self:findChildByName("text_newVersion"):setText("最新版本："..MyUpdateData:getVerstr());
	self:findChildByName("text_reward_tips"):setText("更新奖励："..MyUpdateData:getAwardstr());

	self.mProgress = self:findChildByName("img_progress");
	self.mPercent  = self:findChildByName("text_percent");
	--26为9宫格的宽度，该宽度iamge类没有保存，故无法获到，只能硬编码
	local width = (self.mProgress.m_res.m_width - 44) * 0 ;

	self.mProgress:setSize(44 + width, self.mProgress.m_res.m_height);

	--更新说明
	local updateInfoScrollView = self:findChildByName("sv_update_info");

	local w, h = updateInfoScrollView:getSize();

	local titleText = new(TextView, MyUpdateData:getTitle(), w, 0, kAlignLeft, kFontTextUnderLine, 30, 0xff, 0xff, 0xff);
	updateInfoScrollView:addChild(titleText);

	titleTextW, titleTextH = titleText:getSize();

	local updateInfoTextView = new(TextView, MyUpdateData:getDesc(), w, 0, kAlignLeft, nil, 26, 0xff, 0xff, 0xff);
	updateInfoTextView:setPos(0, titleTextH + 10);
	updateInfoScrollView:addChild(updateInfoTextView);
	ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")
	updateInfoScrollView:setScrollBarWidth(4)

	local update = MyUpdateData:getUpdate()
	local award  = MyUpdateData:getAward()
	local btnGet = self:findChildByName("btn_get")

	if System.getPlatform() == kPlatformIOS then
		local mProgressView  = self:findChildByName("img_updateProgressBg");
		if mProgressView then mProgressView:hide() end
	end

	-- self:findChildByName("text_curVersion"):setText("当前版本："..PhpManager:getVersionName());
	if award == 1 then
		self:findChildByName("text_get_title"):setText("领取奖励");
		btnGet:setFile("kwx_common/btn_red_big.png");

		btnGet:setOnClick(self, function ( self )
			-- 领取
			GameSocketMgr:sendMsg(Command.UPDATE_AWARD_PHP_REQUEST, {}, true);
		end);
		self:findChildByName("img_updateProgressBg"):hide()
	elseif update == 1 then
		self:findChildByName("text_get_title"):setText("更新领奖");
		btnGet:setOnClick(self, function ( self )
			-- 下载
			self:downloadPackage();
		end);

		NativeEvent.getInstance():CheckPackByLocal(MyUpdateData:getUrl());

		ToolKit.setDict("UPDATE", { version = PhpManager:getVersionName() });

		if PhpManager:getNet() == "wifi" then
			self:downloadPackage()
		end
	else
		self:findChildByName("text_get_title"):setText("领取奖励");
		btnGet:setFile("kwx_common/btn_gray_big.png");
		-- btnGet:setEnable(false);
		btnGet:setPickable(false);
	end

	--强制更新
	if MyUpdateData:getForce() == 1 then
		self:findChildByName("btn_close"):setVisible(false);
	end
end

function UpdatePopu:onUpdateResponse()
	-- body
	self:_initView();
end

function UpdatePopu:downloadPackage()
	-- body
	-- 下载
	GameSocketMgr:sendMsg(Command.SETUPDATE_PHP_REQUEST, {version = MyUpdateData:getVerstr()}, false);
	-- if MyUpdateData:getMode() == 1 then -- 友盟更新
	-- 	NativeEvent.getInstance():UpdateByUmeng(1, MyUpdateData:getUmeng(), MyUpdateData:getForce(), 1);
	-- else -- 本地更新
		NativeEvent.getInstance():UpdateByLocal(MyUpdateData:getUrl(), MyUpdateData:getForce());
	-- end
end

--native callback
function UpdatePopu:onNativeCallBack(key, result)
	printInfo("UpdatePopu:onNativeCallBack");
	printInfo("key = " .. key);
	
	if key == 'UpdateVersion' or key == 'UpdateSuccess' then
		local curDownload 	= tonumber(result.downloadSize:get_value() or 0);
		local totalSize 	= tonumber(result.totalSize:get_value() or 0);

		if  curDownload >= 0 and totalSize > 0 then
			local width = (self.mProgress.m_res.m_width - 44) * curDownload / totalSize;

			self.mProgress:setSize(44 + width, self.mProgress.m_res.m_height);
			self.mPercent:setText(tostring(math.floor(curDownload * 100 / totalSize)) .. "%");
		end
	elseif key == 'Updating' then
		AlarmTip.play(result.msg:get_value());
	elseif key == 'UmengUpdate' then
		AlarmTip.play(result.msg:get_value());
	end
end


function UpdatePopu:onUpdateAwardResponse(data)
	if data.status == 1 then
		self:dismiss()
		MyUpdateData:setAward(0)
	end
end

--[[
	通用的（大厅）协议
]]
UpdatePopu.s_severCmdEventFuncMap = {
	[Command.UPDATE_AWARD_PHP_REQUEST]				= UpdatePopu.onUpdateAwardResponse,
}

return UpdatePopu