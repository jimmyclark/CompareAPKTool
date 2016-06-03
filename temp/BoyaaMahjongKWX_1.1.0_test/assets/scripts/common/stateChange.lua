StateChange = {}
local printInfo, printError = overridePrint("StateChange")

StateChange.changeState = function(state, bundle, style, ...)
	--防止多次切换导致状态切换出错
	if kCurrentState == state or kStateChanging then
		printInfo("changeState return")
		if kCurrentState == state and kCurrentStateRef then
			kCurrentStateRef:getController():dealBundleData(bundle)
		end
		return;
	end
	kLastState = kCurrentState;
	kStateChanging = true;
	StateMachine.getInstance():setBundleData(bundle);
	StateMachine.getInstance():changeState(state, style, bundle, ...);
	printInfo("StateChangechangeState" .. state)
end

-- changeState 完毕后 保存状态 并判断是否直接关闭房间loading界面\
StateChange.stateChangeEnd = function(state, stateRef)	
	printInfo("StateChange.stateChangeEnd")
	kStateChanging = false;
	kCurrentState = state or States.Lobby;
	kCurrentStateRef = stateRef
end

-- 还未验证 暂时还是使用原来StateMachine的使用方式
-- StateChange.pushState = function (state, bundle, style, isPopupState, ...)
-- 	--防止多次切换导致状态切换出错
-- 	if(kCurrentState == state) then
-- 		return;
-- 	end
-- 	kLastState = kCurrentState;
-- 	StateMachine.getInstance():setBundleData(bundle);
-- 	StateMachine.getInstance():pushState(state, style, isPopupState, ...)
-- end