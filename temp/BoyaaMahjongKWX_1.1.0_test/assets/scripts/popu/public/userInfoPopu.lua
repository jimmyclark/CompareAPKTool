local UserInfoPopu = class(require("popu.gameWindow"))

function UserInfoPopu:initView(data)
	self.m_userData = data.userData
	self.m_gameData = data.gameData

	self.m_faceView = {}
	self.m_showLevel = nil  -- 记录当前显示的哪个level的道具
	self:updateView(data)
	self:shieldFunction()
end

function UserInfoPopu:freshPropView()
	if self.m_showLevel == G_RoomCfg:getLevel() then return end
	local level = G_RoomCfg:getLevel()

	self.m_faceView = {}
	local faceViews = {}
	for i=1, 5 do
		faceViews[i] = self.m_root:findChildByName(string.format("face_%d", i))
			:hide()
	end
	local propData = MyPropData:getConfigByLevel(level)
	printInfo("propData : ")
	dump(propData)
	if propData then
		--本地支持
		self.m_showLevel = level
		local propList = propData:getPropList()
		for i, prop in pairs(propList) do
			-- 如果配置里面支持
			if #self.m_faceView > 5 then break end
			local propId = prop.pid
			local money = prop.money
			local imageName = PropImages[propId]
			local index = #self.m_faceView + 1
			local faceView = faceViews[index]
			if faceView and propData:getPropById(propId) and imageName then
				faceView:show()
				local iconNode = faceView:findChildByName(string.format("face_img%d", index))
				local child = iconNode:getChildByName("icon")
				if child then iconNode:removeChild(child, true) end
				local image = UIFactory.createImage("kwx_tanKuang/roomUserinfo/"..string.format("img_%d.png",propId))
					:addTo(iconNode)
					:align(kAlignCenter)
				image:setName("icon")

				faceView:findChildByName("gold_text")
					:setText(money)
				local sendBtn = faceView:findChildByName("send_btn")
				sendBtn:setOnClick(nil, function()
					local propCanUse = PhpManager:getPropCanUse()
					if propCanUse == 0 then  --未下载
						AlarmTip.play("开始下载互动道具资源")
						PhpManager:setPropCanUse(2)
						
 						NativeEvent.getInstance():downloadFile("image", ConnectModule:getInstance():getFriendsAnimUrl(), "friendsAnim.zip", "道具");
 						---- NativeEvent.getInstance():downloadFile("image", HallConfig:getFriendsAnimUrl(), "friendsAnim.zip", "道具");
					elseif propCanUse == 2 then -- 正在下载
						AlarmTip.play("道具正在下载中，请稍后")
					elseif self.m_userData:getId() == MyUserData:getId() then
						AlarmTip.play("不能给自己发送")
					elseif self.m_gameData:getIsExist() ~= 1 then
						AlarmTip.play("该玩家不在座位上，无法发送道具")
					elseif propData:getLimit() > MyUserData:getMoney() then
						AlarmTip.play(string.format("持有金币大于%d金币才能使用道具！", propData:getLimit()))
					elseif money > MyUserData:getMoney() then
						AlarmTip.play(string.format("金币不足%d,不能使用该道具！", money))
					else
						-- 用户是否在线
						GameSocketMgr:sendMsg(Command.UserProp, {
							a_uid = MyUserData:getId(),
							p_id  = propId,
							b_uid = self.m_userData:getId(),
						})
						self:dismiss(true)
					end
				end)
				table.insert(self.m_faceView, faceView)
			elseif faceView then
				faceView:hide()
			end
		end
	else
		GameSocketMgr:sendMsg(Command.PROP_PHP_REQUEST, {level = level}, false)
	end
end

function UserInfoPopu:updateView(data)
	self:freshPropView()

	local userData = data.userData
	local gameData = data.gameData
	if not userData then return end
	self.m_userData = userData
	self.m_gameData = gameData
	for i,v in ipairs(self.m_faceView) do
		if v:getVisible() then
			v:findChildByName("icon"):setIsGray(userData:getId() == MyUserData:getId())
			v:findChildByName("send_btn"):setIsGray(userData:getId() == MyUserData:getId())
			v:findChildByName("gold_icon"):setIsGray(userData:getId() == MyUserData:getId())
			-- local color = c3b(255, 255, 255)
			-- v:findChildByName("gold_text"):setColor(color.r, color.g, color.b)
			local width1 = v:findChildByName("gold_icon"):getSize()
			local width2 = v:findChildByName("gold_text"):getSize()
			printInfo("width2 = %d", width2)
			v:findChildByName("gold_view"):setSize(width1 + width2)
		end
	end

	self.m_root:findChildByName("name_text"):setText(userData:getFormatNick(21))
	self.m_root:findChildByName("id_text"):setText(userData:getId())
	self.m_root:findChildByName("level_text"):setText(userData:getLevel())
	self.m_root:findChildByName("gold_text"):setText(userData:getSkipMoney())
	self.m_root:findChildByName("zhanji_text"):setText(string.format("%d胜%d负%d平", userData:getZhanji()))
	self.m_root:findChildByName("rate_text"):setText(userData:getZhanjiRate())
	self.m_root:findChildByName("huaFei_text1"):setText(userData:getHuaFei())
	if not self.m_headImage then
		local headView = self.m_root:findChildByName("head_view")
		-- local w , h = headView:getSize()
		local headImage = new(Mask, userData:getHeadName(), "kwx_uesrInfo/mask_head.png");
		headImage:setSize(254, 254);
		headImage:addTo(headView)
			:align(kAlignCenter)
		self.m_headImage = headImage
	else
		self.m_headImage:setFile(userData:getHeadName())
	end
	local img = userData:getSex() == 0 and "kwx_common/img_man.png" or "kwx_common/img_woman.png"
	self.m_root:findChildByName("sex_icon"):setFile(img)
end

function UserInfoPopu:shieldFunction()
	local huafei = self:findChildByName("huaFei_view")
	if ShieldData:getAllFlag() then
		if huafei then huafei:hide() end
	end
end

return UserInfoPopu
