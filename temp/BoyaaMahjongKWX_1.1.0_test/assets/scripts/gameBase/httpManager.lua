-- HttpManager.lua
-- Author: Vicent.Gong
-- Date: 2013-01-08
-- Last modification : 2013-07-12
-- Description: Implemented a http manager,to manager all http request.

require("core/constants");
require("core/object");
require("core/http");
require("core/eventDispatcher");
require("libs/json_wrap");

HttpConfigContants = 
{
	URL = 1,
	METHOD = 2,
	TYPE = 3,
	TIMEOUT = 4,
};

HttpErrorType = 
{
	SUCCESSED = 1,
	TIMEOUT = 2,
	NETWORKERROR = 3,
	JSONERROR = 4,
};

HttpManager = class();
HttpManager.s_event = EventDispatcher.getInstance():getUserEvent();

HttpManager.ctor = function(self,configMap,postDataOrganizer,urlOrganizer)
	self.m_httpCommandMap = {};
	self.m_commandHttpMap = {};
	self.m_commandTimeoutAnimMap = {};
	
	HttpManager.setConfigMap(self,configMap);
	HttpManager.setPostDataOrganizer(self,postDataOrganizer);
	HttpManager.setUrlOrganizer(self,urlOrganizer);

	

	self.m_timeout  = 18000;
end

HttpManager.getConfigMap = function(self)
	return self.m_configMap;
end

HttpManager.setConfigMap = function(self,configMap)
	HttpManager.destroyAllHttpRequests(self);
	self.m_configMap = configMap or {};
end

HttpManager.appendConfigs = function(self,configMap)
	for k,v in pairs(configMap or {}) do
		self.m_configMap[k] = v;
	end
end

HttpManager.setDefaultTimeout = function(self,time)
	self.m_timeout = time or self.m_timeout;
end

HttpManager.setPostDataOrganizer = function(self,postDataOrganizer)
	self.m_postDataOrganizer = postDataOrganizer;
end

HttpManager.setUrlOrganizer = function(self,urlOrganizer)
	self.m_urlOrganizer = urlOrganizer;
end

HttpManager.execute = function(self,command,data, continueLast)
	if not HttpManager.checkCommand(self,command) then
		return false;
	end
	if not continueLast then
		HttpManager.destroyHttpRequest(self,self.m_commandHttpMap[command]);
	end

	local config = self.m_configMap[command];
	local httpType = config[HttpConfigContants.TYPE] or kHttpPost;

	local url = self.m_urlOrganizer(config[HttpConfigContants.URL],
								config[HttpConfigContants.METHOD],
								httpType);
	print_string("-------------------------------------------------------------------------------------------------")
	print_string("发起php请求: " .. url);
	
	local httpRequest = new(Http,httpType,kHttpReserved,url)
	httpRequest:setTimeout(self.m_timeout, self.m_timeout);
	httpRequest:setEvent(self, self.onResponse);

	if httpType == kHttpPost then 
		local postData =  self.m_postDataOrganizer(config[HttpConfigContants.METHOD],data);
		httpRequest:setData(postData);
	end

    self.m_httpCommandMap[httpRequest] = command;
    self.m_commandHttpMap[command] = httpRequest;

    -- 如果是多次请求不覆盖 则只生成一个超时计时器就可以了 避免报错
    if not continueLast or not self.m_commandTimeoutAnimMap[command] then
		local timeoutAnim = HttpManager.createTimeoutAnim(self,command,config[HttpConfigContants.TIMEOUT] or self.m_timeout);
   		self.m_commandTimeoutAnimMap[command] = timeoutAnim;
	end

	httpRequest:execute();
	print_string("-------------------------------------------------------------------------------------------------\n")
end

-- 根据域名直接请求
HttpManager.executeDirect = function(self, command, domain, data)
	if not HttpManager.checkCommand(self,command) then
		return false;
	end

	HttpManager.destroyHttpRequest(self,self.m_commandHttpMap[command]);

	local config = self.m_configMap[command];
	local httpType = config[HttpConfigContants.TYPE] or kHttpPost;

	print_string("-------------------------------------------------------------------------------------------------")
	print_string("发起php请求: " .. domain);
	
	local httpRequest = new(Http,httpType,kHttpReserved,domain)
	httpRequest:setTimeout(self.m_timeout, self.m_timeout);
	httpRequest:setEvent(self, self.onResponse);

	if httpType == kHttpPost then 
		local postData =  self.m_postDataOrganizer(config[HttpConfigContants.METHOD],data);
		httpRequest:setData(postData);
	end

	local timeoutAnim = HttpManager.createTimeoutAnim(self,command,config[HttpConfigContants.TIMEOUT] or self.m_timeout);

    self.m_httpCommandMap[httpRequest] = command;
    self.m_commandHttpMap[command] = httpRequest;
    self.m_commandTimeoutAnimMap[command] = timeoutAnim;

	httpRequest:execute();
	print_string("-------------------------------------------------------------------------------------------------\n")
end

HttpManager.dtor = function (self)
	HttpManager.destroyAllHttpRequests(self);

    self.m_httpCommandMap = nil;
    self.m_commandHttpMap = nil;
	self.m_commandTimeoutAnimMap = nil;

	self.m_configMap = nil;
end

---------------------------------private functions-----------------------------------------

HttpManager.checkCommand = function(self, command)
	local errLog = nil;

	repeat 
		if not (command or self.m_configMap[command]) then
			errLog = "There is not command like this";
			break;
		end

		local config = self.m_configMap[command];

		if not config[HttpConfigContants.URL] then
			errLog = "There is not url in command";
			break;
		end

		if not config[HttpConfigContants.METHOD] then
			errLog = "There is not method in command";
			break;
		end

		local httpType = config[HttpConfigContants.TYPE];
		if httpType ~= nil and httpType ~= kHttpPost and  httpType ~= kHttpGet then
			errLog = "Not supported http request type";
			break;
		end
	until true

	if errLog then
		HttpManager.log(self,command,errLog);
		return false;
	end

	return true;
end

HttpManager.log = function(self, command, str)
	local prefixStr = "HttpRequest error :";
	if config then
		prefixStr =prefixStr .. " command |" .. command;
	end

	FwLog(prefixStr .. " | " .. str);
end

HttpManager.onResponse = function(self , httpRequest)
	local command = self.m_httpCommandMap[httpRequest];

	if not command then
		HttpManager.destroyHttpRequest(self,httpRequest);
		return;
	end

	HttpManager.destoryTimeoutAnim(self,command);
 
 	local errorCode = HttpErrorType.SUCCESSED;
 	local data = nil;
   	local resultStr;
	repeat 
		-- 判断http请求的错误码,0--成功 ，非0--失败.
		-- 判断http请求的状态 , 200--成功 ，非200--失败.
		if 0 ~= httpRequest:getError() or 200 ~= httpRequest:getResponseCode() then
			errorCode = HttpErrorType.NETWORKERROR;
			break;
		end
	
		-- http 请求返回值
		resultStr =  httpRequest:getResponse();
		print_string("requestUrl ===========>> " .. httpRequest:getRequestUrl());
		print_string("resultStr  ===========>> " .. resultStr);
		-- http 请求返回值的json 格式
		local json_data = json.decode_node(resultStr);
		--返回错误json格式.
	    if not json_data:get_value() then
	    	errorCode = HttpErrorType.JSONERROR;
			break;
	    end

	    data = json_data;
	until true;

    EventDispatcher.getInstance():dispatch(HttpManager.s_event,command,errorCode, data, resultStr);
	
	HttpManager.destroyHttpRequest(self,httpRequest);
end

HttpManager.onTimeout = function(callbackObj)
	local self = callbackObj["obj"];
	local command = callbackObj["command"];
    --Log.w("http 请求超时");
	EventDispatcher.getInstance():dispatch(HttpManager.s_event,command,HttpErrorType.TIMEOUT);

	HttpManager.destroyHttpRequest(self,self.m_commandHttpMap[command]);
end

HttpManager.createTimeoutAnim = function(self,command,timeoutTime)
	local timeoutAnim = new(AnimInt,kAnimRepeat,0,1,timeoutTime,-1);
	timeoutAnim:setDebugName("AnimInt | httpTimeoutAnim");
    timeoutAnim:setEvent({["obj"] = self,["command"] = command},self.onTimeout);

    return timeoutAnim;
end

HttpManager.destoryTimeoutAnim = function(self,command)
	local anim = self.m_commandTimeoutAnimMap[command];
	delete(anim);

	self.m_commandTimeoutAnimMap[command] = nil;
end

HttpManager.destroyHttpRequest = function(self,httpRequest)
	if not httpRequest then 
		return;
	end

	local command = self.m_httpCommandMap[httpRequest];
	
	if not command then
		delete(httpRequest);
	    return;
	end

	HttpManager.destoryTimeoutAnim(self,command);
	self.m_commandHttpMap[command] = nil;
	self.m_httpCommandMap[httpRequest] = nil;
end

HttpManager.destroyAllHttpRequests = function(self)
	for _,v in pairs(self.m_commandHttpMap)do 
		HttpManager.destroyHttpRequest(self,v);
	end
end
