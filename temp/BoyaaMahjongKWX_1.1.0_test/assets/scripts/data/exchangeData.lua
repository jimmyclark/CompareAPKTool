local ExchangeData = class(require('data.dataList'))

--[[
	道具ID
]]
ExchangeData.TypeBqCard 	= 2		-- 补签卡
ExchangeData.TypeHorn 		= 22		-- 喇叭
ExchangeData.TypeBackGift 	= 90001		-- 回头礼包

function ExchangeData:getGoodsInfoByPamount(pamount)
	if not self:getInit() then return end
	for i=1, self:count() do
		local record = self:get(i)
		printInfo("record:getPamount() = "..record:getPamount());
		if record:getPamount() == pamount then
			return i, record
		end
	end
end

function ExchangeData:getIndexByPamount(pamount)
	local money = {};
	local count = self:count();

	for i = 1, count do
		table.insert(money, self:get(i):getPamount());
	end
	table.sort(money, function ( a, b )
		-- body
		return a < b;
	end)

	for i = 1, #money do
		if money[i] == pamount then
			return i;
		end
	end

	return 1;
end

function ExchangeData:setGoodsNumById( id, num )
	-- body
	for i = 1, self:count() do
		local record = self:get(i)

		if record and record:getCid() == id then
			record:setNum(num)
			return
		end
	end
end

function ExchangeData:getGoodsNumById( id )
	-- body
	for i = 1, self:count() do
		local record = self:get(i)

		if record and record:getCid() == id then
			return record:getNum()
		end
	end
end
 
function ExchangeData:getGoodsInfoById( id )
	-- body
	for i = 1, self:count() do
		local record = self:get(i)

		if record and record:getCid() == id then
			return record
		end
	end
end

return ExchangeData  