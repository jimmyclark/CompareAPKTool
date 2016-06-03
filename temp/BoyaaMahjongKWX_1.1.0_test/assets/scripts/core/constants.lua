-- constants.lua
-- Author: Vicent Gong
-- Date: 2012-09-21
-- Last modification : 2013-07-02
-- Description: Babe kernel Constants and Definition

---------------------------------------Anim---------------------------------------
kAnimNormal	= 0;
kAnimRepeat	= 1;
kAnimLoop	= 2;
----------------------------------------------------------------------------------

---------------------------------------Res----------------------------------------
--format
kRGBA8888	= 0;
kRGBA4444	= 1;
kRGBA5551	= 2;
kRGB565		= 3;
kRGBGray	= 0x100;

--filter
kFilterNearest	= 0;
kFilterLinear	= 1;
----------------------------------------------------------------------------------

---------------------------------------Prop---------------------------------------
--for rotate/scale
kNotCenter		= 0;
kCenterDrawing	= 1;
kCenterXY		= 2;
----------------------------------------------------------------------------------

--------------------------------------Align--------------------------------------
kAlignCenter		= 0;
kAlignTop			= 1;
kAlignTopRight		= 2;
kAlignRight			= 3;
kAlignBottomRight	= 4;
kAlignBottom		= 5;
kAlignBottomLeft	= 6;
kAlignLeft			= 7;
kAlignTopLeft		= 8;
---------------------------------------------------------------------------------

---------------------------------------Text---------------------------------------
--TextMulitLines
kTextSingleLine	= 0;
kTextMultiLines = 1;

kDefaultFontName	= ""
kDefaultFontSize 	= 24;

kDefaultTextColorR 	= 0;
kDefaultTextColorG 	= 0;
kDefaultTextColorB 	= 0;
----------------------------------------------------------------------------------

---------------------------------------Touch--------------------------------------
kFingerDown		= 0;
kFingerMove		= 1;
kFingerUp		= 2;
kFingerCancel	= 3;
----------------------------------------------------------------------------------

---------------------------------------Focus--------------------------------------
kFocusIn 	= 0;
kFocusOut 	= 1;
----------------------------------------------------------------------------------

---------------------------------------Scroll-------------------------------------
kScrollerStatusStart	= 0;
kScrollerStatusMoving	= 1;
kScrollerStatusStop		= 2;
----------------------------------------------------------------------------------

---------------------------------------Socket-------------------------------------
--SocketProtocal
kGameId             = 1;
kProtocalVersion 	= 1;
kProtocalSubversion	= 1;
kClientVersionCode 	= "1.1.2"; --没有使用，


--SocketStatus
kSocketConnected 		= 1;
kSocketReconnecting		= 2;
kSocketConnectivity		= 3;
kSocketConnectFailed	= 4;
kSocketUserClose		= 5;
kSocketRecvPacket		= 9;

kCloseSocketAsycWithEvent 	= 0;
kCloseSocketAsyc 			= 1;
kCloseSocketSync 			= -1;

--Socket type
kGameSocket	= "hall";
----------------------------------------------------------------------------------

---------------------------------------Http---------------------------------------
--http get/post
kHttpGet		= 0;
kHttpPost		= 1;
kHttpReserved	= 0;
-----------------------------------------------------------------------------------

-------------------------------------Bool values-----------------------------------
kTrue 	= 1;
kFalse 	= 0;
kNone 	= -1;
-----------------------------------------------------------------------------------

-------------------------------------Button----------------------------------------
kButtonUpInside 	= 1;
kButtonUpOutside 	= 2;
kButtonUp 			= 3;

-----------------------------------------------------------------------------------

-------------------------------------Direction-------------------------------------
kHorizontal 	= 1;
kVertical 		= 2;
-----------------------------------------------------------------------------------

---------------------------------------Platform------------------------------------
--ios
kScreen480x320		= "480x320" -- ios/android
kScreen960x640		= "960x640"
kScreen1024x768		= "1024x768"
kScreen2048x1536	= "2048x1536"

--android
kScreen1280x720		= "1280x720"
kScreen1280x800		= "1280x800"
kScreen1024x600		= "1024x600"
kScreen960x540		= "960x540"
kScreen854x480		= "854x480"
kScreen800x480		= "800x480"

--platform
kPlatformIOS 		= "ios";
kPlatformAndroid 	= "android";
kPlatformWp8 		= "wp8";
kPlatformWin32 		= "win32";
-----------------------------------------------------------------------------------

---------------------------------------Custom Render-------------------------------
kRenderPoints 			= 1;
kRenderLineStrip 		= 2;
kRenderLineLoop 		= 3;
kRenderLines 			= 4;
kRenderTriangleStrip 	= 5;
kRenderTriangleFan 		= 6;
kRenderTriangles 		= 7;

kRenderDataDefault 		= 0;
kRenderDataTexture 		= 16;
kRenderDataColors 		= 32;
kRenderDataAll 			= 48;
-----------------------------------------------------------------------------------

---------------------------------------Custom Blend--------------------------------

kBlendSrcZero=0;
kBlendSrcOne=1;
kBlendSrcDstColor=2;
kBlendSrcOneMinusDstColor=3;
kBlendSrcSrcAlpha=4;
kBlendSrcOneMinusSrcAlpha=5;
kBlendSrcDstAlpha=6;
kBlendSrcOneMinusDstAlpha=7;
kBlendSrcSrcAlphaSaturate=8;

kBlendDstZero=0;
kBlendDstOne=1;
kBlendDstSrcColor=2;
kBlendDstOneMinusSrcColor=3;
kBlendDstSrcAlpha=4;
kBlendDstOneMinusSrcAlpha=5;
kBlendDstDstAlpha=6;
kBlendDstOneMinusDstAlpha=7;

----------------------------------------------------------------------------------

----------------------------------Input ------------------------------------------
kEditBoxInputModeAny  		= 0;
kEditBoxInputModeEmailAddr	= 1;
kEditBoxInputModeNumeric	= 2;
kEditBoxInputModePhoneNumber= 3;
kEditBoxInputModeUrl		= 4;
kEditBoxInputModeDecimal	= 5;
kEditBoxInputModeSingleLine	= 6;


kEditBoxInputFlagPassword					= 0;
kEditBoxInputFlagSensitive					= 1;
kEditBoxInputFlagInitialCapsWord			= 2;
kEditBoxInputFlagInitialCapsSentence		= 3;
kEditBoxInputFlagInitialCapsAllCharacters	= 4;


kKeyboardReturnTypeDefault = 0;
kKeyboardReturnTypeDone = 1;
kKeyboardReturnTypeSend = 2;
kKeyboardReturnTypeSearch = 3;
kKeyboardReturnTypeGo = 4;
----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

------------------------------------Third Part SDK---------------------------------
kCallLuaEvent="event_call"; -- 原生语言调用lua 入口方法
kLuaCallEvent = "LuaCallEvent"; -- 获得 指令值的key

Kwin32Call="gen_guid";

kFBLogin="FBLogin"; -- facebook 登录
kFBShare="FBShare"; -- facebook 分享
kFBLogout="FBLogout" -- facebook 退出
kGuestZhLogin="GuestZhLogin"; -- 简体游客 登录
kGuestZwLogin="GuestZwLogin"; -- 繁体游客 登录
kGuestLogout="GuestLogout" -- 游客 退出
kWeiXinLogin="WeiXinLogin"; -- 微信登录
kMobileLogin="MobileLogin";--移动基地登录
kSinaLogin="SinaLogin"; -- 新浪 登录
kSinaShare="SinaShare"; -- 新浪 分享
kSinaLogout="SinaLogout" -- 新浪 退出
kQQConnectLogin="QQConnectLogin"; -- QQ互联 登录
kQQConnectLogout="QQConnectLogout" -- QQ互联 退出
kRenRenLogin="RenRenLogin"; --人人 登录
kRenRenShare="RenRenShare"; -- 人人 分享
kRenRenLogout="RenRenLogout" -- 人人 退出
kKaiXinLogin="KaiXinLogin"; -- 开心 登录
kKaiXinLogout="KaiXinLogout" -- 开心 退出
kBaiduDKLogin="BaiduDKLogin"; --百度多酷登录
kUserLogout = "UserLogout";
kCallResult="CallResult"; --结果标示  0 -- 成功， 1--失败,2 -- ...
kResultPostfix="_result"; --返回结果后缀  与call_native(key) 中key 连接(key.._result)组成返回结果key
kparmPostfix="_parm"; --参数后缀 
ksubString = "subString";	--字符串截取
kencodeStr = "encodeStr";
kGetGeTuiId = "GetGeTuiId";
-----------------------------------------------------------------------------------

------------------------------------Language---------------------------------------
kZhCNLang="zh_CN";
kZhLang="zh";
kZhTW="zh_TW";
kZhHKLang="zh_HK";
kEnLang="en";
kFRLang="fr_FR";
-----------------------------------------------------------------------------------

------------------------------------Android Keys-----------------------------------
kBackKey="BackKey";
kHomeKey="HomeKey";
kEventPause="EventPause";
kEventResume="EventResume";
kExit="Exit";
-----------------------------------------------------------------------------------

----------------------------------- 活动界面跳转常量 --------------------------------
kStore = "store";         -- 进入商城
kFeedback = "feedback";   -- 进入反馈界面
kRank = "rank";      	  -- 进入排行榜
kInfo = "info";      	  -- 进入个人信息界面
kGame = "game";           -- 快速开始游戏
kDailyTask = "dailyTask"  -- 每日任务
kQuickCharge = "quickCharge" -- 快速购买（按金币数匹配）
kQuickBuy = "quickbuy" 		 -- 快速购买（配置金额）
kLobby = "lobby"             -- 简单返回大厅
kGbmj = "gbmj"  -- 国标麻将
kGdmj = "gdmj"  -- 广东麻将
kShmj = "shmj"  -- 上海麻将
kHbmj = "hbmj"  -- 河北麻将
kScmj = "scmj"  -- 四川麻将
kErmj = "ermj"  -- 二人麻将
kWhmj = "whmj"  -- 武汉麻将

-------------------------------------Sound-----------------------------------------
ksetBgSound = "setBgSound"; -- 设置音效 
kbgSoundsync="bgSound__sync";--设置音效数据 key
ksetBgMusic = "setBgMusic"; -- 设置音乐
kbgMusicsync="bgMusic__sync";-- 设置音乐数据 key
-----------------------------------------------------------------------------------

-------------------------------take a photo or pick a photo------------------------
kTakePhoto = "takePhoto"
kPickPhoto = "pickPhoto"
-----------------------------------------------------------------------------------

-------------------------------activity function-----------------------------------
kActivityGoFunction = "ActivityGoFunction"
-----------------------------------------------------------------------------------

-------------------------------upload image----------------------------------------
kUploadImage = "uploadImage"
kUploadFeedbackImage = "uploadImage"
-----------------------------------------------------------------------------------

-------------------------------open web----------------------------------------
kOpenWeb  	= "openWeb"
kCloseWeb 	= "closeWeb"
-----------------------------------------------------------------------------------
-------------------------------login----------------------------------------
kLogin 		= "login"
-----------------------------------------------------------------------------------
-------------------------------open web----------------------------------------
kOpenRule  	= "openRule"
kCloseRule 	= "closeRule"
-----------------------------------------------------------------------------------

-------------------------------update----------------------------------------
kUpdateByLocal  	= "updatePackByLocal"
kUpdateByUmeng 		= "updatePackByUmeng"
kCheckPackByLocal  	= "checkPackByLocal"


-----------------------------------------------------------------------------------

-------------------------------download image----------------------------------------
kDownloadImage  = "downloadImage"
-----------------------------------------------------------------------------------
-------------------------------rename image----------------------------------------
kRenameImage 	= "renameImage"
-------------------------------download file----------------------------------------
kDownloadFile 	= "downloadFile"
-------------------------------unzip file----------------------------------------
kUnzip 			= "unzip"
-------------------------------record and play back----------------------------------------
kStartRecord 	= "startRecord"
kStopRecord 	= "stopRecord"
kPlayBack 		= "playBack"
kStopPlayBack 	= "stopPlayBack"
-------------------------------------Android Update version------------------------
kVersion_sync="Version_sync"; -- 获得android 版本 
kversionCode  = "versionCode"; -- 获得android versionCode  数据 key
kversionName  = "versionName"; --  获得android versionName  数据 key
kupdateVersion ="updateVersion"; -- 更新版本
kupdateUrl = "updateUrl"; -- 设置更新版本数据 key
-----------------------------------------------------------------------------------

kWin32ConsoleColor = "win32_console_color"; -- win32 print_string 设置颜色


----------------------font style-----------------
kFontTextBold 			= "<b>"; -- 加粗
kFontTextItalic 		= "<i>"; -- 斜体
kFontTextUnderLine 		= "<u>"; -- 下划线
kFontTextDeleteLine 	= "<s>"; -- 中划线
