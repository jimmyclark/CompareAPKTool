-- slider.lua
-- Author: Lennon Zhao
-- Date: 2014-05-19
-- Last modification : 2014-05-19
-- Description: Implemented spiner

require("core/constants");
require("core/object");
require("ui/node");
require("ui/image");

Spinner = class(Node);

Spinner.s_defaultBgImage = "ui/spinner_bg_img.png";
Spinner.s_defaultArrowImage = "ui/spinner_arrow.png";
Spinner.s_defaultListImage = "ui/spinner_bg.png";
Spinner.s_defaultChooseImage = "ui/spinner_choose_bg.png";
Spinner.s_defaultNum = 6;
Spinner.s_defaultPerWidth = 254;
Spinner.s_defaultPerHeight = 62;
Spinner.s_defaultBgHeight = 50;
Spinner.s_defaultHeight = Spinner.s_defaultPerHeight * (Spinner.s_defaultNum - 1);
--[[
	data = {
		1 = "text1",
		2 = "text2",
		3 = "text3"
	}
]]

Spinner.ctor = function(self, data, defaultId, width, height)
	self.m_totalOffset = 0;
	self.m_fingerY = 0;
	self.m_defaultId = defaultId;
	self.m_currentId = defaultId;

	printInfo("chenghao defaultId " .. defaultId)
	printInfo("chenghao data " .. #data)

	self.m_data = {};
	local defaultName;
	-- 如果没有称号就自动修改为第一个称号
	if defaultId == 0 then
		defaultName = data[1] and data[1].name;
		self.m_currentId = data[1] and data[1].id or 0;
	else
		for i=1, #data do
			local record = data[i];
			if defaultId == record.id then
				defaultName = record.name;
			end
			table.insert(self.m_data, record);
			printInfo("chenghao name " .. record.name)
		end
	end

	self.m_bgImage = Spinner.s_defaultBgImage;
	self.m_arrowImage = Spinner.s_defaultArrowImage;
	self.m_listImage = Spinner.s_defaultListImage;
	self.m_chooseImage = Spinner.s_defaultChooseImage;
	self.m_perWidth = Spinner.s_defaultPerWidth;
	self.m_perHeight = Spinner.s_defaultPerHeight;
	self.m_height = Spinner.s_defaultHeight;
	self.m_bgHeight = Spinner.s_defaultBgHeight;

	self.m_checkedIndex = 1;
	self.m_arrowBtn = new(Button, self.m_arrowImage);
	self.m_arrowBtn:setAlign(kAlignRight);

	local btnWidth = self.m_arrowBtn:getSize()
	self.m_bg = new(Image, self.m_bgImage, nil, nil, 20, 20, 20, 20);
	self.m_bg:setSize(self.m_perWidth + btnWidth, self.m_perHeight)
	self.m_bg:setAlign(kAlignLeft);
	self.m_bg:setLevel(3);

	self.m_chooseText = new(Text, defaultName or "", self.m_perWidth, self.m_perHeight, kAlignCenter, "", 30, 70, 230, 150);
	self.m_chooseText:setAlign(kAlignLeft)
	self.m_chooseText:setPos(10, nil)
	self:setSize(self.m_bg.m_width + self.m_arrowBtn.m_width, self.m_perHeight);

	self:addChild(self.m_bg);
	self.m_bg:addChild(self.m_arrowBtn);
	self.m_bg:addChild(self.m_chooseText);

	self:initSelectFunc();
end

Spinner.initSelectFunc = function(self)
	if #self.m_data > 1 then
		self.m_arrowBtn:setEnable(true);
		self.m_chooseText:setPickable(true);
		self.m_arrowBtn:setOnClick(self, self.onArrowClick);
		self.m_chooseText:setEventTouch(view, function(view, finger_action)
			if finger_action == kFingerDown then
				self:onArrowClick();
			end
		end)
	else
		self.m_arrowBtn:setEnable(false);
		self.m_chooseText:setPickable(false);
	end
end

Spinner.setImages = function(self, bgImage, arrowImage, listImage, chooseImage)
	self.m_bgImage = bgImage or Spinner.s_defaultBgImage;
	self.m_arrowImage = arrowImage or Spinner.s_defaultArrowImage;
	self.m_listImage = listImage or Spinner.s_defaultListImage;
	self.m_chooseImage = chooseImage or Spinner.s_defaultChooseImage;

	self.m_perWidth = Spinner.s_defaultPerWidth;
	self.m_perHeight = Spinner.s_defaultPerHeight;
	self.m_height = Spinner.s_defaultHeight;

	if self.m_bg then
		self.m_bg:setFile(self.m_bgImage);
	end
	if self.m_listBg then
		self.m_listBg:setFile(self.m_listImage);
	end
	if self.m_arrowBtn then
		self.m_arrowBtn:setFile(self.m_arrowImage);
	end
end

Spinner.getIsChanged = function(self)
	return self.m_defaultId ~= self.m_currentId, self.m_currentId;
end

Spinner.getCurrentId = function(self)
	return self.m_currentId;
end

Spinner.onArrowClick = function(self)
	--只有一条 记录的时候 不响应
	local m_height
	if #self.m_data == 2 then
		m_height = self.m_perHeight
	elseif #self.m_data <= 3 then
		m_height = (self.m_perHeight * (#self.m_data - 1));
	else
		m_height = self.m_perHeight * 3;
	end

	printInfo("m_height ==========" .. m_height);

	local posX, posY = self:getUnalignPos();

	if not self.m_listBg then
		self.m_listBg = new(Image, self.m_listImage, nil, nil, 10, 10, 10, 10);
		self.m_listBg:setSize(self.m_perWidth - 5, m_height);
		self.m_listBg:setPos(10, self.m_bgHeight + 10);
		self.m_listBg:setLevel(2)
		self:addChild(self.m_listBg);
	else
		if self.m_listBg.m_visible then
			self.m_listBg:setVisible(false);
			return;
		end
	end
	self.m_listBg:setVisible(true);

	-- 少于最少的条数
	if self.m_listView then
		self.m_listBg:removeChild(self.m_listView, true);
		self.m_totalOffset = 0;
	end

	self.m_listView = new(ScrollView, 0, 0, self.m_perWidth, m_height, true);
	self.m_listView:setLevel(2);
	self.m_listBg:addChild(self.m_listView);
	self.m_listBg:setClip(posX, posY + self.m_bgHeight, self.m_perWidth + 50, m_height + 10);

	self.m_listView.onScroll = function(listView,scroll_status,diffY,totalOffset)
		ScrollView.onScroll(listView, scroll_status, diffY, totalOffset);
		self.m_totalOffset = totalOffset;
	end
	self.m_chooseBgs = {};
	for i = 1, #self.m_data do
		local record = self.m_data[i];
		printInfo("find an record" .. record.id)
		if record.id ~= self.m_currentId then
			local node = new(Node);
			node:setSize(self.m_perWidth, self.m_perHeight);

			local m_chooseBg = new(Image, self.m_chooseImage);
			m_chooseBg:setSize(self.m_perWidth, self.m_perHeight)
			m_chooseBg:setVisible(false);

			local textView = new(Text, record.name, self.m_perWidth, self.m_perHeight, kAlignCenter, "", 30, 255, 255, 220);

			node:addChild(m_chooseBg);
			node:addChild(textView);
			table.insert(self.m_chooseBgs, m_chooseBg);
			textView.m_chooseBg = m_chooseBg;

			textView:setEventTouch(textView, function(view, finger_action, x, y, drawing_id_first, drawing_id_current)
				self:onItemTouch(finger_action, x, y, drawing_id_first, drawing_id_current, i, view);
			end)
			self.m_listView:addChild(node);
		end
	end

	self.m_listBg:removeProp(0);
	self.m_listBg:addPropTranslate(0,kAnimNormal, 200, 0, 0, 0, -m_height, 0);
end

Spinner.onItemTouch = function(self, finger_action, x, y, drawing_id_first, drawing_id_current, i, view)
	if finger_action == kFingerDown then
		for k,v in pairs(self.m_chooseBgs) do
			v:setVisible(false);
		end
		if view.m_chooseBg then
			view.m_chooseBg:setVisible(true)
		end
		self.m_fingerY = y;
	elseif finger_action == kFingerUp then
		if drawing_id_first == drawing_id_current and math.abs(self.m_fingerY - y) <= 5 then
			self.m_chooseText:setText(self.m_data[i].name);
			self.m_listBg:setVisible(false);

			self.m_currentId = self.m_data[i].id;
			local temp = table.remove(self.m_data, i);
			table.sort(self.m_data, function(s1, s2)
				return s1.id < s2.id;
			end)
			for i=#self.m_data + 1, 1, -1 do
				if i==1 then
					self.m_data[1] = temp;
				else
					self.m_data[i] = self.m_data[i-1];
				end
			end
			print("changed", self:getIsChanged())
		end
	end
end