
local BroadcastPaoMaDeng = class()

function BroadcastPaoMaDeng:ctor()
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)
	self.m_broadcastTable = {}
	self.m_newHornInfo = {}
	self.m_delegate = nil
	self.m_view = nil
	self.m_isShow = false
end

function BroadcastPaoMaDeng:dtor()
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
	self.m_broadcastTable = {}
	self.m_newHornInfo = {}
end

function BroadcastPaoMaDeng:setDelegate(_delegate, _view)
	self.m_delegate = _delegate
	self.m_view = _view
	self.m_isShow = false
	if #self.m_broadcastTable > 0 then
		self:showMsg()
	end
end

function BroadcastPaoMaDeng:clearDelegate(_delegate)
	if self.m_delegate ~= _delegate then
		return
	end
	self.m_delegate = nil
	self.m_view = nil
end

function BroadcastPaoMaDeng:addMsg(data)
	printInfo("data.iMsgTimes : %d", data.iMsgTimes)
	for i = 1, data.iMsgTimes do
		self.m_broadcastTable[#self.m_broadcastTable + 1] = data

		if table.getn(self.m_newHornInfo) >= 50 then
			table.remove(self.m_newHornInfo, 50)
		end
		table.insert(self.m_newHornInfo, 1, data)
		
	end
end

function BroadcastPaoMaDeng:showMsg()
	local data = self.m_broadcastTable[1]
	if self.m_isShow or not data then
		if self.m_view then
			--self.m_view:hide()
		end
		return
	end
	if not self.m_delegate or not self.m_view then
		printInfo("没有这个")
		return
	end
	table.remove(self.m_broadcastTable, 1)
	self.m_isShow = true
	local img_paomadeng = self.m_view:findChildByName("img_paomadeng")
	self.m_view:show()
	local ix , iy = img_paomadeng:getSize()
	local textView = new(TextView, data.iMsg, ix - 2 * 60, 27, kAlignTopLeft, nil, 26, 0xFF, 0xFF, 0xFF)
	-- local msg = "你说是不是一样的，我真的不相信，还是说真的不是一样的你知道吗？我不是很知道"
	-- local textView = new(TextView, msg, ix - 2 * 60, 27, kAlignTopLeft, nil, 26, 0xFF, 0xFF, 0xFF)
	textView:setScrollBarWidth(0)
	textView:setPos(60 , (iy - 27) / 2)
	textView:setPickable(false)

	img_paomadeng:addChild(textView)
	textView:setClip(60, (iy - 27) / 2, ix - 2 * 60, 28)
	local resy = textView.m_res:getHeight()
	local hangNum, xiaoshu = math.modf(resy / 27)
	hangNum = hangNum + (xiaoshu >= 0.70 and 1 or 0)
	self:playAnim(textView, hangNum, 1)
end

function BroadcastPaoMaDeng:playAnim(textView, totalHang, curHang)
	local translateAnim = textView:addPropTranslate(0, kAnimNormal , 150 ,2000 , 0, 0, 0 , 0)
	translateAnim:setDebugName("BroadcastPaoMaDeng self.translateAnim");
	if 1 == totalHang or totalHang == curHang then
		translateAnim:setEvent(self, function(self)
			textView:removeProp(0)
			delete(textView)
			self.m_isShow = false
			self:showMsg()
		end)
	else
		translateAnim:setEvent(self, function(self)
			textView:removeProp(0)
			textView:setPos(60, -21 * curHang)
			local ix , iy = self.m_view:findChildByName("img_paomadeng"):getSize()
			textView:setClip(60, (iy - 27) / 2, ix - 2 * 60, 28)
			self:playAnim(textView, totalHang, curHang + 1)
		end)
	end
end

function BroadcastPaoMaDeng:onServerBroadcastPaoMaDeng(data)
	printInfo("BroadcastPaoMaDeng:onServerBroadcastPaoMaDeng")
	if not data then
		return
	end
	self:addMsg(data)
	self:showMsg()
end

function BroadcastPaoMaDeng:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

function BroadcastPaoMaDeng:getHornInofTable( ... )
	-- body
	return self.m_newHornInfo;
end

BroadcastPaoMaDeng.commandFunMap = {
	[Command.SERVERGB_BROADCAST_PAOMADENG]	= BroadcastPaoMaDeng.onServerBroadcastPaoMaDeng, -- 广播跑马灯
}

return BroadcastPaoMaDeng