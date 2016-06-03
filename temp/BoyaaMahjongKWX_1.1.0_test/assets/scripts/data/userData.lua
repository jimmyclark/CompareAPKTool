local HeadData = require("data.headData")
local UserData = class(HeadData)

addProperty(UserData, "id", 0)
addProperty(UserData, "seatId", 0)
addProperty(UserData, "money", 0)
addProperty(UserData, "huaFei", 0)
addProperty(UserData, "jewel", 0)
addProperty(UserData, "sex", 0)
addProperty(UserData, "exp", 0)
addProperty(UserData, "level", 0)
addProperty(UserData, "nick", "")
addProperty(UserData, "isLogin", false)
addProperty(UserData, "wintimes", 0)
addProperty(UserData, "drawtimes", 0)
addProperty(UserData, "losetimes", 0)
addProperty(UserData, "regtime", 0)
addProperty(UserData, "mtkey", "")
addProperty(UserData, "status", 0)
addProperty(UserData, "userType", 1)
addProperty(UserData, "isAult", 0)
addProperty(UserData, "curExp", 0)
addProperty(UserData, "needExp", 0)
addProperty(UserData, "title", "")
addProperty(UserData, "isbind", 0)
addProperty(UserData, "isRegister", 0)
addProperty(UserData, "avoidFirstPay", false)
addProperty(UserData, "verifyed", 0)
addProperty(UserData, "isbind_phone", 0)
addProperty(UserData, "score", 0)

--头像上传临时图片名
addProperty(UserData, "uploadTemp", "")

function UserData:ctor()
	
end

-- 设置等级
local setLevel = UserData.setLevel
function UserData:setLevel(level)
	level = level or self:getLevel()
	local preLevel = self:getLevel()
	return setLevel(self, level), level > preLevel
end

function UserData:addMoney(money, animFlag)
	local moneyPre = self:getMoney()
	local moneyNow = moneyPre + money
	if moneyNow < 0 then moneyNow = 0 end
	self:setMoney(moneyNow)
	if animFlag then
		-- 播放金币雨
		AnimationParticles.play(AnimationParticles.DropCoin)
	end
end

local setMoney = UserData.setMoney
function UserData:setMoney(money, animFlag)
	if money < 0 and money then money = 0 end
	setMoney(self, money)
	if self:getMoney() >= MyBaseInfoData:getBrokenMoney() then
		self:setAvoidFirstPay(false)
	end
	if animFlag then
		-- 播放金币雨
		AnimationParticles.play(AnimationParticles.DropCoin)
	end
	return self
end

-- 设置话费劵
local setHuaFei = UserData.setHuaFei
function UserData:setHuaFei(huaFei, isLogin)
	if huaFei < 0 then huaFei = 0 end
	local oldHuaFei = self:getHuaFei()
	setHuaFei(self, huaFei)
	if self:getId() > 0 and huaFei ~= oldHuaFei and app:isInRoom() and not isLogin and self == MyUserData then
		local param = {}
		param.iUserId = self:getId()
		param.iUserInfo = json.encode(self:packPlayerInfo())
		GameSocketMgr:sendMsg(Command.CLIENT_COMMAND_UPDATE_USER_INFO, param, false)
	end
	return self
end

function UserData:clear()
	self:setIsLogin(false)
	self:setId(0)
	self:setMoney(0)
	self:setHuaFei(0)
	self:setJewel(0)
	self:setSex(1)
	self:setNick("")
	self:setIsbind(0)
	self:setMtkey("")
	self:setAvoidFirstPay(false)
	self:setHeadUrl("");
end

function UserData:initUserInfo(data)
	self:setIsLogin(true)
	self:setId(data.mid or 0)
	self:setNick(data.mnick or "")
	self:setMoney(tonumber(data.money or 0))
	self:setHuaFei(tonumber(data.coupons or 0), true)
	self:setJewel(tonumber(data.boyaacoin or 0))
	self:setSex(tonumber(data.sex or 1))
	self:setLevel(tonumber(data.level) or 0)
	-- 头像
	if ToolKit.isValidString(data.icon_big) then
		self:setHeadUrl(data.icon_big)
	else
		self:setHeadUrl(data.icon_small)
	end
	-- 胜负平
	self:setWintimes(tonumber(data.wintimes) or 0)
	self:setLosetimes(tonumber(data.losetimes) or 0)
	self:setDrawtimes(tonumber(data.drawtimes) or 0)
	-- self:setRegtime(data.regtime or 0)
	self:setMtkey(data.mtkey or "")
	self:setStatus(tonumber(data.mstatus) or 0)
	-- 是否绑定
	self:setIsbind(tonumber(data.isbind) or 0)
	-- 是否绑定手机
	self:setIsbind_phone(tonumber(data.isbind_phone) or 0)
	self:setUserType(tonumber(data.usertype))
	self:setIsRegister(tonumber(data.isRegister) or 0)
	--是否认证
	self:setVerifyed(tonumber(data.verifyed) or 0)
	if 1 == self:getIsRegister() then
		GuideManager:initGuideCoinfig()
	end
	self:sendLoginSuccessToJava()
end

function UserData:sendLoginSuccessToJava()
	local param = {}
	param.mid = self:getId()
	param.version = PhpManager:getVersionName()
	param.api = PhpManager:getApi()
	param.api = string.format("0x%x",param.api)
	printInfo("param.api : %s", param.api)
	param.appid = PhpManager:getAppid()
	param.sitemid = PhpManager:getDevice_id() .. GameConfig:getLastSuffix()
	param.userType = self:getUserType()
	param.imei = param.sitemid
	param.socket = ConnectModule.getInstance():getServerType()
	---- param.socket = HallConfig:getServerType()
	NativeEvent.getInstance():initWebView(param)
end

function UserData:getFormatMoney()
	return ToolKit.formatMoney(self:getMoney())
end

function UserData:getSkipMoney()
	return ToolKit.skipMoney(self:getMoney())
end

function UserData:getFormatNick(num)
	return ToolKit.subStr(self:getNick(), num or 9)
end

--根据输赢的状态 更新战绩
function UserData:freshZhanjiByTurnMoney(huType)
	if not huType then return end
	if huType == 2 then
		self:setWintimes(self:getWintimes() + 1)
	elseif huType == 0 then
		self:setDrawtimes(self:getDrawtimes() + 1)
	else
		self:setLosetimes(self:getLosetimes() + 1)
	end
end

function UserData:setZhanji(wintimes, losetimes, drawtimes)
	self:setWintimes(wintimes or 0)
	self:setLosetimes(losetimes or 0)
	self:setDrawtimes(drawtimes or 0)
end

function UserData:getZhanji()
	return self:getWintimes() or 0, self:getLosetimes() or 0, self:getDrawtimes() or 0
end

function UserData:getZhanjiRate()
	local total = self:getWintimes() + self:getLosetimes() + self:getDrawtimes()
	local rate = total == 0 and 0 or self:getWintimes() / total 
	return string.format("%.01f%%", rate * 100)
end

-- 刷新数据源
function UserData:refreshInfo()
	self:setNick(self:getNick())
		:setSex(self:getSex())
		:setExp(self:getExp())
		:setLevel(self:getLevel())
		:setWintimes(self:getWintimes())
		:setLosetimes(self:getLosetimes())
		:setDrawtimes(self:getDrawtimes())
		:setHeadUrl(self:getHeadUrl())
end

function UserData:initPlayerInfo(data, isPrivate)
	local iUserInfo = json.decode(data.iUserInfo) or {}
	self:setId(data.iUserId)
		:setHuaFei(tonumber(iUserInfo.coupons) or 0)
		:setSeatId(data.iSeatId)
		:setNick(iUserInfo.mnick or "")
		:setSex(tonumber(iUserInfo.sex) or 1)
		:setLevel(tonumber(iUserInfo.level) or 1)
		:setWintimes(tonumber(iUserInfo.winCount) or 0)
		:setLosetimes(tonumber(iUserInfo.loseCount) or 0)
		:setDrawtimes(tonumber(iUserInfo.deuceCount) or 0)
	-- 头像
	if ToolKit.isValidString(iUserInfo.bimg) then
		self:setHeadUrl(iUserInfo.bimg)
	else
		self:setHeadUrl(iUserInfo.simg)
	end
	if 1 == isPrivate then
		self:setScore(data.iMoney)
	else
		self:setMoney(data.iMoney)
	end
end

function UserData:updateUserInfo(data)
	self:setNick(data.mnick or self:getNick())
	self:setSex(tonumber(data.sex) or self:getSex())
	self:setLevel(tonumber(data.level) or self:getLevel())
	self:setWintimes(tonumber(data.winCount) or self:getWintimes())
	self:setLosetimes(tonumber(data.loseCount) or self:getLosetimes())
	self:setDrawtimes(tonumber(data.deuceCount) or self:getDrawtimes())
	self:setHuaFei(tonumber(data.coupons) or self:getHuaFei(), true)
end

function UserData:packPlayerInfo()
	return {
		mnick 			= self:getNick(),
		sex 			= self:getSex(),
		level 			= self:getLevel(),
		winCount 		= self:getWintimes(),
		loseCount 		= self:getLosetimes(),
		deuceCount 		= self:getDrawtimes(),
		bimg 			= self:getHeadUrl(),
		simg 			= self:getHeadUrl(),
		coupons			= self:getHuaFei(),
	}
end

return UserData  