
--[[
	适配方案为以最小比例拉伸，微调拉伸差值
	control 为控件
	adaptXY == 0 或nil 则x y都微调
	adaptXY == 1 则x微调
	adaptXY == 2 则y微调
--]]
function makeTheControlAdaptResolution( control , adaptXY)
	if not adaptXY then
		adaptXY = 0;
	end
	local mahjongScaleHeight_x = System.getScreenScaleWidth()
	local mahjongScaleHeight_y = System.getScreenScaleHeight()
	if mahjongScaleHeight_y > mahjongScaleWidth_x then
		if 1 == adaptXY then
			return;
		end
		local height = control.m_height;
		local y1 = control.m_y / mahjongScaleWidth_x;
		local y2 = MahjongLayout_H - y1 - control.m_height;
		local offset = (height * mahjongScaleHeight_y - height * mahjongScaleWidth_x) / 2;
		local y = control.m_y * mahjongScaleHeight_y / mahjongScaleWidth_x;
		control:setPos(control.m_x / mahjongScaleWidth_x, (y + offset) / mahjongScaleWidth_x);
	else
		if 2 == adaptXY then
			return;
		end
		local width = control.m_width;
		local offset = (width * mahjongScaleWidth_x - width * mahjongScaleHeight_y) / 2;
		local x = control.m_x * mahjongScaleWidth_x / mahjongScaleHeight_y;
		control:setPos((x + offset) / mahjongScaleHeight_y , control.m_y / mahjongScaleHeight_y);
	end
end

function isPlatform_Win32()
	local platform = System.getPlatform()
	return platform == kPlatformWin32
end

function isPlatform_Anroid()
	local platform = System.getPlatform()
	return platform == kPlatformAndroid
end

function isPlatform_IOS()
	local platform = System.getPlatform()
	return platform == kPlatformIOS
end

-- 获得字符串的长度
function getStringLen( aString )
	if not aString or aString == "" then
		return 0;
	end 
	local n = string.len(aString);
	local offset = 0;
	local cp ;
	local i = 1;
	while i <= n do
		cp = string.byte(aString, i);
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
		end
	end
	return offset;
end

function getSubString(aString, len)
	-- body
	if not aString or aString == "" then
		return 0;
	end 
	local n = string.len(aString);
	local offset = 0;
	local cp ;
	local i = 1;
	local substr = ""
	while i <= n do
		cp = string.byte(aString, i);
		substr = substr .. cp
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
		end
		if offset >= len then return substr end
	end

	return substr;


end