--[[
	国标麻将（房间）发送协议  2015-03-03
]]
local BaseWriter = require("mjSocket.game.baseWriter")
local GbmjWriter = class(BaseWriter)
local printInfo, printError = overridePrint("GbmjWriter")

--[[
	国标麻将（房间）发送协议
]]
function GbmjWriter:initCommandFuncMap()
	GbmjWriter.super.initCommandFuncMap(self)
	
	--[[
		国标麻将（房间）接收协议
	]]
	local s_clientCmdFunMap = {
		-- [Command.xx]     = self.onXX,	--
	}
	table.merge(self.s_clientCmdFunMap, s_clientCmdFunMap)
end

return GbmjWriter
