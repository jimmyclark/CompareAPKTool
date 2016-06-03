local GameWindow = require("popu.gameWindow")
local MessageBox = class(GameWindow)

MessageBox.s_controls =
{
	close_btn = 1,
	left_btn = 2,
	right_btn = 3,
	content_text = 4,
	left_text = 5,
	right_text = 6,
	title_text = 7,
};

-- local BtnDiffX = 120

function MessageBox:initView(data)
	if not data then return end
	if data.singleBtn then
		self:showSingleBtn()
	end
	if data.leftFunc then
		self.leftFunc = data.leftFunc
	end
	if data.leftText then
		self:getControl(self.s_controls.left_text):setText(data.leftText)
	end
	if data.rightFunc then
		self.rightFunc = data.rightFunc
	end
	if data.closeFunc then
		self.closeFunc = data.closeFunc
	end
	if data.rightText then
		self:getControl(self.s_controls.right_text):setText(data.rightText)
	end
	if data.text then
		self:getControl(self.s_controls.content_text):setText(data.text)
	end
	if data.titleText then
		self:getControl(self.s_controls.title_text):setText(data.titleText)
	end
end

function MessageBox:showSingleBtn()
	self:getControl(self.s_controls.left_btn):pos(0, nil)
	self:getControl(self.s_controls.right_btn):hide()
end

function MessageBox:onCloseBtnClick()
	if self.closeFunc then
		self.closeFunc()
	end
	self:dismiss(true)
end

function MessageBox:onLeftBtnClick()
	if self.leftFunc then
		self.leftFunc()
	end
	self:dismiss(true, true)
end

function MessageBox:onRightBtnClick()
	if self.rightFunc then
		self.rightFunc()
	end
	self:dismiss(true, true)
end

----------------------------  config  --------------------------------------------------------
MessageBox.s_controlConfig = 
{
	[MessageBox.s_controls.close_btn] 	= {"img_bg", "close_btn"},
	[MessageBox.s_controls.left_btn] 	= {"img_bg", "left_btn"},
	[MessageBox.s_controls.left_text] 	= {"img_bg","left_btn","left_text"},
	[MessageBox.s_controls.right_btn] 	= {"img_bg","right_btn"},
	[MessageBox.s_controls.right_text] 	= {"img_bg","right_btn","right_text"},
	[MessageBox.s_controls.content_text] = {"img_bg","content_text"},
	[MessageBox.s_controls.title_text] 	= {"img_bg", "title_text"},
};

MessageBox.s_controlFuncMap = 
{
	[MessageBox.s_controls.close_btn] = MessageBox.onCloseBtnClick;
	[MessageBox.s_controls.left_btn] = MessageBox.onLeftBtnClick;
	[MessageBox.s_controls.right_btn] = MessageBox.onRightBtnClick;
};

return MessageBox