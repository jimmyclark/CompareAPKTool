require("ui/ex/ScrollViewEx")
local HelpPopu = class(require("popu.gameWindow"))

local TAG_NONE      = 0
local TAG_FEEDBACK  = 1
-- local TAG_QESTION   = 2
local TAG_PLAYTYPE  = 2
local TAG_FANSHU    = 3

function HelpPopu:ctor()
    GameSetting:setIsSecondScene(true)
    self.mServiceList = {}
end

function HelpPopu:dtor()
    printInfo("HelpPopu dtor")
    delete(self.m_feedbackFunc)
end

function HelpPopu:initView(data, tag)
    
    local backBtn = self:findChildByName("btn_back");
    backBtn:setOnClick(self, function ( self )
        -- body
        self:dismiss();
    end);

    --初始化各种帮助列表
    self.mScrollView = {};

    ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")

    local viewContent        = self:findChildByName("view_scrollview"):findChildByName("view_content");
    local width, height = viewContent:getSize();

    local tagTable = {
        [TAG_FEEDBACK] = {
            "btn_feedback",
            "btn_feedbackClicked",
        },
        -- [TAG_QESTION] = {
        --     "btn_qestion",
        --     "btn_qestionClicked",
        -- },
        [TAG_PLAYTYPE] = {
            "btn_playtype",
            "btn_playtypeClicked",
        },
        [TAG_FANSHU] = {
            "btn_fanshu",
            "btn_fanshuClicked",
        },
    }
    self.btnTagTable = {}
    self.btnTagTable.normal = {}
    self.btnTagTable.clicked = {}
    for i = TAG_FEEDBACK, TAG_FANSHU do
        table.insert(self.btnTagTable.normal, self:findChildByName(tagTable[i][1]))
        table.insert(self.btnTagTable.clicked, self:findChildByName(tagTable[i][2]))
        self.btnTagTable.normal[i]:setOnClick(self , function(self)
            self:onclickTag(i)
        end)
    end

    self.viewTagTable = {}

    self.curTag = TAG_NONE
    self:onclickTag(tag or TAG_FEEDBACK)
end

function HelpPopu:onclickTag(tag)
    if self.curTag == tag then
        return
    end
    self.curTag = tag
    self:showTagStatus(tag)
    if TAG_FEEDBACK == tag then
        self:showTagFeedbackView()
    elseif TAG_QESTION == tag then

    elseif TAG_PLAYTYPE == tag then
        self:showTagPlaytypeView()
    elseif TAG_FANSHU == tag then
        self:showTagFanshuView()
    end
end

function HelpPopu:showTagStatus(tag)
    for i = TAG_FEEDBACK, TAG_FANSHU do
        if tag == i then
            self.btnTagTable.normal[i]:hide()
            self.btnTagTable.clicked[i]:show()
        else
            self.btnTagTable.normal[i]:show()
            self.btnTagTable.clicked[i]:hide()
            if self.viewTagTable[i] then
                self.viewTagTable[i]:hide()
            end
        end
    end
end

function HelpPopu:showTagFeedbackView()
    if self.viewTagTable[TAG_FEEDBACK] then
        self.viewTagTable[TAG_FEEDBACK]:show()
        return
    end
    local tagFeedbackView = self:findChildByName("view_feedback")
    self.viewTagTable[TAG_FEEDBACK] = tagFeedbackView
    self.m_feedbackFunc = new(require("popu.lobby.feedbackFunc"), tagFeedbackView)
    self.viewTagTable[TAG_FEEDBACK]:show()
end

function HelpPopu:showTagQestionView()
    if self.viewTagTable[TAG_QESTION] then 
        self.viewTagTable[TAG_QESTION]:show()
        return
    end
    local tagQestionView = self:findChildByName("view_qestion")
    self.viewTagTable[TAG_QESTION] = tagFeedbackView
    
end

function HelpPopu:showTagPlaytypeView()
    if self.viewTagTable[TAG_PLAYTYPE] then
        self.viewTagTable[TAG_PLAYTYPE]:show()
        return
    end
    local tagPlaytypeView = self:findChildByName("view_playtype")
    self.viewTagTable[TAG_PLAYTYPE] = tagPlaytypeView
    local scrollerView = self:findChildByName("scrollview_playtype")
    local scrollerViewW, scrollerViewH = scrollerView:getSize()
    local playtypeData = self:loadPlaytypeData()
    local jianGeH = 15
    local curX, curY = 0, 0
    for i = 1, #playtypeData do
        local x, y = curX, jianGeH
        local playtypeNode = new(Node)
        playtypeNode:setPos(x, curY)
        local nodeW , nodeH = 0, y
        local params = {}
        params.text = playtypeData[i].title
        params.size = 30
        local text_title = UIFactory.createText(params)
                                :addTo(playtypeNode)
                                :pos(x, y)

        local w, h = text_title:getSize()
        if w > nodeW then nodeW = w end
        y = y + h + jianGeH
        local item = playtypeData[i].item
        for i = 1, #item do
            if item[i].title then
                params.text = item[i].title
                params.size = 30
                params.width = nil
                params.height = nil
                params.color = nil
                local text_title = UIFactory.createText(params)
                                    :addTo(playtypeNode)
                                    :pos(x, y)

                y = y + h + jianGeH
            end
            params.text = item[i].item or item[i]

            local color = {}
            color.r = 0xFF
            color.g = 0xF0
            color.b = 0x22
            params.color = color
            params.size = 26
            params.width = scrollerViewW - 2 * curX
            params.height = 50
            local text_temp = UIFactory.createTextView(params)
                                :addTo(playtypeNode)
                                :pos(x, y)
            text_temp:setSize(text_temp.m_drawing:getSize()) 
            local w, h = text_temp:getSize()
            if w > nodeW then nodeW = w end
            y = y + h + jianGeH
        end
        nodeH = y-- nodeH - jianGeH
        curY = curY + y
        playtypeNode:setSize(nodeW, nodeH)
        scrollerView:addChild(playtypeNode)
        -- playtypeNode:packDrawing(true)
    end
    self.viewTagTable[TAG_PLAYTYPE]:show()
end

function HelpPopu:loadPlaytypeData()
    require("popu.lobby.help_gd_string");
    return GD_RULE_TABLE
end

function HelpPopu:showTagFanshuView()
    if self.viewTagTable[TAG_FANSHU] then
        self.viewTagTable[TAG_FANSHU]:show()
        return
    end
    local tagFanshuView = self:findChildByName("view_fanshu")
    self.viewTagTable[TAG_FANSHU] = tagFanshuView
    local scrollerView = self:findChildByName("scrollview_fanshu")
    local scrollerViewW, scrollerViewH = scrollerView:getSize()
    local fanshuData = self:loadFanshuData()
    local jianGeH = 15
    local curX, curY = 0, 0
    dump(fanshuData)
    for i = 1, #fanshuData do
        local x, y = curX, jianGeH
        local fanshuNode = new(Node)
        fanshuNode:setPos(x, curY)
        local nodeW , nodeH = 0, y
        local params = {}
        params.text = fanshuData[i].title
        params.size = 30
        local text_title = UIFactory.createText(params)
                                :addTo(fanshuNode)
                                :pos(x, y)

        local w, h = text_title:getSize()
        if w > nodeW then nodeW = w end
        y = y + h + jianGeH
        local item = fanshuData[i].item
        for j = 1, #item do
            if item[j].title then
                params.text = item[j].title
                params.size = 30
                params.width = nil
                params.height = nil
                params.color = nil
                local text_title = UIFactory.createText(params)
                                    :addTo(fanshuNode)
                                    :pos(x, y)

                y = y + h + jianGeH
            end
            local color = {}
            color.r = 0xFF
            color.g = 0xF0
            color.b = 0x22
            params.color = color
            params.size = 26
            params.width = scrollerViewW - 2 * curX
            params.height = 50
            if item[j].item then
                local tempItem = item[j].item
                for k = 1, #tempItem do
                    local cards = nil
                    if tempItem[k].desc then
                        params.text = tempItem[k].desc
                        cards = tempItem[k].cards
                    else
                        params.text = tempItem[k]
                    end
                    printInfo("params.text : %s",params.text)
                    local text_temp = UIFactory.createTextView(params)
                                    :addTo(fanshuNode)
                                    :pos(x, y)
                    text_temp:setSize(text_temp.m_drawing:getSize()) 
                    local w, h = text_temp:getSize()
                    if w > nodeW then nodeW = w end
                    y = y + h + jianGeH

                    if cards and #cards > 0 then
                        local cardsNode = self:createCards(cards)
                        fanshuNode:addChild(cardsNode)
                        local w, h = cardsNode:getSize()
                        cardsNode:setPos(x + 20 ,y)
                        y = y + h + jianGeH
                    end
                end
            else
                params.text = item[j]
                printInfo("params.text : %s",params.text)
                local text_temp = UIFactory.createTextView(params)
                                    :addTo(fanshuNode)
                                    :pos(x, y)
                text_temp:setSize(text_temp.m_drawing:getSize()) 
                local w, h = text_temp:getSize()
                if w > nodeW then nodeW = w end
                y = y + h + jianGeH
            end
        end
        nodeH = y-- nodeH - jianGeH
        curY = curY + y
        fanshuNode:setSize(nodeW, nodeH)
        scrollerView:addChild(fanshuNode)
    end
    self.viewTagTable[TAG_FANSHU]:show()
end

function HelpPopu:loadFanshuData()
    require("popu.lobby.help_gd_string");
    return GD_FAN_TABLE
end


function HelpPopu:createCards(cards)
    -- body
    --创建牌
    if not cards or #cards < 1 then
        return nil;
    end

    local Card                  = require("room/entity/card");
    local CardPanelCoord        = require("room/coord/cardPanelCoord");
    local extraCardBgFile       = CardPanelCoord.extraCardBg[SEAT_1];
    local extraCardImgFileReg   = CardPanelCoord.extraCardImage[SEAT_1];

    local node = new(Node);

    local cardWidth, cardHeight = 0, 0;
    local cardx, cardy          = 0, 0;
    local cardMaxHeight         = 0;

    local has4cards = false;

    for cardIndex = 1, #cards do
        local cardValue = cards[cardIndex];
        if cards[cardIndex] == cardValue and cards[cardIndex + 1] == cardValue and
           cards[cardIndex + 2] == cardValue and cards[cardIndex + 3] == cardValue then
           has4cards = true;
           break;
        end
    end


    local childY = 10

    for cardIndex = 1, #cards do

        local cardValue = cards[cardIndex];

        -- if cards[cardIndex] == cardValue and cards[cardIndex - 1] == cardValue and
        --    cards[cardIndex - 2] == cardValue and cards[cardIndex - 3] == cardValue then

        --     card = new(Card, cardValue, extraCardBgFile, extraCardImgFileReg)
        --         :addTo(node)
        --         :align(kAlignTopLeft)

        --     cardWidth, cardHeight = card:getSize();

        --     card:setPos(cardx - (cardWidth - 5) * 2,  childY - 22);
        --     card:setBgAlign(kAlignTopLeft)
        --     card:scaleCardTo(0.8, 0.8)
        --     card:shiftCardMove(0, -15)

        --     cardMaxHeight = math.max(cardMaxHeight, cardHeight + childY );

        -- else
            card = new(Card, cardValue, extraCardBgFile, extraCardImgFileReg)
                :addTo(node)
                :align(kAlignTopLeft)

            cardWidth, cardHeight = card:getSize();

            card:setPos(cardx, childY);
            card:setBgAlign(kAlignTopLeft)
            card:scaleCardTo(0.8, 0.8)
            card:shiftCardMove(0, -15)

            cardx = cardx + (cardWidth - 5);
            cardMaxHeight = math.max(cardMaxHeight, cardHeight);
        -- end

    end  
    node:setSize(0, cardMaxHeight);
    return node;
end



function HelpPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return HelpPopu.super.dismiss(self, ...)
end

return HelpPopu