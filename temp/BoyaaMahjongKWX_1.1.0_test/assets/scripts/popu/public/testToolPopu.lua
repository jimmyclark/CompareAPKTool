local GameWindow = require("popu.gameWindow")
local TestToolPopu = class(GameWindow)

function TestToolPopu:initView(data)
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)

	self.m_root:findChildByName("close_btn")
		:setOnClick(nil, function()
			self:dismiss(true)
		end)
	
	local accountEditbox = self.m_root:findChildByName("account_editbox")
	accountEditbox:setText(GameConfig:getLastSuffix())

	self.m_root:findChildByName("create_account")
		:setOnClick(nil, function()
			local text = accountEditbox:getText()
			GameConfig:setLastSuffix(text)
				:save()
			AlarmTip.play(string.format("已经使用%s%s作为游客账号, 请重新登录", PhpManager:getDevice_id(), text))
   			GameSocketMgr:closeSocketSync()
			self:dismiss(true)
		end)

	self.m_root:findChildByName("random_btn")
		:setOnClick(nil, function()
			local time = os.time()
			accountEditbox:setText(time)
		end)

	local serverEditBox = self.m_root:findChildByName("server_editbox")
	serverEditBox:setText(string.format("%s:%s", ConnectModule:getInstance():getIpPort()))
	---- serverEditBox:setText(string.format("%s:%s", HallConfig:getIpPort()))

	local selectServerFunc = function(serverType)
		local ip, port 
		local tips = {
			[ServerType.Normal] = "正式服",
			[ServerType.Test] = "测试服",
			[ServerType.Dev] = "开发服",
			[ServerType.Define] = "自定义"
		}
		if serverType == ServerType.Define then
			local text = serverEditBox:getText()
			local array = string.split(text, ":")
			if not array[1] or not tonumber(array[2]) then
				AlarmTip.play("格式有误")
				return
			end
			ip, port = array[1], array[2]
		end

		ConnectModule:getInstance():cutServer(serverType, ip, port)
		---- HallConfig:cutServer(serverType, ip, port)
		GameSocketMgr:closeSocketSync(true)
		serverEditBox:setText(string.format("%s:%s", ConnectModule:getInstance():getIpPort()))
		AlarmTip.play("已经切换到%s, %s:%s", tips[serverType], ConnectModule:getInstance():getIpPort())
	end

	local normalBtn = self.m_root:findChildByName("normal_btn")
	local testBtn = self.m_root:findChildByName("test_btn")
	local devBtn = self.m_root:findChildByName("dev_btn")
	local normalFunc = function()
		normalBtn:setIsGray(true)
		testBtn:setIsGray(false)
		devBtn:setIsGray(false)
	end
	normalBtn:setOnClick(nil, function()
		selectServerFunc(ServerType.Normal)
        kPHPActivityURL = kPhpActivityNormal;
		normalFunc()
	end)

	local testFunc = function(flag)
		normalBtn:setIsGray(false)
		testBtn:setIsGray(true)
		devBtn:setIsGray(false)
	end
	testBtn:setOnClick(nil, function()
		selectServerFunc(ServerType.Test)
        kPHPActivityURL = kPHPActivityURLTest;
		testFunc()
	end)

	local devFunc = function()
		selectServerFunc(ServerType.Dev)
		normalBtn:setIsGray(false)
		testBtn:setIsGray(false)
		devBtn:setIsGray(true)
	end
	devBtn:setOnClick(nil, function()
		selectServerFunc(ServerType.Dev)
		devFunc()
	end)

	--if HallConfig:getServerType() == ServerType.Normal then
	--	normalFunc()
	--elseif HallConfig:getServerType() == ServerType.Test then
	--	testFunc()
	--elseif HallConfig:getServerType() == ServerType.Dev then
	--	devFunc()
	--end
	
	if ConnectModule:getInstance():getServerType() == ServerType.Normal then
		normalFunc()
	elseif ConnectModule:getInstance():getServerType() == ServerType.Test then
		testFunc()
	elseif ConnectModule:getInstance():getServerType() == ServerType.Dev then
		devFunc()
	end

	self.m_root:findChildByName("select_server_btn")
		:setOnClick(ServerType.Define, selectServerFunc)

	-- 
	self.m_root:findChildByName("reconn_type_btn1")
		:setOnClick(nil, function()
			local text = self.m_root:findChildByName("reconn_editbox1"):getText()
			local time = tonumber(text) or 0
			if time > 0 then
				AlarmTip.play(string.format("将在%d秒后断开链接并重连", time))
			end
			self:performWithDelay(function()
				AlarmTip.play("测试重连")
				GameSocketMgr:closeSocketSync(true)
			end, time * 1000)
		end)

	self.m_root:findChildByName("reconn_type_btn2")
		:setOnClick(nil, function()
			local text = self.m_root:findChildByName("reconn_editbox2"):getText()
			local time = tonumber(text) or 0
			if time > 0 then
				AlarmTip.play(string.format("已断开链接，将在%d秒后重连", time))
			end
			GameSocketMgr:closeSocketSync()
			self:performWithDelay(function()
				AlarmTip.play("测试重连")
				GameSocketMgr:closeSocketSync(true)
			end, time * 1000)
		end)

	self.m_root:findChildByName("user_id_editbox")
		:setText(MyUserData:getId())

	self.m_root:findChildByName("update_btn")
		:setOnClick(nil, function()
			GameSocketMgr:sendMsg(Command.FreshMoneyReq, {
				iUserId = MyUserData:getId(),
			})
		end)

	self.m_root:findChildByName("change_btn")
		:setOnClick(nil, function()
			EventDispatcher.getInstance():dispatch(Event.Message, "requestChangeDesk", ChangeDeskType.Change)
			self:dismiss(true)
		end)

	self.m_root:findChildByName("change_down")
		:setOnClick(nil, function()
			EventDispatcher.getInstance():dispatch(Event.Message, "requestChangeDesk", ChangeDeskType.Down)
			self:dismiss(true)
		end)

	self.m_root:findChildByName("change_up")
		:setOnClick(nil, function()
			EventDispatcher.getInstance():dispatch(Event.Message, "requestChangeDesk", ChangeDeskType.Up)
			self:dismiss(true)
		end)

	local moneyEditbox = self.m_root:findChildByName("money_editbox")
	moneyEditbox:setText(MyUserData:getMoney())
	self.m_root:findChildByName("money_change_btn")
		:setOnClick(nil, function()
			local text = moneyEditbox:getText()
			text = tonumber(text)
			if not text then
				AlarmTip.play("输入不合法")
			elseif text < 0 then
				AlarmTip.play("金币不能低于0")
			else
				AlarmTip.play(string.format("修改客户端金币为%d, 请注意测试完后同步信息", text))
				MyUserData:setMoney(text)
			end
		end)

	self.m_root:findChildByName("first_pay_btn")
		:setOnClick(nil, function()
			AlarmTip.play("客户端已模拟完成首充(方便测试首充完成后的交互)")
    		MyBaseInfoData:setFirstPay(1);
    		self:dismiss(true)
		end)
end

function TestToolPopu:updateView(data)
	printInfo("TestToolPopu:updateView")
	local moneyEditbox = self.m_root:findChildByName("money_editbox")
	moneyEditbox:setText(MyUserData:getMoney())
end

function TestToolPopu:onFreshMoneyRsp(data)
	printInfo("TestToolPopu:onFreshMoneyRsp")
	if data.iRet == 0 then
		AlarmNotice.play(
			string.format([[
				玩家%d的金币为%d,经验值为%d,等级为%d,胜%d/负%d/平%d
			]], data.iUserId, data.iMoney, data.iExp, data.iLevel, data.iWintimes, data.iLosetimes, data.iDrawtimes)
		, {
			time = 5000
		})
	else
		AlarmTip.play("获取信息失败")
	end
end

function TestToolPopu:dtor()
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
end

TestToolPopu.commandFunMap = {
	--[[公共业务]]
    [Command.FreshMoneyRsp]     = TestToolPopu.onFreshMoneyRsp,
}

function TestToolPopu:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

return TestToolPopu