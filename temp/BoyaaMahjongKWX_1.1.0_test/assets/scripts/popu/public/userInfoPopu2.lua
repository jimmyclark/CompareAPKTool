local UserInfoPopu2 = class(require("popu.gameWindow"))

function UserInfoPopu2:initView(data)

	-- self.m_userData = data.userData
	-- self.m_gameData = data.gameData

	-- self.m_faceView = {}
	-- self:updateView(data)
	-- self:shieldFunction()
end

function UserInfoPopu2:updateView(data)

	local userData = data.data
	if not userData then return end

	local total = userData.wintimes + userData.losetimes + userData.drawtimes
	local rate = total == 0 and 0 or userData.wintimes / total 

	self.m_root:findChildByName("name_text"):setText(userData.mnick)
	self.m_root:findChildByName("id_text"):setText(userData.mid)
	self.m_root:findChildByName("level_text"):setText(userData.level)
	self.m_root:findChildByName("gold_text"):setText(userData.money)
	self.m_root:findChildByName("zhanji_text"):setText(string.format("%d胜%d负%d平", userData.wintimes, userData.losetimes, userData.drawtimes))
	self.m_root:findChildByName("rate_text"):setText(string.format("%.01f%%", rate * 100))
	self.m_root:findChildByName("huaFei_text1"):setText(userData.coupons)
	if not self.m_headImage then
		local headView = self.m_root:findChildByName("head_view")
		-- local w , h = headView:getSize()
		local imgHead = tonumber(userData.sex) == 0 and "kwx_common/img_manHead.png" or "kwx_common/img_womanHead.png"
		local headImage = new(Mask, imgHead, imgHead);
		headImage:setSize(254, 254);
		headImage:addTo(headView)
			:align(kAlignCenter)
		self.m_headImage = headImage
	else
		-- self.m_headImage:setFile(userData:getHeadName())
	end
	local img = tonumber(userData.sex) == 0 and "kwx_common/img_man.png" or "kwx_common/img_woman.png"
	self.m_root:findChildByName("sex_icon"):setFile(img)
end

function UserInfoPopu2:shieldFunction()
	local huafei = self:findChildByName("huaFei_view")
	if ShieldData:getAllFlag() then
		if huafei then huafei:hide() end
	end
end

function UserInfoPopu2:onGetUserInfoResponse( data )
	-- body
	self:updateView( data )
end

UserInfoPopu2.s_severCmdEventFuncMap = {
    [Command.USERINFO_GET_PHP_REQUEST]                = UserInfoPopu2.onGetUserInfoResponse,
}

return UserInfoPopu2
