WindowStyle = {
    NORMAL          = 1,
    TRANSLATE_DOWN  = 2,
    TRANSLATE_UP    = 3,
    TRANSLATE_LEFT  = 4,
    TRANSLATE_RIGHT = 5,
    POPUP           = 6,
    MOVETO_DOWN		= 7,
    MOVETO_UP		= 8,
}

WindowTag = {
	MessageBox 		= 1,
	MessageBox1 	= 2,
	NoticePopu 		= 3,
	UserPopu 		= 4,
	RankPopu 		= 5,
	TaskPopu 		= 6,
	ShopPopu 		= 7,
	SettingPopu		= 8,
	HelpPopu		= 9,
	MessagePopu		= 10,
	RechargePopu 	= 11,
	PortraitPopu 	= 12,
	UpdatePopu		= 13,
	FeedbackPopu 	= 14,
	
	LoginPopu 		= 21,
	TelLoginPopu 	= 22,
	TelRegisterPopu = 23,
	TelForgotPopu 	= 24,

    SignAwardPopu   = 25,
    FirstPayBagPopu = 26,

    RankUserPopu 	= 27,
    AntiAddictionPopu = 28,

    ActivityPopu 	= 29,

    PayPopu 		= 30,

    UserRulePopu 	= 31,
    PayComfirmPopu 	= 32,

    UserInfoPopu 	= 51,
	RoomSetting 	= 52,
	RoomChat 		= 53,
	GameOverWinPopu    = 54,
	GameOverLosePopu    = 55,
	GameOverDrawPopu    = 56,
	GameOverWinDetailPopu = 57,
	GameOverLoseDetailPopu = 58,

	ReconnMessageBox 	= 80,

	GuidePopu 			= 81,
	TestToolPopu     	= 100,
	GiveCoinPopu		= 101,
	GameBoxPopu			= 102,
	ExchangeInfoPopu 	= 103,
	ExitGamePopu	 	= 104,
	GameOverDetailPopu 	= 105,
	BankruptPopu 		= 106,

	ChatViewPopu 		= 107, 

	GoodsBuyPopu 		= 108,
    UserInfoPopu2 		= 109,
    EMailPopu 			= 110,
    EMailSysAnnexPopu 	= 111,

    createRoomPopu 		= 201,
    entryRoomPopu 		= 202,
    inviteEntryPopu 	= 203,
    billingPopu			= 204,
    historyPopu			= 205,
    accountsPopu		= 206,


}

-- 弹窗配置表
-- 参数1 弹窗配置表{ 1 为弹窗类， 2为弹窗布局文件 }
-- 参数2 zorder
-- 参数3 关闭后是否销毁
WindowConfigMap = {
	-- config  														zOrder bgTouchHide backHide autoRemove stateRemove
	[WindowTag.MessageBox] 		= 	{ "popu.public.messageBox", "messageBox", 220, false, true, true, true},
	[WindowTag.ReconnMessageBox] = 	{ "popu.public.messageBox", "messageBox", 221, false, true, true, true},
	[WindowTag.MessageBox1] 	= 	{ "popu.public.messageBox1", "messageBox", 220, false, true, true, true},
	[WindowTag.UserInfoPopu] 	= 	{ "popu.public.userInfoPopu", "userInfoPopu", 188, true, true, false, true},
	[WindowTag.RoomSetting] 	= 	{ "popu.room.roomSetting", "roomSetting", 188, false, true, false, true},
	[WindowTag.RoomChat] 		= 	{ "popu.room.roomChatPopu", "roomChatPopu", 188, true, true, true, true},
	[WindowTag.GameOverWinPopu] 	= 	{ "popu.room.gameOverWinPopu", "gameOverWinPopu", 188, false, true, true, true},
	[WindowTag.GameOverLosePopu] 	= 	{ "popu.room.gameOverLosePopu", "gameOverLosePopu", 188, false, true, true, true},
	[WindowTag.GameOverDrawPopu] 	= 	{ "popu.room.gameOverDrawPopu", "gameOverDrawPopu", 188, false, true, true, true},
	[WindowTag.GameOverWinDetailPopu] 	= 	{ "popu.room.gameOverWinDetailPopu", "gameOverWinDetailPopu", 188, false, true, true, true},
	[WindowTag.GameOverLoseDetailPopu] 	= 	{ "popu.room.gameOverLoseDetailPopu", "gameOverLoseDetailPopu", 188, false, true, true, true},
	[WindowTag.NoticePopu] 		= 	{ "popu.lobby.noticePopu", "sysNoticeLayout", 188, false, true, true, true},
	[WindowTag.UserPopu] 		= 	{ "popu.lobby.userPopu", "userLayout", 180, false, true, true, true},
	[WindowTag.RankPopu] 		= 	{ "popu.lobby.rankPopu", "rankLayout", 180, false, true, true, true},
	[WindowTag.TaskPopu] 		= 	{ "popu.lobby.taskPopu", "taskLayout", 180, false, true, true, true},
	[WindowTag.ShopPopu] 		= 	{ "popu.lobby.shopPopu", "shopLayout", 180, false, true, true, true},
	[WindowTag.SettingPopu] 	= 	{ "popu.lobby.settingPopu", "settingLayout1", 180, false, true, true, true},
	[WindowTag.HelpPopu] 		= 	{ "popu.lobby.helpPopu", "helpLayout", 180, false, true, true, true},
	[WindowTag.MessagePopu] 	= 	{ "popu.lobby.messagePopu", "messageBoxLayout", 180, false, true, true, true},
	[WindowTag.PortraitPopu] 	= 	{ "popu.lobby.portraitPopu", "modifyPortraitLayout", 188, false, true, true, true},
	[WindowTag.UpdatePopu] 		= 	{ "popu.lobby.updatePopu", "updateLayout", 188, false, true, true, true},
	[WindowTag.FeedbackPopu] 	= 	{ "popu.lobby.feedbackPopu", "feedbackLayout", 188, false, true, true, true},

	[WindowTag.LoginPopu] 		= 	{ "popu.lobby.loginPopu", "loginLayout", 188, false, true, true, true},
	[WindowTag.TelLoginPopu] 	= 	{ "popu.lobby.telLoginPopu", "telLoginLayout", 188, false, true, true, true},
	[WindowTag.TelRegisterPopu] = 	{ "popu.lobby.telRegisterPopu", "telRegisterLayout", 188, false, true, true, true},
	[WindowTag.TelForgotPopu] = 	{ "popu.lobby.telForgotPopu", "telForgotLayout", 188, false, true, true, true},

    [WindowTag.SignAwardPopu] 		= 	{ "popu.public.signAwardPopu", "signAwardLayout", 188, false, true, true, true},
    [WindowTag.FirstPayBagPopu] 	= 	{ "popu.public.firstPayBagPopu", "firstGiftBagLayout", 188, false, true, true, true},
    [WindowTag.RankUserPopu] 		= 	{ "popu.lobby.rankUserPopu", "rankUserLayout", 188, true, true, true, true},
    [WindowTag.AntiAddictionPopu] 	= 	{ "popu.lobby.antiAddictionPopu", "antiAddictionLayout", 188, false, true, true, true},

    [WindowTag.PayPopu] 			= 	{ "popu.lobby.payPopu", "payLayout", 199, false, true, true, true},
	[WindowTag.RechargePopu] 		= 	{ "popu.public.rechargePopu", "quickPurchaseLayout", 190, false, true, true, true},


	[WindowTag.UserRulePopu] 		= 	{ "popu.lobby.userRulePopu", "userRuleLayout", 288, true, false, true, true}, --zindex必须保证在最前面，因为有webview
	-- [WindowTag.UserRulePopu] 			= 	{ "popu.lobby.userRulePopu", "userRuleLayout", 288, false, true, true, true}, --zindex必须保证在最前面，因为有webview
	
	[WindowTag.PayComfirmPopu] 		= 	{ "popu.lobby.payComfirmPopu", "payConfirmLayout", 220, false, true, true, true},

	[WindowTag.GuidePopu] 			= 	{ "popu.public.guidePopu", "guidePopu", 188, false, true, true, true},

	[WindowTag.TestToolPopu] 		= 	{ "popu.public.testToolPopu", "testToolPopu", 199, false, true, false, true},

	[WindowTag.GiveCoinPopu] 		= 	{ "popu.room.giveCoinPopu", "gainCoinLayout", 199, false, true, true, true},
	[WindowTag.GameBoxPopu] 		= 	{ "popu.room.gameBoxPopu", "gameBoxLayout", 199, true, true, true, true},
	[WindowTag.ExchangeInfoPopu] 		= 	{ "popu.lobby.exchangeInfoPopu", "exchangeInfoLayout", 199, false, true, true, true},
	[WindowTag.ExitGamePopu] 		= 	{ "popu.lobby.exitGamePopu", "leaveGamePopu", 288, false, true, true, true},
	[WindowTag.GameOverDetailPopu] 		= 	{ "popu.room.gameOverDetailPopu", "gameOverDetailLayout", 199, false, true, true, true},
	[WindowTag.BankruptPopu] 		= 	{ "popu.public.bankruptPopu", "bankruptPopu", 199, false, true, true, true},

	[WindowTag.ChatViewPopu]		=	{ "popu.public.chatPopu", "chatLayout", 188, true, true, true, true},
	[WindowTag.GoodsBuyPopu]		=	{ "popu.public.goodsBuyPopu", "buyGoodsLayout", 199, false, true, true, true},
	[WindowTag.UserInfoPopu2] 		= 	{ "popu.public.userInfoPopu2", "userInfoPopu2", 199, true, true, true, true},
	[WindowTag.EMailPopu] 			= 	{ "popu.lobby.eMailPopu", "eMailLayout", 180, false, true, true, true},
	[WindowTag.EMailSysAnnexPopu] 		= 	{ "popu.lobby.mailSysAnnexPopu", "sysMsgAnnexLayout", 199, true, true, true, true},
	
	[WindowTag.createRoomPopu] 		= 	{ "popu.lobby.createRoomPopu", "createRoomPopu", 180, true, true, true, true},
	[WindowTag.entryRoomPopu] 		= 	{ "popu.lobby.entryRoomPopu", "joinRoomPopu", 180, true, true, true, true},
	[WindowTag.inviteEntryPopu] 	= 	{ "popu.room.inviteEntryPopu", "inviteFriendPopu", 188, true, true, false, true},
	[WindowTag.billingPopu] 		= 	{ "popu.lobby.billingPopu", "billingLayout", 180, false, true, true, true},
	[WindowTag.historyPopu] 		= 	{ "popu.room.historyPopu", "historyLayout", 180, true, true, true, true},
	[WindowTag.accountsPopu] 		= 	{ "popu.room.accountsPopu", "accountsLayout", 199, false, true, true, true},

}

local WindowManager = class(Node)
local BgAlpha = 180
local BgFadeTime = 200

function WindowManager:ctor()
	self:addToRoot()
	self:setLevel(50)
	self.m_windows = {}
	self:setFillParent(true, true)
end

function WindowManager:showWindow(name, data, style, tag)
	self:createBgShade()

	local window = self:getChildByName(name)
	local winCfg = WindowConfigMap[name]
	local reCreate
	if not window and winCfg then
		local path, viewCfg, zOrder, backHide, bgTouchHide, autoRemove, stateRemove = unpack(winCfg)
		local cls = require(path)
		local viewCfg = require(ViewPath .. viewCfg)
		window = new(cls, viewCfg, data, tag)
		window:setLevel(zOrder)
		self.m_shadeBg:setLevel(zOrder)
		window:setName(name)
		printInfo("创建弹窗 %s", name)
		window:setConfigFlag(backHide, bgTouchHide, autoRemove, stateRemove)
		window:setAlign(kAlignCenter)
		self:addChild(window)
		table.insert(self.m_windows, window)
		reCreate = true
	elseif window then
		window:updateView(data, tag)
	end
	self:sortWindow()
	window:show(style)
	checkAndRemoveOneProp(self.m_shadeBg, 1002)
	if window and not self.m_shadeBg:getVisible() then
		self.m_shadeBg:setVisible(true)
		local anim = self.m_shadeBg:addPropTransparency(1001, kAnimNormal, BgFadeTime, 0, 0.0, 1.0)
		if anim then
			anim:setEvent(nil, function()
				self.m_shadeBg:removeProp(1001)
			end)
		end
	end

	self:resortLevel()
	return window
end

function WindowManager:resortLevel(visibleTb)
	visibleTb = visibleTb or self:getVisibleTb()
	if #visibleTb > 0 then
		self:sortWindow(visibleTb)
		self.m_shadeBg:setLevel(visibleTb[#visibleTb]:getLevel() - 1)
	end
end

--[[
	排序
]]
function WindowManager:sortWindow(windowTb)
	windowTb = windowTb or self.m_windows
	table.sort(self.m_windows, function(node1, node2)
		return node1:getLevel() < node2:getLevel()
	end)
end

function WindowManager:createBgShade()
	if not self.m_shadeBg then
		self.m_shadeBg = UIFactory.createImage("kwx_common/img_zhezhao.png")
		self.m_shadeBg:setFillParent(true, true)
		self.m_shadeBg:setVisible(false)
		self.m_shadeBg:setLevel(1)
		-- self.m_shadeBg:setTransparency(1.1)
		self.m_shadeBg:setEventTouch(self, self.onShadeBgTouch);
		self:addChild(self.m_shadeBg)
	end
end

function WindowManager:onShadeBgTouch(finger_action, x, y, drawing_id_first, drawing_id_current)
	if finger_action ~= kFingerDown then return end
	for i=#self.m_windows, 1, -1 do
		local window = self.m_windows[i]
		if window:isBgTouchHide() and window:getVisible() then
			local success = window:dismiss()
			if success then
				printInfo("success name = %s", window:getName())
				break
			else
				printInfo("false name = %s", window:getName())
				return
			end
		end
	end
end

function WindowManager:onKeyBack()
	for i=#self.m_windows, 1, -1 do
		local window = self.m_windows[i]
		if window:isBackHide() then
			local success = window:dismiss()
			if success then
				return true
			end
		end
	end
end

--[[
	当前有多少弹窗可见
]]
function WindowManager:getVisibleTb()
	local visibleTb = {}
	for k,v in pairs(self.m_windows) do
		if v:getVisible() then
			table.insert(visibleTb, v)
		end
	end
	return visibleTb
end

function WindowManager:onShowEnd(name)
	self.m_shadeBg:setVisible(true)
	checkAndRemoveOneProp(self.m_shadeBg, 1002)
end

function WindowManager:onHidenEnd(name, doClean)
	if doClean then
		for k,v in pairs(self.m_windows) do
			if v:getName() == name then
				table.remove(self.m_windows, k)
				self:removeChild(v, doClean)
				printInfo("销毁弹窗 ！！！！！ %s", name)
				break;
			end
		end
	end
	local visibleTb = self:getVisibleTb()
	self:createBgShade()
	printInfo("弹窗%s关闭成功, 剩余弹窗数量%d, 存在弹窗数量%d", name, #visibleTb, #self.m_windows)
	checkAndRemoveOneProp(self.m_shadeBg, 1001)
	if #visibleTb == 0 and self.m_shadeBg:getVisible() then
		local anim = self.m_shadeBg:addPropTransparency(1002, kAnimNormal, BgFadeTime, 0, 1.0, 0.0)
		if anim then
			anim:setEvent(nil, function()
				self.m_shadeBg:removeProp(1002)
				self.m_shadeBg:setVisible(false)
			end)
		else
			self.m_shadeBg:setVisible(false)
		end
	end
	self:resortLevel(visibleTb)
end

function WindowManager:closeWindowByTag(tag, noAnim)
	for i,v in pairs(self.m_windows) do
		if v:getName() == tag then
			v:dismiss(noAnim)
		end
	end
end

function WindowManager:containsWindowByTag(tag)
	for i,v in pairs(self.m_windows) do
		printInfo("name = %s", v:getName())
		if v:getName() == tag then
			printInfo("containsWindowByTag(tag) = %s , true", tag)
			return v
		end
	end
	printInfo("containsWindowByTag(tag) = %s , false", tag)
end

function WindowManager:clearAllWindow()
	printInfo("WindowManager clearAllWindow")
	local indexTb = {}
	for k, v in pairs(self.m_windows) do
		table.insert(indexTb, k)
	end
	for i = #indexTb, 1, -1 do
		local wnd = self.m_windows[indexTb[i]]
		if wnd:alive() then
			printInfo("wnd:getName() : %s", wnd:getName())
			wnd:dismiss(false)
		end
	end
end

function WindowManager:dealWithStateChange()
	local indexTb = {}
	for k,v in pairs(self.m_windows) do
		if v:isStateRemove() then
			table.insert(indexTb, k)
		end
	end
	for i = #indexTb, 1, -1 do
		local wnd = self.m_windows[indexTb[i]]
		if wnd:alive() then
			self:onHidenEnd(wnd:getName(), true)
		end
	end
end

return WindowManager
