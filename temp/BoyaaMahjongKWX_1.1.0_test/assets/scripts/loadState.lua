require("common.ConnectModule")
local LoadState = class(BaseState);
local printInfo, printError = overridePrint("LoadState")

function LoadState:load()
	BaseState.load(self);
	return true; -- 注意true的返回，如果没有返回true程序会持续调用，直到返回
end

function LoadState:ctor()
	GameConfig      = GameConfig 		or new(require("data.gameConfig"))
	GameConfig:load()
	
	PlatformManager = PlatformManager 	or new(require("platform.platformManager"))

	MyUserData 		= MyUserData 		or setProxy(new(require("data.userData")))

	MyCreateRoomCfg		= MyCreateRoomCfg	or new(require("data.createRoomConfig"))
	MyMailSystemData	= MyMailSystemData	or new(require("data.exchangeData"))
	MyMailFriendData	= MyMailFriendData	or new(require("data.exchangeData"))
	MyRecFriendData		= MyRecFriendData	or new(require("data.exchangeData"))
	MyFriendData		= MyFriendData		or new(require("data.friendData"))
	MyNoticeData 	    = MyNoticeData 		or 	new(require("data.noticeData"));
	MyExchangeData 		= MyExchangeData 	or 	new(require("data.exchangeData"))
	MyGoodsData 		= MyGoodsData 		or 	new(require("data.exchangeData"))
	MyGiftPackData 		= MyGiftPackData 	or 	new(require("data.exchangeData"))
	MyUpdateData 	    = MyUpdateData 		or 	setProxy(new(require("data.updateData")))
	MyFirstPayBagData 	= MyFirstPayBagData	or 	new(require("data.firstPayBag"));
    MySignAwardData     = MySignAwardData   or  setProxy(new(require("data.signAwardData")));
    MyMoneyRecommendData = MyMoneyRecommendData or  new(require("data.moneyRecommendData"));
    MyLevelConfigData   = MyLevelConfigData or 	new(require("data.levelConfigData"))
    MyPropData          = MyPropData        or  new(require("data.propData"));
    MyActivitiesData    = MyActivitiesData  or  setProxy(new(require("data.activitiesData")))
	MyBaseInfoData      = MyBaseInfoData  	or  setProxy(new(require("data.baseInfoData")))

	ShieldData 			= ShieldData        or  new(require("data.shieldData"))

	--初始化全局socket
	GameSocketMgr = GameSocketMgr or new(require("mjSocket.base.socketMgr"), kGameSocket, PROTOCOL_TYPE_BY9, 1)
	PhpManager    = PhpManager    or new(require("mjSocket.base.phpManager"))
	LoginMethod   = LoginMethod   or new(require("common.loginMethod"))

	AnimManager		= AnimManager 		or new(require("manager.animManager"))		
	WindowManager 	= WindowManager 	or new(require("manager.windowManager"))
	GuideManager 	= GuideManager      or new(require("manager.guideManager"))
	GameLoading     = GameLoading       or new(require("manager.gameLoading"))
	DownloadImage   = DownloadImage	    or new(require("common.downloadImage"))
	BroadcastPaoMaDeng = BroadcastPaoMaDeng or new(require("common.ui.broadcastPaoMaDeng"))
	GameResMemory = GameResMemory or new(require("gameBase/gameResMemory"))
	PayController = PayController or new(require("pay/payController"), "pay/")

	if not GlobalRoomLoading then
		local RoomLoading   = require("popu/room/roomLoading")
		GlobalRoomLoading = new(RoomLoading, loadingBg)
		GlobalRoomLoading:addToRoot()
		GlobalRoomLoading:setLevel(199)
	end

	---- HallConfig 	  	= HallConfig		or new(require("data.hallConfig"))
	---- HallConfig:load()

	ConnectModule.getInstance():initModule()

	G_RoomCfg 		= G_RoomCfg or setProxy(new(require("room.utils.roomConfig")))
	
	GameSetting		= GameSetting 		or setProxy(new(require("data.gameSetting")))
	FrameAnimManager = FrameAnimManager or new(require("common.frameAnimManager"))

	GameSetting:load()

   	kMusicPlayer:setVolume(GameSetting:getMusicVolume())
   	kEffectPlayer:setVolume(GameSetting:getSoundVolume())
	-- local fullMusicMap = getFullEffectPath(kMusicPlayer.m_soundFileMap);
	-- local fullSoundMap = getFullEffectPath(kEffectPlayer.m_soundFileMap);
	-- NativeEvent.getInstance():PreloadAllSound(fullMusicMap, fullSoundMap);

	card_pin_map = {}
	require("qnPlist/cards_pin1")
	require("qnPlist/cards_pin2")
	require("qnPlist/cards_pin3")
	for k, v in pairs(cards_pin1_map) do
		card_pin_map[k] = v
	end
	for k, v in pairs(cards_pin2_map) do
		card_pin_map[k] = v
	end
	for k, v in pairs(cards_pin3_map) do
		card_pin_map[k] = v
	end
end

function LoadState:resume(bundleData)
	LoadState.super.resume(self, bundleData)
	PlatformManager:executeAdapter(PlatformManager.s_cmds.StartSceneInit)

	ConnectModule.getInstance():getCDNNetConfig( true, nil )
end

return LoadState