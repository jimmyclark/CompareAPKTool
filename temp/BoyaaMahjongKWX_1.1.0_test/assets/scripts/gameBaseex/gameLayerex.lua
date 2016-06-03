require("gameBase/gameLayer");

GameLayer.getControlInConfig = function(self,config)
	if (not config) or (#config < 1) then
		return nil;
	end
	local result = nil;
	local itorNestValues = function(t)
		local index = {1};

		return function()
			local getValue = function(t,idx)
				local c = t;
				for i=1,#idx-1 do
					c = c[ idx[i] ]; 
				end
				c = c[ idx[#idx] ];
				return c
			end

			local value = getValue(t,index);
			while not value do
				table.remove(index,#index);
				if #index < 1 then
					return nil;
				end
				index[#index] = index[#index] + 1;
				value = getValue(t,index);
			end

			while type(value) == "table" do
				index[#index+1] = 1;
				value = getValue(t,index);
			end

			index[#index] = index[#index] + 1;
			return value;
		end
	end
    
    local ctrl = self.m_root;
	for v in itorNestValues(config) do
		ctrl = ctrl:getChildByName(v);
		result = ctrl;
		if not ctrl then
			break;
		end
	end
	return result;
end

--virtual function
GameLayer.getControl = function(self, control)
	if self.m_controlsMap[control] ~= nil then
		return self.m_controlsMap[control] or nil;
	end

	local config = self.s_controlConfig[control];

	if (not config) or (#config < 1) then
		self.m_controlsMap[control] = false;
		return nil;
	end
	local result = self:getControlInConfig(config);
	if result == nil then
		self.m_controlsMap[control] = false;
	else
		self.m_controlsMap[control] = result;
	end
	return self.m_controlsMap[control] or nil;
end

--声明 layout 变量
GameLayer.declareLayoutVar = function(self,layoutVarFile)
	local success, map = pcall(function () 
        return require(layoutVarFile)
    end)

    if success == false then
    	error("load layout_var file failed, not ".. layoutVarFile .. " file exist");
    	return
    end

	if map then
		self.s_controls = map["var"];
		self.s_controlConfig = map["ui"];
		self.s_controlFuncMap = map["func"];
		self:addEventListeners();
	end
end

GameLayer.addEventListeners = function(self)
    for k,v in pairs(self.s_controlFuncMap) do
		local ctrl = self:getControl(k);
		if type(v) == "string" then
			v = self[v];
		end
		if ctrl then
			for _,vv in ipairs(GameLayer.s_ctrlCallbackMap) do 
				if typeof(ctrl,vv[1]) then
					ctrl[ vv[2] ](ctrl,self,v);
					break;
				end
			end
		end
	end
end