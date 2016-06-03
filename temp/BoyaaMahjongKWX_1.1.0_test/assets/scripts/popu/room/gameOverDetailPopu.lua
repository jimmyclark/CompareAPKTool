
local GameOverDetailPopu = class(require("popu.gameWindow"))

local printInfo, printError = overridePrint("GameOverDetailPopu")

function GameOverDetailPopu:ctor()
	printInfo("GameOverDetailPopu:ctor")
	-- EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
    GameSetting:setIsSecondScene(false)
end

function GameOverDetailPopu:dtor()
	-- EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
end

function GameOverDetailPopu:initView(data)
	data = data or {}
	self.img_info_1 = self:findChildByName("img_info_1")
	self.img_info_2 = self:findChildByName("img_info_2")
	self.img_info_3 = self:findChildByName("img_info_3")

	self.imgInfoTable = {}
	table.insert(self.imgInfoTable, self.img_info_1)
	table.insert(self.imgInfoTable, self.img_info_2)
	table.insert(self.imgInfoTable, self.img_info_3)

	self.m_iDiZhu = data.iDiZhu

	local titlePrefix = "kwx_room/room_gameOver/detail/"
	local titleFile = titlePrefix.."img_win.png"
	local huType = data.iHuType
	if 0 == huType then
		titleFile = titlePrefix.."img_ping.png"
	elseif 1 == huType then
		titleFile = titlePrefix.."img_lost.png"
	elseif 2 == huType then
		titleFile = titlePrefix.."img_win.png"
	end
	self:findChildByName("img_title"):setFile(titleFile)

	self:setGameDetailInfo(data.iPlayerInfo or {})

	self:findChildByName("btn_close"):setOnClick(self, function(self)
		if 1 == G_RoomCfg:getIsCompart() and 1 == data.iIsPrivate then
			self:dismiss()
			self:showAccountWindow(data)
				
		else
			self:dismiss()
		end
	end)

	local btn_again = self:findChildByName("btn_again")
	local btn_change = self:findChildByName("btn_change")
	local btn_continue = self:findChildByName("btn_continue")

	if 1 == G_RoomCfg:getIsCompart() then
		btn_again:hide()
		btn_change:hide()
		btn_continue:show()
		btn_continue:setOnClick(self, function( self )
			-- 包间中继续
			if 1 == data.iIsPrivate then
				self:dismiss()
				self:showAccountWindow(data)
				
			else
				self:dismiss()
				EventDispatcher.getInstance():dispatch(Event.Message, "requestReady")
			end
		end)

	else
		local text_again = self:findChildByName("text_again")
		UIEx.bind(text_again, MyUserData, "money", function(value)
			-- 如果没有指定 则重新判断
			local levelConfig, suggestConfig = app:findChangeRoomConfig()
			-- 升场
			if levelConfig and suggestConfig and suggestConfig:getRequire() > levelConfig:getRequire() then
				text_again:setText("去高倍场")
	            btn_again:setOnClick(nil, handler(self, self.requestReady))
			else
				text_again:setText("再来一局")
	            btn_again:setOnClick(nil, handler(self, self.requestReady))
			end
		end)
		MyUserData:setMoney(MyUserData:getMoney())

		btn_change:setOnClick(self, self.onClickChangeBtn)
		
	end
end

function GameOverDetailPopu:showAccountWindow( data )
	local accountCfg = {}
	for k, info in pairs(data.iPrivateRoom.iPlayInfo) do
		local temp = {}
		temp.mid = info.iUserId
		temp.money = info.iScore
		temp.nick = info.iName
		temp.sex = info.iSex
		temp.headImg = info.iHeadImg
		temp.url = ""
		table.insert(accountCfg, temp)
	end				
	WindowManager:showWindow(WindowTag.accountsPopu, accountCfg)
end

function GameOverDetailPopu:onClickChangeBtn()
	app:requestChangeDesk()
	self:dismiss()
end

function GameOverDetailPopu:setGameDetailInfo(data)
	for i = 1, #data do
		local rootNode = self.imgInfoTable[i]
		if not rootNode then
			return
		end
		local img_headBg = rootNode:findChildByName("img_headBg")
		local fileName = data[i].iHeadImg
		local headImage = new(Mask, fileName, "kwx_room/room_gameOver/detail/img_mask.png");
		headImage:setSize(img_headBg:getSize());
		img_headBg:addChild(headImage);

		rootNode:findChildByName("text_name"):setText(ToolKit.formatNick(data[i].iName, 5))
		local money = data[i].iTurnMoney or 0
		if money >= 0 then money = "+"..money end
		rootNode:findChildByName("text_winmoney"):setText(money)

		local huType = data[i].iHuType
		local huStr = ""
		if 0 == huType then 
			huStr = "平"
		elseif 1 == huType then 
			huStr = "输"
		elseif 2 == huType then	
			huStr = "胡"
		end

		rootNode:findChildByName("text_hu"):setText(huStr)
		local text_huDetail = rootNode:findChildByName("text_huDetail")
		local fanXingStr = ""
		for j = 1, #data[i].iFanTable do
			fanXingStr = fanXingStr.."  "..data[i].iFanTable[j].iFanName
		end
		text_huDetail:setText(fanXingStr)
		local textW, textH = text_huDetail:getSize()
		printInfo("setGameDetailInfo textW : %d , textH : %d", textW, textH)
		if textW > 450 then
			text_huDetail:setClip(440, 15, 450, textH)
			local animTime = (textW - 450) * 20
			if animTime < 200 then animTime = 200 end
			text_huDetail:addPropTranslate(1, kAnimLoop, animTime, 0, 0, -(textW - 450), 0, 0)
		end
		local money = data[i].iGangMoney
		if money >= 0 then money = "+"..money end
		rootNode:findChildByName("text_beishu"):setText(string.format("总倍数x%s倍",data[i].iTotalFan))
		local mingMoney = data[i].iMingMoney
		if mingMoney ~= 0 then
			if mingMoney >= 0 then mingMoney = "+"..mingMoney end
			rootNode:findChildByName("text_gang"):setText(string.format("杠%s  亮%s", money, mingMoney))
		else
			rootNode:findChildByName("text_gang"):setText(string.format("杠%s", money))
		end
		
		if data[i].iIsPiao > 0 then
			local money = data[i].iPiaoTurnMoney
			if data[i].iPiaoTurnMoney >= 0 then money = "+"..money end
			rootNode:findChildByName("text_piao"):setText("漂"..money)
		end
		if data[i].iMoney < MyBaseInfoData:getBrokenMoney() and 0 == G_RoomCfg:getIsCompart() then
			UIFactory.createImage("kwx_room/room_gameOver/detail/img_bank.png")
				:addTo(rootNode)
				:align(kAlignRight)
		end
	end
end

function GameOverDetailPopu:requestReady()
	self.m_requestFlag = true
	self:dismiss(true)
	-- 如果发现场次有变化 且满足升场 则请求升场
	-- 否则还是走准备流程
	local levelConfig, suggestConfig = app:findChangeRoomConfig()
	if levelConfig and suggestConfig and (suggestConfig:getRequire() > levelConfig:getRequire()
		and MyUserData:getMoney() >= suggestConfig:getRequire()) then
		app:requestChangeDesk(ChangeDeskType.Up)
	else --降场和准备都在这里面去判断
		EventDispatcher.getInstance():dispatch(Event.Message, "requestReady")
	end
end

return GameOverDetailPopu
