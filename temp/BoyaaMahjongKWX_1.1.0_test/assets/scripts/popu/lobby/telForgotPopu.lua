local TelForgotPopu = class(require("popu.gameWindow"))

function TelForgotPopu:initView(data)
	--返回
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		self:dismiss();
	end);

	--初始化UI
	local etTel  = self:findChildByName("et_tel")
	local etPsw  = self:findChildByName("et_psw")
	local etCode = self:findChildByName("et_code")

	self.mPassName = ""
	self.mPassWord = ""

	local btnSecurityCode = self:findChildByName("btn_security_code");
	--获取验证码
	btnSecurityCode:setOnClick(self, function ( self )
		-- body
		local tel = etTel:getText();
		if not ToolKit.isValidTelNo(tel) then
			AlarmTip.play("请输入正确的11位手机号码");
			return ;
		end

		btnSecurityCode:setPickable(false);
		
		GameSocketMgr:sendMsg(Command.REGISTER_SECURITY_CODE_PHP_REQUEST, {['phone']=tel, ['act'] = 'pwd'}, false);

		local viewTime 	= self:findChildByName("view_time");
		local anim 	 	= viewTime:addPropTranslate(0, kAnimRepeat, 1000, 0, 0, 0, 0, 0);
		local second 	= 60;
		local textTime 	= self:findChildByName("text_time");
		textTime:setText(string.format("重新获取%dS", second));
        anim:setDebugName("security | anim")
        anim:setEvent(self, function (self)
        	-- body
        	second = second - 1;

        	if second < 0 then
        		textTime:setText("");
        		viewTime:removeProp(0);
        		btnSecurityCode:setPickable(true);
        		return ;
        	end

        	textTime:setText(string.format("重新获取%dS", second));
        end);

	end);

	
	--确定
	self:findChildByName("btn_comfirm"):setOnClick(self, function ( self )
		-- body
		
		self.mPassName = etTel:getText();
		self.mPassWord = etPsw:getText();
		local code = etCode:getText();
		if not ToolKit.isValidTelNo(self.mPassName) then
			AlarmTip.play("请输入正确的11位手机号码");
			return ;
		end

		local pswLen = string.len(self.mPassWord);

		if pswLen < 6 or  pswLen > 16 then
			AlarmTip.play("新密码长度不合法");
			return ;
		end

		if string.len(code) < 4 then
			AlarmTip.play("请输入有效的验证码");
			return ;
		end

		GameSocketMgr:sendMsg(Command.FORGOT_PASSWORD_PHP_REQUEST, {['phone']=self.mPassName, ['pwd']=self.mPassWord, ['verifycode']=code});
	end);

	etTel:setHintText("输入手机号码", 0x96, 0x96, 0x96);
	etPsw:setHintText("输入新密码", 0x96, 0x96, 0x96);
	etCode:setHintText("输入验证码", 0x96, 0x96, 0x96);

	--输入回调
	etTel:setOnTextChange(self, function ( self )
		etTel:setText(string.sub(etTel:getText(), 1, 11));
	end);
	etPsw:setOnTextChange(self, function ( self )
		etPsw:setText(string.sub(etPsw:getText(), 1, 16));
	end);

	etCode:setOnTextChange(self, function ( self )
		etCode:setText(string.sub(etCode:getText(), 1, 6));
	end);

end
--注册验证码
function TelForgotPopu:onRegisterSecurityCodeResponse( data )
	if data.status ~= 1 then
		local viewTime = self:findChildByName("view_time");
		if not viewTime:checkAddProp(0) then
			viewTime:removeProp(0);
		end
		local textTime 	= self:findChildByName("text_time");
		textTime:setText("");
		self:findChildByName("btn_security_code"):setPickable(true);

		AlarmTip.play(data.msg or "获取验证码失败，请重新获取");
	end
end
--找回密码
function TelForgotPopu:onForgotPasswordResponse( data )
	if data.status == 1 then
		AlarmTip.play(data.msg)
		local mLoginData = ToolKit.getDict("TelLoginPopu", {'remebered', 'username','password'});
		if mLoginData.remebered == '' or mLoginData.remebered == 'true' then
			ToolKit.setDict("TelLoginPopu", {remebered = tostring(true), username = self.mPassName, password = self.mPassWord})
		end
		self:dismiss(true)
	else
		AlarmTip.play(data.msg or "找回密码失败");
	end
end
--[[
	通用的（大厅）协议
]]
TelForgotPopu.s_severCmdEventFuncMap = {
	[Command.FORGOT_PASSWORD_PHP_REQUEST] 			= TelForgotPopu.onForgotPasswordResponse,
	[Command.REGISTER_SECURITY_CODE_PHP_REQUEST] 	= TelForgotPopu.onRegisterSecurityCodeResponse,
}

return TelForgotPopu