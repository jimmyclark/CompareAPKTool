local Prop = class()

addProperty(Prop, "level", 0)
addProperty(Prop, "limit", 2100000000)
addProperty(Prop, "propList", {})

function Prop:getPropById(pid)
	for i,v in pairs(self:getPropList()) do
		if v.pid == pid then
			return v
		end
	end
end

return Prop