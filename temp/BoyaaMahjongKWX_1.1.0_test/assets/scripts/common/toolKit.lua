ToolKit = {};

-- 将long转换成:xx年xx月xx日xx时xx分xx秒格式
function ToolKit.getTimeYMD(time)
    local days = "";
    if time and tonumber(time) then
        local timeNum = tonumber(time);
        timeNum = math.abs(timeNum);
        local str = "%Y" .. string_get("yearStr") .. "%m" .. string_get("mouthStr") .. "%d" .. string_get("dayStr") .. "%H" .. string_get("hourStr") .. "%M" .. string_get("minStr") .. "%S".. string_get("secStr");
        days = os.date(str,timeNum);
    end
    return days;
end

-- 将long转换成:xx月xx日xx:xx:xx格式
function ToolKit.getTimeMDHMS(time)
    local days = "";
    if time and tonumber(time) then
        local timeNum = tonumber(time);
        timeNum = math.abs(timeNum);
        local str = "%m" .. string_get("mouthStr") .. "%d" .. string_get("dayStr") .. "%H" .. ":%M" .. ":%S";
        days = os.date(str,timeNum);
    end
    return days;
end

-- 拆分时间：00时:00分:00秒
function ToolKit.skipTime(time)
    local times = nil;
    if time then
        local timeNum = tonumber(time);
        if timeNum and timeNum > 0 then
            local hour = os.date("*t",timeNum).hour - 8;
            local min  = os.date("*t",timeNum).min;
            local sec  = os.date("*t",timeNum).sec;

            hour = string.format("%02d",hour);
            min = string.format("%02d",min);
            sec = string.format("%02d",sec);
            times = hour .. ":" .. min .. ":" .. sec;
        end
    end
    return times or string_get("initTimeStr");
end

-- 拆分时间：00时:00分
function ToolKit.skipTimeHM(time)
    local times = nil;
    if time then
        local timeNum = tonumber(time);
        if timeNum and timeNum > 0 then
            local hour = os.date("*t",timeNum).hour;
            local min  = os.date("*t",timeNum).min;

            hour = string.format("%02d",hour);
            min = string.format("%02d",min);
            times = hour .. ":" .. min;
        end
    end
    return times or string_get("initTimeStr");
end

--拆分金币每3位用逗号隔开
function ToolKit.skipMoney(curMoney)
    local moneyStr = nil;
    local moneyPrefix = ""; -- 负的时候为-
    if curMoney and tonumber(curMoney) then
        local money = curMoney .. "";
        if curMoney < 0 then
            moneyPrefix = "-";
            money = string.sub(money .. "", 2, #money)
        end
        local length = #money;
        local spead = 1;
        for i=length,0, -3 do
            local x = length - spead*3 + 1;
            if x < 1 then
                x=1;
            end
            if moneyStr then
                moneyStr = string.sub(money, x, length - (spead-1)*3) .. "," .. moneyStr;
            else
                moneyStr = string.sub(money, x, length - (spead-1)*3);
            end
            spead = spead +1;
        end
        if string.sub(moneyStr, 1, 1) == "," then
            moneyStr = string.sub(moneyStr, 2, #moneyStr);
        end
    end
    if not moneyStr then
        moneyStr = curMoney or 0;
    end
    moneyStr = moneyPrefix .. moneyStr;
    return moneyStr;
end
--123,456
--12.2万
--12.18亿
--100000000
function ToolKit.formatNumber( number )
    -- body
    local isMinus = false
    number = tonumber(number)
    if 0 > number then isMinus = true number = math.abs(number) end

    number = number and tostring(number) or "";

    if string.len(number) <= 3 then
        number = number;
    elseif string.len(number) <= 6 then
        local insertPos = string.len(number) - 3;
        number = string.sub(number, 1, insertPos) .. tostring(',') .. string.sub(number, insertPos + 1, string.len(number));
    elseif string.len(number) <= 8 then
        number = string.format("%0.01fw", (math.floor(number/1000) * 1000) / 10000);
    else
        number = string.format("%0.02fy", (math.floor(number/1000000) * 1000000) / 100000000);
    end

    if isMinus then number = "-"..number end
    return number;
    
end

function ToolKit.formatThreeNumber( number )
    if not number then return "" end
    number = number and tostring(number) or ""
    local pre = string.sub(number, 1, 1)
    if pre == '-' or pre == '+' then
        number = string.sub(number, 2, string.len(number))
    else
        pre = ""
    end
    local result = ""
    local len = string.len(number)
    for i = 1, len do
        result = result..(string.sub(number,i,i))
        if 0 == (len - i) % 3 and i ~= len then
            result = result..','
        end
    end
    return pre..result
end

--获取utf8字符串的子字符串
function ToolKit.utf8_substring(str, first, num)

  local n   = string.len(str);
  first     = tonumber(first) or 1;
  num       = tonumber(num) or 0;
  local i   = 1;

  if num == 0 then
    return "";
  end;

  while i <= n do

    num = num -1;
    first = first -1;
  
    if first == 0 then
        b = i;
    end

    local cp = string.byte(str, i);
    if cp >= 0xF0 then
      i = i + 4;
    elseif cp >= 0xE0 then
      i = i + 3;
    elseif cp >= 0xC0 then
      i = i + 2;
    else
      i = i + 1;
    end;

    if num == 0 then
        e = i - 1;
        break;
    end

  end;
  
  if not e then
    e = n;
  end;

  if num > 0 then e = n end

  return string.sub(str, b, e);
end;

function ToolKit.subString(str,strMaxLen)
  if nil == str then
    return "";
  end
  return ToolKit.utf8_substring(str, 1, strMaxLen);
end

function ToolKit.split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result;
end

function ToolKit.formatNick(nick, length)
    length = length or 10;
    local subStr = ToolKit.subString(nick, length);
    if subStr == "" then
    elseif subStr ~= nick then
        subStr = subStr .. ".."
    end;
    return subStr;
end

-- function ToolKit.formatMoney(money)
--     money = money or 0
--     local moneyBitCount =  math.floor(math.log10(money)) + 1;
--     if moneyBitCount > 8 then
--         money = string.format("%0.02f", money / 100000000);
--         money = money .. "亿";
--     elseif(moneyBitCount > 6) then
--         money = string.format("%0.01f", money / 10000);
--         money = money .. "万";
--     else
--         money = ToolKit.skipMoney(money);
--     end
--     return money;
-- end

function ToolKit.formatMoney(number)
--123,456
--12.2万
--12.18亿
--100000000
    -- body
    number = number and tostring(number) or "";

    if string.len(number) <= 3 then
        return number;
    elseif string.len(number) <= 6 then
        local insertPos = string.len(number) - 3;
        return string.sub(number, 1, insertPos) .. tostring(',') .. string.sub(number, insertPos + 1, string.len(number));
    elseif string.len(number) <= 8 then
        return string.format("%0.01f万", number/10000);
    else
        return string.format("%0.02f亿", number/100000000);
    end

    return number;
end

function ToolKit.formatTurnMoney(money)
    money = money or 0
    return (money >= 0 and "+" or "-") .. math.abs(money)
end

ToolKit.weakValues = {};
setmetatable(ToolKit.weakValues, {__mode="v"});

-- 提示登录
function ToolKit.showDialog(_title,_msg,left,_leftCmd,right,_rightCmd,callback,own)
  if ToolKit.dialog then
    delete(ToolKit.dialog);
    ToolKit.dialog = nil;
  end;
  ToolKit.weakValues.dialogOwn = own;
  ToolKit.weakValues.dialogCallback = callback; 
  local data = {title=_title,leftStr=left,leftCmd=_leftCmd,rightStr=right,rightCmd=_rightCmd,msgStr=msg};
  ToolKit.dialog = new(Dialog,data);
  ToolKit.dialog:create();
  ToolKit.dialog:setCallBackClick(nil,ToolKit.dialogCallback);
end

function ToolKit.dialogCallback(self,param)
  if ToolKit.dialog then
    delete(ToolKit.dialog);
    ToolKit.dialog = nil;
  end;
  if ToolKit.weakValues.dialogCallback then
    ToolKit.weakValues.dialogCallback(ToolKit.weakValues.Own, param);
  end;
end;


function ToolKit.setDebugName( obj , name)
   if obj then
        obj:setDebugName(name);
   end 
end


--获取从头开始的指定长度的子字符串，可以避免子字符串末尾处中文乱码问题
--str：源字符串
--count：子字符串长度
--return：子字符串，无需进行转码，即可显示
function ToolKit.getSubStr ( str,count )
    if str=="" then
        return str;
    end
    local s=GameString.convert2UTF8(str);
    local i=1;
    local cn={};
    while i<=string.len(s) do
        local ss=string.sub(s,1,i);
        local len=string.lenutf8(ss);
        if len+#cn*2<i then
            table.insert(cn,i);
            i=i+3;
        else
            i=i+1;
        end
    end
    for i=1,#cn do
        cn[i]=cn[i]-(i-1);
        if cn[i]==count then
            count=count-1;
            break;
        end
    end
    return string.sub(GameString.convert2UTF8(s),1,count);
end

--return：  集合:t1-t2
function ToolKit.difference ( t1,t2 )
    local ret={};
    local index=1;
    for _,v in ipairs(t1) do
        if index<=#t2 and v==t2[index] then
            index=index+1;
        else
            ret[#ret+1]=v;
        end
    end

    return ret;
end

-- 文本超过显示长度时，让文本内容一个一个往左循环移动（暂只支持纯英文的文本）
-- textObj:可设置文本的对象，类型：Text、EditText
-- src:源字符串，类型：String
-- size:显示字符的长度，类型：Number
function ToolKit.CharacterMovement(textObj,src,size)
    if not src or src == "" then
        return src;
    end

    local count = string.len(tostring(src));
    local i = 0;
    if count > size then      
         local anim = new(AnimDouble,kAnimLoop,0,1,1000,-1);
         anim:setDebugName("ToolKit | anim");
         anim:setEvent(src,function()
             i = i + 1;
             if i + (size-1)<= count then 
                str = string.sub(src,i,i+(size-1));
             elseif i <= count and i + (size-1) > count then 
                str = string.sub(src,i,count).."   "..string.sub(src,1,(size-1)-(count-i));
             elseif i == count+1 then 
                 i = 1;
                str = string.sub(src,i,i+(size-1));
             end
             textObj:setText(str);
         end);
    end
end 

------------------------------------用于动态显示图片------------------------
function ToolKit.getNextImagePos(pos , obj , space , imageWidth)
    space = space or 0;
    if(not imageWidth) then
        local width , height = obj:getSize();
        pos.x = pos.x + width + space;
    else
        pos.x = pos.x + imageWidth + space;
    end
    return pos;
end

ToolKit.getNum=function (val,arr,count )
    local val=val;
    local index=1;
    if val==0 then 
        arr[1]=0;
    else
        while val>0 do
            arr[index]= val%10;
            val=math.floor(val/10);
            index=index+1;
        end
        for i=index,count do
            arr[i]=0;
        end
    end
end

--去除空格
function ToolKit.trim(s)
    -- return (string.gsub(s,"^%s*(.-)%s*$","%1"));
    return (string.gsub(s, " ", ""));
end

function ToolKit.isValidString(str)
    return str and str ~= ""; 
end

-- 将前缀 key 和 图片地址进行md5加密
function ToolKit.getMd5ImageName(kPrefix, key, imgUrl)
    key = key or 0;
    imgUrl = imgUrl or "";
    kPrefix = kPrefix or "";
    local md5Str = string.sub(md5_string(imgUrl) or "", 9, 24);
    return kPrefix .. "_" .. key .. "_" .. md5Str .. ".png";
end

function ToolKit.getMd5Key(md5Str)
    local startPos, endPos = string.find(md5Str, "%_%w+%_");
    if startPos and endPos then
        return string.sub(md5Str, startPos + 1, endPos - 1);
    end
    return "";
end

function ToolKit.getIntPart(num)
   
    if num <= 0 then
       return math.ceil(num);
    end
    if math.ceil(num) == num then
       num = math.ceil(num);
    else
       num = math.ceil(num) - 1;
    end
    return num;
end

--深度拷贝一个table
function ToolKit.deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function ToolKit.formatCard(cardValue)
    cardValue = cardValue or 0;
    return string.format("0x%02x", cardValue); 
end

-- 传入3张图片引用，返回imgM处在imgL和imgR中间时的位置x，flag=0代表返回的x是相对imgL，flag=1代表返回的x是相对imgR
function ToolKit.getMidPosOf2Img(imgL, imgM, imgR, flag)
    local up_abs_x, up_abs_y = imgL:getAbsolutePos();
    local t_x, t_y = imgR:getAbsolutePos();
    local w,_ = imgL:getSize();
    local ad_w,_ = imgM:getSize();
    local up_x,_ = imgL:getPos();
    local r_x,_ = imgR:getPos();
    local midPos_x;
    if flag == 0 then
        midPos_x = (up_x+w+(t_x-(up_abs_x+w))/2 -ad_w/2);
    elseif flag == 1 then
        midPos_x = (r_x-(t_x-(up_abs_x+w))/2 -ad_w/2);
    end
    return midPos_x;
end

-- 判断utf8字符byte长度
-- 0xxxxxxx - 1 byte
-- 110yxxxx - 192, 2 byte
-- 1110yyyy - 225, 3 byte
-- 11110zzz - 240, 4 byte
local function chsize(char)
    if not char then
        print("not char")
        return 1
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

-- 计算utf8字符串字符数, 各种字符都按一个字符计算
-- 例如utf8len("1你好") => 3
function ToolKit.utf8len(str)
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        len = len +1
    end
    return len, currentIndex
end

-- 截取字符串指定长度
function ToolKit.subStr(str, num, startIndex, noSuffix)
    startIndex = startIndex or 1
    noSuffix   = noSuffix or false;  
    local len = #str
    local numChars = ToolKit.utf8len(str)
    local suffix = ""
    local result = ""
    if not noSuffix and startIndex == 1 and len > num then
        suffix = "..."
    end
    local currentIndex = startIndex
    while currentIndex - startIndex < num do
        local char = string.byte(str, currentIndex)
        local temp = chsize(char)
        result = result .. string.sub(str, currentIndex, currentIndex + temp - 1)
        currentIndex = currentIndex + temp
    end
    return result .. suffix
end

-- 截取字符串指定长度
function ToolKit.isAllAscci(str)
    for i = 1, #str do
        if chsize(string.byte(str, i)) > 1 then
            return false;
        end
    end
    return true;
end

-- 截取字符串指定长度
function ToolKit.isValidTelNo(tel)
    local ret = string.gsub(tel, '%d*', '');
    return string.len(ret) == 0 and string.len(tel) == 11;
end

--字典
function ToolKit.getDict( dictName, fields )
    -- body
    local dict = new(Dict, dictName); dict:load();
    local data = {};

    for k, v in pairs(fields) do
        data[v] = dict:getString(v) or "";
    end

    return data;
end

function ToolKit.setDict( dictName, field2value )
    -- body
    local dict = new(Dict, dictName);

    for k, v in pairs(field2value) do
        dict:setString(k, tostring(v));
    end

    dict:save();
end

function ToolKit.tableLen(tbl)
    local count = 0;
    for k, v in pairs(tbl) do
        count = count + 1;
    end
    return count;
end

--判断lua文件是否存在
function ToolKit.luaFileExists(path)
   
   if(path == nil) then return false end 
   
   local storageScriptPath = System.getStorageScriptPath()
   local defaultPath = string.sub(storageScriptPath,0,string.find(storageScriptPath, "Resource", 0) + 7).."/scripts/";
         path = defaultPath..path;
   local file = io.open(path, "rb")

   if file then file:close() end
   return file ~= nil

end

-- 打印各种数据，便于查看
function ToolKit.mahjongPrint( data , dataName , spaceString )
    if not data or 1 ~= DEBUGMODE then
        printInfo("mahjongPrint : data not a vaild value");
        return;
    end
    System.setWin32ConsoleColor(0xB5E61D);
    spaceString = spaceString or "";
    dataName = dataName or "data";
    dataName = GameString.convert2UTF8(dataName) or "";
    if type(data) == "table" then
        for k , v in pairs(data) do
            if tostring(k) == "__value" then
                local outString = v or "nil";
                if type(v) == "string" then
                    outString = "\""..outString.."\"";
                end
                if type(v) == "boolean" then
                    if v then
                        outString = "true";
                    else
                        outString = "false";
                    end
                end
                printInfo(spaceString..dataName.." = "..outString);
                return;
            end
        end
        printInfo(spaceString..dataName.." = {");
        for k , v in pairs(data) do
            mahjongPrint(v , k , spaceString.."    ");
        end
        printInfo(spaceString.."}");
    else
        if type(data) == "boolean" then
            if data then
                data = "true";
            else
                data = "false";
            end
        end

        if not data then
            data = "";
        end
        -- data = GameString.convert2UTF8(data or "") or "";
        printInfo(spaceString..dataName.." : "..data);
    end
    System.setWin32ConsoleColor(0xffffff);
end