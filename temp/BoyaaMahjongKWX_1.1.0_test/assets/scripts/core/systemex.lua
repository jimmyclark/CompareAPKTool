
System.getAndroidAudioFullFile = function()
	return sys_get_string("audio_search");
end

System.setAndroidAudioFullFile = function(file)
	return sys_set_string("search_name", file);
end

System.getAudioFullPath = function(self,file)
	sys_set_string("search_name", file);
	return sys_get_string("audio_search");
end

System.setSocketLogEnable = function(boolValue)
	--engine had remove it 
	--return sys_set_int("socket_log_file",boolValue and kTrue or kFalse);
end

System.setAlertErrorEnable = function(boolValue)
	--engine had remove it 
	--return sys_set_int("alert_error",boolValue and kTrue or kFalse);
end

System.setLuaError = function(strValue)
	--engine had remove it 
	--return sys_set_string("last_lua_error",strValue);
end

System.setToErrorLuaInWin32Enable = function(boolValue)
	--engine had remove it 
	--return sys_set_int("to_error_lua_in_win32",boolValue and kTrue or kFalse);
end

System.setBackpressExitEnable = function(boolValue)
	--engine had remove it 
	--return sys_set_int("backpress_exit",boolValue and kTrue or kFalse);
end

System.setSocketHeaderSize = function(intValue)
	return socket_sys_set_int("socket_header",intValue or 9);
end

System.setSocketHeaderExtSize = function(intValue)
	return socket_sys_set_int("socket_header_extend",intValue or 0);
end

-----------------------------------------------
System.getStorageScriptPath = function(self)
	return sys_get_string("storage_scripts") or "";
end

System.getStorageImagePath = function(self)
	return sys_get_string("storage_images") or "";
end

System.getStorageAudioPath = function(self)
	return sys_get_string("storage_audio") or "";
end

System.getStorageFontPath = function(self)
	return sys_get_string("storage_fonts") or "";
end

System.getStorageXmlPath = function(self)
	return sys_get_string("storage_xml") or "";
end

System.getStorageUpdatePath = function(self)
	return sys_get_string("storage_update") or "";
end

System.getStorageDictPath = function(self)
	return sys_get_string("storage_dic") or "";
end

System.getStorageLogPath = function(self)
	return sys_get_string("storage_log") or "";
end

System.getStorageUserPath = function(self)
	return sys_get_string("storage_user") or "";
end

System.getStorageTempPath = function(self)
	return sys_get_string("storage_temp") or "";
end

System.removeFile = function(self,filePath)
	dict_set_string("file_op","src_file",filePath);
	return sys_get_int("file_delete",-1) == 0;
end

System.moveFile = function(self,srcFilePath,destFilePath)
	dict_set_string("file_op","src_file",srcFilePath);
	dict_set_string("file_op","dest_file",destFilePath);
	return sys_get_int("file_copy",-1) == 0;
end

System.getFileSize = function(self,filePath)
	dict_set_string("file_op","src_file",filePath);
	return sys_get_int("file_size",-1);
end

System.pushFrontImageSearchPath = function(self,path)
	sys_set_string("push_front_images_path", path);
end

System.pushFrontAudioSearchPath = function(self,path)
	sys_set_string("push_front_audio_path", path);
end

System.pushFrontFontSearchPath = function(self,path)
	sys_set_string("push_front_fonts_path", path);
end