
local ExitGamePopu = class(require("popu.gameWindow"))

function ExitGamePopu:initView(data)
	self:findChildByName("btn_close"):setOnClick(self, function(self)
		self:dismiss()
	end)
	self:findChildByName("textview_desc"):setPickable(false)
	self:findChildByName("btn_enterHuoDong"):setOnClick(self, function(self)
		self:onEnterHuoDongBtnClick()
		self:dismiss()
	end)
	self:findChildByName("btn_left"):setOnClick(self, function(self)
		self:onLeftBtnClick()
	end)
	self:findChildByName("btn_right"):setOnClick(self, function(self)
		self:onRightBtnClick()
	end)
end

function ExitGamePopu:onEnterHuoDongBtnClick()
	if self.enterHuoDongFunc then
		self.enterHuoDongFunc()
	end
	self:dismiss(true)
end

function ExitGamePopu:onLeftBtnClick()
	if self.leftFunc then
		self.leftFunc()
	end
	self:dismiss(true, true)
end

function ExitGamePopu:onRightBtnClick()
	if self.rightFunc then
		self.rightFunc()
	end
	self:dismiss(true, true)
end

return ExitGamePopu