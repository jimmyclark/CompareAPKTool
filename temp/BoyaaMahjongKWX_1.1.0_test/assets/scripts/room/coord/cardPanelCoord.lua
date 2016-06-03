local bgPath = "room/cards/"
local imgPath = "room/extraCards/"
local leftImgPath = "room/hua_left_new/"
local rightImgPath = "room/hua_right_new/"
local leftExtraImgPath = "room/hua_left_extra_new/"
local rightExtraImgPath = "room/hua_right_extra_new/"

local bgPath = ""
local imgPath = ""
local leftImgPath = ""
local rightImgPath = ""
local leftExtraImgPath = ""
local rightExtraImgPath = ""

local CardPanelCoord = {
	tingCardBg = bgPath .. "ting_card_bg.png",
	-- 吃碰杠牌的背景
	extraCardBg = {  -- 出牌动画 麻将子背景
		[1] = bgPath .. "my_extra_bg.png",
		[2] = bgPath .. "right_extra_bg_%d.png",
		[3] = bgPath .. "oppo_out_bg_1-%d.png",
		[4] = bgPath .. "left_extra_bg_%d.png",
	},
	-- 吃碰杠牌的麻将子
	extraCardImage = {
		[1] = imgPath .. "my_hand_%d_0x%02x.png",
		[2] = rightExtraImgPath .. "little_extra_right_%d_0x%02x.png",
		[3] = imgPath .. "little_%d_0x%02x.png",
		[4] = leftExtraImgPath .. "little_extra_left_%d_0x%02x.png",
	},
	-- 暗杠的麻将子（整个）
	extraAnGangImage = {
		[1] = bgPath .. "my_extra_an.png",
		[2] = bgPath .. "right_extra_an_%d.png",
		[3] = bgPath .. "oppo_extra_an_%d.png",
		[4] = bgPath .. "left_extra_an_%d.png",
	},
	-- 吃碰杠的牌 相对手牌位置的偏移量
	extraToHandDiff = {
		[1] = {x = 0, y = 0},
		[2] = {x = 0, y = 0},
		[3] = {x = 0, y = 20},
		[4] = {x = 20, y = 0},
	},
	-- 每个碰杠牌间隔的距离
	extraCardDiff = {
		[1] = { xDouble = 0.93, yDouble = 0, xGangDouble = 0, yGangDouble = -0.2},
		[2] = { xDouble = 0, yDouble = -0.43, xGangDouble = 0, yGangDouble = -0.3},
		[3] = { xDouble = -0.83, yDouble = 0, xGangDouble = 0.05, yGangDouble = -0.3},
		[4] = { xDouble = 0	, yDouble = 0.43, xGangDouble = 0, yGangDouble = -0.3},
	},
	extraCardGroupSpace = {
		[1] = {x = 10, y = 0},
		[2] = {x = 0, y = -4},
		[3] = {x = -10, y = 0},
		[4] = {x = -2, y = 4},
	},
	--碰杠牌的缩放比例
	extraCardScale = {
		[1] = 1.0,
		[2] = 1.0,
		[3] = 1.0,
		[4] = 1.0,
	},
	-- 手牌背景
	handCardBg = {
		[1] = bgPath .. "my_hand_bg.png", 
		[2] = bgPath .. "right_hand_1.png",
		[3] = bgPath .. "oppo_hand_1.png", 
		[4] = bgPath .. "left_hand_1.png", 
	},
	-- 手牌麻将子
	handCardImage = {
		[1] = imgPath .. "my_hand_%d_0x%02x.png",
		[2] = imgPath .. "little_%d_0x%02x.png", 
		[3] = imgPath .. "little_%d_0x%02x.png", 
		[4] = imgPath .. "little_%d_0x%02x.png", 
	},
	-- 手牌间隔比例
	handCardDiff = {
		[1] = { xDouble = 0.94, yDouble = 0 },
		[2] = { xDouble = -0.145, yDouble = -0.3 },
		[3] = { xDouble = -0.65, yDouble = 0 },
		[4] = { xDouble = -0.145, yDouble = 0.3 },
	},
	extraHandCardDiff = {
		[1] = { x = 0, y = 0 },
		[2] = { x = -6, y = -10 },
		[3] = { x = -10, y = 0 },
		[4] = { x = 0, y = 10 },
	},
	-- 手牌缩放比例
	handCardScale = {
		[1] = 1.0,
		[2] = 1.0,
		[3] = 1.0,
		[4] = 1.0,
	},
	-- 手牌和碰杠牌间隔
	handToExtraDiff = {
		[1] = { x = 10, y = 8 },
		[2] = { x = 0, y = -30 },
		[3] = { x = -10, y = 0 },
		[4] = { x = 0, y = -10 },
	},
	--盖牌麻将子（整个）
	gaiPaiFileName = {
		[1] = bgPath .. "my_extra_back.png",
		[2] = bgPath .. "l_r_gang.png",
		[3] = bgPath .. "oppo_extra_back.png",
		[4] = bgPath .. "l_r_gang.png",
	},
	-- 吃碰杠牌的起始位置（同时会在程序运行时根据座位重新自动计算某一坐标的值）
	extraCardStartPos = {
		[1] = { x = display.left + 100, 	y = display.bottom - 55 }, 
		[2] = { x = display.right - 260, 	y = display.bottom - 230 }, 
		[3] = { x = display.right - 320, 	y = display.top + 125 },     
		[4] = { x = display.left + 70, 	y = display.top + 170 },    	
	},
	TingIconPos = {
		[1] = { x = display.cx, 			y = display.bottom - 120 },
		[2] = { x = display.right - 120, 	y = display.cy },
		[3] = { x = display.cx,	 			y = display.top + 160 },
		[4] = { x = display.left + 120, 	y = display.cy },
	},
	-- 吃碰杠牌起始偏移量
	extraCardStartDiff = {
		[1] = { x = 0, y = 0},
		[2] = { x = 0, y = 0},
		[3] = { x = 0, y = 0},
		[4] = { x = 0, y = -70},
	},
	-- 出牌起始位置（同时会在程序运行时根据座位重新自动计算某一坐标的值）
	outCardStartPos = {
		[1] = { x = display.cx, 			y = display.bottom - 175 }, 	
		[2] = { x = display.right - 320, 	y = display.cy - 10 }, 	
		[3] = { x = display.cx, 			y = display.top + 178 },	
		[4] = { x = display.left + 190, 	y = display.cy - 20 },	
	},

	-- 胡牌位置
	huCardPos = {
		[1] = { x = display.left + 0, 	y = display.top +0 },	
		[2] = { x = display.right - 332, 	y = display.height/5 },	
		[3] = { x = display.left + 0, 	y = display.top +0 },	
		[4] = { x = display.left + 416, 	y = display.height/5 },		

	},
	-- 出牌背景
	outCardBg = {  -- 出牌动画 麻将子背景
		[1] = bgPath .. "my_out_bg_%d-%d.png",
		[2] = bgPath .. "right_out_bg_%d-%d.png",
		[3] = bgPath .. "oppo_out_bg_%d-%d.png",   -- 行- 个数
		[4] = bgPath .. "left_out_bg_%d-%d.png",
	},
	-- 出牌麻将子
	outCardImage = {
		[1] = imgPath .. "little_%d_0x%02x.png",
		[2] = rightImgPath .. "little_right_%d_0x%02x.png",
		[3] = imgPath .. "little_%d_0x%02x.png",
		[4] = leftImgPath .. "little_left_%d_0x%02x.png",
	},
	-- 出牌位移
	outCardDiff = {
		[1] = { xDouble = 0.85, yDouble = 0 },
		[2] = { xDouble = 0, yDouble = -0.42 },
		[3] = { xDouble = -0.88, yDouble = 0 },
		[4] = { xDouble = 0, yDouble = 0.42 },
	},
	-- 出牌换行位移
	outCardLineDiff = {
		[1] = { xDouble = 0, yDouble = -0.58 },
		[2] = { xDouble = -0.88, yDouble = 0 },
		[3] = { xDouble = 0, yDouble = 0.49 },
		[4] = { xDouble = 1.36, yDouble = 0 },
	},
	-- 出牌缩放
	outCardScale = {
		[1] = 1.0,
		[2] = 1.0,
		[3] = 1.0,
		[4] = 1.0,
	},
	outCardDiffY = 130,
	-- 每行出牌数目
	outCardLineNum = 10,
	-- 每行出牌增加的数目
	outCardLineStep = -2,
	-- 出牌大牌显示
	bigOutCardBg = bgPath .. "my_hand_bg.png",
	-- 出牌麻将子
	bigOutCardImg = imgPath .. "own_hand_0x%02x.png",
	-- 出牌大牌坐标
	bigOutCardPos = {
		[1] = { x = display.width / 2, 		y = display.cy + 100 },
		[2] = { x = display.width * 3 / 4, 	y = display.cy - 20 },
		[3] = { x = display.width / 2, 		y = display.cy - 150 },
		[4] = { x = display.width / 4, 		y = display.cy - 20 },
	},
	-- 抓牌 位移
	addCardDiff = {
		[1] = { x = 20, y = 0 },
		[2] = { x = -5, y = -15 },
		[3] = { x = -15, y = 0 },
		[4] = { x = -5, y = 15 },
	},
	-- 手牌层
	handCardLayer = {
		[1] = 40,
		[2] = 1,
		[3] = 1,
		[4] = 2,
	},
	-- 吃碰杠牌 层
	extraCardLayer = {
		[1] = 1,
		[2] = 20,  -- 玩家二需要递减
		[3] = 1,
		[4] = 1,
	},
	-- 出牌层
	outCardLayer = {
		[1] = 30,
		[2] = 30,
		[3] = 30,
		[4] = 30,
	},
	--出牌动画层
	outCardAnimLayer = 22,
	-- 房间动画层
	aiLayer = 23,
	-- 出牌箭头偏移
	pointerDiff = {
		[1] =	25,
		[2] = 	15,
		[3] = 	25,
		[4] =   15,
	},
	cardAlign = {
		[1] = kAlignBottomLeft,
		[2] = kAlignTopLeft,
		[3] = kAlignTopLeft,
		[4] = kAlignTopLeft,
	},
}

return CardPanelCoord