local Task = class()

TaskType = {
	Game = 0, 		-- 牌局任务
	Share = 1, 		-- 分享任务
	Evaluate = 2, 	-- 评价任务
	Invite = 3, 	-- 邀请任务
}

addProperty(Task, "id", 0)
addProperty(Task, "title", "")
addProperty(Task, "award", "")
addProperty(Task, "pro_need", 0)
addProperty(Task, "pro_cur", 0)
addProperty(Task, "status", 0)
addProperty(Task, "target", 0)
addProperty(Task, "extend", {})

return Task