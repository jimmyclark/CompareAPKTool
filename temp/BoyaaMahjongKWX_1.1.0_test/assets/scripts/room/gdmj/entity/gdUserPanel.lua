local UserPanel = require("room.entity.userPanel")

local GdUserPanel = class(UserPanel)

function GdUserPanel:initView()
	GdUserPanel.super.initView(self)
end

return GdUserPanel