--[[--
--麻将准备
--]]
function sendMJ_SC_GAME_READY()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_READY)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 13.57.4打牌(MJ_SC_GAME_DISCARD)
--]]
function sendMJ_SC_GAME_DISCARD(cardval)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_DISCARD)

	nMBaseMessage:writeStart()

	--cardval	short	牌值
	nMBaseMessage:writeShort(cardval);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 13.57.6操作碰/杠/胡/过牌(MJ_SC_GAME_SELECT_ACTION_OPTION)
--]]
function sendMJ_SC_GAME_SELECT_ACTION_OPTION(type, relationCards)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_SELECT_ACTION_OPTION)

	nMBaseMessage:writeStart()

	--    type	byte	0过2碰3杠4胡
	nMBaseMessage:writeByte(type);
	--relationCards int 相关的所有牌的数量 碰发3张 杠发4张
	if relationCards ~= nil then
		nMBaseMessage:writeInt(#relationCards);
		Common.log("#relationCards === "..#relationCards);
		for i = 1, #relationCards do
			--    ...cardVal	Short	牌值
			Common.log("SELECT_ACTION_OPTION === relationCards["..i.."]"..relationCards[i]);
			nMBaseMessage:writeShort(relationCards[i]);
		end
	else
		nMBaseMessage:writeInt(0);
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 13.57.10换三张(MJ_SC_GAME_SELECT_CHANGE_CARD)
--]]
function sendMJ_SC_GAME_SELECT_CHANGE_CARD(Cards)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_SELECT_CHANGE_CARD)

	nMBaseMessage:writeStart()

	--Cards	String	需要更换的三张牌	牌值用逗号隔开
	nMBaseMessage:writeString(Cards);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 13.57.13玩家定缺(MJ_SC_GAME_SELECT_DING_QUE)
--]]
function sendMJ_SC_GAME_SELECT_DING_QUE(Type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_SELECT_DING_QUE);

	nMBaseMessage:writeStart();

	--Type	Byte	定缺类型	0万，1条，2桶
	nMBaseMessage:writeByte(Type);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
-- 13.57.20牌桌同步(MJ_SC_GAME_SYNC_TABLE)
--]]
function sendMJ_SC_GAME_SYNC_TABLE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_SYNC_TABLE);

	nMBaseMessage:writeStart();

	--MainGameId	int	主游戏ID
	nMBaseMessage:writeInt(GameConfig.GAME_ID);
	--MainGameVersion	int	主游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--MiniGameVersion	int	小游戏版本号
	nMBaseMessage:writeInt(Common.getScriptVerCode(MahjongConfig.MahjongGameVersion));

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end


--[[--
-- 13.57.21解散房间申请
--]]
function sendMJ_SC_GAME_DISMISS_ROOM()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_DISMISS_ROOM);

	nMBaseMessage:writeStart();

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--13.57.22解散房间投票(MJ_SC_GAME_DISMISS_VOTE)
--]]
function sendMJ_SC_GAME_DISMISS_VOTE(IsAgreeDismiss)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_DISMISS_VOTE);

	nMBaseMessage:writeStart();

	--IsAgreeDismiss	byte	是否同意解散	0拒绝，1同意
	nMBaseMessage:writeByte(IsAgreeDismiss);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
-- 13.57.23同步自己的手牌(MJ_SC_GAME_SYNC_HAND_CARDS)
--]]
function sendMJ_SC_GAME_SYNC_HAND_CARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MJ_SC_GAME_SYNC_HAND_CARDS);

	nMBaseMessage:writeStart();

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
-- 13.57.101进入房间(MJ_SC_ROOM_ENTER_ROOM)
--]]
function sendMJ_SC_ROOM_ENTER_ROOM(tableId)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MJ_SC_ROOM_ENTER_ROOM);

	nMBaseMessage:writeStart();

	--tableId	Int	房号
	nMBaseMessage:writeInt(tableId);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--13.57.102聊天
function sendMJ_SC_ROOM_CHAT(type ,msg)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_ROOM_CHAT)

	nMBaseMessage:writeStart()

	--类型	1=快捷文字，2=高级表情，3=文字
	nMBaseMessage:writeByte(type)
	--聊天内容
	nMBaseMessage:writeString(msg)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--13.57.103距离警告
function sendMJ_SC_DISTANCE_ALERT()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_DISTANCE_ALERT)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--13.57.104 牌桌内个人信息
function sendMJ_SC_MGR_PLAYER_INFO_IN_TABLE(userId)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_PLAYER_INFO_IN_TABLE)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeInt(userId)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--13.57.105赠送魔法表情
function sendMJ_SC_SEND_MAGIC(userId, mofaID)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_SEND_MAGIC)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeInt(userId)
	nMBaseMessage:writeInt(mofaID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end









------------------------------------------------------------

--[[--
--1.1进入房间
--]]
function sendMJ_SC_MGR_ENTER_ROOM(roomCode)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_ENTER_ROOM)
	nMBaseMessage:writeStart()
	--roomCode	Int	房号
	nMBaseMessage:writeInt(roomCode)
	--MiniGameVer	Int	小游戏版本号
	nMBaseMessage:writeInt(Common.getScriptVerCode(MahjongConfig.MahjongGameVersion))
    --GameId	Int	游戏版本号
    nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--1.2退出房间
--]]
function sendMJ_SC_MGR_QUIT_ROOM()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_QUIT_ROOM)
	nMBaseMessage:writeStart()

    --GameId	Int	游戏版本号
    nMBaseMessage:writeInt(GameConfig.GAME_ID)
    --MiniGameVer	Int	小游戏版本号
    nMBaseMessage:writeInt(Common.getScriptVerCode(MahjongConfig.MahjongGameVersion))

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 1.3建立房间
function sendMJ_SC_MGR_CREATE_ROOM(gamesValue, fanValue, ziMoValue, dianGangHua, huangSanZhang, yaoJiu, menQing, tianDiHu, roomType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_CREATE_ROOM)

	nMBaseMessage:writeStart()

	-- Jushu	Int	局数
	nMBaseMessage:writeInt(tonumber(gamesValue))
	-- Fan	Int	番
	nMBaseMessage:writeInt(tonumber(fanValue))
	-- ZiMo	Int	自摸	1=自摸加底，2=自摸加番
	nMBaseMessage:writeInt(tonumber(ziMoValue))
	-- DianGangHua	Int	点杠花	1=点炮，2=自摸
	nMBaseMessage:writeInt(tonumber(dianGangHua))
	-- HuanSanZhang	Int	胡三张	0=否，1=是
	nMBaseMessage:writeInt(tonumber(huangSanZhang))
	-- yaoJiuJiangDui	Int	幺九将对	0=否，1=是
	nMBaseMessage:writeInt(tonumber(yaoJiu))
	-- MenQing	Int	门清中张	0=否，1=是
	nMBaseMessage:writeInt(tonumber(menQing))
	-- TianDiHu	Int	天地胡	0=否，1=是
	nMBaseMessage:writeInt(tonumber(tianDiHu))
    --GameId	Int	游戏版本号
    nMBaseMessage:writeInt(GameConfig.GAME_ID)
    --MiniGameVer	Int	小游戏版本号
    nMBaseMessage:writeInt(Common.getScriptVerCode(MahjongConfig.MahjongGameVersion))
    --GameVer	Int	主游戏版本号
    nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
    --RoomType	Int	房间类型	1=备战到底，2=德阳麻将
    nMBaseMessage:writeInt(roomType)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.5牌桌选项
function sendMJ_SC_MGR_CREATE_OPTION()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_CREATE_OPTION)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end





