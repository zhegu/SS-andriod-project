--[[--
-- 推送牌桌变化
-- ]]
function read80570001(nMBaseMessage)
	Common.log("牌桌变化 =========== ");

	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_TABLE_CHANGE;
	dataTable["messageName"] = "MJ_SC_GAME_TABLE_CHANGE";
	--    TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    roomId	Int	房间ID
	dataTable["roomId"] = tonumber(nMBaseMessage:readInt());
	--    tableId	Int	牌桌ID
	dataTable["tableId"] = tonumber(nMBaseMessage:readInt());
	--    tableType	Int	房间类型
	dataTable["tableType"] = tonumber(nMBaseMessage:readInt());
	--    RoomOwnerSeatID	int	房主位置
	dataTable["RoomOwnerSeatID"] = nMBaseMessage:readByte();

	--Loop	玩家信息
	local UserSize = tonumber(nMBaseMessage:readInt());
	dataTable["UserInfo"] = {};
	for i = 1, UserSize do
		dataTable["UserInfo"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--    ...userId	Int	玩家ID
		dataTable["UserInfo"][i].userId = tonumber(nMBaseMessage:readInt());
		--    ...photoUrl	Text	玩家昵称
		dataTable["UserInfo"][i].photoUrl = nMBaseMessage:readString();
		--    ...seatID	Int	座位号
		dataTable["UserInfo"][i].seatID = nMBaseMessage:readByte();
		--    ...score	Long	积分（金币数）
		dataTable["UserInfo"][i].score = tonumber(nMBaseMessage:readLong());
		--    ...vipLv	Int	Vip等级
		dataTable["UserInfo"][i].vipLv = tonumber(nMBaseMessage:readInt());
		--    ...sex	Byte	性别	0=未知，1男，2女
		dataTable["UserInfo"][i].sex = nMBaseMessage:readByte();
		--...Name	Text
		dataTable["UserInfo"][i].Name = nMBaseMessage:readString();


		nMBaseMessage:setReadPos(pos + length)
	end
	--	RoomTitle	Text	房间标题
	dataTable["RoomTitle"] = nMBaseMessage:readString();
	--	endTimeStamp	Long	房间结束时间戳
	dataTable["endTimeStamp"] = tonumber(nMBaseMessage:readLong());

	return dataTable
end

--[[--
-- 推送准备
-- ]]
function read80570002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_READY;
	dataTable["messageName"] = "MJ_SC_GAME_READY";

	--    TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	--    SeatID	byte
	dataTable["SeatID"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
-- 推送发牌
-- ]]
function read80570003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SEND_CARD;
	dataTable["messageName"] = "MJ_SC_GAME_SEND_CARD";

	--    TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	--    SeatID	byte
	dataTable["SeatID"] = nMBaseMessage:readByte();
	--    FistWaitTime	int	庄家首次出牌时间	15s
	dataTable["FistWaitTime"] = tonumber(nMBaseMessage:readInt());
	--    BaseWaitTime	int	出牌等待时间	10s
	dataTable["BaseWaitTime"] = tonumber(nMBaseMessage:readInt());
	--    AskWaitTime	int	询问等待时间	10s
	dataTable["AskWaitTime"] = tonumber(nMBaseMessage:readInt());

	--Loop	掷骰子次数	2
	local ThrowCnt = tonumber(nMBaseMessage:readInt());
	dataTable["ThrowInfo"] = {};
	for i = 1, ThrowCnt do
		dataTable["ThrowInfo"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--    …DiceCnt	...loop	骰子个数	2
		local DiceCnt = tonumber(nMBaseMessage:readInt());
		for j = 1, DiceCnt do
			dataTable["ThrowInfo"][i][j] = {};
			local length = nMBaseMessage:readShort();
			local pos = nMBaseMessage:getReadPos();

			--    ……DiceNum	......byte	骰子点数
			dataTable["ThrowInfo"][i][j].DiceNum = nMBaseMessage:readByte();

			nMBaseMessage:setReadPos(pos + length);
		end
		nMBaseMessage:setReadPos(pos + length);
	end

	--    DealerSeat	byte	庄家座位号
	dataTable["DealerSeat"] = nMBaseMessage:readByte();
	--    LeaveCardsCnt	byte	剩余牌数量
	dataTable["LeaveCardsCnt"] = nMBaseMessage:readByte();
	--    CardCnt	Loop	牌数13张
	local CardCnt = tonumber(nMBaseMessage:readInt());
	dataTable["CardInfo"] = {};
	for i = 1, CardCnt do
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--    …CardVal	Short	牌值
		dataTable["CardInfo"][i] = nMBaseMessage:readShort();

		nMBaseMessage:setReadPos(pos + length);
	end
	--CurrInning	byte	当前第几局
	dataTable["CurrInning"] = nMBaseMessage:readByte();
	--TotalInning	byte	一共多少局
	dataTable["TotalInning"] = nMBaseMessage:readByte();

	--Seatloop	Loop	玩家信息
	local userScoreSize = tonumber(nMBaseMessage:readInt());
	dataTable["userScore"] = {};
	for i = 1, userScoreSize do
		dataTable["userScore"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--...SeatID	byte	座位号
		dataTable["userScore"][i].SeatID = nMBaseMessage:readByte();
		--...score	Long	积分（金币数）
		dataTable["userScore"][i].score = tonumber(nMBaseMessage:readLong());

		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
-- 推送打牌
-- ]]
function read80570004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_DISCARD;
	dataTable["messageName"] = "MJ_SC_GAME_DISCARD";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    SeatID	byte	出牌者的座位号
	dataTable["SeatID"] = nMBaseMessage:readByte();
	--    CardVal	Short	出牌者出的牌值
	dataTable["CardVal"] = nMBaseMessage:readShort();
	return dataTable
end

--[[--
-- 推送操作询问(MJ_SC_GAME_SEND_ACTION_OPTION)
-- ]]
function read80570005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SEND_ACTION_OPTION;
	dataTable["messageName"] = "MJ_SC_GAME_SEND_ACTION_OPTION";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    CardVal	Short	出牌者出的牌值	也可以是自己抓的牌
	dataTable["CardVal"] = nMBaseMessage:readShort();
	--    isChi	Byte	是否可以吃	0否1是
	dataTable["isChi"] = nMBaseMessage:readByte();
	--    isPeng	byte	是否可以碰	0否1是
	dataTable["isPeng"] = nMBaseMessage:readByte();
	--    isHu	byte	是否可以胡	0否 1是
	dataTable["isHu"] = nMBaseMessage:readByte();
	--    isGang	Byte	是否可以杠	0否 1是
	dataTable["isGang"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
-- 推送操作碰/杠/胡/过牌(MJ_SC_GAME_SELECT_ACTION_OPTION)
-- ]]
function read80570006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SELECT_ACTION_OPTION;
	dataTable["messageName"] = "MJ_SC_GAME_SELECT_ACTION_OPTION";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    Result	Byte	操作结果	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte();
	--    Message	Text	操作提示
	dataTable["Message"] = nMBaseMessage:readString();

	return dataTable
end

--[[--
-- 广播操作结果(MJ_SC_GAME_ACTION_BROADCAST)
-- ]]
function read80570007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_ACTION_BROADCAST;
	dataTable["messageName"] = "MJ_SC_GAME_ACTION_BROADCAST";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    SeatID	Byte	操作者座位号
	dataTable["SeatID"] = nMBaseMessage:readByte();
	--    DisCardVal	Int	出牌者的牌
	dataTable["DisCardVal"] = tonumber(nMBaseMessage:readInt());
	--    DisSeatID	Byte	出牌者的座位号
	dataTable["DisSeatID"] = nMBaseMessage:readByte();
	--    ActionType	Byte	当前操作类型	牌型1：顺子 牌型3：碰 牌型4：明杠 牌型5：暗杠
	dataTable["ActionType"] = nMBaseMessage:readByte();

	--    cardGroup	Loop	同步当前操作者的桌面牌
	local cardGroupSize = tonumber(nMBaseMessage:readInt());
	dataTable["cardGroup"] = {};
	for i = 1, cardGroupSize do
		dataTable["cardGroup"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--    ...cardType	Byte	操作类型	牌型1：顺子 牌型3：碰 牌型4：明杠 牌型5：暗杠
		dataTable["cardGroup"][i].cardType = nMBaseMessage:readByte();
		--    ...cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开 暗杠牌值其他家为-1
		dataTable["cardGroup"][i].cardStr = nMBaseMessage:readString();
		--    ...FromSeatID	Byte	吃碰杠外来的牌来源座位号
		dataTable["cardGroup"][i].FromSeatID = nMBaseMessage:readByte();

		nMBaseMessage:setReadPos(pos + length);
	end
	-- HandCardsSize	Short	操作者剩余手牌数
	dataTable["HandCardsSize"] = nMBaseMessage:readShort();

	return dataTable
end

--[[--
-- 13.57.25广播胡牌结果(MJ_SC_GAME_HU_RESULT_BROADCAST)
-- ]]
function read80570019(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_HU_RESULT_BROADCAST;
	dataTable["messageName"] = "MJ_SC_GAME_HU_RESULT_BROADCAST";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--DisCardVal	Int	胡的是哪张牌
	dataTable["DisCardVal"] = tonumber(nMBaseMessage:readInt());
	--DisCardSeatID	Byte	出牌者的座位号
	dataTable["DisCardSeatID"] = nMBaseMessage:readByte();
	--HuType	Byte	胡牌类型	1胡2自摸3杠上开花4海底捞月5抢杠胡6一炮双响7一炮多响8呼叫转移
	dataTable["HuType"] = nMBaseMessage:readByte();

	--HuUserList	Loop	胡牌列表
	local HuUserListSize = tonumber(nMBaseMessage:readInt());
	dataTable["HuUserList"] = {};
	for i = 1, HuUserListSize do
		dataTable["HuUserList"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--...SeatId	Byte	胡牌座位号
		dataTable["HuUserList"][i].SeatId = nMBaseMessage:readByte();
		--...State	Byte	是否真胡	1实牌0虚牌
		dataTable["HuUserList"][i].State = nMBaseMessage:readByte();
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
		dataTable["HuUserList"][i].HuNumber = nMBaseMessage:readByte();

		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
-- 推送发一张牌【摸牌】(MJ_SC_GAME_DEAL_CARD)
-- ]]
function read80570008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_DEAL_CARD;
	dataTable["messageName"] = "MJ_SC_GAME_DEAL_CARD";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    SeatID	byte	这张牌发给谁（谁摸的牌）
	dataTable["SeatID"] = nMBaseMessage:readByte();
	--    CardVal	Short	牌值（非牌主人发-1）
	dataTable["CardVal"] = nMBaseMessage:readShort();
	--    LeaveCardsCnt	Short	剩余牌数量
	dataTable["LeaveCardsCnt"] = nMBaseMessage:readShort();

	return dataTable
end

--[[--
-- 提示玩家选择换三张(MJ_SC_GAME_SEND_CHANGE_CARD)
-- ]]
function read80570009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SEND_CHANGE_CARD;
	dataTable["messageName"] = "MJ_SC_GAME_SEND_CHANGE_CARD";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--Cards	Text	推荐换得3张牌
	dataTable["Cards"] = nMBaseMessage:readString();
	return dataTable
end

--[[--
-- 换三张(MJ_SC_GAME_SELECT_CHANGE_CARD)
-- ]]
function read8057000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SELECT_CHANGE_CARD;
	dataTable["messageName"] = "MJ_SC_GAME_SELECT_CHANGE_CARD";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--	  SeatId	Byte	座位号
	dataTable["SeatId"] = nMBaseMessage:readByte();
	--    Result	Byte	操作结果	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte();
	--    Message	Text	操作提示
	dataTable["Message"] = nMBaseMessage:readString();

	return dataTable
end

--[[--
-- 换三张结果(MJ_SC_GAME_CHANGE_CARD_BROADCAST)
-- ]]
function read8057000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_CHANGE_CARD_BROADCAST;
	dataTable["messageName"] = "MJ_SC_GAME_CHANGE_CARD_BROADCAST";

	--    TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--    Type Byte 0顺时针，1逆时针，2对家
	dataTable["Type"] = nMBaseMessage:readByte();
	--    Cards	String	得到的三张牌	逗号隔开
	dataTable["Cards"] = nMBaseMessage:readString();
	--    Message	Text	牌来源	需要toast提示，这里内容是 顺时针，逆时针，对家
	dataTable["Message"] = nMBaseMessage:readString();

	return dataTable
end

--[[--
-- 提示玩家选择定缺(MJ_SC_GAME_SEND_DING_QUE)
-- ]]
function read8057000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SEND_DING_QUE;
	dataTable["messageName"] = "MJ_SC_GAME_SEND_DING_QUE";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--Type	Byte	定缺类型	0万，1条，2桶
	dataTable["Type"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
-- 玩家定缺(MJ_SC_GAME_SEND_DING_QUE)
-- ]]
function read8057000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SELECT_DING_QUE;
	dataTable["messageName"] = "MJ_SC_GAME_SELECT_DING_QUE";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--SeatId	Byte	座位号
	dataTable["SeatId"] = nMBaseMessage:readByte();
	--Type	Int	定缺类型	0万，1筒，2条(其它人的为-1)
	dataTable["Type"] = tonumber(nMBaseMessage:readInt());
	--Result	Byte	操作结果	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte();
	--Message	Text	操作提示
	dataTable["Message"] = nMBaseMessage:readString();

	return dataTable
end

--[[--
-- 广播定缺结果(MJ_SC_GAME_DINGQUE_BROADCAST)
-- ]]
function read8057000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_DINGQUE_BROADCAST;
	dataTable["messageName"] = "MJ_SC_GAME_DINGQUE_BROADCAST";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());

	--QuePaiList	Loop	玩家定缺结果
	local QuePaiListSize = tonumber(nMBaseMessage:readInt());
	dataTable["QuePaiList"] = {};
	for i = 1, QuePaiListSize do
		dataTable["QuePaiList"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--...SeatId	Byte	座位号
		dataTable["QuePaiList"][i].SeatId = nMBaseMessage:readByte();
		--...QuePaiType	Byte	玩家定缺的缺牌	定缺
		dataTable["QuePaiList"][i].QuePaiType = nMBaseMessage:readByte();

		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
-- 听牌方案列表(MJ_SC_GAME_TING_SOLUTIONS)
-- ]]
function read8057000f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_TING_SOLUTIONS;
	dataTable["messageName"] = "MJ_SC_GAME_TING_SOLUTIONS";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());

	--	TingPaiList	Loop	听牌方案列表
	local TingPaiListSize = tonumber(nMBaseMessage:readInt());
	dataTable["TingPaiList"] = {};
	for i = 1, TingPaiListSize do
		dataTable["TingPaiList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--...SelectCardValue	int	选择要打出的牌
		dataTable["TingPaiList"][i].SelectCardValue = tonumber(nMBaseMessage:readInt());

		--... SelectTingPaiList	Loop	听牌方案
		local SelectTingPaiListSize = tonumber(nMBaseMessage:readInt());
		dataTable["TingPaiList"][i]["SelectTingPaiList"] = {};
		for j = 1, SelectTingPaiListSize do
			dataTable["TingPaiList"][i]["SelectTingPaiList"][j] = {};
			local length = nMBaseMessage:readShort();
			local pos = nMBaseMessage:getReadPos();
			--......CardValue	int	牌值
			dataTable["TingPaiList"][i]["SelectTingPaiList"][j].CardValue = tonumber(nMBaseMessage:readInt());
			--......Multiple	Int	倍数
			dataTable["TingPaiList"][i]["SelectTingPaiList"][j].Multiple = tonumber(nMBaseMessage:readInt());
			--......LeaveCardsCnt	Byte	剩余多少张牌
			dataTable["TingPaiList"][i]["SelectTingPaiList"][j].LeaveCardsCnt = nMBaseMessage:readByte();

			nMBaseMessage:setReadPos(pos + length);
		end
		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
-- 听牌状态变更(MJ_SC_GAME_TING_STATUS_CHANGED)
-- ]]
function read80570010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_TING_STATUS_CHANGED;
	dataTable["messageName"] = "MJ_SC_GAME_TING_STATUS_CHANGED";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());

	--... SelectTingPaiList	Loop	听牌方案
	local SelectTingPaiListSize = tonumber(nMBaseMessage:readInt());
	dataTable["SelectTingPaiList"] = {};
	for i = 1, SelectTingPaiListSize do
		dataTable["SelectTingPaiList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--......CardValue	int	牌值
		dataTable["SelectTingPaiList"][i].CardValue = tonumber(nMBaseMessage:readInt());
		--......Multiple	Int	倍数
		dataTable["SelectTingPaiList"][i].Multiple = tonumber(nMBaseMessage:readInt());
		--......LeaveCardsCnt	Byte	剩余多少张牌
		dataTable["SelectTingPaiList"][i].LeaveCardsCnt = nMBaseMessage:readByte();

		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
--游戏结果(MJ_SC_GAME_GAME_RESULT)
--]]
function read80570011(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_GAME_RESULT;
	dataTable["messageName"] = "MJ_SC_GAME_GAME_RESULT";

	--TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--PlayerList	Loop	用户列表
	local PlayerListSize = tonumber(nMBaseMessage:readInt());
	dataTable["PlayerList"] = {};
	for i = 1, PlayerListSize do
		dataTable["PlayerList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--...UserID	Int
		dataTable["PlayerList"][i].UserID = tonumber(nMBaseMessage:readInt());
		--...SeatID	byte
		dataTable["PlayerList"][i].SeatID = nMBaseMessage:readByte();
		--...PhotoUrl	Text
		dataTable["PlayerList"][i].PhotoUrl = nMBaseMessage:readString();
		--...Name	Text
		dataTable["PlayerList"][i].Name = nMBaseMessage:readString();
		--...Fan	Int	胡多少番	没胡0
		dataTable["PlayerList"][i].Fan = tonumber(nMBaseMessage:readInt());
		--...Score	Long	输赢多少分	分正负
		dataTable["PlayerList"][i].Score = tonumber(nMBaseMessage:readLong());
		--...FanTypeStr	Text	番型提示
		dataTable["PlayerList"][i].FanTypeStr = nMBaseMessage:readString();
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡
		dataTable["PlayerList"][i].HuNumber = nMBaseMessage:readByte();

		--...cardGroup	Loop	同步当前操作者的桌面牌
		local cardGroupSize = tonumber(nMBaseMessage:readInt());
		dataTable["PlayerList"][i]["cardGroup"] = {};
		for j = 1, cardGroupSize do
			dataTable["PlayerList"][i]["cardGroup"][j] = {};
			local length = nMBaseMessage:readShort();
			local pos = nMBaseMessage:getReadPos();

			--......cardType	Byte	操作类型	牌型1：顺子 牌型3：碰牌 型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡牌
			dataTable["PlayerList"][i]["cardGroup"][j].cardType = nMBaseMessage:readByte();
			--......cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开
			dataTable["PlayerList"][i]["cardGroup"][j].cardStr = nMBaseMessage:readString();

			nMBaseMessage:setReadPos(pos + length);
		end
		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
--13.57.20牌桌同步(MJ_SC_GAME_SYNC_TABLE)
--]]
function read80570014(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SYNC_TABLE;
	dataTable["messageName"] = "MJ_SC_GAME_SYNC_TABLE";

	--TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--CurrActionSeat	byte	当前操作者座位号
	dataTable["CurrActionSeat"] = nMBaseMessage:readByte();
	--TableStat	byte	牌桌状态	0准备 1换三张 2定缺 3打牌
	dataTable["TableStat"] = nMBaseMessage:readByte();
	--PlayerList	Loop	用户列表
	local PlayerListSize = tonumber(nMBaseMessage:readInt());
	dataTable["PlayerList"] = {};
	for i = 1, PlayerListSize do
		dataTable["PlayerList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--...UserID	Int
		dataTable["PlayerList"][i].UserID = tonumber(nMBaseMessage:readInt());
		--...SeatID	byte
		dataTable["PlayerList"][i].SeatID = nMBaseMessage:readByte();
		--...PhotoUrl	Text
		dataTable["PlayerList"][i].PhotoUrl = nMBaseMessage:readString();
		--...Name	Text
		dataTable["PlayerList"][i].Name = nMBaseMessage:readString();
		--...HandCardStr	Text	自己牌的牌值	逗号隔开
		dataTable["PlayerList"][i].HandCardStr = nMBaseMessage:readString();
		--...DisCardStr	Text	打出牌的牌值	逗号隔开
		dataTable["PlayerList"][i].DisCardStr = nMBaseMessage:readString();

		--...LayDownCard	Loop	吃碰杠的牌
		local cardGroupSize = tonumber(nMBaseMessage:readInt());
		dataTable["PlayerList"][i]["cardGroup"] = {};
		for j = 1, cardGroupSize do
			dataTable["PlayerList"][i]["cardGroup"][j] = {};
			local length = nMBaseMessage:readShort();
			local pos = nMBaseMessage:getReadPos();

			--......cardType	Byte	操作类型	牌型1：顺子 牌型3：碰牌 型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡牌
			dataTable["PlayerList"][i]["cardGroup"][j].cardType = nMBaseMessage:readByte();
			--......cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开
			dataTable["PlayerList"][i]["cardGroup"][j].cardStr = nMBaseMessage:readString();
			--......FromSeatID	Byte	吃碰杠外来的牌来源座位号
			dataTable["PlayerList"][i]["cardGroup"][j].FromSeatID = nMBaseMessage:readByte();

			nMBaseMessage:setReadPos(pos + length);
		end

		--...DingQueColor	byte	定缺花色	-1没定缺 -2已定缺，不广播 0万，1筒，2条
		dataTable["PlayerList"][i].DingQueColor = tonumber(nMBaseMessage:readInt());
		--...IsSendChangeCard	byte	是否已经上行换三张的牌	0否 1是
		dataTable["PlayerList"][i].IsSendChangeCard = nMBaseMessage:readByte();
		--    ...score	Long	积分（金币数）
		dataTable["PlayerList"][i].score = tonumber(nMBaseMessage:readLong());
		--    ...sex	Byte	性别	0=未知，1男，2女
		dataTable["PlayerList"][i].sex = nMBaseMessage:readByte();
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
		dataTable["PlayerList"][i].HuNumber = nMBaseMessage:readByte();

		nMBaseMessage:setReadPos(pos + length);
	end
	--RoomTitle	Text	房间标题
	dataTable["RoomTitle"] = nMBaseMessage:readString();
	--CurrInning	byte	当前第几局
	dataTable["CurrInning"] = nMBaseMessage:readByte();
	--TotalInning	byte	一共多少局
	dataTable["TotalInning"] = nMBaseMessage:readByte();
	--RoomOwnerSeatID	Byte	房主位置
	dataTable["RoomOwnerSeatID"] = nMBaseMessage:readByte();
	--roomId	Int	房间ID	RoomCode
	dataTable["roomId"] = tonumber(nMBaseMessage:readInt());
	--LeaveCardsCnt	Short	剩余牌数量
	dataTable["LeaveCardsCnt"] = nMBaseMessage:readShort();

	return dataTable;
end

--[[--
-- 13.57.23同步自己的手牌(MJ_SC_GAME_SYNC_HAND_CARDS)
-- ]]
function read80570017(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_SYNC_HAND_CARDS;
	dataTable["messageName"] = "MJ_SC_GAME_SYNC_HAND_CARDS";

	--TimeStamp	Long	入局时间戳	TimeStamp
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--cardGroup	Loop	同步自己的桌面牌
	local cardGroupSize = tonumber(nMBaseMessage:readInt());
	dataTable["cardGroup"] = {};
	for j = 1, cardGroupSize do
		dataTable["cardGroup"][j] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--......cardType	Byte	操作类型	牌型1：顺子 牌型3：碰牌 型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡牌
		dataTable["cardGroup"][j].cardType = nMBaseMessage:readByte();
		--......cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开
		dataTable["cardGroup"][j].cardStr = nMBaseMessage:readString();

		nMBaseMessage:setReadPos(pos + length);
	end
	return dataTable
end

--[[--
--13.57.18房间总结果
--]]
function read80570012(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_ROOM_RESULT;
	dataTable["messageName"] = "MJ_SC_GAME_ROOM_RESULT";

	--TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--PlayerList	Loop	用户列表
	local PlayerListSize = tonumber(nMBaseMessage:readInt());
	Common.log("read80570012 PlayerListSize==============="..PlayerListSize)
	dataTable["PlayerList"] = {};
	for i = 1, PlayerListSize do
		dataTable["PlayerList"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--...UserID	Int
		dataTable["PlayerList"][i].UserID = tonumber(nMBaseMessage:readInt());
		Common.log("read80570012 UserID==============="..dataTable["PlayerList"][i].UserID)
		--...SeatID	byte
		dataTable["PlayerList"][i].SeatID = nMBaseMessage:readByte();
		--...PhotoUrl	Text
		dataTable["PlayerList"][i].PhotoUrl = nMBaseMessage:readString();
		Common.log("read80570012 PhotoUrl==============="..dataTable["PlayerList"][i].PhotoUrl)
		--...Name	Text
		dataTable["PlayerList"][i].Name = nMBaseMessage:readString();
		Common.log("read80570012 Name==============="..dataTable["PlayerList"][i].Name)
		--...IsRoomOwner	byte	是否房主
		dataTable["PlayerList"][i].IsRoomOwner = nMBaseMessage:readByte();
		--...TotalScore	Long	总共输赢多少分	分正负
		dataTable["PlayerList"][i].TotalScore = tonumber(nMBaseMessage:readLong());
		Common.log("read80570012 TotalScore==============="..dataTable["PlayerList"][i].TotalScore)
		--...ZiMoCnt	short	自摸次数
		dataTable["PlayerList"][i].ZiMoCnt = nMBaseMessage:readShort();
		Common.log("read80570012 ZiMoCnt==============="..dataTable["PlayerList"][i].ZiMoCnt)
		--...JiePaoCnt	short	接炮次数
		dataTable["PlayerList"][i].JiePaoCnt = nMBaseMessage:readShort();
		--...DianPaoCnt	short	点炮次数
		dataTable["PlayerList"][i].DianPaoCnt = nMBaseMessage:readShort();
		--...AnGangCnt	short	暗杠次数
		dataTable["PlayerList"][i].AnGangCnt = nMBaseMessage:readShort();
		--...MingGangCnt	short	明杠次数
		dataTable["PlayerList"][i].MingGangCnt = nMBaseMessage:readShort();
		--...ChaDaJiao	short	查大叫
		dataTable["PlayerList"][i].ChaDaJiao = nMBaseMessage:readShort();
		Common.log("read80570012 ChaDaJiao==============="..dataTable["PlayerList"][i].ChaDaJiao)

		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
-- 13.57.21解散房间申请(MJ_SC_GAME_DISMISS_ROOM)
-- ]]
function read80570015(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_DISMISS_ROOM;
	dataTable["messageName"] = "MJ_SC_GAME_DISMISS_ROOM";

	--TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--surplusTime	int	剩余时间	秒
	dataTable["surplusTime"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80570015 surplusTime==============="..dataTable["surplusTime"])
	--DismissUserId	int	解散发起人
	dataTable["DismissUserId"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80570015 DismissUserId==============="..dataTable["DismissUserId"])
	--dismissInfo	Text	文字提示
	dataTable["dismissInfo"] = nMBaseMessage:readString();
	Common.log("read80570015 dismissInfo==============="..dataTable["dismissInfo"])
	--selfStatus	Byte	状态	0=拒绝，1=同意，2=未选择
	dataTable["selfStatus"] = nMBaseMessage:readByte();
	Common.log("read80570015 selfStatus==============="..dataTable["selfStatus"])
	-- UserStatusList 	loop	玩家状态
	dataTable["UserStatusList"] = {}
	local UserStatusListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80570015 UserStatusListCnt==============="..UserStatusListCnt)
	for i = 1, UserStatusListCnt do
		dataTable["UserStatusList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- ...…userId	Int
		dataTable["UserStatusList"][i].userId = tonumber(nMBaseMessage:readInt());
		Common.log("read80570015 userId ==="..dataTable["UserStatusList"][i].userId)
		-- ...……userName	text
		dataTable["UserStatusList"][i].userName = nMBaseMessage:readString();
		Common.log("read80570015 userName ==="..dataTable["UserStatusList"][i].userName)
		-- ...…status	Byte	状态	0=拒绝，1=同意，2=未选择
		dataTable["UserStatusList"][i].status = nMBaseMessage:readByte();
		Common.log("read80570015 status ==="..dataTable["UserStatusList"][i].status)

		nMBaseMessage:setReadPos(pos + length)
	end
	--DismissName	Text	解散发起人
	dataTable["DismissName"] = nMBaseMessage:readString();
	Common.log("read80570015 DismissName==============="..dataTable["DismissName"])

	return dataTable
end

--[[--
-- 13.57.22解散房间投票(MJ_SC_GAME_DISMISS_VOTE)
-- ]]
function read80570016(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_DISMISS_VOTE;
	dataTable["messageName"] = "MJ_SC_GAME_DISMISS_VOTE";

	--TimeStamp	Long	入局时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong());
	--VoteUserId	int	投票人
	dataTable["VoteUserId"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80570016 VoteUserId==============="..dataTable["VoteUserId"])
	--IsAgree	byte	投票人是否同意	0拒绝，1同意
	dataTable["IsAgree"] = nMBaseMessage:readByte();
	Common.log("read80570016 IsAgree==============="..dataTable["IsAgree"])
	--VoteResult	byte	本次投票结果	0不解散，1解散，2尚无结果
	dataTable["VoteResult"] = nMBaseMessage:readByte();
	Common.log("read80570016 VoteResult==============="..dataTable["VoteResult"])
	--VoteUserName	Text
	dataTable["VoteUserName"] = nMBaseMessage:readString();
	Common.log("read80570016 VoteUserName==============="..dataTable["VoteUserName"])

	return dataTable
end

--[[--
--13.57.24推送用户游戏状态
-- ]]
function read80570018(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_GAME_PUSH_PLAYER_STATE;
	dataTable["messageName"] = "MJ_SC_GAME_PUSH_PLAYER_STATE";

	--UserID	Int
	dataTable["UserID"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80570018 UserID==============="..dataTable["UserID"])
	--SeatID	byte
	dataTable["SeatID"] = nMBaseMessage:readByte();
	Common.log("read80570018 SeatID==============="..dataTable["SeatID"])
	--isOffline	byte	是否是离线状态	1是0不是
	dataTable["isOffline"] = nMBaseMessage:readByte();
	Common.log("read80570018 isOffline==============="..dataTable["isOffline"])

	return dataTable
end











--[[--
-- 进入房间(MJ_SC_ROOM_ENTER_ROOM)
-- ]]
function read80570065(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_ROOM_ENTER_ROOM;
	dataTable["messageName"] = "MJ_SC_ROOM_ENTER_ROOM";

	--Result	Byte	操作结果	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte();
	--Message	Text	操作提示
	dataTable["Message"] = nMBaseMessage:readString();

	return dataTable
end

--13.57.102聊天
function read80570066(nMBaseMessage)
	Common.log("read80570066 聊天")
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_ROOM_CHAT
	dataTable["messageName"] = "MJ_SC_ROOM_CHAT"

	--发言者座位号	0-5,-1表示站立玩家
	dataTable["position"] = tonumber(nMBaseMessage:readInt());
	--发言者昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--类型	1=快捷文字，2=高级表情，3=文字
	dataTable["Type"] = nMBaseMessage:readByte()
	Common.log("read80570066 类型 Type= "..dataTable["Type"])
	--聊天内容	包括发送者昵称
	dataTable["message"] = nMBaseMessage:readString()
	Common.log("read80570066 聊天内容 message= "..dataTable["message"])
	return dataTable
end

--[[--
-- 13.57.103距离警告
-- ]]
function read80570067(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_DISTANCE_ALERT;
	dataTable["messageName"] = "MJ_SC_DISTANCE_ALERT";

	-- InfoList	loop	和其他玩家的距离
	dataTable["InfoList"] = {}
	local infoListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80570067 infoListCnt==============="..infoListCnt)
	for i = 1, infoListCnt do
		dataTable["InfoList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- ...…mofaUrl	Text	昵称
		dataTable["InfoList"][i].info = nMBaseMessage:readString();
		Common.log("read80570067 info ==="..dataTable["InfoList"][i].info)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end



--13.57.104 牌桌内个人信息
function read80570068(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_PLAYER_INFO_IN_TABLE
	dataTable["messageName"] = "MJ_SC_MGR_PLAYER_INFO_IN_TABLE"

	-- userID	Int	用户ID
	dataTable["userID"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80570068 userID =========== "..dataTable["userID"] )
	-- nickName	Text	昵称
	dataTable["nickName"] = nMBaseMessage:readString()
	Common.log("read80570068 nickName =========== "..dataTable["nickName"] )
	-- sex	Byte	性别	1男 2女
	dataTable["sex"] = nMBaseMessage:readByte()
	Common.log("read80570068 sex =========== "..dataTable["sex"] )
	-- photoUrl	Text	头像
	dataTable["photoUrl"] = nMBaseMessage:readString()
	Common.log("read80570068 photoUrl =========== "..dataTable["photoUrl"] )
	-- fangkaCnt	Int	房卡数
	dataTable["fangkaCnt"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80570068 fangkaCnt =========== "..dataTable["fangkaCnt"] )

	-- DistanceList	loop	和其他玩家的距离
	dataTable["DistanceList"] = {}
	local DistanceListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80570068 DistanceListCnt==============="..DistanceListCnt)
	for i = 1, DistanceListCnt do
		dataTable["DistanceList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...userId	int	其他玩家
		dataTable["DistanceList"][i].userId = tonumber(nMBaseMessage:readInt());
		Common.log("read80570068 userId ==="..dataTable["DistanceList"][i].userId)
		-- ...…nickname	Text	昵称
		dataTable["DistanceList"][i].nickname = nMBaseMessage:readString();
		Common.log("read80570068 nickname ==="..dataTable["DistanceList"][i].nickname)
		-- ...Distance	Text	和其他玩家的距离	米
		dataTable["DistanceList"][i].Distance = nMBaseMessage:readString();
		Common.log("read80570068 Distance ==="..dataTable["DistanceList"][i].Distance)

		nMBaseMessage:setReadPos(pos + length)
	end

	-- MofaList	loop	和其他玩家的距离
	dataTable["MofaList"] = {}
	local MofaListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80570068 MofaListCnt==============="..MofaListCnt)
	for i = 1, MofaListCnt do
		dataTable["MofaList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...mofaId	int	魔法id
		dataTable["MofaList"][i].mofaId = tonumber(nMBaseMessage:readInt());
		Common.log("read80570068 mofaId ==="..dataTable["MofaList"][i].mofaId)
		-- ...…mofaUrl	Text	昵称
		dataTable["MofaList"][i].mofaUrl = nMBaseMessage:readString();
		Common.log("read80570068 mofaUrl ==="..dataTable["MofaList"][i].mofaUrl)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--[[--
-- 13.57.105赠送魔法表情
-- ]]
function read80570069(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_SEND_MAGIC;
	dataTable["messageName"] = "MJ_SC_SEND_MAGIC";

	--result	Byte	是否成功	0失败1成功
	dataTable["result"] = nMBaseMessage:readByte();
	--message	Text	操作提示
	dataTable["message"] = nMBaseMessage:readString();
	--targerUserID	Int	目标玩家id	可以是自己
	dataTable["targerUserID"] = tonumber(nMBaseMessage:readInt());

	return dataTable
end

--[[--
--13.57.106牌桌飞礼物消息
-- ]]
function read8057006a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_BROADCAST_FLY_GIFT;
	dataTable["messageName"] = "MJ_SC_BROADCAST_FLY_GIFT";

	--类别ID 	1礼物2.魔法表情
	dataTable["TypeId"] = nMBaseMessage:readByte()
	--礼物来源玩家ID
	dataTable["SourceUserId"] = tonumber(nMBaseMessage:readInt());
	--接收礼物玩家ID
	dataTable["TargetUserId"] = tonumber(nMBaseMessage:readInt());
	--物品ID	礼物（1鲜花2豪车3豪宅4游轮）  魔法表情（1鲜花2西红柿3扔炸弹4吻）
	dataTable["itemId"] = tonumber(nMBaseMessage:readInt());

	return dataTable
end










---------------------------------------------------------------
-- 1.1进入房间
function read80740001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_ENTER_ROOM
	dataTable["messageName"] = "MJ_SC_MGR_ENTER_ROOM"

	-- Result	Byte	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read80740001 Result ==="..dataTable["Result"])
	-- Message	String	结果提示
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read80740001 Message ==="..dataTable["Message"])
	-- Passward	Integer	房间密码
	--dataTable["Passward"] = tonumber(nMBaseMessage:readInt())
	--Common.log("read80740003 Passward ==="..dataTable["Passward"])

	return dataTable
end

-- 1.2退出房间
function read80740002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_QUIT_ROOM
	dataTable["messageName"] = "MJ_SC_MGR_QUIT_ROOM"

	-- Result	Byte	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read80740002 Result ==="..dataTable["Result"])
	-- Message	String	结果提示
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read80740002 Message ==="..dataTable["Message"])

	return dataTable
end

--1.3建立房间
function read80740003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_CREATE_ROOM
	dataTable["messageName"] = "MJ_SC_MGR_CREATE_ROOM"

	-- Result	Byte	1成功0失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read80740003 Result ==="..dataTable["Result"])
	--roomCode	Int	已建立的房间码	-1=没有，其他=有
	dataTable["roomCode"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80740003 roomCode ==="..dataTable["roomCode"])
	-- Message	String	结果提示
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read80740003 Message ==="..dataTable["Message"])

	return dataTable
end

--1.5牌桌选项
function read80740005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_CREATE_OPTION
	dataTable["messageName"] = "MJ_SC_MGR_CREATE_OPTION"

	-- JuShuLoop	Loop	选择局数
	dataTable["JuShuList"] = {}
	local JuShuCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80740005 JuShuCnt==============="..JuShuCnt)
	for i = 1, JuShuCnt do
		dataTable["JuShuList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...value	Int	值
		dataTable["JuShuList"][i].value = tonumber(nMBaseMessage:readInt())
		Common.log("read80740005 value ==="..dataTable["JuShuList"][i].value)
		-- ...text	text	显示文字
		dataTable["JuShuList"][i].text = nMBaseMessage:readString();
		Common.log("read80740005 text ==="..dataTable["JuShuList"][i].text)

		nMBaseMessage:setReadPos(pos + length)
	end

	-- fanList	Loop	番
	dataTable["fanList"] = {}
	local fanCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80740005 fanCnt==============="..fanCnt)
	for i = 1, fanCnt do
		dataTable["fanList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...value	Int	值
		dataTable["fanList"][i].value = tonumber(nMBaseMessage:readInt())
		Common.log("read80740005 value ==="..dataTable["fanList"][i].value)
		-- ...text	text	显示文字
		dataTable["fanList"][i].text = nMBaseMessage:readString();
		Common.log("read80740005 text ==="..dataTable["fanList"][i].text)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end


