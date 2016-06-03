local FeedbackItem = class(Node)

function FeedbackItem:ctor(width, height, service, obj, updateFunc, obj, solveFunc, obj, voteFunc)
	
    self.service     = service;
    self.obj         = obj;
    self.updateFunc  = updateFunc;

    self.solveObj    = obj;
    self.solveFunc   = solveFunc;

    self.voteObj     = obj;
    self.voteFunc    = voteFunc;

    self.voteH       = 0;
    self.animHeight  = 0;

    local x, y, w, h = 0, 5, 0, 0;

    if service.question and string.len(service.question) > 0 then
        local node = self:createDist(width,"您的反馈：",255, 244,231 ,service.question, 0xFF, 0xFF, 0xFF);
        self:addChild(node);
        node:setPos(x, y);
        local _w, _h = node:getSize();
        h = h + _h;
        y = y + _h;
    end
    -- service.answer = "你真的是宛洁吗？"
    if service.answer and string.len(service.answer) > 0 then
        local node = self:createDist(width,"客服回复：", 255, 198, 0, service.answer, 0xFF, 0xFF, 0xFF);
        self:addChild(node);
        node:setPos(x, y);
        local _w, _h = node:getSize();
        h = h + _h;
        y = y + _h;

        --创建打分界面

        -- --尚未解决
        -- --沿未打分
        -- local notReaded = service.readed and tonumber(service.readed) == 0;
        -- local notVote   = service.votescore and tonumber(service.votescore) == 0;
        -- if notReaded or notVote then

        --     y = y + 10;
        --     h = h + 10;
        --     local evaluateView = SceneLoader.load(helpEvaluate);
        --     local evaluateW, evaluateH = evaluateView:getSize();
        --     evaluateView:setPos(x, y);
        --     h = h + evaluateH;
        --     y = y + evaluateH;
        --     self:addChild(evaluateView);

        --     self.voteH = 10 + evaluateH;

        --     self.closedView = evaluateView:getChildByName("view_closed");
        --     self.voteView   = evaluateView:getChildByName("view_vote");

        --     --初始化 解决
        --     local btnSolve      = self.closedView:getChildByName("btn_solve");
        --     local btnNotSolve   = self.closedView:getChildByName("btn_notsolve");

        --     btnSolve:setOnClick(self,function()
        --         self:onClickSolve(self.service.id, true);
        --     end);

        --     btnNotSolve:setOnClick(self,function()
        --         self:onClickSolve(self.service.id, false);      
        --     end);

        --     --初始化 打分
        --     local voteValue = {5, 3, 2}

        --     local btnVote = {};
        --     btnVote[1]   = self.voteView:getChildByName("btn_verygood");
        --     btnVote[2]   = self.voteView:getChildByName("btn_soso");
        --     btnVote[3]   = self.voteView:getChildByName("btn_dissatisfied");

        --     for i = 1, #btnVote do
        --         btnVote[i]:setOnClick(self,function()
        --         self:onClickVote(self.service.id, voteValue[i]);
        --         end);
        --     end
            
        --     if notReaded then
        --         self.closedView:setVisible(true);
        --     elseif notVote then
        --         self.voteView:setVisible(true);
        --     end
        -- end
    end
    self.lastImgLine = new(Image, "kwx_erJiCommon/img_split.png", nil, nil, 1, 1, 1, 1);

    self.lastImgLine:setSize(width, 2);
    self.lastImgLine:setPos(x, y+10);
    self:addChild(self.lastImgLine);

    y = y + 10;
    h = h + 10;

    self:setSize(width, h + 5); -- 比实际大小多出10个逻辑像素

end

function FeedbackItem:dtor()
end

function FeedbackItem:onClickSolve(id, isSolve)
    -- body

    self.service.readed = 1;

    if self.solveFunc then
         self.solveFunc(self.solveObj, id, isSolve);
    end

    self.closedView:setVisible(false);

     local notVote   = self.service.votescore and tonumber(self.service.votescore) == 0;

    if notVote then
        self.voteView:setVisible(true);
    else
        self:createCloseAnim();
    end
end

function FeedbackItem:onClickVote(id, vote)
    -- body
    self.service.votescore = vote;
    if self.voteFunc then
         self.voteFunc(self.voteObj, id, vote);
    end
    self.voteView:setVisible(false);
    self:createCloseAnim();
end
function FeedbackItem:invalidItem(deltaH)
    if self.updateFunc then
        local w, h = self:getSize();
        h = h - deltaH;
        self:setSize(w, h);

        local x, y = self.lastImgLine:getPos();
        self.lastImgLine:setPos(x, y - deltaH);
        self.updateFunc(self.obj);
    end
end

function FeedbackItem:createCloseAnim()
    -- body
    local step  = 20;
    
    self.closeAnim = self:addPropTransparency(1, kAnimRepeat, 100, 0, 1, 1);
    self.closeAnim:setDebugName("FeedBackItem || anim");
    self.closeAnim:setEvent(self, function ( self )
        -- body
        self.animHeight = self.animHeight + step;

        if self.animHeight >= self.voteH then
            self:removeProp(1);
            self:invalidItem(self.animHeight - self.voteH);
            return;
        end

        self:invalidItem(step);

    end);

end

function FeedbackItem:createDist(width, name, r, g, b, desc, dr, dg, db)
    -- body

    local node = new(Node);

    local nameText = new(Text, name, 0, 0, kAlignTopLeft, "", 30, r, g, b);
    nameText:setSize(nameText.m_res.m_width, nameText.m_res.m_height);
    node:addChild(nameText);

    local tvDesc = new(TextView,desc, width - nameText.m_res.m_width, 0, kAlignTopLeft, "", 30, dr, dg, db);
    tvDesc:setPos(nameText.m_res.m_width,0);
    tvDesc:setSize(tvDesc.m_drawing:getSize());
    node:addChild(tvDesc);

    local dW, dH = tvDesc:getSize();
    node:setSize(width, math.max(nameText.m_res.m_height,dH));

    return node;

end

return FeedbackItem