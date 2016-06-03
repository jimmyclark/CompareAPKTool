local TimerClock = class(Node)
local roomTimer = require(ViewPath .. "roomTimer")


TimerClock.DealCard = 1
TimerClock.OutCard = 2
TimerClock.Operate = 3
TimerClock.TimeOut = 4
TimerClock.TimeOutEnd = 5
TimerClock.Observer = 6
TimerClock.SwapCard = 7
TimerClock.SelectPiao = 8

function TimerClock:ctor()
	self.m_root = SceneLoader.load(roomTimer)
		:addTo(self)
		:align(kAlignCenter)
	local bg = self.m_root:getChildByName("timer_bg")
	self.m_bg = bg
	self.m_timerNumer = self.m_bg:getChildByName("view_timerNumber")
	self.m_lightViews = {}
	for i = SEAT_1, SEAT_4 do
		local light = self.m_bg:getChildByName(string.format("timer_light_%d",i))
		if light then
			local tmp = {}
			tmp.light = light
			tmp.seat = i
			table.insert(self.m_lightViews, tmp)
		end
	end
	self.m_numberLeftTable = {}
	for i = 0 , 1 do
		local imgDir = string.format("kwx_room/room_timer/img_timer%d.png", i)
		local img = UIFactory.createImage(imgDir)
					:addTo(self.m_timerNumer)
					:hide()
		table.insert(self.m_numberLeftTable, img)
	end
	self.m_numberRightTable = {}
	for i = 0 , 9 do
		local imgDir = string.format("kwx_room/room_timer/img_timer%d.png", i)
		local img = UIFactory.createImage(imgDir)
					:addTo(self.m_timerNumer)
					:hide()
		table.insert(self.m_numberRightTable, img)
	end

	self:hide()
end

function TimerClock:setRoomRef(ref)
	self.m_roomRef = ref
	return self
end

function TimerClock:getRoom()
	return self.m_roomRef
end

-- 东家的本地座位
function TimerClock:setSeatInfo(localEastSeat)

end

function TimerClock:startTimer()
	self:stopTimer()
	for i,v in ipairs(self.m_lightViews) do
		v.light:setVisible(self.m_seat == v.seat)
		if not v.light:checkAddProp(1001) then
			v.light:removeProp(1001)
		end
		if self.m_seat == v.seat then
			v.light:addPropTransparency(1001, kAnimLoop, 500, 0, 0.6, 1.0)
		end
	end
	self.timerAnim = self:schedule(function()
		if self.m_timerNumer:getVisible() then
			self:showTime(self.m_seconds)
		end
		self:addSeconds(-1)
	end, 1000)
end

function TimerClock:stopTimer()
	delete(self.timerAnim)
	self.timerAnim = nil
end

function TimerClock:play(seat, seconds, type)
	printInfo("TimerClock:play : "..seconds)
	seconds = seconds or 0
	seat = seat or 0
	self.m_seat = seat
	self.m_type = type
	self:startTimer()
	self:showTime(seconds)
	self.m_seconds = seconds - 1
	
	self:show()
end

function TimerClock:addSeconds(second)
	self.m_seconds = self.m_seconds + second
end

function TimerClock:playWait(seconds, type)
	seconds = seconds or 0
	self.m_seat = 0
	self.m_type = type
	self:startTimer()
	self:showTime(seconds)
	self.m_seconds = seconds - 1
	
	self:show()
end

function TimerClock:stop()
	self:stopTimer()
	self:hide()
end

function TimerClock:showTime(seconds)
	if seconds >= 0 and self.m_type ~= TimerClock.TimeOut and self.m_type ~= TimerClock.TimeOutEnd then
		--添加倒计时音效
		if( seconds <= 3 and self.m_seat == SEAT_1 ) then
          	kEffectPlayer:play(Effects.AudioWarning);
		end	
		--------------------------------------
		seconds = tostring(string.format("%02d", seconds))
		local left, right
		if #seconds > 2 then seconds = string.sub(seconds, #seconds - 2, #seconds) end
		if #seconds > 1 then left = string.sub(seconds, 1, 1) end
		right = string.sub(seconds, #seconds, #seconds) or 0
		left = left or 0
		if self.m_leftTimer then
			self.m_leftTimer:hide()
		end
		self.m_leftTimer = self.m_numberLeftTable[tonumber(left)+1]
		self.m_leftTimer:pos(0, 0):show()
		if self.m_rightTimer then
			self.m_rightTimer:hide()
		end
		self.m_rightTimer = self.m_numberRightTable[tonumber(right)+1]
		self.m_rightTimer:pos(28, 0):show()
	elseif seconds == -1 then
		printInfo("计时器结束隐藏面板")
		self:getRoom():onTimerClockEnd()
	elseif seconds == -2 then
		printInfo("超时切换计时器")
		self:getRoom():onTimerClockOver(self.m_type, self.m_seat)
	end
end

return TimerClock
