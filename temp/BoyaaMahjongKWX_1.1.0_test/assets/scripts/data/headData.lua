--[[
	头像下载专用  
	通过UIEx.bind绑定控件 和 headName字段
	在监控headName变动的时候 更新控件显示 同时 调用 checkHeadAndDownload方法，下载头像即可

	-- 为头像绑定数据源
	UIEx.bind(xxNode, xxHeadData, "headName", function(value)
		xxNode:setFile(value)
		xxHeadData:checkHeadAndDownload()
	end)
]]
local HeadData = class()

addProperty(HeadData, "sex", 1)
addProperty(HeadData, "headUrl", "")
addProperty(HeadData, "headName", "")
addProperty(HeadData, "md5Name", nil)

function HeadData:setHeadUrl(headUrl)
	self.headUrl = headUrl
	local md5Name

	if ToolKit.isValidString(headUrl) and 
		not string.find(headUrl, 'default_%a+.png') then

		md5Name = ToolKit.getMd5ImageName(kHeadImagePrefix, self.id, headUrl)
	end
	self:setMd5Name(md5Name)
	self:setHeadName(self:getHeadName())
end

function HeadData:setSex(sex)
	self.sex = sex
	self:setHeadName(self:getHeadName(sex))
	return self
end

--@ 返回头像是否正常   如果不正常 则同时返回下载名称 下载路径
function HeadData:checkHeadImage()
	local md5Name = self:getMd5Name()
	if ToolKit.isValidString(md5Name) then
		if NativeEvent.getInstance():isFileExist(md5Name, kHeadImageFolder) == 1 then
			return true
		else
			return false, md5Name, self:getHeadUrl()
		end
	end
	return true
end

function HeadData:getHeadName(sex)
	local md5Name = self:getMd5Name()
	printInfo("HeadData:getHeadName md5Name : %s", (md5Name or "nil"))
	local defaultHead = (sex or self:getSex()) == 0 and "kwx_common/img_manHead.png" or "kwx_common/img_womanHead.png"
	if ToolKit.isValidString(md5Name) then -- 有网络头像
		printInfo("HeadData:getHeadName isValidString")
		if NativeEvent.getInstance():isFileExist(md5Name, kHeadImageFolder) == 1 then
			printInfo("HeadData:getHeadName isFileExist")
			return kHeadImageFolder .. md5Name  --返回头像路径
		else
			printInfo("HeadData:getHeadName defaultHead : %s", defaultHead)
			self:checkHeadAndDownload()
			return defaultHead
		end
	end
	printInfo("HeadData:getHeadName not defaultHead : %s", defaultHead)
	-- 根据性别返回默认头像
	return defaultHead
end

function HeadData:checkHeadAndDownload()
	printInfo("HeadData:checkHeadAndDownload")
	local success, imageName, imageUrl = self:checkHeadImage()
	-- 头像检查ok
	if success then return end
	printInfo("HeadData:checkHeadAndDownload success")

	-- 开始下载头像
	global_http_downloadImage(imageUrl, kHeadImageFolder, imageName, 
		function(status, folder, name)
			printInfo("status : %s , folder : %s , name : %s", status, folder, name)
			if status ~= 1 then return end
			if name ~= self:getMd5Name() then return end
			self:setHeadName(folder .. name)
		end
	)
end

return HeadData