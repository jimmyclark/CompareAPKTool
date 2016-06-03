-- Data:2013-9-4
-- Description:各个状态的配置
-- Note:
--		程序使用StateMachine这个类，该类负责场景状态的切换，而切换的时候
-- 程序会查看系统维护的状态的集合，如果当前的状态不存在，那么以状态为索引
-- 到table----StatesMap中去获得状态，从而创建。所以，程序需要创建table,配置
-- state
States = 
{
	Load 	= 1,
	Lobby 	= 2,

	Room     = 3,
};

StateFileMap = {
	[States.Load] 		= "loadState",
	[States.Lobby] 		= "lobby/lobbyState",
	[States.Room] 		= "room/roomState",
}

-- 游戏类型ID 和后端同步
GameType = {
	KWXMJ 	= 24,
	SHMJ 	= 5,
	HBMJ 	= 10,
	GBMJ 	= 9,
}

GdmjPlayType = {
	JPH = 0,
	TDH = 1,
}

GameSocketMap = {
	[GameType.KWXMJ] 	= {
		processer 		= "mjSocket.common.commonProcesser",
		reader 			= "mjSocket.gdmj.gdmjReader",
		writer 			= "mjSocket.gdmj.gdmjWriter",
	},
	[GameType.GBMJ] 	= {
		processer 		= "mjSocket.common.commonProcesser",
		reader 			= "mjSocket.gbmj.gbmjReader",
		writer 			= "mjSocket.gbmj.gbmjWriter",
	},
	[GameType.SHMJ] 	= {
		processer 		= "mjSocket.common.commonProcesser",
		reader 			= "mjSocket.shmj.shmjReader",
		writer 			= "mjSocket.shmj.shmjWriter",
	},
	[GameType.HBMJ] 	= {
		processer 		= "mjSocket.common.commonProcesser",
		reader 			= "mjSocket.hbmj.hbmjReader",
		writer 			= "mjSocket.hbmj.hbmjWriter",
	},
}

-- 客户端支持的场景
GameSupportStateMap = {
	[GameType.KWXMJ] = true,
	[GameType.SHMJ] = true,
	[GameType.HBMJ] = false,
	[GameType.GBMJ] = true,
}

GameControllerMap = {
	[GameType.KWXMJ] = "room.gdmj.gdmjRoomController",
	[GameType.SHMJ] = "room.shmj.shmjRoomController",
	[GameType.HBMJ] = "room.hbmj.hbmjRoomController",
	[GameType.GBMJ] = "room.gbmj.gbmjRoomController",
}

-- 房间内Player玩家对应的类
GamePlayerMap = {
	[GameType.KWXMJ] = "room.gdmj.entity.gdPlayer",
	[GameType.SHMJ] = "room.shmj.entity.shPlayer",
	[GameType.HBMJ] = "room.hbmj.entity.hbPlayer",
	[GameType.GBMJ] = "room.gbmj.entity.gbPlayer",
}

-- 房间内CardPanel对应的类
GameCardPanelMap = {
	[GameType.KWXMJ] = "room.gdmj.entity.gdCardPanel",
	[GameType.SHMJ] = "room.shmj.entity.shCardPanel",
	[GameType.HBMJ] = "room.hbmj.entity.hbCardPanel",
	[GameType.GBMJ] = "room.gbmj.entity.gbCardPanel",
}

-- 房间内UserPanel对应的类
GameUserPanelMap = {
	[GameType.KWXMJ] = "room.gdmj.entity.gdUserPanel",
	[GameType.SHMJ] = "room.shmj.entity.shUserPanel",
	[GameType.HBMJ] = "room.hbmj.entity.hbUserPanel",
	[GameType.GBMJ] = "room.gbmj.entity.gbUserPanel",
}

StatesMap = {
}

function autoRequire(state)
	if not StatesMap[state] then
		StatesMap[state] = require(StateFileMap[state])
	end
end