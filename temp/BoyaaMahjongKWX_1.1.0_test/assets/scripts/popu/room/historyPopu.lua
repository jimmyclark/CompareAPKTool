local historyPopu = class(require("popu.gameWindow"))


function historyPopu:initView(data)
  
    --local closeBtn = self:findChildByName("btn_Close");
    --closeBtn:setOnClick(self,function (self)
        --body
    --   self:dismiss();
    --end)
	local myCount = 0
	local play2Count = 0
	local play4Count = 0
	local scroll_history = self:findChildByName("scroll_history")


	local sW, sH = scroll_history:getSize()
	local historyCfg = G_RoomCfg:getHistoryScore()
	local historytab = historyCfg.historytab or {}
    local itemH = 42
    for i=1, #historytab do
    	local item = self:createScoreItem(i, historytab[i])
    	item:setPos(sW/2, itemH*(i-1))
    	scroll_history:addChild(item)

    	myCount 	= myCount + historytab[i].my
    	play2Count 	= play2Count + historytab[i].play2
    	play4Count 	= play4Count + historytab[i].play4
    end

    self:findChildByName("text_play2"):setText(historyCfg.seat2)
    self:findChildByName("text_play4"):setText(historyCfg.seat4)

    self:findChildByName("text_scoreme"):setText(myCount)
    self:findChildByName("text_score2"):setText(play2Count)
    self:findChildByName("text_score4"):setText(play4Count)

end

function historyPopu:createScoreItem( index, data )
	local item = new(Node)
	
	item:setSize(593,42)
	local roundnumText = new(Text, index, 0, 0, kAlignCenter,"", 26,255,255,255)
	--roundnumText:setAlign(kAlignCenter)
	roundnumText:setPos(-242,5)
	item:addChild(roundnumText)

	local myScore = new(Text, data.my, 0, 0, kAlignCenter,"", 26,0xff,0xff,0x5f)
	--myScore:setAlign(kAlignCenter)
	myScore:setPos(-130,5)
	item:addChild(myScore)

	local play2Score = new(Text, data.play2, 0, 0, kAlignCenter,"", 26,0x32,0xfa,0x1e)
	--play2Score:setAlign(kAlignCenter)
	play2Score:setPos(15,5)
	item:addChild(play2Score)

	local play4Score = new(Text, data.play4, 0, 0, kAlignCenter,"", 26,255,255,255)
	--play4Score:setAlign(kAlignCenter)
	play4Score:setPos(180,5)
	item:addChild(play4Score)
	return item
end

function historyPopu:dismiss(...)
    return historyPopu.super.dismiss(self, ...)
end

return historyPopu