-- stateMachine.lua
-- Author: Vicent Gong
-- Date: 2012-07-09
-- Last modification : 2013-05-30
-- Description: Implement a stateMachine to handle state changing in global

require("core/state");
require("core/anim");
require("core/constants");
require("statesConfig");

StateStyle = 
{	
	NORMAL = 1,
	POPUP = 2,
	FADE  = 3,
	TRANSLATE_TO = 4,
	TRANSLATE_BACK = 5,
};

StateMachine = class();

StateMachine.getInstance = function()
	if not StateMachine.s_instance then
		StateMachine.s_instance = new(StateMachine);
	end
	
	return StateMachine.s_instance;
end

StateMachine.releaseInstance = function()
	delete(StateMachine.s_instance);
	StateMachine.s_instance = nil;
end

StateMachine.registerStyle = function(self, style, func)
	self.m_styleFuncMap[style] = func;
end

StateMachine.changeState = function(self, state, style, ...)	
	if not StateMachine.checkState(self,state) then
		return;
	end
		
	local newState,needLoad = StateMachine.getNewState(self,state,...);
	local lastState = table.remove(self.m_states,#self.m_states);

	--release all useless states
	for k,v in pairs(self.m_states) do
		StateMachine.cleanState(self,v);
	end

	--Insert new state
	self.m_states = {};
	self.m_states[#self.m_states+1] = newState;
	StateMachine.switchState(self,needLoad,false,lastState,true,style);
end

StateMachine.pushState = function(self, state, style, isPopupState, ...)
	if(kCurrentState == state) then
		return;
	end
	if not StateMachine.checkState(self,state) then
		return;
	end
	
	local newState,needLoad = StateMachine.getNewState(self,state,...);
	local lastState = self.m_states[#self.m_states];

	self.m_states[#self.m_states+1] = newState;

	StateMachine.switchState(self,needLoad,isPopupState,lastState,false,style);
end

StateMachine.popState = function(self, style)
	if not StateMachine.canPop(self) then
		--error("Error,no state in state stack\n");
		return;
	end
	
	local lastState = table.remove(self.m_states,#self.m_states);
	StateMachine.switchState(self,false,false,lastState,true, style);
end

---------------------------------private functions-----------------------------------------

StateMachine.ctor = function(self)
	self.m_states 			= {};
	self.m_lastState 		= nil;
	self.m_releaseLastState = false;
	
	self.m_loadingAnim		= nil;
	self.m_isNewStatePopup	= false;

	StateMachine.m_styleFuncMap = {};

	StateMachine.registerStyle(self, StateStyle.TRANSLATE_TO, StateMachine.translateToStyle);
	StateMachine.registerStyle(self, StateStyle.TRANSLATE_BACK, StateMachine.translateBackStyle);
end

StateMachine.translateToStyle = function(newStateObj, lastStateObj, self, onSwitchEnd)
	if self.m_translateAnim then
		return;
	end
	local screenW = System.getScreenScaleWidth();
	local screenH = System.getScreenScaleHeight();

	local newView = newStateObj:getController().m_view.m_root;
	local lastView = lastStateObj:getController().m_view.m_root;
	-- newView:setVisible(false)
	-- local duration = 500;
	-- self.m_translateAnim = new(EaseMotion, kEaseOut, 30, duration, 0, {2.0});
	-- self.m_translateAnim:setEvent(nil, function()
	-- 	local process = self.m_translateAnim and self.m_translateAnim.m_process or 1;
	-- 	local time = self.m_translateAnim and self.m_translateAnim.m_timer or duration;
	-- 	newView:removeProp(0);
	-- 	lastView:removeProp(0);
	-- 	if time <= duration then
	-- 		newView:addPropTranslateSolid(0, screenW * (1- process), 0)
	-- 		lastView:addPropTranslateSolid(0, -screenW * process, 0)
	-- 	else
	-- 		onSwitchEnd(self);
	-- 		delete(self.m_translateAnim);
	-- 		self.m_translateAnim = nil;
	-- 	end
	-- 	newView:setVisible(true);
	-- end)
	-- 由于translateTo 是需要创建界面 所以需要预留多一些时间 加了100ms延迟
	self.m_translateAnim = newView:addPropTranslate(0, kAnimNormal, 200, 100, screenW, 0, 0, 0);
	lastView:addPropTranslate(0, kAnimNormal, 200, 100, 0, -screenW, 0, 0);
	self.m_translateAnim:setEvent(nil,function()
		newView:removeProp(0);
		lastView:removeProp(0);
		onSwitchEnd(self);
		self.m_translateAnim = nil;
	end);
end

StateMachine.translateBackStyle = function(newStateObj, lastStateObj, self, onSwitchEnd)
	if self.m_translateAnim then
		return;
	end

	local screenW = System.getScreenScaleWidth();
	local screenH = System.getScreenScaleHeight();
	local newView = newStateObj:getController().m_view.m_root;
	local lastView = lastStateObj:getController().m_view.m_root;

	self.m_translateAnim = newView:addPropTranslate(0, kAnimNormal, 200, 0, -screenW, 0, 0, 0);
	lastView:addPropTranslate(0, kAnimNormal, 200, 0, 0, screenW, 0, 0);
	self.m_translateAnim:setEvent(nil,function()
		newView:removeProp(0);
		lastView:removeProp(0);
		onSwitchEnd(self);
		self.m_translateAnim = nil;
	end);
end

--Check if the current state is the new state and clean unloaded states
StateMachine.checkState = function(self, state)
	delete(self.m_loadingAnim);
	self.m_loadingAnim = nil;
	
	local lastState = self.m_states[#self.m_states];
	if not lastState then
		return true;
	end
	if lastState.state == state then
		return false;
	end

	local lastStateObj = lastState.stateObj;
	if lastStateObj:getCurStatus() <= StateStatus.Loaded then
		StateMachine.cleanState(self,lastState);
		self.m_states[#self.m_states] = nil;
		return StateMachine.checkState(self,state);
	else
		return true;
	end
end

StateMachine.getNewState = function(self, state, ...)
	local nextStateIndex;
	for i,v in ipairs(self.m_states) do 
		if v.state == state then
			nextStateIndex = i;
			break;
		end
	end
	autoRequire(state)
	local nextState;
	if nextStateIndex then
		nextState = table.remove(self.m_states,nextStateIndex);
	else
		nextState = {};
		nextState.state = state;
		nextState.stateObj = new(StatesMap[state],...);
	end
	return nextState,(not nextStateIndex);
end

StateMachine.canPop = function(self)
	if #self.m_states < 2 then
		return false;
	else
		return true;
	end
end

StateMachine.switchState = function(self, needLoadNewState, isNewStatePopup,
										lastState, needReleaseLastState,
										style)	

	self.m_isNewStatePopup = isNewStatePopup;

	self.m_lastState = lastState;
	self.m_releaseLastState = needReleaseLastState;
	self.m_style = style;

	StateMachine.pauseState(self,self.m_lastState);
	
	if needLoadNewState then
		self.m_loadingAnim = new(AnimInt,kAnimRepeat,0,1,1);
		self.m_loadingAnim:setDebugName("AnimInt | self.m_loadingAnim")
		self.m_loadingAnim:setEvent(self,StateMachine.loadAndRun);
	else
		StateMachine.run(self);
	end
end

StateMachine.loadAndRun = function(self)
	local stateObj = self.m_states[#self.m_states].stateObj;
	if stateObj:load() then
		delete(self.m_loadingAnim);
		self.m_loadingAnim = nil;
		stateObj:setStatus(StateStatus.Loaded);
		StateMachine.run(self);
	end
end

StateMachine.run = function(self)
	StateMachine.runState(self,self.m_states[#self.m_states]);
	
	local newStateObj = self.m_states[#self.m_states].stateObj;
	if self.m_lastState and self.m_style and self.m_styleFuncMap[self.m_style] then	
		self.m_styleFuncMap[self.m_style](newStateObj,self.m_lastState.stateObj,self,StateMachine.onSwitchEnd);
	else
		StateMachine.onSwitchEnd(self);
	end
end

StateMachine.onSwitchEnd = function(self)
	if self.m_lastState then
		if self.m_releaseLastState then
			StateMachine.cleanState(self,self.m_lastState);
		elseif self.m_isNewStatePopup then
		
		else
			self.m_lastState.stateObj:stop();
		end
	end

	self.m_lastState = nil;
	self.m_releaseLastState = false;

	local newState = self.m_states[#self.m_states].stateObj;
	local state = self.m_states[#self.m_states].state;
	StateChange.stateChangeEnd(state, newState);
	newState:resume(self.m_bundleData);  -- ADD
	self.m_bundleData = nil; -- 生效一次
end

StateMachine.cleanState = function(self, state)
	if not (state and state.stateObj) then
		return;
	end

	local obj = state.stateObj;
	for _,v in ipairs(State.s_releaseFuncMap[obj:getCurStatus()]) do
		obj[v](obj);
	end
	delete(obj);
end

StateMachine.runState = function(self, state)
	if not (state and state.stateObj) then
		return;
	end

	local obj = state.stateObj;
	if obj:getCurStatus() == StateStatus.Loaded 
		or obj:getCurStatus() == StateStatus.Stoped  then
		obj:run();
	end
end

StateMachine.pauseState = function(self, state)
	if not (state and state.stateObj) then
		return;
	end

	local obj = state.stateObj;
	if obj:getCurStatus() == StateStatus.Resumed then
		obj:pause();
	end
end

StateMachine.dtor = function(self)
	for i,v in pairs(self.m_states) do 
		StateMachine.cleanState(self,v);
	end
	
	self.m_states = {};
end

StateMachine.setBundleData = function(self, bundleData)
	self.m_bundleData = bundleData;
end