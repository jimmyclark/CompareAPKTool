local noticeItemLayout = require(ViewPath .. "noticeItemLayout")
local NoticePopu = class(require("popu.gameWindow"))

--跳转标识 1 活动 2商城 3任务 4快速开始 5快速充值 6更新弹窗

function NoticePopu:initView(data)
	
	self:findChildByName("btn_close"):setOnClick(self, function ( self )
		-- body
		self:dismiss();
	end);

	self:initNotice();

end

--根据MyNoticeData初始化消息内容
function NoticePopu:initNotice()
	local noticeScollview = self:findChildByName("sc_notice");
	noticeScollview:removeAllChildren();
	local count = MyNoticeData:count();
	local y = 0;
	local w, h = noticeScollview:getSize();
	for i = 1, count do
		local item = self:createItem(MyNoticeData:get(i));
		local itemW, itemH = item:getSize();
		item:setPos((w - itemW) / 2, y);
		noticeScollview:addChild(item);
		y = y + itemH;
	end
end
--创建消息ITEM
function NoticePopu:createItem(notice)
	local item = SceneLoader.load(noticeItemLayout);
	item:findChildByName("text_title"):setText(notice:getStart_time() .." ".. notice:getTitle());

	local noticeText = item:findChildByName("text_notice");
	noticeText:setText(notice:getContent());

	local w, h = noticeText.m_res:getWidth(), noticeText.m_res:getHeight();
	noticeText:setSize(w, h);
	item:findChildByName("view_body"):setSize(w, h);

	local linkText = new(Text, notice:getLink_content(), 0, 0, kAlignLeft, kFontTextUnderLine, 30, 0xFF, 0x5b, 0x29);

	local linkBtn = item:findChildByName("btn_link");
	linkBtn:setOnClick(self, function ( self )
	   -- body
	   self:dismiss();
       --发送消息 
       EventDispatcher.getInstance():dispatch(Event.Message, "NoticeLinkType", notice:getLink_type());

	end);

	linkBtn:addChild(linkText);

	linkBtn:setSize(linkText:getSize());

	local titleW, titleH = item:findChildByName("img_title_bg"):getSize();
	local linkW,  linkH  = linkBtn:getSize();

	local totalH = titleH + h + linkH + 5 + 30; --30 为两间隔之差

	item:setSize(titleW, totalH);

	return item;
	--0xFF1717
end

--HTTP回调
--1.若界面打开时，即可截获NOTICE_PHP_REQUEST的回调
--2.NOTICE_PHP_REQUEST请求一般在登录完成时发生
function NoticePopu:onNoticeResponse(data)
	if data.status == 1 then
		self:initNotice();
	end
end

--[[
	通用的（大厅）协议
]]
NoticePopu.s_severCmdEventFuncMap = {
	[Command.NOTICE_PHP_REQUEST]	= NoticePopu.onNoticeResponse,
}


return NoticePopu