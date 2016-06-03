ViewPath = "view/kScreen_960_640/";

kDeviceTypeIOS = 1;
kDeviceTypeIPHONE = 1;
kDeviceTypeIPAD = 2;
kDeviceTypePC = 3;
kDeviceTypeANDROID = 4;
kDeviceTypeWIN7 = 5;

FEEDBACK_APPID = "4112";
if isPlatform_IOS then
	FEEDBACK_APPID = "9017";		-- iOS的反馈APPID
end
FEEDBACK_GAME  = "kwx";
FEEDBACK_FTYPE = 1;
FEEDBACK_IMG_FTYPE = 2;
--kBrokeMoney = 1000

PLAYER_COUNT = 3
SEAT_1 = 1
SEAT_2 = 2
SEAT_3 = 3
SEAT_4 = 4

ServerType = {
	Normal = 1,
	Test = 2,
	Dev = 3,
}

ChargeType = {
	QuickCharge = 1,
	FirstCharge = 2,
	BrokeCharge = 3,
	NotEnoughMoney = 4,
	JewelCharge = 5,
}

ChangeDeskType = {
	Change = 0,
    Down = 1,
    Up = 2,
}

CARD_UP_SCALE = 1.2

PropImages = {
	[1] = "anim_praise.png",
	[2] = "anim_egg.png",
	[3] = "anim_soap.png",
	[4] = "anim_heart.png",
	[5] = "anim_beer.png",
	[6] = "anim_stock.png",
	[7] = "anim_flower.png",
	[8] = "anim_bomb.png",
}

-- [1] = "点赞",
-- [2] = "鸡蛋",
-- [3] = "肥皂",
-- [4] = "亲吻",
-- [5] = "干杯",
-- [6] = "石头",
-- [7] = "玫瑰",
-- [8] = "炸弹",
local path = "animation/friendsAnim/"
PropConfig = {
	[1] = path .. "animationToPraise",
	[2] = path .. "animationThrowEgg",
	[3] = path .. "animationThrowSoap",
	[4] = path .. "animationSendKiss",
	[5] = path .. "animationCheers",
	[6] = path .. "animationThrowRock",
	[7] = path .. "animationSendRose",
	[8] = path .. "animationThrowBomb",
}

UserType = {
	Visitor = 1,
	WeChat = 24,
	Phone = 42,
}

UserTypeIcon = {
	[UserType.Visitor] = {
		icon = "setting/visitor.png",
	},
	[UserType.WeChat] = {
		icon = "setting/wechat.png",
	},
	[UserType.Phone] = {
		icon = "setting/phone.png",
	},
}
-------------------- 各种操作类型 ---------------------
kOpeCancel			= 0x000;			-- 取消
kOpeRightChi		= 0x001;			-- 右吃
kOpeMiddleChi		= 0x002;			-- 中吃
kOpeLeftChi			= 0x004;			-- 左吃
kOpePeng			= 0x008;			-- 碰
kOpePengGang		= 0x010;			-- 碰杠
kOpeHuaGang			= 0x020;			-- 花杠
kOpeHu				= 0x040;			-- 胡
kOpePengGangHu		= 0x080;			-- 抢杠胡
kOpeHuaHu			= 0x100;			-- 八花胡
kOpeAnGang			= 0x200;			-- 暗杠
kOpeBuGang			= 0x400;			-- 补杠
kOpeZiMo			= 0x800;			-- 自摸
kOpeTing			= 0x1000;			-- 听牌

-- 客户端自定义 请保证不冲突
kOpeGameStart       = 0x122000            -- 开局
kOpeBuHua           = 0x123000            -- 补花

-- 操作优先级
kPriorityNone = 0
kPriorityOut = 0x1
kPriorityGiveup = 0x2
kPriorityChi = 0x4
kPriorityPeng = 0x8
kPriorityGang = 0x10
kPriorityHu = 0x20

----------------------各种文件前后缀-------
kHeadImagePrefix = "userHead"
kHeadImageFolder = "head_images/"
kGameImagePrefix = "gameImage"
kGameImageFolder = "game_images/"

kPngSuffix = ".png"

-- 活动跳转
kTargetLobby					= "lobby"   --大厅
kTargetInfo 					= "info"    --用户信息
kTargetRoom						= "room"	--房间（包括快速开始，包厢）
kDescGame 						= "game"	   --开始游戏
kTargetStore 					= "store"   --商场
kTargetRecharge					= "recharge"   --充值
kTargetFeedback 				= "feedback"  --反馈
kTargetTask 					= "task";  --任务
kTargetPropStore  				= "propstore"  --兑换
kTargetSign 					= "sign"      --签到
kTargetQuickBuy 				= "quickbuy"   --快速购买
kTargetActivityNumber			= "activityNumber"  -- 活动数量
kTargetQQGroup					= "QQGroup" -- 跳转到QQ群
