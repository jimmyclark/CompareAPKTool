local FeedbackFunc = class()

function FeedbackFunc:ctor(rootNode)
	ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")
	--注册HTTP回调
    GameSetting:setIsSecondScene(true)

	EventDispatcher.getInstance():register(HttpModule.s_event,self,self.onHttpRequestsCallBack);
	EventDispatcher.getInstance():register(Event.Call, self, self.onNativeCallBack);
	self.mServiceList={};
	self.rootNode = rootNode
	self:initView()
end

function FeedbackFunc:dtor()
	--注销HTTP回调
	EventDispatcher.getInstance():unregister(HttpModule.s_event,self,self.onHttpRequestsCallBack);
	EventDispatcher.getInstance():unregister(Event.Call, self, self.onNativeCallBack);
end

function FeedbackFunc:initView(data)
	self.rootNode:findChildByName("btn_upload"):setOnClick(self, self.onClickSendBtn);

	self.rootNode:findChildByName("btn_uploadPic"):setOnClick(self, function ( self )
		self.m_uploadFeedbackFile = "";
		NativeEvent.getInstance():pickPhoto('feedback');
	end);

	--初始化输入
	self.mEtQuestion = self.rootNode:findChildByName("editview_feedback");
	-- self.mEtTel = self.rootNode:findChildByName("et_tel_no");

	self.mEtQuestion:setHintText("点击输入内容(最多200个字符)", 0x96, 0x96, 0x96);
	-- self.mEtTel:setHintText("输入您的联系方式(选填)", 0x96, 0x96, 0x96);

	-- self.mEtTel:setOnTextChange(self, function ( self )
	-- 	self.mEtTel:setText(string.sub(self.mEtTel:getText(), 1, 200));
	-- end);

	-- self.mEtTel:setOnTextChange(self, function ( self )
	-- 	self.mEtTel:setText(string.sub(self.mEtTel:getText(), 1, 11));
	-- end);

	local param_post = {
							appid 	 = FEEDBACK_APPID,
    						ftype 	 = FEEDBACK_FTYPE,
    						game 	 = FEEDBACK_GAME
						};

	HttpModule.getInstance():execute(HttpModule.s_cmds.GetFeedbackList, param_post, false, true);

	-- self.mTextTip = self.rootNode:findChildByName("text_tips")
	-- self.mLoading = self.rootNode:findChildByName("img_loading");
	-- self.mLoading:addPropRotate(1, kAnimRepeat, 1000, 0, -360, 0, kCenterDrawing);


	--上传图片
	self.m_uploadFeedbackImg = new(Mask, "kwx_uesrInfo/mask_head.png", "kwx_uesrInfo/mask_head.png");--feedback/photo.png
	self.rootNode:findChildByName("btn_uploadPic"):addChild(self.m_uploadFeedbackImg);
	local w, h = self.rootNode:findChildByName("btn_uploadPic"):getSize()
	self.m_uploadFeedbackImg:setSize(w, h)
	self.m_uploadFeedbackImg:setVisible(false);
	self.m_uploadFeedbackFile = "";
end

----------------------------------------------------------------------------------
--ui action 
----------------------------------------------------------------------------------
function FeedbackFunc:onClickSendBtn()
	local question 	= self.mEtQuestion:getText();
	-- local tel 		= self.mEtTel:getText();

	local len = string.len(question);

	if len <= 0 then
		AlarmTip.play("反馈信息不能为空哦");
		return ;
	end

	if len > 200 then
		AlarmTip.play("反馈信息不超过200个字符");
		return ;
	end

	self:sendFeedbackMessage(question, tel);
end
----------------------------------------------------------------------------------
--ui update
----------------------------------------------------------------------------------
function FeedbackFunc:updateFeedbackList()
	-- body
	local feedbackScv = self.rootNode:findChildByName("scrollview_feedback");
	--设置滚动条
	feedbackScv:setScrollBarWidth(8);
	feedbackScv:removeAllChildren();
	
	local listViewInfoW, listViewInfoH = feedbackScv:getSize();

	local x = 0;
	local y = 0;

	for i = #self.mServiceList, 1, -1 do

		local service = self.mServiceList[i];

		if  service.question then 
			if string.len(service.question) > 0 then
				local n = new(require("popu.lobby.item.feedbackItem"), listViewInfoW, srcollViewInfoH, service, self, self.updateFeedbackScrollView, self, self.sendFeedbackSolve, self, self.sendFeedbackVote);
				n:setPos(x, y);
				feedbackScv:addChild(n);
				local w, h = n:getSize();
				y = y + h + 10;
			end
		end
	end
end

function FeedbackFunc:updateFeedbackScrollView()
	-- body
	local feedbackScv = self.rootNode:findChildByName("scrollview_feedback");
	local child = feedbackScv:getChildren();
	feedbackScv.m_nodeH = 0;

	local curx  = 0;
	local cury 	= 0;

	for i = 1, #child do
		child[i]:setPos(curx, cury);
		local x, y = child[i]:getUnalignPos();
		local w, h = child[i]:getSize();

		feedbackScv.m_nodeH = (feedbackScv.m_nodeH > y + h) and feedbackScv.m_nodeH or (y + h);

		cury = cury + h;
	end

	ScrollView.update(feedbackScv);
end

----------------------------------------------------------------------------------
--http send
----------------------------------------------------------------------------------

--发送 反馈消息
function FeedbackFunc:sendFeedbackMessage(question, contact)
	if MyUserData:getId() <= 0 then
		AlarmTip.play("要先登录才能反馈哦");
		return;
	end
	
	if self.mLastQuestion == question then
		AlarmTip.play("您已经反馈过该内容");
		return;
	end

	self.mLastQuestion = question;
	
	question = GameString.convert2UTF8(question);
	
	local param_post = {
							appid 	 = FEEDBACK_APPID,
    						ftype 	 = FEEDBACK_FTYPE,
    						game 	 = FEEDBACK_GAME,
    						title 	 = "feedback content",
    						fwords 	 = question,
    						fcontact = contact
						};

	HttpModule.getInstance():execute(HttpModule.s_cmds.SendFeedback, param_post, false, true);

end

--反馈的机型列表
function FeedbackFunc:getFcontact()
	-- local tempFeedList = CreatingViewUsingData.helpView.feedBack.feedList;
	-- local api = PlatformFactory.curPlatform:getPlatformAPI();
	-- local loginType = PlatformFactory.curPlatform:getCurrentUserType();
	-- local fcontact = kNullStringStr;
	-- fcontact = fcontact .. tempFeedList.loginType .. (loginType or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.model_name .. (GameConstant.model_name or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.macAddress .. (GameConstant.macAddress or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.version .. (GameConstant.Version or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.device;
	-- fcontact = fcontact .. tempFeedList.net .. (GameConstant.net or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.ip .. (getPhoneIP() or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.isSdCard .. (GameConstant.isSdCard or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.platformType .. (GameConstant.platformType or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.api .. (GameConstant.api or kNullStringStr);
	-- fcontact = fcontact .. tempFeedList.endingType;
	-- return fcontact;
end

--发送反馈图片
function FeedbackFunc:sendFeedbackImg(fileName, fid)

	if fileName == "" then
		return ;
	end

	local param_post = {
							param = {
								appid 	 = FEEDBACK_APPID,
	    						ftype 	 = FEEDBACK_IMG_FTYPE,
	    						game 	 = FEEDBACK_GAME,
	    						title 	 = "feedback content",
	    						fid 	 = fid,
	    						pfile 	 = fileName,
							},
							method 	 = 'Feedback.mSendFeedBackPicture',
						};
	
	NativeEvent.getInstance():uploadFeedbackImage('http://feedback.kx88.net/api/api.php', fileName, param_post);					
end
--是否 解决
function FeedbackFunc:sendFeedbackSolve(fid, bSolve )
	--发送请求

	local param_post = {
							appid 	 = FEEDBACK_APPID,
    						ftype 	 = FEEDBACK_FTYPE,
    						game 	 = FEEDBACK_GAME,
    						title 	 = "feedback content",
    						fid 	 = fid;
    						solved 	 = bSolve and "1" or "0"; 
						};

	HttpModule.getInstance():execute(HttpModule.s_cmds.SolveFeedback, param_post, false, true);
    
end
--满意度
function FeedbackFunc:sendFeedbackVote(fid, vote )
	--发送请求
	local param_post = {
							appid 	 = FEEDBACK_APPID,
    						ftype 	 = FEEDBACK_FTYPE,
    						game 	 = FEEDBACK_GAME,
    						title 	 = "feedback content",
    						fid 	 = fid;
    						score 	 = vote;
						};

	HttpModule.getInstance():execute(HttpModule.s_cmds.VoteFeedback, param_post, false, true);
    
end
----------------------------------------------------------------------------------
--http callback
----------------------------------------------------------------------------------
function FeedbackFunc:onHttpRequestsCallBack(command, ...)
	printInfo("command" .. command);
	if FeedbackFunc.httpRequestsCallBackFuncMap[command] then
     	FeedbackFunc.httpRequestsCallBackFuncMap[command](self,...)
	end

	printInfo("command end"); 
end 
--发送反馈回调
function FeedbackFunc:sendFeedbackCallBack(isSuccess, data )

	if not isSuccess or not data then
	    return;
	end
	if isSuccess then

		self.mFid = GetNumFromJsonTable(data.ret, "fid", 0);
		if self.mFid == 0 then
			self.mLastQuestion = "";
			AlarmTip.play("网络异常，请重新发送反馈。");
			return;
		end
		--如果有图片开始上传图片
		self:sendFeedbackImg(self.m_uploadFeedbackFile, self.mFid);
		
		AlarmTip.play("反馈成功，感谢您对我们工作的支持。");
		self.mEtQuestion:setText("");
		-- self.mEtTel:setText("");
		self.mEtQuestion:setHintText("点击输入内容(最多200个字符)", 0x96, 0x96, 0x96);
		-- self.mEtTel:setHintText("输入您的联系方式(选填)", 0x96, 0x96, 0x96);

		local service = {};
		service.question = self.mLastQuestion;
		self.mServiceList[#self.mServiceList + 1] = service;

		--更新反馈列表
		self:updateFeedbackList();

		self.m_uploadFeedbackFile = "";
		self.m_uploadFeedbackImg:setFile("feedback/photo_mask.png");
		self.m_uploadFeedbackImg:setVisible(false);
	end
end

--请求反馈列表回调
function FeedbackFunc:requsetFeedbackListCallBack (isSuccess, data )
	
	if self.mLoading then
		self.mLoading:setVisible(false);
		-- self.mTextTip:setVisible(false);
	end

	if not isSuccess or not data then
	    return;
	end

	if isSuccess then
		local feedbackCount = tonumber(#data.ret);
		if feedbackCount > 0 then
			for k, v in pairs(data.ret) do
				local service = {};
				service.id 		 = GetStrFromJsonTable(v, "id", "");
				service.question = GetStrFromJsonTable(v, "msgtitle", "");
				service.answer	 = GetStrFromJsonTable(v, "rptitle", "");
				service.votescore= GetStrFromJsonTable(v, "votescore", "");
				service.readed	 = GetStrFromJsonTable(v, "readed", "");
				self.mServiceList[#self.mServiceList + 1] = service;
			end

			self:updateFeedbackList();
		else
			-- self.mTextTip:setVisible(true);
		end
	end
end

function FeedbackFunc:SolveFeedbackCallBack(isSuccess, data )
	
end

function FeedbackFunc:VoteFeedbackCallBack(isSuccess, data )

end

--native callback
function FeedbackFunc:onNativeCallBack(key, result)
	printInfo("FeedbackFunc:onNativeCallBack"..key);
	if key == kPickPhoto then
		if key and result then
			printInfo("FeedbackFunc:onNativeCallBack11"..result.name:get_value());
			self.m_uploadFeedbackImg:setFile(result.name:get_value());
			self.m_uploadFeedbackImg:setVisible(true);
			--upload image 
			self.m_uploadFeedbackFile = result.name:get_value();
		else
			AlarmTip.play("保存图片失败");
		end
	end
end

--回调函数映射表
FeedbackFunc.httpRequestsCallBackFuncMap = {
	[HttpModule.s_cmds.GetFeedbackList] = FeedbackFunc.requsetFeedbackListCallBack,
	[HttpModule.s_cmds.SendFeedback] 	= FeedbackFunc.sendFeedbackCallBack,
	[HttpModule.s_cmds.SolveFeedback] 	= FeedbackFunc.SolveFeedbackCallBack,
	[HttpModule.s_cmds.VoteFeedback] 	= FeedbackFunc.VoteFeedbackCallBack,
}

return FeedbackFunc