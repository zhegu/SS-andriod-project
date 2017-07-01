module("MahjongTableConsole", package.seeall)

--1血战
mnTableType = -1;
TABLE_TYPE_XZ = 1;--1血战

mRoomID = -1;-- 当前房间号
mMatchID = -1;-- 当前比赛号
mTableID = -1;-- 当前桌子号

mBankerSeatID = -1;-- 房主座位号
m_selfseat = -1;--自己的座位号 东0南1西2北3逆时针
mTableFee = -1;-- 当前桌费

local mCurrPlayer = -1;-- 当前正在操作的人的座位号
local mCurrCardValue = -1;-- 当前出的牌值
mSelfQuePaiType = -1;-- 自己的定缺类型 0万，1条，2桶

local TingPaiList = {};--听牌方案列表
local CurrTingCardList = {};--当前的听牌方案

mTableStatus = -1;-- 当前桌子状态
STAT_WAITING = 0;-- 等待阶段
STAT_WAITING_READY = 1;-- 准备阶段
STAT_SETOUT = 2;-- 发牌阶段
STAT_CHANGE_CARD = 3;-- 换三张牌阶段
STAT_DING_QUE = 4;-- 定缺阶段
STAT_TAKEOUT = 5;-- 出牌阶段
STAT_GAME_RESULT = 6;-- 结果阶段

TableButtonStatus = 0;--牌桌按钮状态

mRoomTitle = "";
isTableContinue = false;-- 断线续玩

mPlayers = {};--牌桌用户列表,显示在PokerTablePlayer类(下标SeatID + 1)
PlayerInfo = {}--用户游戏信息

--聊天类型：文本
TYPE_CHAT_TEXT = 1
--聊天类型：普通表情
TYPE_CHAT_FACE = 2
--聊天类型：互动表情
TYPE_CHAT_INTERACT = 3
--聊天类型：高级表情
TYPE_CHAT_FACE_SUPERIOR = 4

isTableRecordMode = false;--当前是否是牌桌记录模式

mEndTimeStamp = -1; --房间结束时间戳
mCurrInning = 0; --当前局数
mTotalInning = 0; --总局数

local diceValue = {}; --骰子的点数

PLAYER_STATE_NORMAL = 1; --用户正常状态
PLAYER_STATE_DINGQUEING = 2; --用户定缺中状态
PLAYER_STATE_XUANPAIING = 3; --用户选牌中状态


--[[--
--重置牌桌数据
--]]
function releaseTableData()
	Common.log("重置牌桌数据")
	mnTableType = -1;
	mRoomID = -1;-- 当前房间号
	mMatchID = -1;-- 当前比赛号
	mTableID = -1;-- 当前桌子号
	mBankerSeatID = -1;-- 房主座位号
	m_selfseat = -1;--自己的座位号
	mTableFee = -1;-- 当前桌费

	mCurrPlayer = -1;-- 当前正在下注的人的座位号
	mCurrCardValue = -1;-- 当前出的牌值
	mSelfQuePaiType = -1;-- 自己的定缺类型 0万，1条，2桶
	TingPaiList = {};

	mTableStatus = -1;-- 当前桌子状态
	TableButtonStatus = 0;--牌桌按钮状态

	mRoomTitle = "";
	mMatchTitle = "";

	mPlayers = {};--牌桌用户列表

	isTableRecordMode = false;
	mEndTimeStamp = -1;
	mCurrInning = 0
	mTotalInning = 0;
	diceValue = {}
end

--[[--
--获取自己的座位号
--]]
function getSelfSeat()
	return m_selfseat;
end

--[[--
--设置自己的座位号
--]]
function setSelfSeat(SeatID)
	m_selfseat = SeatID;
end

--[[--
--返回东南西北的方位(东0，南1，西2，北，3)
--]]
function getPlayerDirBySeatID(SeatID)
	if mBankerSeatID == -1 then
		return SeatID;
	end
	return (SeatID - mBankerSeatID + 4) % 4;
end

--[[--
-- 根据座位号取出玩家在牌桌中位置
--
-- @param #number nSeatID 座位号
-- @return
--]]
function getPlayerPosBySeat(seatId)
	if (getSelfSeat() == -1) then
		return seatId;
	end
	return (seatId - getSelfSeat() + 4) % 4;
end

--[[--
-- 根据玩家在牌桌上的位置取出其座位号
-- @number i pos
-- @return
--]]
function getPlayerSeatByPos(side)
	if (getSelfSeat() == -1) then
		return side;
	end
	return (side + getSelfSeat()) % 4;
end


--[[--
--根据用户的userid，得到用户
--]]
function getPlayerByUserID(UserID)
	for key, player in pairs(mPlayers) do
		if player ~= nil then
			if (player.mUserID == UserID) then
				return player;
			end
		end
	end
	return nil;
end

--[[--
--获取有效用户数量
--]]
function getPlayerSize()
	local palyerNum = 0;
	for key, player in pairs(mPlayers) do
		if player ~= nil then
			if (not player.mIsEliminated) then
				palyerNum = palyerNum + 1
			end
		end
	end
	return palyerNum
end

--[[--
--根据用户的userid，得到用户
--]]
function getPlayerPosByUserID(UserID)
	for key, player in pairs(mPlayers) do
		if player ~= nil then
			if (player.mUserID == UserID) then
				return player;
			end
		end
	end
	return nil;
end

--[[--
-- 根据座位号取出玩家数组的下标
--
-- @param #number nSeatID 座位号
-- @return local
--]]
function getPlayerIdxBySeat(nSeatID)
	if mPlayers[nSeatID + 1] ~= nil then
		return nSeatID + 1;
	end
	return -1;
end

--[[--
--通过座位号获取自己用户信息
--@return #TablePlayer 用户信息
--]]
function getSelfPlayer()
	local mSelfSeatID = getSelfSeat()
	if mSelfSeatID ~= -1 then
		return getPlayer(mSelfSeatID)
	end
	return nil;
end

--[[--
--通过座位号获取用户信息
--@param #number nSeatID 座位号
--@return #TablePlayer 用户信息
--]]
function getPlayer(nSeatID)
	if mPlayers[nSeatID + 1] ~= nil then
		return mPlayers[nSeatID + 1];
	end
	Common.log("m_aPlayer is nil, nSeatID == "..nSeatID)
	return nil;
end

--[[--
--删除指定座位号的用户
--@param #number nSeatID 座位号
--]]
function removePlayer(nSeatID)
	mPlayers[nSeatID + 1] = nil
end

--[[--
--删除所用用户
--@param #number nSeatID 座位号
--]]
function removePlayerAll()
	mPlayers = {}
end

--[[--
--获取当前操作用户
--]]
function getCurrPlayer()
	return mCurrPlayer
end

--[[--
--设置当期操作用户
--]]
function setCurrPlayer(seatID)
	mCurrPlayer = seatID
	MahjongTableLogic.setCurrPlayerDir();
	MahjongTableCardLayer.removeLastTakeOutCard();
end

--[[--
--获取当前打出的牌
--]]
function getCurrCardValue()
	return mCurrCardValue
end

--[[--
--设置当期打出的牌
--]]
function setCurrCardValue(value)
	mCurrCardValue = value
end

--[[--
--获取自己的定缺
--]]
function getSelfQuePaiType()
	return mSelfQuePaiType
end

--[[--
--获取听牌方案列表
--]]
function getTingPaiListByValue(CardValue)
	return TingPaiList[""..CardValue];
end

function clearTingPaiList()
	TingPaiList = {};
end

--[[--
--获取当前听牌方案
--]]
function getCurrTingCardList()
	return CurrTingCardList;
end

--[[--
--设置牌桌按钮状态
--]]
function setTableButtonStatus(Status)
	TheLastTableButtonStatus = TableButtonStatus;
	TableButtonStatus = Status;
end

--获取骰子的点数
function getDiceValue()
	return diceValue;
end

--[[--
--设置牌桌状态
--@param #number nStatus 牌桌状态
--]]
function setStatus(nStatus)
	Common.log("setStatus nStatus = "..nStatus)

	mTableStatus = nStatus;

	if mTableStatus == STAT_WAITING then
	-- 等待阶段
	elseif mTableStatus == STAT_WAITING_READY then
		-- 准备阶段
		mCurrPlayer = -1;-- 当前正在操作的人的座位号
		mCurrCardValue = -1;-- 当前出的牌值
		mSelfQuePaiType = -1;-- 自己的定缺类型 0万，1条，2桶
		TingPaiList = {};--听牌方案列表
		CurrTingCardList = {};--当前的听牌方案
		MahjongTableButtonLayer.setTingCardsListButtonVisible(false);
	elseif mTableStatus == STAT_SETOUT then
	-- 发牌阶段
	elseif mTableStatus == STAT_CHANGE_CARD then
	-- 换三张牌阶段
	elseif m_nGameStatus == STAT_DING_QUE then
	-- 定缺阶段
	elseif m_nGameStatus == STAT_TAKEOUT then
	-- 出牌阶段
	elseif m_nGameStatus == STAT_GAME_RESULT then
		-- 游戏结果阶段
		CurrTingCardList = {};
		MahjongTableButtonLayer.setTingCardsListButtonVisible(false);
	end
end

--[[--
--进入牌桌
--]]
function EnterGame()
	closeLogicTime();
	ResumeSocket("MahjongEnterGame");
	GameConfig.setTheLastBaseLayer(GameConfig.getTheCurrentBaseLayer());
	mvcEngine.createModule(GUI_MAHJONGTABLE);
end

--[[--
--每局结束或开始时重置牌桌
--]]
function resetGameTable()
	setStatus(STAT_WAITING_READY);
	MahjongTableLogic.setImageZiVisible(true);
	MahjongTableCardLayer.removeAllCards();
	MahjongTableElementLayer.resetTableElement();
	MahjongTablePlayerLayer.resetPlayerTableState()
end

--[[--
-- 推送牌桌变化
-- ]]
local function readMJ_SC_GAME_TABLE_CHANGE()
	Common.log("推送牌桌变化 ================ ")
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getTableChangeTable();
	releaseTableData();

	GameLoadModuleConfig.launchMiniGameByID(MahjongConfig.MahjongSichuanGameID, MahjongConfig.MahjongSichuanPackage);

	--roomId	Int	房间ID
	mRoomID = dataTable["roomId"];
	--tableId	Int	牌桌ID
	mTableID = dataTable["tableId"];
	--tableType	Int	房间类型
	mnTableType = dataTable["tableType"];
	--RoomOwnerSeatID	int	房主位置
	mBankerSeatID = dataTable["RoomOwnerSeatID"];
	--RoomTitle	Text	房间标题
	mRoomTitle = dataTable["RoomTitle"];
	--endTimeStamp	Long	房间结束时间戳
	mEndTimeStamp = dataTable["endTimeStamp"];

	--Loop	玩家信息
	for i = 1, #dataTable["UserInfo"] do
		--    ...userId	Int	玩家ID
		local userId = dataTable["UserInfo"][i].userId;
		--    ...photoUrl	Text	玩家昵称
		local photoUrl = dataTable["UserInfo"][i].photoUrl;
		--    ...seatID	Int	座位号
		local seatID = dataTable["UserInfo"][i].seatID;
		--    ...score	Long	积分（金币数）
		local score = dataTable["UserInfo"][i].score;
		--    ...vipLv	Int	Vip等级
		local vipLv = dataTable["UserInfo"][i].vipLv;
		--    ...sex	Byte	性别	0=未知，1男，2女
		local sex = dataTable["UserInfo"][i].sex;
		--    ...Name	Text
		local nickname = dataTable["UserInfo"][i].Name;

		if userId == profile.User.getSelfUserID() then
			setSelfSeat(seatID);
		end

		--	m_nPos = -1,-- 玩家位置，0，1，2...自己的位置永远是0,顺时针旋转
		mPlayers[seatID + 1] = MahjongTablePlayer:new(userId);
		-- ...userID Int 用户ID
		mPlayers[seatID + 1].mUserID = userId;
		-- ...SeatID byte 座位号 1-6
		mPlayers[seatID + 1].mSeatID = seatID;
		Common.log("mPlayers[SeatID].mSeatID === "..mPlayers[seatID + 1].mSeatID)
		--...NickName	text	昵称
		mPlayers[seatID + 1].mNickName = nickname;
		--...PhotoUrl	Text	头像Url
		mPlayers[seatID + 1].mPhotoUrl = photoUrl;
		--...ChipCnt	long	筹码数
		mPlayers[seatID + 1].mScore = score;
		--...sex	Byte	性别	0=未知，1男，2女
		mPlayers[seatID + 1].mSex = sex;

		sendMJ_SC_MGR_PLAYER_INFO_IN_TABLE(mPlayers[seatID + 1].mUserID)
	end

	if mnTableType == TABLE_TYPE_XZ then
		--血战玩法
		if #dataTable["UserInfo"] == 4 then
			setStatus(STAT_WAITING_READY);
			sendMJ_SC_GAME_READY();
		else
			setStatus(STAT_WAITING);
		end
	end

	for key, player in pairs(mPlayers) do
		if player ~= nil then
			local pos = getPlayerPosBySeat(player.mSeatID);
			Common.log("房间牌桌变化应答 seatid== "..player.mSeatID.."  pos == "..pos)
			player.m_nPos = pos;
			MahjongTablePlayerLayer.addMahjongTablePlayer(player.mSeatID);
			--			MahjongTablePlayerLayer.updateTablePlayerInfo(player.mSeatID)
			Common.getPicFile(player.mPhotoUrl, player.mSeatID + 1, true, MahjongTablePlayerLayer.updatePlayerPhoto, true);
		end
	end

	MahjongTableLogic.refreshPlayerDir();
	MahjongTableButtonLayer.refreshRoomDetailsInfo();
	MahjongTableButtonLayer.setPanelRoomVisible(true);
	MahjongTableButtonLayer.setJieSanButtonLogo();
end

--[[--
-- 退出房间
-- ]]
local function readMJ_SC_MGR_QUIT_ROOM()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getQuitRoomTable();
	local Result = dataTable["Result"]; --1成功0失败
	local Message = dataTable["Message"];
	if Result == 1 then
		MahjongTableLogic.gameExit();
	else
		Common.showToast(Message, 2);
	end
end

--[[--
-- 推送准备
-- ]]
local function readMJ_SC_GAME_READY()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getReadDataTable();
	--    SeatID	byte
	local SeatID = dataTable["SeatID"];

	local player = getPlayer(SeatID)
	player.mIsReady = 1 --用户是否准备 0否 1是
	MahjongTablePlayerLayer.updateTablePlayerState(player.mSeatID)
end

--[[--
-- 推送发牌
-- ]]
local function readMJ_SC_GAME_SEND_CARD()
	PauseSocket("MahjongSendCardAnim");
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getInitCardTable();
	--    SeatID	byte
	local SeatID = dataTable["SeatID"];
	--    FistWaitTime	int	庄家首次出牌时间	15s
	local FistWaitTime = dataTable["FistWaitTime"];
	--    BaseWaitTime	int	出牌等待时间	10s
	local BaseWaitTime = dataTable["BaseWaitTime"];
	--    AskWaitTime	int	询问等待时间	10s
	local AskWaitTime = dataTable["AskWaitTime"];

	--Loop	掷骰子次数	2
	for i = 1, #dataTable["ThrowInfo"] do
		for j = 1, #dataTable["ThrowInfo"][i] do
			local DiceNum = dataTable["ThrowInfo"][i][j].DiceNum;
			Common.log("DiceNum ======= "..DiceNum);
			diceValue[j] = DiceNum;
		end
	end

	--    DealerSeat	byte	庄家座位号
	local DealerSeat = dataTable["DealerSeat"];
	--    LeaveCardsCnt	byte	剩余牌数量
	local LeaveCardsCnt = dataTable["LeaveCardsCnt"];
	--Common.showToast("剩余牌数量 : "..LeaveCardsCnt, 2);
	--    CardCnt	Loop	牌数13张
	Common.log("CardCnt ========== "..#dataTable["CardInfo"]);
	--    CurrInning	byte	当前第几局
	mCurrInning = dataTable["CurrInning"];
	-- TotalInning	byte	一共多少局
	mTotalInning = dataTable["TotalInning"];

	MahjongTableLogic.setSurplusCard(LeaveCardsCnt);
	--Seatloop	Loop	玩家信息
	for i = 1, #dataTable["userScore"] do
		local SeatID = dataTable["userScore"][i].SeatID;
		local score = dataTable["userScore"][i].score;
		Common.log("score ======= "..score);
		mPlayers[SeatID + 1].mScore = score;
		MahjongTablePlayerLayer.updateTablePlayerInfo(SeatID)
	end

	MahjongAudioManager.playMahjongSound("MJ_BEGIN", -1);

	resetGameTable();

	setSelfSeat(SeatID);

	setStatus(STAT_SETOUT);

	--隐藏解散房间按钮
	MahjongTableButtonLayer.setPanelRoomVisible(false);

	MahjongTableArmature.showBeginAnim();
end

--开始动画结束后处理发牌
function callbackBeginAni()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getInitCardTable();
	MahjongTableCardLayer.addHandCard(0, dataTable["CardInfo"]);
	MahjongTableCardLayer.addHandCard(1, {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1});
	MahjongTableCardLayer.addHandCard(2, {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1});
	MahjongTableCardLayer.addHandCard(3, {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1});
	ResumeSocket("MahjongSendCardAnim");
end

--[[--
--发送出牌消息
--]]
function sendDisCard(value)
	MahjongTableCardLayer.hideTingCards();
	MahjongTableButtonLayer.hidePanelCaoZuoVisible();
	sendMJ_SC_GAME_DISCARD(value);
end

--[[--
-- 推送操作询问(MJ_SC_GAME_SEND_ACTION_OPTION)
-- ]]
local function readMJ_SC_GAME_SEND_ACTION_OPTION()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getSendActionOptiondTable();
	--    CardVal	Short	出牌者出的牌值	也可以是自己抓的牌
	local CardVal = dataTable["CardVal"];
	setCurrCardValue(CardVal);
	--    isChi	Byte	是否可以吃	0否1是
	local isChi = dataTable["isChi"];
	--    isPeng	byte	是否可以碰	0否1是
	local isPeng = dataTable["isPeng"];
	--    isHu	byte	是否可以胡	0否 1是
	local isHu = dataTable["isHu"];
	--    isGang	Byte	是否可以杠	0否 1是
	local isGang = dataTable["isGang"];

	MahjongTableButtonLayer.refreshCaoZuoButton(isChi, isPeng, isHu, isGang);
end

--[[--
-- 推送操作碰/杠/胡/过牌(MJ_SC_GAME_SELECT_ACTION_OPTION)
-- ]]
local function readMJ_SC_GAME_SELECT_ACTION_OPTION()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getSelectActionOptiondTable();
	--    Result	Byte	操作结果	1成功0失败
	local Result = dataTable["Result"];
	--    Message	Text	操作提示
	local Message = dataTable["Message"];
end

--[[--
--获取要换的牌
--]]
function getChangeCards()
	local CardsList = MahjongTableCardLayer.getSelectCard();
	if #CardsList ~= 3 then
		Common.showToast("必须选择三张牌", 2);
		return nil;
	end

	if CardsList[1].m_nColor == CardsList[2].m_nColor and CardsList[1].m_nColor == CardsList[3].m_nColor then
		local CardStr = CardsList[1].m_nValue .. "," .. CardsList[2].m_nValue .. "," .. CardsList[3].m_nValue;
		return CardStr;
	else
		Common.showToast("必须选择相同花色的牌", 2);
		return nil;
	end
end

--[[--
-- 提示玩家选择换三张(MJ_SC_GAME_SEND_CHANGE_CARD)
-- ]]
local function readMJ_SC_GAME_SEND_CHANGE_CARD()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getSendChangeCardTable();
	--Cards	Text	推荐换得3张牌
	local Cards = dataTable["Cards"];

	local CardsList = Common.FGUtilStringSplit(Cards, ",");

	setStatus(STAT_CHANGE_CARD);
	--刷新一下自己的手牌
	MahjongTableCardLayer.refreshHandCard(0, true);

	MahjongTableCardLayer.setSelectCard(CardsList);

	MahjongTableButtonLayer.setPanelChangeCardsVisible(true);

	for key, player in pairs(mPlayers) do
		if player ~= nil then
			player.mIsSendChangeCard = 0 --用户上行换三张状态 0否 1是
			MahjongTablePlayerLayer.updateTablePlayerState(player.mSeatID)
		end
	end
end

--[[--
-- 换三张(MJ_SC_GAME_SELECT_CHANGE_CARD)
-- ]]
local function readMJ_SC_GAME_SELECT_CHANGE_CARD()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getSelectChangeCardTable();
	--	  SeatId	Byte	座位号
	local SeatId = dataTable["SeatId"];
	--    Result	Byte	操作结果	1成功0失败
	local Result = dataTable["Result"];
	--    Message	Text	操作提示
	local Message = dataTable["Message"];

	local player =  getPlayer(SeatId)
	player.mIsSendChangeCard = 1 --用户上行换三张状态 0否 1是
	MahjongTablePlayerLayer.updateTablePlayerState(player.mSeatID)
	MahjongTableElementLayer.showChangeCard(player.mSeatID)
end

--[[--
-- 换三张结果(MJ_SC_GAME_CHANGE_CARD_BROADCAST)
-- ]]
local function readMJ_SC_GAME_CHANGE_CARD_BROADCAST()
	PauseSocket("MahjongChangeCardAnim");
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getChangeCardBrodcastTable();
	--    Type Byte 0顺时针，1逆时针，2对家
	local Type = dataTable["Type"];
	Common.log(" Type ============== " .. Type);
	--    Message	Text	牌来源	需要toast提示，这里内容是 顺时针，逆时针，对家
	local Message = dataTable["Message"];
	MahjongTableArmature.showChangeCardAnim(Type)
end

function callBackChangeCardAni()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getChangeCardBrodcastTable();
	--    Cards	String	得到的三张牌	逗号隔开
	local Cards = dataTable["Cards"];
	local CardsList = Common.FGUtilStringSplit(Cards, ",");

	MahjongTableCardLayer.addHandCard(0, CardsList);
	MahjongTableElementLayer.removeChangeCards();
	ResumeSocket("MahjongChangeCardAnim");
end

--[[--
--提示玩家选择定缺
--]]
local function readMJ_SC_GAME_SEND_DING_QUE()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getSendDingQueTable();
	--Type	Byte	定缺类型	0万，1筒，2条
	local Type = dataTable["Type"];

	setStatus(STAT_DING_QUE);

	MahjongTableButtonLayer.setPanelDingQueVisible(true);

	MahjongTableArmature.showDingQueAnim(Type + 1)

	for key, player in pairs(mPlayers) do
		if player ~= nil then
			if player.mDingQueColor == -3 then
				player.mDingQueColor = -1; --用户定缺状态 -1没定缺 -2已定缺，不广播 0万，1筒，2条
			end
			MahjongTablePlayerLayer.updateTablePlayerState(player.mSeatID)
		end
	end
end

--[[--
--玩家定缺
--]]
local function readMJ_SC_GAME_SELECT_DING_QUE()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getSelectDingQueTable();
	--SeatId	Byte	座位号
	local SeatId = dataTable["SeatId"];
	--Type	Byte	定缺类型	0万，1筒，2条
	local Type = dataTable["Type"];
	--Result	Byte	操作结果	1成功0失败
	local Result = dataTable["Result"];
	--Message	Text	操作提示
	local Message = dataTable["Message"];

	Common.log("Type ============== "..Type);

	local player =  getPlayer(SeatId)
	player.mDingQueColor = -2; --用户定缺状态 -1没定缺 -2已定缺，不广播 0万，1筒，2条
	MahjongTablePlayerLayer.updateTablePlayerState(player.mSeatID)
end

--[[--
--广播定缺结果
--]]
local function readMJ_SC_GAME_DINGQUE_BROADCAST()
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getDingQueBroadcastTable();
	setStatus(STAT_TAKEOUT);
	--QuePaiList	Loop	玩家定缺结果
	local QuePaiListSize = #dataTable["QuePaiList"];
	for i = 1, QuePaiListSize do
		--...SeatId	Byte	座位号
		local SeatId = dataTable["QuePaiList"][i].SeatId;
		Common.log("广播定缺结果 SeatId ============== "..SeatId);
		--...QuePaiType	Byte	玩家定缺的缺牌	定缺
		local QuePaiType = dataTable["QuePaiList"][i].QuePaiType;
		Common.log("广播定缺结果 QuePaiType ============== "..QuePaiType);
		if getSelfSeat() == SeatId then
			mSelfQuePaiType = QuePaiType;
		end
		MahjongTablePlayerLayer.showDingQue(SeatId, QuePaiType);
		MahjongTablePlayerLayer.updateTablePlayerState(SeatId)
	end
	--刷新一下自己的手牌
	MahjongTableCardLayer.refreshHandCard(0, true);
end

--[[--
--听牌方案列表
--]]
local function readMJ_SC_GAME_TING_SOLUTIONS()
	Common.log("听牌方案列表 ================ ")
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getTingSolutionsTable();
	local SelectCardValueList = {};
	TingPaiList = {};
	--	TingPaiList	Loop	听牌方案列表
	local TingPaiListSize = #dataTable["TingPaiList"];
	for i = 1, TingPaiListSize do
		--...SelectCardValue	int	选择要打出的牌
		local SelectCardValue = dataTable["TingPaiList"][i].SelectCardValue;

		Common.log("SelectCardValue ================ "..SelectCardValue);

		table.insert(SelectCardValueList, SelectCardValue);

		TingPaiList[""..SelectCardValue] = {};

		--... SelectTingPaiList	Loop	听牌方案
		local SelectTingPaiListSize = #dataTable["TingPaiList"][i]["SelectTingPaiList"];

		for j = 1, SelectTingPaiListSize do
			TingPaiList[""..SelectCardValue][j] = {}
			--......CardValue	int	牌值
			local CardValue = dataTable["TingPaiList"][i]["SelectTingPaiList"][j].CardValue;
			--......Multiple	Int	倍数
			local Multiple = dataTable["TingPaiList"][i]["SelectTingPaiList"][j].Multiple;
			--......LeaveCardsCnt	Byte	剩余多少张牌
			local LeaveCardsCnt = dataTable["TingPaiList"][i]["SelectTingPaiList"][j].LeaveCardsCnt;

			TingPaiList[""..SelectCardValue][j].CardValue = CardValue;
			TingPaiList[""..SelectCardValue][j].Multiple = Multiple;
			TingPaiList[""..SelectCardValue][j].LeaveCardsCnt = LeaveCardsCnt;
		end
	end

	MahjongTableCardLayer.showTingCards(SelectCardValueList);
end

--[[--
--听牌状态变更
--]]
local function readMJ_SC_GAME_TING_STATUS_CHANGED()
	Common.log("听牌状态变更 ================ ")
	local dataTable = MahjongLoadProfile.MahjongGameDoc.getStatusChangeTable();
	CurrTingCardList = {};
	--... SelectTingPaiList	Loop	听牌方案
	local SelectTingPaiListSize = #dataTable["SelectTingPaiList"];
	for i = 1, SelectTingPaiListSize do
		CurrTingCardList[i] = {};
		--......CardValue	int	牌值
		local CardValue = dataTable["SelectTingPaiList"][i].CardValue;
		--......Multiple	Int	倍数
		local Multiple = dataTable["SelectTingPaiList"][i].Multiple;
		--......LeaveCardsCnt	Byte	剩余多少张牌
		local LeaveCardsCnt = dataTable["SelectTingPaiList"][i].LeaveCardsCnt;
		CurrTingCardList[i].CardValue = CardValue;
		CurrTingCardList[i].Multiple = Multiple;
		CurrTingCardList[i].LeaveCardsCnt = LeaveCardsCnt;
		Common.log("听牌状态变更 ====== CardValue == " .. CardValue)
		Common.log("听牌状态变更 ====== CardTxt == " .. MahjongCardDoc.getMahjongCardTxt(CardValue))
		Common.log("听牌状态变更 ====== Multiple == "..Multiple)
		Common.log("听牌状态变更 ====== LeaveCardsCnt == "..LeaveCardsCnt)
	end

	if #CurrTingCardList > 0 then
		MahjongTableButtonLayer.setTingCardsListButtonVisible(true);
	else
		MahjongTableButtonLayer.setTingCardsListButtonVisible(false);
	end
end

--[[--
--房间总结果
--]]
local function readMJ_SC_GAME_ROOM_RESULT()
	Common.log("readMJ_SC_GAME_ROOM_RESULT 房间总结果");
	mvcEngine.createModule(GUI_MAHJONGROOMTOTALRESULT);
end

--解散房间申请
local function readMJ_SC_GAME_DISMISS_ROOM()
	PauseSocket("DismissRoom");
	local dismissRoomData = MahjongLoadProfile.MahjongCreateRoomInfo.getDismissRoomReqTable()
	local TimeStamp = dismissRoomData["TimeStamp"]  --入局时间戳
	local surplusTime = dismissRoomData["surplusTime"]  --剩余时间	秒
	local DismissUserId = dismissRoomData["DismissUserId"]  --解散发起人
	local selfStatus = dismissRoomData["selfStatus"]  --状态	0=拒绝，1=同意，2=未选择
	local UserStatusList = dismissRoomData["UserStatusList"]  --玩家状态
	local DismissName = dismissRoomData["DismissName"]  --玩家状态

	if selfStatus == 1 then
		--同意
		if not mvcEngine.logicModuleIsShow(GUI_MAHJONGDISMISSROOMREQUEST) then
			mvcEngine.createModule(GUI_MAHJONGDISMISSROOMREQUEST);
		end
	elseif selfStatus == 2 then
		mvcEngine.createModule(GUI_COMMONDIALOG);
		local contentStr = DismissName.." 玩家想要解散房间，是否同意"
		CommonDialogLogic.setData(CommonDialogLogic.getTypeTable().TYPE_DISMISSROOM, contentStr);
	end

	local function DismissRoomCallback()
		--回复消息接收
		ResumeSocket("DismissRoom");
	end

	--显示动画延迟两秒
	GamePub.delayDoFunc(MahjongTableLogic.view, 0.5, DismissRoomCallback);
end

--解散房间投票
local function readMJ_SC_GAME_DISMISS_VOTE()
	PauseSocket("DismissVote");
	local dismissRoomVoteData = MahjongLoadProfile.MahjongCreateRoomInfo.getDismissRoomVoteTable()

	local TimeStamp = dismissRoomVoteData["TimeStamp"]  --入局时间戳
	local VoteUserId = dismissRoomVoteData["VoteUserId"]  --投票人
	local IsAgree = dismissRoomVoteData["IsAgree"]  --投票人是否同意	0拒绝，1同意
	local VoteResult = dismissRoomVoteData["VoteResult"]  --本次投票结果	0不解散，1解散，2尚无结果
	local VoteUserName = dismissRoomVoteData["VoteUserName"]  --投票用户名

	if IsAgree == 0 then
		--拒绝
		if mvcEngine.logicModuleIsShow(GUI_MAHJONGDISMISSROOMREQUEST) then
			mvcEngine.destroyModule(GUI_MAHJONGDISMISSROOMREQUEST)
		end
		if mvcEngine.logicModuleIsShow(GUI_COMMONDIALOG) then
			CommonDialogLogic.checkClose()
		end

		mvcEngine.createModule(GUI_MAHJONGREFUSEDISMISSROOM);
		MahjongRefuseDismissRoomLogic.setContent("由于玩家"..VoteUserName.."拒绝，解散失败，游戏继续");
	end

	if VoteResult == 1 then
		--解散房间
		if mvcEngine.logicModuleIsShow(GUI_COMMONDIALOG) then
			CommonDialogLogic.checkClose()
		end
		if mvcEngine.logicModuleIsShow(GUI_MAHJONGDISMISSROOMREQUEST) then
			MahjongDismissRoomRequestLogic.waitClose()
		end
	end

	local function DismissVoteCallback()
		--回复消息接收
		ResumeSocket("DismissVote");
	end

	--显示动画延迟两秒
	GamePub.delayDoFunc(MahjongTableLogic.view, 3.5, DismissVoteCallback);
end

--推送用户游戏状态
local function readMJ_SC_GAME_PUSH_PLAYER_STATE()
	local pushPlayerStateData = MahjongLoadProfile.MahjongGameDoc.getPushPlayerStateTable()

	local UserID = pushPlayerStateData["UserID"]  --入局时间戳
	local SeatID = pushPlayerStateData["SeatID"]  --投票人
	local isOffline = pushPlayerStateData["isOffline"]  --是否是离线状态	1是0不是

	local player = getPlayer(SeatID)
	player.mIsOffline = isOffline;
	MahjongTablePlayerLayer.updateTablePlayerInfo(SeatID)

end

--距离警告
local function readMJ_SC_DISTANCE_ALERT()
	--	mvcEngine.createModule(GUI_MAHJONGTABLEDISTANCEWARNING);
	MahjongTableButtonLayer.setDistanceWarnVisible()
end

--查看个人信息
local function readMJ_SC_MGR_PLAYER_INFO_IN_TABLE()
	local userInfo = MahjongLoadProfile.MahjongUserInfo.getUserInfoTable()

	--	targetUserID	Int	查看的玩家id
	local UserID = userInfo["userID"];
	if PlayerInfo["UserID_"..UserID] == nil then
		PlayerInfo["UserID_"..UserID] = {}
	end
	PlayerInfo["UserID_"..UserID].UserID = UserID;
	Common.log("查看个人信息 userId == "..UserID)
	--nickName	Text	昵称
	PlayerInfo["UserID_"..UserID].nickName = userInfo["nickName"];
	--Sex	byte	性别	0=未知，1=男，2=女
	PlayerInfo["UserID_"..UserID].Sex = userInfo["sex"];
	-- ip	Text	IP地址
	PlayerInfo["UserID_"..UserID].ip = userInfo["ip"];
	--PhotoUrl	Text	头像
	PlayerInfo["UserID_"..UserID].PhotoUrl = userInfo["photoUrl"];
	--score	Long	积分
	PlayerInfo["UserID_"..UserID].fangkaCnt = userInfo["fangkaCnt"];
	--DistanceList	loop	和其他玩家的距离
	PlayerInfo["UserID_"..UserID].DistanceList = userInfo["DistanceList"];
	--MofaList	loop	魔法表情
	PlayerInfo["UserID_"..UserID].MofaList = userInfo["MofaList"];

end

--牌桌飞礼物消息
local function processMJ_SC_BROADCAST_FLY_GIFT()
	local sendMagicData = MahjongLoadProfile.MahjongUserInfo.getFlyGiftBroadcastTable()
	local TypeId = sendMagicData["TypeId"]  --类别ID	1礼物2.魔法表情
	local SourceUserId = sendMagicData["SourceUserId"]  --礼物来源玩家ID
	local TargetUserId = sendMagicData["TargetUserId"]  --接收礼物玩家ID
	local itemId = sendMagicData["itemId"]  --物品ID	礼物（1鲜花2豪车3豪宅4游轮） 魔法表情（1鲜花2西红柿3扔炸弹4吻）
	Common.log("itemId ============== "..itemId);
	local SourcePlayer = getPlayerByUserID(SourceUserId)
	local TargetPlayer = getPlayerByUserID(TargetUserId)
	if SourcePlayer == nil or TargetPlayer == nil then
		return
	end
	local fromPos = SourcePlayer.m_nPos;
	local toPos = TargetPlayer.m_nPos;
	local fromPosX = MahjongTableConfig.playerPhotoXY[fromPos + 1][1]
	local fromPosY = MahjongTableConfig.playerPhotoXY[fromPos + 1][2]
	local toPosX = MahjongTableConfig.playerPhotoXY[toPos + 1][1]
	local toPosY = MahjongTableConfig.playerPhotoXY[toPos + 1][2]
	if TypeId == MahjongLoadProfile.MahjongUserInfo.SEND_GIFT then
	--牌桌飞礼物
	elseif TypeId == MahjongLoadProfile.MahjongUserInfo.INTERACTION then
		--牌桌互动表情

		local isMoveRight = false
		if fromPosX > toPosX then
			isMoveRight = false
		else
			isMoveRight = true
		end
		MahjongInteractionAnim.showInteractionAnimStart(itemId,fromPosX,fromPosY,toPosX,toPosY,isMoveRight)
	elseif TypeId == MahjongLoadProfile.MahjongUserInfo.KICK_OUT then
	--牌桌踢人动画
	--		NiuNiuInteractionAnim.showKickOutAmin(toPosX,toPosY + 46)
	end
end

--聊天
local function processMJ_SC_ROOM_CHAT()
	Common.log("process 聊天应答 ")
	local chatData = MahjongLoadProfile.MahjongSocial.getTableChat()
	local seatId = chatData["position"] --发言者座位号	0-5,-1表示站立玩家
	local nickName = chatData["NickName"] --发言者昵称
	local type = chatData["Type"] --类型	1=普通表情，2=高级表情，3=文字
	local message = chatData["message"] --聊天内容	包括发送者昵称
	MahjongTablePlayerLayer.updateTableAfterPlayerChatServerBack(seatId, nickName, type, message)
end


local GameSyncTimer = nil;
local GameSynctimerNum = 0;

--[[--
--判断是否有断线续玩的结束处理
--]]
function closeLogicTime()
	Common.log("closeLogicTime ==================== ")
	MahjongLoadProfile.MahjongGameDoc.setIsGameSync(false);
	if (GameSyncTimer ~= nil) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(GameSyncTimer);
		GameSyncTimer = nil
	end
	GameSynctimerNum = 0;
end

--[[--
--根据时间判断是否退出牌桌
--]]
function logicCurrentTime()
	if GameConfig.getTheCurrentBaseLayer() == GUI_MAHJONGTABLE then
		if MahjongLoadProfile.MahjongGameDoc.getIsGameSync() then
			--已经断线续玩
			closeLogicTime();
		else
			--未断线续玩
			GameSynctimerNum = GameSynctimerNum + 1;
			Common.log("GameSynctimerNum ==================== "..GameSynctimerNum)
			if GameSynctimerNum > 5 then
				--时间定时器
				closeLogicTime();
				MahjongTableLogic.gameExit();
				Common.log("您的房间已解散 ==================== ")
				Common.showToast("您的房间已解散", 2);
			end
		end
	else
		closeLogicTime();
	end
end

--[[--
--重连成功以后判断是否有断线续玩
--]]
function logicGameSync()
	if isTableRecordMode then
		return;
	end
	Common.log("logicGameSync ==================== ")
	if GameConfig.getTheCurrentBaseLayer() == GUI_MAHJONGTABLE then
		--需要判断是否有断线续玩
		if GameSyncTimer == nil then
			GameSyncTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(logicCurrentTime, 1 ,false);
		end
	end
end

framework.addSlot2Signal(MJ_SC_GAME_TABLE_CHANGE, readMJ_SC_GAME_TABLE_CHANGE, true);

--[[--
--添加牌桌内消息监听
--]]
function addSignal()
	framework.addSlot2Signal(MJ_SC_MGR_QUIT_ROOM, readMJ_SC_MGR_QUIT_ROOM)
	framework.addSlot2Signal(MJ_SC_GAME_READY, readMJ_SC_GAME_READY)
	framework.addSlot2Signal(MJ_SC_GAME_SEND_CARD, readMJ_SC_GAME_SEND_CARD)
	framework.addSlot2Signal(MJ_SC_GAME_SEND_ACTION_OPTION, readMJ_SC_GAME_SEND_ACTION_OPTION)
	framework.addSlot2Signal(MJ_SC_GAME_SELECT_ACTION_OPTION, readMJ_SC_GAME_SELECT_ACTION_OPTION)
	framework.addSlot2Signal(MJ_SC_GAME_SEND_CHANGE_CARD, readMJ_SC_GAME_SEND_CHANGE_CARD)
	framework.addSlot2Signal(MJ_SC_GAME_SELECT_CHANGE_CARD, readMJ_SC_GAME_SELECT_CHANGE_CARD)
	framework.addSlot2Signal(MJ_SC_GAME_CHANGE_CARD_BROADCAST, readMJ_SC_GAME_CHANGE_CARD_BROADCAST)
	framework.addSlot2Signal(MJ_SC_GAME_SEND_DING_QUE, readMJ_SC_GAME_SEND_DING_QUE)
	framework.addSlot2Signal(MJ_SC_GAME_SELECT_DING_QUE, readMJ_SC_GAME_SELECT_DING_QUE)
	framework.addSlot2Signal(MJ_SC_GAME_DINGQUE_BROADCAST, readMJ_SC_GAME_DINGQUE_BROADCAST)
	framework.addSlot2Signal(MJ_SC_GAME_TING_SOLUTIONS, readMJ_SC_GAME_TING_SOLUTIONS)
	framework.addSlot2Signal(MJ_SC_GAME_TING_STATUS_CHANGED, readMJ_SC_GAME_TING_STATUS_CHANGED)
	framework.addSlot2Signal(MJ_SC_GAME_ROOM_RESULT, readMJ_SC_GAME_ROOM_RESULT) --房间总结果
	framework.addSlot2Signal(MJ_SC_GAME_DISMISS_ROOM, readMJ_SC_GAME_DISMISS_ROOM) --解散房间申请
	framework.addSlot2Signal(MJ_SC_GAME_DISMISS_VOTE, readMJ_SC_GAME_DISMISS_VOTE) --解散房间投票
	framework.addSlot2Signal(MJ_SC_GAME_PUSH_PLAYER_STATE, readMJ_SC_GAME_PUSH_PLAYER_STATE) --推送用户游戏状态

	framework.addSlot2Signal(MJ_SC_DISTANCE_ALERT, readMJ_SC_DISTANCE_ALERT) --距离警告
	framework.addSlot2Signal(MJ_SC_MGR_PLAYER_INFO_IN_TABLE, readMJ_SC_MGR_PLAYER_INFO_IN_TABLE) --个人信息
	framework.addSlot2Signal(MJ_SC_BROADCAST_FLY_GIFT, processMJ_SC_BROADCAST_FLY_GIFT) --牌桌飞礼物消息
	framework.addSlot2Signal(MJ_SC_ROOM_CHAT, processMJ_SC_ROOM_CHAT) --聊天

end

--[[--
--删除牌桌内消息监听
--]]
function removeSignal()
	framework.removeSlotFromSignal(MJ_SC_MGR_QUIT_ROOM, readMJ_SC_MGR_QUIT_ROOM)
	framework.removeSlotFromSignal(MJ_SC_GAME_READY, readMJ_SC_GAME_READY)
	framework.removeSlotFromSignal(MJ_SC_GAME_SEND_CARD, readMJ_SC_GAME_SEND_CARD)
	framework.removeSlotFromSignal(MJ_SC_GAME_SEND_ACTION_OPTION, readMJ_SC_GAME_SEND_ACTION_OPTION)
	framework.removeSlotFromSignal(MJ_SC_GAME_SELECT_ACTION_OPTION, readMJ_SC_GAME_SELECT_ACTION_OPTION)
	framework.removeSlotFromSignal(MJ_SC_GAME_SEND_CHANGE_CARD, readMJ_SC_GAME_SEND_CHANGE_CARD)
	framework.removeSlotFromSignal(MJ_SC_GAME_SELECT_CHANGE_CARD, readMJ_SC_GAME_SELECT_CHANGE_CARD)
	framework.removeSlotFromSignal(MJ_SC_GAME_CHANGE_CARD_BROADCAST, readMJ_SC_GAME_CHANGE_CARD_BROADCAST)
	framework.removeSlotFromSignal(MJ_SC_GAME_SEND_DING_QUE, readMJ_SC_GAME_SEND_DING_QUE)
	framework.removeSlotFromSignal(MJ_SC_GAME_SELECT_DING_QUE, readMJ_SC_GAME_SELECT_DING_QUE)
	framework.removeSlotFromSignal(MJ_SC_GAME_DINGQUE_BROADCAST, readMJ_SC_GAME_DINGQUE_BROADCAST)
	framework.removeSlotFromSignal(MJ_SC_GAME_TING_SOLUTIONS, readMJ_SC_GAME_TING_SOLUTIONS)
	framework.removeSlotFromSignal(MJ_SC_GAME_TING_STATUS_CHANGED, readMJ_SC_GAME_TING_STATUS_CHANGED)
	framework.removeSlotFromSignal(MJ_SC_GAME_ROOM_RESULT, readMJ_SC_GAME_ROOM_RESULT) --房间总结果
	framework.removeSlotFromSignal(MJ_SC_GAME_DISMISS_ROOM, readMJ_SC_GAME_DISMISS_ROOM) --解散房间申请
	framework.removeSlotFromSignal(MJ_SC_GAME_DISMISS_VOTE, readMJ_SC_GAME_DISMISS_VOTE) --解散房间投票
	framework.removeSlotFromSignal(MJ_SC_GAME_PUSH_PLAYER_STATE, readMJ_SC_GAME_PUSH_PLAYER_STATE) --推送用户游戏状态

	framework.removeSlotFromSignal(MJ_SC_DISTANCE_ALERT, readMJ_SC_DISTANCE_ALERT) --距离警告
	framework.removeSlotFromSignal(MJ_SC_MGR_PLAYER_INFO_IN_TABLE, readMJ_SC_MGR_PLAYER_INFO_IN_TABLE) --个人信息
	framework.removeSlotFromSignal(MJ_SC_BROADCAST_FLY_GIFT, processMJ_SC_BROADCAST_FLY_GIFT) --牌桌飞礼物消息
	framework.removeSlotFromSignal(MJ_SC_ROOM_CHAT, processMJ_SC_ROOM_CHAT) --聊天

end