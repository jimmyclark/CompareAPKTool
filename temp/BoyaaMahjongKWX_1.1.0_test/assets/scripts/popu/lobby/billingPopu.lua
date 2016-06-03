local billingItemLayout = require(ViewPath .. "billingItem")
local billingPopu = class(require("popu.gameWindow"))


function billingPopu:ctor()
	EventDispatcher.getInstance():register(Event.Socket, self, self.onSocketReceive)
end

function billingPopu:dtor()
	EventDispatcher.getInstance():unregister(Event.Socket, self, self.onSocketReceive)
end

function billingPopu:initView(data)
  
	local backBtn = self:findChildByName("btn_back");
	backBtn:setOnClick(self, function ( self )
		-- body
		self:dismiss(true);
	end);
       
    GameSocketMgr:sendMsg(Command.BILLINGINFO_GET_PHP_REQUEST, {})
end

function billingPopu:initBillIngView(data)
	local view_billing = self:findChildByName("view_billing")
    view_billing:removeAllChildren(true)
    
    local viewWidth, viewHeight = view_billing:getSize()
    local scrollView = new(ScrollView, 0, 0, viewWidth, viewHeight, false)
    					:addTo(view_billing)

    local billingData = data.data

    if not billingData then
		local text_nodata = self:findChildByName("text_nodata")
		text_nodata:show()
    	return
    end

    local count = #billingData
	local sW, sH = scrollView:getSize()
	for i = 1, count do
		local data = billingData[i]
		local item = self:createBillingListItem(data)
		local iW, iH = item:getSize()
		item:setPos((sW - iW) / 2, iH * (i - 1))
		scrollView:addChild(item)
	end
end

function billingPopu:createBillingListItem( data )
	local item = SceneLoader.load(billingItemLayout):findChildByName("view_item")

	local curtime = os.time()
	local difftime = curtime - data.timestamp
    local hour = os.date("*t",difftime).hour;
    local min  = os.date("*t",difftime).min;

	local text_time = item:findChildByName("text_time")
	local timeStr = ""
    if 1 <= hour then
    	if 0 < math.floor(hour/24) then
    		timeStr = math.floor(hour/24).."天前"
    	else
    		timeStr = hour.."小时前"
    	end

    else
    	if 0 > min then
    		timeStr = "刚刚"
    	else
    		timeStr = min.."分钟前"
    	end
    end
    text_time:setText(timeStr)


	local playStr = ""
	item:findChildByName("text_total"):setText("总局数："..data.total.."局")

	if tonumber(data.me.money) >= 0 then playStr = playStr.."赢" else playStr = playStr.."输" end
	playStr = playStr..math.abs(data.me.money).."金币 "
	item:findChildByName("text_my"):setText(playStr)

	for k,v in pairs(data.play) do
		local playName = item:findChildByName("text_playname"..tonumber(k))
		playName:setText(v.nick..":")
		local tempText = new(Text, v.nick,0, 0, kAlignTopLeft, "", 30, 255, 255, 255)
		-- item:addChild(tempText)

		playStr = ""
		if v.money >= 0 then playStr = playStr.."赢" else playStr = playStr.."输" end
		playStr = playStr..math.abs(v.money).."金币 "
		local textW,_ = tempText:getSize()
		local textX,textY = playName:getPos()
		local text_playInfo = item:findChildByName("text_playInfo"..tonumber(k))
		text_playInfo:setText(playStr)
		text_playInfo:setPos(textX + textW,133)

		if 1 == v.sex then
			v.headImg = "kwx_common/img_manHead.png"
		else
			v.headImg = "kwx_common/img_womanHead.png"
		end
	end

	if 1 == data.me.sex then
		data.me.headImg = "kwx_common/img_manHead.png"
	else
		data.me.headImg = "kwx_common/img_womanHead.png"
	end
	table.insert(data.play, {money = data.me.money, headImg = data.me.headImg,sex = data.me.sex, mid = data.me.mid, nick = data.me.nick, url = data.me.url})
	item:findChildByName("btn_share"):setOnClick(self, function( self )
		WindowManager:showWindow(WindowTag.accountsPopu, data.play)
	end)

	return item
end

function billingPopu:dismiss(...)
    return billingPopu.super.dismiss(self, ...)
end

function billingPopu:onGetBillingInfo(data)
	self:initBillIngView(data)
end

function billingPopu:onSocketReceive(param, ...)
	if self.commandFunMap[param] then
		self.commandFunMap[param](self,...)
	end
end

billingPopu.s_severCmdEventFuncMap = {
	[Command.BILLINGINFO_GET_PHP_REQUEST]			= billingPopu.onGetBillingInfo,
}

billingPopu.commandFunMap = {
	[Command.BILLINGINFO_GET_PHP_REQUEST]			= billingPopu.onGetBillingInfo,
}

return billingPopu