--region serializer.lua
--Author : KimWang
--Date   : 2015/5/27
--这个文件用于lua表的序列化和反序列化，并且提供相关的方法持久化已经序列化的数据。
Serializer = {};

--[Comment]
--序列化lua表
--obj:  需要被序列化的对象
--返回: 序列化后的字符串
Serializer.serialize = function(obj)  
    local str = "" 
    local t = type(obj)  
    if t == "number" then  
        str = str .. obj  
    elseif t == "boolean" then  
        str = str .. tostring(obj)  
    elseif t == "string" then  
        str = str .. string.format("%q", obj)  
    elseif t == "table" then  
        str = str .. "{\n"  
        for k, v in pairs(obj) do  
            str = str .. "[" .. Serializer.serialize(k) .. "]=" .. Serializer.serialize(v) .. ",\n"  
        end  
        local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
            for k, v in pairs(metatable.__index) do  
                str = str .. "[" .. Serializer.serialize(k) .. "]=" .. Serializer.serialize(v) .. ",\n"  
            end  
        end  
        str = str .. "}"  
    elseif t == "nil" then  
        return nil  
    else  
        return ;
        -- error("can not serialize a " .. t .. " type.")  
    end  
    return str  
end  

--[Comment]
--将字符串反序列化成lua表
--str:  需要被反序列化的字符串
--返回: 被反序化的lua表
Serializer.unserialize = function(str)  
    local t = type(str)  
    if t == "nil" or str == "" then  
        return nil  
    elseif t == "number" or t == "string" or t == "boolean" then  
        str = tostring(str)  
    else  
        return;
        -- error("can not unserialize a " .. t .. " type.")  
    end  
    str = "return " .. str  
    local func = loadstring(str)  
    if func == nil then return nil end  
    return func()
end  

--[Comment]
--将lua表序列化同时持久化到磁盘
--key:键用于索引存储的字符串
--obj:lua表
--返回为-1，表示操作失败，否则操作成功
Serializer.save = function(dict, key, obj)
    local ret = -1;
    if key ~= nil and type(key) == "string" and obj ~= nil then
        local str = Serializer.serialize(obj);
        if str ~= nil then
            ret = dict_set_string(dict, key, str);
        end
    end
    return ret;
end

--[Comment]
--从磁盘加载字符串，并反序列化成lua表
--key:键用于索引存储的字符串
--返回为nil，表示操作失败，否则操作成功
Serializer.load = function(dict, key)
    local ret = nil;
    if key ~= nil and type(key) == "string"  then
        dict_load(key);
        local str = dict_get_string(dict, key);
        if str ~= nil then
            ret = Serializer.unserialize(str);
        end
    end
    return ret;
end

--endregion
