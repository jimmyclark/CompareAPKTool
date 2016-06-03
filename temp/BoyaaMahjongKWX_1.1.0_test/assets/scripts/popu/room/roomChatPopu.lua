require("room/chat/faceq_res")

local RoomChatPopu = class(require("popu.gameWindow"))
local PATH = "kwx_tanKuang/roomChat/"

function RoomChatPopu:initView(userInfo)
	self.m_root:findChildByName("close_btn")
		:setOnClick(nil, function()
			self:dismiss()
		end)

	self.m_sendBtn  = self.m_root:findChildByName("send_btn")
	self.m_inuptText = self.m_root:findChildByName("input_text")

	self.m_sendBtn:setOnClick(self, self.sendChatWord)

	self.m_faceList = self.m_root:findChildByName("face_list")

	self.m_wordBtn = self.m_root:findChildByName("word_btn")
	self.m_wordBtn:enableAnim(false)
	self.m_wordBtnTitle = self.m_root:findChildByName("word_title")
	self.m_wordList = self.m_root:findChildByName("word_list")

	self.m_recordBtn = self.m_root:findChildByName("record_btn")
	self.m_recordBtn:enableAnim(false)
	self.m_recordBtnTitle = self.m_root:findChildByName("record_title")
	self.m_recordList = self.m_root:findChildByName("record_list")

	local changeTab = function(index)
		if index == 1 then
			self.m_wordBtnTitle:setText(self.m_wordBtnTitle:getText(), nil, nil, 0xFF, 0xFF, 0xFF)
			self.m_wordBtn:setFile(PATH .. "btn_selected.png")
			self.m_recordBtnTitle:setText(self.m_recordBtnTitle:getText(), nil, nil, 0x50, 0xB4, 0xFF)
			self.m_recordBtn:setFile(PATH .. "btn_notSelect.png")
			self:initChatView()
		elseif index == 2 then
			self.m_recordBtnTitle:setText(self.m_recordBtnTitle:getText(), nil, nil, 0xFF, 0xFF, 0xFF)
			self.m_recordBtn:setFile(PATH .. "btn_selected.png")
			self.m_wordBtnTitle:setText(self.m_wordBtnTitle:getText(), nil, nil, 0x50, 0xB4, 0xFF)
			self.m_wordBtn:setFile(PATH .. "btn_notSelect.png")
			self:initRecordView()
		end
	end
	self.m_wordBtn:setOnClick(1, changeTab)
	self.m_recordBtn:setOnClick(2, changeTab)

	self.m_inuptText:setOnTextChange(self, function ( self )
		local text = self.m_inuptText:getText()
		text = string.ltrim(text)
		local _, len = ToolKit.utf8len(text)
		if len > 36 then
			AlarmTip.play("聊天内容不超过36个字符")
			self.m_inuptText:setText(ToolKit.subStr(self.m_inuptText:getText(), 36, nil, true));
		end
	end);

	self:initFaceView()
	self:initChatView()
end

function RoomChatPopu:initChatView()
	if self.m_recordListView then self.m_recordListView:hide() end
	if self.m_wordListView then self.m_wordListView:show() return end
	local wordList = self.m_wordList
	local width, height = wordList:getSize()

	self.m_wordListView = new(ScrollView, 0, 0, width, 320, false)
	self.m_wordListView:setScrollBarWidth(8);
	self.m_wordListView:setDirection(kVertical)
	wordList:addChild(self.m_wordListView)

	self:createWordView(SysChatArray)
		:addTo(self.m_wordListView)
end

function RoomChatPopu:createWordView(chatArray)
	local wordNode = new(Node)
	local x,y = 12, 0
	for i=1, #chatArray do
		local chatInfo = chatArray[i]
		local wordBtn = UIFactory.createButton(PATH .. "img_textDi.png")
			:addTo(wordNode)
			:pos(x, y + 10)
		wordBtn:enableAnim(false)
		wordBtn:setOnClick( nil, function()
  			EventDispatcher.getInstance():dispatch(Event.Message, "sendChatWord", chatInfo)
			self:dismiss(true)
		end)

		local txt = UIFactory.createText({
				text = chatInfo,
				size = 24,
				color = c3b( 0xFF, 0xFF, 0xFF),
			})
			:addTo(wordBtn)
			:align(kAlignLeft, 10, 0)

		y = y + 65
	end
	wordNode:setSize(384, y)
	return wordNode
end

function RoomChatPopu:initRecordView()
	if self.m_wordListView then self.m_wordListView:hide() end
	if self.m_recordListView then self.m_recordListView:show() return end
	if not G_RoomCfg then return end
	local chatHistory = G_RoomCfg:getChatHistory()
	local recordList = self.m_recordList
	local width, height = recordList:getSize()

	self.m_recordListView = new(ScrollView, 0, 0, width, 320, false)
	self.m_recordListView:setScrollBarWidth(8);
	self.m_recordListView:setDirection(kVertical)
	recordList:addChild(self.m_recordListView)

	self:createRecordNode(chatHistory)
end

function RoomChatPopu:createRecordNode(chatHistory)
	local x, y = 12, 0
	local imgWidth
	self.m_records = {}
	for i=1, #chatHistory do
		local chatRecord = chatHistory[i]
		local recordImg = UIFactory.createImage(PATH .. "img_textDi.png", nil, nil, 20, 20, 20, 20)
			:pos(x, y + 10)
			:addTo(self.m_recordListView)
		table.insert(self.m_records, recordImg)

		imgWidth = imgWidth or recordImg:getSize()
		local txt = UIFactory.createTextView({
				text = string.format("[%s]%s", chatRecord.nick, chatRecord.chatInfo),
				size = 24,
				color = c3b(147, 71, 0),
				width = imgWidth - 40,
				height = 0,
			})
			:addTo(recordImg)
			:pos(10, 10)
		local width, txtHeight = txt:getSize()
		txt:setSize(nil, txtHeight)
		txt:setEventTouch(nil, function() end)
		local height = txtHeight + 20
		recordImg:setSize(imgWidth, height)
		UIFactory.createButton(PATH .. "btn_textClose.png")
			:addTo(recordImg)
			:align(kAlignRight, 10, 0)
			:setOnClick(nil, function()
				local startIndex 
				for j,v in ipairs(self.m_records) do
					if v == recordImg then
						startIndex = j
						break
					end
				end
				self.m_recordListView:removeChild(recordImg, true)
				self.m_recordListView.m_nodeH = self.m_recordListView.m_nodeH - height
				self.m_recordListView:update()
				if not startIndex then return end
				table.remove(self.m_records, startIndex)
				table.remove(chatHistory, startIndex)
				for index = startIndex, #self.m_records do
					printInfo("startIndex ==============")
					local record = self.m_records[index]
					local x,y = record:getPos()
					record:pos(x, y - height - 20)
				end
			end)
		y = y + height + 20
	end
	return recordNode
end

function RoomChatPopu:initFaceView()
	local qList = self.m_faceList
	local qList_w, qList_h = qList:getSize()

	local qfileArray = {}
	local qfaceName = "expression"
	local faceNum = 27
	for i=1, faceNum do 
		qfileArray[i] = faceq_res_map[string.format(qfaceName.."%d.png",i)]
	end

	self.m_faceListView = new(ScrollView, 0, 0, qList_w, 320, false)
	self.m_faceListView:setScrollBarWidth(8);
	self.m_faceListView:setDirection(kVertical)
	self.m_faceListView:addTo(qList)
	self:createFaceNode(qfileArray)
		:addTo(self.m_faceListView)
end

function RoomChatPopu:createFaceNode(qfileArray)
	local faceNode = new(Node)
	local x,y = 0, 0
	local faceW, faceH = 116, 90
	local sepLines = {}
	for i=1, #qfileArray do
		local faceBtn = UIFactory.createButton(qfileArray[i])
		faceBtn:setOnClick( nil, function()
			local faceCanUse = PhpManager:getFaceCanUse()
			if faceCanUse == 0 then
				AlarmTip.play("开始下载表情资源")
				PhpManager:setFaceCanUse(2)
				
				NativeEvent.getInstance():downloadFile("image", ConnectModule:getInstance():getExpressionUrl(), "expression.zip", "表情");
				---- NativeEvent.getInstance():downloadFile("image", HallConfig:getExpressionUrl(), "expression.zip", "表情");
			elseif faceCanUse == 2 then
				AlarmTip.play("表情正在下载中，请稍后")
			elseif faceCanUse == 1 then
  				EventDispatcher.getInstance():dispatch(Event.Message, "sendChatFace", i)
			end
			self:dismiss(true)
		end)
		local w, h = faceBtn:getSize()
		faceBtn:setPos(x + (faceW - w)/2, y + (faceH - h)/2)
		faceNode:addChild(faceBtn)
		if i % 3 == 0 then
			x = 0
			y = y + faceH
			if i ~= #qfileArray then
				local sep_h = UIFactory.createImage("kwx_common/img_h_split.png")
					:addTo(faceNode)
					:pos(0, y)
				local w, h = sep_h:getSize()
				sep_h:setSize(3 * faceW, h)
			end
		else
			x = x + faceW
			if i == 1 or i == 2 then
				local sep_v = UIFactory.createImage("kwx_common/img_v_split.png")
					:addTo(faceNode)
					:pos(x, 0)
				table.insert(sepLines, sep_v)
			end
		end
	end
	for i,v in ipairs(sepLines) do
		local w , h = v:getSize()
		v:setSize(w, y)
	end
	faceNode:setSize(384, y)
	return faceNode
end

function RoomChatPopu:sendChatWord()
	local text = self.m_inuptText:getText()
	text = string.ltrim(text)
	if not ToolKit.isValidString(text) then
		AlarmTip.play("输入内容为空")
		return
	end
  	EventDispatcher.getInstance():dispatch(Event.Message, "sendChatWord", text)
	self:dismiss(true)
end

return RoomChatPopu