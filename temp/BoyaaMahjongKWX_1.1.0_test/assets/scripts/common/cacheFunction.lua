---------  数据存储的封装类 --------- 

require("core/dict")

MahjongCacheData_loadFileList = {}

function MahjongCacheData_loadFile( fileName )
	for k,v in pairs(MahjongCacheData_loadFileList) do
		if 1 == MahjongCacheData_loadFileList[fileName] then
			printInfo(fileName.." has load .")
			return
		end
	end
	dict_load(fileName)
	MahjongCacheData_loadFileList[fileName] = 1
end

function MahjongCacheData_saveDict( dictName )
	if dictName then
		dict_save(dictName)
	end
end

function MahjongCacheData_deleteDict( dictName )
	if dictName then
		dict_delete(dictName)
	end
end

-- Get函数的参数定义
-- dictName(string)       需要load的dict表
-- key(string)            需要获取的key值
-- default(函数各异)	  默认值(可以不传)
function MahjongCacheData_getInt( dictName , key , default)
	MahjongCacheData_loadFile(dictName)
	return dict_get_int(dictName,key,default or 0)
end

function MahjongCacheData_getBoolean( dictName , key , default)
	MahjongCacheData_loadFile(dictName)
	local ret = dict_get_int(dictName,key,default and kTure or kFalse)
	return (kTure == ret)
end

function MahjongCacheData_getDouble( dictName , key , default)
	MahjongCacheData_loadFile(dictName)
	return dict_get_double(dictName,key,default or 0.0)
end

function MahjongCacheData_getString( dictName , key , default)
	MahjongCacheData_loadFile(dictName)
	default = default or ""
	return dict_get_string(dictName,key) or default
end

function MahjongCacheData_getTable( dictName , key , default)
	require("core/serializer")
	default = default or {}
	return Serializer.load(dictName , key) or default
end

-- Set函数的参数定义
-- dictName(string)       需要load的dict表
-- key(string)            需要获取的key值
-- data(函数各异)		  需要设置的数据
-- needSave（Boolean）    是否需要存入硬盘(可以不传，默认不存)
function MahjongCacheData_setInt( dictName , key , data , needSave)
	local ret = dict_set_int(dictName,key,data or 0)
	if ret ~= -1 and needSave then
		MahjongCacheData_saveDict(dictName)
	end
end

function MahjongCacheData_setBoolean( dictName , key , data , needSave)
	local ret = dict_set_int(dictName,key,data and kTrue or kFalse)
	if ret ~= -1 and needSave then
		MahjongCacheData_saveDict(dictName)
	end
end

function MahjongCacheData_setDouble( dictName , key , data , needSave)
	local ret = dict_set_double(dictName,key,data or 0.0)
	if ret ~= -1 and needSave then
		MahjongCacheData_saveDict(dictName)
	end
end

function MahjongCacheData_setString( dictName , key , data , needSave)
	local ret = dict_set_string(dictName,key,data or "")
	if ret ~= -1 and needSave then
		MahjongCacheData_saveDict(dictName)
	end
end

function MahjongCacheData_setTable( dictName , key , data , needSave)
	require("core/serializer")
	local ret = Serializer.save(dictName,key,data or {})
	if ret ~= -1 and needSave then
		MahjongCacheData_saveDict(dictName)
	end
end

function MahjongCacheData_clearData()
	GuideManager:clearGuideConfig()
end 