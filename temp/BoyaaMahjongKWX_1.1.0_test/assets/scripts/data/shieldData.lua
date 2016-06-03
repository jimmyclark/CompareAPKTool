--[[
	一键屏蔽开关
]]
local ShieldData = class()

-- 苹果版本
-- 排行榜、活动中心（包括气泡）、商城多重支付、道具、更新、登陆选择（默认游客登录）、公告

-- Android版本
-- 首充礼包 活动中心
addProperty(ShieldData, "init", false) -- 屏蔽信息是否已经拉取
addProperty(ShieldData, "mutiPayChanged", false) -- 屏蔽开关是否已经变化
addProperty(ShieldData, "isQuickEntryGame", false) -- 新用户是否快速开启游戏
-- -- 公共屏蔽
-- addProperty(ShieldData, "activityFlag", true)   -- 默认屏蔽活动入口
-- addProperty(ShieldData, "singleGameFlag", true) -- 是否显示不推荐的游戏

-- 差异化屏蔽
if System.getPlatform() == kPlatformIOS then
	addProperty(ShieldData, "allFlag", true)	--默认全屏蔽
	-- addProperty(ShieldData, "firstPayFlag", false) --默认不屏蔽首充功能
	addProperty(ShieldData, "mutiPayFlag", true)   --默认屏蔽多重支付，仅使用苹果支付
	-- addProperty(ShieldData, "mutiLoginFlag", true) --默认屏蔽多选登录
	-- addProperty(ShieldData, "exchangeFlag", true)  --默认屏蔽道具兑换
	-- addProperty(ShieldData, "updateFlag", true)    --默认屏蔽更新
	-- addProperty(ShieldData, "noticeFlag", true)    --默认屏蔽公告
	-- addProperty(ShieldData, "rankFlag", true)	   --默认屏蔽排行榜
	-- addProperty(ShieldData, "shareFlag", true)
	-- addProperty(ShieldData, "addictionFlag", true)	   --默认屏蔽个人信息实名认证
else
	addProperty(ShieldData, "allFlag", true)	--默认全屏蔽
	-- addProperty(ShieldData, "firstPayFlag", true)  --默认屏蔽首充功能
	addProperty(ShieldData, "mutiPayFlag", false)  --默认不屏蔽多重支付
	-- addProperty(ShieldData, "mutiLoginFlag", false) --默认不屏蔽多选登录
	-- addProperty(ShieldData, "exchangeFlag", false) --默认不屏蔽道具兑换
	-- addProperty(ShieldData, "updateFlag", false)   --默认不屏蔽更新
	-- addProperty(ShieldData, "noticeFlag", false)    --默认不屏蔽公告
	-- addProperty(ShieldData, "rankFlag", false)	   --默认不屏蔽排行榜
	-- addProperty(ShieldData, "shareFlag", false)
	-- addProperty(ShieldData, "addictionFlag", false)	   --默认不屏蔽个人信息实名认证
end

function ShieldData:initData(data)
	self:setAllFlag(data.all == 1)
	self:setIsQuickEntryGame(data.isQuickEntryGame == 1)
	-- self:setActivityFlag(data.activity == 1)
	-- 	:setFirstPayFlag(data.firstPay == 1)
	-- 	:setMutiLoginFlag(data.mutiLogin == 1)
	-- 	:setExchangeFlag(data.exchange == 1)
	-- 	:setUpdateFlag(data.update == 1)
	-- 	:setNoticeFlag(data.notice == 1)
	-- 	:setRankFlag(data.rank == 1)
	-- 	:setShareFlag(data.share == 1)
	-- 	:setAddictionFlag(data.addiction == 1)
	return self
end

return ShieldData
