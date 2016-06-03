-- Data:2013-9-4
-- Description:程序入口 
-- Note:

require("config")
require("utils.init")
require("core.init")
require("common.init")
require("gameBase.init")
require("mjSocket/base/socketCmd")

local errorPage = require(ViewPath.."errorPage");

function event_load(width,height)
	System.setLayoutWidth(1280);
    System.setLayoutHeight(720);

   	--删除全部4类对象
	res_delete_group(-1);
	anim_delete_group(-1);
	prop_delete_group(-1);
	drawing_delete_all();
	audio_music_stop(1);
	--同步关闭room/hall socke
	socket_close(kGameSocket, -1)

    printError("----------------------------------------")
    printError("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    printError(debug.traceback("", 2))
    printError("----------------------------------------")

	local errorScene = SceneLoader.load(errorPage);
	errorScene:addToRoot();

	errorContent = errorScene:getChildByName("centerView"):getChildByName("errorLog");
	local errorTips = System.getLuaError() or "";
	errorBackBtn = errorScene:getChildByName("centerView"):getChildByName("confirm");
	errorTip = errorScene:getChildByName("centerView"):getChildByName("errorTip")

 	if ToolKit.isValidString(errorTips) and DEBUG_MODE then
 		errorTip:setVisible(false)
		errorContent:setVisible(true);
		errorContent:setText(errorTips);
	else
 		errorTip:setVisible(true)
		errorContent:setVisible(false);
	end
	errorBackBtn:setOnClick(nil,function()
	    delete(errorScene);
		to_lua("main.lua");	
	end);
	PhpManager    = PhpManager    or new(require("mjSocket.base.phpManager"))
	local machineInfo = PhpManager:getMachineInfo();
	local reportStr = (errorTips or "") .. machineInfo;
	NativeEvent.getInstance():ReportLuaError(reportStr);
end 