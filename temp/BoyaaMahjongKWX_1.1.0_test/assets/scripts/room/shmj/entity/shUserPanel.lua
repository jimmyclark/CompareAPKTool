local UserPanel = require("room.entity.userPanel")

local ShUserPanel = class(UserPanel)

function ShUserPanel:initView()
	ShUserPanel.super.initView(self)
end

return ShUserPanel