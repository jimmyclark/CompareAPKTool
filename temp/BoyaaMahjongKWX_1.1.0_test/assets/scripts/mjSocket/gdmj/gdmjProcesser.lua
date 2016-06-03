--[[
	广东麻将（房间）协议  2015-03-03
]]
local GdmjProcesser = class(SocketProcesser)
local printInfo, printError = overridePrint("GdmjProcesser")

function GdmjProcesser:onGfxyBd(data)

end


--[[
	广东麻将（房间）协议
]]
local s_severCmdFunMap = {
	[Command.GfxyBd]            = GdmjProcesser.onGfxyBd,
}

table.merge(GdmjProcesser.s_severCmdFunMap, s_severCmdFunMap)

return GdmjProcesser