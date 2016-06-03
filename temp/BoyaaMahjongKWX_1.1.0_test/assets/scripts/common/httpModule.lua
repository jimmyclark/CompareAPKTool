require("gameBase/httpManager");
require("libs/json_wrap");
require("animation/toastShade");
require("platform/platformConfig")

Joins = function(t, mtkey)
    local str = "K";
    if t == nil or type(t) == "boolean"  or type(t) == "byte" then
        return str;
    elseif type(t) == "number" or type(t) == "string" then
        str = string.format("%sT%s%s", str.."", mtkey, string.gsub(t, "[^a-zA-Z0-9]",""));
    elseif type(t) == "table" then
        for k,v in orderedPairs(t) do
            str = string.format("%s%s=%s", str, tostring(k), Joins(v, mtkey));
        end
    end
    return str;
end

HttpModule = class();
HttpModule.CommonUrl = nil;
HttpModule.s_event = EventDispatcher.getInstance():getUserEvent();

HttpModule.getInstance = function()
	if not HttpModule.s_instance then 
		HttpModule.s_instance = new(HttpModule);
	end
	return HttpModule.s_instance;
end

HttpModule.releaseInstance = function()
	delete(HttpModule.s_instance);
	HttpModule.s_instance = nil;
end

HttpModule.ctor = function(self)
	self.m_httpManager = new(HttpManager,HttpModule.s_config,HttpModule.postDataOrganizer,HttpModule.urlOrganizer);
	EventDispatcher.getInstance():register(HttpManager.s_event,self,self.onHttpResponse);
end

HttpModule.dtor = function(self)
	EventDispatcher.getInstance():unregister(HttpManager.s_event,self,self.onHttpResponse);
	delete(self.m_httpManager);
	self.m_httpManager = nil;
end

HttpModule.postDataOrganizerNoEncode = function(method,data)
	local post_data = {};
   	HttpModule.postDataInit(post_data, data);
    if method and not string.find( method, "#") then
    	 post_data.method = method;
    end

    if data then
        post_data.param = data;
    end

    local signature = HttpModule.joins(post_data.mtkey,post_data);
    post_data.sig = string.upper(md5_string(signature));
    
    method = method or "";
    -- 不进行编码
   	print_string(method .. "|api = " .. json.encode(post_data));
	return "api=".. json.encode(post_data);
end

HttpModule.postDataOrganizer = function(method,data)
	local post_data = {};
   	HttpModule.postDataInit(post_data, data);
    if method and not string.find( method, "#") then
    	post_data.method = method;
    end

    if data then
        post_data.param = data;
    end

    local signature = HttpModule.joins(post_data.mtkey,post_data);
    post_data.sig = string.upper(md5_string(signature));
    
    method = method or "";

    local dataStr = HttpModule.dataEncode_lua(json.encode(post_data));
   	print_string(method .. "|api = " .. json.encode(post_data));
	return "api=".. dataStr;
end

HttpModule.dataEncode_lua = function(str)

	if str == nil then  
		return "";
	end
	
	local platformStr = sys_get_string("platform");
	if platformStr == "win32" then
		str = string.gsub (str, "\n", "\r\n");
      	str = string.gsub (str, "([^%w ])",
         	function (c) return string.format ("%%%02X", string.byte(c)) end);
      	str = string.gsub (str, " ", "+");
		return str;
	end

    return NativeEvent.getInstance():encodeStr(str);
end

HttpModule.postDataInit = function(post_data, param_data)
    --用户Key
    -- post_data.appid, post_data.appkey, post_data.api = PlatformManager.getInstance():executeAdapter(PlatformManager.s_cmds.ProduceAppConfig);
    
    -- -- -- 保存用户的api
    -- UserData.setApi(post_data.api);
    	post_data.mid 		= MyUserData:getId();
    	post_data.username 	= string.format("user_%s", post_data.mid);
    	post_data.time 		= os.time();
    	post_data.appkey 	= "";
    	post_data.api 		= 273694720;
    	post_data.appid 	= "";
    -- post_data.sitemid = PlatformConfig.imei;
    -- post_data.langtype = UserData.getLangtype(); 	--1:简体 2:繁体
    	post_data.usertype = 1;--UserData.getUserType();	--Android游客:7 sina用户:2 博雅通行证:12 QQ用户:3
    -- post_data.version = PlatformConfig.versionName; -- 版本号
     	post_data.mtkey = "";
     	post_data.vkey  = PlatformConfig.imei;

    -- -- param 参数 携带 sitemid参数  避免和新浪登录冲突
    -- if param_data and not param_data.sitemid then
    -- 	param_data.sitemid = PlatformConfig.imei;
    -- end
end

HttpModule.joins = function(mtkey,t)
  return Joins(t,mtkey);
end

HttpModule.urlOrganizer = function(url,method,httpType)
	if httpType == kHttpGet then
		return url;
	end

	if  string.find(method, "#") then
		local indexs =  string.find( method, "#");
	    local m = "";
	    local p = "";
	    if indexs then
	        m = string.sub(method , 1 , indexs-1);
	        p = string.sub(method , indexs + 1 );
	    end
	    if m ~="" and p ~= "" then
    	 	url = url .. "?m=".. m .. "&p=" .. p;
    	elseif m ~= "" and p == "" then 
    		url = url .. "?m=" .. m;
    	elseif m == "" and p ~= "" then 
    		url = url .. "?m=" .. p;
    	end  
    -- else
    -- 	url=url.."?m="..method;
    end

	return url;
end

HttpModule.execute = function(self,command,data,isShowLoading, continueLast)
	self.m_httpManager:execute(command, data, continueLast);

	local show = isShowLoading or (isShowLoading == nil);
	if show then 
		ToastShade.getInstance():play();
	end 
end

-- 根据指定的域名来
HttpModule.executeDirect = function(self, command, domain, data, isShowLoading)
	self.m_httpManager:executeDirect(command, domain, data);

	local show = isShowLoading or (isShowLoading == nil);
	if show then 
		ToastShade.getInstance():play();
	end 
end

HttpModule.onHttpResponse = function(self,command,errorCode,data, resultStr)
	
	local errMsg = nil;
	if errorCode == HttpErrorType.NETWORKERROR then
		printInfo(command .. "netWorkError")
		errMsg = GameString.get("netWorkError") or "";
		ToastShade.getInstance():stopTimer();
	elseif  errorCode == HttpErrorType.TIMEOUT then
		printInfo(command .. "netWorkTimeout")
		errMsg = GameString.get("netWorkTimeout") or "";
		ToastShade.getInstance():stopTimer();
	elseif  errorCode == HttpErrorType.JSONERROR then	
		printInfo(command .. "netWorkJsonError")
		errMsg = GameString.get("netWorkJsonError") or "";
		ToastShade.getInstance():stopTimer();
	end

	EventDispatcher.getInstance():dispatch(HttpModule.s_event,command,errMsg == nil, errMsg or data, resultStr);
	ToastShade.getInstance():stopCommand();
end

HttpModule.s_cmds = 
{
	GetServerSite = 1,
	GetFeedbackList = 2,
	SendFeedback 	= 3,
	SolveFeedback 	= 4,
	VoteFeedback 	= 5,
	RequestChargeList = 6,
	RequestPayOrder	= 7,
	RequestPayConfig = 8,
	RequestPayConfigForLimit = 9,
	WeChatAccessToken 		 = 10,
};

HttpModule.loginSuffix 		= "?m=login&p=index";
HttpModule.passportQuickUrl = "http://passport.boyaa.com/user/check"; -- 博雅通行证快速登录

HttpModule.s_config = {}

HttpModule.initUrlConfig = function(self, domainChange)

	----local DOMAIN = HallConfig:getDomain()
	local DOMAIN = ConnectModule.getInstance():getDomain()
	HttpModule.s_config = 
	{
		[HttpModule.s_cmds.GetServerSite] = {
			kPhpServerUrl,
			"",
		},
		[HttpModule.s_cmds.GetFeedbackList] = {
			'http://feedback.kx88.net/api/api.php',
			"Feedback.mGetFeedback",
		},
		[HttpModule.s_cmds.SendFeedback] = {
			"http://feedback.kx88.net/api/api.php",
			"Feedback.sendFeedback",
		},
		[HttpModule.s_cmds.SolveFeedback] = {
			"http://feedback.kx88.net/api/api.php",
			"Feedback.mCloseTicket",
		},
		[HttpModule.s_cmds.VoteFeedback] = {
			"http://feedback.kx88.net/api/api.php",
			"Feedback.mPostScore",
		},
		
		[HttpModule.s_cmds.RequestChargeList] = {
			DOMAIN .. "?m=pay&p=getProductProxy&sid=7&appid=%d&pmode=%d", --登录时候根据登录类型来动态设置,
			"",
		},
		[HttpModule.s_cmds.RequestPayOrder] = {
			DOMAIN .. "?m=pay&p=createOrderProxy&id=%d&sitemid=%s&pmode=%s",
			"",
		},
		[HttpModule.s_cmds.RequestPayConfig] = {
			DOMAIN,
			"pay#payconf",
		},
		[HttpModule.s_cmds.RequestPayConfigForLimit] = {
			DOMAIN,
			"pay#payconf"
		},
		[HttpModule.s_cmds.WeChatAccessToken] = {
			'https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&grant_type=%s',
			""
		},
	};

	self.m_httpManager:setConfigMap(HttpModule.s_config);
end