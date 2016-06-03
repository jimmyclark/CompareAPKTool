--[[
	国标麻将（房间）协议  2015-03-03
]]
local GbmjProcesser = class(SocketProcesser)
local printInfo, printError = overridePrint("GbmjProcesser")

--[[
	国标麻将（房间）协议
]]
GbmjProcesser.s_severCmdEventFuncMap = {
}
return GbmjProcesser