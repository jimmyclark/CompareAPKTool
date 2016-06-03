local testPopu = class(require("popu.gameWindow"))

testPopu.s_controls = 
{
	close_btn = 1,
};

function testPopu:initView(data)
  
    --local closeBtn = self:findChildByName("btn_Close");
    --closeBtn:setOnClick(self,function (self)
        --body
    --   self:dismiss();
    --end)

	if self.closeFunc then
		self.closeFunc = data.closeFunc
	end

    
end

function testPopu:dismiss(...)
    return testPopu.super.dismiss(self, ...)
end

function testPopu:onCloseBtnClick( ... )
	-- body
	if self.closeFunc then
		self.closeFunc()
	end
	self.dismiss(true, true)
end


testPopu.s_controlConfig = {
	[testPopu.s_controls.close_btn] = {"img_bg" , "btn_Close"},
};

testPopu.s_controlFuncMap = {
	[testPopu.s_controls.close_btn] = {}	
};

return testPopu