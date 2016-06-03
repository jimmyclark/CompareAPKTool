local inviteEntryPopu = class(require("popu.gameWindow"))


function inviteEntryPopu:initView(data)

    if not data or not data.data then
        AlarmTip.play("未获取配置，请稍后重试！")
        return
    end
    
	self.m_sendData = data.data
    self:findChildByName("btn_wechat"):setOnClick(self, function( self )
    	NativeEvent.getInstance():shareOnlyMessage(3, 
    		self.m_sendData.weixin.desc, 
    		self.m_sendData.weixin.url, 
    		self.m_sendData.weixin.icon)

        -- //邀请的方式，如短信sms、微信weixin、QQqq、朋友圈pyq
        GameSocketMgr:sendMsg(Command.INVITE_STATISTICS_PHP_REQUEST,{["fid"] = G_RoomCfg:getFid(), ["type"] = "weixin"})
    end)

    self:findChildByName("btn_address"):setOnClick(self, function( self )
    	NativeEvent.getInstance():sendMessageToPlayer(self.m_sendData.sms.desc..self.m_sendData.sms.url)
        GameSocketMgr:sendMsg(Command.INVITE_STATISTICS_PHP_REQUEST,{["fid"] = G_RoomCfg:getFid(), ["type"] = "sms"})
    end)

end

function inviteEntryPopu:dismiss(...)
    return inviteEntryPopu.super.dismiss(self, ...)
end




return inviteEntryPopu