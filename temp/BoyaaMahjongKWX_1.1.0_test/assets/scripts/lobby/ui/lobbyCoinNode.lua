local LobbyCoinNode = class(Node, false);

function LobbyCoinNode:ctor(uiPath, ...)
	self.mUiPath =  {}
	if not uiPath then
		uiPath = "kwx_lobby/number"
	end
	self.mUiPath =  {
		['0'] = uiPath.."/0.png",
		['1'] = uiPath.."/1.png",
		['2'] = uiPath.."/2.png",
		['3'] = uiPath.."/3.png",
		['4'] = uiPath.."/4.png",
		['5'] = uiPath.."/5.png",
		['6'] = uiPath.."/6.png",
		['7'] = uiPath.."/7.png",
		['8'] = uiPath.."/8.png",
		['9'] = uiPath.."/9.png",
		[','] = uiPath.."/d.png",
		['.'] = uiPath.."/p.png",
		['w'] = uiPath.."/w.png",
		['y'] = uiPath.."/y.png",
		['-'] = uiPath.."/f.png",
		['+'] = uiPath.."/z.png",
		['#'] = uiPath.."/fen.png",
	}
	
	super(self, ...)
 	-- body
end

function LobbyCoinNode:dtor()
	self:removeAllChildren()
end

function LobbyCoinNode:setNumber( formatNumber )
	-- body
	self:removeAllChildren();
	printInfo("formatNumber : %s", formatNumber)
	local x, y = 0, 0;

	for i = 1, string.len(formatNumber) do
		local c = string.sub(formatNumber, i, i);
		local numImg 	= new(Image, self.mUiPath[c]);
		if numImg then
			local w, h = numImg:getSize();
			w = w - 2; -- 调整间距
			if c == ',' then
				w = w - 1;
				x = x - 1;
			elseif c == 'c' then
				w = w + 2;
				x = x + 2;
			end
			numImg:setPos(x, y);
			x = x + w;
			self:addChild(numImg);
			self:setSize(x, h);
		end
	end
end

return LobbyCoinNode