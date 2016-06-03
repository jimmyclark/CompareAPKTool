local UserPanel = require("room.entity.userPanel")

local GbUserPanel = class(UserPanel)

function GbUserPanel:initView()
	GbUserPanel.super.initView(self)
end

return GbUserPanel