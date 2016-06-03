--[[
	河北麻将（房间）接收协议  2015-03-03
]]
local HbmjReader = class(SocketReader)
local printInfo, printError = overridePrint("HbmjReader")
function HbmjReader:ctor()
	self.m_sockName = "河北"
end
--[[
	河北麻将（房间）接收协议
]]
HbmjReader.s_severCmdFunMap = {
	
}

return HbmjReader
