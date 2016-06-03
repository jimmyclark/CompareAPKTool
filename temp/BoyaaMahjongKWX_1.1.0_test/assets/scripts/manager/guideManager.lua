local GuideInfo = require("guide.guideInfo")
local GuideManager = class()

function GuideManager:ctor()
end

function GuideManager:stop()
end

function GuideManager:needToShowGuideOutCard()
	local outCardTable = MahjongCacheData_getTable("GuideConfig", "showGuideOutCard")
	local curTime = os.time()
	local startTime = outCardTable.iStartTime or 0
	local lastTime = outCardTable.iLastTime or 0
	if (curTime - startTime >= 0 and curTime - startTime <= 3 * 24 * 60 * 60) then
		local tempTable = {}
		tempTable.iStartTime = startTime
		if curTime - lastTime >= 24 * 60 * 60 then
			tempTable.iLastTime = curTime
			MahjongCacheData_setTable("GuideConfig", "showGuideOutCard", tempTable, true)
			return true
		end
	end
	return false
end

-- 显示出牌引导
function GuideManager:showGuideOutCard(flag, rootNode)
	if not flag  then
		if self.m_outCardView then
			self.m_outCardView:removeSelf()
			self.m_outCardView = nil
		end
	else
		if self:needToShowGuideOutCard() then
			if not self.m_outCardView then
				self.m_outCardView = new(Node)
				rootNode:addChild(self.m_outCardView)
				self.m_outCardView:setFillParent(true, true)
				self.m_outCardView:setAlign(kAlignCenter)
				local img_tipsKuang = self:createImageText("【双击】 或 【拖动】要打出的牌")
				self.m_outCardView:addChild(img_tipsKuang)
				local kw, kh = img_tipsKuang:getSize()
				img_tipsKuang:setPos(display.cx + 40, display.cy - kh)
				-- local img_tips = self:createImageTips(1)
				-- self.m_outCardView:addChild(img_tips)
				-- local tw, th = img_tips:getSize()
				-- img_tips:setPos((kw - tw) / 2, kh +10)
				-- local anim = img_tips:addPropTranslate(0, kAnimLoop, 500, -1, 0, 0, 20, 0)
				-- anim:setDebugName("GuideManager : showGuideOutCard")
				local outCardAnim = self.m_outCardView:addPropTransparency(0, kAnimNormal, 4000, -1, 1.0, 1.0)
				outCardAnim:setEvent(self, function(self)
					self.m_outCardView:removeSelf()
					self.m_outCardView = nil
				end)
			end
		end
	end
end

function GuideManager:createImageTips( _type )
	local img_tips = nil
	if 2 == _type then
		img_tips = UIFactory.createImage("kwx_guide/img_tipsRight.png")
	else
	 	img_tips = UIFactory.createImage("kwx_guide/img_tipsBottomBig.png")
	 end
	return img_tips
end

function GuideManager:createImageText( _text )
	local img_tipsKuang = UIFactory.createImage("kwx_guide/img_tipsKuang.png", nil, nil, 40, 40, 40, 40)
	img_tipsKuang:setSize(480, 200)
	local params = {}
	params.text = _text
	params.size = 28
	params.width = 480 - 60
	params.height = 200 - 20
	params.align = kAlignCenter
	-- params.
	-- TextView, params.text, params.size, params.width, params.height, params.align, color.r, color.g, color.b, params.font
	local text_view = UIFactory.createTextView( params )
	img_tipsKuang:addChild(text_view)
	text_view:setAlign(kAlignCenter)
	return img_tipsKuang
end

function GuideManager:needToShowGuideGangCard()
	local gangCardTable = MahjongCacheData_getTable("GuideConfig", "showGuideGangCard")
	local curTime = os.time()
	local startTime = gangCardTable.iStartTime or 0
	local lastTime = gangCardTable.iLastTime or 0
	if (curTime - startTime >= 0 and curTime - startTime <= 3 * 24 * 60 * 60) then
		local tempTable = {}
		tempTable.iStartTime = startTime
		if curTime - lastTime >= 24 * 60 * 60 then
			tempTable.iLastTime = curTime
			MahjongCacheData_setTable("GuideConfig", "showGuideGangCard", tempTable, true)
			return true
		end
	end
	return false
end

-- 显示杠牌引导
function GuideManager:showGuideGangCard(flag, rootNode)
	if not flag then
		if self.m_gangCardView then
			self.m_gangCardView:removeSelf()
			self.m_gangCardView = nil
		end
	else
		if self:needToShowGuideGangCard() then
			if not self.m_gangCardView then
				self.m_gangCardView = new(Node)
				rootNode:addChild(self.m_gangCardView)
				self.m_gangCardView:setFillParent(true, true)
				self.m_gangCardView:setAlign(kAlignCenter)
				local img_tipsKuang = self:createImageText("杠牌可直接获得金币，明杠、暗杠、补杠等详情可查看设置中的帮助")
				self.m_gangCardView:addChild(img_tipsKuang)
				local kw, kh = img_tipsKuang:getSize()
				img_tipsKuang:setAlign(kAlignCenter)
				img_tipsKuang:setPos(0, -280)
				local img_tips = self:createImageTips(1)
				self.m_gangCardView:addChild(img_tips)
				local tw, th = img_tips:getSize()
				img_tips:setAlign(kAlignCenter)
				img_tips:setPos(0, -120)
				local anim = img_tips:addPropTranslate(0, kAnimLoop, 500, -1, 0, 0, 20, 0)
				anim:setDebugName("GuideManager : showGuideOutCard")
				local outCardAnim = self.m_gangCardView:addPropTransparency(0, kAnimNormal, 4000, -1, 1.0, 1.0)
				outCardAnim:setEvent(self, function(self)
					self.m_gangCardView:removeSelf()
					self.m_gangCardView = nil
				end)
			end
		end
	end
end

function GuideManager:needToShowGuideMing()
	local mingTable = MahjongCacheData_getTable("GuideConfig", "showGuideMing")
	local curTime = os.time()
	local startTime = mingTable.iStartTime or 0
	local lastTime = mingTable.iLastTime or 0
	if (curTime - startTime >= 0 and curTime - startTime <= 3 * 24 * 60 * 60) then
		local tempTable = {}
		tempTable.iStartTime = startTime
		if curTime - lastTime >= 24 * 60 * 60 then
			tempTable.iLastTime = curTime
			MahjongCacheData_setTable("GuideConfig", "showGuideMing", tempTable, true)
			return true
		end
	end
	return false
end

-- 显示明牌引导
function GuideManager:showGuideMing(flag, rootNode)
	if not flag then
		if self.m_mingView then
			self.m_mingView:removeSelf()
			self.m_mingView = nil
		end
	else
		if self:needToShowGuideMing() then
			if not self.m_mingView then
				self.m_mingView = new(Node)
				rootNode:addChild(self.m_mingView)
				self.m_mingView:setFillParent(true, true)
				self.m_mingView:setAlign(kAlignCenter)
				local img_tipsKuang = self:createImageText("亮牌后，对手可以看到你的牌，系统自动打牌，不可再换牌，胡牌则番数加倍")
				self.m_mingView:addChild(img_tipsKuang)
				local kw, kh = img_tipsKuang:getSize()
				img_tipsKuang:setAlign(kAlignCenter)
				img_tipsKuang:setPos(0, -280)
				local img_tips = self:createImageTips(1)
				self.m_mingView:addChild(img_tips)
				local tw, th = img_tips:getSize()
				img_tips:setAlign(kAlignCenter)
				img_tips:setPos(0, -120)
				local anim = img_tips:addPropTranslate(0, kAnimLoop, 500, -1, 0, 0, 20, 0)
				anim:setDebugName("GuideManager : showGuideOutCard")
				local outCardAnim = self.m_mingView:addPropTransparency(0, kAnimNormal, 4000, -1, 1.0, 1.0)
				outCardAnim:setEvent(self, function(self)
					self.m_mingView:removeSelf()
					self.m_mingView = nil
				end)
			end
		end
	end
end

function GuideManager:needToShowGuideSelectPiao()
	local selectPiao = MahjongCacheData_getInt("GuideConfig", "showGuideSelectPiao", 0)
	if selectPiao >= 1 and selectPiao <= 3 then
		selectPiao = selectPiao + 1
		MahjongCacheData_setInt("GuideConfig", "showGuideSelectPiao", selectPiao, true)
		return true
	end
	return false
end

-- 显示选漂引导
function GuideManager:showGuideSelectPiao(flag, rootNode)
	if not flag then
		if self.m_selectPiaoView then
			self.m_selectPiaoView:removeSelf()
			self.m_selectPiaoView = nil
		end
	else
		if self:needToShowGuideSelectPiao() then
			if not self.m_selectPiaoView then
				self.m_selectPiaoView = new(Node)
				rootNode:addChild(self.m_selectPiaoView)
				self.m_selectPiaoView:setFillParent(true, true)
				self.m_selectPiaoView:setAlign(kAlignCenter)
				local img_tipsKuang = self:createImageText("点击选择“漂”的数量，可多赢金币哦！")
				self.m_selectPiaoView:addChild(img_tipsKuang)
				local kw, kh = img_tipsKuang:getSize()
				img_tipsKuang:setAlign(kAlignCenter)
				img_tipsKuang:setPos(0, -280)
				local img_tips = self:createImageTips(1)
				self.m_selectPiaoView:addChild(img_tips)
				local tw, th = img_tips:getSize()
				img_tips:setAlign(kAlignCenter)
				img_tips:setPos(0, -120)
				local anim = img_tips:addPropTranslate(0, kAnimLoop, 500, -1, 0, 0, 20, 0)
				anim:setDebugName("GuideManager : showGuideOutCard")
				local outCardAnim = self.m_selectPiaoView:addPropTransparency(0, kAnimNormal, 4000, -1, 1.0, 1.0)
				outCardAnim:setEvent(self, function(self)
					self.m_selectPiaoView:removeSelf()
					self.m_selectPiaoView = nil
				end)
			end
		end
	end
end

function GuideManager:needToShowGuideClickPlayer()
	local clickPlayerTable = MahjongCacheData_getTable("GuideConfig", "showGuideClickPlayer")
	local curTime = os.time()
	local startTime = clickPlayerTable.iStartTime or 0
	local lastTime = clickPlayerTable.iLastTime or 0
	printInfo("needToShowGuideClickPlayer : startTime : %s, lastTime : %s, curTime : %s", startTime, lastTime, curTime)
	-- local todayTimes = clickPlayerTable.iTodayTimes or 0
	if (curTime - startTime >= 0 and curTime - startTime <= 3 * 24 * 60 * 60) then
		local tempTable = {}
		tempTable.iStartTime = startTime
		tempTable.iLastTime = curTime
		-- tempTable.iTodayTimes = todayTimes + 1
		if curTime - lastTime >= 24 * 60 * 60 then
			printInfo("tempTable.iStartTime : %s, tempTable.iLastTime : %s", tempTable.iStartTime, tempTable.iLastTime)
			-- if tempTable.iTodayTimes <= 2 then
				MahjongCacheData_setTable("GuideConfig", "showGuideClickPlayer", tempTable, true)
				local clickPlayerTable = MahjongCacheData_getTable("GuideConfig", "showGuideClickPlayer")
				printInfo("clickPlayerTable.iStartTime : %s, clickPlayerTable.iLastTime : %s", clickPlayerTable.iStartTime, clickPlayerTable.iLastTime)
			-- end
			-- if tempTable.iTodayTimes == 2 then
				return true
			-- end
		end
	end
	return false
end

-- 显示点击房间人物引导
function GuideManager:showGuideClickPlayer(flag, rootNode)
	if not flag then
		if self.m_clickPlayerView then
			self.m_clickPlayerView:removeSelf()
			self.m_clickPlayerView = nil
		end
	else
		if self:needToShowGuideClickPlayer() then
			if not self.m_clickPlayerView then
				self.m_clickPlayerView = new(Node)
				rootNode:addChild(self.m_clickPlayerView)
				self.m_clickPlayerView:setFillParent(true, true)
				self.m_clickPlayerView:setAlign(kAlignCenter)
				local img_tipsKuang = self:createImageText("点击对手可查看资料还可以送鲜花、扔鸡蛋哦！")
				self.m_clickPlayerView:addChild(img_tipsKuang)
				local kw, kh = img_tipsKuang:getSize()
				img_tipsKuang:setAlign(kAlignCenter)
				img_tipsKuang:setPos(-400, -70)
				local img_tips = self:createImageTips(2)
				self.m_clickPlayerView:addChild(img_tips)
				local tw, th = img_tips:getSize()
				img_tips:setAlign(kAlignCenter)
				img_tips:setPos(-100, -70)
				local anim = img_tips:addPropTranslate(0, kAnimLoop, 500, -1, 10, 0, 0, 0)
				anim:setDebugName("GuideManager : showGuideOutCard")
				local outCardAnim = self.m_clickPlayerView:addPropTransparency(0, kAnimNormal, 4000, -1, 1.0, 1.0)
				outCardAnim:setEvent(self, function(self)
					self.m_clickPlayerView:removeSelf()
					self.m_clickPlayerView = nil
				end)
			end
		end
	end
end

function GuideManager:initGuideCoinfig()
	local isHas = MahjongCacheData_getInt("GuideConfig", "isHasGuide", 0)
	if 1 ~= isHas then
		MahjongCacheData_setInt("GuideConfig", "isHasGuide", 1, true)
		local curTime = os.time()
		local tempTable = {}
		tempTable.iStartTime = curTime
		MahjongCacheData_setTable("GuideConfig", "showGuideOutCard", tempTable, true)
		MahjongCacheData_setTable("GuideConfig", "showGuideGangCard", tempTable, true)
		MahjongCacheData_setTable("GuideConfig", "showGuideMing", tempTable, true)
		MahjongCacheData_setInt("GuideConfig", "showGuideSelectPiao", 1, true)
		MahjongCacheData_setTable("GuideConfig", "showGuideClickPlayer", tempTable, true)
	end
end

function GuideManager:clearGuideConfig()
	local isHas = MahjongCacheData_getInt("GuideConfig", "isHasGuide", 0)
	if 1 == isHas then
		MahjongCacheData_setInt("GuideConfig", "isHasGuide", 0, true)
	end
end

return GuideManager