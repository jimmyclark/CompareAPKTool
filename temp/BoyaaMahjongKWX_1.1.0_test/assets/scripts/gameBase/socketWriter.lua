require("core/object");

SocketWriter = class();

SocketWriter.ctor = function(self)
	self.m_socket = nil;	-- 操作的套接字
end

SocketWriter.writePacket = function(self, socket, packetId, cmd, info)
	self.m_socket = socket;

	if self.s_clientCmdFunMap[cmd] then
		printInfo("发送命令字 ========================= 0x%04x", cmd)
		self.s_clientCmdFunMap[cmd](self,packetId,info);
		dump(info)
		return true;
	end

	return false;
end

SocketWriter.s_clientCmdFunMap = {
};