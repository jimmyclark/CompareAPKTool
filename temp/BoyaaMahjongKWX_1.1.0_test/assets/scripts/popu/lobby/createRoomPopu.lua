local createRoomPopu = class(require("popu.gameWindow"))


function createRoomPopu:initView(data)	

	-- MyCreateRoomCfg:setRoundNumId(tonumber(tempList[i].key))
	-- MyCreateRoomCfg:setBeiId(tonumber(tempList[i].key))
	-- MyCreateRoomCfg:setPlayTypeId(tonumber(tempList[i].key))

	local tempList1 = MyCreateRoomCfg:getRoundNum()
	local configNum = 0
	if tempList1 and 0 < #tempList1 then 
		configNum = #tempList1 
		MyCreateRoomCfg:setRoundNumId(tempList1[1].key)	-- 默认第一项
		self:findChildByName("btn_js1"):setFile("kwx_tanKuang/login/img_sigle.png")
	end
	for i = 1, 4 do
		local btn = self:findChildByName("btn_js"..i);
		local text = self:findChildByName("text_jsinfo"..i)
		if i <= configNum then
			text:setText(tempList1[i].name)
			btn:setOnClick(self, function( self )
				if configNum > 4 then configNum = 4 end
				for j = 1, configNum do
					self:findChildByName("btn_js"..j):setFile("kwx_tanKuang/login/img_check.png")
				end
				btn:setFile("kwx_tanKuang/login/img_sigle.png")
				MyCreateRoomCfg:setRoundNumId(tempList1[i].key)
			end)
		else
			btn:hide()
			text:hide()
		end
	end

	tempList = {}
	tempList = MyCreateRoomCfg:getBei()
	local configNum = 0
	if tempList and 0 < #tempList then 
		configNum = #tempList 
		MyCreateRoomCfg:setBeiId(tempList[1].key)	-- 默认第一项
		self:findChildByName("btn_bs1"):setFile("kwx_tanKuang/login/img_sigle.png")
	end

	for i = 1, 2 do
		local btn = self:findChildByName("btn_bs"..i);
		local text = self:findChildByName("text_bsinfo"..i)
		if i <= configNum then
			text:setText("卡五星"..tempList[i].name)
			btn:setOnClick(self, function( self )
				if configNum > 2 then configNum = 2 end
				for j = 1, configNum do
					self:findChildByName("btn_bs"..j):setFile("kwx_tanKuang/login/img_check.png")
				end
				btn:setFile("kwx_tanKuang/login/img_sigle.png")
				MyCreateRoomCfg:setBeiId(tonumber(tempList[i].key))
			end)
		else
			btn:hide()
			text:hide()
		end
	end


	local btn_piao = self:findChildByName("btn_type1")
	btn_piao:setFile("kwx_tanKuang/login/img_checked.png")
	MyCreateRoomCfg:setPlayTypeId(1)
	btn_piao:setOnClick(self, function( self )
		if 1 == MyCreateRoomCfg:getPlayTypeId() then
			btn_piao:setFile("kwx_tanKuang/login/img_check.png")
			MyCreateRoomCfg:setPlayTypeId(0)
		else
			btn_piao:setFile("kwx_tanKuang/login/img_checked.png")
			MyCreateRoomCfg:setPlayTypeId(1)
		end
	end)

	-- tempList = {}
	-- tempList = MyCreateRoomCfg:getPlayType()
	-- local configNum = 0
	-- if tempList then configNum = #tempList end
	-- for i = 1, 2 do
	-- 	local btn = self:findChildByName("btn_type"..i);
	-- 	local text = self:findChildByName("text_type"..i)
	-- 	if GameMode.Piao == tempList[i].key then
	-- 		text:setText(tempList[i].name)
	-- 		btn:setOnClick(self, function( self )
	-- 			for j = 1, configNum do
	-- 				self:findChildByName("btn_type"..j):setFile("kwx_tanKuang/login/img_check.png")
	-- 			end
	-- 			btn:setFile("kwx_tanKuang/login/img_checked.png")
	-- 			MyCreateRoomCfg:setPlayTypeId(tonumber(tempList[i].key))
	-- 		end)
	-- 	else
	-- 		btn:hide()
	-- 		text:hide()
	-- 	end
	-- end
    
    self:findChildByName("btn_create"):setOnClick(self, function( self )

    	if 0 >= MyUserData:getJewel() then
	    	WindowManager:showWindow(WindowTag.RechargePopu, {
						goodsIndex = 1,
						chargeType =  ChargeType.JewelCharge,
					});

    	else

      		GlobalRoomLoading:play()
	    	GameSocketMgr:sendMsg(Command.SERVER_CREATEROOM_REQ, {
	    		iLevel = 21,
	    		iChip = 0,
	    		iSid = 0,
	    		iUserCount = 3,
	    		iInfo = json.encode(MyUserData:packPlayerInfo()),
	    		iMtKey = MyUserData:getMtkey(),
	    		iFrom = PhpManager:getApi(),
	    		iVersion = PhpManager:getVersionCode(),
	    		iVersionName = PhpManager:getVersionName(),
	    		iLoginWay = 0,
	    		iReady = 1,
	    		iMjCode = GameType.KWXMJ,
	    		iRoundNum = MyCreateRoomCfg:getRoundNumId(),
	    		iPlayType = 0,
	    		iBaseInfo = MyCreateRoomCfg:getBasePointId(),
	    		iKwxBei = MyCreateRoomCfg:getBeiId(),
	    		iChangeNum = 0,
	    		iIsPiao = MyCreateRoomCfg:getPlayTypeId(),
			})
	    end
    end)
end

function createRoomPopu:dismiss(...)
    return createRoomPopu.super.dismiss(self, ...)
end

function createRoomPopu:onCloseBtnClick( ... )
	-- body
	if self.closeFunc then
		self.closeFunc()
	end
	self.dismiss(true, true)
end


return createRoomPopu