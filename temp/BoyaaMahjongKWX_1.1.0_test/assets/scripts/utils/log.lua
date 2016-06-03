--[[--

打印调试信息

### 用法示例

~~~ lua

printLog("WARN", "Network connection lost at %d", os.time())

~~~

@param string tag 调试信息的 tag
@param string fmt 调试信息格式
@param [mixed ...] 更多参数

]]
function printLog(tag, fmt, ...)
    if not DEBUG_MODE then return end
    local t = {
        "[",
        string.upper(tostring(tag)),
        "] ",
        string.format(tostring(fmt), ...)
    }
    print_string(table.concat(t))
end

--[[--

输出 tag 为 ERR 的调试信息

@param string fmt 调试信息格式
@param [mixed ...] 更多参数

]]
function printError(fmt, ...)
    if not DEBUG_MODE then return end
    print_string(string.format("ERROR: %s", string.format(fmt, ...)))
end

--[[--

输出 tag 为 INFO 的调试信息

@param string fmt 调试信息格式
@param [mixed ...] 更多参数

]]
function printInfo(fmt, ...)
    if not DEBUG_MODE then return end
    printLog("INFO", fmt, ...)
end

--[[]]
function overridePrint(tag)
    local len = #tag
    local totalLen = 15
    local offset = math.floor((totalLen - len) / 2) 
    local suffix = ""
    for i=1, offset do
        suffix = suffix .. " "
    end
    tag = table.concat({suffix, tag, suffix}, "")
    return 
    function(fmt, ...)    
        printInfo("[" .. string.format("%s", tag) .. "]:" .. fmt, ...)
    end,
    function(fmt, ...)
        printError("[" .. string.format("%s", tag) .. "]:" .. fmt, ...)
    end
end

local fixStart  = "\n||||||||||||||||||||||||||||||||||||||||||||||||打印%s结果 START||||||||||||||||||||||||||||||||||||||||||||||||\n"
local fixEnd    = "\n||||||||||||||||||||||||||||||||||||||||||||||||打印结果 E N D||||||||||||||||||||||||||||||||||||||||||||||||\n"
function dump(value, tag)
    if not DEBUG_MODE then return end
    tag = tag or ""
    print_string(string.format(fixStart, tag) .. inspect(value, {indent="    "}) .. fixEnd)
end