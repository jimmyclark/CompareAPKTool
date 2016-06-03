-- evnetDispatcher.lua
-- Author: Vicent.Gong
-- Date: 2012-07-11
-- Last modification : 2013-05-29
-- Description: Implemented a evnet dispatcher to handle default event.

require("core/global");

Event = {
    RawTouch    	= 1,
	Call    		= 2,
	KeyDown    		= 3, -- 监听按键
	Pause 			= 4, -- 点击home键 暂停活动 程序运行在后台调用
	Resume 			= 5, -- 点击游戏   重新开始活动 程序运行在前台调用
	Back			= 6, -- 返回键
	Timeout			= 7, -- 系统定时器到达
	Socket			= 8, -- Socket
	Message			= 9,
	ConsoleSocket   = 10, --单机
	End 			= 11,-- 无用，结束标识
  	Shield    		= 12, -- 屏蔽
};

EventState = 
{
	Deactive = 1,
	Active = 2,
	RemoveMarked = 3,
};

EventDispatcher = class();

EventDispatcher.getInstance = function()
	if not EventDispatcher.s_instance then 
		EventDispatcher.s_instance = new(EventDispatcher);
	end
	return EventDispatcher.s_instance;
end

EventDispatcher.releaseInstance = function()
	delete(EventDispatcher.s_instance);
	EventDispatcher.s_instance = nil;
end

EventDispatcher.ctor = function(self)
	self.m_listener = {};
	self.m_userKey = Event.End;
end

EventDispatcher.getUserEvent = function(self)
	self.m_userKey = self.m_userKey + 1;
	return self.m_userKey;
end

EventDispatcher.register = function(self, event, obj, func)
	local mark = self.m_dispatching and EventState.Deactive or EventState.Active;
	
	self.m_listener[event] = self.m_listener[event] or {};
	local arr = self.m_listener[event];
	arr[#arr+1] = {["obj"] = obj,["func"] = func,["mark"] = mark,};

end

EventDispatcher.unregister = function(self, event, obj, func)
	if not self.m_listener[event] then return end; 

	local arr = self.m_listener[event];
	for k,v in pairs(arr) do 
		if (v["func"] == func) and (v["obj"] == obj) then 
			if self.m_dispatching then
				arr[k].mark = EventState.RemoveMarked;
			else
				arr[k] = nil;
			end
			return;
		end
	end
end

EventDispatcher.dispatch = function(self, event, ...)
	if not self.m_listener[event] then return end;

	self.m_dispatching = true;

	local ret = false;
	local listeners = self.m_listener[event];
	for _,v in pairs(listeners) do 
		if v["func"] 
			and (v["mark"] ~= EventState.Deactive and v["mark"] ~= EventState.RemoveMarked) then
			ret = ret or v["func"](v["obj"],...);
		end
	end

	self.m_dispatching = false;

	EventDispatcher.cleanup(self);

	return ret;
end

EventDispatcher.cleanup = function(self)
	for _,listeners in pairs(self.m_listener) do
		for k,v in pairs(listeners) do 
			if v.mark == EventState.Deactive then 
				v.mark = EventState.Active;
			elseif v.mark == EventState.RemoveMarked or v.func == nil then 
				listeners[k] = nil;
			end
		end
	end
end

EventDispatcher.dtor = function(self)
	self.m_listener = nil;
end