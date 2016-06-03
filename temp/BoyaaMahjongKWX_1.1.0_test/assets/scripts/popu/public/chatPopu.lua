local chatContentItem = require(ViewPath .. "chatContentItem")

local GameWindow = require("popu.gameWindow")

local ChatPopu = class(GameWindow)


function ChatPopu:ctor()
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)
end

function ChatPopu:dtor()
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
end

function ChatPopu:initView()

	self.mChatContentList = {}
	self.chatContentData = ""

	self.commonUserBarIsShow = false

	self.scrollviewChat = self.m_root:findChildByName("scrollview_chat")
	self.commonUserBar = self.m_root:findChildByName("view_commonUserBar")
	self.textMyInput = self.m_root:findChildByName("text_myInput")
	self.commonUserBar:hide()
	self.textMyInput:show()
	 
	-- 常用按钮
 --    self.m_root:findChildByName("text_commonUser"):setEventTouch(self, function(self, finger_action)
	-- 	if finger_action == kFingerDown then

	-- 		if self.commonUserBarIsShow == false then		
	-- 			self.commonUserBarIsShow = true		
	-- 			self.commonUserBar:show()
	-- 		else
	-- 			self.commonUserBarIsShow = false
	-- 			self.commonUserBar:hide()
	-- 		end
	-- 	end
	-- end);

	-- 发送按钮
	local sendBtn = self:findChildByName("btn_sendChat");
	sendBtn:setIsGray(true)
    sendBtn:setOnClick(self,function (self)
      -- body
		self.commonUserBar:hide()
		self.commonUserBarIsShow = false

		local len = getStringLen(self.chatContentData)
		if len > 40 then
			AlarmTip.play("你的输入超过40个字符")
			return
		end

		local hornNum = MyGoodsData:getGoodsNumById(MyExchangeData.TypeHorn)

		if hornNum and 0 >= hornNum then
			-- 喇叭数不足时购买
			WindowManager:showWindow(WindowTag.GoodsBuyPopu, MyGoodsData:getGoodsInfoById(MyExchangeData.TypeHorn));
		else
			self:findChildByName("btn_sendChat"):setIsGray(true)
			self.chatTextEdit:setText("");
			self.textMyInput:show()
    		GameSocketMgr:sendMsg(Command.HORN_SEND_PHP_REQUEST, { ["msg"] = self.chatContentData },false);  
		end
		-- 设置为不可点
     	--sendBtn:setEnable(false)

     	-- 间隔时间后可点
	 --  	sendBtn:schedule(function()
	 --  		sendBtn:setEnable(true)
		-- end, 10000)
    end)

    -- 编辑聊天内容
    self.chatTextEdit = self:findChildByName("edittext_chatInfo")
    self.chatTextEdit:setOnTextChange(self, self.onChatTextChange)
    self.chatTextEdit:setText("")
    -- 喇叭数量
    self:updateHoreNum()
  	-- 找同乡
	-- self:findChildByName("btn_seekTX"):setOnClick(self,function (self)
	-- 	self.commonUserBar:hide()
 --    	self.commonUserBarIsShow = false
 --    	self.chatTextEdit:setText()
	-- 	end)

	-- -- 求金币
	-- self:findChildByName("btn_seekGold"):setOnClick(self,function (self)
	-- 	self.commonUserBar:hide()
 --    	self.commonUserBarIsShow = false
	-- 	end)

	-- -- 三缺一
	-- self:findChildByName("btn_SQY"):setOnClick(self,function (self)
	-- 	self.commonUserBar:hide()
 --    	self.commonUserBarIsShow = false
	-- 	end)

	self:updateChatScroll()

end


function ChatPopu:onChatTextChange()
	-- body
	self.commonUserBar:hide()
    self.commonUserBarIsShow = false

    self.chatContentData = self.chatTextEdit:getText()
    
	local len = getStringLen(self.chatContentData)
	-- 检测发送内空是否可发送
	if len > 0 then
		self:findChildByName("btn_sendChat"):setIsGray(false)
		self.textMyInput:hide()
		table.insert(self.mChatContentList, 1, self.chatContentData)
	else
		self:findChildByName("btn_sendChat"):setIsGray(true)
		self.textMyInput:show()
	end
end

function ChatPopu:dismiss(...)
    return ChatPopu.super.dismiss(self, ...)
end

function ChatPopu:updateChatScroll( ... )
	-- body

	self.scrollviewChat:removeAllChildren(true)
	self.chatMsgList = {}

	-- 将发送内容添加到scrollview
	local tempHornInofTable = BroadcastPaoMaDeng:getHornInofTable()
	local itemCount = table.getn(tempHornInofTable)
	local curHeight = 0
	for i = 1, itemCount do

		local chatItem = self:createChatItem(i, tempHornInofTable[i])
		-- local chatItem = self:createMsgItem(i, tempHornInofTable[i])

		local sW, sH = self.scrollviewChat:getSize()
		local iW, iH = chatItem:getSize()
		-- chatItem:setPos((sW - iW) / 2, iH * (i - 1))

		chatItem:setPos(5, curHeight)
		curHeight = curHeight + iH

		self.scrollviewChat:addChild(chatItem)
	end
   -- self.scrollviewChat:rollToTop()
end

function ChatPopu:createMsgItem( curItemNum, data )
	-- body
	item = SceneLoader.load(chatContentItem):findChildByName("view_chatItem")
	local textViewMsg = item:findChildByName("text_msg")

	local data = json.decode(data.data) or ""

	local strMsg = ""

	-- 拼接消息内容
	strMsg = "【" .. data.title .. "】" .. data.name .. "："
	textViewMsg:setText(strMsg .. data.msg .. "  ".. ToolKit.skipTimeHM(data.timestamp))

	local textTitle = item:findChildByName("text_title")
	textTitle:setText(strMsg)
	local tw = textTitle.m_res:getWidth()

	-- 区分消息显示
	local msgType = data.type2
	if msgType == 1 then
		textViewMsg:setColor(0xff, 0x00, 0x00)
	elseif msgType == 3 then
		textViewMsg:setColor(0xff, 0xff, 0xff)

		-- local textName = new(TextView, strMsg, tw + 10, 24, kAlignLeft, kFontTextUnderLine, 24, 0xff, 0xff, 0xff)
		-- 	-- :align(kAlignCenter)
		-- 	:pos(10, 10)
		-- 	:addTo(item)
			item:findChildByName("view_touch")
				:setSize(tw, 40)
				:setEventTouch(self, function(self, finger_action)
			if finger_action == kFingerDown then
    			GameSocketMgr:sendMsg(Command.USERINFO_GET_PHP_REQUEST, { ["mid"] = data.uid });  
				WindowManager:showWindow(WindowTag.UserInfoPopu2, nil)
			end
		end);
	end

	-- 区分背景
	if curItemNum % 2 == 0 then
		local imgItembg = item:findChildByName("img_chatItem_bg")
		imgItembg:hide()
	end

	return item
end

-- 聊天消息item创建
function ChatPopu:createChatItem( curItemNum, data )
	-- body
	local nodeItem = new(Node)
	nodeItem:setAlign(kAlignTopLeft)

	local data = json.decode(data.data) or ""
	local strMsg = ""

	local bgImage = UIFactory.createImage("kwx_chat/img_chatText_bg.png")
	bgImage:setAlign(kAlignTopLeft)
	nodeItem:addChild(bgImage)

	-- 拼接消息内容
	strMsg = "【" .. data.title .. "】" .. data.name
	local msgBody = strMsg .. "：" .. data.msg .. "  ".. ToolKit.skipTimeHM(data.timestamp)
	local textView = new(TextView, msgBody, 790, 0, kAlignTopLeft, nil, 26, 0xFF, 0xFF, 0xFF)
	textView:setPos(10,6)
	nodeItem:addChild(textView)
	-- 区分消息显示
	local msgType = data.type2
	if msgType == 1 then
		textView:setColor(0xff, 0x00, 0x00)
	elseif msgType == 3 then
		textView:setColor(0xff, 0xff, 0xff)

		local textTitle = new(Text)
		textTitle:setText(strMsg)
		local tw = textTitle.m_res:getWidth()

		local titleText = new(TextView, "【" .. data.title .. "】", 200, 0, kAlignTopLeft, kFontTextUnderLine, 26, 0xFF, 0xFF, 0xFF);
		local titleW, titleH = titleText:getSize()
		local linkText = new(TextView, data.name, tw, 0, kAlignTopLeft, kFontTextUnderLine, 26, 0xFF, 0xFF, 0xFF);
		linkText:setPos(10 + 108,6)
		nodeItem:addChild(linkText)
		linkText:setEventTouch(self, function(self, finger_action)
				if finger_action == kFingerDown then
	    			GameSocketMgr:sendMsg(Command.USERINFO_GET_PHP_REQUEST, { ["mid"] = data.uid });  
					WindowManager:showWindow(WindowTag.UserInfoPopu2, nil)
				end
			end);
	end
	
	-- 区分背景
	if curItemNum % 2 == 0 then
		bgImage:hide()
	end

	bgImage:setSize(790, textView.m_res:getHeight() + 10)
	nodeItem:setSize(bgImage:getSize())

	return nodeItem

end

function ChatPopu:updateHoreNum()
	-- body
	local count = MyGoodsData:getGoodsNumById(MyGoodsData.TypeHorn)
	local strCount = count
	if count and count > 9 then strCount = "…" end

    self:findChildByName("text_hornNum"):setText(strCount)
	self:findChildByName("btn_sendChat"):setIsGray(false)
end

function ChatPopu:onSendHornMsgResponse( data )
	-- body
    self:updateHoreNum()
end

function ChatPopu:onExchangeGoodsResponse( data )
	-- body
    self:updateHoreNum()
end

function ChatPopu:onServergbBroadcastGoodsData( data )
	-- body
    self:updateHoreNum()
end

function ChatPopu:onServerBroadcastPaoMaDeng( data )
	-- body
	self:updateChatScroll()

end

function ChatPopu:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

function ChatPopu:onGetBaseInfoResponse( data )
	-- body

end


--[[
	通用的（大厅）协议
]]
ChatPopu.s_severCmdEventFuncMap = {
    [Command.EXCHANGE_GOODS_REQUEST]                = ChatPopu.onExchangeGoodsResponse,
    [Command.HORN_SEND_PHP_REQUEST]                = ChatPopu.onSendHornMsgResponse,
    [Command.SERVERGB_BROADCAST_GOODSDATA]      = ChatPopu.onServergbBroadcastGoodsData,
}

ChatPopu.commandFunMap = {
    [Command.SERVERGB_BROADCAST_PAOMADENG]                = ChatPopu.onServerBroadcastPaoMaDeng,
    [Command.GET_BASEINFO_PHP_REQUEST]					= ChatPopu.onGetBaseInfoResponse,
}

return ChatPopu