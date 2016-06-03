module("Command")

--GAME PHP(透传)
PHP_CMD_CONSTANT_BEGIN  = 0x10000;		--php cmd的额外值，所有php  cmd 客户端理解为大于0x10000的


PHP_CMD_REQUEST 		= 0x0038;		-- php 透传命令字
PHP_CMD_RESPONSE		= 0x0038;
SERVER_CMD_PHP_OUT_TIME = 0x0027;       -- php返回超时

LOGIN_PHP_REQUEST 					= PHP_CMD_CONSTANT_BEGIN 	+ 0x0001; 				--注册命令
USERINFO_PHP_REQUEST				= PHP_CMD_CONSTANT_BEGIN 	+ 0x0002;				--获取用户信息
NOTICE_PHP_REQUEST					= PHP_CMD_CONSTANT_BEGIN 	+ 0x0003;				--获取公告信息
PAY_PHP_REQUEST						= PHP_CMD_CONSTANT_BEGIN 	+ 0x0004;				--获取商城信息
TASK_RC_PHP_REQUEST					= PHP_CMD_CONSTANT_BEGIN 	+ 0x0005;				--获取日常任务信息
TASK_CZ_PHP_REQUEST					= PHP_CMD_CONSTANT_BEGIN 	+ 0x0006;				--获取成长任务信息
UPDATE_PHP_REQUEST					= PHP_CMD_CONSTANT_BEGIN	+ 0x0007;				--获取游戏更新信息
REGISTER_SECURITY_CODE_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0008;				--获取注册验证码
FORGOT_PASSWORD_PHP_REQUEST			= PHP_CMD_CONSTANT_BEGIN	+ 0x0009;				--找回手机密码

RANK_DIANFENG_PHP_REQUEST 			= PHP_CMD_CONSTANT_BEGIN 	+ 0x000a;				--巅峰排行榜
RANK_ZHANSHEN_PHP_REQUEST 			= PHP_CMD_CONSTANT_BEGIN	+ 0x000b;				--战神排行榜
RANK_FUHAO_PHP_REQUEST 				= PHP_CMD_CONSTANT_BEGIN 	+ 0x000c;				--土豪排行榜

SIGN_AWARD_PHP_REQUEST	            = PHP_CMD_CONSTANT_BEGIN	+ 0x000d;				--获取签到信息
FIRST_PAY_BAG_PHP_REQUEST           = PHP_CMD_CONSTANT_BEGIN	+ 0x000e;               --首充礼包信息

ANTI_ADDICTION_PHP_REQUEST			= PHP_CMD_CONSTANT_BEGIN	+ 0x000f;               --防沉迷
SIGN_GETAWARD_PHP_REQUEST           = PHP_CMD_CONSTANT_BEGIN	+ 0x0010;               --签到奖励信息
SIGN_GETGIFTAWARD_PHP_REQUEST       = PHP_CMD_CONSTANT_BEGIN	+ 0x0011;               --签到奖励信息

TASK_AWARD_PHP_REQUEST 				= PHP_CMD_CONSTANT_BEGIN	+ 0x0012;               --获取任务奖励

PAY_CONFIG_PHP_REQUEST 				= PHP_CMD_CONSTANT_BEGIN	+ 0x0013;               --获取计费配置
ORDER_PHP_REQUEST 					= PHP_CMD_CONSTANT_BEGIN	+ 0x0014;               --下单
PAY_CONFIG_LIMIT_PHP_REQUEST		= PHP_CMD_CONSTANT_BEGIN	+ 0x0015;               --获取计费配置

PO_CHAN_PHP_REQUEST                 = PHP_CMD_CONSTANT_BEGIN    + 0x0016;               --领取破产补助
PAY_RECOMMEND_PHP_REQUEST            = PHP_CMD_CONSTANT_BEGIN   + 0x0017;				--支付推荐配置
PROP_PHP_REQUEST           			= PHP_CMD_CONSTANT_BEGIN    + 0x0018;				--拉取道具配置

MODIFY_USERINFO_PHP_REQUEST 		= PHP_CMD_CONSTANT_BEGIN    + 0x0019;				--修改用户信息

ROOM_CONFIG_PHP_REQUEST             = PHP_CMD_CONSTANT_BEGIN    + 0x001A;  
PO_CHAN_TIME_PHP_REQUEST            = PHP_CMD_CONSTANT_BEGIN    + 0x001B;              --获取场次配置（推荐金额）

GET_ACTRELATED_PHP_REQUEST 	        = PHP_CMD_CONSTANT_BEGIN    + 0x0020;				--拉取活动相关信息

RANK_DIANFENG_GET_AWARD_PHP_REQUEST = PHP_CMD_CONSTANT_BEGIN 	+ 0x0021;				--昨日巅峰排行榜领奖

GET_RULE_PHP_REQUEST 	        	= PHP_CMD_CONSTANT_BEGIN    + 0x0022;				--拉取RULE相关信息

UPDATE_AWARD_PHP_REQUEST			= PHP_CMD_CONSTANT_BEGIN	+ 0x0023;				--获取游戏更新奖励

NOTIFY_UPDATE_AWARD_PHP_REQUEST		= PHP_CMD_CONSTANT_BEGIN	+ 0x0024;				--通知游戏更新奖励

GET_BASEINFO_PHP_REQUEST			= PHP_CMD_CONSTANT_BEGIN	+ 0x0025;				--游戏基本信息

EXCHANGE_LIST_REQUEST				= PHP_CMD_CONSTANT_BEGIN	+ 0x0026;				--兑换列表
EXCHANGE_GOODS_REQUEST				= PHP_CMD_CONSTANT_BEGIN	+ 0x0027;				--兑换商品
EXCHANGE_RECORD_REQUEST				= PHP_CMD_CONSTANT_BEGIN	+ 0x0028;				--兑换历史
ROOM_GAME_BOX_STATUS_REQUEST		= PHP_CMD_CONSTANT_BEGIN	+ 0x0029;				--牌局包厢状态
ROOM_GAME_BOX_DETAIL_REQUEST		= PHP_CMD_CONSTANT_BEGIN	+ 0x0030;				--牌局包厢详细信息
ROOM_GAME_BOX_AWARD_REQUEST		    = PHP_CMD_CONSTANT_BEGIN	+ 0x0031;				--牌局包厢详细信息
ROOM_GAME_ACTIVITY_STATUS_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0032;				--房间赠送活动
ROOM_GAME_ACTIVITY_DETAIL_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0033;				--房间赠送活动
ROOM_GAME_ACTIVITY_AWARD_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0034;				--房间赠送活动

SETUPDATE_PHP_REQUEST 				= PHP_CMD_CONSTANT_BEGIN	+ 0x0035;				--设置可以领取更新奖励
ONEKEY_HIDE_PHP_REQUEST 			= PHP_CMD_CONSTANT_BEGIN    + 0x0037;
IOS_MUTI_PAY_PHP_REQUEST 			= PHP_CMD_CONSTANT_BEGIN    + 0x0038; 	

SETSHARE_PHP_REQUEST 				= PHP_CMD_CONSTANT_BEGIN	+ 0x0039;
IOS_REPORT_PUSH_TOKEN_REQUEST       = PHP_CMD_CONSTANT_BEGIN    + 0x0040;               -- 上报推送Token				--设置分享成功s
 
SIGN_BQ_GETAWARD_PHP_REQUEST       	= PHP_CMD_CONSTANT_BEGIN	+ 0x0041;				-- 签到补签

HORN_SEND_PHP_REQUEST		       	= PHP_CMD_CONSTANT_BEGIN	+ 0x0042;				-- 喇叭发送消息
USERINFO_GET_PHP_REQUEST		    = PHP_CMD_CONSTANT_BEGIN	+ 0x0043;				-- 获取用户信息

-- friend 
FRIEND_GET_ALLFRIEND_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0050;				-- 获得好友列表
FRIEND_GET_RECOMMEND_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0051;				-- 获得推荐好友列表
FRIEND_GET_ADDFRIEND_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0052;				-- 添加好友
FRIEND_GET_DELFRIEND_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0053;				-- 删除好友
 
-- 邮件相关
MAIL_GET_SYSTEMMSG_PHPREQUEST		= PHP_CMD_CONSTANT_BEGIN 	+ 0x0070				-- 获取邮件系统消息
MAIL_GET_FRIENDMSG_PHPREQUEST		= PHP_CMD_CONSTANT_BEGIN 	+ 0x0071				-- 获取邮件好友消息
MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST	= PHP_CMD_CONSTANT_BEGIN 	+ 0x0072				-- 领取
MAIL_DEL_SYSTEMMSG_PHPREQUEST		= PHP_CMD_CONSTANT_BEGIN 	+ 0x0073				-- 删除

SETEVALUATE_PHP_REQUEST				= PHP_CMD_CONSTANT_BEGIN    + 0x0074;               -- 评价成功
TASKSUBMIT_PHP_REQUEST				= PHP_CMD_CONSTANT_BEGIN    + 0x0075;               -- 提交任务

CREATEROOMFIG_GET_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN    + 0x0076;               -- 获得开房配置
INVITECON_GET_PHP_REQUEST		= PHP_CMD_CONSTANT_BEGIN    + 0x0077;               -- 获得开房邀请信息
BILLINGINFO_GET_PHP_REQUEST		= PHP_CMD_CONSTANT_BEGIN    + 0x0078;               -- 获得账单信息
PAYMENT_BATTLE_PHP_REQUEST		= PHP_CMD_CONSTANT_BEGIN    + 0x0079;               -- 支付商品
REPAYMENT_BATTLE_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN    + 0x0080;               -- 退款

ANNOUNCE_SYSTEM_PHP_REQUEST		= PHP_CMD_CONSTANT_BEGIN    + 0x0081;               -- 登录失败公告

INVITE_STATISTICS_PHP_REQUEST	= PHP_CMD_CONSTANT_BEGIN	+ 0x0082;				--好友对战邀请方式统计

--SOCKET EVENT
SOCKET_EVENT_CONNECTED 		= 0x30000; --socket连接成功
SOCKET_EVENT_CONNECT_FAILD	= 0x30001; --socket连接失败
SOCKET_EVENT_CLOSE 			= 0x30002; --sokcet关闭
SOCKET_EVENT_TIMEOUT		= 0x30003; --sokcet超时
SOCKET_EVENT_SEND_ERROR		= 0x30004; --sokcet超时


-----------------大厅 交互命令---------------------
HeatBeatReq = 0x2008		--发送心跳包
HeatBeatRsp	= 0x600D		--心跳包返回

LoginLobbyReq           	= 0x101    -- 登录大厅
LoginLobbyRsp       		= 0x201   -- 回应登录大厅成功

LogoutLobbyReq 				= 0x102

LobbyOnlineReq           	= 0x311
LobbyOnlineRsp              = LobbyOnlineReq 

LobbyKickOutBd              = 0x203   -- 被T出

LobbyJoinRoomErrRsp         = 0x20A

-----------------房间 交互命令---------------------

-- 0x1005状态码
LOGIN_ROOM_ERROR = 6
NOT_ENOUGH_MONEY = 9
KICK_USER_OUT    = 2
FANG_CHEN_MI     = 16
ENTRY_ROOM_ERR	 = 28

-----------------房间 公共部分---------------------
LoginRoomRsp 		= 0x1110	-- 登录房间成功				7
LoginRoomErr     	= 0x1005 	-- 登录错误
LoginRoomOtherErr   = 0x1006    -- 其他错误(包括踢出等)
LoginRoomServerErr  = 0x20F     -- 服务器异常

UserEnterBd 		= 0x100D		--广播用户进入			D
RoomInfoBd 			= 0x1112        --告诉客户端名字和等级
ReadyReq			= 0x2001 		-- 请求准备开始
UserReadyBd			= 0x4001		-- 广播玩家准备
UserExitBd          = 0x100E		-- 广播用户退出
LogoutRoomRsp       = 0x1008		-- 返回退出房间成功
	BATTLE_DISSMISS_MASTER_LEAVE = 0x0000 	-- 房主离开
	BATTLE_DISSMISS_AGREEMENT = 0x0001 		-- 所有玩家同意解散
	BATTLE_DISSMISS_FULL_ROUND = 0x0002 	-- 已打满局数

ChangeDeskReq       = 0x1114        -- 换桌、升场、降场
ChangeDeskErr       = ChangeDeskReq -- 换桌异常

-- 玩牌相关
GameReadyStartBd    = 0x4002 		-- 广播准备开始
DealCardBd 			= 0x3001 		-- 服务端发牌
GameStartBd 		= 0x4003		-- 发牌后 广播开始游戏
ObserverCardBd      = 0x2020        -- 国标麻将开始看牌
UserAiBd 			= 0x4007 		-- 广播用户托管

-- 请求
SendChat			= 0x1003
SendFace			= 0x1004
SendProp			= 0x2030		-- 发送道具
SendOperate			= 0x2004
LogoutRoomReq       = 0x1002
RequestOutCard      = 0x2002
RequestOperate      = 0x2004
RequestAi           = 0x2005

-- 玩法相关
OwnGrabCardBd		= 0x3002 		-- 广播自己抓牌
OtherGrabCardBd 	= 0x4006  		-- 广播玩家抓牌
OutCardBd  			= 0x4004		-- 广播出牌
OperateBd 			= 0x4005  		-- 广播玩家操作
OperateCancelBd     = 0x4023        -- 操作取消广播 进入等待出牌状态
StopGameBd 			= 0x4009 		--广播游戏停止
ReconnSuccess       = 0x1111		--重连房间成功

QiangGangHuBd       = 0x3005

GameCostBd 			= 0x400d 		-- 广播台费

RoomOutCardReq 		= 0x4004 		-- 玩家请求出牌

--玩家聊天
UserChat            = 0x1003		--聊天
UserFace            = 0x1004        --聊天表情
UserProp            = 0x2030        --道具
JoinGameReq  		= 0x119			--请求加入房间
-- requestJoinRoom   	= 0x119

-- 国标专用
GB_StopRoundBd		= 0x4014 		--国标台牌广播一局游戏结束

--广东麻将专用
SwapCardStartBd       = 0x3012  --服务器通知开始换牌
SwapCardReq           = 0x2015	--请求换牌
SwapCardRsp           = 0x3013  --换牌返回
DoubleHuReq           = 0x2019  --加倍胡请求
DoubleHuBd            = 0x3014  --加倍胡返回
DoubleFinishBd        = 0x3015  --加倍胡指令结束
DoubleOutCardBd       = 0x3016  --加倍胡出牌
DoubleGrabCardBd      = 0x3017  --加倍胡抓牌
GD_StopRoundBd		  = 0x4021  --广东一局游戏结束
GfxyBd				  = 0x4012  --广东刮风下雨通知
SERVERGB_BROADCAST_BANKRUPT              = 0x2029 --破产广播

SERVER_COMMAND_SELECT_PIAO	= 0x1117  --MahjongKW 选飘
CLIENT_COMMAND_PIAO 		= 0x1117  --客户端选漂
SERVER_COMMAND_BROADCAST_PIAO 	= 0x1118  --服务器广播选漂
SERVER_COMMAND_BROADCAST_START_GAME = 0x1119 -- 广播牌局开始

SERVERGB_BROADCAST_PAOMADENG   = 0x6901   -- 广播跑马灯
SERVERGB_BROADCAST_GOODSDATA   = 0x6900   -- 广播道具信息
	-- 二级指令
	HALL_SERVER_UPDATE_MONEY                 = 0x0002 --server推送金币，博雅币之类信息
    HALL_PUSH_MONEY                          = 0x0003 --servert推送金币
    HALL_SERVER_UPDATE_FEEBACK_TIP           = 0x0004 --server推送反馈气泡
    SERVER_MATCHAWARDHUAFEI_RES              = 0x0005 -- 比赛奖励-话费卷
    SERVER_MATCHAWARDCARD_RES                = 0x0006 -- 比赛奖励-卡片

SERVER_COMMAND_KICK_OUT = 0x3004				--踢掉用户
SERVER_COMMAND_READY_COUNT_DOWN = 0x3008       --告诉客户端准备倒计时

--请求刷新金币
FreshMoneyReq     = 0x6400	--客户端请求刷新金币
FreshMoneyRsp     = FreshMoneyReq   --刷新金币信息返回

FreshMoneyBd      = 0x6510  --通知客户端金币变动
NoticeMoneyChangeReq = 0x2023  --通知gameServer金币变动
NoticeMoneyChangeRsp = NoticeMoneyChangeReq  -- 金币变动返回

CLIENT_COMMAND_UPDATE_USER_INFO = 0x2028     --玩家广播自定义消息给同桌子的其他玩家
SERVER_COMMAND_UPDATE_USER_INFO = CLIENT_COMMAND_UPDATE_USER_INFO     --玩家广播自定义消息给同桌子的其他玩家结果

--上海麻将专用
SH_ChengBaoBd      = 0x400F  -- 上海麻将广播承包关系
SH_StopRoundBd     = 0x4014

--好友相关
SERVER_COMMAND_FRIEND_REQ	= 0x6000
	-- 二级指令
	FRIEND_CMD_ADD_FRI = 0x0006	--
	FRIEND_CMD_FROM_ADD = 0x0007	--
	FRIEND_CMD_ENDTY_CHANNEL = 0x0033 --进入频道
	FRIEND_CMD_EXIT_CHANNEL = 0x0034 -- 离开频道
	FRIEND_CMD_ADD_CHANNEL_FRI = 0x0035 -- 添加频道好友


SERVER_CREATEROOM_REQ				= 0x130		--申请创建房间
SERVER_EXIT_PRIVATEROOM_REQ			= 0x2033	--申请退出私人房
SERVER_EXIT_PRIVATEROOM_HANDLER_REQ	= 0x2034	--申请退出私人房处理
SERVER_BROADCAST_STOP_BATTLE			= 0x4026	--广播对战总结算

