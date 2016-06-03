--[[
	支付推荐配置
]]

local MoneyRecommendData = class(require('data.dataList'))

function MoneyRecommendData:getPamountByMoney(money)
	if not self:getInit() then return end
	money = money or MyUserData:getMoney()
	local moneyData = self:getData()
	table.sort(moneyData, function(s1, s2)
		return s1:getMin() < s2:getMin()
	end)
	for i,v in ipairs(moneyData) do
		if money >= v:getMin() and money < v:getMax() then
			return v:getPrice()
		end
	end
	local lastPayPamount = moneyData[#moneyData] and moneyData[#moneyData]:getPrice()
	printInfo("找不到配置返回最后一个配置额度： %d", lastPayPamount or 0)
	return lastPayPamount
end

return MoneyRecommendData