local RoomCoord = {
	Timer = {
		x = display.cx, y = display.cy
	},
	UserReadyPos = {
		[1] = { x = display.cx, y = display.bottom - 95 },
		[2] = { x = display.right - 260, y = display.cy },
		[3] = { x = display.cx, y = display.top + 200 },
		[4] = { x = display.left + 260, y = display.cy },
	},
	ReadyViewPos = {
		[1] = { x = display.cx, y = display.bottom - 200 },
		[2] = { x = display.right - 460, y = display.cy + 10 },
		[3] = { x = display.cx, y = display.top + 290 },
		[4] = { x = display.left + 460, y = display.cy + 10 },
	},
	GameHeadPos = {
		[1] = { x = display.cx, y = display.bottom, xDouble = 0.5, yDouble = 0.5},
		[2] = { x = display.right, y = display.cy, xDouble = -0.9, yDouble = -0.6},
		[3] = { x = display.cx, y = display.top, xDouble = -0.5, yDouble = 0},
		[4] = { x = display.left, y = display.cy, xDouble = -0.1, yDouble = -0.6},
	},
	UserGamePos = {
		[1] = { x = display.left + 100, y = display.bottom - 100 },
		[2] = { x = display.right - 100, y = display.top + 150 },
		[3] = { x = display.left + 150, y = display.top + 100 },
		[4] = { x = display.left + 100, y = display.top + 200 },
	},
	OpAnimPos = {
		[1] = { x = display.cx, y = display.bottom - 330 },
		[2] = { x = display.right - 300, y = display.cy - 45 },
		[3] = { x = display.cx, y = display.top + 150 },
		[4] = { x = display.left + 300, y = display.cy - 45 },
	},
	AiBtnPos = {
		[1] = { x = display.cx, y = display.bottom - 300 },
		[2] = { x = display.right - 300, y = display.cy },
		[3] = { x = display.cx, y = display.top + 170 },
		[4] = { x = display.left + 300, y = display.cy },
	},
	OperatePos 		= { x = display.pos, y = display.bottom - 200 },
	-- Layer
	PlayerLayer 	= {
		[1] = 4,
		[2] = 2,
		[3] = 2,
		[4] = 2,
	},
	UserPanelLayer  = {
		[1] = 4,
		[2] = 3,
		[3] = 2,
		[4] = 3,
	},
	CardPanelLayer = {
		[1] = 3,
		[2] = 2,
		[3] = 2,
		[4] = 2,
	},
	GameCardPanelLayer = {
		
	},
	IconLayer = 5, --层位于我的下方
	PlayerLevels = {
		[1] = 4,
		[2] = 3,
		[3] = 2,
		[4] = 1,
	},
	OutCardFingerLayer = 4,
	Huan3PanelPos = {
		x = display.cx, y = display.bottom - 270
	},
	Huan3PanelLayer = 11,
	BigOutCardLayer = 21,
	SettingLayer = 1,
	ReadyLayer = 10,
	AiLayer = 20,
	TingLayer = 22,
	TimerLayer 		= 20,
	OperateLayer 	= 20,
	TipLayer	 	= 25,
	AnimLayer  		= 30,
	LoadingLayer 	= 100,
}

return RoomCoord