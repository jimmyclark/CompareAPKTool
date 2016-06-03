
function global_http_readUrlFile(url, callback)
	require("common/downAddReadFile")
	local request = new(DownAddReadFile, url , 5000)
	request:setEvent(callback)
	request:execute()
end

function global_http_downloadImage(url, folder, name, callback)
	NativeEvent.getInstance():downloadImage(url, folder, name, callback);
end

--[[
	获取商品列表
]]
function globalRequestChargeList(force)
	-- 根据平台来决定怎么拉取商品列表
	PlatformManager:executeAdapter(PlatformManager.s_cmds.RequestChargeList, force);
end


--[[
	支付入口
]]
function globalRequestCharge(data)
	local goodsInfo = {};
	goodsInfo.id = data.id;
	goodsInfo.pamount = data.pamount;
	-- goodsInfo.ptype = data:getPtype();
	-- goodsInfo.pname = data:getPname();
	-- PayController:showPaySelectWindow(goodsInfo)
	PayController:payForGoods(true, goodsInfo, true)
end