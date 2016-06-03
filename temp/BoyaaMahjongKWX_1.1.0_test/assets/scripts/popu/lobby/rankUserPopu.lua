local RankUserPopu = class(require("popu.gameWindow"))

function RankUserPopu:initView(data)
	-- local rank = setProxy(new(require("data.rank")));
	-- rank:setId(data:getId());
	-- rank:setLevel(data:getLevel());
	-- rank:setNick(data:getNick());
	-- rank:setSimg(data:getSimg());
	-- rank:setBimg(data:getBimg());
	-- rank:setRank(data:getRank());
	-- rank:setWinstr(data:getWinstr());
	-- rank:setPlaystr(data:getPlaystr());
	-- rank:setMoney(data:getMoney());
	-- rank:setTitle(data:getTitle());
	-- rank:setWinpro(data:getWinpro());
	-- rank:setSex(data:getSex());
	local nickStr = data:getNick()
	nickStr = ToolKit.isAllAscci(nickStr) and ToolKit.subStr(nickStr, 12) or ToolKit.subStr(nickStr, 18)
	self:findChildByName("text_nick"):setText(nickStr);
	self:findChildByName("text_id"):setText(data:getId());
	self:findChildByName("text_lv"):setText(data:getLevel());
	local winTimes = tonumber(data:getWintimes() or 0)
	local loseTimes = tonumber(data:getLosetimes() or 0)
	local drawTimes = tonumber(data:getDrawtimes() or 0)
	local times = winTimes + loseTimes + drawTimes
	local rate = times > 0 and (winTimes / times) or 0
	rate = string.format("%.2f", rate * 100).."%"
	self:findChildByName("text_win_rate"):setText(rate);
	self:findChildByName("text_coin"):setText(ToolKit.skipMoney(data:getMoney())..'金币');
	local platStr = string.format("%s胜 %s平 %s负", data:getWintimes(), data:getDrawtimes(), data:getLosetimes())
	self:findChildByName("text_score"):setText(platStr);
	self:findChildByName("img_sex"):setFile(data:getSex() == 0 and "kwx_common/img_man.png" or "kwx_common/img_woman.png");

	local headImg = self:findChildByName("img_portrait")
	local width, height = headImg:getSize();

	local headImage = new(Mask, "ui/blank.png", "kwx_uesrInfo/mask_head.png");
	headImage:setSize(width - 13, height - 12)
	headImage:addTo(headImg)
	headImage:setAlign(kAlignCenter)

	local bigHead 	= false;
	-- 为头像绑定数据源
	UIEx.bind(self, data, "headName", function(value)
		if not bigHead or (bigHead and type(value) ~= 'table') then
			headImage:setFile(value);
		end
		data:checkHeadAndDownload();
	end)
	--设置小头像
	data:setHeadUrl(data:getSimg());
	--设置大头像
	bigHead = true;
	data:setHeadUrl(data:getBimg());
	data:setSex(data:getSex());

end

return RankUserPopu