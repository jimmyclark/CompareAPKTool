PlatformConfig = {};

PlatformConfig.basePlatform = 1;
PlatformConfig.oppoPlatform = 2;
PlatformConfig.huaweiPlatform = 3;
PlatformConfig.qihu360Platform = 4;
PlatformConfig.yidongPlatform = 5;  --移动基地
PlatformConfig.auditPlatform = 6;	--审核版本
PlatformConfig.nd91Platform = 7;	--91平台
PlatformConfig.yidongMMPlatform = 8;
PlatformConfig.tianyiPlatform = 9;	--电信天翼平台
PlatformConfig.unicomPlatform = 10;	--联通沃商店
PlatformConfig.baiduDKPlatform = 11;	--百度多酷平台
PlatformConfig.GDTPlatform = 12;	--广点通版本
PlatformConfig.lianxiangPlatform = 13;
PlatformConfig.anzhiPlatform = 14;	--安智平台
PlatformConfig.sogouPlatform = 15;	--搜狗平台
PlatformConfig.yidongMMIapPlatform = 16;	--移动mm弱联网
PlatformConfig.unionKuandaiPlatform = 17;	--联通宽带
PlatformConfig.qqPlatform = 18;	--
PlatformConfig.gameViewPlatform = 19;	--马来西亚gameView联运
PlatformConfig.baiduQuDaoPlatform = 20; --百度渠道联运

-- 获取支付商品列表的时候 需要的pmode参数  
PlatformConfig.basePmode = 4;  -- 主版本

-------------支付 sid----------
PlatformConfig.boyaaPaySid = 7;

PlatformConfig.paySid = PlatformConfig.boyaaPaySid;


-------------不同登录方式获取商品列表的时候 携带的appid参数----------
PlatformConfig.visitorPayAppid = 1358;  -- 游客登录支付
PlatformConfig.sid = 7;		-- 安卓sid

if System.getPlatform() == kPlatformIOS then
	PlatformConfig.visitorPayAppid = 1531;		-- 苹果appid
	PlatformConfig.sid = 5;										-- 苹果sid
end
-- PlatformConfig.sinaPayAppid = 338;     -- 新浪登录支付
-- PlatformConfig.boyaaPayAppid = 339;    -- 通行证登录支付
-- PlatformConfig.weixinPayAppid = 7036;   -- 微信登录支付


--不同登录方式  用来记录并区分登录方式
PlatformConfig.sinaLogin = 2;
PlatformConfig.qqLogin = 3;
PlatformConfig.visitorLogin = 7;
PlatformConfig.spiderLogin = 12;
PlatformConfig.oppoLogin = 9;
PlatformConfig.huaweiLogin = 13;
PlatformConfig.yidongLogin = 11;
PlatformConfig.qihu360Login = 8;
PlatformConfig.nd91Login = 7;
PlatformConfig.sogouLogin = 17;
PlatformConfig.baiduDKLogin = 18;
PlatformConfig.lianxiangLogin = 19;
PlatformConfig.anzhiLogin = 20;
PlatformConfig.weixinLogin = 21;
PlatformConfig.gameViewLogin = 29;

-- 根据登录方式来格式化
PlatformConfig.getAppidAndPmode = function(loginType)
	--统一使用游客的APPID
	local appid = PlatformConfig.visitorPayAppid;
	-- if(loginType == PlatformConfig.visitorLogin) then
	-- 	appid = PlatformConfig.visitorPayAppid;
	-- elseif loginType == PlatformConfig.huaweiLogin then
	-- 	appid = HuaWeiPlatform.huaweiPayAppid;
	-- elseif (loginType == PlatformConfig.oppoLogin) then
	-- 	appid = OppoPlatform.oppoPayAppid;
	-- elseif(loginType == PlatformConfig.sinaLogin) then
	-- 	appid = PlatformConfig.sinaPayAppid;
	-- elseif(loginType == PlatformConfig.spiderLogin) then
	-- 	appid = PlatformConfig.boyaaPayAppid;
	-- elseif( loginType == PlatformConfig.yidongLogin ) then
	-- 	appid = YiDongPlatform.yidongPayAppid;
	-- elseif(loginType == PlatformConfig.qihu360Login) then
	-- 	appid = QiHu360Platform.qihu360PayAppid;
	-- elseif(loginType == PlatformConfig.nd91Login) then
	-- 	appid = ND91Platform.nd91PayAppid;
	-- elseif(loginType == PlatformConfig.baiduDKLogin) then
	-- 	appid = BaiduDKPlatform.baiduDKAppid;
	-- elseif(loginType == PlatformConfig.lianxiangLogin) then
	-- 	appid = LianxiangPlatform.lianxiangPayAppid;
	-- elseif(loginType == PlatformConfig.anzhiLogin) then
	-- 	appid = AnzhiPlatform.anzhiPayAppid;
	-- elseif(loginType == PlatformConfig.sogouLogin) then
	-- 	appid = SogouPlatform.sogouPayAppid;
	-- elseif(loginType == PlatformConfig.weixinLogin) then
	-- 	appid = PlatformConfig.weixinPayAppid;
	-- elseif(loginType == PlatformConfig.gameViewLogin) then
	-- 	appid = GameViewPlatform.gameViewAppid;
	-- end
	return appid, PlatformConfig.basePmode;
end

PlatformConfig.getAppConfig = function(self)
	return PlatformConfig.appid, PlatformConfig.appkey, PlatformConfig.api;
end

-- 当前平台 =============================================================
PlatformConfig.currPlatform = PlatformConfig.basePlatform;
PlatformConfig.currPlatformName = "主版本"

-- 正式服 测试服 外网测试服域名配置
kPhpTestURL = "http://mahjong20.by.com/mahjong/mahjongtwo_weibo/application/";		--测试服
kPhpKaiFaURL = "http://192.168.100.20/mahjong/mahjongtwo_weibo/application/";		--开发服

kPhpNormalURL = "http://cnmahjong.17c.cn/mahjong/mahjongtwo_weibo/application/";
kPhpTestOutURL = "http://snspmj01.17c.cn/mahjong/mahjongtwo_weibo/application/";
kPhpCommonUrl = kPhpNormalURL --PHP地址 可切换

kPhpServerTestUrl = 'http://mahjong144.by.com/majiang_v5/data/site.mobile.json';
kPhpServerUrl = 'http://uchead.static.17c.cn/dfqp/static/site.mobile.json?v=20140901'

kPhpActivityNormal = "http://ususspmj02.ifere.com/"		-- 01是全集的，02才是卡五星的，修改了一下
kPHPActivityURLTest = "http://192.168.204.68/operating/web/index.php";
kPHPActivityURL = kPhpActivityNormal;

kRequestActivityInfoUrl = "?m=activities&p=actrelated";
kActivityCenterUrl = "?m=activities&extra[title]=1";

--从android传过来的数据
PlatformConfig.api   =  "0A472400"; --"0A470008"--
PlatformConfig.appid ="";
PlatformConfig.appkey="";
PlatformConfig.model_name="";
PlatformConfig.simType = 0;
PlatformConfig.imei   ="";
PlatformConfig.rat    ="";  --分辨率
PlatformConfig.phone  ="";  --手机号
PlatformConfig.net    ="";  --联网方式
PlatformConfig.mac    ="";  --联网mac地址
PlatformConfig.osv    ="";  --操作系统
PlatformConfig.simnum ="";  --sim序列号
PlatformConfig.isSdCard=0;      --是否有sd卡
PlatformConfig.isSoundOpen = true; -- 移动基地声音开关
PlatformConfig.versionCode = 3;
PlatformConfig.isTest = true;   -- 是否是测试环境
PlatformConfig.activityCenterUrl = kPhpActivityNormal .. kActivityCenterUrl; --活动中心url
PlatformConfig.requestActivityInfoUrl = kPhpActivityNormal .. kRequestActivityInfoUrl;
PlatformConfig.mobileChargeKey = nil;  -- 默认没有手机卡
PlatformConfig.isSoundCanUse = 0;	   -- 声音资源1可用,0不可用
PlatformConfig.isFaceCanUse = 1; 	   -- 表情资源1可用
PlatformConfig.isPropCanUse = 1; 	   -- 互动道具是否可用
PlatformConfig.isNeedSmsPay = 1;	   -- 是否需要短信支付,1需要，0否
PlatformConfig.isNeedLuoMaPay = 0;	   -- 是否需要裸码支付,1需要，0否
PlatformConfig.isNeedAliWebPay = 1;    -- 是否需要阿里web支付, 1需要，0否
PlatformConfig.activityIsTest = 1;	   -- 活动是否为测试 0为测试 1为正式
PlatformConfig.isBigBag = 1;	   	   -- 是否为大包
PlatformConfig.simulatorIp = "simulatorIp";
PlatformConfig.simulatorPhone = "simulatorPhone";
PlatformConfig.getMachineInfo = function()
	local smsType = {"移动", "联通", "电信"}
	return GameString.convert2UTF8("附加信息 [ 平台：" .. PlatformConfig.currPlatformName .. ", 版本号：" .. PhpManager:getVersionName() .. ", 机型：" .. PlatformConfig.model_name .. ", phone:"..(PlatformConfig.phone or "") .. 
		", 手机卡类型：" .. (smsType[PlatformConfig.simType] or "未知") .. ", 机器码：" .. PlatformConfig.imei .. 
		", 联网方式：" ..  PlatformConfig.net .. ", 是否有sd卡：" .. (PlatformConfig.isSdCard == 0 and "否" or "是") .. " ]");
end