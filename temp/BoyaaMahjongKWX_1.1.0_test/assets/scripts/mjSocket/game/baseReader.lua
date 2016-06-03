--[[
    读socket基类
    用作各个麻将reader的基类
]]
local BaseReader = class(SocketReader)
-------------------通用协议-------------------------
function BaseReader:ctor()
    self:initCommandFuncMap()
end

-- 发牌后广播开始游戏 0x4003
function BaseReader:onGameStartBd(packetId)
    local info = {
        iHuaInfos = {},
    }
    -- 4个玩家的花牌数目
    local huaCount = 0
    -- SOCKET_TODO  循环数量
    for i=1, PLAYER_COUNT do
        local temp = {}
        temp.iUserId = self.m_socket:readInt(packetId, -1)
        temp.iHuaCards = self:readHandCardsTb(packetId)
        table.insert(info.iHuaInfos, temp)
    end
    return info
end

-------------------通用读取方法---------------------
-- 手牌
function BaseReader:readHandCardsTb(packetId)
	local cardsTb = {}
	local cardCount = self.m_socket:readInt(packetId, -1)
    dump("手牌================" .. cardCount)
    for i=1, cardCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	table.insert(cardsTb, card)
    end
    dump(cardsTb)
    return cardsTb
end

 -- 花牌 以及 (byte类型的数量)的牌
function BaseReader:readCardsTb(packetId)
	local cardsTb = {}
    local cardCount = self.m_socket:readByte(packetId, -1)
    for i=1, cardCount do
    	local card = self.m_socket:readByte(packetId, -1)
    	table.insert(cardsTb, card)
    end
    return cardsTb
end

function BaseReader:initCommandFuncMap()
    --[[
        国标麻将（房间）接收协议
    ]]
    self.s_severCmdFunMap = {
        [Command.GameStartBd]        = self.onGameStartBd,      --广播发牌
    }
end

return BaseReader