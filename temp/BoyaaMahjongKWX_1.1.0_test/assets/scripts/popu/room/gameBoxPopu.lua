
local GameBoxPopu = class(require("popu.gameWindow"))

local printInfo, printError = overridePrint("GameBoxPopu")

local numberTable = {
	["0"] = "kwx_tanKuang/gameBox/number/0.png",
	["1"] = "kwx_tanKuang/gameBox/number/1.png",
	["2"] = "kwx_tanKuang/gameBox/number/2.png",
	["3"] = "kwx_tanKuang/gameBox/number/3.png",
	["4"] = "kwx_tanKuang/gameBox/number/4.png",
	["5"] = "kwx_tanKuang/gameBox/number/5.png",
	["6"] = "kwx_tanKuang/gameBox/number/6.png",
	["7"] = "kwx_tanKuang/gameBox/number/7.png",
	["8"] = "kwx_tanKuang/gameBox/number/8.png",
	["9"] = "kwx_tanKuang/gameBox/number/9.png",
}

function GameBoxPopu:ctor()
	-- EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
    GameSetting:setIsSecondScene(false)
end

function GameBoxPopu:dtor()
	-- EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
end

function GameBoxPopu:initView(data)
	local need = data.need or 0
	local process = data.process or 0
	local award = data.award or 0
	local view_notDone = self:findChildByName("view_notDone")
	local img_done = self:findChildByName("img_done")
	if 1 == award then
		view_notDone:hide()
		img_done:show()
	else
		local view_number = self:findChildByName("view_number")
		view_number:removeAllChildren()
		view_notDone:show()
		img_done:hide()
		need = need - process
		if need > 99 then need = 99 end
		if need > 9 then
			local n1 = math.floor(need / 10)
			local n2 = need - n1 * 10
			UIFactory.createImage(numberTable[""..n1]):pos(-34, 0):addTo(view_number)
			UIFactory.createImage(numberTable[""..n2]):pos(0, 0):addTo(view_number)
		else
			UIFactory.createImage(numberTable[""..need]):pos(0, 0):addTo(view_number)
		end
	end
	for i = 1, #(data.goods or {}) do
		self:initGoodsInfo(i, data.goods[i], award)
	end
end

function GameBoxPopu:initGoodsInfo(index, data, award)
	local btn = self:findChildByName(string.format("btn_box%d",index))
	if btn then
		local fileName = ""
		local textName = ""
		local img_typeImage = btn:findChildByName("img_typeImage")
		if 1 == award then
			fileName = "kwx_tanKuang/gameBox/img_boxDone.png"
			textName = "宝箱奖励"
			img_typeImage:setFile(fileName)
		else
			fileName = data.img
			textName = data.title or ""
			DownloadImage:downloadOneImage(fileName, img_typeImage)
		end
		printInfo("fileName : %s",(fileName or ""))

		local text_title = btn:findChildByName("text_title")
		text_title:setText(textName)

		btn:setOnClick(self, function(self)
			local temp = {}
			temp.level = G_RoomCfg:getLevel()
			temp.position = index - 1
			GameSocketMgr:sendMsg(Command.ROOM_GAME_BOX_AWARD_REQUEST, temp, false)
		end)
	end
end

function GameBoxPopu:onRoomGameBoxAwardResponse( data )
	if 1 ~= data.status or not data.data then
		return
	end
	data = data.data
	local isOk = data.status
	if 1 == isOk then
        for i = 1, #(data.goods or {}) do
		    self:initGoodsInfo(i, data.goods[i])
	    end
	end
end

GameBoxPopu.s_severCmdEventFuncMap = {
	[Command.ROOM_GAME_BOX_AWARD_REQUEST]		= GameBoxPopu.onRoomGameBoxAwardResponse,
}

return GameBoxPopu