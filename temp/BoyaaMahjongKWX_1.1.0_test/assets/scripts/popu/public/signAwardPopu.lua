local GameWindow = require("popu.gameWindow")
local SignAwardPopu = class(GameWindow)

function SignAwardPopu:initView()
    printInfo("SignAwardPopu:initView")
    local closeBtn = self:findChildByName("btn_close");
    closeBtn:setOnClick(self,function (self)
        --body
        self:dismiss();
    end)
    
    local btn_signAward = self:findChildByName("btn_signAward");

    btn_signAward:setOnClick(self,function (self)
        --body   
        -- 签到未完成则签到请求
        if MySignAwardData:getToday_sign() == 0 then
            GameSocketMgr:sendMsg(Command.SIGN_GETAWARD_PHP_REQUEST, { ["do"] = "sign" },false);  
        elseif MySignAwardData:getToday_sign() == 1 then
            -- 快速开始
            self:dismiss(true, true)
            app:quickStartGame()
        end
    end);
    local text_temp = (MySignAwardData:getToday_sign() == 0) and "签 到" or "快速开始"
    self:findChildByName("text_signAward"):setText(text_temp)
    UIEx.bind(self, MySignAwardData, "today_sign", function(value)
        local text_temp = (MySignAwardData:getToday_sign() == 0) and "签 到" or "快速开始"
        self:findChildByName("text_signAward"):setText(text_temp)
    end)
    if MySignAwardData:getInit() then
        self:_initView()
    end
    self:findChildByName("text_totalSign"):setText(MySignAwardData:getSign_count())
    UIEx.bind(self, MySignAwardData, "sign_count", function(value)
        self:findChildByName("text_totalSign"):setText(MySignAwardData:getSign_count())
    end)

    local bqkCount = MyGoodsData:getGoodsNumById(MyGoodsData.TypeBqCard) or MySignAwardData:getBqk_count()
    self:findChildByName("text_totalAddSignCard"):setText(bqkCount)
   
    local lqCount = MySignAwardData:getLq_count()
    self:findChildByName("text_lqTime"):setText(lqCount)
    UIEx.bind(self, MySignAwardData, "lq_count", function(value)
        self:findChildByName("text_lqTime"):setText(MySignAwardData:getLq_count())
    end)

    self:updateBQSignData()
    -- 补签按钮
    local btn_bq = self:findChildByName("btn_addSignAward")
    btn_bq:setOnClick(self, function ( self )
        -- body
        if self.mBqkCount > 0 then
            if self.mLqCount > 0 then
                GameSocketMgr:sendMsg(Command.SIGN_BQ_GETAWARD_PHP_REQUEST, { ["do"] = "signed" },false); 
            end
        else

            local count = MyGoodsData:count();
            for i = 1, count do
                local exchangeData = MyGoodsData:get(i)

                if exchangeData:getCid() == MyGoodsData.TypeBqCard then
                    WindowManager:showWindow(WindowTag.GoodsBuyPopu, exchangeData );
                    return
                end
            end
        end
    end)


end

function SignAwardPopu:_initView()
    local count = MySignAwardData:count()
    for i = 1, count do
        local view_temp = self:findChildByName(string.format("view_sign%d",i))
        if not view_temp then
            return
        end
        local btn_temp = view_temp:findChildByName(string.format("btn_sign%d",i))
        local text_sign = view_temp:findChildByName(string.format("text_sign%d",i))
        local text_signInfo = view_temp:findChildByName(string.format("text_signInfo%d",i))
        local img_signImage = view_temp:findChildByName(string.format("img_signImage%d",i))
        local img_get = view_temp:findChildByName(string.format("img_get%d",i))
        local signInfo = MySignAwardData:get(i)

        btn_temp:setOnClick(self, function(self)
            GameSocketMgr:sendMsg(Command.SIGN_GETGIFTAWARD_PHP_REQUEST, { ["do"] = "gif" , times = signInfo:getTimes()},false);
        end)

        UIEx.bind(btn_temp, signInfo, "tips", function(value)
            printInfo("tips : %d",value)
            if 1 == value then
                btn_temp:setFile("kwx_tanKuang/sign/btn_mianban_1.png")
            else
                btn_temp:setFile("kwx_tanKuang/sign/btn_mianban_2.png")
            end
        end)
        UIEx.bind(img_signImage, signInfo, "img", function(value)
            local defalut = "kwx_tanKuang/sign/img_defalut_2.png"
            img_signImage:setFile(defalut)
            DownloadImage:downloadOneImage(value, img_signImage, defalut)
        end)
        signInfo:setImg(signInfo:getImg())
        UIEx.bind(img_get, signInfo, "tips", function(value)
            img_get:setVisible(4 == value)
        end)
        printInfo("signInfo:getTips : %d",signInfo:getTips())
        signInfo:setTips(signInfo:getTips())
        UIEx.bind(text_sign, signInfo, "title", function(value)
            text_sign:setText(value)
        end)
        text_sign:setText(signInfo:getTitle())
        UIEx.bind(text_signInfo, signInfo, "desc", function(value)
            text_signInfo:setText(value)
        end)
        text_signInfo:setText(signInfo:getDesc())
    end
end

function SignAwardPopu:refreshSignData( data )
    MySignAwardData:setSign_count(data.sign_count)
    MySignAwardData:setToday_sign(data.today_sign)
    MyUserData:setHuaFei(data.coupons)
    MyUserData:setMoney(data.money, true)
    local gifarr = data.gifarr
    local count = MySignAwardData:count()
    for i = 1, #gifarr do
        for j = 1, count do
            local signInfo = MySignAwardData:get(i)
            if gifarr[i].times == signInfo:getTimes() then
                signInfo:setTips(gifarr[i].tips)
                signInfo:setTimes(gifarr[i].times)
                signInfo:setImg(gifarr[i].img)
                signInfo:setTitle(gifarr[i].title)
                signInfo:setDesc(gifarr[i].desc);
            end
        end
    end
end

function SignAwardPopu:refreshBqSignData( data )
    -- body
    MySignAwardData:setSign_count(data.sign_count)
    MySignAwardData:setToday_sign(data.today_sign)
    MySignAwardData:setBqk_count(data.bqk_count)
    MySignAwardData:setLq_count(data.lq_count)
    MyUserData:setHuaFei(data.coupons)
    MyUserData:setMoney(data.money, true)

    MyGoodsData:setGoodsNumById(MyGoodsData.TypeBqCard, data.bqk_count)

    self:updateBQSignData()
    
    local gifarr = data.gifarr
    local count = MySignAwardData:count()
    for i = 1, #gifarr do
        for j = 1, count do
            local signInfo = MySignAwardData:get(i)
            if gifarr[i].times == signInfo:getTimes() then
                signInfo:setTips(gifarr[i].tips)
                signInfo:setTimes(gifarr[i].times)
            end
        end
    end
end

function SignAwardPopu:updateBQSignData()
    -- body
    self.mBqkCount = MyGoodsData:getGoodsNumById(MyGoodsData.TypeBqCard) or MySignAwardData:getBqk_count()
    self.mLqCount = MySignAwardData:getLq_count()
    self:findChildByName("text_totalAddSignCard"):setText(self.mBqkCount)
    self:findChildByName("text_lqTime"):setText(self.mLqCount)

    if self.mLqCount <= 0 then
        self:findChildByName("btn_addSignAward"):setIsGray(true)
    end
end

function SignAwardPopu:onServergbBroadcastGoodsData()
    -- body
    self.mBqkCount = MyGoodsData:getGoodsNumById(MyGoodsData.TypeBqCard) or MySignAwardData:getBqk_count()
    self.mLqCount = MySignAwardData:getLq_count()
    self:findChildByName("text_totalAddSignCard"):setText(self.mBqkCount)
    self:findChildByName("text_lqTime"):setText(self.mLqCount)

    if self.mLqCount <= 0 then
        self:findChildByName("btn_addSignAward"):setIsGray(true)
    end
end

function SignAwardPopu:onSignGetAwardResponse(data)
    if 1 ~= data.status or not data.data then
        return
    end
    data = data.data
    local status = data.status
    if 1 == status then
        AlarmTip.play(data.msg or "请求成功")
        self:refreshSignData(data)
    else
        AlarmTip.play(data.msg or "请求失败")
    end
end

function SignAwardPopu:onSignBQGetAwardResponse( data )
    -- body
    if 1 ~= data.status or not data.data then
        return
    end
    data = data.data
    local status = data.status
    if 1 == status then
        AlarmTip.play(data.msg or "请求成功")
        self:refreshBqSignData(data)
    else
        AlarmTip.play(data.msg or "请求失败")
    end
    
end

function SignAwardPopu:onSignGetGiftAwardResponse(data)
    if 1 ~= data.status or not data.data then
        return
    end
    data = data.data
    local status = data.status
    if 1 == status then
        AlarmTip.play(data.msg or "请求成功")
        self:refreshSignData(data)
    else
        AlarmTip.play(data.msg or "请求失败")
    end
end

function SignAwardPopu:onExchangeGoodsResponse(data)
    printInfo("ShopPopu:onExchangeGoodsResponse")
    if not data or 1 ~= data.status or not data.data then
        return
    end

    self.mBqkCount = MyGoodsData:getGoodsNumById(MyGoodsData.TypeBqCard)
    MySignAwardData:setBqk_count(self.mBqkCount)

    self:updateBQSignData()


    -- data = data.data
    -- if 1 == data.status then
    --     local money = MyUserData:getMoney()
    --     local huaFei = MyUserData:getHuaFei()

    --     money = money - (data.money or 0)
    --     huaFei = huaFei - (data.coupons or 0)
    --     MyUserData:setMoney(money)
    --     MyUserData:setHuaFei(huaFei)
        
    --     AlarmTip.play(data.msg or "")
    -- else
    --     AlarmTip.play(data.msg or "")
    -- end
end

SignAwardPopu.s_severCmdEventFuncMap = {
    [Command.SIGN_GETGIFTAWARD_PHP_REQUEST]    = SignAwardPopu.onSignGetGiftAwardResponse,
    [Command.SIGN_GETAWARD_PHP_REQUEST] = SignAwardPopu.onSignGetAwardResponse,
    [Command.SIGN_BQ_GETAWARD_PHP_REQUEST] = SignAwardPopu.onSignBQGetAwardResponse,
    [Command.EXCHANGE_GOODS_REQUEST]                = SignAwardPopu.onExchangeGoodsResponse,
    [Command.SERVERGB_BROADCAST_GOODSDATA]      = SignAwardPopu.onServergbBroadcastGoodsData,
}


return SignAwardPopu;