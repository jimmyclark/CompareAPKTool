local AnimManager = class(Node)
local printInfo, printError = overridePrint("AnimManager")

AnimationTag = {
	-- 动画类，   
	RoomStart    = 2,
	ShaiZi 	     = 2,
	Operate      = 3,
	AnimFade  = 4,
	RoomEnd      = 4,
	AnimShake    = 21,
	AnimTemplate = 22,
}

AnimationConfig = {				--    fileName  level  isSingle autoRemove  
	[AnimationTag.AnimTemplate] = { "animTemplate", 1,	false, 	true},
	[AnimationTag.AnimShake] 	= { "animShake", 	2,  false, 	true},
	[AnimationTag.AnimFade] 	= { "animFade", 3,  false, 	true},
	[AnimationTag.ShaiZi]		= { "animShaiziAnim", 2, false, true},
	[AnimationTag.Operate]		= { "operateAnim", 2, false, true},
}

function AnimManager:ctor()
	self:addToRoot()
	self:setLevel(50)
end

function AnimManager:play(tag, params, ...)
	local config = AnimationConfig[tag]
	if not config then return end
	local clsName, level, isSingle, autoRemove = unpack(config)
	local anim = self:getChildByName(tag)
	-- 如果是单例动画 且还在播放就释放一次
	if isSingle and anim then
		anim:play(params)
		return
	end
	local cls = require("animation." .. clsName)
	if cls then
		local anim = new(cls)
		anim:setName(tag)
		anim:setLevel(level)
		anim:play(params)
		self:addChild(anim)
		return anim
	end
end

function AnimManager:removeAnimByTag(animTag)
	local animNode = self:getChildByName(animTag)
	if animNode then
		animNode:removeSelf()
	end
end

function AnimManager:removeAnimByTagTb(tb)
	for i, animTag in ipairs(tb) do
		self:removeAnimByTag(animTag)
	end
end

-- 一般在界面切换的时候调用 自动销毁该区间的动画
function AnimManager:releaseAnimByTag(startTag, endTag)
	printInfo("releaseAnimByTag")
	for tag=startTag, endTag do
		printInfo("releaseAnimByTag = %d", tag)
		local child = self:getChildByName(tag)
		if child then
			child:release()
		end
	end
end 

return AnimManager