ServerType = {
	Normal = 0,  -- 正式服
	Test = 1,    -- 测试服
	Dev = 2, 	 -- 开发服
	Define = 3,  -- 自定义
}

local HallConfig = class()

local ServerConfig = {
	[ServerType.Normal] = {
		gates = {
			{ ip = "120.132.147.21", port = 7075 },
			{ ip = "120.132.147.21", port = 7076 },
			{ ip = "120.132.147.21", port = 7077 },
			{ ip = "120.132.147.21", port = 7078 },
			{ ip = "120.132.147.21", port = 7079 },
		},
		domains = {
			{ url = "http://cnmahjong.17c.cn/majiang_v5/"},
			{ url = "http://snspmj01.ifere.com/majiang_v5/"},
			{ url = "http://120.132.147.20/majiang_v5/"},
		},
	},
	[ServerType.Test] = {
		gates = {
			{ ip = "192.168.96.157", port = 7075 },
			{ ip = "192.168.96.157", port = 7076 },
			{ ip = "192.168.96.157", port = 7077 },
			{ ip = "192.168.96.157", port = 7078 },
			{ ip = "192.168.96.157", port = 7079 },
		},
		domains = {
			{ url = "http://mahjong20.by.com/majiang_v5/"},
		},
	},
	[ServerType.Dev] = {
		gates = {
			{ ip = "192.168.96.156", port = 6401 },
		},
		domains = {
			{ url = "http://mahjong144.by.com/majiang_v5/"},
		},
	}
}

addProperty(HallConfig, "updated", 0)
addProperty(HallConfig, "config", nil)
addProperty(HallConfig, "serverList", {})
addProperty(HallConfig, "domainList", {})

-- 服务器类型 0 正式服   1 测试服   2 开发服
addProperty(HallConfig, "serverType", ServerType.Normal)
-- 默认正式服的配置
local config = ServerConfig[ServerType.Normal]
addProperty(HallConfig, "ip", config.gates[1].ip)
addProperty(HallConfig, "port", config.gates[1].port)
addProperty(HallConfig, "domain", config.domains[1].url)

addProperty(HallConfig, "uploadHost", "api.php?m=user&p=uploadicon&g=12")
addProperty(HallConfig, "updateHostUrl", "http://swf4.17c.cn/mahjongkw/site/site.mobile.json?v=" .. os.time())

addProperty(HallConfig, "gdmjUrl", "http://swf4.17c.cn/mahjonghj/download/v1/gdmj.zip?v=" .. os.time())
addProperty(HallConfig, "friendsAnimUrl", "http://swf4.17c.cn/mahjongkw/download/v1/friendsAnim.zip?v=" .. os.time())
addProperty(HallConfig, "expressionUrl", "http://swf4.17c.cn/mahjongkw/download/v1/expression.zip?v=" .. os.time())
addProperty(HallConfig, "netUpdateTime", 0)

function HallConfig:load()
	self.m_set = new(Dict, "HallConfig")
	self.m_set:load()
	
	local serverType = self.m_set:getInt("serverType", ServerType.Normal)
	local config = self.m_set:getString("config")
	-- 这里最烦了  还要连hallserver
	local ip = self.m_set:getString("ip")
	local port = self.m_set:getInt("port")
	local domain = ServerConfig[serverType].domains[1].url
	printInfo("domain : %s", domain)
	local netUpdateTime = self.m_set:getInt("netUpdateTime", 0)
	
	self:setNetUpdateTime(netUpdateTime)
	self:setDomain(domain)
	--配置为正式服的时候 强制
	if PhpManager:getIsTest() == 0 then
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
end

-- @force 是否强制更新网络配置
function HallConfig:freshNetConfig(force)
	local netUpdateTime = MyBaseInfoData:getNetUpdateTime()
	-- 如果是正式服就更新配置
	-- 获取到了更新时间 检查是否要更新
	if (force or self:getUpdated() == 0) and PhpManager:getIsTest() == 0 and self:getNetUpdateTime() ~= netUpdateTime then
		printInfo("更新网络配置")
		self:setUpdated(2)  --正在更新 
		global_http_readUrlFile(self:getUpdateHostUrl(), function(status, ret)
			self:setUpdated(1)  --更新完成
			if status == 1 and ret ~= config then
				printInfo("ip域名配置发生变化")
				self:setNetUpdateTime(netUpdateTime)
					:setConfig(ret)
					:save()
			end
		end)
	end
end

function HallConfig:cutServer(serverType)
	serverType = serverType or ServerType.Normal
	local config = ServerConfig[serverType] or ServerConfig[ServerType.Normal]
	self:setServerType(serverType)
		:setServerList(config.gates)
		:freshServerInfo()
		:setDomainList(config.domains)
		:freshDomainInfo()
		:save()
end

local setDomain = HallConfig.setDomain
function HallConfig:setDomain(url)
	printInfo("domain url : %s", url)
	self:freshNetConfig(url)
	setDomain(self, url)
	HttpModule.getInstance():initUrlConfig();
	return self
end

function HallConfig:setConfig(config)
	self.config = config
	if ToolKit.isValidString(config) then
		config = json.decode(config)
		if config then
			local serverList = {}
			for k,v in ipairs(config.hall) do
				serverList[k] = v
			end
			self:setServerList(serverList)
				:freshServerInfo()
			
			local domainList = {}
			for k,v in ipairs(config.php) do
				domainList[k] =	v
			end
			self:setDomainList(domainList)
				:freshDomainInfo()
		end
	end
	return self
end

function HallConfig:freshServerInfo()
	local serverList = self:getServerList()
	if not serverList or #serverList == 0 then return end
	local server = serverList[math.random(1, #serverList)]
	self:setIpPort(server.ip, server.port)
	printInfo("更新使用的ip port 配置 %s:%s", server.ip, server.port)
	return self
end

function HallConfig:freshDomainInfo()
	local domainList = self:getDomainList()
	if not domainList or #domainList == 0 then return end
	local domain = domainList[1]
	self:setDomain(domain.url)
	printInfo("更新使用的domain 配置 %s", domain.url)
	return self
end

function HallConfig:getIpPort()
	return self:getIp(), self:getPort()
end

function HallConfig:setIpPort(ip, port)
	self:setIp(ip)
	self:setPort(port)
	return self	
end

function HallConfig:save()
	self.m_set = new(Dict, "HallConfig")
	self.m_set:setString("config", self:getConfig())
	self.m_set:setString("ip", self:getIp())
	self.m_set:setInt("port", self:getPort())
	self.m_set:setInt("serverType", self:getServerType())
	self.m_set:setString("domain", self:getDomain())
	self.m_set:save()
end

return HallConfig