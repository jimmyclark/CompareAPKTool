local TestToolManager = class(Node)

function TestToolManager:ctor()
	self:addToRoot()
	self:setLevel(199)
	local toolBtn = UIFactory.createButton("common/buttons/green_small.png", nil, nil, nil, 30, 30, 0, 0)
		:addTo(self)
		:align(kAlignCenter)

	toolBtn:setSize(186, 68)
	toolBtn:setOnClick(nil, function()
		WindowManager:showWindow(WindowTag.TestToolPopu)
	end)
end

return TestToolManager