local AnimationBase = require("animation.animationBase")
local Upgradecoinshow = class(AnimationBase)

function Upgradecoinshow:load(params)
	local pos = params.pos
	if pos then
		self:pos(pos.x, pos.y)
	end

	self.m_imgNode = new(Node)
		:addTo(self)
		:align(kAlignCenter)
	local prefix = params.money >= 0 and "win" or "lose"
	local sign = params.money >= 0 and "+" or "-"
	local path = params.money >= 0 and "kwx_room/moneyNum/" or "kwx_room/moneyNum/" 
	local moneyStr = tostring(math.abs(params.money))
	local imagesTb = {prefix .. sign .. kPngSuffix}
	for i=1, #moneyStr do
		table.insert(imagesTb, string.format("%s%s.png", prefix, string.sub(moneyStr, i, i)))
	end
	
	table.insert(imagesTb,"jin_icon.png");
	table.insert(imagesTb,"bi_icon.png");

	local x = 0
	for i=1, #imagesTb do
		local img = UIFactory.createImage(path .. imagesTb[i])
			:addTo(self.m_imgNode)
			:align(kAlignLeft)
		local width, height = img:getSize()
		img:pos(x, 0)
		x = x + width
	end
	self.m_imgNode:setSize(x, 0)
	self.m_imgNode:setVisible(false);

end

function Upgradecoinshow:play(params)
	self:stop()
	self:load(params)
    
    self.m_imgNode:setVisible(true); 
    self.m_imgNode:addPropTransparency(121,kAnimNormal,1,1000,0,1);
	self.m_imgNode:addPropScale(122,kAnimNormal,100,1000,1,1.3,1,1.3,kCenterDrawing);
	self.m_imgNode:addPropScale(123,kAnimNormal,100,1100,1,0.77,1,0.77,kCenterDrawing);
	
end

function Upgradecoinshow:stop()
	printInfo("停止动画")
	if self.mAnim then
		delete(self.mAnim)
		self.mAnim = nil
	end

	if self.m_imgNode then
       delete(self.m_imgNode);
	end	
end

return Upgradecoinshow