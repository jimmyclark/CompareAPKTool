--[[
	通用的（大厅）发送协议  2015-03-03
]]
local CommonWriter = class(SocketWriter)
local printInfo, printError = overridePrint("CommonWriter")


function CommonWriter:onSendHeadBeat(packetId, data)
	printInfo("发送心跳包")
end

function CommonWriter:onSendPHPRequest(packetId, param)
	local cmd 	= param.cmd
	local data 	= PhpManager:getBasic(cmd)
	local compress = 0
	PhpManager:mergeApiParams(data.api, param)
	printInfo("========[[ 发送PHP命令 0x%04x 是否压缩 %d ]] ============================", cmd or 0, compress or 0)
	dump(data)
	self.m_socket:writeInt(packetId, cmd)
	self.m_socket:writeBinary(packetId, json.encode(data), compress)
end

function CommonWriter:onRequestLoginLobby(packetId, param)
	param = param or {
		iUserId 		= MyUserData:getId(),
		iUserStatus 	= 0,
		iOriginAPI 		= PhpManager:getApi(),
		iVersionName 	= PhpManager:getVersionName(),
		iUserName		= MyUserData:getNick(),
	}
	self.m_socket:writeInt(packetId, param.iUserId);
    self.m_socket:writeShort(packetId, param.iUserStatus);
    self.m_socket:writeInt(packetId, param.iOriginAPI);
    self.m_socket:writeString(packetId, param.iVersionName);
    self.m_socket:writeString(packetId, param.iUserName);
end

--登出大厅  0x102
function CommonWriter:onLogoutLobbyReq(packetId, param)

end

function CommonWriter:onJoinRoomReq(packetId, param)
 	-- self.m_socket:writeInt(packetId,  param.iGameType);
 	self.m_socket:writeShort(packetId, param.iLevel or 0);
	self.m_socket:writeInt(packetId,  param.iMoney);
  	self.m_socket:writeInt(packetId,  0);
  	-- 整合以前登录房间需要的信息
  	self.m_socket:writeShort(packetId,  3);
  	self.m_socket:writeString(packetId,  param.iUserInfoJson);
  	self.m_socket:writeString(packetId,  param.iMtKey);
  	self.m_socket:writeInt(packetId,  param.iOriginAPI);
  	self.m_socket:writeInt(packetId,  param.iVersion);
  	self.m_socket:writeString(packetId,  param.iVersionName);
  	self.m_socket:writeShort(packetId, -1)
  	self.m_socket:writeShort(packetId, 1)

  	if param.iFid then
  		self.m_socket:writeInt(packetId,  param.iFid);
  	end
end

function CommonWriter:onChangeDeskReq(packetId, param)
	self.m_socket:writeInt(packetId, param.iChangeType or 0)
	self.m_socket:writeInt(packetId, param.iQuickStart or 1)
end

function CommonWriter:onLobbyOnlineReq(packetId, param)

end

-- 请求准备
function CommonWriter:onRequestReady(packetId)
	-- 空包
end

function CommonWriter:onSendChat(packetId, param)
	self.m_socket:writeString(packetId, param.iChatInfo)
end

function CommonWriter:onSendFace(packetId, param)
	self.m_socket:writeInt(packetId, param.iFaceType)
end

function CommonWriter:onSendProp(packetId, param)
	self.m_socket:writeInt(packetId, param.a_uid);
	self.m_socket:writeInt(packetId, param.p_id);
	self.m_socket:writeInt(packetId, 1);
	self.m_socket:writeInt(packetId, param.b_uid);
end

function CommonWriter:onLogoutRoomReq(packetId, param)
	-- 空包
	local tips = "exit"
end

function CommonWriter:onRequestOutCard(packetId, param)
	dump(param, "出牌=============")
	self.m_socket:writeByte(packetId, param.iCard)
	self.m_socket:writeShort(packetId, param.iIsLiang)
	if 1 == param.iIsLiang then
		self.m_socket:writeInt(packetId, #param.iNoLiangCards)
		for k, v in pairs(param.iNoLiangCards) do
			self.m_socket:writeByte(packetId, v.iCard)
			self.m_socket:writeByte(packetId, v.iCount)
		end
	end
end

function CommonWriter:onRequestOperate(packetId, param)
	self.m_socket:writeInt(packetId, param.iOpValue)
	self.m_socket:writeByte(packetId, param.iCard)
end

function CommonWriter:onRequestAi(packetId, param)
	self.m_socket:writeInt(packetId, param.iAiType)
end

function CommonWriter:onSwapCardReq(packetId, cards)
	self.m_socket:writeByte(packetId, #cards)
	for i=1, #cards do
		self.m_socket:writeByte(packetId, cards[i])
	end
end

function CommonWriter:onFreshMoneyReq(packetId, params)
	self.m_socket:writeInt(packetId, 1)
	self.m_socket:writeShort(packetId, 0x0001)
	self.m_socket:writeInt(packetId, params.iUserId)
end

function CommonWriter:onNoticeMoneyChangeReq(packetId, params)
	self.m_socket:writeInt(packetId, params.iUserId)
end

function CommonWriter:onDoneSelectPiao(packetId, params)
	self.m_socket:writeInt(packetId, params.iPiao)
end

function CommonWriter:onUserUpdateUserInfo(packetId, params)
	self.m_socket:writeInt(packetId, params.iUserId)
	self.m_socket:writeString(packetId, params.iUserInfo)
end

function CommonWriter:onFriendInfoReq(packetId, params)
	if Command.FRIEND_CMD_ENDTY_CHANNEL == params.command then
		self.m_socket:writeShort(packetId, params.command)
		self.m_socket:writeInt(packetId, params.iUserId)
		self.m_socket:writeInt(packetId, params.iChannelId)

	elseif Command.FRIEND_CMD_EXIT_CHANNEL == params.command then
		self.m_socket:writeShort(packetId, params.command)
		self.m_socket:writeInt(packetId, params.iUserId)
		self.m_socket:writeInt(packetId, params.iChannelId)

	elseif Command.FRIEND_CMD_ADD_CHANNEL_FRI == params.command then
		self.m_socket:writeShort(packetId, params.command)
		self.m_socket:writeInt(packetId, params.iUserId)
		self.m_socket:writeInt(packetId, #params.iUserList)
		for i = 1, #params.iUserList do
			self.m_socket:writeInt(packetId, params.iUserId[i])
		end
		
	end
	
end

function CommonWriter:onCreateRoomReq(packetId, params)
	self.m_socket:writeShort(packetId, params.iLevel)
	self.m_socket:writeInt(packetId, params.iChip)
	self.m_socket:writeInt(packetId, params.iSid)
	self.m_socket:writeShort(packetId, params.iUserCount)

	self.m_socket:writeString(packetId, params.iInfo)
	self.m_socket:writeString(packetId, params.iMtKey)
	self.m_socket:writeInt(packetId, params.iFrom)
	self.m_socket:writeInt(packetId, params.iVersion)
	self.m_socket:writeString(packetId, params.iVersionName)
	self.m_socket:writeShort(packetId, params.iLoginWay)
	self.m_socket:writeShort(packetId, params.iReady)
	self.m_socket:writeShort(packetId, params.iMjCode)
	self.m_socket:writeShort(packetId, params.iRoundNum)
	self.m_socket:writeShort(packetId, params.iPlayType)
	self.m_socket:writeShort(packetId, params.iBaseInfo)
	self.m_socket:writeShort(packetId, params.iKwxBei)
	self.m_socket:writeByte(packetId, params.iChangeNum)
	self.m_socket:writeByte(packetId, params.iIsPiao)
end

function CommonWriter:onExitPrivateRoomReq( packetId, params )
	self.m_socket:writeInt(packetId, params.iUserId)
end

function CommonWriter:onExitPrivateRoomHandlerReq( packetId, params )
	self.m_socket:writeInt(packetId, params.iUserId)
	self.m_socket:writeInt(packetId, params.iOpUid)
	self.m_socket:writeInt(packetId, params.iOpt)
end
--[[
	通用的（大厅）发送协议
]]
CommonWriter.s_clientCmdFunMap = {
	[Command.HeatBeatReq]		= CommonWriter.onSendHeadBeat,
	[Command.PHP_CMD_REQUEST]	= CommonWriter.onSendPHPRequest,
	-- 大厅相关
	[Command.LoginLobbyReq]		= CommonWriter.onRequestLoginLobby,
	[Command.LogoutLobbyReq]	= CommonWriter.onLogoutLobbyReq,
	[Command.LobbyOnlineReq]	= CommonWriter.onLobbyOnlineReq,
	-- 新版 加入房间 0x119  返回 0x1007 和 0x1005
	[Command.JoinGameReq]   	= CommonWriter.onJoinRoomReq;
	-- [Command.requestJoinRoom]   = CommonWriter.requestJoinRoom;
	[Command.ChangeDeskReq]   	= CommonWriter.onChangeDeskReq;
	-- 房间相关
	[Command.ReadyReq]   		= CommonWriter.onRequestReady;
	[Command.SendChat]          = CommonWriter.onSendChat,
	[Command.SendFace]          = CommonWriter.onSendFace,
	[Command.SendProp]          = CommonWriter.onSendProp,

	[Command.LogoutRoomReq]		= CommonWriter.onLogoutRoomReq,
	[Command.RequestOutCard]	= CommonWriter.onRequestOutCard,
	[Command.RequestOperate]	= CommonWriter.onRequestOperate,
	[Command.RequestAi]			= CommonWriter.onRequestAi,
	[Command.CLIENT_COMMAND_PIAO] = CommonWriter.onDoneSelectPiao,

	-- 换三张
	[Command.SwapCardReq]		= CommonWriter.onSwapCardReq,

	-- 请求更新金币
	[Command.FreshMoneyReq]		= CommonWriter.onFreshMoneyReq,

	-- 通知server金币变动
	[Command.NoticeMoneyChangeReq] = CommonWriter.onNoticeMoneyChangeReq,
	-- 房间内广播用户变动的信息
	[Command.CLIENT_COMMAND_UPDATE_USER_INFO] = CommonWriter.onUserUpdateUserInfo,

	-- 好友相关
	[Command.SERVER_COMMAND_FRIEND_REQ] = CommonWriter.onFriendInfoReq,
	-- 好友对战申请创建房间
	[Command.SERVER_CREATEROOM_REQ] = CommonWriter.onCreateRoomReq,
	--申请退出私人房
	[Command.SERVER_EXIT_PRIVATEROOM_REQ] = CommonWriter.onExitPrivateRoomReq,
	[Command.SERVER_EXIT_PRIVATEROOM_HANDLER_REQ] = CommonWriter.onExitPrivateRoomHandlerReq,
}

return CommonWriter