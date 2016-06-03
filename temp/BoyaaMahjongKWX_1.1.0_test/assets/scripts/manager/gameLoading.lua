local GameLoading = class(Node)

local PHP_TIMEOUT = 12
local CONN_TIMEOUT = 4
local LOADING_TAG = 1001

function GameLoading:ctor()
	self:addToRoot()
	self:setLevel(50)
	self.s_loadingCmds = {}	--socket cmd
	self.p_loadingCmds = {} --php cmd
  	self.m_loading = new(ToastShade)
end

function GameLoading:play()
  	self.m_loading:play()
end

function GameLoading:addPhpCommand(cmd, tip, anim)
	if not self.m_anim then
		self.m_anim = self:schedule(handler(self, self.checkTimeout), 1000)
		if anim ~= false then
			self:play()
			self.p_loadingCmds[cmd] = {
				time = os.time(),
				tip = tip,
			} -- 请求时间
		end
	end
end

function GameLoading:onCommandResponse(cmd)
	cmd = cmd or 0
	self.p_loadingCmds[cmd] = nil
	self:judgeStop()
end

function GameLoading:judgeStop()
	if table.nums(self.p_loadingCmds) == 0 then
		self:stop()
	end
end

function GameLoading:checkTimeout()
	local tb = {}
	local time = os.time()
	for cmd, v in pairs(self.p_loadingCmds) do
		local isTimeOut = false
		if cmd == Command.SOCKET_EVENT_CONNECTED and time - v.time > CONN_TIMEOUT then
			isTimeOut = true
			GameSocketMgr:closeSocketSync()
		elseif time - v.time > PHP_TIMEOUT then
			isTimeOut = true
		end
		if isTimeOut then
			if ToolKit.isValidString(v.tip) then
				AlarmTip.play(v.tip)
			end
			self.p_loadingCmds[cmd] = nil
			app:onCommandTimeout(cmd)
		end
	end
	self:judgeStop()
end

-- 判断该命令是否在请求队列中
function GameLoading:isCommandRequest(cmd)
	return self.p_loadingCmds[cmd]
end

function GameLoading:timeoutStop()
	local record = self.p_loadingCmds[#self.p_loadingCmds]
	if record and ToolKit.isValidString(record.tip) then
		AlarmTip.play(record.tip)
	end
	self:stop()
end

function GameLoading:stop()
	delete(self.m_anim)
	self.m_anim = nil
	self.m_loading:stopTimer()
	self.p_loadingCmds = {}
end

return GameLoading