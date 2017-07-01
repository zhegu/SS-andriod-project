--[[--
--心跳消息
--]]
function sendIdleMsg()
    if Services:getMessageService():getCutOut() then
        return
    end
    local nMBaseMessage = NMBaseMessage:new();
    nMBaseMessage:setMessageType(0);
    nMBaseMessage:writeStart();
    nMBaseMessage:writeByte(6);
    nMBaseMessage:writeOver();
    local messageService = Services:getMessageService();
    messageService:sendMessage(nMBaseMessage);
    nMBaseMessage:delete();
end

--[[-------------------------推送老虎机限时礼包------------------------]]
function sendGIFTBAGID_PUSH_LIMITED_GIFTBAG()
	Common.log("限时礼包请求")

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_PUSH_LIMITED_GIFTBAG)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------小游戏聊天室IM_ID消息----------------------]]

--[[--
--进入小游戏聊天室
--]]
function sendIMID_MINI_ENTER_CHAT_ROOM(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_ENTER_CHAT_ROOM)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型  1 水果机 2 金皇冠 3 …
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--退出小游戏聊天室
--]]
function sendIMID_MINI_QUIT_CHAT_ROOM(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_QUIT_CHAT_ROOM)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型  1 水果机 2 金皇冠 3 …
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--小游戏发送消息
--]]
function sendIMID_MINI_SEND_MESSAGE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_SEND_MESSAGE)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型  1 水果机 2 金皇冠 3 …
	nMBaseMessage:writeByte(dataTable["MiniGameType"])
	--MessageContent	Text	消息内容
	nMBaseMessage:writeString(dataTable["MessageContent"])
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------打赏模块 REWARDS 消息----------------------]]
--[[--
--请求小游戏打赏基本信息(MINI_REWARDS_BASEINFO)
--]]
function sendIMID_MINI_REWARDS_BASEINFO(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_BASEINFO)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求小游戏打赏(MINI_REWARDS_RESULT)
--]]
function sendIMID_MINI_REWARDS_RESULT(MiniGameType, RewardType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_RESULT)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型
	nMBaseMessage:writeByte(MiniGameType)
	--RewardType	byte	红包类型	1 小 2 大
	nMBaseMessage:writeByte(RewardType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求小游戏打赏领奖 (MINI_REWARDS_COLLECT)
--]]
function sendIMID_MINI_REWARDS_COLLECT(MiniGameType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_REWARDS_COLLECT)

	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--MiniGameType 小游戏类型
	nMBaseMessage:writeByte(MiniGameType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--小游戏领取打赏V3 (IMID_MINI_GET_REWARDS_V3)
--]]
function sendIMID_MINI_GET_REWARDS_V3(MiniGameType, CheckCode)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_MINI_GET_REWARDS_V3)

	nMBaseMessage:writeStart()

	--MiniGameType	Byte	小游戏类型	1 老虎机 2金皇冠 3…
	nMBaseMessage:writeByte(MiniGameType)
	--CheckCode	Int	验证码	发话者ID
	nMBaseMessage:writeInt(CheckCode)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--------------------小游戏赚金榜----------------------
--
--[[--
--3.16.35 获取小游戏赚金榜（COMMONS_GET_MINI_GAME_EARN_RANK)
--@param #byte 		day  		1今天2昨天
--@param #string 	Timestamp   时间戳
--]]--
function sendCOMMONS_GET_MINI_GAME_EARN_RANK(day,Timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_MINI_GAME_EARN_RANK)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(day)
	nMBaseMessage:writeInt(GameLoadModuleConfig.getLoadModuleGameID())
	nMBaseMessage:writeString(Timestamp)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.15.97扎金花发送大喇叭(OPERID_MGR_SEND_BUGLE）
function sendOPERID_MGR_SEND_BUGLE(Message)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_MGR_SEND_BUGLE)
	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Message	Text	发送文字
	nMBaseMessage:writeString(Message)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendOPERID_MGR_SEND_BUGLE")
end

--3.7.149保险箱info (MANAGERID_STRONG_BOX_INFO)
function sendMANAGERID_STRONG_BOX_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_STRONG_BOX_INFO)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendMANAGERID_STRONG_BOX_INFO")
end

--3.7.150保险箱存钱 (MANAGERID_SAVE_TAKE_STRONG_BOX_COIN)
function sendMANAGERID_SAVE_TAKE_STRONG_BOX_COIN(Coin,Type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_SAVE_TAKE_STRONG_BOX_COIN)
	nMBaseMessage:writeStart()
	--Coin	Long	单次不能存取太多金币
	nMBaseMessage:writeLong(Coin)
	--Type	Byte	操作类型	1存钱2取钱
	nMBaseMessage:writeByte(Type)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendMANAGERID_SAVE_TAKE_STRONG_BOX_COIN")
end

--[[--
--3.7.163 小游戏列表V3(MANAGERID_MINIGAME_LIST_TYPE_V3)
--]]--
function sendMANAGERID_MINIGAME_LIST_TYPE_V3(TimeStamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();

	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LIST_TYPE_V3);

	nMBaseMessage:writeStart();

	--GameID	byte	发起登录的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--VersionCode	Int	游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--TimeStamp	Long	时间戳
	nMBaseMessage:writeLong(TimeStamp);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--3.15.114 自定义事件(OPERID_CUSTOM_EVENT)
function sendOPERID_CUSTOM_EVENT(eventId)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_CUSTOM_EVENT)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--eventId	Int	事件id	服务器定义的事件常量
	nMBaseMessage:writeInt(eventId)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end