local createRoomConfig = class()

GameMode = {
	Piao = 20,
}

addProperty(createRoomConfig, "basePointId", 0)
addProperty(createRoomConfig, "beiId", 0)
addProperty(createRoomConfig, "roundNumId", 0)
addProperty(createRoomConfig, "playTypeId", 0)
addProperty(createRoomConfig, "isPiao", 1)

addProperty(createRoomConfig, "basePoint", {})
addProperty(createRoomConfig, "bei", {})
addProperty(createRoomConfig, "roundNum", {})
addProperty(createRoomConfig, "playType", {})

return createRoomConfig