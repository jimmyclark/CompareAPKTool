local entryRoomPopu = class(require("popu.gameWindow"))


function entryRoomPopu:initView(data)
  
  	self.m_curEntryNum = 0
  	self.m_roomNumber = {}
    --local closeBtn = self:findChildByName("btn_Close");
    --closeBtn:setOnClick(self,function (self)
        --body
    --   self:dismiss();
    --end)

	for i = 0, 9 do
		self:findChildByName("btn_num"..i):setOnClick(self, function( self )

			if 6 > self.m_curEntryNum then	
				local numFile = "kwx_tanKuang/bankrupt/"..i..".png"
				self.m_curEntryNum = self.m_curEntryNum + 1
				local img_num = self:findChildByName("img_num"..self.m_curEntryNum)
				local entryNum = new(Image, numFile)
				entryNum:setAlign(kAlignCenter)
				img_num:addChild(entryNum)

				table.insert(self.m_roomNumber, i)

				if 6 <= self.m_curEntryNum then
					local entryStr = ""
					for i = 1, #self.m_roomNumber do
						entryStr = entryStr..self.m_roomNumber[i]
					end

					GlobalRoomLoading:play()
				    GameSocketMgr:sendMsg(Command.JoinGameReq, {
						iGameType = GameType.KWXMJ,
						iMoney = MyUserData:getMoney(),
						iUserInfoJson = json.encode(MyUserData:packPlayerInfo()),
						iMtKey = MyUserData:getMtkey(),
						iOriginAPI = PhpManager:getApi(),
						iVersion = PhpManager:getVersionCode(),
						iVersionName = PhpManager:getVersionName(),
						iChangeDesk = 0,
						iQuickStart = 0,
						iLevel = 21,
						iFid = tonumber( entryStr ),
					})
				end

			end

			if 0 < self.m_curEntryNum then
				self:findChildByName("btn_del"):setIsGray(false)
			end
		end)
	end

	self:findChildByName("btn_del"):setOnClick(self, function( self )

		if 0 < self.m_curEntryNum then				
			self:findChildByName("img_num"..self.m_curEntryNum):removeAllChildren()
			self.m_curEntryNum = self.m_curEntryNum - 1
			table.remove(self.m_roomNumber, #self.m_roomNumber)
		end

		if 0 >= self.m_curEntryNum then
			self:findChildByName("btn_del"):setIsGray(true)
		end
	end)

	self:findChildByName("btn_del"):setIsGray(true)
    
end

function entryRoomPopu:dismiss(...)
    return entryRoomPopu.super.dismiss(self, ...)
end

function entryRoomPopu:onCloseBtnClick( ... )
	-- body
	if self.closeFunc then
		self.closeFunc()
	end
	self.dismiss(true, true)
end


return entryRoomPopu