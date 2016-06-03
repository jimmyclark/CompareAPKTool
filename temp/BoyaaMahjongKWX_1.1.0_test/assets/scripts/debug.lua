	-- GameSetting:setIsSecondScene(true)
	-- G_RoomCfg:setLevel(103)

-- printInfo(globalPlayer[2]:getUserData():getHeadName())
-- printInfo(globalPlayer[2]:getUserData():getMd5Name())
	-- GameSocketMgr:sendMsg(Command.LoginLobbyReq)

-- globalPlayer[2]:getUserData():setHeadUrl("http://abc")

-- dump(CommandSupport)
-- globalPlayer[SEAT_1]:_showHuanCardPanel()
-- testRoomController:showBigOutCard(1, 0x01)
-- printInfo("============debug===========")
-- GameSocketMgr:closeSocketSync()
-- GameSocketMgr:sendMsg(ROOM_CLIENT_COMMAND_OUTCARD, {})

-- dump(MyLevelConfigData)

-- dump(G_RoomCfg:getLevel())
-- local levelConfig = MyLevelConfigData:getLevelConfig(G_RoomCfg:getGameType(), G_RoomCfg:getLevel())
-- 	local suggestConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney(MyUserData:getMoney(), G_RoomCfg:getGameType())
-- AlarmTip.play("1dsafddafd阿斯蒂芬阿斯顿发送方1dsafddafd阿斯蒂芬阿斯顿发送方1dsafddafd阿斯蒂芬阿斯顿发送方1dsafddafd阿斯蒂芬阿斯顿发送方")
-- globalPlayer[1]:showAiStatus(true)
-- AtomAnimManager.getInstance():playAnim("atomAnimTable/flower", {
-- 	 		width = 850,
-- 	 		height = 400,
-- 	 		parent = self,
-- 	 		level = 51,
-- 	 	})

-- globalPlayer[2]:getUserData():setSex(0)
-- 	dump(levelConfig)
-- 	dump(suggestConfig)
	-- local bundleData = {
 --        type    = StateEvent.LoginRoomError,
 --        msgTip  = "登录异常，请重新登录！",
 --        reLogin = true,
 --    }
 --    StateChange.changeState(States.Lobby, bundleData)
 -- GameSocketMgr:sendMsg(Command.LogoutLobbyReq)
-- local str = ToolKit.subStr("123天气好", 5)
-- printInfo(str)
		-- GameSocketMgr:closeSocketSync(true)
	-- GameLoading:addPhpCommand(Command.JoinGameReq)

-- globalPlayer[1]:showTingStatus(1)
-- globalPlayer[2]:showTingStatus(1)
-- globalPlayer[3]:showTingStatus(1)
-- globalPlayer[4]:showTingStatus(1)
-- AtomAnimManager.getInstance():playAnim("atomAnimTable/upgrade", {
-- 		 		width = 600,
-- 	 			height = 150,
-- 		 		parent = self,
-- 		 		level = 51,
-- 		 		onComplete = gameOverFunc,
-- 		 	})

-- testRoomController:clearTableForGame()
-- testRoomController:_removeAllPlayers()
-- testRoomController:_initAllPlayers()
-- testRoomController:onEnterRoomSuccess(GlobalTestData)
-- testRoomController.m_timer:stop()



-- WindowManager:showWindow(WindowTag.GameOverWinPopu, {
-- 		iHuCard = 0x1,
-- 		dropCoinFlag = true,
-- 		iPlayerResult = {
-- 			[MyUserData:getId()] = {
-- 				iTurnMoney = 1000,
-- 				iHuType = 2,
-- 				iLocalSeatId = 1,
-- 				isWin = true,
-- 				iUserData = MyUserData,
-- 				iHandCards = {0x1, 0x2, 0x3, 0x5, 0x5},
-- 				iExtraCards = {
-- 					{
-- 						operateValue = kOpeMiddleChi,
-- 						cards = {0x1, 0x2, 0x3},
-- 					},
-- 					{
-- 						operateValue = kOpePeng,
-- 						cards = {0x2, 0x2, 0x2},
-- 					},
-- 					{
-- 						operateValue = kOpePengGang,
-- 						cards = {0x2, 0x2, 0x2, 0x2},
-- 					},
-- 				},
-- 				iCbUsers = {MyUserData:getId()},
-- 				iFansTb = {
-- 					{
-- 						iFanId = 1,
-- 						iFanNum = 29,
-- 					},
-- 					{
-- 						iFanId = 2,
-- 						iFanNum = 33,
-- 					},
-- 					{
-- 						iFanId = 3,
-- 						iFanNum = 22,
-- 					},
-- 					{
-- 						iFanId = 5,
-- 						iFanNum = 29,
-- 					},
-- 					{
-- 						iFanId = 6,
-- 						iFanNum = 33,
-- 					},
-- 					{
-- 						iFanId = 7,
-- 						iFanNum = 22,
-- 					},
-- 					{
-- 						iFanId = 8,
-- 						iFanNum = 29,
-- 					},
					
-- 				}
-- 			},
-- 			[1] = {
-- 				iTurnMoney = 0,
-- 				iHuType = 0,
-- 				iLocalSeatId = 2,
-- 				isWin = true,
-- 				iUserData = MyUserData,
-- 				iHandCards = {0x1, 0x2, 0x3, 0x5, 0x5, 0x5, 0x5, 0x5},
-- 				iExtraCards = {
-- 					{
-- 						operateValue = kOpeMiddleChi,
-- 						cards = {0x1, 0x2, 0x3},
-- 					},
-- 					{
-- 						operateValue = kOpePeng,
-- 						cards = {0x2, 0x2, 0x2},
-- 					},
-- 				},
-- 				iCbUsers = {MyUserData:getId()},
-- 				iFansTb = {},
-- 			},
-- 			[2] = {
-- 				iTurnMoney = 0,
-- 				iHuType = 0,
-- 				iLocalSeatId = 3,
-- 				isWin = true,
-- 				iUserData = MyUserData,
-- 				iHandCards = {0x1, 0x2, 0x3, 0x5, 0x5, 0x5, 0x5, 0x5},
-- 				iExtraCards = {
-- 					{
-- 						operateValue = kOpeMiddleChi,
-- 						cards = {0x1, 0x2, 0x3},
-- 					},
-- 					{
-- 						operateValue = kOpePeng,
-- 						cards = {0x2, 0x2, 0x2},
-- 					},
-- 				},
-- 				iCbUsers = {MyUserData:getId()},
-- 				iFansTb = {},
-- 			},
-- 			[3] = {
-- 				iTurnMoney = -1234556,
-- 				iHuType = 3,
-- 				iLocalSeatId = 4,
-- 				isWin = true,
-- 				iUserData = MyUserData,
-- 				iHandCards = {0x1, 0x2, 0x3, 0x5, 0x5, 0x5, 0x5, 0x5},
-- 				iExtraCards = {
-- 					{
-- 						operateValue = kOpeMiddleChi,
-- 						cards = {0x1, 0x2, 0x3},
-- 					},
-- 					{
-- 						operateValue = kOpePeng,
-- 						cards = {0x2, 0x2, 0x2},
-- 					},
-- 				},
-- 				iCbUsers = {MyUserData:getId()},
-- 				iFansTb = {},
-- 			},
-- 		}
-- 	})

 -- MyUserData:setSeatId()
	-- WindowManager:showWindow(WindowTag.GameOverLosePopu, result)

-- printInfo("剩余弹窗数量%d", #WindowManager.m_windows)
-- WindowManager:showWindow(WindowTag.MessageBox1)
-- HttpModule.getInstance():execute(HttpModule.s_cmds.RequestExchangeGoods, param_data);

-- AnimManager:play(AnimationTag.AnimTemplate)

--[[------------------------------------------------------------------------
test_zip.lua
test code for luazip
--]]------------------------------------------------------------------------

-- compatibility code for Lua version 5.0 providing 5.1 behavior
-- if string.find (_VERSION, "Lua 5.0") and not package then
-- 	if not LUA_PATH then
-- 		LUA_PATH = os.getenv("LUA_PATH") or "./?.lua;"
-- 	end
-- 	require"compat-5.1"
-- 	package.cpath = os.getenv("LUA_CPATH") or "./?.so;./?.dll;./?.dylib"
-- end

-- require('zip')

-- function test_open ()
-- 	local zfile, err = zip.open('luazip.zip')
	
-- 	assert(zfile, err)
	
-- 	print("File list begin")
-- 	for file in zfile:files() do
-- 		print(file.filename)
-- 	end
-- 	print("File list ended OK!")
-- 	print()
	
-- 	print("Testing zfile:open")
-- 	local f1, err = zfile:open('README')
-- 	assert(f1, err)
	
-- 	local f2, err = zfile:open('luazip.h')
-- 	assert(f2, err)
-- 	print("zfile:open OK!")
-- 	print()
	
-- 	print("Testing reading by number")
-- 	local c = f1:read(1)
-- 	while c ~= nil do
-- 		io.write(c)
-- 		c = f1:read(1)
-- 	end

-- 	print()
-- 	print("OK")
-- 	print()
-- end

-- function test_openfile ()
-- 	print("Testing the openfile magic")
	
-- 	local d, err = zip.openfile('a/b/gamecore/src/app/ui/UILoadingPanel.lua')
-- 	assert(d, err)
-- 	local char = d:read(1)
-- 	print("read a/b/c/d.txt")
-- 	while char ~= nil do
-- 		io.write(char)
-- 		char = d:read(1)
-- 	end
-- 	print()
	
-- 	local e, err = zip.openfile('a/b/c/e.txt')
-- 	assert(e == nil, err)
	
-- 	local d2, err = zip.openfile('a2/b2/c2/d2.txt', "ext2")
-- 	assert(d2, err)
	
-- 	local e2, err = zip.openfile('a2/b2/c2/e2.txt', "ext2")
-- 	assert(e2 == nil, err)
	
-- 	local d3, err = zip.openfile('a3/b3/c3/d3.txt', {"ext2", "ext3"})
-- 	assert(d3, err)
	
-- 	local e3, err = zip.openfile('a3/b3/c3/e3.txt', {"ext2", "ext3"})
-- 	assert(e3 == nil, err)
	
-- 	print("Smooth magic!")
-- 	print()
-- end

-- -- test_open()
-- test_openfile()
-- printInfo("设置金币")
-- MyUserData:setMoney(1011)
-- printInfo(MyUserData:getMoney())

-- AlarmNotice.play("ceshi dsfsdf ")
-- AtomAnimManager.getInstance():playAnim("atomAnimTable/lose", {
-- 		 		width = 800,
-- 		 		height = 600,
-- 		 		parent = self,
-- 		 		level = 51,
-- 		 		onComplete = function()
-- 					-- WindowManager:showWindow(WindowTag.GameOverLosePopu, result)
-- 		 		end,
-- 		 	})
-- MyUserData:setMoney(20000000)

-- printInfo("G_RoomCfg:getGameType() = %d", G_RoomCfg:getGameType())
		-- UIEx.bind(globalNick, MyUserData, "money", function(value)
		-- 	globalNick:setText(value)
		-- end)
-- AnimManager:play(AnimationTag.AnimShake, testLobbyScene)
-- printInfo(string.sub("sgadsg.txt.tmp", -4))
-- testLobbyScene:onSocketConnectFailed()
-- testRoomController:
-- package.loaded['moduleTest'] = nil
-- require('moduleTest')
-- printInfo(Constants.GlobalTip)
-- printInfo(Constants.GlobalTip)
-- require("lfs")

-- local function removePath(path)
--     local mode = lfs.attributes(path, "mode")
--     if mode == "directory" then
--         local dirPath = path
--     	if string.sub(path, -1) ~= "/" then dirPath = dirPath .. "/" end
--         for file in lfs.dir(dirPath) do
--             if file ~= "." and file ~= ".." then 
--                 local f = dirPath..file 
--                 removePath(f)
--             end
--         end
--         os.remove(path)
--     else
--         os.remove(path)
--     end
-- end

-- removePath("D:/test_remove")

-- if not card then
-- 	card = UIFactory.createImage("ui/image.png")
-- 	-- card:setAlign(kAlignCenter)
-- 	card:addToRoot()
-- end
-- -- card:pos(display.cx, display.cy)
-- card:stopAllActions()
-- transition.moveTo(card, {
-- 	sequence = 1001,
-- 	easing = "ELASTICIN",
-- 	time = 1500,
-- 	x = 200,
-- 	y = 100,
-- 	onComplete = function()
-- 		transition.scaleBy(card, {
-- 			sequence = 1002,
-- 			scale = 1.8,
-- 			easing = "bounceIn",
-- 			time = 1500,
-- 			onComplete = function(value)
-- 				printInfo("value = ")
-- 				transition.fadeTo(card, {
-- 					sequence = 1003,
-- 					easing = "bounceOut",
-- 					opacity = 0.5,
-- 					time = 1000,
-- 					onComplete = function()
-- 						transition.rotateTo(card, {
-- 							sequence = 1005,
-- 							angle = 180,
-- 							easing = "sinIn",
-- 							time = 1000,
-- 							onComplete = function()
-- 								printInfo("x = %d, y = %d", card:getPos())
-- 								printInfo("scaleX = %d, scaleY = %d", card:getScale())
-- 								printInfo("fade = %d", card:getTransparency())
-- 							end
-- 						})
-- 					end,
-- 				})
-- 			end,
-- 		})
-- 	end,
-- })

-- transition.fadeTo(card, {
-- 	sequence = 1003,
-- 	easing = "bounceOut",
-- 	opacity = 0.0,
-- 	time = 1000,
-- })

-- transition.tintTo(card, {
-- 	sequence = 1004,
-- 	easing = "bounceOut",
-- 	color = c3b(0, 0, 0),
-- 	time = 1000,
-- })

-- transition.rotateTo(card, {
-- 	sequence = 1005,
-- 	angle = 180,
-- 	easing = "bounceOut",
-- 	time = 1000,
-- })

-- printInfo(PhpManager:getMachineInfo())
-- GameSocketMgr:closeSocketSync()
	-- WindowManager:showWindow(WindowTag.MessageBox)
	-- GameSocketMgr:sendMsg(Command.ReadyReq)
	-- testRoomScene:showRoomLoading()

	-- testRoomScene:realShowRoom()

-- StateChange.changeState(States.Lobby, {
-- 	type = StateEvent.LoginRoomError,
-- 	msgTip = "温馨提示"
-- })

-- AnimManager:play(AnimationTag.ShaiZi, {
-- 	bankSeat = 1,
-- 	onComplete = function()
-- 		-- for k,v in pairs(testRoomScene.m_players) do
-- 		-- 	v:onGameReadyStart()
-- 		-- end
-- 	end
-- })

-- G_RoomCfg:initInfo({}, 0)
-- G_RoomCfg:setBankSeatId(1)
-- testRoomController:onDealCardBd({
-- 	iAllHandCards = {
-- 		{ 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x31, 0x32, 0x33, 0x34},
-- 		{ 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
-- 		{ 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
-- 		{ 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
-- 	}
-- })

-- -- 聊天
-- EventDispatcher.getInstance():dispatch(Event.Socket, Command.UserChat, {
-- 		iUserId = MyUserData:getId(),
-- 		iChatInfo = "chatsdf"
-- 	});

-- -- 表情
-- EventDispatcher.getInstance():dispatch(Event.Socket, Command.UserFace, {
-- 		iUserId = MyUserData:getId(),
-- 		iFaceType = 123
-- 	});

-- -- 抓牌

-- AlarmTip.play("data.iMessage")
-- AlarmNotice.play("data.iMessage")

-- new(CustomNode, kRenderLineStrip, kRenderDataColors, {100,100,200,100,200,200,100,200}, {0,1,2,3}, 

-- testRoomController.m_timer:play(3, 10)
-- testRoomController.m_timer:setSeatInfo(2)
	-- ToastShade.getInstance():stopTimer()
	-- G_RoomCfg:setRemainNum(2)

-- for i=0x21, 0x21 do
-- 	globalCardPanel[1]:createOneExtraCardTb({
-- 		operateValue = kOpePeng,
-- 		cards = {i, i, i}
-- 	})
-- 	globalCardPanel[2]:createOneExtraCardTb({
-- 		operateValue = kOpePeng,
-- 		cards = {i, i, i}
-- 	})
-- 	globalCardPanel[3]:createOneExtraCardTb({
-- 		operateValue = kOpePeng,
-- 		cards = {i, i, i}
-- 	})
-- 	globalCardPanel[4]:createOneExtraCardTb({
-- 		operateValue = kOpePeng,
-- 		cards = {i, i, i}
-- 	})
-- end
-- GameSetting:setSoundType(SoundType.KWXMJ)

-- playChatSound("大家好！很高兴见到各位！", 1)
-- playOutCardSound(0x1, 1)

-- UIFactory.createImage()

-- globalCardPanel[1]:clearHandCards()
-- globalCardPanel[2]:clearHandCards()
-- globalCardPanel[3]:clearHandCards()
-- globalCardPanel[4]:clearHandCards()
-- for i=1, 14 do
-- 	globalCardPanel[1]:createOneHandCard(math.random(1, 9))
-- 	globalCardPanel[2]:createOneHandCard(0)
-- 	globalCardPanel[3]:createOneHandCard(0)
-- 	globalCardPanel[4]:createOneHandCard(0)
-- end

-- globalPlayer[1]:sendPropToPlayer(4, globalPlayer[4])
-- printInfo(math.ceil(math.random() * 3) + 6000)
--printInfo(MyLevelConfigData:getPamountByLevel(102))
-- dump(MyLevelConfigData)
-- MyFirstPayBagData:setAward(2)
-- -- MyUserData:setMoney(1)
-- local TimerClock = require("room.entity.timerClock")
-- testRoomController.m_timer:play(4, 5, TimerClock.Operate)
-- testRoomController.m_timer:setSeatInfo(4)



    -- GameSocketMgr:sendMsg(Command.FIRST_PAY_BAG_PHP_REQUEST, { ['act']='detail'}, false);
    -- MyFirstPayBagData:setOpen(0)
    -- MyFirstPayBagData:setAward(2)
    -- MyBaseInfoData:setFirstPay(1);
    -- MyUserData:setMoney(999)
	-- EventDispatcher.getInstance():dispatch(Event.Message, "closePopu", {popuId = 0});
	
-- EventDispatcher.getInstance():dispatch(Event.Socket, Command.LogoutRoomRsp)

    
    
    -- MyBaseInfoData:set

-- globalPlayer[2]:getGameData():setHuaNum(1)


-- MyUserData:setMoney(11799999)
-- local path = "popu/room/roomSetting/"
-- local switch = new(Switch, nil, nil, path .. "select_btn.png", path .. "select_btn.png", path .. "select_bg.png", pendingAnimationImages, staticPendingAnimationImage)
-- switch:addToRoot()
-- switch:pos(display.cx, display.cy)

-- globalPlayer[1]:getGameData():setHuaNum(math.random(0, 9))
-- globalPlayer[2]:getGameData():setHuaNum(math.random(0, 9))
-- globalPlayer[3]:getGameData():setHuaNum(math.random(0, 9))
-- globalPlayer[4]:getGameData():setHuaNum(math.random(0, 9))

-- MyUserData:setMoney(10000000000000)


-- globalCardPanel[SEAT_1]:switchBuGangToPeng(0x5)
-- globalCardPanel[SEAT_2]:switchBuGangToPeng(0x5)
-- globalCardPanel[SEAT_3]:switchBuGangToPeng(0x5)
-- globalCardPanel[SEAT_4]:switchBuGangToPeng(0x5)

-- globalCardPanel[SEAT_1]:switchPengToBuGang(0x5)
-- globalCardPanel[SEAT_2]:switchPengToBuGang(0x5)
-- globalCardPanel[SEAT_3]:switchPengToBuGang(0x5)
-- globalCardPanel[SEAT_4]:switchPengToBuGang(0x5)
-- testRoomController:onOperateCardBd({
-- 	iUserId = globalPlayer[1]:getUserData():getId(),
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpePeng,
-- 	iTargetSeatId = 1,
-- })

-- testRoomController:onOperateCardBd({
-- 	iUserId = globalPlayer[1]:getUserData():getId(),
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpeAnGang,
-- 	iTargetSeatId = 1,
-- })

-- testRoomController:onOperateCardBd({
-- 	iUserId = globalPlayer[1]:getUserData():getId(),
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpeAnGang,
-- 	iTargetSeatId = 1,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = globalPlayer[2]:getUserData():getId(),
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpePeng,
-- 	iTargetSeatId = 1,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = globalPlayer[3]:getUserData():getId(),
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpePeng,
-- 	iTargetSeatId = 1,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = globalPlayer[4]:getUserData():getId(),
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpePeng,
-- 	iTargetSeatId = 1,
-- })
-- dump(MyLevelConfigData)

-- MyUserData:setMoney(230000)
-- 大番型动画
-- if testRoomController then
-- 	local HuAnim = require("animation/animationWinGame");
-- 		new(HuAnim, testRoomController)
-- 			:addTo(testRoomController)
-- 			:play();
-- end

-- GuideManager:onEnterRoomGuide()
-- GameSocketMgr:sendMsg(Command.NoticeMoneyChangeReq, {
-- 	iUserId = MyUserData:getId()
-- })
-- WindowManager:showWindow(WindowTag.TestToolPopu)

-- globalCardPanel[SEAT_2]:reDrawExtraHandCards({0x04, 0x05, 0x01, 0x04, 0x05, 0x01, 0x02, 0x03, 0x11, 0x22, 0x13, 0x21, 0x22, 0x03})
-- globalCardPanel[SEAT_1]:reDrawExtraHandCards({0x04, 0x05, 0x01, 0x04, 0x05, 0x01, 0x02, 0x03, 0x11, 0x22, 0x13, 0x21, 0x22, 0x03})
-- globalCardPanel[SEAT_3]:reDrawExtraHandCards({0x04, 0x05, 0x01, 0x11, 0x12, 0x13, 0x14, 0x15, 0x17, 0x28, 0x19, 0x27, 0x28, 0x09})
-- globalCardPanel[SEAT_4]:reDrawExtraHandCards({0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, 0x15, })

-- GameSocketMgr:sendMsg(Command.RequestAi, {
-- 	iAiType = math.random(0, 1),
-- })	
  	-- kEffectPlayer:play(Effects.PropCheer3);

-- globalPlayer[1]:requestAi(1)
-- local a = (function() printInfo("aaa") end)()
-- local userData1 = require("data.userData")
-- local userData2 = setProxy(require("data.userData"))

-- UIEx.bind(testLobbyScene.moneyText, userData2, "money", function(value)

-- end)

-- printInfo("start time = %d", os.time())
-- for i=1, 1000000 do
-- 	userData1:setMoney(1000)
-- 	EventDispatcher.getInstance():dispatch(Event.Message, "updateMoney", 1000)
-- end
-- printInfo("end time = %d", os.time())

-- printInfo("start time = %d", os.time())
-- for i=1, 1000000 do
-- 	userData2:setMoney(1000)
-- end
-- -- printInfo("end time = %d", os.time())
-- globalPlayer[1]:showChatFace(10)
-- globalPlayer[2]:showChatFace(10)
-- globalPlayer[3]:showChatFace(10)
-- globalPlayer[4]:showChatFace(10)
-- -- sendPropToPlayer

globalPlayer[1]:sendPropToPlayer(8, globalPlayer[2])
-- globalPlayer[2]:sendPropToPlayer(1, globalPlayer[4])
-- globalPlayer[3]:sendPropToPlayer(1, globalPlayer[4])
-- globalPlayer[4]:sendPropToPlayer(1, globalPlayer[4])
-- MyUserData:setMoney(299999)
-- testRoomController:onOperateCardBd({
-- 	iUserId = 2,
-- 	iCard = 0x4,
-- 	-- iOpValue = kOpePengGang,3
-- 	iOpValue = kOpePeng,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = 2,
-- 	iCard = 0x08,
-- 	-- iOpValue = kOpePengGang,3
-- 	iOpValue = kOpeMiddleChi,
-- })

-- globalPlayer[1]:dealOpAfterOtherOperate(0x01, 1)
-- testRoomController:onQiangGangHuBd({
-- 		iCard = 0x01,
-- 		iFanLeast = 10,
-- 		iOpValue = kOpePengGangHu,
-- 	})

-- globalPlayer[1]:onSwapCardStartBd()

-- dump(bit.bxor(0x110, 0x10))

-- testRoomController:onOperateCardBd({
-- 	iUserId = 2,
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,3
-- 	iOpValue = kOpeAnGang,
-- })

-- testRoomController:onOperateCardBd({
-- 	iUserId = 3,
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,3
-- 	iOpValue = kOpePeng,
-- })

-- for i=SEAT_1, SEAT_4 do
-- 	globalPlayer[i].m_gameData:setIsPlaying(0)
-- end

-- playOperateSound(kOpeBuHua, 0)

-- testRoomController:onOperateCardBd({
-- 	iUserId = 3,
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpeBuGang,
-- 	iOpValue = kOpeBuGang,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = 2,
-- 	iCard = 0x5,
-- 	-- iOpValue = kOpePengGang,
-- 	iOpValue = kOpeMiddleChi,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = 3,
-- 	iCard = 0x5,
-- 	iOpValue = kOpeMiddleChi,
-- 	-- iOpValue = kOpeAnGang,
-- })
-- testRoomController:onOperateCardBd({
-- 	iUserId = MyUserData:getId(),
-- 	iCard = 0x9,
-- 	iOpValue = kOpePeng,
-- 	-- iOpValue = kOpeMiddleChi,
-- 	-- iOpValue = kOpeHu,
-- 	-- iOpValue = kOpeAnGang,
-- })

-- printInfo("userId = %d", MyUserData:getId())
-- WindowManager:showWindow(WindowTag.UserInfoPopu)

-- testRoomController:requestReady()
-- printInfo("fffffff")
-- playOutCardSound( 0x4, 1)
-- 	kEffectPlayer:play("audio_button_click");
-- 	playOperateSound(kOpePengGang, 1)

-- printInfo(tostring(0x31))

-- globalPlayer[1].m_gameData:setIsPlaying(0)
-- G_RoomCfg:setJu(2)

-- globalPlayer[1].m_gameData:setIsReady(0)
-- globalPlayer[1].m_gameData:setIsAi(1)

-- globalPlayer[1]:showOperatePanel(0x5, {
-- 	-- iOpValue = bit.bor(bit.bor(bit.bor(bit.bor(kOpePeng, kOpeMiddleChi), kOpePengGang), kOpeHu), kOpeTing),
-- 	-- iOpValue = bit.bor(bit.bor(kOpePeng, kOpeHu), kOpeLeftChi),
-- 	iOpValue = kI,
-- 	iAnCards = {0x02}
-- -- })

-- globalCardPanel[1]:clearOutCards()
-- globalCardPanel[2]:clearOutCards()
-- globalCardPanel[3]:clearOutCards()
-- globalCardPanel[4]:clearOutCards()

-- globalCardPanel[1]:resetOutCardPosAndLayer()
-- globalCardPanel[2]:resetOutCardPosAndLayer()
-- globalCardPanel[3]:resetOutCardPosAndLayer()
-- globalCardPanel[4]:resetOutCardPosAndLayer()
-- for i=1, 24 do
-- 	local suit = math.random(0, 2)
-- 	local face = math.random(1, 9)
-- 	local card = tonumber("0x" .. suit .. face)
-- 	-- local lastOutCard = globalCardPanel[1]:createOneOutCard(0x01)
-- 	-- lastOutCard:resetImageByValueAndType(0x02, globalCardPanel[1].m_outCardImgFileReg)
-- 	globalCardPanel[4]:createOneOutCard(0x43)
-- 		-- if face == 5 then
-- 		-- 	cc:setColor(200, 200, 200)
-- 		-- end
-- 	globalCardPanel[1]:createOneOutCard(0x43)
-- 		-- if face == 5 then
-- 		-- 	cc:setColor(200, 200, 200)
-- 		-- end
-- 	globalCardPanel[2]:createOneOutCard(0x43)
-- 		-- if face == 5 then
-- 		-- 	cc:setColor(200, 200, 200)
-- 		-- end
-- 	globalCardPanel[3]:createOneOutCard(0x43)
-- 		-- if face == 5 then
-- 		-- 	cc:setColor(200, 200, 200)
-- 		-- end
-- end
-- globalSeat = globalSeat or 1
-- globalPlayer[globalSeat]:onAddCard(0x01, {})
-- local anim = AnimFactory.createAnimInt(kAnimNormal, 0, 1, 500, 0)
-- anim:setEvent(nil, function()
-- 	globalPlayer[globalSeat]:onOutCard(0x01, 0)
-- 	globalSeat = globalSeat % 4 + 1
-- end)

-- MyUserData:addMoney(1001, true)
-- AnimManager:play(AnimationTag.Operate, {
-- 		cardValue = 0x01,
-- 		cards = {},
-- 		opValue = kOpeHu,
-- 		pos = {x = display.cx, y = display.cy},
-- 		onComplete = function()
-- 		end
-- 	})
-- local HuAnim = require("animation/animationWinGame");
-- 		new(HuAnim, testRoomController)
-- 			:addTo(testRoomController)
-- 			:play();

-- globalPlayer[1]:judgeRemoveOperateCard(kOpePeng, 0x01)
-- globalPlayer[1]:reconnTable({0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, }, {
-- 		iHuaCardTb = {},
-- 		iExtraCardsTb = {},
-- 		iOutCardTb = {0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 
-- 		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 
-- 		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, },
-- 	})
-- playOutCardSound(0x21, 1)
-- getMutiEffectPath(Effects.mutiEffectMap[SoundType.SHMJ])
-- globalPlayer[1]:onOutCard(0x01, 0)

-- WindowManager:showWindow(WindowTag.GuidePopu, nil, WindowStyle.NORMAL)
-- MyUserData:setMoney(1999)
-- function app:selectGoodsForChargeByLevel(params)
-- 	params = params or {}
-- 	local level = params.level or G_RoomCfg:getLevel()
-- 	local chargeType = params.chargeType
-- 	local isBroke = self:checkIsBroke()
-- 	local avoidFirstPay = params.avoidFirstPay
-- 	repeat
-- 		-- 如果可以弹出首充 则根据此回合是否破产设置下回合不弹首充
-- 		if not MyUserData:getAvoidFirstPay() and not avoidFirstPay and self:judgeShowFirstPayPopu(chargeType) then 
-- 			MyUserData:setAvoidFirstPay(isBroke and not self:isInRoom())
-- 			break
-- 		end
-- 		-- 根据金币查找推荐额度
-- 		local pamount = MyLevelConfigData:getPamountByLevel(level)
-- 		if not pamount thenl
-- 			AlarmTip.play("没有相应的额度")
-- 			GameSocketMgr:sendMsg(Command.ROOM_CONFIG_PHP_REQUEST, {})
-- 			break
-- 		end
-- 		-- 根据额度查找商品
-- 		local goodsIndex, goodsInfo = PayController:getGoodsInfoByPamount(pamount)
-- 		if not goodsIndex then
-- 			AlarmTip.play("商品不存在")
-- 			break
-- 		end
-- 		WindowManager:showWindow(WindowTag.RechargePopu, {
-- 			goodsIndex = goodsIndex,
-- 			goodsInfo = goodsInfo,
-- 			-- 需要不在牌局中才弹破产
-- 			chargeType = (isBroke and ChargeType.BrokeCharge) or chargeType or ChargeType.QuickCharge,
-- 		});
-- 	until true
-- end

-- local wnd = WindowManager:containsWindowByTag(WindowTag.GameOverLosePopu)
-- wnd:requestChangeDesk()

-- local wnd = WindowManager:containsWindowByTag(WindowTag.FirstPayBagPopu)

-- function wnd:onHidenEnd(...)
--     -- body
--     wnd.super.onHidenEnd(self, ...);

--     if not self.mPay and app:checkIsBroke() then
--         MyUserData:setAvoidFirstPay(true)
--         app:selectGoodsForChargeVarMoney()
--     elseif self.chargeType == ChargeType.NotEnoughMoney then
--         app:selectGoodsForChargeByLevel({
--             chargeType = ChargeType.NotEnoughMoney,
--             avoidFirstPay = true,
--         })
--     end
-- end

-- globalPlayer[1]:onGfxyBd(1001)
-- globalPlayer[2]:onGfxyBd(1001)
-- globalPlayer[3]:onGfxyBd(1001)
-- globalPlayer[4]:onGfxyBd(1001)
-- require("animation.animationParticles")
-- AnimationParticles.play(AnimationParticles.DropCoin)
-- local AddMoneyAnim = require("animation.animAddMoney")
-- local node = new(AddMoneyAnim)
-- node:addToRoot()
-- node:play( {
-- 		money = -0001,
-- 		pos = ccp(display.cx, display.cy),
-- 	})
-- function analysShaiziNum(eastSeatId, bankSeatId)
--   	local resultAll ={};
--   	local 
-- 	for i=1,6 do
-- 	    for j=1,6 do
-- 	        if((i+j-1) % 4 + 1 == bankSeatId) then
-- 	           	local result = {};
-- 	           	result.i=i;
-- 	           	result.j=j;
-- 	           	table.insert(resultAll,result);
-- 	        end
-- 	    end
-- 	end
-- 	dump(bankSeatId)
--     dump(resultAll)
--     local index = math.random(1, #resultAll);
-- end
-- analysShaiziNum(0, math.random(1, 4))

-- globalUserPanel[1]:showChatWord("trye")
-- globalPlayer[1]:showTingStatus(1)
-- globalPlayer[1]:showTingTipView({
-- 	{
-- 		iFan = 1,
-- 		iFanId = 1,
-- 		iRemain = 2,
-- 		iHuCard = 0x12,
-- 	},
-- 	{
-- 		iFan = 1,
-- 		iFanId = 1,
-- 		iRemain = 2,
-- 		iHuCard = 0x13,
-- 	},
-- 	{
-- 		iFan = 1,
-- 		iFanId = 1,
-- 		iRemain = 2,
-- 		iHuCard = 0x14,
-- 	},

-- WindowManager:closeWindowByTag(WindowTag.SettingPopu)
	-- {
	-- 	iFan = 1,
	-- 	iFanId = 1,
	-- 	iRemain = 2,
	-- 	iHuCard = 0x15,
	-- },
	-- {
	-- 	iFan = 1,
	-- 	iFanId = 1,
	-- 	iRemain = 2,
	-- 	iHuCard = 0x16,
	-- },
	-- {
	-- 	iFan = 1,
	-- 	iFanId = 1,
	-- 	iRemain = 2,
	-- 	iHuCard = 0x17,
	-- },
	-- {
	-- 	iFan = 1,
	-- 	iFanId = 1,
	-- 	iRemain = 2,
	-- 	iHuCard = 0x18,
	-- },
	-- {
	-- 	iFan = 1,
	-- 	iFanId = 1,
	-- 	iRemain = 2,
	-- 	iHuCard = 0x18,
	-- },
	-- {
	-- 	iFan = 1,
	-- 	iFanId = 1,
	-- 	iRemain = 2,
	-- 	iHuCard = 0x18,
	-- },
-- }, true)

-- AtomAnimManager.getInstance():playAnim("atomAnimTable/lose", {
-- 		 		width = 700,
-- 		 		height = 500,
-- 		 		parent = self,
-- 		 		level = 51,
-- 		 		onComplete = function()
-- 					WindowManager:showWindow(WindowTag.GameOverLosePopu, result)
-- 		 		end,
-- 		 	})

-- globalPlayer[1]:showTingStatus(1)
-- globalPlayer[2]:showTingStatus(1)
-- globalPlayer[3]:showTingStatus(1)
-- globalPlayer[4]:showTingStatus(1)

-- ::scsdc::

-- goto scsdc
-- for i = SEAT_1, SEAT_4 do
-- globalPlayer[i]:reDrawTable(
-- 	{0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09},
-- 	{
-- 		iExtraCardsTb = {
-- 			{
-- 				opValue = kOpePeng,
-- 				card = 0x06,
-- 			},
-- 			{
-- 				opValue = kOpeAnGang,
-- 				card = 0x07,
-- 			},
-- 			{
-- 				opValue = kOpePengGang,
-- 				card = 0x08,
-- 			},
-- 		},
-- 		iOutCardTb = {0x01, 0x02, 0x03},
-- 		iHuaCardTb = {0x51, 0x52, 0x53},
-- 	}
-- )
-- end

-- globalPlayer[2]:onGameOver({
-- 	iMoney = 1001,
-- 	iHandCards = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09},
-- })

-- globalPlayer[1]:onGameOver({
-- 	iMoney = 1001,
-- 	iHandCards = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09},
-- })

-- globalPlayer[3]:onGameOver({
-- 	iMoney = 1001,
-- 	iHandCards = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09},
-- })

-- globalPlayer[4]:onGameOver({
-- 	iMoney = 1001,
-- 	iHandCards = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09},
-- })

-- AnimManager:play(AnimationTag.Operate, {
-- 		cardValue = 0,
-- 		cards = {0,0,0,0},
-- 		opValue = kOpeAnGang,
-- 		pos = {x = display.cx, y = display.cy},
-- 	})

  -- ToastShade.getInstance():play();
--------------------输牌动画-- start----------------------------
--     local parentW = System.getScreenWidth();
--     local parentH = System.getScreenHeight();
--     local width   = 429;
--     local height  = 231;
-- AtomAnimManager.getInstance():playAnim("atomAnimTable/lose", {
	
-- 	});
--------------------输牌动画-- end----------------------------

--------------------流局动画-- start----------------------------
-- AtomAnimManager.getInstance():playAnim("atomAnimTable/upgrade", {
-- 	 		width = 650,
-- 	 		height = 150,
-- 	 		parent = self,
-- 	 		level = 51,
-- 	 		onComplete = function()
-- 	 			AlarmTip.play("开始结算")
-- 	 		end
-- 	 	})
-- dump(MyLevelConfigData)
-- globalPlayer[1]:showTingStatus(1)

-- local GameServer 	= require("room.gameServer")
-- if not G_gameServer then
-- 	G_gameServer = new(GameServer)
-- 	G_gameServer:addToRoot()
-- end
	-- EventDispatcher.getInstance():dispatch(Event.Message, "requestChangeDesk", ChangeDeskType.Down)
	-- dump(MyLevelConfigData)

--------------------流局动画-- end----------------------------

-- AtomAnimManager.getInstance():playAnim("atomAnimTable/upgrade", {
-- 	 		width = 512,
-- 	 		height = 369,
-- 	 		parent = self,
-- 	 		level = 51,
-- 	 	})

-- globalUserPanel[1]:onUserExit()
-- globalUserPanel[2]:onUserExit()
-- globalUserPanel[3]:onUserExit()
-- globalUserPanel[4]:onUserExit()
-- local card = new(Image, "ui/image.png")
-- 	card:addToRoot()
-- 	card:pos(display.cx, display.cy)
-- printInfo("size = %d, %d", card:getSize())
-- printInfo("real size = %d, %d", card:getRealSize())
-- printInfo("real size = %d", card.m_res:getWidth())
-- card:setSize(100, 100)
-- printInfo("size = %d, %d", card:getSize())
-- printInfo("real size = %d, %d", card:getRealSize())
-- printInfo("real size = %d", card.m_res:getWidth())

-- AnimManager:play(AnimationTag.ShaiZi, {
-- 		bankSeat = 1,
-- 	})
-- 	:pos(display.cx + 55, display.cy)

-- testRoomController:playZhuangAnimFor(SEAT_3)
	-- AnimManager:play(AnimationTag.AnimFade, {
	-- 	file = "room/game_start.png",
	-- 	pos = ccp(display.cx, display.cy),
	-- 	showBg = true,
	-- 	fadeTime = 300,
	-- 	fadeSize = 3,
	-- 	bgSize = 1.5,
	-- 	scaleTime = 200,
	-- 	delayTime = 200,
	-- })
-- G_RoomCfg:setObTime(10)
-- globalPlayer[1]:onObserverCardBd()

-- globalPlayer[1].m_gameData:setIsObing(0)
-- globalPlayer[1]:showTingStatus(1)
-- local TimerClock = require("room.entity.timerClock")
-- testRoomController.m_timer:play(1, 5, TimerClock.Operate)
-- testRoomController.m_timer:setSeatInfo(4)
-- G_RoomCfg:setCurQuan(2)
-- G_RoomCfg:setMySeat(1)
-- G_RoomCfg:setBankSeat(0)
-- G_RoomCfg:setEastSeat(0)
-- testRoomController:freshJuType()

-- testRoomController.m_timer:play(SEAT_1, G_RoomCfg:getOutTime(), TimerClock.OutCard)

	-- kMusicPlayer:stop(true);
	-- globalPlayer[2]:onAddCard(0, {0x58})
-- 	globalPlayer[4]:onAddCard(0, {0x58})
-- testRoomController:playZhuangAnimFor(4)
-- dump(MyLevelConfigData)
-- -- ExpressionAnim.play(seat,faceName, 1, imgCount, playTime, playCount, x, y)
-- globalPlayer[SEAT_1]:showChatWord("丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦")
-- globalPlayer[SEAT_2]:showChatWord("丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦")
-- globalPlayer[SEAT_3]:showChatWord("丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦")
-- globalPlayer[SEAT_4]:showChatWord("丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦丧失地方圣达菲撒旦")

-- local opValue = bit.bor(kOpeHu, 0)
-- opValue = bit.bor(opValue, kOpeZiMo)
-- printInfo(string.format("0x%04x", opValue))
-- opValue = bit.bxor(0, kOpeZiMo)
-- printInfo(string.format("0x%04x", opValue))


-- GameSocketMgr:sendMsg(Command.PAY_RECOMEND_PHP_REQUEST, {})

-- WindowManager:showWindow(WindowTag.RechargePopu, {
	-- chargeType = ChargeType.BrokeCharge,
	-- goodsInfo = MyPayData:get(1),
-- })

-- AlarmNotice.play("1111111111111")
-- GameSocketMgr:sendMsg(Command.ChangeDeskReq, {
-- 	iChangeType = 1,
-- })

-- if not testCard then
--  	testCard = UIFactory.createImage("ui/button.png")
--  	testCard:addToRoot()
--  	testCard:pos(display.cx, display.cy)
--  else
--  testCard:removeProp(101)
-- end
-- -- 
-- 	testCard:addPropTranslateWithEasing(101, kAnimNormal, 300, 0, "easeOutBounce", "easeOutBounce", -100, 100, -100, 100)

-- local anim = testCard:addPropTranslateWithEasing(101, kAnimNormal, 300, 0, nil, "easeOutBounce", 0, 0, 100, 100)
