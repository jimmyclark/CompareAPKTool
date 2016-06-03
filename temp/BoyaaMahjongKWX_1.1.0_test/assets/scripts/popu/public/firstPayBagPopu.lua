local FirstPayBagPopu = class(require("popu.gameWindow"));

function FirstPayBagPopu:ctor()
    printInfo("FirstPayBagPopu:ctor")
end

function FirstPayBagPopu:dtor()
    printInfo("FirstPayBagPopu:dtor")
end

function FirstPayBagPopu:initView(data)

    data = data or {}
    self:findChildByName("btn_close"):setOnClick(self,function (self)
        --body
        self:dismiss();
    end);
    self:findChildByName("btn_close1"):setOnClick(self,function (self)
        --body
        self:dismiss();
    end);

    if not MyFirstPayBagData:getInit() then
        GameSocketMgr:sendMsg(Command.FIRST_PAY_BAG_PHP_REQUEST, {['act']='detail'});
    end

    self:findChildByName("img_caidai"):setPickable(false)

    self:_initView();
    self.chargeType = data.chargeType

    UIEx.bind(self, MyBaseInfoData, "firstPay", function(value)
        if 1 == value then
            self:dismiss()
        end
    end)
end

function FirstPayBagPopu:_initView()
    local view_desc = self:findChildByName("view_desc")
    local x, y = 0, 0
    local pramas = {}
    pramas.size = 30
    pramas.text = MyFirstPayBagData:getDesc()
    local text_left = UIFactory.createText(pramas):pos(x, y)
    text_left:setAlign(kAlignLeft)
    view_desc:addChild(text_left)
    local w, h = text_left:getSize()
    x = x + w
    pramas.size = 38
    local color = {}
    color.r = 0xFF
    color.g = 0xF0
    color.b = 0x22
    pramas.color = color
    pramas.text = MyFirstPayBagData:getGift_price()
    local text_mid = UIFactory.createText(pramas):pos(x, y)
    text_mid:setAlign(kAlignLeft)
    view_desc:addChild(text_mid)
    local w, h = text_mid:getSize()
    x = x + w
    pramas.size = 30
    pramas.text = MyFirstPayBagData:getGift_title()
    pramas.color = nil
    local text_right = UIFactory.createText(pramas):pos(x, y)
    text_right:setAlign(kAlignLeft)
    view_desc:addChild(text_right)


    local img_btnText = self:findChildByName("img_btnText")
    local btn_type = MyFirstPayBagData:getBtn_type()
    if 1 ~= btn_type then
        img_btnText:setFile("kwx_tanKuang/bigGift/img_buy.png")
    end

    if MyFirstPayBagData:getInit() then
        self:findChildByName("btn_get"):setOnClick(self,function(self)
            self.mPay = true;
            self:dismiss(true);
            local index, goodsInfo = PayController:getGoodsInfoByPamount(MyFirstPayBagData:getPrice(), 0)
            if index and goodsInfo then
                globalRequestCharge(goodsInfo, {}, false);
            else
                AlarmTip.play("没有找到合适的商品");
            end
        end);
    end
    local count = MyFirstPayBagData:count()
    for i = 1, count do
        local firstPayData = MyFirstPayBagData:get(i)
        local view = self:findChildByName(string.format("view_info%d",i))
        if not view then return end
        
        local text_info = view:findChildByName("text_info")
        text_info:setText(firstPayData:getName())

        local view_make = self:findChildByName("view_make")
        local img_pic = UIFactory.createImage("kwx_shop/img_defalutHuaFei.png")
                        :addTo(view)
                        -- :setSize(100, 100)
                        :pos(0, -15)
        img_pic:setAlign(kAlignCenter);
        DownloadImage:downloadOneImage(firstPayData:getImg(), img_pic)
    end
end

function FirstPayBagPopu:onFirstPayBagResponse(data)
    self:_initView();
end

function FirstPayBagPopu:onHidenEnd(...)
    FirstPayBagPopu.super.onHidenEnd(self, ...);

    if not self.mPay and app:checkIsBroke() then
        printInfo("FirstPayBagPopu:onHidenEnd setAvoidFirstPay true")
        MyUserData:setAvoidFirstPay(true)
        app:selectGoodsForChargeVarMoney()
    elseif not self.mPay and self.chargeType == ChargeType.NotEnoughMoney then
        app:selectGoodsForChargeByLevel({
            chargeType = ChargeType.NotEnoughMoney,
            avoidFirstPay = true,
        })
    end
end


FirstPayBagPopu.s_severCmdEventFuncMap = {
    [Command.FIRST_PAY_BAG_PHP_REQUEST]   = FirstPayBagPopu.onFirstPayBagResponse,
}

return FirstPayBagPopu;