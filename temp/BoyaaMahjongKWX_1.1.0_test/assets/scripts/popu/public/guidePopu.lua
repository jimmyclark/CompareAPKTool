--[[
	新手教程弹窗
]]
local GuidePopu = class(require("popu.gameWindow"))
local animTime = 200

function GuidePopu:initView(data)
	self:findChildByName("close_btn"):setOnClick(nil, function()
		self:dismiss()		
	end)
	data = data or {}
	local gameType = data.gameType or GameType.GBMJ

	local firstGirl = self:findChildByName("shmj_girl")
	firstGirl:setEventTouch(self, self.onTouch)
	local secondGirl = self:findChildByName("gdmj_girl")
	secondGirl:setEventTouch(self, self.onTouch)
	local thirdGirl = self:findChildByName("gbmj_girl")
	thirdGirl:setEventTouch(self, self.onTouch)

	local leftArrow = self:findChildByName("arrow_left")
	local rightArrow = self:findChildByName("arrow_right")
	leftArrow:setOnClick(self, self.onLeftArrowClick)
	rightArrow:setOnClick(self, self.onRightArrowClick)

	self:findChildByName("quick_start_btn"):setOnClick(nil, function()
		local levelConfig = MyLevelConfigData:getSuggestLevelConfigVarMoney()
			if levelConfig then
				app:requestEnterRoom(levelConfig:getLevel(), true)
			end
	end)
	-- 选中状态
	self.m_selected = 2
	-- 动画标记
	self.m_anim = nil

	if gameType == GameType.GBMJ then
		self.m_views = {
			self:findChildByName("shmj_circle"),
			self:findChildByName("gbmj_circle"),
			self:findChildByName("gdmj_circle"),
		}
		self.m_girls = {
			self:findChildByName("shmj_girl"),
			self:findChildByName("gbmj_girl"),
			self:findChildByName("gdmj_girl"),
		}
		self.m_tips = {
			"你喜欢上海麻将吗?",
			"你喜欢国标麻将吗?",
			"你喜欢广东麻将吗?",
		}
		self.m_gameType = {
			GameType.SHMJ,
			GameType.GBMJ,
			GameType.KWXMJ,
		}
	elseif gameType == GameType.KWXMJ then
		self.m_views = {
			self:findChildByName("shmj_circle"),
			self:findChildByName("gdmj_circle"),
			self:findChildByName("gbmj_circle"),
		}
		self.m_girls = {
			self:findChildByName("shmj_girl"),
			self:findChildByName("gdmj_girl"),
			self:findChildByName("gbmj_girl"),
		}
		self.m_tips = {
			"你喜欢上海麻将吗?",
			"你喜欢广东麻将吗?",
			"你喜欢国标麻将吗?",
		}
		self.m_gameType = {
			GameType.SHMJ,
			GameType.KWXMJ,
			GameType.GBMJ,
		}
	else
		self.m_views = {
			self:findChildByName("gdmj_circle"),
			self:findChildByName("shmj_circle"),
			self:findChildByName("gbmj_circle"),
		}
		self.m_girls = {
			self:findChildByName("gdmj_girl"),
			self:findChildByName("shmj_girl"),
			self:findChildByName("gbmj_girl"),
		}
		self.m_tips = {
			"你喜欢广东麻将吗?",
			"你喜欢上海麻将吗?",
			"你喜欢国标麻将吗?",
		}
		self.m_gameType = {
			GameType.KWXMJ,
			GameType.SHMJ,
			GameType.GBMJ,
		}
	end
	self.m_srcTb = {1, 2, 3}
	self.m_posXTb = {-300, 0, 300}
	
	-- 第一个和第三个缩放
	self.m_views[1]:addPropScaleSolid(102, 0.75, 0.75, kCenterXY, 160, -120)
	self.m_views[1]:addPropTransparency(103, kAnimNormal, animTime, 0, 1.0, 0.6)
	self.m_views[1]:pos(self.m_posXTb[1])
	
	
	self.m_views[2]:addPropScaleSolid(102, 1.16, 1.16, kCenterXY, 160, -120)
	self.m_views[2]:pos(self.m_posXTb[2])

	self.m_views[3]:addPropScaleSolid(102, 0.75, 0.75, kCenterXY, 160, -120)
	self.m_views[3]:addPropTransparency(103, kAnimNormal, animTime, 0, 1.0, 0.6)
	self.m_views[3]:pos(self.m_posXTb[3])

	self:findChildByName("tip_text"):setText(self.m_tips[2])
	self.touchIndex = nil

	self:findChildByName("qipao"):addPropScaleWithEasing(101, kAnimNormal, animTime, 0, 'easeOutBack', 'easeOutBack', 0.2, 0.8, kCenterXY, 350, 100)
end

function GuidePopu:onLeftArrowClick()
	self:onSelectGirl(self.m_selected % 3 + 1)
end

function GuidePopu:onRightArrowClick()
	self:onSelectGirl((self.m_selected + 1) % 3 + 1)
end

function GuidePopu:onTouch(finger_action, x, y, drawing_first, drawing_current)
	printInfo("finger_action = %d", finger_action)
	local view

	if finger_action == kFingerDown then
		self.startX = x
		self.touchIndex = nil
		for i,v in ipairs(self.m_girls) do
			if drawing_first == v.m_drawingID then
				self.touchIndex = i
				break
			end
		end
		kEffectPlayer:play(Effects.AudioButtonClick);
	elseif finger_action == kFingerUp then
		if x > self.startX then
			self:onRightArrowClick()
		elseif x < self.startX then
			self:onLeftArrowClick()
		elseif self.touchIndex then
			self:onSelectGirl(self.touchIndex)
		end
	end
end

function GuidePopu:onSelectGirl(index)
	if self.m_anim then return end
	if self.m_selected == index then 
		printInfo("m_selected == index")
		return
	end
	printInfo("onSelectGirl")
	local function getSortTb(selectIndex)
		if selectIndex == 1 then
			return {3, 1, 2}
		elseif selectIndex == 2 then
			return {1, 2, 3}
		elseif selectIndex == 3 then
			return {2, 3, 1}
		end
	end

	self:findChildByName("qipao"):hide()
	self.m_srcTb = getSortTb(self.m_selected)
	self.m_dstTb = getSortTb(index)
	-- 将m_srcTb位置
	self.m_anim = true
	for i, index1 in ipairs(self.m_srcTb) do
		for j, index2 in ipairs(self.m_dstTb) do
			if index1 == index2 then
				-- 将self.m_views[index1] 从 i 移动到j 的位置
				local view = self.m_views[index1]
				if index2 == index then
					view:setLevel(3)
				else
					view:setLevel(2)
				end
				local posX = self.m_posXTb[j]
				local diffX = 0
				local prePosX = view:getPos()
				view:pos(posX, nil)
				-- 移动
				checkAndRemoveOneProp(view, 101)
				local anim = view:addPropTranslate(101, kAnimNormal, animTime * 2, 0, prePosX - posX, 0, 0, 0)
				anim:setEvent(nil, function()
					checkAndRemoveOneProp(view, 101)
				end)

				-- 从1-3 3-1
				-- 缩放
				if (i==1 and j==3) or (i==3 and j==1) then
					view:setLevel(1)
					checkAndRemoveOneProp(view, 102)
					local anim = view:addPropScale(102, kAnimNormal, animTime, 0, 0.75, 0.45, 0.75, 0.45, kCenterXY, 160, -120)
					anim:setEvent(nil, function()
						checkAndRemoveOneProp(view, 102)
						anim = view:addPropScale(102, kAnimNormal, animTime, 0, 0.45, 0.75, 0.45, 0.75, kCenterXY, 160, -120)
						anim:setEvent(nil, function()
							self:onSelectEnd(index)
						end)
					end)
				elseif i== 2 then
					checkAndRemoveOneProp(view, 102)
					view:addPropScale(102, kAnimNormal, animTime * 2, 0, 1.16, 0.75, 1.16, 0.75, kCenterXY, 160, -120)
					checkAndRemoveOneProp(view, 103)
					view:addPropTransparency(103, kAnimNormal, animTime * 2, 0, 1.0, 0.6)
				elseif j == 2 then
					checkAndRemoveOneProp(view, 102)
					view:addPropScale(102, kAnimNormal, animTime * 2, 0, 0.75, 1.16, 0.75, 1.16, kCenterXY, 160, -120)
					checkAndRemoveOneProp(view, 103)
					view:addPropTransparency(103, kAnimNormal, animTime * 2, 0, 0.6, 1.0)
				end
			end
		end
	end
end

function GuidePopu:onSelectEnd(index)
	self.m_selected = index
	self.m_anim = false
   	EventDispatcher.getInstance():dispatch(Event.Message, "SelectGameType", self.m_gameType[index])
	self:findChildByName("tip_text"):setText(self.m_tips[index])
	local qipao = self:findChildByName("qipao") 
	qipao:show()
	checkAndRemoveOneProp(qipao, 101)
	self:findChildByName("qipao"):addPropScaleWithEasing(101, kAnimNormal, animTime, 0, 'easeOutBack', 'easeOutBack', 0.2, 0.8, kCenterXY, 350, 100)
end

return GuidePopu