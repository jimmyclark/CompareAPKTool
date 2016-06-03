local GameData = class()

addProperty(GameData, "dealHuaNum", 0) -- 发牌时候的花牌数目
addProperty(GameData, "huaNum", 0) -- 花牌数目
addProperty(GameData, "isTing", 0) -- 是否听牌
addProperty(GameData, "isExist", 0) --是否在座位上
addProperty(GameData, "isAi", 0) -- 是否听牌
addProperty(GameData, "isReady", 0) -- 是否准备
addProperty(GameData, "isPlaying", 0) -- 是否开始游戏
addProperty(GameData, "isMyTurn", 0) -- 是否轮到我出牌
addProperty(GameData, "isBank", 0) -- 是不是庄家
addProperty(GameData, "tingInfos", {})  --可听的听牌信息
addProperty(GameData, "curTingInfo", {})  --已听的听牌信息
addProperty(GameData, "isSelectTing", 0)  --是否在选择听
addProperty(GameData, "isSelectLiang", 0)  --是否在选择亮

--国标专用
addProperty(GameData, "isObing", 0) -- 观察牌型时间
--广东专用
addProperty(GameData, "isHuaning", 0) --正在换三张
addProperty(GameData, "doubleNum", 0) --加倍数


function GameData:addHuaNum(num)
	num = num or 1
	local preNum = self:getHuaNum()
	if preNum < 0 then preNum = 0 end
	self:setHuaNum(preNum + num)
end

-- 重置
function GameData:clear()
	self:setHuaNum(0)	
	self:setIsTing(0)
	self:setIsAi(0)
	self:setIsReady(0)
	self:setIsPlaying(0)
	self:setIsBank(0)
	self:setIsMyTurn(0)
	self:setTingInfos({})
	self:setCurTingInfo({})
	self:setIsHuaning(0)
end

-- 结算时
function GameData:onGameOver()
	self:setIsPlaying(0)
	self:setIsReady(0)
	self:setIsAi(0)
	self:setIsTing(0)
	self:setIsMyTurn(0)
	self:setIsHuaning(0)
	self:setTingInfos({})
	self:setCurTingInfo({})
end

-- 点击准备按钮时
function GameData:resetForReady()
	self:setIsPlaying(0)
	self:setIsAi(0)
	self:setIsTing(0)
	self:setIsMyTurn(0)
	self:setIsHuaning(0)
	self:setTingInfos({})
	self:setHuaNum(0)	
	self:setCurTingInfo({})
end

return GameData