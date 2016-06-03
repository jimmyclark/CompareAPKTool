local accountsPopu = class(require("popu.gameWindow"))


function accountsPopu:initView(data)

 	local accountsTab = data
    -- table.insert(accountsTab, {score = data.me.money, sex = data.me.sex, mid = data.me.mid, nick = data.me.nick, url = data.me.url})
    -- table.insert(accountsTab, {score = data.play[1].money, sex = data.play[1].sex, mid = data.play[1].mid, nick = data.play[1].nick, url = data.play[1].url})
    -- table.insert(accountsTab, {score = data.play[2].money, sex = data.play[2].sex, mid = data.play[2].mid, nick = data.play[2].nick, url = data.play[2].url})

    table.sort(accountsTab, function(s1, s2)
    	return s1.money > s2.money;
    end)

    self:findChildByName( "btn_back" ):setOnClick(self, function( self )
    	self:dismiss()
        if kCurrentState == States.Room then
            self:handlerExitRoom()
        end
    end)

    for i = 1, #accountsTab do
    	self:findChildByName( "text_name"..i):setText(accountsTab[i].nick)

    	local view_score = self:findChildByName( "view_score"..i)
    	local textScore
    	if accountsTab[i].money >= 0 then
    		textScore = new(require("lobby.ui.lobbyCoinNode"), "kwx_room/accounts/positive")
    	else
    		textScore = new(require("lobby.ui.lobbyCoinNode"), "kwx_room/accounts/negative")
    	end
        textScore:setAlign(kAlignCenter)
    	textScore:setNumber(accountsTab[i].money)
    	view_score:addChild(textScore)

        textScore:addPropTranslate(101, kAnimNormal, 300, i * 300, 0, 0, 0, -100)

        local img_head = self:findChildByName( "img_head"..i)
        local headImage = new(Mask, accountsTab[i].headImg, "kwx_room/accounts/img_headzz.png");
        headImage:setSize(img_head:getSize());
        img_head:addChild(headImage);
    end

    local img_title = self:findChildByName("img_title")
    img_title:addPropTranslate(101, kAnimNormal, 300, 100, 0, 0, -150, 0)

    self:findChildByName("btn_share"):setOnClick(self, function( self )
        NativeEvent.getInstance():shareToFriend({["userName"] = MyUserData:getNick()})
    end)
end


function accountsPopu:handlerExitRoom()
    GameSocketMgr:sendMsg(Command.LogoutRoomReq)
    StateChange.changeState(States.Lobby)
    --用户基本信息 更新用户基本信息
    GameSocketMgr:sendMsg(Command.GET_BASEINFO_PHP_REQUEST, {infoParam = {s1 = 0xf, d1 = 0xff}}, false);
end

function accountsPopu:dismiss(...)
    return accountsPopu.super.dismiss(self, ...)
end


return accountsPopu