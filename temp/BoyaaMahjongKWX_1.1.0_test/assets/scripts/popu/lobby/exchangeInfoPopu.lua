
local ExchageInfoPopu = class(require("popu.gameWindow"))

local printInfo, printError = overridePrint("ExchageInfoPopu")

function ExchageInfoPopu:ctor()
    GameSetting:setIsSecondScene(true)
end

function ExchageInfoPopu:dtor()
	
end

function ExchageInfoPopu:initView(data)
	self.m_data = data
	self:findChildByName("btn_close"):setOnClick(self, function(self)
		self:dismiss()
	end)

	self.mTextPhone = self:findChildByName("text_phone_input")
	self.mTextName = self:findChildByName("text_name_input")
	self.mTextDizhi = self:findChildByName("text_dizhi_input")

	self.mTextPhone:setOnTextChange(self, self.mTextPhoneChange)
	self.mTextName:setOnTextChange(self, self.mTextNameChange)
	self.mTextDizhi:setOnTextChange(self, self.mTextDizhiChange)

	local btn_mid = self:findChildByName("btn_mid")
	local text_midName = self:findChildByName("text_midName")
	text_midName:setText("提 交")
	btn_mid:setOnClick(self, self.submitExchangeInfo)

	if data.isLook then
		self.mTextPhone:setText(data.phone or "", 0, 0, 0x50, 0xB4, 0xFF)
		self.mTextPhone:setPickable(false)
		self.mTextName:setText(data.name or "", 0, 0, 0x50, 0xB4, 0xFF)
		self.mTextName:setPickable(false)
		self.mTextDizhi:setText(data.address or "", 0, 0, 0x50, 0xB4, 0xFF)
		self.mTextDizhi:setPickable(false)
		text_midName:setText("确 认")
		btn_mid:setOnClick(self, function(self)
			self:dismiss()
		end)
	end
end

function ExchageInfoPopu:mTextPhoneChange()
	if string.len(self.mTextPhone:getText()) > 11 then
		self.mTextPhone:setText(ToolKit.subStr(self.mTextPhone:getText(), 11, 1, true));
	end
end

function ExchageInfoPopu:mTextNameChange()
	if string.len(self.mTextPhone:getText()) > 20 then
		self.mTextPhone:setText(ToolKit.subStr(self.mTextPhone:getText(), 20, 1, true));
	end
end

function ExchageInfoPopu:mTextNameChange()
	if string.len(self.mTextDizhi:getText()) > 100 then
		self.mTextDizhi:setText(ToolKit.subStr(self.mTextPhone:getText(), 100, 1, true));
	end
end

function ExchageInfoPopu:submitExchangeInfo()
	local phoneLen = string.len(self.mTextPhone:getText())
	local nameLen = string.len(self.mTextName:getText())
	local dizhiLen = string.len(self.mTextDizhi:getText())
	if phoneLen < 11 then
		local strName = "您输入的手机号码有误"
		if phoneLen <= 0 then
			strName = "您输入的手机号码为空"
		end
		AlarmTip.play(strName)
		return
	end
	if nameLen <= 0 then
		AlarmTip.play("您输入的姓名为空")
		return
	end
	local goodsInfo = {};
	goodsInfo.id = self.m_data:getId();
	goodsInfo.num = 1
	goodsInfo.phone = self.mTextPhone:getText()
	goodsInfo.name = self.mTextName:getText()
	goodsInfo.address = self.mTextDizhi:getText()
	GameSocketMgr:sendMsg(Command.EXCHANGE_GOODS_REQUEST, goodsInfo)
	self:dismiss()
end

return ExchageInfoPopu