local eMailPopu = class(require("popu.gameWindow"))
local systemMsgItemLayout = require(ViewPath .. "mailSysMsgItem")
local friendMsgItemLayout = require(ViewPath .. "mailFriendMsgItem")


local TABTAG_SYSTEMMSG = 1
local TABTAG_FRIENDMSG = 2
function eMailPopu:ctor()
    GameSetting:setIsSecondScene(true)
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)
end

function eMailPopu:dtor()
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
end

function eMailPopu:initView(data)

	-- 系统消息表
	self.mSystemList = {}
	self.mFriendList = {}
	-- 返回按钮
	self:findChildByName("btn_back"):setOnClick(self, function( )
		-- body
		self:dismiss();
	end)
	local tagTable = {
		[TABTAG_SYSTEMMSG] = {
			"btn_systemmsg",
			"btn_systemmsgClicked",
		},
		[TABTAG_FRIENDMSG] = {
			"btn_friendmsg",
			"btn_friendmsgClicked",
		}
	}

	self.mTabView = {}
	self.mTabView[TABTAG_SYSTEMMSG] = self:findChildByName("view_systemmsg")
	self.mTabView[TABTAG_FRIENDMSG] = self:findChildByName("view_friendmsg")

	self.mTabBtn = {}
	self.mTabBtn.normal = {}
	self.mTabBtn.clicked = {}

	for i = TABTAG_SYSTEMMSG, TABTAG_FRIENDMSG do
		table.insert(self.mTabBtn.normal, self:findChildByName(tagTable[i][1]))
		table.insert(self.mTabBtn.clicked, self:findChildByName(tagTable[i][2]))
		self.mTabBtn.normal[i]:setOnClick(self, function( self )
			-- body
			self:onClickTabBtn(i)
		end)
	end
    self:onClickTabBtn(TABTAG_SYSTEMMSG)
end

function eMailPopu:changeTabState( tag )
	-- body
	for i = TABTAG_SYSTEMMSG, TABTAG_FRIENDMSG do
		if tag == i then
			self.mTabBtn.normal[i]:hide()
			self.mTabBtn.clicked[i]:show()
			self.mTabView[i]:show()
		else
			self.mTabBtn.normal[i]:show()
			self.mTabBtn.clicked[i]:hide()
			self.mTabView[i]:hide()
		end
	end

end
function eMailPopu:onClickTabBtn( tag )
	-- body
	-- self:changeTabState(tag)
    if tag == TABTAG_SYSTEMMSG then
        self:showSystemMsgView()

    elseif tag == TABTAG_FRIENDMSG then
        self:showFriendMsgView()
    end


end

function eMailPopu:showSystemMsgView(args)
    -- local scrollView = self.mTabView[TABTAG_SYSTEMMSG]:findChildByName("scrollview_systemmsg")
    -- scrollView:removeAllChildren(true)	
    self:findChildByName("img_msgtips"):show()

    local view_systemmsg = self:findChildByName("view_systemmsg")
    view_systemmsg:removeAllChildren(true)
    local viewWidth, viewHeight = view_systemmsg:getSize()
    local scrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false)
    					:addTo(view_systemmsg)

    local count = MyMailSystemData:count()

    if 0 >= count then
    	self:findChildByName("text_nodata"):show()
    	return
    end
	self:findChildByName("text_nodata"):hide()

	local sW, sH = scrollView:getSize()
	for i = 1, count do
		local data = MyMailSystemData:get(i)
		local item = self:createSystemMsgListItem(data)
		local iW, iH = item:getSize()
		item:setPos((sW - iW) / 2, iH * (i - 1))
		scrollView:addChild(item)

		table.insert(self.mSystemList, {
			msgid = data:getId(),
			msgtype = data:getType(),
			item = item
			})
	end
end

function eMailPopu:createSystemMsgListItem( data )
	-- body
	local item = SceneLoader.load(systemMsgItemLayout):findChildByName("view_item")

	item:findChildByName("text_msgtitle"):setText(ToolKit.formatNick(data:getTitle(), 12))
	item:findChildByName("text_msg"):setText(ToolKit.formatNick(data:getContent(),20))

	local text_seestr = item:findChildByName("text_seestr")
	
	if 1 == data:getAward() then
		item:findChildByName("btn_see"):setIsGray(true)
		if 1 == data:getType() then
			text_seestr:setText("已阅")
		elseif 2 == data:getType() then
			text_seestr:setText("已领")
        end
	else
		item:findChildByName("btn_see"):setOnClick(self, function()
			-- 查看
			if 1 == data:getType() then
				GameSocketMgr:sendMsg(Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST, { ["id"] = data:getId() })
				data:setAward(1)
				self:onGetSystemAwardMsgResponse(data:getId())
				WindowManager:showWindow(WindowTag.EMailSysAnnexPopu, data)
			elseif 2 == data:getType() then
				WindowManager:showWindow(WindowTag.EMailSysAnnexPopu, data)
			end
		end)

		if 1 == data:getType() then
			text_seestr:setText("查看")
		elseif 2 == data:getType() then
			text_seestr:setText("领取")
		end
	end


	item:findChildByName("btn_del"):setOnClick(self, function()
		-- 删除
		local count = MyMailSystemData:count()
		for i = 1, count do
			local item = MyMailSystemData:get(i)
			if data:getId() == item:getId() then
				MyMailSystemData:remove(i)
				self:showSystemMsgView()
				GameSocketMgr:sendMsg(Command.MAIL_DEL_SYSTEMMSG_PHPREQUEST, { ["id"] = data:getId() })
				return
			end
		end
	end)
	return item
end

function eMailPopu:showFriendMsgView(args)
    self:findChildByName("img_msgtips"):hide()

	local view_systemmsg = self:findChildByName("view_friendmsg")
    view_systemmsg:removeAllChildren(true)
    local viewWidth, viewHeight = view_systemmsg:getSize()
    local scrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false)
    					:addTo(view_systemmsg)

    local count = MyMailFriendData:count()

    if 0 >= count then
    	self:findChildByName("text_nodata"):show()
    	return
    end
	self:findChildByName("text_nodata"):hide()

	local sW, sH = scrollView:getSize()
	for i = 1, count do
		local data = MyMailFriendData:get(i)
		local item = self:createFriendMsgListItem(data)
		local iW, iH = item:getSize()
		item:setPos((sW - iW) / 2, iH * (i - 1))
		scrollView:addChild(item)

		table.insert(self.mFriendList, {
			msgid = data:getId(),
			msgtype = data:getType(),
			item = item
			})
	end
end


function eMailPopu:createFriendMsgListItem( data )
	-- body
	local item = SceneLoader.load(friendMsgItemLayout):findChildByName("view_item")

	item:findChildByName("text_msgtitle"):setText(ToolKit.formatNick(data:getMnick(), 12))

	local headView = item:findChildByName("view_head")
	local headImage = new(Mask, data:getPoto(), "kwx_mail/img_headMask.png")
	headImage:setSize(headView:getSize())
	headView:addChild(headImage)

	local text_seestr = item:findChildByName("text_seestr")
	local text_btn2str = item:findChildByName("text_btn2str")
	
	if 1 == data:getType() then
		item:findChildByName("text_msg"):setText("申请成为你的好友")
		text_seestr:setText("忽略")
		text_seestr:setText("同意")
	
	elseif 2 == data:getType() then
		item:findChildByName("text_msg"):setText("赠送给你"..data:getMoney().."金币")
		text_seestr:setText("收取")
		text_seestr:setText("回赠")
	end

	item:findChildByName("btn_see"):setOnClick(self, function()
			
		end)
	
	return item
end

function eMailPopu:onGetSystemAwardMsgResponse( msgid )
	local itemCount = table.getn( self.mSystemList )
	for i = 1, itemCount do
		if self.mSystemList[i].msgid == msgid then 
			if 1 == self.mSystemList[i].msgtype then
				self.mSystemList[i].item:findChildByName("text_seestr"):setText("已阅")
				self.mSystemList[i].item:findChildByName("btn_see"):setIsGray(true)
				return
			elseif 2 == self.mSystemList[i].msgtype then
				self.mSystemList[i].item:findChildByName("text_seestr"):setText("已领")
				self.mSystemList[i].item:findChildByName("btn_see"):setIsGray(true)
			end
		end
	end
end

function eMailPopu:setHeadImg(fileName)
	local headView = self.m_root:findChildByName("view_head");

	if not self.m_headImage then
		self.m_headImage = new(Mask, fileName, "kwx_lobby/img_touXiangMask.png");
		self.m_headImage:setSize(headView:getSize());
		headView:addChild(self.m_headImage);
	else
		self.m_headImage:setVisible(true)
		self.m_headImage:setFile(fileName)
	end
end

function eMailPopu:onGetFriendMsgResponse( msgid )
	
end

function eMailPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return eMailPopu.super.dismiss(self, ...)
end

function eMailPopu:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

--[[
	通用的（大厅）协议
]]
eMailPopu.s_severCmdEventFuncMap = {
    [Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST]	= eMailPopu.onGetSystemAwardMsgResponse,
    [Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST]	= eMailPopu.onGetSystemAwardMsgResponse,
	[Command.MAIL_GET_FRIENDMSG_PHPREQUEST]			= eMailPopu.onGetFriendMsgResponse,
}

eMailPopu.commandFunMap = {
}
return eMailPopu