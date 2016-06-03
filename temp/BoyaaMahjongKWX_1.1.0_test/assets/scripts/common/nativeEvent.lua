
-- NativeEvent.lua
-- 本地事件方法
NativeEvent = class();
local printInfo, printError = overridePrint("NativeEvent")

NativeEvent.s_platform = System.getPlatform();

NativeEvent.getInstance = function()
	if not NativeEvent.s_instance then
		NativeEvent.s_instance = new(NativeEvent);
	end
	return NativeEvent.s_instance;
end

NativeEvent.onEventCall = function()
	local callParam, json_data, resultStr = NativeEvent.getInstance():getNativeCallResult();
	-- -- 全局有效的本地方法 在此处拦截
	printInfo("java 调用 lua 方法 callParam = %s", callParam or "null")
	printInfo("json_data")
	if json_data then dump(json_data) end
	printInfo("resultStr")
	if resultStr then printInfo("%s", resultStr) end
	NativeEvent.getInstance():onNativeCallDone(callParam, json_data, resultStr);
end

NativeEvent.onEventPause = function(self)
	audio_music_pause()
end

-- application come to foreground
NativeEvent.onEventResume = function(self)
	printInfo("NativeEvent.onEventResume")
	if GameSetting then
    	GameSetting:setIsSecondScene(false)
	end
	self:CloseStartScreen()
	audio_music_resume()
end

NativeEvent.onNativeCallDone = function(self, param, ...)
	if NativeEvent.callEventFuncMap[param] then
		NativeEvent.callEventFuncMap[param](self, ...);
	else
		EventDispatcher.getInstance():dispatch(Event.Call, param,...);
	end
end

NativeEvent.onWinKeyDown = function(key)
	printInfo("onWinKeyDown" .. key)
	if key == 60 or key == 81 then --Q 键返回
		EventDispatcher.getInstance():dispatch(Event.Back);
	elseif key == 55 or key == 76 then -- L键 debug
		dofile("../Resource/scripts/debug.lua")
	else
		EventDispatcher.getInstance():dispatch(Event.KeyDown,key);
	end
end


-- 公共 call_native 方法  和原生交互的唯一方法
NativeEvent.callNativeEvent = function(self, keyParm, data)
	if data then
		dict_set_string(keyParm, keyParm .. kparmPostfix, data);
	end
	dict_set_string(kLuaCallEvent, kLuaCallEvent, keyParm);
	call_native("OnLuaCall");
end

-- 解析 call_native 返回值
NativeEvent.getNativeCallResult = function(self)
	local callParam = dict_get_string(kLuaCallEvent, kLuaCallEvent);
	local callResult = dict_get_int(callParam, kCallResult, -1);
    if callResult ~= 0 then -- 获取数值失败
        return callParam , false;
    end
    local result = dict_get_string(callParam, callParam .. kResultPostfix);
    dict_delete(callParam);
    local json_data = json.decode_node(result);
    return callParam, json_data, result;
end

---------------------  调用方法 ------------------------
-- 立即返回结果的的操作
NativeEvent.encodeStr = function(self, str)
	local key = "encodeStr"
	self:callNativeEvent(key, str)
   	return dict_get_string(key, key .. kResultPostfix);
end

NativeEvent.compressString = function(self, str)
	local key = "compressString"
	self:callNativeEvent(key, str)
	return dict_get_string(key, key .. kResultPostfix)
end

NativeEvent.unCompressString = function(self, str)
	local key = "unCompressString"
	self:callNativeEvent(key, str)
	return dict_get_string(key, key .. kResultPostfix)
end

NativeEvent.isFileExist = function(self, filePath, fileFolder)
	local key = "isFileExist"
	local tab = {}
	tab.path = filePath
	tab.folder = fileFolder
	self:callNativeEvent(key, json.encode(tab))
	return dict_get_int(key, key .. kResultPostfix, 0)
end

-- 获取手机安装的应用市场个数:
NativeEvent.getMarketNum = function(self)
	local key = "getMarketNum"
	self:callNativeEvent(key)
	return dict_get_int(key, key .. kResultPostfix, 0)
end

-- 跳转手机应用
NativeEvent.launchMarket = function( self )
	local key = "launchMarket"
	self:callNativeEvent(key)
end

-- 发送邀请通过短信
NativeEvent.sendMessageToPlayer = function( self , msg)
	local key = "sendMessageToPlayer"
	local tab = {}
	tab.message = msg
	tab.number = ""
	self:callNativeEvent(key, json.encode(tab))
end

-- 发送邀请通过share
NativeEvent.shareOnlyMessage = function( self , style, message, url, logo)
	local key = "shareOnlyMessage"
	local tab = {}
	tab.style = style
	tab.logo = logo
	tab.url = url
	tab.message = message
	self:callNativeEvent(key, json.encode(tab))
end

-- 涉及ui的操作 放在消息队列中执行
-- 延时释放 defualt png , 解决 Android 游戏启动时屏幕黑一下的问题
NativeEvent.CloseStartScreen = function(self)
	local key = "CloseStartScreen"
	self:callNativeEvent(key)
end

NativeEvent.GetInitValue =function(self)
	local key = "GetInitValue"
	self:callNativeEvent(key)
    return dict_get_string(key, key.."_result");
end

NativeEvent.GetNetAvaliable = function(self)
	local key = "GetNetAvaliable"
	self:callNativeEvent(key)
    return dict_get_int(key, key..kResultPostfix, 0);
end

NativeEvent.PreloadAllSound = function(self, musicsMap, effectsMap)
    local key = "LoadSoundRes"
	local tab={};
    tab.bgMusic = musicsMap;
    tab.soundRes = effectsMap;
    self:callNativeEvent(key, json.encode(tab))
end

NativeEvent.ReportLuaError = function(self, faultInfo)
	local key = "ReportLuaError"
	local tab = {};
	tab.faultInfo = faultInfo;
    local json_data = json.encode(tab);
	self:callNativeEvent(key, json_data);
end

NativeEvent.Exit = function(self)
	local key = "Exit"
	self:callNativeEvent(key)
end

NativeEvent.StartUnitePay = function(self, param_data)
	local key = "unitePay"
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 初始化活动
NativeEvent.initWebView = function(self, param_data)
	local key = "initWebView"
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 打开活动
NativeEvent.openWebView = function(self, param_data)
	local key = "openWebView"
	param_data = {}
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 拍照
NativeEvent.takePhoto = function(self, userId)
	self:callNativeEvent(kTakePhoto, json.encode({name = tostring(userId)}));
end

--选择图片
NativeEvent.pickPhoto = function(self, userId)
	self:callNativeEvent(kPickPhoto, json.encode({name = tostring(userId)}));
end

--上传图片
NativeEvent.uploadImage = function(self, url, uploadImageName, doType)
	local api = PhpManager:getAPI();
	api['do'] = doType;
	self:callNativeEvent(kUploadImage, json.encode({url = url, uploadImageName = uploadImageName, api = api, ['type'] = 0}));
end

--上传图片
NativeEvent.uploadFeedbackImage = function(self, url, uploadImageName, api)
	self:callNativeEvent(kUploadFeedbackImage, json.encode({url = url, uploadImageName = uploadImageName, api = api, ['type'] = 1}));
end

--打开网页
NativeEvent.openWeb = function(self, url)

    local api=PhpManager:getAPI();
	self:callNativeEvent(kOpenWeb, json.encode({url = url, api = api}));
end

--打开网页
NativeEvent.closeWeb = function(self)
	self:callNativeEvent(kCloseWeb, json.encode({}));
end

--打开条款
NativeEvent.openRule = function(self, ruleUrl)
	self:callNativeEvent(kOpenRule, json.encode({url = ruleUrl,api = PhpManager:getAPI()}));
end

--关闭条款
NativeEvent.closeRule = function(self)
	self:callNativeEvent(kCloseRule, json.encode({}));
end

--打开第三方登录
NativeEvent.login = function(self, param)
	self:callNativeEvent(kLogin, json.encode(param));
end

--本地更新
NativeEvent.UpdateByLocal = function(self, url, force)
	local param = {
					url 	= url,
					force 	= force or 0,
				};

	self:callNativeEvent(kUpdateByLocal , json.encode(param));
end
--友盟更新
NativeEvent.UpdateByUmeng = function(self, isActUpdata, isDeltaUpdate, isForceUpdate, isCheckForProcess)
	local param = {
					isActUpdata 		= isActUpdata,
					isDeltaUpdate 		= isDeltaUpdate,
					isForceUpdate 		= isForceUpdate,
					isCheckForProcess 	= isCheckForProcess,
				};

	self:callNativeEvent(kUpdateByUmeng , json.encode(param));
end

--检查本地更新
NativeEvent.CheckPackByLocal = function(self, url)
	local param = {
					url 	= url,
				};

	self:callNativeEvent(kCheckPackByLocal , json.encode(param));
end


NativeEvent.downloadImage = function(self, url, folder, name, callback)

	self.downloadId = self.downloadId and (self.downloadId + 1) or 1;

	local param = {
					id 		= self.downloadId,
					url 	= url,
					folder 	= folder,
					name 	= name,
				};
	NativeEvent.callEventFuncMap[tostring(self.downloadId)] = callback;
	self:callNativeEvent(kDownloadImage , json.encode(param));
end

--重命名图片
NativeEvent.renameImage = function(self, oldName, newName, url)

	local param = {
					oldName = oldName,
					newName = newName,
					url 	= url;
				};

	self:callNativeEvent(kRenameImage , json.encode(param));
end

--下载文件
--type: 'image' or 'audio'
NativeEvent.downloadFile = function(self, type, url, file, tag)
	printInfo("开始下载文件")
	local param = {
					file 	= file,
					type 	= type,
					url 	= url,
					tag 	= tag,
				};

	self:callNativeEvent(kDownloadFile , json.encode(param));
end

--解压文件
--type: 'image' or 'audio'
NativeEvent.unzip = function(self, type, path, file, tag)

	local param = {
					file 	= file,
					type 	= type,
					path 	= path,
					tag 	= tag,
				};

	self:callNativeEvent(kUnzip , json.encode(param));
end

NativeEvent.shareFromTask = function(self, param_data)
	local key = "shareTask"
	param_data = param_data or {}
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 分享到朋友圈
NativeEvent.shareToFriend = function(self, param_data)
	local key = "shareToFriend"
	param_data = param_data or {}
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 跳转到QQ群
NativeEvent.jumpToQQGroup = function(self, param_data)
	local key = "jumpToQQGroup"
	param_data = param_data or {}
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 平台退出
NativeEvent.platformManagerExit = function(self, param_data)
	local key = "platformManagerExit"
	param_data = param_data or {}
	local json_data = json.encode(param_data)
	self:callNativeEvent(key, json_data)
end

-- 传递当前服务器类型，开发测试用
NativeEvent.ServerType = function(self, type)
	local param = {
		["type"] = type,
	}
	if isPlatform_IOS then
		self:callNativeEvent("serverType", json.encode(param))
	end
end

-- 大厅登陆成功给原生一个通知，方便进行一些操作
NativeEvent.lobbyLoginSuccessed = function(self)
	if isPlatform_IOS then
		self:callNativeEvent("lobbyLoginSuccessed")
	end
	-- 传递当前服务器类型，开发测试用
	NativeEvent.ServerType = function(self, type)
		local param = {
			["type"] = type,
		}
		if isPlatform_IOS then
			self:callNativeEvent("serverType", json.encode(param))
		end
	end

	-- 大厅登陆成功给原生一个通知，方便进行一些操作
	NativeEvent.lobbyLoginSuccessed = function(self)
		if isPlatform_IOS then
			self:callNativeEvent("lobbyLoginSuccessed")
		end
	end
end

--///////////////////////////////// Win32 ////////////////////////////////
if isPlatform_Win32() then
	NativeEvent.callNativeEvent = function(self, keyParm , data)
	end

	-- 拍照
	NativeEvent.takePhoto = function(self, str)
	end

	--选择图片
	NativeEvent.pickPhoto = function(self, str)
	end

	--上传图片
	NativeEvent.uploadImage = function(self, str)
	end

	--打开网页
	NativeEvent.openWeb = function(self, url)
	end

	--打开网页
	NativeEvent.closeWeb = function(self)
	end

	--打开条款
	NativeEvent.openRule = function(self, ruleUrl)
	end

	--关闭条款
	NativeEvent.closeRule = function(self)
	end

	--打开第三方登录
	NativeEvent.login = function(self, param)
	end

	--本地更新
	NativeEvent.UpdateByLocal = function(self, url, force)
	end
	--友盟更新
	NativeEvent.UpdateByUmeng = function(self, isActUpdata, isDeltaUpdate, isForceUpdate, isCheckForProcess)
	end
	--检测更新
	NativeEvent.CheckPackByLocal = function(self, url)
	end
	--头像下载
	NativeEvent.downloadImage = function(self, id, url, folder, name)
	end
	--重命令头像
	NativeEvent.renameImage = function(self, oldName, newName, url)
	end
	--下载文件
	NativeEvent.downloadFile = function(self, type, url, file, tag)
		printInfo("开始下载文件")
	end
	--解压文件
	NativeEvent.unzip = function(self, type, path, file, tag)
	end
	-- 立即返回结果的的操作
	NativeEvent.encodeStr = function(self, str)
		return str
	end

	NativeEvent.compressString = function(self, str)
	end

	NativeEvent.unCompressString = function(self, str)
	end

	NativeEvent.isFileExist = function(self, str)
	end

	-- 涉及ui的操作 放在消息队列中执行
	--延时释放 defualt png , 解决 Android 游戏启动时屏幕黑一下的问题
	NativeEvent.CloseStartScreen = function(self)
	end

    NativeEvent.GetInitValue =function(self)
    end

    NativeEvent.GetNetAvaliable = function(self)
    	return 1
    end

    NativeEvent.PreloadAllSound = function(self, musicsMap, effectsMap)
	end

	NativeEvent.ReportLuaError = function(self, faultInfo)
	end

	NativeEvent.Exit = function(self)
	end

	NativeEvent.StartUnitePay = function(self, param_data)
	end

	NativeEvent.initWebView = function(self, param_data)
	end

	NativeEvent.openWebView = function(self, param_data)
	end

	NativeEvent.shareToFriend = function(self, param_data)
	end

	NativeEvent.jumpToQQGroup = function(self, param_data)
	end

	-- 平台退出
	NativeEvent.platformManagerExit = function(self, param_data)
	end

	NativeEvent.ServerType = function(self, type)
	end

	NativeEvent.lobbyLoginSuccessed = function(self)
	end
end

function NativeEvent:onLoadSoundResCallback(jsonData, resultStr)
	-- AlarmTip.play("resultStr =" .. resultStr)
end

function NativeEvent:onActiviyCloseCallback(jsonData, resultStr)
	WindowManager:onKeyBack();
end

function NativeEvent:onDownloadImageCallback(jsonData)
	printInfo("NativeEvent:onDownloadImageCallback")
	dump(jsonData)
	local stat 		= jsonData.stat:get_value();
	local folder 	= jsonData.folder:get_value();
	local name 		= jsonData.name:get_value();
	local id 		= tostring(jsonData.id:get_value());
	local callback = NativeEvent.callEventFuncMap[tostring(id)];

	if callback then
		callback(stat, folder, name);
	end

	NativeEvent.callEventFuncMap[id] = nil;
end

function NativeEvent:onUnitePayCallback(jsonData)
	-- body
	local status = jsonData.status:get_value(); -- 0 成功 1 取消 2 失败
	if(status and tonumber(status) == 0) then
       AlarmTip.play("您的支付请求已发送，可能由于网络延时，金币将会稍后到帐，请耐心等待")
    else --失敗或者取消
       UnitePay.getInstance():showMutiPay();
    end
end

function NativeEvent:onDownloadFileCallback(jsonData)
	printInfo('kDownloadFile finish');
	printInfo("status = " .. jsonData.status:get_value() or "");
	printInfo("path = " .. jsonData.path:get_value() or "");
	printInfo("url = " .. jsonData.url:get_value() or "");
	local status = tonumber(jsonData.status:get_value()) or 0
	local tag = jsonData.tag:get_value() or ""
	local path = jsonData.path:get_value() or ""
	local type = jsonData.type:get_value() or ""
	local progress = jsonData.progress:get_value() or ""
	if status == 1 then  --下载成功
		AlarmTip.play(string.format("下载%s完成，正在解压", tag))
		local folder
		if tag == "表情" then
			folder = "expression/"
		elseif tag == "道具" then
			folder = "friendsAnim/"
		elseif tag == "广东声音" then
			folder = "ogg/gdmj/"
		elseif tag == "上海声音" then
			folder = "ogg/shmj/"
		elseif tag == "襄阳声音" then
			folder = "ogg/kwxmj/"
		end
		NativeEvent.getInstance():unzip(type, folder, path, tag);
	elseif status == 2 then  --正在下载
		local progress = jsonData.progress:get_value() or 0
		AlarmTip.play(string.format("正在下载%s %s", tag, progress) .. "%s", "\%")
	else --下载异常失败
		if tag == "表情" then
			PhpManager:setFaceCanUse(0)
		elseif tag == "道具" then
			PhpManager:setPropCanUse(0)
		elseif tag == "广东声音" then
			PhpManager:setGdmjCanUse(0)
		elseif tag == "上海声音" then
			PhpManager:setShmjCanUse(0)
		elseif tag == "襄阳声音" then
			PhpManager:setKwxmjCanUse(0)
		end
		AlarmTip.play(string.format("下载%s失败", tag))
	end
end

function NativeEvent:onUnzipCallback(jsonData)
	printInfo('kUnzip finish');
	printInfo("status = " .. jsonData.status:get_value() or "");
	printInfo("path = " .. jsonData.path:get_value() or "");
	printInfo("file = " .. jsonData.file:get_value() or "");
	local status = tonumber(jsonData.status:get_value()) or 0
	local tag = jsonData.tag:get_value() or ""
	if status == 1 then
		AlarmTip.play(string.format("解压%s完成", tag))
		if tag == "表情" then
			PhpManager:setFaceCanUse(1)
		elseif tag == "道具" then
			PhpManager:setPropCanUse(1)
		elseif tag == "广东声音" then
			PhpManager:setGdmjCanUse(1)
		elseif tag == "上海声音" then
			PhpManager:setShmjCanUse(1)
		elseif tag == "襄阳声音" then
			PhpManager:setKwxmjCanUse(1)
		end
	else
		AlarmTip.play(string.format("解压%s失败", tag))
	end
end

function NativeEvent:onUploadImageCallBack(result)
	printInfo("NativeEvent:onUploadImageCallBack")
	dump(result)
	if result and result.flag:get_value() and MyUserData:getId() > 0 then
		printInfo("这是上传反馈的图片")
		return
	end
	printInfo("这是上传头像的图片")
	if result and tonumber(result.status:get_value() or 0) == 1 and MyUserData:getId() > 0 then
		AlarmTip.play("上传头像成功");
		local url = result.data.big:get_value();
		local md5Name = ToolKit.getMd5ImageName(kHeadImagePrefix, MyUserData:getId(), url);
		NativeEvent.getInstance():renameImage(MyUserData:getUploadTemp(), string.format("%s%s",kHeadImageFolder, md5Name), url);
	else
		AlarmTip.play("上传头像失败");
	end
end

function NativeEvent:onUploadFeedbackImageCallBack(result)
	printInfo("NativeEvent:onUploadFeedbackImageCallBack")
	-- if result and result.ret and tonumber(result.ret.isSave:get_value() or 0) == 1 and MyUserData:getId() > 0 then
	-- 	-- AlarmTip.play("上传成功")
	-- else
	-- 	-- AlarmTip.play("上传头像失败")
	-- end
end

function NativeEvent:onRenameImageCallBack(result)
	printInfo("NativeEvent:onRenameImageCallBack")
	dump(result)
	if result and tonumber(result.status:get_value() or 0) == 1 and MyUserData:getId() > 0 then
		url = result.url:get_value();
		MyUserData:setHeadUrl(url);
	end
end

function NativeEvent:onShareSuccessCallBack(result)
	printInfo("NativeEvent:onRenameImageCallBack")
	dump(result)
	GameSocketMgr:sendMsg(Command.SETSHARE_PHP_REQUEST, {}, false)
end

function NativeEvent:onReconnectTimeOutCallback(result)
	dump(result)
	if app:isInRoom() then
		GameSocketMgr:closeSocketSync()
	end
end

-- 获取用户ID
function NativeEvent:getUID()
	if MyUserData:getId() > 0 then
		dict_set_int("getUID", "getUID", MyUserData:getId())
	end
end

-- 获取用户信息，有需要可以继续添加
function NativeEvent:getUserInfo()
	if MyUserData:getId() > 0 then
		local param = {
						id 			= MyUserData:getId(),			-- 用户ID
						nick		= MyUserData:getNick(),			-- 用户昵称
						mtkey 		= MyUserData:getMtkey(),		-- mtkey
						userType 	= MyUserData:getUserType(),		-- 用户类型
					};
		self:callNativeEvent("getUserInfo", json.encode(param));
	end
end

-- 显示Loading界面
function NativeEvent:playLoading()
	GameLoading:addPhpCommand(9999)
end

-- 移除添加的Loading界面
function NativeEvent:stopLoading()
	GameLoading:onCommandResponse(9999)
end

-- 显示Banner条
function NativeEvent:showBanner()
	local text = dict_get_string("bannerMsg", "bannerMsg")
	AlarmTip.play(text)
end

-- 播放按键音，原生写的按钮没有音效，可以通过调用这个来解决
function NativeEvent:playClickSound()
	kEffectPlayer:play(Effects.AudioButtonClick);
end

-- 获取当前Server域名
function NativeEvent:getCurrentServerURL()
	printInfo("getCurrentServerURL")
	---- local url = HallConfig:getDomain()
	local DOMAIN = ConnectModule.getInstance():getDomain()
	dict_set_string("getCurrentServerURL", "getCurrentServerURL", json.encode(url));
end

-- 获取当前的活动中心域名
function NativeEvent:getCurrentActivityURL()
	-- ServerType = {
	-- 	Normal = 0,  -- 正式服
	-- 	Test = 1,    -- 测试服
	-- 	Dev = 2, 	 -- 开发服
	-- 	Define = 3,  -- 自定义
	-- }
	local urls = {
		[0] = kPhpActivityNormal,		-- 正式
		[1] = kPHPActivityURLTest,		-- 测试
		[2] = kPHPActivityURLTest,		-- 开发
	}
	----local url = urls[HallConfig:getServerType()]
	local url = urls[ConnectModule.getInstance():getServerType()]
	dict_set_string("getCurrentActivityURL", "getCurrentActivityURL", json.encode(url))
end

-- iOS上报推送Token
function NativeEvent:reportAPNSToken(info)
	printInfo("reportAPNSToken")
	GameSocketMgr:sendMsg(Command.IOS_REPORT_PUSH_TOKEN_REQUEST, {['APNSToken']=tostring(info.APNSToken:get_value()), ['channel_id']=tostring(info.channel_id:get_value())},false);
end

-- iPad分辨率特殊，需要其他分辨率的牌桌，iOS版本用这个方法来切换牌桌，对安卓没有影响。默认牌桌写在了app.lua的lobbyLoginSuccessed方法里
function NativeEvent:SwitchRoomTableWhileIPAD()
	printInfo("SwitchRoomTableWhileIPAD")
	kRoomTable = "kwx_room/roomTable_iPad.png"
end

NativeEvent.callEventFuncMap = {
	["LoadSoundRes"]  	= NativeEvent.onLoadSoundResCallback,
	["activityClose"] 	= NativeEvent.onActiviyCloseCallback,
	["downloadImage"] 	= NativeEvent.onDownloadImageCallback,
	["UnitePayCallback"]= NativeEvent.onUnitePayCallback,
	["reconnectTimeOut"]= NativeEvent.onReconnectTimeOutCallback,
	[kDownloadFile] 	= NativeEvent.onDownloadFileCallback,
	[kUnzip] 			= NativeEvent.onUnzipCallback,
	[kUploadImage] 		= NativeEvent.onUploadImageCallBack,
	-- [kUploadFeedbackImage] 		= NativeEvent.onUploadFeedbackImageCallBack,
	[kRenameImage] 		= NativeEvent.onRenameImageCallBack,
	["ShareSuccess"]	= NativeEvent.onShareSuccessCallBack,
	-- 获取用户信息
	["getUID"]				=	NativeEvent.getUID,
	["getUserInfo"]			=	NativeEvent.getUserInfo,

	-- 加载和移除Loading界面
	["playLoading"]			=	NativeEvent.playLoading,
	["stopLoading"]			=	NativeEvent.stopLoading,

	-- 显示Banner条
	["showBanner"]			=	NativeEvent.showBanner,

	-- 播放按键音，用来处理原生的一些操作没有按键音效的问题，比如触摸输入框
	["playClickSound"]		=	NativeEvent.playClickSound,

	-- 获取服务器列表
	["getCurrentServerURL"] = NativeEvent.getCurrentServerURL,
	["getCurrentActivityURL"] = NativeEvent.getCurrentActivityURL,

	-- 上报iOS推送Token，远程推送要用到
	["reportAPNSToken"] = NativeEvent.reportAPNSToken,

	-- 切换牌桌图片
	["SwitchRoomTableWhileIPAD"] = NativeEvent.SwitchRoomTableWhileIPAD,
};
