--[[
	上海麻将（房间）协议  2015-03-03
]]
local ShmjProcesser = class(SocketProcesser)
local printInfo, printError = overridePrint("ShmjProcesser")

function ShmjProcesser:onGfxyBd(data)

end


--[[
	上海麻将（房间）协议
]]
local s_severCmdFunMap = {

}

table.merge(ShmjProcesser.s_severCmdFunMap, s_severCmdFunMap)

return ShmjProcesser