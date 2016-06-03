SoundType = {
	Common = 1,
	GBMJ   = 2,
	KWXMJ   = 3,
	SHMJ   = 4,
	HBMJ   = 5,
}
local folderMap = {
	[SoundType.Common] = "common/",
	[SoundType.GBMJ] = "gbmj/",
	[SoundType.KWXMJ] = "kwxmj/",
	[SoundType.SHMJ] = "shmj/",
	[SoundType.HBMJ] = "hbmj/",
}

RoomSoundMap = {
	[GameType.GBMJ] = {
		soundType = SoundType.GDMJ,
		str = "广东话",
		setMethod = "setGbSoundType",
		getMethod = "getGbSoundType",
		loaded = false,
	},
	[GameType.KWXMJ] = {
		soundType = SoundType.KWXMJ,
		str = "襄阳话",
		setMethod = "setGdSoundType",
		getMethod = "getGdSoundType",
		loaded = false,
	},
	[GameType.SHMJ] = {
		soundType = SoundType.SHMJ,
		str = "上海话",
		setMethod = "setShSoundType",
		getMethod = "getShSoundType",
		loaded = false,
	},
	[GameType.HBMJ] = {
		soundType = SoundType.Common,
		str = "河北话",
		setMethod = "setHbSoundType",
		getMethod = "getHbSoundType",
		loaded = false,
	},
}

Music = {
	AudioGameBack = "Audio_Game_Back";
}

-- 多音效版本
local mutiEffectMap = {
	ManBuHua = "man_buhua",
	ManChi  = {"man_chi0", "man_chi1", "man_chi2"},
	ManGangAG = "man_gang_AG",
	ManGangBG = {"man_bugang0", "man_bugang1"},
	ManGang  = {"man_gang0", "man_gang1", "man_gang2"},
	ManHu    = {"man_hu0", "man_hu1", "man_hu2"},
	ManPeng  = {"man_peng0", "man_peng1", "man_peng2"},
	ManZiMo  = {"man_zimo0", "man_zimo1"},
	ManPiao	 = "man_piao",
	ManLiangDao = "man_liangdao",

	ManCard_11 = {"man_card_11_1", "man_card_11_2"},
	ManCard_12 = {"man_card_12_1", "man_card_12_2"},
	ManCard_13 = "man_card_13_1",
	ManCard_14 = "man_card_14_1",
	ManCard_15 = "man_card_15_1",
	ManCard_16 = "man_card_16_1",
	ManCard_17 = "man_card_17_1",
	ManCard_18 = "man_card_18_1",
	ManCard_19 = "man_card_19_1",

	ManCard_21 = {"man_card_21_1", "man_card_21_2"},
	ManCard_22 = "man_card_22_1",
	ManCard_23 = "man_card_23_1",
	ManCard_24 = "man_card_24_1",
	ManCard_25 = "man_card_25_1",
	ManCard_26 = "man_card_26_1",
	ManCard_27 = "man_card_27_1",
	ManCard_28 = "man_card_28_1",
	ManCard_29 = "man_card_29_1",

	ManCard_41 = "man_card_31_1",
	ManCard_42 = "man_card_32_1",
	ManCard_43 = {"man_card_33_1", "man_card_33_2", "man_card_33_3"},

	WomanBuHua = "woman_buhua",
	WomanChi  = {"woman_chi0", "woman_chi1", "woman_chi2"},
	WomanGangAG = "woman_gang_AG",
	WomanGangBG = {"woman_bugang0", "woman_bugang1"},
	WomanGang  = {"woman_gang0", "woman_gang1", "woman_gang2"},
	WomanHu    = {"woman_hu0", "woman_hu1", "woman_hu2"},
	WomanPeng  = {"woman_peng0", "woman_peng1", "woman_peng2"},
	WomanZiMo  = {"woman_zimo0", "woman_zimo1"},
	WomanPiao	 = "woman_piao",
	WomanLiangDao = "woman_liangdao",

	WomanCard_11 = {"woman_card_11_1", "woman_card_11_2"},
	WomanCard_12 = {"woman_card_12_1"},
	WomanCard_13 = "woman_card_13_1",
	WomanCard_14 = "woman_card_14_1",
	WomanCard_15 = "woman_card_15_1",
	WomanCard_16 = "woman_card_16_1",
	WomanCard_17 = "woman_card_17_1",
	WomanCard_18 = "woman_card_18_1",
	WomanCard_19 = "woman_card_19_1",

	WomanCard_21 = {"woman_card_21_1", "woman_card_21_2"},
	WomanCard_22 = "woman_card_22_1",
	WomanCard_23 = "woman_card_23_1",
	WomanCard_24 = "woman_card_24_1",
	WomanCard_25 = "woman_card_25_1",
	WomanCard_26 = "woman_card_26_1",
	WomanCard_27 = "woman_card_27_1",
	WomanCard_28 = "woman_card_28_1",
	WomanCard_29 = "woman_card_29_1",

	WomanCard_41 = "woman_card_31_1",
	WomanCard_42 = "woman_card_32_1",
	WomanCard_43 = {"woman_card_33_1"},

	ManChat0	= "man_chat_01",
	ManChat1	= "man_chat_02",
	ManChat2	= "man_chat_03",
	ManChat3	= "man_chat_04",
	ManChat4	= "man_chat_05",
	ManChat5	= "man_chat_06",
	ManChat6	= "man_chat_07",
	ManChat7	= "man_chat_08",

	WomanChat0	= "woman_chat_01",
	WomanChat1	= "woman_chat_02",
	WomanChat2	= "woman_chat_03",
	WomanChat3	= "woman_chat_04",
	WomanChat4	= "woman_chat_05",
	WomanChat5	= "woman_chat_06",
	WomanChat6	= "woman_chat_07",
	WomanChat7	= "woman_chat_08",
}

-- 多音效版本
local commomMutiEffectMap = {
	ManBuHua = "man_buhua",
	ManChi  = {"man_chi0", "man_chi1", "man_chi2"},
	ManGangAG = "man_gang_AG",
	ManGangBG = {"man_bugang0"},
	ManGang  = {"man_gang0", "man_gang1", "man_gang2"},
	ManHu    = {"man_hu0", "man_hu1", "man_hu2"},
	ManPeng  = {"man_peng0", "man_peng1", "man_peng2"},
	ManZiMo  = {"man_zimo0", "man_zimo1"},
	ManPiao	 = "man_piao",
	ManLiangDao = "man_liangdao",

	ManCard_11 = {"man_card_11_1"},
	ManCard_12 = {"man_card_12_1"},
	ManCard_13 = "man_card_13_1",
	ManCard_14 = "man_card_14_1",
	ManCard_15 = "man_card_15_1",
	ManCard_16 = "man_card_16_1",
	ManCard_17 = "man_card_17_1",
	ManCard_18 = "man_card_18_1",
	ManCard_19 = "man_card_19_1",

	ManCard_21 = {"man_card_21_1"},
	ManCard_22 = "man_card_22_1",
	ManCard_23 = "man_card_23_1",
	ManCard_24 = "man_card_24_1",
	ManCard_25 = "man_card_25_1",
	ManCard_26 = "man_card_26_1",
	ManCard_27 = "man_card_27_1",
	ManCard_28 = "man_card_28_1",
	ManCard_29 = "man_card_29_1",

	ManCard_41 = "man_card_31_1",
	ManCard_42 = "man_card_32_1",
	ManCard_43 = {"man_card_33_1"},

	WomanBuHua = "woman_buhua",
	WomanChi  = {"woman_chi0", "woman_chi1", "woman_chi2"},
	WomanGangAG = "woman_gang_AG",
	WomanGangBG = {"woman_bugang0"},
	WomanGang  = {"woman_gang0", "woman_gang1", "woman_gang2"},
	WomanHu    = {"woman_hu0", "woman_hu1", "woman_hu2"},
	WomanPeng  = {"woman_peng0", "woman_peng1", "woman_peng2"},
	WomanZiMo  = {"woman_zimo0", "woman_zimo1"},

	WomanCard_11 = {"woman_card_11_1"},
	WomanCard_12 = {"woman_card_12_1"},
	WomanCard_13 = "woman_card_13_1",
	WomanCard_14 = "woman_card_14_1",
	WomanCard_15 = "woman_card_15_1",
	WomanCard_16 = "woman_card_16_1",
	WomanCard_17 = "woman_card_17_1",
	WomanCard_18 = "woman_card_18_1",
	WomanCard_19 = "woman_card_19_1",

	WomanCard_21 = {"woman_card_21_1"},
	WomanCard_22 = "woman_card_22_1",
	WomanCard_23 = "woman_card_23_1",
	WomanCard_24 = "woman_card_24_1",
	WomanCard_25 = "woman_card_25_1",
	WomanCard_26 = "woman_card_26_1",
	WomanCard_27 = "woman_card_27_1",
	WomanCard_28 = "woman_card_28_1",
	WomanCard_29 = "woman_card_29_1",

	WomanCard_41 = "woman_card_31_1",
	WomanCard_42 = "woman_card_32_1",
	WomanCard_43 = {"woman_card_33_1"},

	ManChat0	= "man_chat_01",
	ManChat1	= "man_chat_02",
	ManChat2	= "man_chat_03",
	ManChat3	= "man_chat_04",
	ManChat4	= "man_chat_05",
	ManChat5	= "man_chat_06",
	ManChat6	= "man_chat_07",
	ManChat7	= "man_chat_08",

	WomanChat0	= "woman_chat_01",
	WomanChat1	= "woman_chat_02",
	WomanChat2	= "woman_chat_03",
	WomanChat3	= "woman_chat_04",
	WomanChat4	= "woman_chat_05",
	WomanChat5	= "woman_chat_06",
	WomanChat6	= "woman_chat_07",
	WomanChat7	= "woman_chat_08",
}


local function convertMapBySoundType(tb, soundType)
	local prefix = folderMap[soundType]
	local newTb
	if prefix then
		newTb = {}
		for k,v in pairs(tb) do
			if type(v) == "string" then
				newTb[k] = prefix .. v
			elseif type(v) == "table" then
				newTb[k] = newTb[k] or {}
				for _, val in pairs(v) do
					table.insert(newTb[k], prefix .. val)
				end
			end
		end
	end
	return newTb or tb
end

Effects = {
	AudioButtonClick = "audio_button_click",
	AudioCardClick   = "audio_card_click",
	AudioCardOut     = "audio_card_out",
	AudioDealCard    = "audio_deal_card",
	AudioEnter       = "audio_enter",
	AudioLeft        = "audio_left",
	AudioLiuju       = "audio_liuju",
	AudioLose        = "audio_lose",
	AudioPoChan      = "audio_po_chan",
	AudioReady       = "audio_ready",
	AudioShaizi     = "audio_shaizi",
	AudioTing       = "audio_ting",
	AudioTipOperate  = "audio_tip_operate",
	AudioTwoGuan     = "audio_tuo_guan",
	AudioWarn        = "audio_warn",
	AudioWarning     = "audio_warning",
	AudioWin        = "audio_win",
	AudioGetGold    = "audio_get_gold",
	AudioUpGrade  	= "audio_upgrade",
	AudioGetCard  	= "audio_get_card",

	PropCheer1 		= "audio_exp_1007_1", -- 点赞    干杯  花束的声音
    PropCheer2 		= "audio_exp_1007_2", -- 点赞    干杯  花束的声音
    PropCheer3 		= "audio_exp_1007_3", -- 点赞    干杯  花束的声音

    PropBomb1 		= "audio_exp_1008_1", -- 炸弹的声音
    PropBomb2		= "audio_exp_1008_2", -- 炸弹的声音
    PropBomb3		= "audio_exp_1008_3", -- 炸弹的声音

    PropEgg1 		= "audio_exp_1009_1", -- 鸡蛋  番茄  肥皂的声音
    PropEgg2		= "audio_exp_1009_2", -- 鸡蛋  番茄  肥皂的声音
    PropEgg3		= "audio_exp_1009_3", -- 鸡蛋  番茄  肥皂的声音

    PropRock1 		= "audio_exp_1010_1", -- 石头的声音
    PropRock2 		= "audio_exp_1010_2", -- 石头的声音
    PropRock3 		= "audio_exp_1010_3", -- 石头的声音

    PropRose1		= "audio_exp_1011_1", -- 玫瑰 握手  嘴唇的声音
    PropRose2		= "audio_exp_1011_2", -- 玫瑰 握手  嘴唇的声音
    PropRose3		= "audio_exp_1011_3", -- 玫瑰 握手  嘴唇的声音

	mutiEffectMap 	= {
		[SoundType.Common] 	= convertMapBySoundType(commomMutiEffectMap, SoundType.Common),
		[SoundType.KWXMJ] 	= convertMapBySoundType(mutiEffectMap, SoundType.KWXMJ),
	}
}

require("gameBase/gameMusic");
require("gameBase/gameEffect");

kMusicPlayer=GameMusic.getInstance();
kEffectPlayer=GameEffect.getInstance();

kMusicPlayer:setSoundFileMap(Music);
kEffectPlayer:setSoundFileMap(Effects);

-- -- 重写播放方法
-- kEffectPlayer.play = function(self, index, loop)
-- 	if index then
-- 		GameSound.play(self, index, loop);
-- 	end
-- end
-- kMusicPlayer.play = function(self, index, loop)
-- 	if index then
-- 		GameSound.play(self, index, loop);
-- 	end
-- end
local prefix, extName
if System.getPlatform() == kPlatformAndroid then
	prefix="ogg/";
	extName=".ogg";
else
	prefix="mp3/";
	extName=".mp3";
end
kMusicPlayer:setPathPrefixAndExtName(prefix, extName);
kEffectPlayer:setPathPrefixAndExtName(prefix, extName);