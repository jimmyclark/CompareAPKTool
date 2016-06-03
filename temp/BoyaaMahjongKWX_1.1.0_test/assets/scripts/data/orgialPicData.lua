local OrgialPicData = class(require('data.headData'))

function OrgialPicData:getHeadName(sex)
	local md5Name = self:getMd5Name()
	local defaultHead = "kwx_tanKuang/gameBox/img_boxDefalut.png"
	if ToolKit.isValidString(md5Name) then -- 有网络头像
		if NativeEvent.getInstance():isFileExist(md5Name, kHeadImageFolder) == 1 then
			return kHeadImageFolder .. md5Name  --返回头像路径
		else
			return defaultHead
		end
	end
	-- 根据性别返回默认头像
	return defaultHead
end

return OrgialPicData