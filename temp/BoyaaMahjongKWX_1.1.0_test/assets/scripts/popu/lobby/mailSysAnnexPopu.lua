local mailSysAnnexPopu = class(require("popu.gameWindow"))


function mailSysAnnexPopu:ctor()
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)
end

function mailSysAnnexPopu:dtor()
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
end

function mailSysAnnexPopu:initView(data)

	-- 返回按钮
	self:findChildByName("btn_close"):setOnClick(self, function( )
		-- body
		self:dismiss();
	end)

	self:findChildByName("btn_mid"):setOnClick(self, function( )
		-- 领取
		if 2 == data:getType() then
			GameSocketMgr:sendMsg(Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST, { ["id"] = data:getId() }, true)
		else 
			self:dismiss();
		end
	end)
	
	self:findChildByName("text_title"):setText(ToolKit.formatNick(data:getTitle(), 12))
	self:findChildByName("textview_content"):setText(data:getContent())

	local text_midName = self:findChildByName("text_midName")
	if 1 == data:getType() then
		text_midName:setText("知道了")
	elseif 2 == data:getType() then
		text_midName:setText("领取")
	end
end

function mailSysAnnexPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return mailSysAnnexPopu.super.dismiss(self, ...)
end

function mailSysAnnexPopu:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

function mailSysAnnexPopu:onGetSystemAwardMsgResponse( msgid )
	local count = MyMailSystemData:count()
	for i = 1, count do
		local item = MyMailSystemData:get(i)
		if item:getId() == msgid then
			if 2 == item:getType() then
				self:findChildByName("text_midName")
					:setText("已领")
			    self:findChildByName("btn_mid"):setIsGray(true)
			end	
		end
	end
		
end
--[[
	通用的（大厅）协议
]]
mailSysAnnexPopu.s_severCmdEventFuncMap = {
    [Command.MAIL_GET_SYSTEMMSG_AWARD_PHPREQUEST]	= mailSysAnnexPopu.onGetSystemAwardMsgResponse,
}

mailSysAnnexPopu.commandFunMap = {
}

return mailSysAnnexPopu