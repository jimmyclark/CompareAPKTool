local RankData = class(require('data.dataList'))

addProperty(RankData, "hours", "")
addProperty(RankData, "page", 0)
addProperty(RankData, "totalPage", 0)
addProperty(RankData, "curCount", 1)
addProperty(RankData, "info", setProxy(new(require('data.rank'))))

function RankData:clear()
	self.super.clear(self);
	self:setHours("");
	self:setCurCount(1)
	self:setTotalPage(0)
	self:setPage(0)
end

return RankData