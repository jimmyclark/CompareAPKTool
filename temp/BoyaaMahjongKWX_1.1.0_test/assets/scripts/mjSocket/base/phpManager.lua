local PhpManager = class()

local s_commandMap = {
	[Command.LOGIN_PHP_REQUEST] 					= 	"login#login",
	-- [Command.USERINFO_PHP_REQUEST]					=	"user#getinfo",
	[Command.NOTICE_PHP_REQUEST]					=	"system#notice",
	[Command.PAY_PHP_REQUEST]						=	"newpay#getproduct",
	[Command.PAY_CONFIG_PHP_REQUEST]				=	"pay#getconf",
	[Command.PAY_CONFIG_LIMIT_PHP_REQUEST]			=	"pay#getconf",
	[Command.ORDER_PHP_REQUEST]						=	"newpay#createorder",
	[Command.PAY_RECOMMEND_PHP_REQUEST]				=	"pay#recommend",
	[Command.TASK_RC_PHP_REQUEST]					=	"task#getlist",
	-- [Command.TASK_CZ_PHP_REQUEST]					=	"task#getlist",
	[Command.UPDATE_PHP_REQUEST] 					= 	"system#get_update",
	[Command.SETUPDATE_PHP_REQUEST] 				= 	"system#set_update",
	[Command.REGISTER_SECURITY_CODE_PHP_REQUEST] 	= 	"user#verifycode",
	[Command.FORGOT_PASSWORD_PHP_REQUEST] 			= 	"user#findpwd",
    [Command.SIGN_AWARD_PHP_REQUEST]                = 	"qiandao#signinfo",
    [Command.SIGN_GETAWARD_PHP_REQUEST]             = 	"qiandao#award",
    [Command.SIGN_GETGIFTAWARD_PHP_REQUEST]         = 	"qiandao#award",
    [Command.SIGN_BQ_GETAWARD_PHP_REQUEST]          = 	"qiandao#award",
    [Command.FIRST_PAY_BAG_PHP_REQUEST]             = 	"firstpay#detail",

	[Command.RANK_DIANFENG_PHP_REQUEST] 			= 	"ranking#getlist",
	[Command.RANK_ZHANSHEN_PHP_REQUEST] 			= 	"ranking#getlist",
	[Command.RANK_FUHAO_PHP_REQUEST] 				= 	"ranking#getlist",
	[Command.RANK_DIANFENG_GET_AWARD_PHP_REQUEST]   =   "ranking#getPeakAward",
	[Command.ANTI_ADDICTION_PHP_REQUEST] 			= 	"user#verify",
	[Command.TASK_AWARD_PHP_REQUEST] 				= 	"task#award",
	[Command.PO_CHAN_PHP_REQUEST]                   = 	"bankrupt#index",
	[Command.PO_CHAN_TIME_PHP_REQUEST]				=	"bankrupt#index",
	[Command.MODIFY_USERINFO_PHP_REQUEST]           = 	"user#setinfo",
	[Command.PROP_PHP_REQUEST]                   	= 	"prop#get_list",
	[Command.ROOM_CONFIG_PHP_REQUEST]				=   "room#getlist",
	[Command.GET_ACTRELATED_PHP_REQUEST]            =   "activity#actrelated",	-- iOS需要这个接口来获取活动数量
	[Command.UPDATE_AWARD_PHP_REQUEST]   			=   "system#update_award",
	[Command.NOTIFY_UPDATE_AWARD_PHP_REQUEST]   	=   "system#upnotice",
	[Command.GET_BASEINFO_PHP_REQUEST]   			=   "baseinfo#index",

	[Command.EXCHANGE_LIST_REQUEST]					=	"market#goodslist",
	[Command.EXCHANGE_GOODS_REQUEST]				=	"market#exchange",
	[Command.EXCHANGE_RECORD_REQUEST]				=	"market#getchangelog",

	[Command.ROOM_GAME_BOX_STATUS_REQUEST]			=	"box#open",
	[Command.ROOM_GAME_BOX_DETAIL_REQUEST]			=	"box#detail",
	[Command.ROOM_GAME_BOX_AWARD_REQUEST]		    =	"box#award",
	[Command.ROOM_GAME_ACTIVITY_STATUS_REQUEST]		=	"goldoff#index",
	[Command.ROOM_GAME_ACTIVITY_DETAIL_REQUEST]		=	"goldoff#index",
	[Command.ROOM_GAME_ACTIVITY_AWARD_REQUEST]		= 	"goldoff#index",
	-- 一键屏蔽
	[Command.ONEKEY_HIDE_PHP_REQUEST]				=   "apple#check",  --一键屏蔽
	-- 苹果支付屏蔽
	[Command.IOS_MUTI_PAY_PHP_REQUEST]				=   "pay#checkWebPay",  --多重支付
	[Command.SETSHARE_PHP_REQUEST]					= 	"task#share",  --设置分享成功
	[Command.SETEVALUATE_PHP_REQUEST]					= 	"task#evaluate",  --设置评价成功
	[Command.TASKSUBMIT_PHP_REQUEST]					= 	"task#add_times",  --提交任务
	-- 苹果推送Token上报
	[Command.IOS_REPORT_PUSH_TOKEN_REQUEST]			=	"apple#push",	--推送Token

	[Command.HORN_SEND_PHP_REQUEST]					=	"prop#sendSouna",	--喇叭发送
	[Command.USERINFO_GET_PHP_REQUEST]				=	"user#userinfo",	--获得用户信息

	-- 好友相关
	[Command.FRIEND_GET_ALLFRIEND_PHP_REQUEST]				=	"friend#friend_list",	--获得用户信息
	[Command.FRIEND_GET_RECOMMEND_PHP_REQUEST]				=	"friend#recommend",	--获得推荐好友信息

	-- 邮件相关
	[Command.MAIL_GET_SYSTEMMSG_PHPREQUEST]				=	"system#message",	--获得邮件系统消息
	[Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST]		=	"system#systemmsgAward",	-- L领取
	[Command.MAIL_GET_FRIENDMSG_PHPREQUEST]				=	"friend#offline_msg",	--获得邮件好友消息
	[Command.MAIL_DEL_SYSTEMMSG_PHPREQUEST]				=	"system#systemmsgDelete",	--删除邮件系统消息

	[Command.CREATEROOMFIG_GET_PHP_REQUEST]				=	"battle#room_config",	--开房配置
	[Command.INVITECON_GET_PHP_REQUEST]					=	"battle#invite_content",	--开房邀请信息
	[Command.BILLINGINFO_GET_PHP_REQUEST]					=	"battle#billing",	--账单信息
	[Command.PAYMENT_BATTLE_PHP_REQUEST]					=	"battle#payment",	--扣钻石
	[Command.REPAYMENT_BATTLE_PHP_REQUEST]					=	"battle#repayment",	--退钻石
	[Command.INVITE_STATISTICS_PHP_REQUEST]					=   "battle#invite_statistics",
	[Command.ANNOUNCE_SYSTEM_PHP_REQUEST]					=	"system#announce",	--登录失败公告
}

local smsType = {
	[0] = "未知",
	[1] = "移动",
	[2] = "联通",
	[3] = "电信",
}

addProperty(PhpManager, "usertype", 1)
addProperty(PhpManager, "versionCode", 1)
addProperty(PhpManager, "versionName", "1.1.0")
addProperty(PhpManager, "packages", "")
addProperty(PhpManager, "apk_path", "")
addProperty(PhpManager, "lib_path", "")
addProperty(PhpManager, "files_path", "")
addProperty(PhpManager, "sd_path", "")
addProperty(PhpManager, "lang", "")
addProperty(PhpManager, "country", "")
addProperty(PhpManager, "device_id", "")
addProperty(PhpManager, "appname", "")
addProperty(PhpManager, "packageName", "")
addProperty(PhpManager, "modelName", "4.1.1")
addProperty(PhpManager, "phone", "")
addProperty(PhpManager, "net", "2G")
addProperty(PhpManager, "mac", "123mac")
addProperty(PhpManager, "appid", "1001")
addProperty(PhpManager, "appkey", "not known")
addProperty(PhpManager, "api", 0x10C04000)
addProperty(PhpManager, "isSdCard", "")
addProperty(PhpManager, "simType", 0)
addProperty(PhpManager, "imsi", "")
addProperty(PhpManager, "propCanUse", 1)
addProperty(PhpManager, "faceCanUse", 1)
addProperty(PhpManager, "gdmjCanUse", 1)
addProperty(PhpManager, "shmjCanUse", 1)
addProperty(PhpManager, "kwxmjCanUse", 1)
addProperty(PhpManager, "isTest", 1)
addProperty(PhpManager, "fid", "")

function PhpManager:ctor()
	self:_initPlatform()
end

function PhpManager:getBasic(command)
	local methodInfo = s_commandMap[command]
	local _m, _p = unpack(string.split(methodInfo, "#"))
	return {
		m = _m,
		p = _p,
		api = self:getAPI(),
	}
end

function PhpManager:getAPI()
	printInfo("self:getDevice_id() : %s", self:getDevice_id())
	printInfo("GameConfig:getLastSuffix() : %s", GameConfig:getLastSuffix())
	return {
			sitemid 	= self:getDevice_id() .. GameConfig:getLastSuffix(),
			device_id 	= self:getDevice_id() .. GameConfig:getLastSuffix(),
			api 		= self:getApi(),
			version 	= self:getVersionName(),
			usertype	= MyUserData:getUserType(),
			sess_id 	= MyUserData:getMtkey(),
			mid 		= MyUserData:getId(),
		}
end

function PhpManager:getLoginParam()
	device_type = "android"
	if System.getPlatform() == kPlatformIOS then
		device_type = "iOS"
	end
	return {
		device_type 		= device_type, 				-- 移动终端设备机型
       	device_os 			= self:getModelName(), 			-- 移动终端设备操作系统
       	resolution 			= display.resolution,
       	network_mode        = self:getNet(),
       	network_operator 	= smsType[self.simType] or "未知",    -- 移动终端设备所使用的网络运营商(1:移动, 2:联通, 3:电信)
       	mac_address			= self:getMac(),
       	channel_id          = self:getAppid(),			-- 渠道id
       	channel_key 		= self:getAppkey(), 			-- 渠道key
       	imsi                = self:getImsi(),
	}
end

function PhpManager:mergeApiParams(apiData, param)
	table.merge(apiData, param)
end

--[[
	获取机器信息
]]
function PhpManager:getMachineInfo()
	local fmt = "附加信息 [ 平台：%s, 版本号：%s, 机型：%s, phone: %s, 手机卡类型：%s, 机器码: %s, 联网方式：%s, 是否有sd卡：%s ]"
	return string.format(fmt, self.currPlatform or "未知", self.version or "未知", self.modelName or "未知",
		self.phone or "未知", smsType[self.simType] or "未知", self.device_id or "未知", self.net or "未知", self.isSdCard or "未知")
end

function PhpManager:_initPlatform()
	local platform = System.getPlatform();
	if platform ~= kPlatformWin32 then --android和iOS登录
		self:_initAndroid()
	else
		self:_initWin32() --win32登录
	end
	self:initExtraInfo()
end

function PhpManager:_initAndroid()
	local result = NativeEvent.getInstance():GetInitValue()
	local json_data=json.decode_node(result);
	self.versionCode 	= GetNumFromJsonTable(json_data, "version_code", 1)
	self.versionName 	= GetStrFromJsonTable(json_data, "version_name", "1.0.0")
	self.packages 		= GetStrFromJsonTable(json_data, "packages", "")
	self.apk_path 		= GetStrFromJsonTable(json_data, "apk_path", "")
	self.lib_path 		= GetStrFromJsonTable(json_data, "lib_path", "")
	self.files_path 	= GetStrFromJsonTable(json_data, "files_path", "")
	self.sd_path 		= GetStrFromJsonTable(json_data, "sd_path", "")
	self.lang 			= GetStrFromJsonTable(json_data, "lang", "")
	self.country 		= GetStrFromJsonTable(json_data, "country", "")
	self.device_id 		= GetStrFromJsonTable(json_data, "device_id", "")
	self.appname 		= GetStrFromJsonTable(json_data, "appname", "")
	self.packageName 	= GetStrFromJsonTable(json_data, "packageName", "")
	self.modelName 		= GetStrFromJsonTable(json_data, "modelName", "")
	self.phone 			= GetStrFromJsonTable(json_data, "phone", "")
	self.net 			= GetStrFromJsonTable(json_data, "net", "")
	self.mac 			= GetStrFromJsonTable(json_data, "mac", "")
	self.appid 			= GetStrFromJsonTable(json_data, "appid", "")
	self.appkey 		= GetStrFromJsonTable(json_data, "appkey", "")
	self.api 			= GetNumFromJsonTable(json_data, "api", 0x10B04000)
	self.isSdCard 		= GetNumFromJsonTable(json_data, "isSdCard", 0)
	self.simType 		= GetNumFromJsonTable(json_data, "simType", 0)
	self.imsi 		    = GetStrFromJsonTable(json_data, "imsi", "")
	self.propCanUse 	= GetNumFromJsonTable(json_data, "propCanUse", 0)
	self.faceCanUse 	= GetNumFromJsonTable(json_data, "faceCanUse", 0)
	self.gdmjCanUse 	= GetNumFromJsonTable(json_data, "gdmjCanUse", 0)
	self.shmjCanUse 	= GetNumFromJsonTable(json_data, "shmjCanUse", 0)
	self.isTest         = GetNumFromJsonTable(json_data, "isTest", 0)  -- 0 正式服
	self.fid         	= GetNumFromJsonTable(json_data, "fid", "")  -- 0 房间号

	PlatformConfig.simType = self.simType;

	printInfo("self.versionCode = %s", self.versionCode)
	printInfo("self.versionName = %s", self.versionName)
	printInfo("self.packages = %s", self.packages)
	printInfo("self.apk_path = %s", self.apk_path)
	printInfo("self.lib_path = %s", self.lib_path)
	printInfo("self.files_path = %s", self.files_path)
	printInfo("self.sd_path = %s", self.sd_path)
	printInfo("self.lang = %s", self.lang)
	printInfo("self.country = %s", self.country)
	printInfo("self.device_id = %s", self.device_id)
	printInfo("self.appname = %s", self.appname)
	printInfo("self.packageName = %s", self.packageName)
	printInfo("self.modelName = %s", self.modelName)
	printInfo("self.phone = %s", self.phone)
	printInfo("self.net = %s", self.net)
	printInfo("self.mac = %s", self.mac)
	printInfo("self.appid = %s", self.appid)
	printInfo("self.appkey = %s", self.appkey)
	printInfo("self.api = %s", self.api)
	printInfo("self.isSdCard = %s", self.isSdCard)
	printInfo("self.simType = %s", self.simType)
	printInfo("self.propCanUse = %s", self.propCanUse)
	printInfo("self.faceCanUse = %s", self.faceCanUse)
	printInfo("self.gdmjCanUse = %s", self.gdmjCanUse)
	printInfo("self.shmjCanUse = %s", self.shmjCanUse)
	printInfo("self.isTest = %s", self.isTest == 0 and "否" or "是")
	printInfo("self.fid = %s", self.fid)
end

function PhpManager:_initWin32()
	local guid_str = System.getWindowsGuid();
	local str = "0";
	if guid_str then
		if string.len(guid_str) > 4 then
			str = string.sub(guid_str, 2, 9);
		else
			str = guid_str;
		end
	else
		guid_str = "0";
	end
	self.device_id = guid_str .. "8"
end

-- 根据是否正式包
function PhpManager:initExtraInfo()
	if self.isTest ~= 0 then
		DEBUG_MODE = true
        kPHPActivityURL = kPHPActivityURLTest;
		require("systemInfoWnd")
		new(SystemInfoWnd);
    else --正式包
		DEBUG_MODE = false
       	kPHPActivityURL = kPhpActivityNormal;
       	GameConfig:setLastSuffix("")
	end
	-- wifi下dump文件上传
	if self.net == "wifi" then
		require("UploadDumpFile")
		local upload = new(UploadDumpFile, "11"); --appid为11
		upload:execute(true); --请在wifi网络的情况下调用上传
	end
end

return PhpManager
