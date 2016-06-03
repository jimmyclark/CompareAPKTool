--[[
	河北麻将（房间）发送协议  2015-03-03
]]
local HbmjWriter = class(SocketWriter)
local printInfo, printError = overridePrint("HbmjWriter")

--[[
	河北麻将（房间）发送协议
]]
HbmjWriter.s_clientCmdFunMap = {
}

return HbmjWriter
