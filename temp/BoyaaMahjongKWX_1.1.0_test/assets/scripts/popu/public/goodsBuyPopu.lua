local GameWindow = require("popu.gameWindow")
local goodsBuyPopu = class(GameWindow)

GoodsNum_Max = 200

function goodsBuyPopu:initView(data)

	-- 购买数量
	self.mBuyGoodsNumber = 1
  self.mGoodsPrice = data:getMoney()

	-- 购买数量编辑
  self.numberTextEdit = self:findChildByName("editText_number")
  self.numberTextEdit:setOnTextChange(self, self.onNumberTextChange)

	-- 关闭按钮
	local btn_close = self:findChildByName("btn_close")
    btn_close:setOnClick(self,function (self)
       --body
      self:dismiss();
    end)

    -- 增加按钮
	local btn_add = self:findChildByName("btn_add")
  -- btn_add:setOnClick(self,function (self)
  --    --body
  --    self:updateBuyNumber(1) 
  -- end)
  local isDown = false
  btn_add:setEventTouch(self, function(self, finger_action)
      if not isDown then 
        isDown = true
        self:updateBuyNumber(1) 
      end

      if finger_action == kFingerDown and isDown then
        btn_add:schedule(function()
          self:updateBuyNumber(1) 
        end,150)
      elseif finger_action == kFingerUp then
        isDown = false
        btn_add:stopAllActions()
      end
    end);

   	-- 减少按钮
	local btn_cut = self:findChildByName("btn_cut")
  -- btn_cut:setOnClick(self,function (self)
  --      --body
  --      if self.mBuyGoodsNumber >= 2 then
  --      		self:updateBuyNumber(-1)
  --  	   end
  -- end)

  btn_cut:setEventTouch(self, function(self, finger_action)
      if not isDown then 
        isDown = true
        self:updateBuyNumber(-1) 
      end

    if finger_action == kFingerDown and isDown and self.mBuyGoodsNumber >= 2 then
      btn_cut:schedule(function()
        self:updateBuyNumber(-1) 
      end,150)
    elseif finger_action == kFingerUp then
      isDown = false
      btn_cut:stopAllActions()
    end
  end);

  -- 购买按钮
  local btn_buy = self:findChildByName("btn_buy")
  btn_buy:setOnClick(self, function ( self )
    -- body
    local myMoney = MyUserData:getMoney()
    local needMoney = self.mBuyGoodsNumber * self.mGoodsPrice

    if app:isInRoom() then
      -- 在牌局进行中购买喇叭，玩家金币如果小于底注*30+喇叭价格*购买数量
      if G_RoomCfg and (G_RoomCfg:getDi()*30 + needMoney) > myMoney then
        AlarmTip.play("您的金币较少，无法在牌局中购买")
        return
      end
    elseif myMoney < needMoney then
      AlarmTip.play("您的金币足，无法兑换该商品！")
      app:selectGoodsForChargeVarMoney()
      self:dismiss();
      return
    end

    local goodsInfo = {};
    goodsInfo.id = data:getId();
    goodsInfo.cid = data:getCid();
    goodsInfo.num = self.mBuyGoodsNumber
    GameSocketMgr:sendMsg(Command.EXCHANGE_GOODS_REQUEST, goodsInfo)
    --self:dismiss()
  end)    

  -- 当前金币
  local text_curGold = self:findChildByName("text_curGold")
  text_curGold:setText(ToolKit.formatNumber(MyUserData:getMoney()))
  UIEx.bind(self, MyUserData, "money", function(value)
      text_curGold:setText(ToolKit.formatNumber(MyUserData:getMoney()))
  end)

  -- 设置道具图片
  local img_goodsMark = self:findChildByName("img_goodsMark")
  local img_pic = UIFactory.createImage("kwx_shop/img_defalutHuaFei.png")
            :addTo(img_goodsMark)
            :pos(0, 0)
  img_pic:setAlign(kAlignCenter);
  DownloadImage:downloadOneImage(data:getImage(), img_pic)

  -- 单价
  local text_goldPrice = self:findChildByName("text_goldPrice")
  text_goldPrice:setText(self.mGoodsPrice)

  -- 总价
  self.mTotlePrice = self:findChildByName("text_totlePrice")

  self:updateBuyNumber(0)
  
end

function goodsBuyPopu:onNumberTextChange()
	-- body
	self.mBuyGoodsNumber = tonumber(self.numberTextEdit:getText()) or 1

  self:updateBuyNumber(0)

end

function goodsBuyPopu:updateBuyNumber(num)
	-- body
	self.mBuyGoodsNumber = self.mBuyGoodsNumber + num

  if self.mBuyGoodsNumber > GoodsNum_Max then self.mBuyGoodsNumber = GoodsNum_Max end
  if self.mBuyGoodsNumber < 1 then self.mBuyGoodsNumber = 1 end

	self.numberTextEdit:setText(self.mBuyGoodsNumber)

  self.mTotlePrice:setText(ToolKit.formatNumber(self.mBuyGoodsNumber * self.mGoodsPrice))

  self:findChildByName("btn_add"):setIsGray(false)
  self:findChildByName("btn_cut"):setIsGray(false)

  if self.mBuyGoodsNumber >= GoodsNum_Max then self:findChildByName("btn_add"):setIsGray(true)  end
  if self.mBuyGoodsNumber <= 1 then self:findChildByName("btn_cut"):setIsGray(true) end

end

function goodsBuyPopu:dismiss(...)
    return goodsBuyPopu.super.dismiss(self, ...)
end

function goodsBuyPopu:onExchangeGoodsResponse(data)
    printInfo("ShopPopu:onExchangeGoodsResponse")
    if not data or 1 ~= data.status or not data.data then
        return
    end
    
    GameSocketMgr:sendMsg(Command.EXCHANGE_RECORD_REQUEST, {});
    data = data.data
    if 1 == data.status then
        local money = MyUserData:getMoney()
        local huaFei = MyUserData:getHuaFei()

        money = money - (data.money or 0)
        huaFei = huaFei - (data.coupons or 0)
        MyUserData:setMoney(money)
        MyUserData:setHuaFei(huaFei)
        AlarmTip.play(data.msg or "")
    else
        AlarmTip.play(data.msg or "")
    end

    -- local curMoney = MyUserData:getMoney()
    -- self:findChildByName("text_curGold"):setText(ToolKit.formatNumber(MyUserData:getMoney()))
end

goodsBuyPopu.s_severCmdEventFuncMap = {
    [Command.EXCHANGE_GOODS_REQUEST]                = goodsBuyPopu.onExchangeGoodsResponse,
}

return goodsBuyPopu