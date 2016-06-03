
--[[
	图片下载专用  
	通过UIEx.bind绑定控件 和 headName字段
	在监控headName变动的时候 更新控件显示 同时 调用 checkHeadAndDownload方法，下载头像即可
]]
local DownloadImage = class()

function DownloadImage:ctor()
	self.downloadTable = {}
end

function DownloadImage:dtor()
	
end

-- 返回是否该图片存在
function DownloadImage:checkGameImage(md5Name)
	if ToolKit.isValidString(md5Name) then
		if NativeEvent.getInstance():isFileExist(md5Name, kGameImageFolder) == 1 then
			return true
		else
			return false
		end
	end
	return true
end

-- 下载图片
function DownloadImage:downloadOneImage(fileName, control, defaultName)
	if not control then
		return
	end
	local md5Name = ToolKit.getMd5ImageName(kGameImagePrefix, nil, fileName)
	local isExit = self:checkGameImage(md5Name)
	if not isExit then
		if not self.downloadTable[md5Name] then
			self.downloadTable[md5Name] = {}
			-- 开始下载头像
			global_http_downloadImage(fileName, kGameImageFolder, md5Name, 
				function(status, folder, name)
					if status ~= 1 then return end
					self:downloadOneImageDone(name, folder..name)
				end
			)
		end
		control.m_md5Name = md5Name
		local hasExist = false
		for k, v in pairs(self.downloadTable[md5Name]) do
			if v == control then
				hasExist = true
				break
			end
		end
		if not hasExist then
			table.insert(self.downloadTable[md5Name], control)
		end
		if defaultName then
			control:setFile(defaultName)
		end
		-- self:downloadOneImageDone(md5Name, defaultName)
	else
		control:setFile(kGameImageFolder..md5Name)
	end
end

-- 下载完成的回调
function DownloadImage:downloadOneImageDone(md5Name, imageName)
	if not md5Name or not self.downloadTable[md5Name] or not imageName then
		return
	end
	for k, v in pairs(self.downloadTable[md5Name]) do
		v:setFile(imageName)
	end
end

-- control销毁后则清空
function DownloadImage:removeControl(control)
	if not control then return end
	for k, controlTable in pairs(self.downloadTable) do
		for i, v in pairs(controlTable) do
			if v == control then
				table.remove(controlTable, i)
				break
			end
		end
	end
end

return DownloadImage