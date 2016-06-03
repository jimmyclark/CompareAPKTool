
local TelLoginPopu = class(require("popu.gameWindow"))

function TelLoginPopu:initView(data)
	--返回
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		self:dismiss();
	end);

	--初始化UI
	local etTel  	= self:findChildByName("et_tel");
	local etPsw  	= self:findChildByName("et_psw");
	local textPsw  	= self:findChildByName("text_psw");

	

	etTel:setHintText("输入手机号码", 0x96, 0x96, 0x96);
	etPsw:setHintText("输入密码", 0x96, 0x96, 0x96);
	etPsw:setInputType(0);--设置为密码类型
	--设置透明
	etPsw:addPropTransparency(1, kAnimRepeat, 100, 0, 0, 0);
	
	textPsw:setText("输入密码");

	self.mLoginData = ToolKit.getDict("TelLoginPopu", {'remebered', 'username','password'});

	local linkText = new(Text, "找回密码", 0, 0, kAlignLeft, kFontTextUnderLine, 30, 0x32, 0xFA, 0x1E);
	linkText:setAlign(kAlignLeft);
	self:findChildByName("btn_forgot_psw"):addChild(linkText);
	--注册
	self:findChildByName("btn_register"):setOnClick(self, function ( self )
		-- body
		WindowManager:showWindow(WindowTag.TelRegisterPopu, {}, WindowStyle.POPUP);
		self:dismiss(true);
	end);
	--登录
	self:findChildByName("btn_login"):setOnClick(self, function ( self )
		-- body
		local tel = etTel:getText();
		local psw = etPsw:getText();
		if not ToolKit.isValidTelNo(tel) then
			AlarmTip.play("请输入正确的11位手机号码");
			return ;
		end

		local pswLen = string.len(psw);

		if pswLen < 6 or  pswLen > 16 then
			AlarmTip.play("密码长度不合法");
			return ;
		end

		self.mUserName 	= tel;
		self.mPassword 	= psw;

		-- LoginMethod:requestPhoneLogin(tel, psw, nil);
		-- body
		GameConfig:setLastUserType(UserType.Phone)
			:setLastLoginData({
				username = tel,
				password = psw,
			})
		GameSocketMgr:closeSocketSync(true)
	end);
	--找回密码
	self:findChildByName("btn_forgot_psw"):setOnClick(self, function ( self )
		-- body
		WindowManager:showWindow(WindowTag.TelForgotPopu, {}, WindowStyle.POPUP);
		self:dismiss(true);
	end);

	self.mRemebered = false;
	self.mUserName 	= "";
	self.mPassword 	= "";
	
	if self.mLoginData.remebered == '' or self.mLoginData.remebered == 'true' then
		self:findChildByName("img_check"):setFile("kwx_tanKuang/login/img_checked.png");
		etTel:setText(self.mLoginData.username);
		etPsw:setText(self.mLoginData.password);
		local len = string.len(self.mLoginData.password or "");
		if len > 0 then
			local star = "";
			for i = 1, len do
				star = star .. "*";
			end
			textPsw:setText(star);
		else
			textPsw:setText("输入密码");
		end
		self.mRemebered = true;
	end

	if self.mRemebered then
		self:findChildByName("img_check"):setFile("kwx_tanKuang/login/img_checked.png");
	else
		self:findChildByName("img_check"):setFile("kwx_tanKuang/login/img_check.png");
	end
	
	--记住密码
	self:findChildByName("btn_remember_psw"):setOnClick(self, function ( self )
		-- body
		self.mRemebered = not self.mRemebered;

		if self.mRemebered then
			self:findChildByName("img_check"):setFile("kwx_tanKuang/login/img_checked.png");
		else
			self:findChildByName("img_check"):setFile("kwx_tanKuang/login/img_check.png");
		end
	end);
	--输入回调
	etTel:setOnTextChange(self, function ( self )
		etTel:setText(string.sub(etTel:getText(), 1, 11));
	end);

	--输入回调
	etPsw:setOnTextChange(self, function ( self )
		etPsw:setText(string.sub(etPsw:getText(), 1, 16))
		local psw = etPsw:getText();
		local len = string.len(psw or "");
		if len > 0 then
			local star = "";
			for i = 1, len do
				star = star .. "*";
			end
			textPsw:setText(star);
		else
			textPsw:setText("输入密码");
		end
	end);

end

--登录成功
function TelLoginPopu:onLoginResponse( data )
	if data.status == 1 then
		if self.mRemebered then
			ToolKit.setDict("TelLoginPopu", {remebered = tostring(self.mRemebered), username = self.mUserName, password = self.mPassword});
		else
			ToolKit.setDict("TelLoginPopu", {remebered = tostring(false), username = "", password = ""});
		end
		self:dismiss(true);
	end
end

--[[
	通用的（大厅）协议
]]
TelLoginPopu.s_severCmdEventFuncMap = {
	[Command.LOGIN_PHP_REQUEST] 	= TelLoginPopu.onLoginResponse,
}

return TelLoginPopu