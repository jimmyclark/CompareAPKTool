
local GameOverLosePopu = class(require("popu.gameWindow"))

function GameOverLosePopu:ctor()
end

function GameOverLosePopu:dtor()
end

function GameOverLosePopu:initView(data)
	-- if not result then return end
	dump(result)
	self.m_gameData = data

	local btn_detail = self.m_root:findChildByName("btn_detail")
    btn_detail:setOnClick(self, self.onClickDeatailBtn)
    btn_detail:hide()
    local btn_again = self.m_root:findChildByName("btn_again")
	-- 根据现在的钱判断是否升场 或者 降场
	local text_again = self.m_root:findChildByName("text_again")
	btn_again:hide()
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

    local money = 0
	for k, playerInfo in pairs(data.iPlayerInfo) do
		if playerInfo.iUserId == MyUserData:getId() then
			money = playerInfo.iTurnMoney
			break
		end
	end
    local view_coin = self:findChildByName("view_coin")
    local filePre1 = "kwx_room/room_gameOver/number"
	local filePre2 = "kwx_room/room_gameOver/lost/number"
	
	local numberTable;
	local moneyPre = ""
	if money >= 0 then
		moneyPre = "+"
		numberTable = filePre1
	else
		numberTable = filePre2
	end
	local LobbyCoinNode			= require("lobby/ui/lobbyCoinNode")
	local moneyNode = new(LobbyCoinNode, numberTable)
	moneyNode:setNumber(moneyPre..ToolKit.formatThreeNumber(money))
	view_coin:addChild(moneyNode)
	moneyNode:setAlign(kAlignCenter)
	moneyNode:hide()
	-- moneyNode:addPropTransparency(0, kAnimNormal, 700, -1, 0.7, 1.0)
	-- moneyNode:addPropTranslate(1, kAnimNormal, 700, -1, 0, 0, 200, 0)
	local viewNode = self:findChildByName("view_lose")
	local sAnim = viewNode:addPropScale(0, kAnimNormal, 700, -1, 0.0, 1.0, 0.0, 1.0, kCenterDrawing)
	viewNode:addPropTransparency(1, kAnimNormal, 700, -1, 0.5, 1.0)
	sAnim:setEvent(self, function(self)
		viewNode:removeProp(0)
		viewNode:removeProp(1)
		btn_detail:show()
		btn_again:show()
		moneyNode:show()
		--moneyNode:addPropTransparency(0, kAnimNormal, 700, -1, 0.7, 1.0)
		--moneyNode:addPropTranslate(1, kAnimNormal, 700, -1, 0, 0, 200, 0)
	end)
	
	self:findChildByName("btn_back"):setOnClick(self, function()
		-- body
		self:dismiss()
	end)

	--结算金币滚动
    self.showMoney = 0
	self.timerAnim = moneyNode:schedule(function()
	
		local interval = money / 100
		self.showMoney = self.showMoney + interval

		if ( 0 < money and money < self.showMoney ) or (0 > money and money >self.showMoney) or money == 0 then
			self.showMoney = money
			moneyNode:setNumber(moneyPre..ToolKit.formatThreeNumber(math.ceil(self.showMoney)))
			moneyNode:stopAllActions()
			return;
		end

		moneyNode:setNumber(moneyPre..ToolKit.formatThreeNumber(math.ceil(self.showMoney)))

	end, 10)
end

function GameOverLosePopu:onClickDeatailBtn()
	self.m_closeFlag = true
    WindowManager:showWindow(WindowTag.GameOverDetailPopu, self.m_gameData)
    self:dismiss()
end

function GameOverLosePopu:requestReady()
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

function GameOverLosePopu:dismiss(directFlag)
	GameOverLosePopu.super.dismiss(self, directFlag)
	-- GuideManager:stop()
	return true
end

function GameOverLosePopu:onHidenEnd(...)
	GameOverLosePopu.super.onHidenEnd(self, ...)
	-- 如果不是因为点了 快速开始 或者换桌/高倍场按钮 则判断是否破产
	if not self.m_closeFlag and app:checkIsBroke() then
		-- 如果已经破产 则弹充值
		app:selectGoodsForChargeByLevel({
			level = G_RoomCfg:getLevel(),
		})
	end
end

return GameOverLosePopu