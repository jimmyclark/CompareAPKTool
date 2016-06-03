local taskItemLayout = require(ViewPath .. "taskItemLayout")
local TaskPopu = class(require("popu.gameWindow"))

local TASK_RC = 1;
local TASK_CZ = 2;

function TaskPopu:ctor()
	-- body
	-- ScrollBar.setDefaultImage("kwx_common/img_scrollerBar.png")
    GameSetting:setIsSecondScene(true)
	EventDispatcher.getInstance():register(Event.Call, self,self.onNativeCallDone);
end

function TaskPopu:dtor()
	EventDispatcher.getInstance():unregister(Event.Call, self,self.onNativeCallDone)
end

function TaskPopu:initView(data)
	self.mTaskList = {}
	self.mCurSelectId = 0

	self.mImg_bg = self:findChildByName("img_bg")
	-- self.mScrollView = self:findChildByName("view_task")
	self.mTaskData = new(require("data.taskData"));
	GameSocketMgr:sendMsg(Command.TASK_RC_PHP_REQUEST, {act = "rc"})

	self:findChildByName("btn_back"):setOnClick(self, function(self)
		self:dismiss()
	end)
end

function TaskPopu:initTask()
	-- self.mScrollView:removeAllChildren()
	delete(self.mScrollView)
	self.mScrollView = nil

	self.mScrollView = new(ScrollView)
	self.mScrollView:setFillRegion(true, 30, 110, 30, 10)
	self.mImg_bg:addChild(self.mScrollView)
	local data = self.mTaskData
	local count = 0
	local itemW, itemH = 0, 0
	for i = 1, data:count() do
		local itemData = data:get(i)
		local item = self:createItem(itemData)
		if item then
			itemW, itemH = item:getSize()
			item:setPos(25, count * (itemH+30))
			self.mScrollView:addChild(item)
			count = count + 1

			table.insert(self.mTaskList, {
					item = item,
					itemData = itemData
				})
		end
	end
	-- local w , h = self.mScrollView:getSize()
	-- self.mScrollView:setSize(w, count * (itemH+30));
end

function TaskPopu:createItem(data)
	--设置领奖按钮状态
	printInfo("id : %d, status : %d",data:getId(), data:getStatus())
	local status = data:getStatus();
	if status ~= 1 and status ~= 2 then
		return
	end
	local item = SceneLoader.load(taskItemLayout);
	self:initItem(item, data);
	return item;
end

function TaskPopu:initItem(item, data)
	local status = data:getStatus();
	item:setName(tostring(data:getId()));
	item:findChildByName("text_title"):setText(data:getTitle());
	-- item:findChildByName("img_icon"):setFile(string.format("%s/%s.png","task", data:getId()));
	local progress = item:findChildByName("img_progress");
	--44为9宫格的宽度，该宽度iamge类没有保存，故无法获到，只能硬编码
	local percent = data:getPro_need() ~= 0 and data:getPro_cur() / data:getPro_need() or 0;
	local width = (progress.m_res.m_width - 44) * percent;
	progress:setSize(44 + width, progress.m_res.m_height);
	item:findChildByName("text_progress"):setText(data:getPro_cur()..'/'..data:getPro_need());
	item:findChildByName("text_info"):setText(data:getAward());
	item:findChildByName("btn_task"):setVisible(false);

	if data:getPro_need() == data:getPro_cur() then
		status = 2
	end
	--未完成状态
	if status == 1 then
		local id = data:getId();
		local btnTask = item:findChildByName("btn_task");
        btnTask:setFile("kwx_common/btn_red_small.png")
		btnTask:setVisible(true);
		item:findChildByName("text_btnTitle"):setText("去做任务");

		local target = data:getTarget()

		btnTask:setOnClick(self, function ( self )	
			self.mCurSelectId = data:getId()
			if TaskType.Game == target then
				app:quickStartGame()
				self:dismiss(true);
			elseif TaskType.Share == target then
				-- 分享
				local extent = data:getExtend()
				NativeEvent.getInstance():shareFromTask({
							["logo"] = extent.logo or "",
							["desc"] = extent.desc or "",
							["url"] = extent.link or ""})

				if isPlatform_Win32() then
					self:onNativeCallDone("shareTaskReturn")
				end
				
			elseif TaskType.Evaluate == target then
				-- 点评
				local markeNum = NativeEvent.getInstance():getMarketNum()
				if 0 < markeNum then
					NativeEvent.getInstance():launchMarket()
					GameSocketMgr:sendMsg(Command.TASKSUBMIT_PHP_REQUEST, {['target'] = TaskType.Evaluate})
				end
			elseif TaskType.Invite == target then
				-- 邀请
				GameSocketMgr:sendMsg(Command.TASKSUBMIT_PHP_REQUEST, {['target'] = TaskType.Invite})
			end
		end);


	elseif status == 2 then
		--可以领取
		local btnTask = item:findChildByName("btn_task");
		btnTask:setFile("kwx_common/btn_blue_small.png")
		btnTask:setVisible(true);
		local id = data:getId();
		btnTask:setOnClick(self, function ( self )
			-- body
			GameSocketMgr:sendMsg(Command.TASK_AWARD_PHP_REQUEST, {taskid = id});
		end);
		item:findChildByName("text_btnTitle"):setText("领取奖励");
	end
end

function TaskPopu:sort()
	
end
--
function TaskPopu:initData( data )
	-- body
	if data.status == 1 then
		self.mTaskData:clear();
		for i = 1, #data.data do
			local task = setProxy(new(require("data.task")));
			task:setId(data.data[i].id);
			task:setTitle(data.data[i].title);
			task:setAward(data.data[i].award);
			task:setPro_need(data.data[i].pro_need);
			task:setPro_cur(data.data[i].pro_cur);
			task:setStatus(data.data[i].status);
			task:setTarget(data.data[i].target);
			task:setExtend(data.data[i].extend)
			self.mTaskData:add(task);
		end 

		self:sort();
		self.mTaskData:setInit(true);
		self:initTask();
	else
		printInfo("error");
	end
end

--返回type 及 index
function TaskPopu:findTaskById( id )
	-- body
	if id then
		local count = self.mTaskData:count()
		for i = 1, count do
			local task = self.mTaskData:get(i)
			if tostring(task:getId()) == tostring(id) then
				return i
			end
		end
	end
end

function TaskPopu:updateTasklListFromId( id )
	for i = 1, #self.mTaskList do
		if id == self.mTaskList[i].itemData:getId() then
			local pro_cur = self.mTaskList[i].itemData:getPro_cur() + 1
			self.mTaskList[i].itemData:setPro_cur(pro_cur)
			self:initItem(self.mTaskList[i].item, self.mTaskList[i].itemData)
			break
		end
	end
end

function TaskPopu:onTaskRcResponse(data)
	self:initData(data);
end

function TaskPopu:onTaskCzResponse(data)
	self:initData(data);
	
end
function TaskPopu:onTaskAwardResponse(data)
	if data.status == 1 then
		--替换
		local id = data.data.next and data.data.next.id or data.data.id;
		printInfo("id :　%d", id)
		local index = self:findTaskById(id);
		printInfo("index :　%d", index)
		if index then
			local task = self.mTaskData:get(index);
			local _next = data.data.next;
			if _next and _next.id then
				task:setTitle(_next.title);
				task:setAward(_next.award);
				task:setPro_need(_next.pro_need);
				task:setPro_cur(_next.pro_cur);
				task:setStatus(_next.status);
			else
				task:setStatus(3);
			end
			self:sort();
			self:initTask();
		end
	end
end

function TaskPopu:onTaskSubmitResponse( data )
	
end

-- 原生调用 分享成功
function TaskPopu:onNativeCallDone(key, data)
	printInfo("TaskPopu:onNativeCallDone")
	--dump(data)
	if "shareTaskReturn" == key then
		self:updateTasklListFromId(self.mCurSelectId)
		GameSocketMgr:sendMsg(Command.TASKSUBMIT_PHP_REQUEST, {['target'] =TaskType.Share})
	end
end


--[[
	通用的（大厅）协议
]]
TaskPopu.s_severCmdEventFuncMap = {
	[Command.TASK_RC_PHP_REQUEST]	= TaskPopu.onTaskRcResponse,
	[Command.TASK_CZ_PHP_REQUEST]	= TaskPopu.onTaskCzResponse,
	[Command.TASK_AWARD_PHP_REQUEST]= TaskPopu.onTaskAwardResponse,
	[Command.TASKSUBMIT_PHP_REQUEST]= TaskPopu.onTaskSubmitResponse,
}

function TaskPopu:dismiss(...)
    GameSetting:setIsSecondScene(false)
    return TaskPopu.super.dismiss(self, ...)
end

return TaskPopu