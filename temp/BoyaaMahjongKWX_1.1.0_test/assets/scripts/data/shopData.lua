local ShopData = class(require('data.dataList'))

function ShopData:getGoodsInfoByPamount(pamount)
	if not self:getInit() then return end
	local ret = nil
	local index
	for i = 1, self:count() do
		local record = self:get(i)
		if record:getPamount() == pamount then
			return i, record
		end
		if not ret then
			index = i
			ret = record
		else
			if ret:getPamount() < pamount and ret:getPamount() <= record:getPamount() then
				index = i
				ret = record
			elseif ret:getPamount() >= pamount and ret:getPamount() >= record:getPamount() then
				index = i
				ret = record
			end
		end
	end
	return index, ret
end

function ShopData:getIndexByPamount(pamount)
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

return ShopData  