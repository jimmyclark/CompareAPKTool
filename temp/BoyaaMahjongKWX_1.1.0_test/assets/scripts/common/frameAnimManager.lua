

local FrameAnimManager = class()

function FrameAnimManager:ctor()
	self.m_timerTable = {}
end

function FrameAnimManager:dtor()
	for i = 1, #self.m_timerTable do
		delete(self.m_timerTable[i].animTimer)
	end
	self.m_timerTable = {}
end

function FrameAnimManager:playAnim(_type, node)
	if not _type or not FrameAnimManager.m_configTable[_type] then
		return
	end
	-- if _type ~= FrameAnimManager.m_ctr.iLevelUpTwo then return end
	local animInfo = FrameAnimManager.m_configTable[_type]
	local count = animInfo.count or 0
	local animType = animInfo.animType or kAnimNormal
	local fileName = animInfo.fileName or ""
	local animTime = animInfo.animTime or 2000
	local animDelay = animInfo.animDelay or -1
	local animInterval = animInfo.animInterval or 0
	local imgTable = {}
	for i = 1, count do
		local nameStr = string.format(fileName, i)
		if nameStr then
			table.insert(imgTable, nameStr)
		end
	end
	-- 如果没有图片
	if #imgTable <= 0 then
		return
	end
	local animIntervalCount = math.floor(animInterval / (animTime / #imgTable))
	local posx = animInfo.posx or 0
	local posy = animInfo.posy or 0
	local align = animInfo.align
	local notrelease = animInfo.notrelease
	local animRev = false
	local animIndex = 0
	local animImages = UIFactory.createImages(imgTable)
	animImages:setPos(posx, posy)
	if align then animImages:setAlign(align) end
	if not node then 
		animImages:addToRoot()
	else 
		node:addChild(animImages) 
	end
	-- self, animType, startValue, endValue, duration, delay
	local tempAnim = new(AnimDouble, kAnimRepeat, 0, 1, animTime / #imgTable, animDelay)
	local timerIndex = #self.m_timerTable + 1
	self.m_timerTable[timerIndex] = {}
	self.m_timerTable[timerIndex].animTimer = tempAnim
	self.m_timerTable[timerIndex].animNode  = node
	self.m_timerTable[timerIndex].animType 	= _type
	self.m_timerTable[timerIndex].animImages = animImages

	local animDtor = animImages.dtor
	animImages.dtor = function(animImages)
		for k, v in pairs(self.m_timerTable) do
			if v.animTimer == tempAnim then
				delete(v.animTimer)
				table.remove(self.m_timerTable, k)
				break
			end
		end
	end

	tempAnim:setEvent(self, function(self)
		if animType == kAnimRepeat then
			animIndex = animIndex + 1
			-- printInfo("animIndex %d", animIndex)
			if animIndex >= #imgTable then
				animImages:hide()
				if animIndex == #imgTable + animIntervalCount then
					animIndex = 0
					animImages:show()
					animImages:setImageIndex(animIndex)
				end 
			else
				animIndex = animIndex % #imgTable
				animImages:setImageIndex(animIndex)
			end
		elseif animType == kAnimLoop then
			-- 暂时不处理loop类型
			if animRev then
				animIndex = (animIndex - 1) % #imgTable
				animImages:setImageIndex(animIndex)
				if animIndex == 0 then animRev = false end
			else
				animIndex = (animIndex + 1) % #imgTable
				animImages:setImageIndex(animIndex)
				if animIndex == #imgTable - 1 then animRev = true end
			end
		else
			if animIndex + 1 == #imgTable then
				delete(tempAnim)
				tempAnim = nil
				-- printInfo("jisdnsdnsidsndsndsnid")
				if animImages and not notrelease then
					-- printInfo("jisdnsdnsidsndsndsnid111")
					delete(animImages) 
				end
				return
			end
			animIndex = (animIndex + 1) % #imgTable
			animImages:setImageIndex(animIndex)
		end
	end)
end

function FrameAnimManager:clearAnim(_type, node)
	if not _type then
		return
	end
	for k, v in pairs(self.m_timerTable) do
		if v.animType == _type and node == v.animNode then
			delete(v.animTimer)
			-- delete(v.animImages)
			table.remove(self.m_timerTable, k)
			break
		end
	end
end

function FrameAnimManager:playLobbyQuickStartAnim(  )
	
end

FrameAnimManager.m_ctr = {
	iLobbySelectType = 1,
	iLobbyBottom = 2,
	iLobbyQuick = 3,
	iLevelUp = 4,
	iLevelUpTwo = 5,
}

FrameAnimManager.m_configTable = {
	[FrameAnimManager.m_ctr.iLobbySelectType] = {
		fileName = "kwx_anim/lobbySelect/img_select%d.png",
		count = 8,
		animType = kAnimRepeat,
		animTime = 800,
		animDelay = 500,
		align = kAlignCenter,
		animInterval = 5000,
	},
	[FrameAnimManager.m_ctr.iLobbyBottom] = {
		fileName = "kwx_anim/lobbyBottom/buttom%d.png",
		count = 14,
		animType = kAnimRepeat,
		animTime = 1200,
		animDelay = 400,
		align = kAlignBottom,
		animInterval = 5000,
	},
	[FrameAnimManager.m_ctr.iLobbyQuick] = {
		fileName = "kwx_anim/lobbyQuick/img_quick%d.png",
		count = 13,
		animType = kAnimNormal,
		animTime = 1000,
		animDelay = -1,
		animDelay = 1400,
		align = kAlignTop,
	},
	[FrameAnimManager.m_ctr.iLevelUp] = {
		fileName = "kwx_anim/levelUp/levelUp%d.png",
		count = 7,
		animType = kAnimNormal,
		animTime = 1000,
		animDelay = -1,
		align = kAlignCenter,
		notrelease = true,
	},
	[FrameAnimManager.m_ctr.iLevelUpTwo] = {
		fileName = "kwx_anim/levelUp/img_light%d.png",
		count = 14,
		animType = kAnimNormal,
		animTime = 3000,
		animDelay = 500,
		align = kAlignCenter,
	},
}

return FrameAnimManager