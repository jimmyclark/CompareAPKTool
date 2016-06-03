require("common/nativeEvent")

UmengEvent = {};

-- 事件类型
-- View  Update 
-- single_cmds 单个点击事件 不携带其他参数
UmengEvent.single_cmds = {
	-- 用户信息
	ViewUserInfo 					= "ViewUserInfo",  -- 进入个人信息界面
	UpdateUserHead 					= "UpdateUserHead", -- 修改头像
	UpdateUserInfo 					= "UpdateUserInfo", -- 更改用户信息，昵称 性别

	-- 大厅按钮
	ViewDailyTask 					= "ViewDailyTask", -- 查看每日任务
	DailyReward 					= "DailyReward",
	ViewActivityInDaily 			= "ViewActivityInDaily", -- 每日任务进入活动
	ViewActivityInLobby 			= "ViewActivityInLobby", -- 大厅进入活动
	ViewRankList 					= "ViewRankList", -- 查看排行榜
	ViewAchieve                     = "ViewAchieve",  -- 查看成绩榜
	ViewNotice 						= "ViewNotice", -- 查看每日通知
	ViewHelp 						= "ViewHelp", -- 查看帮助

	-- ViewSettingInLobby 				= "ViewSettingInLobby", -- 查看设置
	-- ViewSettingInRoom 				= "ViewSettingInRoom", -- 查看设置
	-- UpdateSettingInLobby 			= "UpdateSettingInLobby", --大厅中更新设置
	-- UpdateSettingInRoom 			= "UpdateSettingInRoom", -- 房间中更新设置

	-- 玩家主动查看
	ViewQuickChargeInLobby 			= "ViewQuickChargeInLobby", -- 大厅快速充值
	ViewQuickChargeInRoom 			= "ViewQuickChargeInRoom", -- 房间快速充值
	ViewQuickChargeInHelp 			= "ViewQuickChargeInHelp", -- 房间快速充值

	ViewMarketInLobby 				= "ViewMarketInLobby", --进入商城
	ViewMarketInUserInfo 		    = "ViewMarketInUserInfo", -- 个人信息界面进入商城

	-- 金币不够被动触发
	ShowQuickChargeInLobby 			= "ShowQuickChargeInLobby", --大厅中显示快速充值
	ShowQuickChargeInRoom 			= "ShowQuickChargeInRoom", -- 房间内显示快速充值

	SendFeedBack 					= "SendFeedBack",      -- 发送反馈消息
	SendChat 						= "SendChat",          -- 发送聊天
	SendFace 						= "SendFace",			-- 发送表情
	--进入房间
	SelectPrimaryRoom 				= "SelectPrimaryRoom",    -- 选择初级场次
	SelectMiddleRoom 				= "SelectMiddleRoom",    -- 选择中级场次
	SelectAdvanceRoom 				= "SelectAdvanceRoom",    -- 选择高级场次
	SelectExpertRoom 				= "SelectExpertRoom",    -- 选择专家场次
	SelectMasterRoom 				= "SelectMasterRoom",    -- 选择大师场次
	SelectFinchRoom					= "SelectFinchRoom",     -- 选择雀神场

	QuickStartGame 					= "QuickStartGame",      -- 快速开始

	EnterConsoleGame				= "EnterConsoleGame", 	-- 进入单机场次

	ViewFanHelpInRoom 				= "ViewFanHelpInRoom", --在房间内查看番型帮助
	ViewUserInfoInRoom 				= "ViewUserInfoInRoom", --在房间内查看个人信息 

	BankruptRequest 	= "BankruptRequest", --破产补助 携带等待时间

	DoubleChoice    = "DoubleChoice",  -- 1 加倍 0 胡牌

	LoginSuccess	= "LoginSuccess",

	-- 新手三步走
	FreshStepOne = "FreshStepOne",
	FreshStepTwo = "FreshStepTwo",
	FreshStepThree = "FreshStepThree",

};


-- 时长统计
UmengEvent.muti_cmds = {
	LoginSuccess 		= "LoginSuccess",
	MarketStayTime 		= "MarketStayTime",
	RankListStayTime 	= "RankListStayTime",
	HelpStayTime 		= "HelpStayTime",  
	BankruptRequest 	= "BankruptRequest", --破产补助 携带等待时间
}


UmengEvent.reportButtonEvent = function(key, id)
	if key then
		NativeEvent.getInstance():ReportButtonEvent(key, id);
	end
end

MonitorEvent = {};

-- REPORT_FLAG = true;

MonitorSceneType = {
	START_SCENE = 0,
	HALL_SCENE = 1,
	LOGIN_SCENE = 2,
	MALL_SCENE = 3,
	PLAY_SCENE = 4,
	EACH_BUREAU = 5,
}
-- 与android对应
function MonitorEvent.recordSceneStart(sceneType)
	if sceneType and PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		NativeEvent.getInstance():MonitorSceneStart(sceneType);
	end
end

function MonitorEvent.recordSceneEnd(sceneType)
	if sceneType and PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		NativeEvent.getInstance():MonitorSceneEnd(sceneType);
	end
end

function MonitorEvent.recordLogin()
	if PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		local id = UserData.getId();
		NativeEvent.getInstance():MonitorLogin(id);
	end
end

function MonitorEvent.recordSocketSend(sendCmd)
	if PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		NativeEvent.getInstance():MonitorSocketSend(sendCmd);
	end
end

function MonitorEvent.recordSocketRecv(recvCmd)
	if PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		NativeEvent.getInstance():MonitorSocketRecv(recvCmd);
	end
end

function MonitorEvent.recordLogout(tableId)
	if tableId and PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		NativeEvent.getInstance():MonitorLogout(tableId);
	end
end

function MonitorEvent.recordUpdateStart()
	if PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		printInfo("recordUpdateStart")
		NativeEvent.getInstance():MonitorUpdateStart();
	end
end

function MonitorEvent.recordUpdateEnd()
	if PlatformConfig.currPlatform == PlatformConfig.anzhiPlatform then
		printInfo("recordUpdateEnd")
		NativeEvent.getInstance():MonitorUpdateEnd();
	end
end