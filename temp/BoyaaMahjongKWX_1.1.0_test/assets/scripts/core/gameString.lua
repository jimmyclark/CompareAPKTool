-- gameString.lua
-- Author: Vicent Gong
-- Date: 2012-09-30
-- Last modification : 2014-06-12
-- Description: provide basic wrapper for game string handler

require("core/object");
require("core/system")

GameString = class();

GameString.s_platform = System.getPlatform();
GameString.s_win32Code = "gb2312";

GameString.setWin32Code = function(win32Code)
	GameString.s_win32Code = win32Code or GameString.s_win32Code;
end

GameString.load = function(filename, lang)
	if not lang then
		if GameString.s_platform == kPlatformWin32 and GameString.s_win32Code == "gbk" then
			lang = "zw";
		else
			lang = System.getLanguage();
		end
	end

    local languageLuaFile = string.format("%s_%s",filename,lang);
    if pcall(require,languageLuaFile) == false then
    	if pcall(require,filename) == false then
    		error("load string file failed, not default string file exist");
    	end
    end
end
		
GameString.get = function(key)
    local str= _G[key];
	return str;
end

GameString.convert2Platform = function(str, sourceCode)
--	编码已经统一为UTF8编码，不需要进行转换
	return str;
--[[
	sourceCode = sourceCode or "utf-8";
	local platformCode = (GameString.s_platform == kPlatformWin32) 
							and GameString.s_win32Code or "utf-8";

	if sourceCode == platformCode then
		return str;
	else
		return string_encoding(sourceCode,platformCode,str);
	end
]]
end

GameString.convert2UTF8 = function(str, sourceCode)
	if not sourceCode then
		if GameString.s_platform == kPlatformWin32 then
			sourceCode = GameString.s_win32Code;
		else
			sourceCode = "utf-8";
		end
	end

	if sourceCode == "utf-8" then
		return str;
	else
		return string_encoding(sourceCode,"utf-8",str);
	end
end