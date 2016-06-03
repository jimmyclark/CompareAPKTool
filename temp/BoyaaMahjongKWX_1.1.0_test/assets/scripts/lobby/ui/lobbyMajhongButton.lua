local LobbyMajhongButton = class(Button, false);

local Path = "lobby/"
function LobbyMajhongButton:ctor(type)
	self.mUiName = 
	{
		[GameType.KWXMJ] = {"btnGuangdong1.png", "btnGuangdong2.png"},
		[GameType.SHMJ] = {"btnShanghai1.png", "btnShanghai2.png"},
		[GameType.HBMJ] = {"btnHebei1.png", "btnHebei2.png"},
		[GameType.GBMJ] = {"btnGuobiao1.png", "btnGuobiao2.png"},
	}

	self.mType = type;
	super(self, Path .. self.mUiName[self.mType][1])
 	-- body
 	self:setOnClick(nil, function()
		AnimManager:play(AnimationTag.AnimFade, {
			node = self,
			fadeSize = 1.3,
			fadeTime = 250,
		})
 		EventDispatcher.getInstance():dispatch(Event.Message, "SelectGameType", self.mType)
 	end)

 	--创建箭头
 	local arrow = new(Image, Path .. "arrow.png")
 	arrow:setName("arrow");
 	arrow:setAlign(kAlignRight);
 	arrow:setPos(-34, 0);
 	self:addChild(arrow);
 	
end

function LobbyMajhongButton:dtor()

end

function LobbyMajhongButton:setSelected( selected )
	-- body
	self:setFile(Path .. self.mUiName[self.mType][selected and 2 or 1]);
	self:findChildByName("arrow"):setVisible(selected);
	if selected and GameSupportStateMap[self.mType] then
		GameConfig:setLastType(self.mType)
			:save()
	end
end
 return LobbyMajhongButton