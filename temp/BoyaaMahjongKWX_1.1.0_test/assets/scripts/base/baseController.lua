require("core.object")
require("base.baseLayer")

-- 去除gameScene 的版本
BaseController = class(BaseLayer) 

function BaseController:ctor(viewConfig, state, ...)
	BaseLayer.addToRoot(self)
	BaseLayer.setFillParent(self,true,true)
	self.m_state = state
	self.m_ctrl = self.s_controls;

	EventDispatcher.getInstance():register(Event.Message, self, self.onMessageCallDone)
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)
end

-- 切换界面完成后 处理业务
function BaseController:dealBundleData(bundleData)
end


function BaseController:resume(bundleData)
	self.m_root:setPickable(true)
	WindowManager:dealWithStateChange()
end

function BaseController:pause()
	self.m_root:setPickable(false);
	EventDispatcher.getInstance():unregister(Event.Message, self, self.onMessageCallDone)
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
end

function BaseController:dtor()
	EventDispatcher.getInstance():unregister(Event.Message, self, self.onMessageCallDone);
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive);
end

function BaseController:pushStateStack(obj, func)
	self.m_state:pushStateStack(obj,func);
end

function BaseController:popStateStack()
	self.m_state:popStateStack();
end

function BaseController:stop()
	self.m_root:setVisible(false);
end

function BaseController:run()
	self.m_root:setVisible(true);
	self.m_root:setPickable(false);
end

function BaseController:onBack()

end

BaseController.messageFunMap = {
}

BaseController.commandFunMap = {
}

function BaseController:onMessageCallDone(param, ...)
	if self.messageFunMap[param] then
		self.messageFunMap[param](self,...)
	end
end

function BaseController:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end