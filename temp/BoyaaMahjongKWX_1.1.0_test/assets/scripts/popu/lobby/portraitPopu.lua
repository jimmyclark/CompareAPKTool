local PortraitPopu = class(require("popu.gameWindow"))

function PortraitPopu:initView(data)
	
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		self:dismiss();
	end);


	self:findChildByName("btn_takePhoto"):setOnClick(self, function ( self )
		-- body
		--拍照
		NativeEvent.getInstance():takePhoto(MyUserData:getId());
		self:dismiss();
	end);

	self:findChildByName("btn_pickPhoto"):setOnClick(self, function ( self )
		-- body
		--选择图片
		NativeEvent.getInstance():pickPhoto(MyUserData:getId());
		self:dismiss();
	end);

end

return PortraitPopu