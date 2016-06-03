

Observer = class();

-- 设置该控件 观察的信息
-- 信息变动后会回调 notify方法
-- @tb 表
-- @key string
Observer.setOberverInfo = function(self, tb, key)
	if type(tb) == "table" and key then
		print_string("添加观察对象 ==================")
		tb[key .. "Observers"] = tb[key .. "Observers"] or {};  -- 初始化
		self.observerTarget = tb[key .. "Observers"];
		table.insert(tb[key .. "Observers"], self);
	end
end

-- 取消观察 
Observer.cancelObserver = function(self)
	if self and self.observerTarget then
		local unBinded = function()
			for i,v in pairs(self.observerTarget) do
				if self == v then
					print_string("销毁观察对象 ==================")
					table.remove(self.observerTarget, i);
					return true;
				end
			end
		end
		if unBinded() then  --多调用一次 避免多次绑定 
			unBinded();
		end
	end
end

Observer.dtor = function(self)
	self:cancelObserver();
end

---------------------------virtual-------------------------------
-- 观察的对象有改变 现在通知控件更新
Observer.notify = function(self, value)
end

