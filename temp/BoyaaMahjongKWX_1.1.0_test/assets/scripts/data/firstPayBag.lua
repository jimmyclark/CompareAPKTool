local FirstPayBag = class(require('data.dataList'))

addProperty(FirstPayBag, "open", 0)
addProperty(FirstPayBag, "desc", "")
addProperty(FirstPayBag, "price", 0)
addProperty(FirstPayBag, "btn_type", 1)
addProperty(FirstPayBag, "status", 0)
addProperty(FirstPayBag, "gift_price", "")
addProperty(FirstPayBag, "gift_title", "")

function FirstPayBag:clear()
	self.super.clear(self);
	self:setOpen(0)
	self:setDesc("")
	self:setPrice(0)
	self:setStatus(0)
end

return FirstPayBag;