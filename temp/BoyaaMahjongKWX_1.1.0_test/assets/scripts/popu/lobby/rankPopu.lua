local rankDianFengItemLayout = require(ViewPath .. "rankDianFengItemLayout")
local rankZhanShenItemLayout = require(ViewPath .. "rankZhanShenItemLayout")
local rankTuHaoItemLayout = require(ViewPath .. "rankTuHaoItemLayout")
local rankSelfDianFengItemLayout = require(ViewPath .. "rankSelfDianFengItemLayout")
local rankSelfZhanShenItemLayout = require(ViewPath .. "rankSelfZhanShenItemLayout")
local rankSelfTuHaoItemLayout = require(ViewPath .. "rankSelfTuHaoItemLayout")
require("ui/ex/ScrollViewEx")

local RankPopu = class(require("popu.gameWindow"))
local printInfo, printError = overridePrint("CommonPhpProcesser")

local RANK_DIANFENG = 1
local RANK_FUHAO 	= 2
local RANK_ZHANSHEN	= 3

function RankPopu:ctor()
    GameSetting:setIsSecondScene(true)
end

function RankPopu:initView(data)
	--返回
	self.mRankData = {};
	self.mRankData[RANK_DIANFENG] 	= new(require("data.rankData"));
	self.mRankData[RANK_FUHAO] 	= new(require("data.rankData"));
	self.mRankData[RANK_ZHANSHEN] 		= new(require("data.rankData"));

	self.mView				= {}
	self.mView[RANK_DIANFENG]	= self:findChildByName("view_dianfeng")
	self.mView[RANK_FUHAO] = self:findChildByName("view_fuhao")
	self.mView[RANK_ZHANSHEN]	= self:findChildByName("view_zhanshen")

	self.mViewShow = {}
	for i = RANK_DIANFENG, RANK_ZHANSHEN do
		self.mViewShow[i] = false
	end

	local backBtn = self:findChildByName("btn_back");
	backBtn:setOnClick(self, function( self )
		self:dismiss();
	end);

	backBtn:enableAnim(false)
	local tagTable = {
        [RANK_DIANFENG] = {
            "btn_dianfeng",
            "btn_dianfengClicked",
        },
        [RANK_FUHAO] = {
            "btn_fuhao",
            "btn_fuhaoClicked",
        },
        [RANK_ZHANSHEN] = {
            "btn_zhanshen",
            "btn_zhanshenClicked",
        },
    }
    self.btnTagTable = {}
    self.btnTagTable.normal = {}
    self.btnTagTable.clicked = {}
    for i = RANK_DIANFENG, RANK_ZHANSHEN do
        table.insert(self.btnTagTable.normal, self:findChildByName(tagTable[i][1]))
        table.insert(self.btnTagTable.clicked, self:findChildByName(tagTable[i][2]))
        self.btnTagTable.normal[i]:setOnClick(self , function(self)
            self:onclickTag(i)
        end)
    end

    self:findChildByName("btn_reaward"):setIsGray(true)

    self:onclickTag(RANK_DIANFENG)
end

function RankPopu:showTagStatus(tag)
    for i = RANK_DIANFENG, RANK_ZHANSHEN do
        if tag == i then
            self.btnTagTable.normal[i]:hide()
            self.btnTagTable.clicked[i]:show()
            self.mView[i]:show()
        else
            self.btnTagTable.normal[i]:show()
            self.btnTagTable.clicked[i]:hide()
            self.mView[i]:hide()
        end
    end
end

function RankPopu:onclickTag(tag)
    self:showTagStatus(tag)
    if RANK_DIANFENG == tag then
        self:showTagDianFengView()
    elseif RANK_FUHAO == tag then
        self:showTagFuHaoView()
    elseif RANK_ZHANSHEN == tag then
        self:showTagZhanShenView()
    end
end

function RankPopu:showTagDianFengView()
	if self.mRankData[RANK_DIANFENG]:count() <= 0 then
		GameSocketMgr:sendMsg(Command.RANK_DIANFENG_PHP_REQUEST, {["type"] = RANK_DIANFENG, ["page"] = 1})
		return
	end
	self:findChildByName("text_nodata"):hide();
	if self.mViewShow[RANK_DIANFENG] then
		return
	end
	self.mViewShow[RANK_DIANFENG] = true
	local scrollView = self.mView[RANK_DIANFENG]:findChildByName("scrollview_dianfeng")
	local sW, sH = scrollView:getSize()
	printInfo("scrollView sW : %s, sH : %s", sW, sH)
	local count = self.mRankData[RANK_DIANFENG]:count()
	for i = 1, count do
		local data = self.mRankData[RANK_DIANFENG]:get(i)
		local item = self:createItem(RANK_DIANFENG, data)
		local iW, iH = item:getSize()
		item:setPos((sW - iW) / 2, iH * (i - 1))
		scrollView:addChild(item)
	end
end

function RankPopu:showTagFuHaoView()
	if self.mRankData[RANK_FUHAO]:count() <= 0 then
		GameSocketMgr:sendMsg(Command.RANK_FUHAO_PHP_REQUEST, {["type"] = RANK_FUHAO, ["page"] = 1})
		return
	end
	self:findChildByName("text_nodata"):hide();
	if self.mViewShow[RANK_FUHAO] then
		return
	end
	self.mViewShow[RANK_FUHAO] = true
	local scrollView = self.mView[RANK_FUHAO]:findChildByName("scrollview_fuhao")
	local sW, sH = scrollView:getSize()
	local count = self.mRankData[RANK_FUHAO]:count()
	local curCount = self.mRankData[RANK_FUHAO]:getCurCount()
	for i = curCount, count do
		local data = self.mRankData[RANK_FUHAO]:get(i)
		local item = self:createItem(RANK_FUHAO, data)
		local iW, iH = item:getSize()
		item:setPos((sW - iW) / 2, iH * (i - 1))
		scrollView:addChild(item)
	end
	scrollView:setOnReachBottom(self, function(self)
		local page = self.mRankData[RANK_FUHAO]:getPage()
		if page < self.mRankData[RANK_FUHAO]:getTotalPage() then
			GameSocketMgr:sendMsg(Command.RANK_FUHAO_PHP_REQUEST, {["type"] = RANK_FUHAO, ["page"] = page + 1})
		end
	end)
	self.mRankData[RANK_FUHAO]:setCurCount(count)
end

function RankPopu:showTagZhanShenView()
	if self.mRankData[RANK_ZHANSHEN]:count() <= 0 then
		GameSocketMgr:sendMsg(Command.RANK_ZHANSHEN_PHP_REQUEST, {["type"] = RANK_ZHANSHEN, ["page"] = 1})
		return
	end
	self:findChildByName("text_nodata"):hide();
	if self.mViewShow[RANK_ZHANSHEN] then
		return
	end
	self.mViewShow[RANK_ZHANSHEN] = true
	local scrollView = self.mView[RANK_ZHANSHEN]:findChildByName("scrollview_zhanshen")
	local sW, sH = scrollView:getSize()
	local count = self.mRankData[RANK_ZHANSHEN]:count()
	local curCount = self.mRankData[RANK_ZHANSHEN]:getCurCount()
	for i = curCount, count do
		local data = self.mRankData[RANK_ZHANSHEN]:get(i)
		local item = self:createItem(RANK_ZHANSHEN, data)
		local iW, iH = item:getSize()
		item:setPos((sW - iW) / 2, iH * (i - 1))
		scrollView:addChild(item)
	end
	scrollView:setOnReachBottom(self, function(self)
		local page = self.mRankData[RANK_ZHANSHEN]:getPage()
		if page < self.mRankData[RANK_ZHANSHEN]:getTotalPage() then
			GameSocketMgr:sendMsg(Command.RANK_ZHANSHEN_PHP_REQUEST, {["type"] = RANK_ZHANSHEN, ["page"] = page + 1})
		end
	end)
	self.mRankData[RANK_ZHANSHEN]:setCurCount(count)
end

function RankPopu:initSelfRank(tag)
	local myselfBg = self.mView[tag]:findChildByName("img_selfBg")
	myselfBg:removeAllChildren()
	local mMyInfo = self.mRankData[tag]:getInfo()
	local item = self:createItem(tag, mMyInfo, true)
	if item then 
		item:setAlign(kAlignCenter)
		myselfBg:addChild(item)
		if RANK_DIANFENG == tag then
			self:findChildByName("btn_reaward"):setIsGray(mMyInfo:getAward() ~= 1)
			self:findChildByName("btn_reaward"):setOnClick(self, function(self)
				GameSocketMgr:sendMsg(Command.RANK_DIANFENG_GET_AWARD_PHP_REQUEST, {})
			end)
		end
	end
end

function RankPopu:setImgPlace(item, rank)
	local img_place = item:findChildByName("img_place")
	item:findChildByName("text_myRank"):hide()
	img_place:show()

	rank = tonumber(rank) or 0
	if rank > 0 and rank <= 3 then
		img_place:setFile(string.format("kwx_rank/img_rank%d.png",rank))
		local oldW, oldH = img_place:getSize()
		img_place:setSize(img_place.m_res.m_width, img_place.m_res.m_height)
		local nowW, nowH = img_place:getSize()
		local ix, iy = img_place:getPos()
		img_place:setPos(ix - (nowW - oldW) / 2, iy)
	elseif rank <= 0 then
		img_place:hide()
		item:findChildByName("text_myRank"):show()
	else
		item:findChildByName("text_rank"):setText(rank)
	end
end

function RankPopu:createItem(tag, data, isMyself, last)
	local item = nil
	if tag == RANK_DIANFENG then
		item = SceneLoader.load(rankDianFengItemLayout)
		item:findChildByName("text_myRank"):setText("未上榜")
		item:findChildByName("text_win"):setText(data:getLevel())
		item:findChildByName("text_lv"):setText(ToolKit.formatThreeNumber(data:getWinMoney()))
	elseif tag == RANK_FUHAO then
		item = SceneLoader.load(rankTuHaoItemLayout)
		item:findChildByName("text_myRank"):setText("未上榜")
		local title = tonumber(data:getTitle())
		local titleFile = "kwx_rank/img_title1.png"
		if title > 0 and title <= 8 then
			titleFile = string.format("kwx_rank/img_title%d.png", title)
		end
		item:findChildByName("img_title"):setFile(titleFile)
		item:findChildByName("text_coin"):setText(ToolKit.formatThreeNumber(data:getMoney()))
	elseif tag == RANK_ZHANSHEN then
		item = SceneLoader.load(rankZhanShenItemLayout)
		item:findChildByName("text_myRank"):setText("未上榜")
		local platStr = string.format("%s胜 %s平 %s负", data:getWintimes(), data:getDrawtimes(), data:getLosetimes())
		item:findChildByName("text_win"):setText(data:getLevel())
		item:findChildByName("text_lv"):setText(platStr)
	end
	if item then
		local nickStr = data:getNick()
		nickStr = ToolKit.isAllAscci(nickStr) and ToolKit.subStr(nickStr, 12) or ToolKit.subStr(nickStr, 18)
		item:findChildByName("text_nick"):setText(nickStr)
		if isMyself or last then
			item:findChildByName("img_split"):hide()
		end
		self:setImgPlace(item, data.rank)
		local headView = item:findChildByName("view_head")

		-- local width, height = headView:getSize()
		local headImage = new(Mask, "ui/blank.png", "kwx_uesrInfo/mask_head.png");
		headImage:addTo(headView)
		headImage:setSize(90, 90)
		headImage:setAlign(kAlignCenter)
		headView:setPickable(true)
		local btn_head = new(Button, "ui/blank.png")
		btn_head:addTo(headView)
		btn_head:setFillParent(true, true)
		btn_head:setOnClick(self, function(self)
			WindowManager:showWindow(WindowTag.RankUserPopu, data);
		end)
		-- headView:setEventTouch(self, function(self, finger_action)
		-- 	if finger_action == kFingerUp then
		-- 		
		-- 	end
		-- end)
		-- 为头像绑定数据源
		UIEx.bind(self, data, "headName", function(value)
			headImage:setFile(value)
			data:checkHeadAndDownload()
		end)
		data:setHeadUrl(data:getBimg())
	end
	return item
end

function RankPopu:initCommonData(rank, data)
	rank:setLevel(data.level or "")
	rank:setId(tonumber(data.mid or 0))
	rank:setNick(data.nick or "")
	rank:setSimg(data.icon or "")
	rank:setBimg(data.big or "")
	rank:setRank(data.rank or "")
	rank:setMoney(data.money or 0)
	rank:setSex(tonumber(data.sex or 0))
	rank:setWintimes(data.wintimes or "")
	rank:setLosetimes(data.losetimes or "")
	rank:setDrawtimes(data.drawtimes or "")
	rank:setTitle(data.title or "")
end

function RankPopu:initData(tag, data )
	-- if true then return end
	local content = data.content or {}
	printInfo("#content : %s", #content)
	if data.info then 
		local mMyInfo = self.mRankData[RANK_DIANFENG]:getInfo()
		self:initCommonData(mMyInfo, data.info)
		mMyInfo:setWinMoney(data.info.winmoney or 0)
		mMyInfo:setAward(tonumber(data.info.award) or 0)
		mMyInfo:setId(MyUserData:getId())
		mMyInfo:setMoney(MyUserData:getMoney())
		mMyInfo:setWintimes(MyUserData:getWintimes())
		mMyInfo:setLosetimes(MyUserData:getLosetimes())
		mMyInfo:setDrawtimes(MyUserData:getDrawtimes())
		mMyInfo:setSimg(MyUserData:getHeadUrl() or "")
		mMyInfo:setBimg(MyUserData:getHeadUrl() or "")
		mMyInfo:setSex(MyUserData:getSex() or 0)
		UIEx.bind(self, MyUserData, "money", function(value)
			mMyInfo:setMoney(value)
		end)
		self:initSelfRank(tag)
	end
	local Rank = require("data.rank")
	for i = 1, #content do
		local rank = setProxy(new(Rank))
		self:initCommonData(rank, content[i])
		rank:setWinMoney(content[i].winmoney or 0)
		self.mRankData[tag]:add(rank)
	end
	self.mRankData[tag]:setPage(data.page or 0)
	self.mRankData[tag]:setTotalPage(data.totalpage or 0)
	if self.mRankData[tag]:count() <= 0 then
		self:findChildByName("text_nodata"):show()
	else
		if RANK_DIANFENG == tag then 
			self:showTagDianFengView()
		elseif RANK_FUHAO == tag then
			self.mViewShow[RANK_FUHAO] = false
			self:showTagFuHaoView()
		elseif RANK_ZHANSHEN == tag then
			self.mViewShow[RANK_ZHANSHEN] = false
			self:showTagZhanShenView()
		end
	end
end

function RankPopu:onDianFengResponse(data)
	printInfo("onDianFengResponse")
	if app:checkResponseOk(data) then
		self:initData(RANK_DIANFENG, data.data)
	end
end

function RankPopu:onZhangShenResponse(data)
	printInfo("onZhangShenResponse")
	if app:checkResponseOk(data) then
		self:initData(RANK_ZHANSHEN, data.data)
	end
end

function RankPopu:onFuHaoResponse(data)
	printInfo("onFuHaoResponse")
	if app:checkResponseOk(data) then
		self:initData(RANK_FUHAO, data.data)
	end
end

function RankPopu:onDianFengGetAwardResponse(data)
	--加金币
	if data.status == 1 then
		MyUserData:addMoney(tonumber(data.data.reward_money or 0), true);
		MyBaseInfoData:setRankAward(0);
	end
	self:findChildByName("btn_reaward"):setIsGray(true)
	AlarmTip.play(data.msg);
end

--[[
	通用的（大厅）协议
]]
RankPopu.s_severCmdEventFuncMap = {
	[Command.RANK_DIANFENG_PHP_REQUEST]				= RankPopu.onDianFengResponse,
	[Command.RANK_ZHANSHEN_PHP_REQUEST]				= RankPopu.onZhangShenResponse,
	[Command.RANK_FUHAO_PHP_REQUEST]				= RankPopu.onFuHaoResponse,
	[Command.RANK_DIANFENG_GET_AWARD_PHP_REQUEST]	= RankPopu.onDianFengGetAwardResponse,
}

function RankPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return RankPopu.super.dismiss(self, ...)
end

return RankPopu