
local GiveCoinPopu = class(require("popu.gameWindow"))

local printInfo, printError = overridePrint("GiveCoinPopu")

function GiveCoinPopu:ctor()
    GameSetting:setIsSecondScene(true)
end

function GiveCoinPopu:dtor()

end

function GiveCoinPopu:initView(data)
	self:findChildByName("btn_close"):setOnClick(self, function(self)
		self:dismiss()
	end)

	local award = tonumber(data.award) or 0

	local text_title = self:findChildByName("text_title")
	text_title:setText(data.title or "金币大派送")

	local text_momey = self:findChildByName("text_momey")
	text_momey:setText(data.gmoney or 0)

	local view_descText = self:findChildByName("view_descText")
	local x, y = 0, 0
	local params = {}
	params.text = data.time or ""
	params.size = 24

	local text_time = UIFactory.createText(params):addTo(view_descText):pos(x, y)
	local w , h = text_time:getSize()
	x = x + w
	params.text = data.desc or ""
	params.color = {}
	params.color.r = 0xff
	params.color.g = 0xf0
	params.color.b = 0x23
	local text_desc = UIFactory.createText(params):addTo(view_descText):pos(x, y)
	local w, h = text_desc:getSize()
	x = x + w
	params.text = data.money or ""
	params.color = {}
	params.color.r = 0xff
	params.color.g = 0xf0
	params.color.b = 0x23
	local text_money = UIFactory.createText(params):addTo(view_descText):pos(x, y)
	local w, h = text_money:getSize()
	x = x + w
	local w, h = view_descText:getSize()
	local vx , vy = view_descText:getPos()
	local scale = System.getLayoutScale()
	vx = (w - x) / 2
	view_descText:setSize(x , h)
	view_descText:setPos(vx, vy)

	local img_updateProgressBg = self:findChildByName("img_updateProgressBg")
	local pamount = tonumber(data.amount) or 6
	local rate = tonumber(data.rate) or 0
	if 1 == tonumber(data.type) then
		img_updateProgressBg:show()
		local img_progress = self:findChildByName("img_progress")
		local text_percent = self:findChildByName("text_percent")
		local w , h = img_updateProgressBg:getSize()
		local iw, ih = img_progress:getSize()
		local tw = w * (rate / 100)
		if tw > iw then iw = tw end
		img_progress:setSize(iw, ih)
		printInfo("img_updateProgressBg iw %s, h : %s", iw, h)
		text_percent:setText(rate.."%")

		pamount = math.floor(((100 - rate) / 100) * pamount)
	else
		img_updateProgressBg:hide()
	end

	local btn_mid = self:findChildByName("btn_mid")
	self:findChildByName("text_btnName"):setText(data.btn or "确定")
	btn_mid:setOnClick(self, function(self)
		if 1 == award then
			GameSocketMgr:sendMsg(Command.ROOM_GAME_ACTIVITY_AWARD_REQUEST, {level = G_RoomCfg:getLevel() , act = "award"}, false)
		else
			printInfo("pamount : %d", pamount)
			local index, goodsInfo = PayController:getGoodsInfoByPamount(pamount, 0)
			if goodsInfo then
				globalRequestCharge(goodsInfo, {}, false);
			end
		end
		self:dismiss()
	end)
end

return GiveCoinPopu