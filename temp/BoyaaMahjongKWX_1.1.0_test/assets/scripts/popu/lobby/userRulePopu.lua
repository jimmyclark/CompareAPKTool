local UserRulePopu = class(require("popu.gameWindow"))

function UserRulePopu:ctor()
    GameSetting:setIsSecondScene(true)
	EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
end

function UserRulePopu:dtor()

	EventDispatcher.getInstance():unregister(Event.Call, self, self.onNativeCallBack);
end

function UserRulePopu:initView(data)
	local closeBtn = self:findChildByName("btn_back");
	closeBtn:setOnClick(self, function ( self )
		-- body
		self:dismiss(true);
	end);
	closeBtn:enableAnim(false);
	self:findChildByName("img_titleText"):setFile(1 == data.title and "kw_tiaoKuang/img_yonghu.png" or "kw_tiaoKuang/img_fuwu.png");

	NativeEvent.getInstance():openRule(data.url);

	GameLoading:addPhpCommand(Command.GET_RULE_PHP_REQUEST);
end

function UserRulePopu:dismiss(param)
    GameSetting:setIsSecondScene(false)
	NativeEvent.getInstance():closeRule();
	GameLoading:onCommandResponse(Command.GET_RULE_PHP_REQUEST);

	local platform = System.getPlatform();
	if platform ~= kPlatformAndroid then --android登录
		return self.super.dismiss(self, param);
	end
end
--native callback
function UserRulePopu:onNativeCallBack(key, result)
	if key == "ruleFinish" then
		GameLoading:onCommandResponse(Command.GET_RULE_PHP_REQUEST);
	elseif key == "ruleClose" then
		self.super.dismiss(self, true);
	elseif key == "keyBack" then
		self:dismiss(self, true);
	end
end

return UserRulePopu