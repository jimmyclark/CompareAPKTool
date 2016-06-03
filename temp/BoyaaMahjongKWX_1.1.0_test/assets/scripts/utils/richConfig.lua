-- 富文本图片配置文件

--Lua里的转义字符: ( ) . % + - * ? [ ^ $ 
function SpecialCharSafe2Str(str)
	return string.gsub(str, "[%(%)%.%%%+%-%*%?%[%]%^%$]", 
		function(ret)
			-- Log.w("try to find special char", ret)
			ret = "%"..ret
			return ret
		end)
end

-- ctrl(id)aaaa --> id, aaaa
function SplitIdAndStr(str, ctrl)
	local ret1, ret2 = nil, nil
	string.gsub(str, ctrl.."%(%D*(%d*).*%)(.*)", function(str1, str2) ret1 = str1; ret2 = str2; end)
	return ret1, ret2
end

kRichIdStrTbl = kRichIdStrTbl or {}
__RichSharpKey = __RichSharpKey or 10000
function __getKey()
	__RichSharpKey = __RichSharpKey + 1
	return __RichSharpKey
end

function SafeToRichStr(str)
	if string.find(str, "#") then
		local key = __getKey()
		kRichIdStrTbl[key] = str
		str = "#k("..key..")"
	end
	return str
end

-- 从tbl里重新取回原本的str
function RegainStr(sharp_key)
	sharp_key = tonumber(sharp_key)
	if not sharp_key then return "" end
	local str = kRichIdStrTbl[sharp_key] or ""
	kRichIdStrTbl[sharp_key] = nil

	return str
end

--获取utf8字符串的子字符串
function utf8_substring(str, first, num)
	local ret = "";
	
	local n = string.len(str);
	local offset = 1;
	local cp;
	local b, e;
	local i = 1;
	while i <= n do
		if not b and offset >= first then
			b = i;
		end;
		if not e and offset >= first + num then
			e = i;
			break;
		end;
		cp = string.byte(str, i);
		if cp >= 0xF0 then
			i = i + 4;
			offset = offset + 2;
		elseif cp >= 0xE0 then
			i = i + 3;
			offset = offset + 2;
		elseif cp >= 0xC0 then
			i = i + 2;
			offset = offset + 2;
		else
			i = i + 1;
			offset = offset + 1;
		end;
	end;
	
	if not b then
		return "",0;
	end;
	
	if not e then
		e = n + 1;
	end;
	
	ret = string.sub(str, b, e-b);
	return ret, offset-1;
end;


-- 用来截取utf8字符串
-- utf8_sub("hi你好", 1, 3) --> hi你
-- utf8_sub("hi你好", 4, 4) --> 好 
function utf8_sub(str, u_start, u_end)
    local ret = "";

    local n = string.len(str);
    local offset = 1;
    local cp;
    local b, e;
    local i = 1;
    while i <= n do
        if not b and offset >= u_start then
            b = i;
        end;
        
        cp = string.byte(str, i);
        if cp >= 0xF0 then
            i = i + 4;
        elseif cp >= 0xE0 then
            i = i + 3;
        elseif cp >= 0xC0 then
            i = i + 2;
        else
            i = i + 1;
        end;
        offset = offset + 1;


        if not e and offset > u_end then
            e = i-1;
            break;
        end;
    end;
    
    if not b then
        return "",0;
    end;

    if not e then
        e = n;
    end;

    ret = string.sub(str, b, e);

    return ret,offset-1;
end;

function utf8_len(str)
    local n = string.len(str);
    local utf_count = 0;
    local cn, en = 0, 0
    local p_byte;
    local i = 1;
    while i <= n do
        p_byte = string.byte(str, i);
        if p_byte >= 0xF0 then
            i = i + 4;
            utf_count = utf_count + 1;
            cn = cn + 1
        elseif p_byte >= 0xE0 then
            i = i + 3;
            utf_count = utf_count + 1;
            cn = cn + 1
        elseif p_byte >= 0xC0 then
            i = i + 2;
            utf_count = utf_count + 1;
            cn = cn + 1
        else
            i = i + 1;
            utf_count = utf_count + 1;
            en = en + 1
        end;
    end;

    return utf_count, cn, en;
end;



-- string.rep(kRichUnderLine, ntimes)
kRichUnderLine = "__________________________________________________________________"

kRichImageConf = {
	------------------------ sample ------------------------
	[101] = {file="common/male_head.png", w=80,h=80,},
	
	------------------add your images below-----------------
	[102] = {file="2.0/common/femal.png", w=32,h=32},
	[103] = {file="2.0/Commonx/male.png", w=32,h=32},

	[104] = {file="2.0/common/coin_icon.png", w=45,h=45},	-- 每日登录奖励VIP金币图标配置
	[105] = {file = "common/blank.png", w=65, h=50},	-- Vip3的图标配置
	[106] = {file = "common/blank.png", w=45, h=35},	-- Vip1、Vip2的图标配置
	-- max is [999]
}
