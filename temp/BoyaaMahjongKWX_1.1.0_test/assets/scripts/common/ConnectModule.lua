
--[[
	CND轮循连接模块
	getCDNNetConfig		获得cdn配置
	startIpTurnConnect	开始轮循尝试连接
--]]
ServerType = {
	Normal = 0,  -- 正式服
	Test = 1,    -- 测试服
	Dev = 2, 	 -- 开发服
	Define = 3,  -- 自定义
}

ConnectModule = class();
ConnectModule.s_event = EventDispatcher.getInstance():getUserEvent();

local ServerConfig = {
	[ServerType.Normal] = {
		hall = {		  
                { ip = "120.132.147.21" , port = {7075,7076,7077,7078,7079 }},              
		},
		php = {
			{url = "http://cnmahjong.17c.cn/majiang_v5/"},
			{url = "http://snspmj01.ifere.com/majiang_v5/"},
			{url = "http://120.132.147.20/majiang_v5/"},
		}
	},
	[ServerType.Test] = {
		hall = {
			    { ip = "192.168.96.157" , port = { 7075,7076,7077,7078,7079	}},
        },
		php = {
			{url = "http://mahjong20.by.com/majiang_v5/"},
			{url = "http://snspmj01.ifere.com/majiang_v5/"},
			{url = "http://120.132.147.20/majiang_v5/"},
		}
	},
	[ServerType.Dev] = {
	    hall = {
			    { ip = "192.168.96.156" , port = { 6401 }},
        },
		php = {
			{url = "http://mahjong144.by.com/majiang_v5/"},
		}
	},
	[ServerType.Define] = {
	    hall = {},
		php = {}
	}	

}

addProperty(ConnectModule, "updated", 0)
addProperty(ConnectModule, "config", nil)
addProperty(ConnectModule, "hallList", {})
addProperty(ConnectModule, "phpList", {})

-- 服务器类型 0 正式服   1 测试服   2 开发服
addProperty(ConnectModule, "serverType", ServerType.Normal)
-- 默认正式服的配置
local config = ServerConfig[ServerType.Normal]
addProperty(ConnectModule, "ip", config.hall[1].ip)
addProperty(ConnectModule, "port", config.hall[1].port[1])
addProperty(ConnectModule, "domain", config.php[1])

addProperty(ConnectModule, "uploadHost", "api.php?m=user&p=uploadicon&g=12")
addProperty(ConnectModule, "CDNHostUrl", "http://swf4.17c.cn/mahjongkw/site/site.mobile.json?v=" .. os.time())

addProperty(ConnectModule, "gdmjUrl", "http://swf4.17c.cn/mahjonghj/download/v1/gdmj.zip?v=" .. os.time())
addProperty(ConnectModule, "friendsAnimUrl", "http://swf4.17c.cn/mahjongkw/download/v1/friendsAnim.zip?v=" .. os.time())
addProperty(ConnectModule, "expressionUrl", "http://swf4.17c.cn/mahjongkw/download/v1/expression.zip?v=" .. os.time())
addProperty(ConnectModule, "netUpdateTime", 0)

addProperty(ConnectModule, "turnIpTab", {})
addProperty(ConnectModule, "turning", false)



ConnectModule.getInstance = function()
	if not ConnectModule.s_instance then 
		ConnectModule.s_instance = new(ConnectModule);
	end
	return ConnectModule.s_instance;
end

ConnectModule.releaseInstance = function()
	delete(ConnectModule.s_instance);
	ConnectModule.s_instance = nil;
end

ConnectModule.initModule = function(self)
	-- 初始化连接本地connectMapTable
	self.m_cfg = new(Dict, "CDNConfig")
	self.m_cfg:load()
    	
	local serverType = self.m_cfg:getInt("serverType", ServerType.Normal)
	local config = self.m_cfg:getString("config")
	local ip = self.m_cfg:getString("ip")
	local port = self.m_cfg:getInt("port")
	local domain = self.m_cfg:getString("domain", self:getDomain())
	local netUpdateTime = self.m_cfg:getInt("netUpdateTime", 0)

	self:setNetUpdateTime(netUpdateTime)
	self:setDomain(domain)
	HttpModule.getInstance():initUrlConfig()

	--配置为正式服的时候 强制
	-- PhpManager:setIsTest(0)
	if PhpManager:getIsTest() == 0 then
		printInfo("[ConnectModule]检测为非测试模式 servertype:".. serverType.." ip:"..ip.." port:"..port)
		if serverType ~= ServerType.Normal then
			serverType = ServerType.Normal
			-- 矫正serverType 同时
			-- config 只有正式服才会获取 并保存
			if ToolKit.isValidString(config) then
				self:setConfig(config)
			else-- 没有则根据代码写死的配置选择
				self:cutServer(serverType)
			end
		-- 如果serverType 匹配 则选用上次保存的ip port
		elseif ToolKit.isValidString(ip) and tonumber(port) then
			self:setIpPort(ip, port)
		-- 如果缓存的配置有 则从缓存的配置选
		elseif ToolKit.isValidString(config) then
			self:setConfig(config)
		-- 都没有则根据代码写死的配置选择
		else
			self:cutServer(serverType)
		end
	else -- 其他的服务器
		if ToolKit.isValidString(ip) and tonumber(port) then
			self:setIpPort(ip, port)
		else
			self:cutServer(serverType)
		end
	end
	self:setServerType(serverType)

	-- 如果之前选的是正式服
	if serverType == ServerType.Normal then
       	kPHPActivityURL = kPhpActivityNormal
   	else
       	kPHPActivityURL = kPHPActivityURLTest
    end
end

ConnectModule.getRandomIpPort = function( self )
	local hallList = self:getHallList() or {}

	if not hallList or 0 == #hallList then return end 

	local exist = false
	local turnIpTab = self:getTurnIpTab()
	local randIp, randPort
	local randTimes = 50
	for i = 1, randTimes do
		randHall = hallList[math.random(1, #hallList)]

		for j, v in pairs(turnIpTab) do
			randIp = v.ip
			-- 如果ip已测试匹配端口是否已测
			if v.ip == randHall.ip then 
				randPort = self:getRandomPort( randHall, v )
			else 
				randPort = randHall.port[math.random(1, #randHall.port)]			
			end
		end 

		if randPort or randIp then break end
	end
	
	return randIp, randPort
end

ConnectModule.getRandomPort = function( self ,randHall, turnHall )
	local exist = false
	local randPort
	local randTimes = 50
	
	for i = 1, randTimes do
		randPort = randHall.port[math.random(1, #randHall.port)]
		exist = false
		
		for j = 1, #turnHall.port do
			if randPort == turnHall.port[j] then 
				exist = true 
			end
		end

		if not exist then break end
	end

	if exist then return end 
	return randPort
end

ConnectModule.onSocketConnected = function( self )
	printInfo("[ConnectModule]轮循连接成功 ip:" .. self:getIp() .. "port:" .. self:getPort())
	if self:getTurning() then
		self:saveDict()
		printInfo("[ConnectModule]保存cdn轮循环结果")
	end
	self:setTurning(false)
end

-- 获得新的配置中与上次ip port匹配
ConnectModule.matchNewConfig = function( self )
	local curIp, curPort = self:getIpPort()
	local hallList = self:getHallList() or {}
	local exist = false

	for i, v in pairs(hallList) do
		if v.ip == curIp then
			for j = 1, #v.port do
				if v.port[i] == curPort then
					exist = true
				end
			end
		end
	end

	printInfo("[ConnectModule]当时连接ip:".. curIp.." port:"..curPort)
	if not exist then
		printInfo("[ConnectModule]当时连接在新配置无需重连")
	else
		printInfo("[ConnectModule]当时连接不在新配置中重新轮循连接")
		self:startIpTurnConnect()
	end
end

-- ip轮循连接
ConnectModule.startIpTurnConnect = function( self )
	if not self:getTurning() then
		self:setTurning(true)
	end

	local hallList = self:getHallList() or {}
	if not hallList or 0 == #hallList then 
		printInfo("[ConnectModule]未获取CND配置，使用本地配置 服务器类型："..self:getServerType())
		self:setHallList(ServerConfig[self:getServerType()].hall)
		self:setPhpList(ServerConfig[self:getServerType()].php)
	end 


	local turnIpTab = self:getTurnIpTab()
	if 0 >= table.getn(turnIpTab) then
		table.insert(turnIpTab, {
							ip = self:getIp(), 
							port = {self:getPort()}}
					)
		self:setTurnIpTab( {{ ip = self:getIp(), port = {self:getPort()} }} )
	end

	local ip, port = self:getRandomIpPort()
	printInfo("[ConnectModule]CND配置表:" .. json.encode(self:getHallList()))
	printInfo("[ConnectModule]轮循表:" .. json.encode(turnIpTab))

	--test
	-- ip = nil
	if ip and port then
		printInfo("[ConnectModule]随机轮循 ip:" .. ip .. " port:" .. port)
		self:setIpPort(ip, port)

		for i, v in pairs(turnIpTab) do
			if v.ip == ip then
				table.insert(v.port, port)
			else
				table.insert(turnIpTab, {
							ip = ip, 
							port = {port}}
					)
			end
		end
		self:setTurnIpTab( turnIpTab )
		-- 尝试新的连接
		GameSocketMgr:closeSocketSync(true)
		return
	else
		GameSocketMgr:sendMsg(Command.ANNOUNCE_SYSTEM_PHP_REQUEST)

		printInfo("[ConnectModule]未找到合适连接，重新更新cnd配置")
		turnIpTab = {}
		self:setTurnIpTab( turnIpTab )
		self:getCDNNetConfig(true)
	end
end

ConnectModule.getCDNNetConfig = function( self, force, callback )
	-- 获得CDN配置
	if ServerType.Normal ~= self:getServerType() then
		if callback then callback() end
		return
	end

	local netUpdateTime = MyBaseInfoData:getNetUpdateTime()
	if force or ( 0 >= netUpdateTime or self:getNetUpdateTime() < netUpdateTime ) then
		printInfo("[ConnectModule]尝试获得CDN配置文件")
		global_http_readUrlFile(self:getCDNHostUrl(), function( status, ret )
			-- body
			if 1 == status then
				printInfo("[ConnectModule]获得CDN配置")
				if 0 < netUpdateTime then
					self:setNetUpdateTime(netUpdateTime)
				end

				self:setTurning(false)
				self:analysisCDNJson(ret)
				self:saveDict()
				self:matchNewConfig()

				if callback then callback() end
			end
		end)
	else
		if callback then callback() end
	end
end

ConnectModule.freshHallInfo = function( self, hallTab )
	-- 刷新hall信息
	hallList = hallTab or self:getHallList()
	if not hallList or #hallList == 0 then return end

	local ip, port = self:getIpPort()
	local exist = false

	for i, v in pairs(hallList) do
		if v.ip == ip then
			for j = 1,#v.port do
				if port == v.port[j] then
					exist = true
					break
				end
			end 
		end
	end

	if not exist then
		local randIp = math.random(1, #hallList)
		ip = hallList[randIp].ip
		local randPort = math.random(1, #hallList[randIp].port)
		port = hallList[randIp].port[randPort]

		self:setIpPort(ip, port)
	end
end
ConnectModule.freshPhpInfo = function( self, phpTab )
	-- 刷新php信息
	phpList = phpTab or self:getPhpList()
	if not phpList or #phpList == 0 then return end

	local phpUrl = self:getDomain()
	local exist = false
	for i, v in pairs(phpList) do
		if v.url == phpUrl then
			exist = true
		end 
	end

	if not exist then
		phpUrl = phpList[math.random(1, #phpList)]
		self:setDomain(phpUrl.url)
	end
end

ConnectModule.cutServer = function( self, serverType, ip, port )
	serverType = serverType or ServerType.Normal
	if ServerType.Normal == serverType and self:getConfig() then
		config = {
			hall = self:getHallList(),
			php = self:getPhpList()
	}
	elseif ServerType.Define ~= serverType then
		config = ServerConfig[serverType] or ServerConfig[serrverType.Normal]
	end

	if ServerType.Define ~= serverType then
		self:setServerType(serverType)
		self:freshHallInfo(config.hall)
		self:freshPhpInfo(config.php)
	end

	-- 对手动修改改变
	if ip and port then
		self:setIpPort(ip, port)
	end
	self:saveDict()
end

ConnectModule.analysisCDNJson = function( self, config )
	self:setConfig(config)
	if ToolKit.isValidString(config) then
        printInfo(config)
		config = json.decode(config)
		if config then
			local hallList = {}
			for k, v in pairs(config.hall_new or config.hall) do
				local data = {}
				data.ip = k
				data.port = v
				table.insert(hallList, data)
			end
			self:setHallList(hallList)
			self:freshHallInfo()

			local phpList = config.php
			self:setPhpList(phpList)
			self:freshPhpInfo()
		end
	end
end

ConnectModule.getIpPort = function( self )
	return self:getIp(), self:getPort()
end

ConnectModule.setIpPort = function( self, ip, port )
	self:setIp(ip)
	self:setPort(port)
end

ConnectModule.saveDict = function( self )
	-- 保存本地配置
	local url = self:getDomain()
	self.m_cfg = new(Dict, "CDNConfig")
	self.m_cfg:setInt("serverType", self:getServerType())
	self.m_cfg:setString("config", self:getConfig())
	self.m_cfg:setString("ip", self:getIp())
	self.m_cfg:setInt("port", self:getPort())
	self.m_cfg:setString("domain", self:getDomain())
	self.m_cfg:setInt("netUpdateTime", self:getNetUpdateTime())
	self.m_cfg:save()
end

