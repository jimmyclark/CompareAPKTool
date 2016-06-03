require("core/object");
SocketReader = class();

SocketReader.ctor = function(self)
	self.m_socket = nil;	-- 操作的套接字
	self.m_sockName = "全局"
end

SocketReader.readPacket = function(self, socket, packetId, cmd)
	self.m_socket = socket;

	local packetInfo = nil;
	if self.s_severCmdFunMap[cmd] then
		printInfo("%s处理命令字 ========================= 0x%04x", self.m_sockName, cmd)
		packetInfo = self.s_severCmdFunMap[cmd](self,packetId);
   		dump(packetInfo)
   	else
		printInfo("%s略过命令字 ========================= 0x%04x", self.m_sockName, cmd)
	end
	
	return packetInfo;
end

SocketReader.s_severCmdFunMap = {

};