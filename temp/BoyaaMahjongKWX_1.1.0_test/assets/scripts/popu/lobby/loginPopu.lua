local LoginPopu = class(require("popu.gameWindow"))

function LoginPopu:initView(data)
	--返回
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		self:dismiss()
	end)
	--手机登录
	self:findChildByName("btn_phone"):setOnClick(self, function ( self )
		-- body
		WindowManager:showWindow(WindowTag.TelLoginPopu, {}, WindowStyle.POPUP)
		self:dismiss(true)
	end)
	--微信登录
	self:findChildByName("btn_weixin"):setOnClick(self, function ( self )
		-- body
		GameConfig:setLastUserType(UserType.WeChat)
		GameSocketMgr:closeSocketSync(true)
		self:dismiss(true)
	end)
	--游客登录
	self:findChildByName("btn_vistor"):setOnClick(self, function ( self )
		-- body
		GameConfig:setLastUserType(UserType.Vistor)
		GameSocketMgr:closeSocketSync(true)
		self:dismiss(true)
	end)
	self:shieldFunction()
end

function LoginPopu:shieldFunction()
	local phone = self:findChildByName("btn_phone")
	local wechat = self:findChildByName("btn_weixin")
	local visitor = self:findChildByName("btn_vistor")
	if ShieldData:getAllFlag() then
		if phone then phone:hide() end
		if wechat then wechat:hide() end
		if visitor and phone then visitor:setPos(phone:getPos()) end
	end
end

return LoginPopu
