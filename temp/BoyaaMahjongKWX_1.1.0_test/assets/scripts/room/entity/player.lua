local UserPanel = import(".userPanel")
local CardPanel = import(".cardPanel")
local OperatePanel = import(".operatePanel")
local GameData = require("room.entity.gameData")
local UserData = require("data.userData")
local RoomCoord = require("room.coord.roomCoord")
local CardPanelCoord = require("room.coord.cardPanelCoord")
local FaceConfig = require("room.chat.faceConfig")
local AnimFace = require("animation.animFace")
local Player = class(Node)
local printInfo, printError = overridePrint("Player")
local TingTipView = import(".tingTipView")
local operatePanel = require(ViewPath .. "operatePanel")
local AnimChat = require("animation/animChat")
require("motion/EaseMotion")

addProperty(Player, "isMyTurn", false)

function Player:ctor(seat)
	self.m_seat = seat
	self:setFillParent(true, true)
	self.m_gameData = setProxy(new(GameData))
	if self.m_seat == SEAT_1 then
		self.m_userData = MyUserData
	else
		self.m_userData = setProxy(new(UserData))
	end
	globalPlayer = globalPlayer or {}
	globalPlayer[seat] = self
	self:initPanel()
end

function Player:dtor()
	delete(self.showReadyTimeAnim)
	self.showReadyTimeAnim = nil
end

function Player:initPanel()
	self:_initUserPanel()
	self:_initCardPanel()
	self:_initReadyPanel()
end

function Player:_initUserPanel()
	if not self.m_userPanel then
		local userPanelCls = GameUserPanelMap[G_RoomCfg:getGameType()]
		self.m_userPanel = new(require(userPanelCls), self.m_seat, self.m_userData, self.m_gameData)
			:addTo(self, RoomCoord.UserPanelLayer[self.m_seat])
	else
		self.m_userPanel:initView(self.m_userData)
	end
end

function Player:_initCardPanel()
	if not self.m_cardPanel then
		local cardPanelCls = GameCardPanelMap[G_RoomCfg:getGameType()]
		self.m_cardPanel = new(require(cardPanelCls), self.m_seat, self.m_userData, self.m_gameData)
			:addTo(self, RoomCoord.CardPanelLayer[self.m_seat])
	else
		self.m_cardPanel:initView(self.m_userData)
	end
end

function Player:showReadyView(flag)
	if self.m_readyView then
		self.m_readyView:setVisible(flag)
	end
end

function Player:_initReadyPanel()
	local pos = RoomCoord.ReadyViewPos[self.m_seat]
	self.m_readyView = new(Node)
		:addTo(self, RoomCoord.ReadyLayer)
		:pos(pos.x, pos.y)
		:hide()

	if self.m_seat == SEAT_1 then
		self.m_readyBtn = UIFactory.createButton("kwx_common/btn_red_big.png")
			:addTo(self.m_readyView)
			:align(kAlignLeft, 15, 0)
			:hide()

		-- self.m_readyBtn:setSize(200, 80)

		self.m_readyBtn:setOnClick(nil, function()
			local levelConfig, suggestConfig = app:findChangeRoomConfig()
			-- 点击准备按钮的时候 只有在金币大于该场次上限的时候才触发升降场换桌
			if levelConfig and suggestConfig and (suggestConfig:getRequire() > levelConfig:getRequire()
				and MyUserData:getMoney() > levelConfig:getUppermost()) then
				app:requestChangeDesk(ChangeDeskType.Up)
			else --不需要升降场的准备都在这里面去判断
				self:requestReady()
			end
		end)

		self.m_readText = UIFactory.createText({
				text = "准 备",
				size = 36,
				align = kAlignCenter,
			})
			:addTo(self.m_readyBtn)
			:align(kAlignCenter, 0, -2)

		self.m_changeBtn = UIFactory.createButton("kwx_common/btn_blue_big.png")
			:addTo(self.m_readyView)
			:align(kAlignRight, 15, 0)
			:hide()

		-- self.m_changeBtn:setSize(200, 80)

		self.m_changeBtn:setOnClick(nil, function()
			app:requestChangeDesk()
		end)

		self.m_changeText = UIFactory.createText({
				text = "换 桌",
				size = 36,
				align = kAlignCenter,
			})
			:addTo(self.m_changeBtn)
			:align(kAlignCenter, 0, -2)

		UIEx.bind(self.m_readyView, self.m_userData, "money", function(value)
			local levelConfig, suggestConfig = app:findChangeRoomConfig()
			-- 升场
			if levelConfig and suggestConfig and suggestConfig:getRequire() > levelConfig:getRequire() then
				self.m_changeText:setText("去高倍场")
			else
				self.m_changeText:setText("换 桌")
			end
		end)
		UIEx.bind(self.m_readyView, G_RoomCfg, "level", function(value)
			local levelConfig, suggestConfig = app:findChangeRoomConfig()
			-- 升场
			if levelConfig and suggestConfig and suggestConfig:getRequire() > levelConfig:getRequire() then
				self.m_changeText:setText("去高倍场")
			else
				self.m_changeText:setText("换 桌")
			end
		end)
	end
	UIEx.bind(self.m_readyView, self.m_gameData, "isReady", function(value)
		self.m_readyImage:setVisible(value == 1)
		-- 动画
		if value == 1 then
			AnimManager:play(AnimationTag.AnimFade, {
				node = self.m_readyImage,
				fadeSize = 3.0,
				fadeTime = 200,
			})
			delete(self.showReadyTimeAnim)
			self.showReadyTimeAnim = nil
		end
		if self.m_readyBtn and self.m_changeBtn then
			self.m_readyBtn:setVisible(value == 0)
			self.m_changeBtn:setVisible(value == 0)
		end
	end)
	UIEx.bind(self.m_readyView, G_RoomCfg, "isPlaying", function(value)
		self.m_readyView:setVisible(not value)
		local isReady = self.m_gameData:getIsReady()
		self.m_readyImage:setVisible(isReady == 1)
		if self.m_readyBtn and self.m_changeBtn then
			self.m_readyBtn:setVisible(isReady == 0)
			self.m_changeBtn:setVisible(isReady == 0)
		end
	end)
	
	self.m_readyImage = UIFactory.createImage("kwx_room/ok.png")
		:addTo(self.m_readyView)
		:align(kAlignCenter)
end

function Player:onTouch(finger_action, x, y, drawing_id_first, drawing_id_current)
	if self.m_seat == SEAT_1  then
		return self.m_cardPanel:onTouch(finger_action, x, y, drawing_id_first, drawing_id_current)
	end
end

function Player:initPlayerInfo(playerInfo)
	self.m_userData:initPlayerInfo(playerInfo, G_RoomCfg:getIsCompart())
end

function Player:clearTableForGame()
	self.m_gameData:resetForReady()
	self.m_cardPanel:clearTableForGame()
	self.m_userPanel:clearTableForGame()
end

-------------------[[ 玩牌业务 ]] ------------------

function Player:onEnterRoom(isReady)
	-- 协议里面没有自己的准备状态 不设置避免显示出准备按钮
	if self.m_seat ~= SEAT_1 then
		self.m_gameData:setIsReady(isReady)
	end
	self.m_gameData:setIsPlaying(0)
	self.m_gameData:setIsExist(1)
	self.m_userPanel:onEnterRoom()
end

-- 显示选漂的数据
function Player:showSelectPiao(info)
	self.m_userPanel:showSelectPiaoInfo(info)
	GuideManager:showGuideSelectPiao(false)
end

function Player:onUserExit()
	self.m_gameData:setIsReady(0)
	self.m_gameData:setIsPlaying(0)
	self.m_gameData:setIsExist(0)
	self.m_userPanel:onUserExit()
end

function Player:onUserReady()
	self.m_gameData:setIsExist(1)
	self.m_gameData:setIsReady(1)
end

--扣除台费
function Player:onGameReadyStart(isBank)
	if 1 ~= G_RoomCfg:getIsCompart() then
		self.m_userData:addMoney(-G_RoomCfg:getTai())
	end
	self.m_gameData:setIsPlaying(1)
	self.m_gameData:setIsBank(isBank)
	self.m_userPanel:onGameReadyStart(isBank)
end

function Player:isBank()
	return self.m_isBank
end

function Player:onDealCardBd(handCards, buhuaCards)
	self.m_gameData:setIsPlaying(1)
	self.m_cardPanel:onDealCardBd(handCards, buhuaCards)
end

function Player:onDealCardStep(startIndex, endIndex)
	printInfo("玩家%d发牌，从%d到%d", self.m_seat, startIndex, endIndex)
	self.m_cardPanel:onDealCardStep(startIndex, endIndex)
end

function Player:onDealCardOver(isNormal)
	self.m_cardPanel:onDealCardOver(isNormal)
end

function Player:playZhuangAnim()

end

function Player:onGameStartBd(data)
	self.m_gameData:setIsPlaying(1)
	self.m_cardPanel:onGameStartBd(data)
end

function Player:onSwapCardStartBd(data)
	self.m_gameData:setIsHuaning(1)
	self:_showHuanCardPanel()
	self.m_cardPanel:onSwapCardStartBd(data.iHuanCards)
end

function Player:onSwapCardRsp(handCards, exchangeCards)
	self.m_gameData:setIsHuaning(0)
	self.m_cardPanel:onSwapCardRsp(handCards, exchangeCards)
end

function Player:getUserData()
	return self.m_userData
end

function Player:getGameData()
	return self.m_gameData
end

function Player:getRoom()
	return self:getParent()
end

-- 重连后重绘麻将子
function Player:reconnTable(handCards, otherCards, isLiang, catchCard)
	isLiang = isLiang or 0
	dump(handCards)
	self.m_gameData:setIsTing(isLiang or 0)
	-- self.m_userData:addMoney(-G_RoomCfg:getTai()) -- 由server处理 事先扣掉台费
	self.m_userPanel:showUserGameView()
	
	self.m_gameData:setIsPlaying(1)
	self.m_gameData:setIsReady(1)
	self.m_gameData:setIsMyTurn(#handCards % 3 == 2)
	self.m_gameData:setHuaNum(#otherCards.iHuaCardTb)
	-- 庄家
	local localBankSeat = G_RoomCfg:getLocalBankSeat()
	self.m_gameData:setIsBank(localBankSeat == self.m_seat and 1 or 0)
	self.m_cardPanel:reDrawExtraCards(otherCards.iExtraCardsTb)
	local handCardInfo = {}
	for k, v in pairs(handCards) do
		handCardInfo[#handCardInfo + 1] = v.iCard
	end
	if 1 == self.m_gameData:getIsTing() then
		printInfo("绘制的是亮倒后的牌 %d",self.m_seat)
		-- 先去掉抓牌
		if catchCard then
			for k, v in pairs(handCards) do
				if v.iCard == catchCard and v.iType == 1 then
					table.remove(handCards, k)
					break
				end
			end
		end
		-- 排序，將不亮的牌放到前面
		for i = 1, #handCards do
			for j = i + 1,#handCards do
				if handCards[i].iType == handCards[j].iType then
					if handCards[i].iCard > handCards[j].iCard then
						local t = handCards[i]
						handCards[i] = handCards[j]
						handCards[j] = t
					end
				else
					if 0 == handCards[j].iType then
						local t = handCards[i]
						handCards[i] = handCards[j]
						handCards[j] = t
					end
				end
			end
		end
		self:reDrawHandCardsLiang(handCards)
		if catchCard then self:onAddCard(catchCard, {}) end
		self:showTingStatus(isLiang, true)
	else
		self.m_cardPanel:reDrawHandCards(handCardInfo)
	end
	self.m_cardPanel:reDrawOutCards(otherCards.iOutCardTb)
	self.m_cardPanel:enableSelect(true)
end

--iCard iOpInfo iHuaCards
function Player:onAddCard(iCard, iHuaCards)
	-- 换牌异常处理
	if self.m_gameData:getIsHuaning() == 1 then
		self.m_gameData:setIsHuaning(0)
		local handCards = self.m_cardPanel:getHandCards()
		table.sort(handCards)
		self.m_cardPanel:reDrawHandCards(handCards)
	end
	G_RoomCfg:reduceRemainNum(#iHuaCards + 1)
	self.m_cardPanel:onAddCard(iCard, iHuaCards)
	self.m_cardPanel:enableSelect(true)
end

function Player:dealOpAfterAddCard(iCard, iOpInfo)
	if self.m_seat ~= SEAT_1 then return end

	self:showOperatePanel(iCard, iOpInfo)
	self.m_gameData:setIsMyTurn(1)
end

function Player:onOutCard(iCard, iIsTing, iIsAi)
	self.m_gameData:setIsMyTurn(0)
	self.m_cardPanel:onOutCard(iCard)
	self:freshUserTingInfo(iCard, iIsTing)
	self:freshUserAiInfo(iIsAi)
end

function Player:dealOpAfterOtherOutCard(iCard, iOpInfo)
	if self.m_seat ~= SEAT_1 then return end

	self:showOperatePanel(iCard, iOpInfo)
end

function Player:getOperateAnim()
	return self.operateAnim
end

-- 操作
function Player:onOperateCard(iCard, iOpInfo)
	local iOpValue = iOpInfo.iOpValue
	local extraTb = self.m_cardPanel:onOperateCard(iCard, iOpValue)

	local opAnimPos = RoomCoord.OpAnimPos[self.m_seat]
	if self.operateAnim then
		self.operateAnim:release()
		self.operateAnim = nil
	end
	self.operateAnim = AnimManager:play(AnimationTag.Operate, {
		cardValue = iCard,
		cards = extraTb,
		opValue = iOpValue,
		pos = opAnimPos,
		onComplete = function()
			self.operateAnim = nil
		end
	})
	local priority = self:getOpPriority(iOpValue)
	if priority == kPriorityChi or priority == kPriorityPeng then
		self.m_gameData:setIsMyTurn(1)
	else
		self.m_gameData:setIsMyTurn(0)
	end
	self.m_cardPanel:enableSelect(true)
end

-- 操作后显示听牌等信息
function Player:dealOpAfterOwnOperate(iCard, iOpInfo)
	-- self.m_cardPanel:freshTingInfo(iOpInfo.iTingInfos)
	if bit.band(iOpInfo.iOpValue, kOpeTing) > 0 and self.m_gameData:getIsTing() ~= 1 then
		printInfo("可以听牌哦 0x%04x", iOpInfo.iOpValue)
		self:showOperatePanel(iCard, {
			iOpValue = kOpeTing,
			iAnCards = {},
			iBuCards = {},
			iCanTing = 0,
			iLiangInfo = iOpInfo.iLiangInfo,
			iFanLeast = iOpInfo.iFanLeast,
		})
	end
end

function Player:switchBuGangToPeng(iCard)
	self.m_cardPanel:switchBuGangToPeng(iCard)
end

-- 显示别人操作后我的操作 用于抢杠胡
function Player:onQiangGangHuBd(iCard, iOpInfo)
	self:showOperatePanel(iCard, iOpInfo)
end

function Player:freshUserTingInfo(iCard, iIsTing, isReconn)
	if self.m_seat == SEAT_1 then
		--更新听牌信息
		local tingInfos = self.m_gameData:getTingInfos()
		self.m_gameData:setCurTingInfo(tingInfos and tingInfos[iCard])
	end
	-- 避免重复触发
	if iIsTing ~= self.m_gameData:getIsTing() and self.m_gameData:getIsTing() ~= 1 then
		self.m_gameData:setIsTing(iIsTing)
		self:showTingStatus(iIsTing, isReconn)
		local curTingInfo = self.m_gameData:getCurTingInfo()
		if curTingInfo then
			self:showTingTipView(curTingInfo, true)
		else
			self:hideTingTipView()
		end
	end
end

function Player:freshUserAiInfo(iIsAi)
	if self.m_gameData:getIsAi() ~= iIsAi then
		self.m_gameData:setIsAi(iIsAi)
		if self.m_seat == SEAT_1 then
			self:showAiStatus(iIsAi == 1)
			self.m_cardPanel:enableSelect(iIsAi == 0)
		end
	-- 如果是我自己 则根据是否托管隐藏或显示ai
	elseif self.m_seat == SEAT_1 then
		if iIsAi == 1 then
			if self.m_aiNode then
				self.m_aiNode:forceShow()
			else
				self:showAiStatus(true)
			end
		end
		self.m_cardPanel:enableSelect(iIsAi == 0)
	end
end

function Player:showCardUpTip(value)
	self.m_cardPanel:showCardUpTip(value)
end

function Player:showTingStatus(iIsTing, isReconn)
	if not self.m_tingNode then
		local pos = CardPanelCoord.TingIconPos[self.m_seat]
		self.m_tingNode = new(Node)
			:addTo(self, RoomCoord.AiLayer)
			:pos(pos.x, pos.y)

		local tingIcon = "animation/roomAnim/ming.png"
		self.m_tingIcon = UIFactory.createImage(tingIcon)
			:addTo(self.m_tingNode)
			:align(kAlignCenter)
			:setScale(0.45, 0.45)

		if self.m_seat == SEAT_1 then
			self.m_tingIcon:setEventTouch(self, self.onTingTouch);
			self.m_tingIcon:pos(0, 20)
		end

		UIEx.bind(self.m_tingNode, self.m_gameData, "isTing", function(value)
			self.m_tingNode:setVisible(value == 1)
		end)
	end
	-- 重连状态下不播放动画和音效了
	if not isReconn then
		-- 播放听牌动画
		local opAnimPos = RoomCoord.OpAnimPos[self.m_seat]
		AnimManager:play(AnimationTag.Operate, {
			cardValue = 0,
			cards = {},
			opValue = kOpeTing,
			pos = opAnimPos,
		})

		kEffectPlayer:play(Effects.AudioTing)
		checkAndRemoveOneProp(self.m_tingIcon, 1)
		local anim = self.m_tingIcon:addPropScaleEase(1, kAnimNormal, ResDoubleArrayBounceOut, 700, 0, 2.5, 1, 2.5, 1, kCenterDrawing);
		if anim then
			anim:setEvent(nil, function()
				self.m_tingIcon:removeProp(1)
			end)
		end
	end
	self.m_tingNode:setVisible(iIsTing == 1)
end

function Player:getIsInGamePos()
	return self.m_userPanel:getIsInGamePos()
end

-- 聊天相关
function Player:showChatWord(chatInfo)
	if not self.m_chatWord then
		self.m_chatWord = new(Node)
			:addTo(self, RoomCoord.AnimLayer)
	end
	self.m_chatWord:removeAllChildren()
	local x, y = self.m_userPanel:getFaceAnimPos()
	if not x or not y then return end

	local params = {
		seat = self.m_seat,
		chatInfo = chatInfo,
		pos = ccp(x, y),
		isGame = self:getIsInGamePos(),
	}
	new(AnimChat):addTo(self.m_chatWord, RoomCoord.AnimLayer)
		:play(params)

	playChatSound(chatInfo, self.m_userData:getSex())
end

function Player:showChatFace(faceIndex)
	if not self.m_chatFace then
		self.m_chatFace = new(Node)
			:addTo(self, RoomCoord.AnimLayer)
	end
	self.m_chatFace:removeAllChildren()
	
	local x, y = self.m_userPanel:getFaceAnimPos()
	if not x or not y then return end

	local faceName = nil;

	local facePrefix = FaceConfig[1].expNamePrefix
	local img = FaceConfig[1].expressInfo .. faceIndex .. "0%02d.png"

	if type(facePrefix) == "table" then
		faceName = facePrefix[img]
	elseif type(facePrefix) == "string" then
		faceName = img
	end
	local imgCount = FaceConfig[1][faceIndex].imgCount
	local playCount = FaceConfig[1][faceIndex].playCount
	local playTime = FaceConfig[1][faceIndex].ms

	printInfo("玩家%d发送了表情%d", self.m_seat, faceIndex)
	local params = {
		num = imgCount,
		playCount = playCount,
		faceName = faceName,
		duration = playTime,
		pos = ccp(x, y),
	}
	new(AnimFace):addTo(self.m_chatFace, RoomCoord.AnimLayer)
		:play(params)
end

function Player:sendPropToPlayer(propId, targetPlayer)
	local x, y = self:getPropAnimPos()
	local x2, y2 = targetPlayer:getPropAnimPos()
	if not x or not y then return end
	if not x2 or not y2 then return end

	if PropConfig[propId] then
		local propAnim = new(require(PropConfig[propId]), ccp(x, y), ccp(x2, y2), self.m_seat, targetPlayer.m_seat)
		self:addChild(propAnim);
		propAnim:play();
	end
end

function Player:getAnimCoinFlyPos()
	return self.m_userPanel:getAnimCoinFlyPos()
end

function Player:getPropAnimPos()
	return self.m_userPanel:getPropAnimPos()
end

function Player:onTingTouch(finger_action)
	if finger_action == kFingerDown then
		if self.m_tingTipView and self.m_tingTipView:getVisible() then
			self:hideTingTipView()
		else
			local curTingInfo = self.m_gameData:getCurTingInfo()
			if curTingInfo then
				self:showTingTipView(curTingInfo)
			else
				self:hideTingTipView()
			end
		end
	end
end

function Player:getOpPriority(operateValue)
	if bit.band(operateValue, kOpeHu) > 0 or
		bit.band(operateValue, kOpeZiMo) > 0 then -- 支持一炮多响
		return kPriorityHu
	elseif bit.band(operateValue, kOpePengGang) > 0 or 
		bit.band(operateValue, kOpeAnGang) > 0 or 
		bit.band(operateValue, kOpeBuGang) > 0 then
		return kPriorityGang
	elseif bit.band(operateValue, kOpePeng) > 0 then
		return kPriorityPeng
	elseif bit.band(operateValue, kOpeLeftChi) > 0 or 
		bit.band(operateValue, kOpeMiddleChi) > 0 or 
		bit.band(operateValue, kOpeRightChi) > 0 then
		return kPriorityChi
	else
		return kPriorityNone
	end
end

-- 获得庄家位置
function Player:getZhuangPos()
	return self.m_userPanel:getZhuangPos()
end

function Player:onSelectTing()
	self:getRoom():onSelectTing()
	self.m_cardPanel:onSelectTing()
end

function Player:onSelectLiang(data)
	self:getRoom():onSelectLiang(data)
	self.m_cardPanel:onSelectLiang(data)
end

function Player:onSelectLiangOutCard()
	printInfo("sdsdskdkancv onSelectLiangOutCard")
	if self.m_operatePanel then
		printInfo("sdsdskdkancv sdsdsdsd")
		self.m_operatePanel:showViewLiang(true, 2)
	end
	self.m_cardPanel:onSelectLiangOutCard()
end

function Player:onUserAi(iIsAi)
	self:freshUserAiInfo(iIsAi)
end

function Player:onServerShowReadyTime( data )
	if not self.m_readText then
		return
	end
	self.timeCount = data.iTime or 10
	delete(self.showReadyTimeAnim)
	self.showReadyTimeAnim = nil
	self.showReadyTimeAnim = new(AnimInt, kAnimRepeat, 0, 1, 1000, 0)
	self.showReadyTimeAnim:setEvent(self, function( self )
		if self.timeCount < 0 then
			delete(self.showReadyTimeAnim)
			self.showReadyTimeAnim = nil
			self.timeCount = 0
		end
		self.m_readText:setText("准备 "..self.timeCount)
		self.timeCount = self.timeCount - 1
	end)
end

function Player:requestAi(aiType)
	if self.m_seat ~= SEAT_1 then return end
	
	GameSocketMgr:sendMsg(Command.RequestAi, {
		iAiType = aiType,
	})
	self:showAiStatus(aiType == 1)
	self.m_cardPanel:enableSelect(true)
end

function Player:showAiStatus(isAi)
	if self.m_seat ~= SEAT_1 then return end
	
	local pos = RoomCoord.AiBtnPos[self.m_seat]
	if not self.m_aiNode then
		self.m_aiNode = new(require("animation.animAi"))
			:addTo(self, RoomCoord.CardPanelLayer[self.m_seat] + 1)
			:pos(display.right, display.bottom)

		UIEx.bind(self.m_aiNode, self.m_gameData, "isPlaying", function(value)
			if value ~= 1 then
				self.m_aiNode:hide()
			end
		end)
	end
	self.m_aiNode:play(isAi)
end

function Player:onGameOver(data)
	self.m_gameData:onGameOver()
	-- self.m_userData:setMoney(data.iMoney)
	if 1 == G_RoomCfg:getIsCompart() then self.m_userData:setScore(data.iMoney)
	else self.m_userData:setMoney(data.iMoney)	end
	-- self.m_userData:setExp(data.iExp)
	self.m_userData:setLevel(data.iLevel)
	self.m_userData:freshZhanjiByTurnMoney(data.iHuType)
	self.m_cardPanel:onGameOver(data.iInhandCrads, data.iHuCard)
	local isLevelUp = data.iIsLevelUp or 0
	if 1 == isLevelUp and self.m_seat == SEAT_1 then
		local reward = data.iLevelReward or 0
		AlarmTip.play("恭喜您升级获得"..reward.."金币")
		self.m_userData:addMoney(0, true)
		self:getRoom():playLevelUpAnim()
	end
end

function Player:reDrawExtraHandCards(cards)
	self.m_cardPanel:reDrawExtraHandCards(cards)
end

function Player:reDrawHandCardsLiang(handCards)
	-- 排序，將不亮的牌放到前面
	for i = 1, #handCards do
		for j = i + 1,#handCards do
			if handCards[i].iType == handCards[j].iType then
				if handCards[i].iCard > handCards[j].iCard then
					local t = handCards[i]
					handCards[i] = handCards[j]
					handCards[j] = t
				end
			else
				if 0 == handCards[j].iType then
					local t = handCards[i]
					handCards[i] = handCards[j]
					handCards[j] = t
				end
			end
		end
	end
	self.m_cardPanel:reDrawHandCardsLiang(handCards)
end

function Player:drawHuCardsLiang(huCards)
	-- 胡牌显示
	self.m_cardPanel:drawHuCardsLiang(huCards)
end

-- 座位号  操作的牌  操作值
function Player:reduceOperateCardForTingInfo(seatId, card, opValue)
	--只有自己才需要维护听牌信息
	if self.m_seat ~= SEAT_1 then return end
	--吃
	-- 根据吃碰杠来更新自己的信息
	if bit.band(opValue, kOpeLeftChi) > 0 then
		self:reduceCardForTingInfo(card+1, 1, true)
		self:reduceCardForTingInfo(card+2, 1)
	elseif bit.band(opValue, kOpeMiddleChi) > 0 then
		self:reduceCardForTingInfo(card-1, 1, true)
		self:reduceCardForTingInfo(card+1, 1)
	elseif bit.band(opValue, kOpeRightChi) > 0 then
		self:reduceCardForTingInfo(card-1, 1, true)  --不更新界面
		self:reduceCardForTingInfo(card-2, 1)
	--碰
	elseif bit.band(opValue, kOpePeng) > 0 then
		self:reduceCardForTingInfo(card, 2)
	--杠
	elseif bit.band(opValue, kOpeBuGang) > 0 then
		self:reduceCardForTingInfo(card, 1)
	elseif bit.band(opValue, kOpePengGang) > 0 then
		self:reduceCardForTingInfo(card, 3)
	end
end

-- @avoidFresh 只更新数据，不更新显示
function Player:reduceCardForTingInfo(card, num, avoidFresh)
	--只有自己才需要维护听牌信息
	if self.m_seat ~= SEAT_1 then return end
	num = num or 1
	if self.m_gameData:getIsTing() == 1 then
		local curTingInfo = self.m_gameData:getCurTingInfo()
		if curTingInfo then
			for i,v in ipairs(curTingInfo) do
				if v.iHuCard == card then
					v.iRemainNum = v.iRemainNum - num
					if v.iRemainNum < 0 then v.iRemainNum = 0 end
				end
			end
			-- 如果正在显示听牌信息
			if self.m_tingTipView and self.m_tingTipView:getVisible() then
				self:showTingTipView(curTingInfo)
			end
		end
	end
end

function Player:showTingTipView(tingInfo, autoHide)
	if not self.m_tingTipView then
		self.m_tingTipView = new(TingTipView, tingInfo)
			:addTo(self, RoomCoord.TingLayer)
		UIEx.bind(self.m_tingTipView, self.m_gameData, "isTing", function(value)
			if value == 0 then self:hideTingTipView() end
		end)
	else
		self.m_tingTipView:show()
		self.m_tingTipView:freshTingView(tingInfo)
	end
	if autoHide then
		checkAndRemoveOneProp(self.m_tingTipView, 1001)
		local bgSize = self.m_tingTipView:getBgSize()
		local anim = self.m_tingTipView:addPropScale(1001, kAnimNormal, 500, 3000, 1, 0, 1, 0, kCenterXY, bgSize.width/2, 120)
		if anim then
			anim:setEvent(nil, function()
				self.m_tingTipView:hide()
				checkAndRemoveOneProp(self.m_tingTipView, 1001)
			end)
		end
	end
end

function Player:hideTingTipView()
	if self.m_tingTipView then
		self.m_tingTipView:hide()
	end
end

-- 玩家1
function Player:showOperatePanel(iCard, iOpInfo)
	if self.m_gameData:getIsAi() == 1 then 
		self:hideOperatePanel()
		self.m_cardPanel:enableSelect(false)
		return
	end
	local opBundle = checkOperateData(iOpInfo.iOpValue, iCard, iOpInfo.iAnCards, iOpInfo.iBuCards, iOpInfo.iLiangInfo);
	if opBundle.count > 0 then
		if not self.m_operatePanel then
			self.m_operatePanel = new(OperatePanel, operatePanel)
				:addTo(self, RoomCoord.OperateLayer)
		else
			self.m_operatePanel:setVisible(true)
		end
		self.m_operatePanel:showOperationBtns(opBundle, iCard)
		-- 如果只有听则可以出牌
		if opBundle.count == 1 and bit.band(iOpInfo.iOpValue, kOpeTing) > 0 then
			self.m_cardPanel:enableSelect(true)
		else
			self.m_cardPanel:enableSelect(false)
		end
	else
		self:hideOperatePanel()
		self.m_cardPanel:enableSelect(true)
	end
end

function Player:_showHuanCardPanel()
end

--牌被玩家操作后从出牌列表中去除
function Player:judgeRemoveOperateCard(iOpValue, iCard)
	return self.m_cardPanel:judgeRemoveOperateCard(iOpValue, iCard)
end

-- 通知操作面板隐藏
function Player:onOperateHidden()
	self.m_cardPanel:enableSelect(true)
end

function Player:hideOperatePanel()
	if self.m_operatePanel then
		self.m_operatePanel:setVisible(false)
	end
end

function Player:isPlaying()
	return self.m_gameData:getIsPlaying() == 1
end

function Player:isOperating()
	return self.m_operatePanel and self.m_operatePanel:getVisible()
end

function Player:getHandCards()
	return self.m_cardPanel:getHandCards()
end

function Player:setHandAndHuaCards(handCards, huaCards)
	self.m_cardPanel:setHandAndHuaCards(handCards, huaCards)
end

function Player:getExtraCards()
	return self.m_cardPanel:getExtraCards()
end

-- 请求
function Player:requestReady()
	self:getRoom():requestReady()
end

function Player:requestOutCard(cardValue, isLiang, noLiangCards)
	self:hideOperatePanel()
	if self.m_operatePanel then
		self.m_operatePanel:showViewLiang(false)
	end
	local data = {
		iCard = cardValue,
		iIsLiang = isLiang,
		iNoLiangCards = noLiangCards,
	}
	GameSocketMgr:sendMsg(Command.RequestOutCard, data)
end

function Player:requestHuan3Cards(cards)
	GameSocketMgr:sendMsg(Command.SwapCardReq, cards)
end

function Player:onTimerClockOver()
	self:hideOperatePanel()
	-- 选择听牌的时候取消
	if self.m_gameData:getIsSelectTing() == 1 then
		self:hideTingTipView()
	end
	self.m_cardPanel:cancelTing()
	self.m_cardPanel:enableSelect(true)
	self.m_cardPanel:clearLiang()
end

function Player:onCancelOperate()
	-- 选择听牌的时候取消
	if self.m_gameData:getIsSelectTing() == 1 then
		self:hideTingTipView()
	end
	self.m_cardPanel:cancelTing()
	self.m_cardPanel:enableSelect(true)
	self:getRoom():onCancelOperate()
end

-- 更新用户金币
function Player:onFreshMoneyRsp(data)
	self.m_userData:setExp(data.iExp)
        :setLevel(data.iLevel)
        :setZhanji(data.iWintimes, data.iLosetimes, data.iDrawtimes)

	if 1 == G_RoomCfg:getIsCompart() then self.m_userData:setScore(data.iMoney)
	else self.m_userData:setMoney(data.iMoney)	end        
end

function Player:requestTakeOperate(opValue, cardValue)
	local data = {
		iOpValue = opValue,
		iCard = cardValue,
	}
	if opValue == kOpeCancel then
		self:onCancelOperate()
	end
	GameSocketMgr:sendMsg(Command.RequestOperate, data)
end

return Player