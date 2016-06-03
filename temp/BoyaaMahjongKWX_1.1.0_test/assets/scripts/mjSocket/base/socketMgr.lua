require("mjSocket/base/socketTip")
-- if Command and not Command.CommandSupport then
-- 	local CommandSupport = {}
-- 	for i,v in pairs(Command) do
-- 		if type(v) == "number" then
-- 			CommandSupport[v] = true
-- 		end
-- 	end
-- 	Command.CommandSupport = CommandSupport
-- end

require("mjSocket/base/socketTip")
require("gameBase/gameSocket")
require("mjSocket/base/socketConfig")

local CommonProcesser 		= require("mjSocket.common.commonProcesser")
local CommonPhpProcesser	= require("mjSocket.common.commonPhpProcesser")
local CommonReader 			= require("mjSocket.common.commonReader")
local CommonWriter 			= require("mjSocket.common.commonWriter")

--[[
	主要用来管理 套接字的状态
	分发命令字
]]
local SocketMgr = class(GameSocket);
local printInfo, printError = overridePrint("SocketMgr")

-------------------------------------------------------------------------------
-- private
-------------------------------------------------------------------------------
SocketMgr.ctor = function(self, sockName, sockHeader, netEndian)
	self:initSocketTools();
	self:setHeartBeatCmd(Command.HeatBeatReq);

    self.m_maxReconnectTime = 10;
    self.m_hasConnectRecord = false; -- 是否有过连接记录
    self.m_maxReconnTime = 1; 		 --最大重连次数
    self.m_reconnTime = self.m_maxReconnTime	--当前重连次数
    self.m_reconnAnim = nil
end

SocketMgr.dtor = function(self)
	self:removeCommonSocketReader(self.m_reader)
	self:removeCommonSocketWriter(self.m_writer)
	self:removeCommonSocketProcesser(self.m_processer)
	self:removeCommonSocketProcesser(self.m_phpProcesser)

	delete(self.m_reader);
    self.m_reader = nil;
	delete(self.m_writer);
    self.m_writer = nil;
	delete(self.m_processer);
    self.m_processer = nil;
    delete(self.m_phpProcesser);
    self.m_phpProcesser = nil;
end

SocketMgr.initSocketTools = function(self)
	self.m_reader = new(CommonReader)
	self.m_writer = new(CommonWriter)
	self.m_processer = new(CommonProcesser)
	self.m_phpProcesser = new(CommonPhpProcesser)

	printInfo("添加通用socket工具")
    self:addCommonSocketReader(self.m_reader);
    self:addCommonSocketWriter(self.m_writer);
    self:addCommonSocketProcesser(self.m_processer);
    self:addCommonSocketProcesser(self.m_phpProcesser);
end

SocketMgr.isSocketOpening = function(self)
	return self.m_isSocketOpening;
end

SocketMgr.createSocket = function(self, sockName, sockHeader, netEndian)
	return new(Socket, sockName, sockHeader, netEndian)
end

SocketMgr.getSocket = function(self)
	return self.m_socket;
end	

SocketMgr.openSocket = function(self)
	if self:isSocketOpen() or self:isSocketOpening() then
		printInfo("isSocketOpening")
		if self:isSocketOpening() then
			AlarmTip.play("正在连接服务器")
		end
		return;
	end
	self.m_hasConnectRecord = true;
	self.m_isSocketOpening = true;
	
	---- local ip,port = HallConfig:getIpPort();
	local ip,port = ConnectModule.getInstance():getIpPort();
	-- ip = "192.168.200.144"
	-- port = "6401"
	printInfo("ip = %s, port = %s", ip, port)
	if ToolKit.isValidString(ip) and tonumber(port) then
		GameSocket.openSocket(self,ip,port);
		GameLoading:addPhpCommand(Command.SOCKET_EVENT_CONNECTED, "无法连接到服务器")
	else
		printInfo("ip端口错误")
	end
end

SocketMgr.isSocketClosed = function(self)
	return not self:isSocketOpen() and not self:isSocketOpening()
end

SocketMgr.checkSocketOk = function(self)
	if self:isSocketOpen() then
		return true
	end
	self:closeSocketSync(true)
end

SocketMgr.closeSocketSync = function(self, reconn)
	if self.m_reconnAnim then 
   		delete(self.m_reconnAnim)
   		self.m_reconnAnim = nil
   	end
	self.reconnFlag = reconn
	local isOpen = self:isSocketOpen()
	LoginMethod:logOut()
	GameLoading:stop()
	GameSocket.closeSocketSync(self);
	self.m_isSocketOpening = false;
	-- 如果是已经断开的状态，且需要重连，则直接重连
	if self:isSocketClosed() and reconn then
		self.reconnFlag = nil
		self:openSocket()
	end
end

SocketMgr.convertCommand = function(self, cmd)
	return cmd > Command.PHP_CMD_CONSTANT_BEGIN and Command.PHP_CMD_REQUEST or cmd
end

SocketMgr.isPhpCommand = function(self, cmd)
	return cmd > Command.PHP_CMD_CONSTANT_BEGIN
end

SocketMgr.sendMsg = function(self, cmd, info, anim)
	--send
	if self:isSocketOpen() then
		-- 如果是php透传命令
		GameSocket.sendMsg(self, cmd, info)
		if self:isPhpCommand(cmd) then
			-- 处理loading效果
			printInfo("sendMsg")
			-- GameSocket.sendMsg(self, cmd, info)
			GameLoading:addPhpCommand(cmd, SocketTip[cmd], anim)
		else
			-- EventDispatcher.getInstance():dispatch(Event.ConsoleSocket, cmd, info)
		end

		return ;
	end
	
	AlarmTip.play("正在连接服务器...")
	self:openSocket()
	app:onSocketSendError()	
end


SocketMgr.writeBegin = function(self, socket, cmd)
	return socket:writeBegin(self:convertCommand(cmd), kProtocalVersion, 
							kProtocalSubversion, kDeviceTypeANDROID);
end

SocketMgr.writePacket = function(self, socket, packetId, cmd, info)
	-- php cmd
	if cmd > Command.PHP_CMD_CONSTANT_BEGIN then
		--可以在这里组织共同数据
		-- local packetInfo = info or {};
		-- info = self:getPhpJsonTable(subCmd + PHP_CMD_CONSTANT);
		-- for k,v in pairs(packetInfo) do 
		-- 	info[k] = v;
		-- end
		info.cmd = cmd;
	end
	return GameSocket.writePacket(self,socket, packetId, self:convertCommand(cmd), info);
end

SocketMgr.onTimeout = function(self)
	printInfo("Socket Status onTimeout")
	GameSocket.onTimeout(self);
	self:closeSocketSync();
	app:onSocketTimeOut()
end 

-------------------------------------------------------------------------------
-- private
-- Method: onSocketConnected
-- Action: 当程序打开Socket的时候，如果连接成功会触发该回调函数，此时请求登
-- 陆服务器
SocketMgr.onSocketConnected = function(self)
	printInfo("Socket Status onSocketConnected")
	self.m_isNotReconnect = false
	GameSocket.onSocketConnected(self);

	self.m_isSocketOpening = false;
	self.m_reconnTime = 0
	self.reconnFlag = nil
	--connect suc
   	if self.m_reconnAnim then 
   		delete(self.m_reconnAnim)
   		self.m_reconnAnim = nil
   	end
	app:onSocketConnected()
end

SocketMgr.onSocketReconnecting = function(self)
	printInfo("Socket Status onSocketReconnecting")

	GameSocket.onSocketReconnecting(self);
	self.m_isSocketOpening = true;
end

SocketMgr.onSocketConnectFailed = function(self)
	printInfo("Socket Status onSocketConnectFailed")
    GameSocket.onSocketConnectFailed(self);
    self.m_isNotReconnect = false
	self.m_isSocketOpening = false;

	if self.reconnFlag  then
		AlarmTip.play("连接服务器失败")
	end
	self:tryReconnect(true)
	self.reconnFlag = nil
end

SocketMgr.onSocketClosed = function(self)
	printInfo("Socket Status onSocketClosed %s", "大厅连接断开")

    GameSocket.onSocketClosed(self);
	self.m_isSocketOpening = false;
	if not self.m_isNotReconnect then
		printInfo("开始重连")
		self:tryReconnect()
	end
end

SocketMgr.tryReconnect = function(self)
	-- 已连接 或者 正在连接
	if not self:isSocketClosed() or self.m_reconnAnim then return end
	if GameSetting:getDisableReconn() then return end		-- 异地登陆， 禁止自动重连
	self:stopHeartBeat()
	local netAvaliable = NativeEvent.getInstance():GetNetAvaliable()
	-- 网络正常情况下 且未达到重连上限 则重连
	-- 网络可用的情况下
   	if netAvaliable == 1 then
   		if self.reconnFlag then
   			self:openSocket()
			self.reconnFlag = nil
   		elseif self.m_reconnTime < self.m_maxReconnTime then --尝试重连
   			self.m_reconnTime = self.m_reconnTime + 1
   			self.m_reconnAnim = AnimFactory.createAnimInt(kAnimNormal, 0, 1, 1000, 0)
   			self.m_reconnAnim:setEvent(nil, function()
   				delete(self.m_reconnAnim)
   				self.m_reconnAnim = nil
   				self:openSocket()
   			end)
   		else --不需要重连则 直接提示网络异常
	   		app:onNetErrorBackToLobby()
   		end
   	-- 在游戏中 且 还没重连过
   	elseif app:isInRoom() and self.m_reconnTime == 0 then
   		self.m_reconnTime = self.m_reconnTime + 1
   		self.m_reconnAnim = AnimFactory.createAnimInt(kAnimNormal, 0, 1, 1000, 0)
   		self.m_reconnAnim:setEvent(nil, function()
   			delete(self.m_reconnAnim)
   			self.m_reconnAnim = nil
   			self:openSocket()
   		end)
   	else --直接显示 网络异常
	   	app:onNetErrorBackToLobby()
   	end
end

return SocketMgr