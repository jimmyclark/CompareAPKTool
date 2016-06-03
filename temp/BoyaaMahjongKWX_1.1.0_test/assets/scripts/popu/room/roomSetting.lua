local RoomSetting = class(require("popu.gameWindow"))
local PATH = "kwx_tanKuang/lobbySetting/"

function RoomSetting:initView(userInfo)
	self.m_root:findChildByName("close_btn")
		:setOnClick(nil, function()
			self:dismiss()
		end)

	local effectView = self.m_root:findChildByName("effect_view")
	local musicView = self.m_root:findChildByName("music_view")

	local effectSlider = effectView:findChildByName("slider")
	local musicSlider = musicView:findChildByName("slider")

	effectSlider:setImages( PATH .. "img_processBg.png", PATH .. "img_processFg.png", PATH .. "btn_process.png");
	musicSlider:setImages( PATH .. "img_processBg.png", PATH .. "img_processFg.png", PATH .. "btn_process.png");

	printInfo("GameSetting:getSoundVolume() = %f", GameSetting:getSoundVolume())
	effectSlider:setProgress(GameSetting:getSoundVolume())
	effectSlider:setOnChange(nil, function()
		local progress = effectSlider:getProgress()
		GameSetting:setSoundVolume(progress)
		kEffectPlayer:setVolume(progress)
	end)
	effectView:findChildByName("min"):setOnClick(nil, function()
		GameSetting:setSoundVolume(0.0)
		kEffectPlayer:setVolume(0.0)
		effectSlider:setProgress(0)
	end)
	effectView:findChildByName("max"):setOnClick(nil, function()
		GameSetting:setSoundVolume(1.0)
		kEffectPlayer:setVolume(1.0)
		effectSlider:setProgress(1)
	end)

	musicSlider:setProgress(GameSetting:getMusicVolume())
	musicSlider:setOnChange(nil, function()
		local progress = musicSlider:getProgress()
		GameSetting:setMusicVolume(progress)
		kMusicPlayer:setVolume(progress)
	end)
	musicView:findChildByName("min"):setOnClick(nil, function()
		GameSetting:setMusicVolume(0.0)
		kMusicPlayer:setVolume(0.0)
		musicSlider:setProgress(0)
	end)
	musicView:findChildByName("max"):setOnClick(nil, function()
		GameSetting:setMusicVolume(1.0)
		kMusicPlayer:setVolume(1.0)
		musicSlider:setProgress(1)
	end)

	local leftBtn = self.m_root:findChildByName("left_btn")
	local leftText = self.m_root:findChildByName("left_text")

	local rightBtn = self.m_root:findChildByName("right_btn")
	local rightText = self.m_root:findChildByName("right_text")
	leftBtn:enableAnim(false)
	rightBtn:enableAnim(false)
	
	local selectColor = c3b( 0xFF, 0xFF, 0xFF)
	local unSelectColor = c3b( 0x50, 0xB4, 0xFF)
	local config = RoomSoundMap[G_RoomCfg:getGameType()] 
	local leftStr = config and config.str
	local rightStr = "普通话"
	leftText:setText(leftStr)

	local leftFunc = function()
		if not config then return end
		local soundType = config.soundType
		printInfo("soundType = %s", soundType)
		-- 判断声音是否需要下载， 是否可选
		if soundType == SoundType.KWXMJ then
			local kwxmjCanUse = PhpManager:getKwxmjCanUse()
			if kwxmjCanUse == 0 then
				AlarmTip.play("开始下载襄阳声音")
				PhpManager:setKwxmjCanUse(2)
				
				NativeEvent.getInstance():downloadFile("audio", ConnectModule:getInstance():getGdmjUrl(), "gdmj.zip", "广东声音");
				----NativeEvent.getInstance():downloadFile("audio", HallConfig:getGdmjUrl(), "gdmj.zip", "广东声音");
				return
			elseif kwxmjCanUse == 2 then
				AlarmTip.play("广东声音正在下载中，请稍后")
				return
			end
		end
		leftBtn:setFile("kwx_tanKuang/roomSetting/img_selected.png")
		leftText:setText(leftStr, nil, nil, selectColor.r, selectColor.g, selectColor.b)
		rightText:setText(rightStr, nil, nil, unSelectColor.r, unSelectColor.g, unSelectColor.b)
		rightBtn:setFile("ui/blank.png")
		GameSetting:setSoundType(config.soundType)
		GameSetting[config.setMethod](GameSetting, config.soundType)
	end
	leftBtn:setOnClick(nil, leftFunc)

	local rightFunc = function()
		rightBtn:setFile("kwx_tanKuang/roomSetting/img_selected.png")
		leftBtn:setFile("ui/blank.png")
		leftText:setText(leftStr, nil, nil, unSelectColor.r, unSelectColor.g, unSelectColor.b)
		rightText:setText(rightStr, nil, nil, selectColor.r, selectColor.g, selectColor.b)
		GameSetting:setSoundType(SoundType.Common)
		GameSetting[config.setMethod](GameSetting, SoundType.Common)
	end
	rightBtn:setOnClick(nil, rightFunc)

	if GameSetting:getSoundType() == SoundType.Common then
		printInfo("SoundType.Common")
		rightFunc()
	else
		printInfo("SoundType.KWXMJ")
		leftFunc()
	end
end

function RoomSetting:onHidenEnd(...)
	RoomSetting.super.onHidenEnd(self, ...)
	GameSetting:save()
end

return RoomSetting