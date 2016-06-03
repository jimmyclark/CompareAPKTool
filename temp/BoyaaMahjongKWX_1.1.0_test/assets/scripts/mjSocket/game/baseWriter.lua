--[[
    写socket基类
    用作各个麻将writer的基类
]]
local BaseWriter = class(SocketWriter)

function BaseWriter:ctor()
    self:initCommandFuncMap()
end

function BaseWriter:initCommandFuncMap()
end

return BaseWriter