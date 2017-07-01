module("MahjongTableRecordConsole", package.seeall)

--[[--
--同步牌桌数据
--]]
function readMJ_SC_GAME_SYNC_TABLE(RecordData)
	local dataTable = nil;

	MahjongTableConsole.releaseTableData();

	if RecordData ~= nil then
		dataTable = RecordData;
		MahjongTableConsole.isTableRecordMode = true;
	else
		dataTable = MahjongLoadProfile.MahjongGameDoc.getGameSyncTable();
		MahjongTableConsole.isTableRecordMode = false;
	end

	GameLoadModuleConfig.launchMiniGameByID(MahjongConfig.MahjongSichuanGameID, MahjongConfig.MahjongSichuanPackage);

	--CurrActionSeat	byte	当前操作者座位号
	local CurrActionSeat = dataTable["CurrActionSeat"];

	--TableState	byte	牌桌状态	0准备 1换三张 2定缺 3打牌
	local TableState = dataTable["TableStat"];
	if TableState == 0 then
		--0准备
		MahjongTableConsole.setStatus(MahjongTableConsole.STAT_WAITING_READY);
		sendMJ_SC_GAME_READY();
	elseif TableState == 1 then
		--1换三张
		MahjongTableConsole.setStatus(MahjongTableConsole.STAT_CHANGE_CARD);
	elseif TableState == 2 then
		--2定缺
		MahjongTableConsole.setStatus(MahjongTableConsole.STAT_DING_QUE);
	elseif TableState == 3 then
		--3打牌
		MahjongTableConsole.setStatus(MahjongTableConsole.STAT_TAKEOUT);
	end

	--RoomTitle	Text	房间标题
	MahjongTableConsole.mRoomTitle = dataTable["RoomTitle"];
	--roomId Int 房间ID RoomCode
	MahjongTableConsole.mRoomID = dataTable["roomId"];
	--CurrInning	byte	当前第几局
	MahjongTableConsole.mCurrInning = dataTable["CurrInning"];
	--TotalInning	byte	一共多少局
	MahjongTableConsole.mTotalInning = dataTable["TotalInning"];
	--RoomOwnerSeatID	Byte	房主位置
	MahjongTableConsole.mBankerSeatID = dataTable["RoomOwnerSeatID"];
	--Common.log("RoomOwnerSeatID ======== "..RoomOwnerSeatID);
	--LeaveCardsCnt	Short	剩余牌数量
	local LeaveCardsCnt = dataTable["LeaveCardsCnt"];

	--PlayerList	Loop	用户列表
	local PlayerListSize = #dataTable["PlayerList"];
	for i = 1, PlayerListSize do
		--...UserID	Int
		local UserID = dataTable["PlayerList"][i].UserID;
		--...SeatID	byte
		local SeatID = dataTable["PlayerList"][i].SeatID;
		if UserID == profile.User.getSelfUserID() then
			MahjongTableConsole.setSelfSeat(SeatID);
			break;
		end
	end

	if MahjongTableConsole.isTableRecordMode then
		--录像模式,如果找不到自己的视角，则使用房主视角
		if MahjongTableConsole.getSelfSeat() == -1 then
			MahjongTableConsole.setSelfSeat(MahjongTableConsole.mBankerSeatID);
		end
	end

	MahjongTableConsole.setCurrPlayer(CurrActionSeat);

	for i = 1, PlayerListSize do
		--...UserID	Int
		local UserID = dataTable["PlayerList"][i].UserID;
		--...SeatID	byte
		local SeatID = dataTable["PlayerList"][i].SeatID;
		if UserID == profile.User.getSelfUserID() then
			MahjongTableConsole.setSelfSeat(SeatID);
		end
		local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(SeatID);
		--...PhotoUrl	Text
		local PhotoUrl = dataTable["PlayerList"][i].PhotoUrl;
		--...Name	Text
		local Name = dataTable["PlayerList"][i].Name;
		--...HandCardStr	Text	自己牌的牌值	逗号隔开
		local HandCardStr = dataTable["PlayerList"][i].HandCardStr;
		Common.log("自己牌的牌值 HandCardStr ====== " .. HandCardStr);
		local CardsList = Common.FGUtilStringSplit(HandCardStr, ",");
		--...DisCardStr	Text	打出牌的牌值	逗号隔开
		local DisCardStr = dataTable["PlayerList"][i].DisCardStr;
		Common.log("打出牌的牌值 DisCardStr ====== " .. DisCardStr);
		--...LayDownCard	Loop	吃碰杠的牌
		local cardGroupSize = #dataTable["PlayerList"][i]["cardGroup"];
		for j = 1, cardGroupSize do
			--......cardType Byte 操作类型	牌型1：顺子 牌型3：碰牌 型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡实牌  牌型8：胡虚牌
			local cardType = dataTable["PlayerList"][i]["cardGroup"][j].cardType;
			--......cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开
			local cardStr = dataTable["PlayerList"][i]["cardGroup"][j].cardStr;
			--......FromSeatID	Byte	吃碰杠外来的牌来源座位号
			local FromSeatID = dataTable["PlayerList"][i]["cardGroup"][j].FromSeatID;
		end

		--...DingQueColor	byte	定缺花色	-1没定缺 -2已定缺，不广播 0万，1筒，2条
		local DingQueColor = dataTable["PlayerList"][i].DingQueColor;
		Common.log("DingQueColor ============== " .. DingQueColor)
		if SeatID == MahjongTableConsole.getSelfSeat() then
			MahjongTableConsole.mSelfQuePaiType = DingQueColor;
		end
		--...IsSendChangeCard	byte	是否已经上行换三张的牌	0否 1是
		local IsSendChangeCard = dataTable["PlayerList"][i].IsSendChangeCard;
		Common.log("IsSendChangeCard ============== " .. IsSendChangeCard)
		--...score	Long	积分（金币数）
		local score = dataTable["PlayerList"][i].score;
		Common.log("score ============== "..score)
		--...sex	Byte	性别	0=未知，1男，2女
		local sex = dataTable["PlayerList"][i].sex;
		Common.log("sex ============== "..sex)
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
		local HuNumber = dataTable["PlayerList"][i].HuNumber;
		Common.log("HuNumber ============== "..HuNumber)

		MahjongTableElementLayer.showPlayerHu(SeatID, HuNumber);
		--手牌
		MahjongTableCardLayer.addHandCard(PlayerPos, CardsList);
		--打出的牌
		local CardsList = Common.FGUtilStringSplit(DisCardStr, ",");
		MahjongTableCardLayer.addTakeOutCards(SeatID, CardsList);
		--放下的牌
		MahjongTableCardLayer.addPutDownCards(PlayerPos, dataTable["PlayerList"][i]["cardGroup"], true);
		--显示定缺标志
		MahjongTablePlayerLayer.showDingQue(SeatID, DingQueColor);

		if IsSendChangeCard == 1 then
			--显示换三张的牌堆
			MahjongTableElementLayer.showChangeCard(SeatID);
		end

		--	m_nPos = -1,-- 玩家位置，0，1，2...自己的位置永远是0,顺时针旋转
		MahjongTableConsole.mPlayers[SeatID + 1] = MahjongTablePlayer:new(UserID);
		-- ...userID Int 用户ID
		MahjongTableConsole.mPlayers[SeatID + 1].mUserID = UserID;
		-- ...SeatID byte 座位号 1-6
		MahjongTableConsole.mPlayers[SeatID + 1].mSeatID = SeatID;
		Common.log("mPlayers[SeatID].mSeatID === " .. MahjongTableConsole.mPlayers[SeatID + 1].mSeatID)
		--...NickName	text	昵称
		MahjongTableConsole.mPlayers[SeatID + 1].mNickName = Name;
		--...PhotoUrl	Text	头像Url
		MahjongTableConsole.mPlayers[SeatID + 1].mPhotoUrl = PhotoUrl;
		--...ChipCnt	long	筹码数
        if MahjongTableConsole.isTableRecordMode then
            MahjongTableConsole.mPlayers[SeatID + 1].mScore = 0;
        else
            MahjongTableConsole.mPlayers[SeatID + 1].mScore = score;
        end
		--...sex	Byte	性别	0=未知，1男，2女
		MahjongTableConsole.mPlayers[SeatID + 1].mSex = sex;
		MahjongTableConsole.mPlayers[SeatID + 1].mDingQueColor = DingQueColor;
		MahjongTableConsole.mPlayers[SeatID + 1].mIsSendChangeCard = IsSendChangeCard;

		sendMJ_SC_MGR_PLAYER_INFO_IN_TABLE(MahjongTableConsole.mPlayers[SeatID + 1].mUserID)
	end

	for key, player in pairs(MahjongTableConsole.mPlayers) do
		if player ~= nil then
			local pos = MahjongTableConsole.getPlayerPosBySeat(player.mSeatID);
			Common.log("房间牌桌同步应答 seatid== " .. player.mSeatID .. "  pos == " .. pos)
			player.m_nPos = pos;
			MahjongTablePlayerLayer.addMahjongTablePlayer(player.mSeatID);
			--			MahjongTablePlayerLayer.updateTablePlayerInfo(player.mSeatID)
			MahjongTablePlayerLayer.updateTablePlayerState(player.mSeatID)
			Common.getPicFile(player.mPhotoUrl, player.mSeatID + 1, true, MahjongTablePlayerLayer.updatePlayerPhoto, true);
		end
	end

	MahjongTableLogic.refreshPlayerDir();
	MahjongTableLogic.setSurplusCard(LeaveCardsCnt);
	MahjongTableButtonLayer.refreshRoomDetailsInfo();
end

--[[--
-- 推送发一张牌【摸牌】(MJ_SC_GAME_DEAL_CARD)
-- ]]
function readMJ_SC_GAME_DEAL_CARD(RecordData)
	PauseSocket("MahjongDealCard");

	local dataTable = nil;
	if RecordData ~= nil then
		dataTable = RecordData;
	else
		dataTable = MahjongLoadProfile.MahjongGameDoc.getDealCardTable();
	end
	--    SeatID	byte	这张牌发给谁（谁摸的牌）
	local SeatID = dataTable["SeatID"];

	local function DealCardCallback()
		--回复消息接收
		MahjongTableConsole.setCurrPlayer(SeatID);
		--    CardVal	Short	牌值（非牌主人发-1）
		local CardVal = dataTable["CardVal"];
		--    LeaveCardsCnt	Short	剩余牌数量
		local LeaveCardsCnt = dataTable["LeaveCardsCnt"];
		--Common.showToast("剩余牌数量 : " .. LeaveCardsCnt, 2);
		MahjongTableLogic.setSurplusCard(LeaveCardsCnt);
		MahjongTableCardLayer.addHandCard(MahjongTableConsole.getPlayerPosBySeat(SeatID), { CardVal });
		ResumeSocket("MahjongDealCard");
	end

	if MahjongTableConsole.getCurrPlayer() == MahjongTableConsole.getSelfSeat() or MahjongTableConsole.isTableRecordMode then
		--自己操作的时候摸牌,录像不暂停
		DealCardCallback();
	else
		--显示动画延迟1秒
		GamePub.delayDoFunc(MahjongTableLogic.view, 1, DealCardCallback);
	end
end

--[[--
-- 推送出牌
-- ]]
function readMJ_SC_GAME_DISCARD(RecordData)
	local dataTable = nil;
	if RecordData ~= nil then
		dataTable = RecordData;
	else
		dataTable = MahjongLoadProfile.MahjongGameDoc.getDisCardTable();
	end
	--    SeatID	byte	出牌者的座位号
	local SeatID = dataTable["SeatID"];
	MahjongTableConsole.setCurrPlayer(SeatID);
	Common.log("SeatID ============== " .. SeatID);
	--    CardVal	Short	出牌者出的牌值
	local CardVal = dataTable["CardVal"];
	Common.log("CardVal ============== " .. CardVal);
	MahjongAudioManager.playMahjongSound("MJ_DAPAI", -1);
	MahjongAudioManager.playMahjongCardSound(CardVal, MahjongTableConsole.getPlayer(SeatID).mSex);
	MahjongTableConsole.setCurrCardValue(CardVal);

	MahjongTableCardLayer.showLastTakeOutCard(SeatID, CardVal);
	MahjongTableCardLayer.addTakeOutCards(SeatID, { CardVal });
	MahjongTableCardLayer.removeHandCard(MahjongTableConsole.getPlayerPosBySeat(SeatID), CardVal .. "");
end

--[[--
-- 广播操作结果(MJ_SC_GAME_ACTION_BROADCAST)
-- ]]
function readMJ_SC_GAME_ACTION_BROADCAST(RecordData)
	local dataTable = nil;
	if RecordData ~= nil then
		dataTable = RecordData;
	else
		dataTable = MahjongLoadProfile.MahjongGameDoc.getActionBroadcastTable();
	end
	--    SeatID	Byte	操作者座位号
	local SeatID = dataTable["SeatID"];
	MahjongTableConsole.setCurrPlayer(SeatID);
	local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(SeatID);
	--    DisCardVal	Int	出牌者的牌
	local DisCardVal = dataTable["DisCardVal"];
	--    DisSeatID	Byte	出牌者的座位号
	local DisSeatID = dataTable["DisSeatID"];
	--    ActionType	Byte	当前操作类型	0：同步放下牌 牌型1：顺子 牌型3：碰 牌型4：明杠 牌型5：暗杠
	local ActionType = dataTable["ActionType"];
	Common.log(" ActionType ================ " .. ActionType);

	if ActionType ~= 0 then
		--处理牌型逻辑
		if ActionType == 3 then
			-- 牌型3：碰
			MahjongTableArmature.showCardZiAnim(PlayerPos, MahjongTableArmature.ARMATURE_CARD_ZI_PENG);
			MahjongAudioManager.playMahjongSound("PENG", MahjongTableConsole.getPlayer(SeatID).mSex);
		elseif ActionType == 4 then
			-- 牌型4：明杠
			MahjongTableArmature.showCardZiAnim(PlayerPos, MahjongTableArmature.ARMATURE_CARD_ZI_GANE);
			MahjongAudioManager.playMahjongSound("MING_GANE", MahjongTableConsole.getPlayer(SeatID).mSex);
		elseif ActionType == 5 then
			-- 牌型5：暗杠
			MahjongTableArmature.showCardZiAnim(PlayerPos, MahjongTableArmature.ARMATURE_CARD_ZI_GANE);
			MahjongAudioManager.playMahjongSound("AN_GANE", MahjongTableConsole.getPlayer(SeatID).mSex);
		end
		MahjongAudioManager.playMahjongSound("MJ_DAPAI", -1);
		-- cardGroup	Loop	同步当前操作者的桌面牌
		-- local cardGroupSize = #dataTable["cardGroup"];
		-- Common.log("广播操作结果 cardGroupSize ================ " .. cardGroupSize);
		-- HandCardsSize	Short	操作者剩余手牌数
		local HandCardsSize = dataTable["HandCardsSize"];
		Common.log("操作者剩余手牌数 =========== " .. HandCardsSize);

		MahjongTableCardLayer.removeLastTakeOutCard();

		for index, cardsInfo in pairs(dataTable["cardGroup"]) do
			MahjongTableCardLayer.removeHandCard(MahjongTableConsole.getPlayerPosBySeat(SeatID), cardsInfo.cardStr, HandCardsSize);
		end
		MahjongTableButtonLayer.hidePanelCaoZuoVisible();
	else
	--0：同步放下牌

	end

	MahjongTableCardLayer.addPutDownCards(PlayerPos, dataTable["cardGroup"], false);

end

--[[--
--胡牌结果广播
--]]
function readMJ_SC_GAME_HU_RESULT_BROADCAST(RecordData)
	PauseSocket("MahjongHuResult");

	local dataTable = nil;
	if RecordData ~= nil then
		dataTable = RecordData;
	else
		dataTable = MahjongLoadProfile.MahjongGameDoc.getHuResultBroadcastTable();
	end

	--DisCardVal	Int	胡的是哪张牌
	local DisCardVal = dataTable["DisCardVal"];
	--DisCardSeatID	Byte	出牌者的座位号
	local DisCardSeatID = dataTable["DisCardSeatID"];
	--HuType	Byte	胡牌类型	1胡2自摸3杠上开花4海底捞月5抢杠胡6一炮双响7一炮多响8呼叫转移
	local HuType = dataTable["HuType"];
	Common.log("HuType ============= "..HuType);
	for i = 1, #dataTable["HuUserList"] do
		--...SeatId	Byte	胡牌座位号
		local SeatID = dataTable["HuUserList"][i].SeatId;
		--...State	Byte	是否真胡	1实牌0虚牌
		local State = dataTable["HuUserList"][i].State;
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
		local HuNumber = dataTable["HuUserList"][i].HuNumber;

		if SeatID == MahjongTableConsole.getSelfSeat() then
			MahjongTableConsole.clearTingPaiList();
		end

		MahjongTableCardLayer.addPutDownCardsForHu(SeatID, DisCardVal, DisCardSeatID, HuType, State);
		if HuType == 2 or HuType == 3 or HuType == 4 then
			--2自摸3杠上开花4海底捞月
			--自摸删除手牌
			MahjongTableCardLayer.removeHandCard(MahjongTableConsole.getPlayerPosBySeat(SeatID), DisCardVal .. "");
		end
	end

	MahjongTableCardLayer.removeLastTakeOutCard();

	local function HuResultCallback()
		--回复消息接收
		for i = 1, #dataTable["HuUserList"] do
			--...SeatId	Byte	胡牌座位号
			local SeatID = dataTable["HuUserList"][i].SeatId;
			--...State	Byte	是否真胡	1实牌0虚牌
			local State = dataTable["HuUserList"][i].State;
			--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
			local HuNumber = dataTable["HuUserList"][i].HuNumber;

			MahjongTableElementLayer.showPlayerHu(SeatID, HuNumber);
		end
		ResumeSocket("MahjongHuResult");
	end

	if MahjongTableConsole.isTableRecordMode then
		HuResultCallback();
	else
		--显示动画延迟两秒
		GamePub.delayDoFunc(MahjongTableLogic.view, 2, HuResultCallback);
	end

	MahjongTableButtonLayer.hidePanelCaoZuoVisible();
end

--[[--
--游戏结果
--]]
function readMJ_SC_GAME_GAME_RESULT(RecordData)

	PauseSocket("MahjongGameResult");

	local dataTable = nil;
	if RecordData ~= nil then
		dataTable = RecordData;
	else
		dataTable = MahjongLoadProfile.MahjongGameDoc.getGameResultTable();
	end

	MahjongTableConsole.setStatus(MahjongTableConsole.STAT_GAME_RESULT);

	local function GameResultCallback()
		--PlayerList	Loop	用户列表
		local PlayerListSize = #dataTable["PlayerList"];
		for i = 1, PlayerListSize do
			--...UserID	Int
			local UserID = dataTable["PlayerList"][i].UserID;
			--...SeatID	byte
			local SeatID = dataTable["PlayerList"][i].SeatID;
			--...PhotoUrl	Text
			local PhotoUrl = dataTable["PlayerList"][i].PhotoUrl;
			--...Name	Text
			local Name = dataTable["PlayerList"][i].Name;
			--...Fan	Int	胡多少番	没胡0
			local Fan = dataTable["PlayerList"][i].Fan;
			--...Score	Long	输赢多少分	分正负
			local Score = dataTable["PlayerList"][i].Score;
			--...FanTypeStr	Text	番型提示
			local FanTypeStr = dataTable["PlayerList"][i].FanTypeStr;
			--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
			local HuNumber = dataTable["PlayerList"][i].HuNumber;

			--...cardGroup	Loop	同步当前操作者的桌面牌
			local cardGroupSize = #dataTable["PlayerList"][i]["cardGroup"];
			Common.log("游戏结果 cardGroupSize =============== " .. cardGroupSize);
			local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(SeatID);
			MahjongTableCardLayer.addPutDownCards(PlayerPos, dataTable["PlayerList"][i]["cardGroup"], false);
            if MahjongTableConsole.isTableRecordMode then
                MahjongTableConsole.mPlayers[SeatID + 1].mScore = Score;
            else
                MahjongTableConsole.mPlayers[SeatID + 1].mScore = MahjongTableConsole.mPlayers[SeatID + 1].mScore + Score;
            end
			MahjongTablePlayerLayer.updateTablePlayerInfo(SeatID)
		end

		MahjongAudioManager.playMahjongSound("MJ_TUIPAI", -1);
		--移除手牌
		MahjongTableCardLayer.removeAllHandCards();

		MahjongTableLogic.setSurplusCardVisible(false);

		local function showGameResultInfo()
			mvcEngine.createModule(GUI_MAHJONGGAMERESULT);
			MahjongGameResultLogic.refreshGameResultInfo(dataTable);
		end

		--延迟两秒显示结算界面
		GamePub.delayDoFunc(MahjongTableLogic.view, 2, showGameResultInfo);
	end

	local MaxHuNumber = 0;--最后一个胡牌数

	--PlayerList	Loop	用户列表
	local PlayerListSize = #dataTable["PlayerList"];
	for i = 1, PlayerListSize do
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
		local HuNumber = dataTable["PlayerList"][i].HuNumber;
		if HuNumber == 255 then
			HuNumber = -1;
		end
		if MaxHuNumber < HuNumber then
			MaxHuNumber = HuNumber;
		end
	end

	if MahjongTableConsole.isTableRecordMode then
		--录像不会延时
		GameResultCallback();
	else
		if MaxHuNumber == 0 then
			MahjongTableElementLayer.showLiuJuAnim();
			--延迟两秒显示结算界面
			GamePub.delayDoFunc(MahjongTableLogic.view, 1.5, GameResultCallback);
		else
			GameResultCallback();
		end
	end
end


framework.addSlot2Signal(MJ_SC_GAME_SYNC_TABLE, readMJ_SC_GAME_SYNC_TABLE, true);

--[[--
--添加牌桌内消息监听
--]]
function addSignal()
	framework.addSlot2Signal(MJ_SC_GAME_DISCARD, readMJ_SC_GAME_DISCARD)
	framework.addSlot2Signal(MJ_SC_GAME_DEAL_CARD, readMJ_SC_GAME_DEAL_CARD)
	framework.addSlot2Signal(MJ_SC_GAME_ACTION_BROADCAST, readMJ_SC_GAME_ACTION_BROADCAST)
	framework.addSlot2Signal(MJ_SC_GAME_GAME_RESULT, readMJ_SC_GAME_GAME_RESULT)
	framework.addSlot2Signal(MJ_SC_GAME_HU_RESULT_BROADCAST, readMJ_SC_GAME_HU_RESULT_BROADCAST)
end

--[[--
--删除牌桌内消息监听
--]]
function removeSignal()
	framework.removeSlotFromSignal(MJ_SC_GAME_DISCARD, readMJ_SC_GAME_DISCARD)
	framework.removeSlotFromSignal(MJ_SC_GAME_DEAL_CARD, readMJ_SC_GAME_DEAL_CARD)
	framework.removeSlotFromSignal(MJ_SC_GAME_ACTION_BROADCAST, readMJ_SC_GAME_ACTION_BROADCAST)
	framework.removeSlotFromSignal(MJ_SC_GAME_GAME_RESULT, readMJ_SC_GAME_GAME_RESULT)
	framework.removeSlotFromSignal(MJ_SC_GAME_HU_RESULT_BROADCAST, readMJ_SC_GAME_HU_RESULT_BROADCAST)
end