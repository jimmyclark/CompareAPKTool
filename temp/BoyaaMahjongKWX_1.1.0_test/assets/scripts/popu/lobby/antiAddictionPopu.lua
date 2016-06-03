local AntiAddictionPopu = class(require("popu.gameWindow"))

function AntiAddictionPopu:initView(data)
	local closeBtn = self:findChildByName("btn_close");
	closeBtn:setOnClick(self, function ( self )
		-- body
		self:dismiss();
	end);

	local etName  = self:findChildByName("et_name");
	local etId  = self:findChildByName("et_id");

	etName:setHintText("输入姓名", 0x96, 0x96, 0x96);
	etId:setHintText("输入身份证号码", 0x96, 0x96, 0x96);
	
	--获取验证码
	self:findChildByName("btn_confirm"):setOnClick(self, function ( self )
		-- body
		local name 	= etName:getText();
		local id 	= etId:getText();

		local nameLen = string.len(name);
		local idLen 	= string.len(id);

		if nameLen < 4 or nameLen > 10 then
			AlarmTip.play("请输入有效的姓名");
			return ;
		end

		if idLen ~= 15 and idLen ~= 18 then
			AlarmTip.play("请输入有效的身份证号码");
			return ;
		end

		GameSocketMgr:sendMsg(Command.ANTI_ADDICTION_PHP_REQUEST, {['name']=name, ['idcard']=id}, true);

	end);

	etName:setOnTextChange(self, function ( self )
		etName:setText(string.sub(etName:getText(), 1, 16));
	end);
	etId:setOnTextChange(self, function ( self )
		etId:setText(string.sub(etId:getText(), 1, 18));
	end);

end
--防沉迷
function AntiAddictionPopu:onAntiAddictionResponse( data )
	if not data or 1 ~= data.status then
		return
	end
	if data.data and tonumber(data.data.status) == 1 then
		AlarmTip.play(data.data.msg);
		self:dismiss();
	else
		AlarmTip.play(data.data.msg or "提交失败");
	end
end
--[[
	通用的（大厅）协议
]]
AntiAddictionPopu.s_severCmdEventFuncMap = {
	[Command.ANTI_ADDICTION_PHP_REQUEST] 			= AntiAddictionPopu.onAntiAddictionResponse,
}

return AntiAddictionPopu