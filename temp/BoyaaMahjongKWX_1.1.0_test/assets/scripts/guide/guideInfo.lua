local path = "new_guide/"
local GuideConfig = {
	[GameType.GBMJ] = {
		FirstEnter = {
			pos = {x = 450, y = 70},
			tip = "欢迎来到国标麻将场\n国标麻将不同底注场起胡番数不同，低于胡牌番数，不能胡牌。",
			timeout = 5000,
		},

		-- FirstChi = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n上家对你这么好，快吃！",
		-- },

		-- FirstPeng = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n运气不错哦~快去碰，有碰才有杠！",
		-- },

		-- FirstGang = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n哎呦~不错哦！可以杠了",
		-- },

		FirstHu = {
			pos = {x = 680, y = 80},
			tip = "\n哇，运气很好哦~！可以胡咯！",
		},

		GirlFile = path .. "gb_girl.png",
	},

	[GameType.KWXMJ] = {
		FirstEnter_TDH = {
			pos = {x = 450, y = 70},
			tip = "欢迎来到广东麻将场\n广东推倒胡玩法，只有自摸才可以胡牌。",
			timeout = 5000,
		},

		FirstEnter_JPH = {
			pos = {x = 450, y = 70},
			tip = "欢迎来到广东麻将场，鸡平胡玩法。",
			timeout = 5000,
		},

		FirstPengGang_TDH = {
			pos = {x = 680, y = 80},
			tip = "可以杠牌了，推倒胡明杠，可立即获得获3倍底注哦！",
		},

		FirstAnGang_TDH = {
			pos = {x = 680, y = 80},
			tip = "自己抓到4张一样的！推倒胡暗杠，可立即获得6倍底注！",
		},

		-- FirstChi = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n上家对你这么好，快吃！",
		-- },

		-- FirstPeng = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n运气不错哦~快去碰，有碰才有杠！",
		-- },

		-- FirstGang = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n哎呦~不错哦！可以杠了",
		-- },

		FirstHu = {
			pos = {x = 680, y = 80},
			tip = "\n哇，运气很好哦~！可以胡咯！",
		},

		GirlFile = path .. "gd_girl.png",
	},

	[GameType.SHMJ] = {
		FirstEnter = {
			pos = {x = 450, y = 70},
			tip = "欢迎来到上海麻将场\n勒子：指输钱上限。风碰可以达到4个勒子；荒番、开宝可以将勒子数提升2倍。",
			timeout = 5000,
		},

		FirstChengBao = {
			pos = {x = 450, y = 160},
			tip = "承包：吃碰杠一家或被一家吃碰杠3次以上。点炮记分承包者付一份；自摸记分承包者付3份。",
		},

		-- FirstChi = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n上家对你这么好，快吃！",
		-- },

		-- FirstPeng = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n运气不错哦~快去碰，有碰才有杠！",
		-- },

		-- FirstGang = {
		-- 	pos = {x = 680, y = 80},
		-- 	tip = "\n哎呦~不错哦！可以杠了",
		-- },

		FirstHu = {
			pos = {x = 680, y = 80},
			tip = "\n哇，运气很好哦~！可以胡咯！",
		},

		GirlFile = path .. "sh_girl.png",
	},
}

return GuideConfig