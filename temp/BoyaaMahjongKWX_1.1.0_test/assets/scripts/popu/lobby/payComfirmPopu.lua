local PayComfirmPopu = class(require("popu.gameWindow"))

function PayComfirmPopu:initView(data)
	--返回
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		if self.closeFunc then
			self.closeFunc()
		end
		self:dismiss();
	end);

	self:findChildByName("content_text"):setText(data.text);

	self:findChildByName("btn_tel"):setOnClick(self, function ( self )
		-- body
		
	end);

	self:findChildByName("btn_comfirm"):setOnClick(self, function ( self )
		-- body
		if data.leftFunc then
			self.leftFunc()
		end
		self:dismiss();
	end);

	

	self.leftFunc  = data.leftFunc
	self.closeFunc = data.closeFunc
end


return PayComfirmPopu