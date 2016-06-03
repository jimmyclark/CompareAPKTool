local RoomLoadingPage = class(Node)

------------------------------------------------------------ private ---------------------------------
function RoomLoadingPage:ctor()
	self:setFillParent(true,true);
end

function RoomLoadingPage:play(roomType)
	printInfo("RoomLoadingPage:play")
	if not self.m_loading then
  		self.m_loading = new(ToastShade)
  		self.m_loading:setTouchFunc(function()
  			self:cancelEnterRoom()
  		end)
	end
  	self.m_loading:play()
  	self:startTimeOut()
end

function RoomLoadingPage:dtor()
	self:stop()
	delete(self.m_loading)
	self.m_loading = nil
end 

function RoomLoadingPage:startTimeOut()
	self:stopTimeOut();
	self.m_timeOut = new(AnimInt,kAnimNormal,0,1, 12000,0);
	self.m_timeOut:setDebugName("self.m_timeOut");
	self.m_timeOut:setEvent(self, self.cancelEnterRoom);
end 

function RoomLoadingPage:stopTimeOut()
	delete(self.m_timeOut);
	self.m_timeOut = nil;
end 

function RoomLoadingPage:stop()
	self:stopTimeOut()
	if self.m_loading then
		self.m_loading:stopTimer()
	end
end 

function RoomLoadingPage:cancelEnterRoom()
	GameSocketMgr:sendMsg(Command.LogoutRoomReq)
	self:stop()
end

function RoomLoadingPage:onEnsureGameType(data, isReconnet)
	repeat
		-- 如果是在房间外面且已经没有loading
		if not self.m_timeOut and not app:isInRoom() and not isReconnet then
			self:cancelEnterRoom()
			break
		end
		-- 如果在房间
		if app:isInRoom() then
		    printInfo("已经在房间了")
		    EventDispatcher.getInstance():dispatch(Event.Message, "ensureGameType", data)
		else
			printInfo("roomLoading  StateChange.changeState")
		    StateChange.changeState(States.Room, data)
		end
	until true
	self:stop()
end

return RoomLoadingPage