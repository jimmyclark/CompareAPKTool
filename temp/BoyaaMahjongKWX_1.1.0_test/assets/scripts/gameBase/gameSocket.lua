-- gameSocket.lua
-- Author: Vicent Gong
-- Date: 2013-07-15
-- Last modification : 2013-10-12
-- Description: Implement a base class for socket 

require("core/constants");
require("core/object");
require("core/global");
require("core/socket");
require("core/anim");
require("gameBase/socketReader");
require("gameBase/socketWriter");
require("gameBase/socketProcesser")

GameSocket = class();

GameSocket.ctor = function(self, sockName,sockHeader,netEndian)
	self.m_socket = self:createSocket(sockName,sockHeader,netEndian);
	self.m_socket:setEvent(self,GameSocket.onSocketEvent);

	self.m_heartBeatInterval = 10000;
	self.m_netBeatInterval = 3000;

	self.m_socketReaders = {};
	self.m_socketWriters = {};
	self.m_socketProcessers = {};

	self.m_commonSocketReaders = {};
	self.m_commonSocketWriters = {};
	self.m_commonSocketProcessers = {};
end

GameSocket.dtor = function(self)
	self:stopHeartBeat();

	self.m_socketReaders = {};
	self.m_socketWriters = {};
	self.m_socketProcessers = {};

	self.m_commonSocketReaders = {};
	self.m_commonSocketWriters = {};
	self.m_commonSocketProcessers = {};

	delete(self.m_socket);
	self.m_socket = nil;
end

GameSocket.openSocket = function(self, ip, port)
	printInfo("GameSocket.openSocket")
	if not self:isSocketOpen() then
		printInfo("GameSocket.openSocket 正式open")
		self.m_socket:open(ip,port);
	end
end

GameSocket.closeSocketSync = function(self)
	if self.m_socket then
		self:stopHeartBeat();
		self.m_socket:close();
		self.m_isSocketOpen = false;
	end
end

GameSocket.closeSocketAsync = function(self)
	if self.m_socket then
		self:stopHeartBeat();
		self.m_socket:close(0);
	end
end

GameSocket.isSocketOpen = function(self)
	return self.m_isSocketOpen;
end

GameSocket.sendMsg = function(self, cmd, info)
	--[[if not self.m_isSocketOpen then
		return false;
	end]]

	local packetId = self:writeBegin(self.m_socket, cmd);
	self:writePacket(self.m_socket,packetId, cmd, info);
	self:writeEnd(packetId);
	return true;
end

GameSocket.setHeartBeatInterval = function(self, milliSecond)
	self.m_heartBeatInterval = milliSecond;
end

GameSocket.setHeartBeatCmd = function(self, cmd)
	self.m_heartBeatCmd = cmd;
end

GameSocket.setReconnectParam = function(self, reconnectTimes, interval)
	-- self.m_socket:setReconnectParam(reconnectTimes, interval);
end

GameSocket.addSocketReader = function(self,socketReader)
	self:addSocketHandler(self.m_socketReaders,SocketReader,socketReader);
end

GameSocket.addSocketWriter = function(self,socketWriter)
	self:addSocketHandler(self.m_socketWriters,SocketWriter,socketWriter);
end

GameSocket.addSocketProcesser = function(self,socketProcesser)
	local ret = self:addSocketHandler(self.m_socketProcessers,SocketProcesser,socketProcesser);
	if ret then
		socketProcesser:setSocketManager(self);
	end
end

GameSocket.removeSocketReader = function(self,socketReader)
	self:removeSocketHandler(self.m_socketReaders,socketReader);
end

GameSocket.removeSocketWriter = function(self,socketWriter)
	self:removeSocketHandler(self.m_socketWriters,socketWriter);
end

GameSocket.removeSocketProcesser = function(self,socketProcesser)
	self:removeSocketHandler(self.m_socketProcessers,socketProcesser);
end

GameSocket.addCommonSocketReader = function(self,socketReader)
	self:addSocketHandler(self.m_commonSocketReaders,SocketReader,socketReader);
end

GameSocket.addCommonSocketWriter = function(self,socketWriter)
	self:addSocketHandler(self.m_commonSocketWriters,SocketWriter,socketWriter);
end

GameSocket.addCommonSocketProcesser = function(self,socketProcesser)
	local ret = self:addSocketHandler(self.m_commonSocketProcessers,SocketProcesser,socketProcesser);
	if ret then
		socketProcesser:setSocketManager(self);
	end
end

GameSocket.removeCommonSocketReader = function(self,socketReader)
	self:removeSocketHandler(self.m_commonSocketReaders,socketReader);
end

GameSocket.removeCommonSocketWriter = function(self,socketWriter)
	self:removeSocketHandler(self.m_commonSocketWriters,socketWriter);
end

GameSocket.removeCommonSocketProcesser = function(self,socketProcesser)
	self:removeSocketHandler(self.m_commonSocketProcessers,socketProcesser);
end

---------------------------------private functions-----------------------------------------

--virtual
GameSocket.createSocket = function(self, sockName, sockHeader, netEndian)
	error("Derived class must implement this function");
end

--write packet functions
--virtual
GameSocket.writeBegin = function(self, socket, cmd)
	error("Derived class must implement this function");
end

--virtual
GameSocket.writePacket = function(self, socket, packetId, cmd, info)
	for k,v in pairs(self.m_socketWriters) do
		if v:writePacket(socket,packetId,cmd,info) then
			return true;
		end
	end

	for k,v in pairs(self.m_commonSocketWriters) do
		if v:writePacket(socket,packetId,cmd,info) then
			return true;
		end
	end

	return false;
end

--virtual
GameSocket.writeEnd = function(self, packedId)
	self.m_socket:writeEnd(packedId);
end

--read packet functions
--virtual
GameSocket.readBegin = function(self, packedId)
	return self.m_socket:readBegin(packedId);
end

--virtual
GameSocket.readPacket = function(self, socket, packetId, cmd)
	local packetInfo = nil;	

	for k,v in pairs(self.m_socketReaders) do
		local packetInfo =  v:readPacket(socket,packetId,cmd);
		if packetInfo then
			return packetInfo;
		end
	end

	for k,v in pairs(self.m_commonSocketReaders) do
		dump("name = " .. (v.m_sockName or "位置"))
		local packetInfo =  v:readPacket(socket,packetId,cmd);
		if packetInfo then
			return packetInfo;
		end
	end

	return packetInfo;
end

--virtual
GameSocket.readEnd = function(self, packedId)
	self.m_socket:readEnd(packedId);
end

--process packet functions
--virtual
GameSocket.onReceivePacket = function(self, cmd, info)
	if not self:isSocketOpen() then
		return
	end
	for k,v in pairs(self.m_socketProcessers) do
		local info =  v:onReceivePacket(cmd,info);
		if info then
			return info;
		end
	end

	for k,v in pairs(self.m_commonSocketProcessers) do
		local info = v:onReceivePacket(cmd,info);
		if info then
			for k,v in pairs(self.m_socketProcessers) do
				if v:onCommonCmd(cmd,cmdInfo) then
					break;
				end
			end
			return;
		end
	end

	return false;
end

--socket event functions
--virtual
GameSocket.onSocketConnected = function(self)
	printInfo("GameSocket.onSocketConnected")
	self.m_isSocketOpen = true;
	-- 心跳包改为进入房间后才发送
	-- GameSocket.startHeartBeat(self);
end

--virtual
GameSocket.onSocketReconnecting = function(self)
	self.m_isSocketOpen = false;
end

--virtual
GameSocket.onSocketConnectivity = function(self)
	
end

--virtual
GameSocket.onSocketConnectFailed = function(self)
    self.m_isSocketOpen = false;
end

--virtual
GameSocket.onSocketClosed = function(self)
	self.m_isSocketOpen = false;
end

--virtual
GameSocket.onTimeout = function(self)
	self.m_isSocketOpen = false;
end

GameSocket.parseMsg = function(self, packetId)
	local cmd = self:readBegin(packetId);
	local info = self:readPacket(self.m_socket,packetId,cmd);
	self:readEnd(packetId);
	return cmd,info;
end

GameSocket.onSocketServerPacket = function(self, packetId)
	GameSocket.stopTimer(self);
	local cmd,info = GameSocket.parseMsg(self,packetId);
	self:onReceivePacket(cmd,info);
end

GameSocket.onSocketEvent = function(self, eventType, param)
	printInfo("eventType = %s", eventType)
	if eventType == kSocketConnected then
        self:onSocketConnected();
    elseif eventType == kSocketReconnecting then
        self:onSocketReconnecting();
    elseif eventType == kSocketConnectivity then
        self:onSocketConnectivity(param);
    elseif eventType == kSocketConnectFailed then
        self:onSocketConnectFailed();
    elseif eventType == kSocketRecvPacket then
        self:onSocketServerPacket(param);
    elseif eventType == kSocketUserClose then
    	self:onSocketClosed();
	end
end

--heart beat 
GameSocket.startHeartBeat = function(self)
	if not self.m_heartBeatCmd then
		return;
	end

	GameSocket.stopHeartBeat(self);
	self.m_heartBeatAnim = new(AnimDouble,kAnimRepeat,0,1,self.m_heartBeatInterval * 2,0);
	self.m_heartBeatAnim:setDebugName("GameSocket || m_heartBeatAnim");
	self.m_heartBeatAnim:setEvent(self,GameSocket.onHeartBeat);
end

GameSocket.stopHeartBeat = function(self)
	delete(self.m_timeOutAnim);
	self.m_timeOutAnim = nil;
	delete(self.m_heartBeatAnim);
	self.m_heartBeatAnim = nil;
end

GameSocket.onHeartBeat = function(self)
	local packetId = self:writeBegin(self.m_socket,self.m_heartBeatCmd);
	self:writeEnd(packetId);

	GameSocket.restartTimer(self);
end

GameSocket.onHeartBeatTimeout = function(self)
	GameSocket.stopHeartBeat(self);
	self:onTimeout();
end

GameSocket.restartTimer = function(self)
	self:stopTimer();

	self.m_timeOutAnim = new(AnimInt, kAnimNormal,0,1,self.m_heartBeatInterval,0);
	self.m_timeOutAnim:setDebugName("GameSocket || m_timeOutAnim");
	self.m_timeOutAnim:setEvent(self, GameSocket.onHeartBeatTimeout);
end

GameSocket.onNetSlowTip = function(self)
	AlarmTip.play(GameString.get("heartBeatNetSlowTips"));
end

GameSocket.stopTimer = function(self)
	delete(self.m_timeOutAnim);
	self.m_timeOutAnim = nil;
end

GameSocket.addSocketHandler = function(self,vtable,valueType,value)
	if value and (not typeof(value,valueType)) then
		error("add error type to gamesocket");
	end

	if self:checkExist(vtable,value) then
		return false;
	end

	table.insert(vtable,1,value);
	return true;
end

GameSocket.removeSocketHandler = function(self,vtable,value)
	local index = self:getIndex(vtable,value);
	if index ~= -1 then
		table.remove(vtable,index);
		return true;
	end

	return false;
end

GameSocket.getIndex = function(self,vtable,value)
	for k,v in pairs(vtable or {}) do 
		if v == value then
			return k;
		end
	end

	return -1;
end

GameSocket.checkExist = function(self,vtable,value)
	return self:getIndex(vtable,value) ~= -1;
end
