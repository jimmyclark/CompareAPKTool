-- socket.lua
-- Author: Vicent Gong
-- Date: 2012-09-30
-- Last modification : 2014-12-04 by cuipeng
-- Description: provide basic wrapper for socket functions

require("core/object");

Socket = class();
Socket.s_sockets = {};

PROTOCOL_TYPE_BUFFER="BUFFER"
PROTOCOL_TYPE_BY9="BY9"
PROTOCOL_TYPE_BY14="BY14"
PROTOCOL_TYPE_QE="QE"
PROTOCOL_TYPE_TEXAS="TEXAS"
PROTOCOL_TYPE_VOICE="VOICE"
PROTOCOL_TYPE_BY7="BY7"

Socket.ctor = function(self,sockName,sockHeader,netEndian)

	if Socket.s_sockets[sockName] then
		error("Already have a " .. sockName .. " socket");
		return;
	end
	
	self.m_socketType = sockName;	
	Socket.s_sockets[sockName] = self;
	self:setProtocol ( sockHeader, netEndian );	
	
	-- print_string("##################################"..sockName.."-"..sockHeader.."-"..netEndian);
end

Socket.dtor = function(self)
	Socket.s_sockets[self.m_socketType] = nil;
end

Socket.setProtocol = function ( self,sockHeader,netEndian )
	printInfo("sockHeader = %s, netEndian = %d", sockHeader, netEndian)
	socket_set_protocol ( self.m_socketType, sockHeader, netEndian );
end

Socket.setEvent = function(self,obj,func)
	self.m_cbObj = obj;
	self.m_cbFunc = func;
end

Socket.onSocketEvent = function(self,eventType, param)
	printInfo("eventType = %s", eventType)
	if self.m_cbFunc then
		self.m_cbFunc(self.m_cbObj,eventType, param);
	end
end

Socket.reconnect = function(self,num,interval)
	
end

Socket.open = function(self,ip,port)
	return socket_open(self.m_socketType,ip,port);
end

Socket.close = function(self,param)
	return socket_close(self.m_socketType,param or -1);
end

Socket.writeBegin = function(self,cmd,ver,subVer,deviceType)
	return socket_write_begin(self.m_socketType,cmd,ver,subVer,deviceType);
end

Socket.writeBegin2 = function(self,cmd,subCmd,ver,subVer,deviceType)
	return socket_write_begin2(self.m_socketType,cmd,subCmd,ver,subVer,deviceType);
end

Socket.writeBegin3 = function(self,cmd,ver,gameId)
	return socket_write_begin3(self.m_socketType,ver,cmd,gameId);
end

Socket.writeBegin4 = function(self,cmd,ver)
	return socket_write_begin4(self.m_socketType,ver,cmd);
end

Socket.writeByte = function(self,packetId,value)
	return socket_write_byte(packetId,value);
end

Socket.writeShort = function(self,packetId,value)
	return socket_write_short(packetId,value);
end

Socket.writeInt = function(self,packetId,value)
	return socket_write_int(packetId,value);
end

Socket.writeInt64 = function( self,packetId,value )
	return socket_write_int64(packetId,value);
end

Socket.writeString = function(self,packetId,value)
	return socket_write_string(packetId,value);
end

Socket.writeBuffer = function(self,value)
	return socket_write_buffer(self.m_socketType,value);
end

Socket.writeBinary = function(self, packetId, string, compress)
	return socket_write_string_compress(packetId, string, compress)
end

Socket.writeEnd = function(self,packetId)
	return socket_write_end(packetId);
end

Socket.readBegin = function(self,packetId)
	return socket_read_begin(packetId);
end

Socket.readSubCmd = function(self,packetId)
	return socket_read_sub_cmd(packetId);
end

Socket.readByte = function(self,packetId,defualtValue)
	return socket_read_byte(packetId,defualtValue);
end

Socket.readShort = function(self,packetId,defualtValue)
	return socket_read_short(packetId,defualtValue);
end

Socket.readInt = function(self,packetId,defualtValue)
	return socket_read_int(packetId,defualtValue);
end

Socket.readInt64 = function( self,packetId,defualtValue )
	return socket_read_int64(packetId,defualtValue);
end

Socket.readString = function(self,packetId)
	return socket_read_string(packetId);
end

Socket.readBinary = function(self, packetId)
	return socket_read_string_compress(packetId)
end

Socket.readEnd = function(self,packetId)
	return socket_read_end(packetId);
end

function event_socket(sockName, eventType, param, num)
	-- print_string("##################################"..sockName.."-"..eventType.."-"..param);
	if Socket.s_sockets[sockName] then
		Socket.s_sockets[sockName]:onSocketEvent(eventType, param);
	end
end
