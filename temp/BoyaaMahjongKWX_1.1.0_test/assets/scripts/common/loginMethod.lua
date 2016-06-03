local LoginMethod = class()

function LoginMethod:ctor()

	EventDispatcher.getInstance():register(HttpModule.s_event,self,self.onHttpRequestsCallBack);
	EventDispatcher.getInstance():register(Event.Call, self,self.onNativeCallDone);
end

function LoginMethod:dtor()
	
	EventDispatcher.getInstance():unregister(HttpModule.s_event,self,self.onHttpRequestsCallBack);
	EventDispatcher.getInstance():unregister(Event.Call, self,self.onNativeCallDone);
end


function LoginMethod:autoRequestLogin()
	-- TODO 根据记录的登录方式登录
	local lastUserType = GameConfig:getLastUserType()
	printInfo("上次登录方式 = %d", lastUserType)
	if lastUserType == UserType.WeChat then
		self:requestWechatLogin()
	elseif lastUserType == UserType.Phone then
		local loginData = GameConfig:getLastLoginData()
		if loginData then
			self:requestPhoneLogin(loginData.username, loginData.password, loginData.verifycode, loginData.act)
		else
			local loginData = ToolKit.getDict("TelLoginPopu", {'remebered', 'username','password'});
			if loginData.username ~= "" and loginData.password ~= "" then
				self:requestPhoneLogin(loginData.username, loginData.password)
			else
				self:requestGuestLogin()
			end
		end
	else --默认游客登录
		self:requestGuestLogin()
	end
	GameConfig:setLastLoginData(nil)
end

--游客登录
function LoginMethod:requestGuestLogin()
	self:logOut();
	MyUserData:setUserType(UserType.Visitor)
	self:requestLoginPhp()
end
--手机登录
--verifycode仅注册时使用
function LoginMethod:requestPhoneLogin(phoneno, pwd, verifycode, act)
	self:logOut();
	MyUserData:setUserType(UserType.Phone)

    local param = {
    	['phoneno'] 	= phoneno,
    	['pwd'] 		= pwd,
    	['verifycode'] 	= verifycode,
    	['act'] 		= act
    };

	self:requestLoginPhp(param)
end

--微信登录
function LoginMethod:requestWechatLogin(atoken, openid)
	--native          call wechat
	if isPlatform_Win32() then
		opentoken = "12222121212"
		openid = "1212121331212"
	end
	if not atoken then
		NativeEvent.getInstance():login({loginType = UserType.WeChat});
		return ;
	end
	self:logOut();
	MyUserData:setUserType(UserType.WeChat)

    local param = {
    	['opentoken'] 	= atoken,
    	['openid'] 	= openid,
    };

    printInfo("opentoken" .. atoken);
    printInfo("openid" .. openid);

	self:requestLoginPhp(param)
end

function LoginMethod:requestLoginPhp(mergeParams)
	
	local param_data = PhpManager:getLoginParam()
	if mergeParams then
		-- param_data.param = mergeParams
		table.merge(param_data, mergeParams)
	end
    dump(param_data, "LoginMethod param_data")
	GameSocketMgr:sendMsg(Command.LOGIN_PHP_REQUEST, param_data);
end

function LoginMethod:logOut()
	MyUserData:clear()
	MySignAwardData:clear()
	MyMoneyRecommendData:clear()
	MyBaseInfoData:clear()
	MyFirstPayBagData:clear()
	MyGoodsData:clear()
	MyGiftPackData:clear()
	MyMailSystemData:clear()
	MyMailFriendData:clear()
end

function LoginMethod:onHttpRequestsCallBack(command, ...)
	if LoginMethod.httpRequestsCallBackFuncMap[command] then
     	LoginMethod.httpRequestsCallBackFuncMap[command](self,...)
	end 
end 

-- 登陆成功初始化
function LoginMethod:NativeCallLoginInit()
	-- body
	local key = "native_callLogoInit"
	local userInfoT = {}
	userInfoT.nick = MyUserData:getNick()
	userInfoT.id = MyUserData:getId()
	userInfoT.level = MyUserData:getLevel()

	dict_set_string(key, key..kparmPostfix, json.encode(userInfoT))
	dict_set_string(kLuaCallEvent, kLuaCallEvent, key)
	call_native("OnLuaCall")
end

function LoginMethod:onNativeCallDone(key, data)
	printInfo("LoginMethod:onNativeCallDone" .. key);
	if key == 'loginPlatform' then
		printInfo("data.stat = " .. data.stat:get_value());
		if tonumber(data.stat:get_value()) == 0 then
			--get access token
			local appid = 'wxa485b55301f50376';
			local secret= 'd4624c36b6795d1d99dcf0547af5443d';
			local code 	= data.code:get_value() or 0;
			printInfo("LoginMethod code = " .. code);
			
			local url = string.format('https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=%s', appid, secret, code, 'authorization_code');
			HttpModule.s_config[HttpModule.s_cmds.WeChatAccessToken][1] = url;
			HttpModule.getInstance():execute(HttpModule.s_cmds.WeChatAccessToken, {}, true, true);

		else
			AlarmTip.play(data.code:get_value() or "登录微信失败");
		end

	end
	
end

--微信access token
function LoginMethod:weChatAccessTokenCallBack(isSuccess, data)
	if not isSuccess or not data then
		AlarmTip.play("登录微信失败");
	    return;
	end

	local openid 		= data.openid:get_value();
	local accessToken 	= data.access_token:get_value();

	if not openid or not accessToken then
		AlarmTip.play("登录微信失败");
		return ;
	end
	
	self:requestWechatLogin(accessToken, openid);
end

function LoginMethod:onLoginResponse( data )
	-- body
	self:NativeCallLoginInit()
end

LoginMethod.httpRequestsCallBackFuncMap = {
	[HttpModule.s_cmds.WeChatAccessToken] 	= LoginMethod.weChatAccessTokenCallBack,
	[Command.LOGIN_PHP_REQUEST] 					= LoginMethod.onLoginResponse,
}

--[[
	通用的（大厅）协议
]]
return LoginMethod