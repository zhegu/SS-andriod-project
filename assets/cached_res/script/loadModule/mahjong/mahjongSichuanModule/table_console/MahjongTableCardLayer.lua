--存放牌桌上所有显示的牌以及结算金币，位于牌桌第二层
module("MahjongTableCardLayer", package.seeall)

local CardLayer = nil; --存放牌桌上展示的牌

local HandCardBatchNode = nil; --自己存放牌桌上展示的牌，位置0

local HandCards = {}; --玩家的手牌(下标是牌桌的位置+1 ====== pos+1)
local PutDownCards = {}; --放下的牌(下标是牌桌的位置+1 ====== pos+1)
local TakeOutCards = {}; --打出去的牌(下标是牌桌的位置+1 ====== pos+1)

local lastTakeOutCard = nil; --上一张打出的牌

local selfMoveCard = nil; --自己拖动的牌

function getTableHandCards()

	return HandCards;
end

function getTablePutDownCards()

	return PutDownCards;
end

function getTableTakeOutCards()

	return TakeOutCards;
end

--[[--
--创建纸牌层
--]]
local function creatCardLayer()
	CardLayer = CCLayer:create()
	CardLayer:registerScriptTouchHandler(MahjongTableOnTouch.OnTouchEvent)
	setCardLayerTouchEnabled(true)
	CardLayer:setZOrder(1)

	HandCards[1] = {};
	HandCards[2] = {};
	HandCards[3] = {};
	HandCards[4] = {};

	HandCardBatchNode = CCSpriteBatchNode:create(MahjongTableConfig.getCardResPath("MJ_HandCardsTPlist.pvr.ccz"))
	CardLayer:addChild(HandCardBatchNode);

	CardLayer:addChild(MahjongTableTingCardsLayer.getTingCardsLayer());
end


--[[--
--设置出牌触摸监听
--]]
function setCardLayerTouchEnabled(isTouchEnabled)
	CardLayer:setTouchEnabled(isTouchEnabled)
end

--[[--
--获取纸牌层
--]]
function getCardLayer()
	if CardLayer == nil then
		creatCardLayer()
	end
	return CardLayer
end

--[[--
--显示正面
--]]
function showCardFront(sender)
	sender:showFront()
end

--[[--
--获取自己的手牌
--]]
function getSelfCards()
	return HandCards[1];
end

--[[--
--得到手牌数量
--]]
function getHandCardsCnt(Pos)
	local CardsCnt = 0
	if HandCards[Pos + 1] ~= nil then
		CardsCnt = #HandCards[Pos + 1]
	end
	return CardsCnt
end

--[[--
--通过别人打出的牌查找自己可以碰/杠的牌的数列
--]]
function getSameCardsListForOther(nNumber)
	Common.log("nNumber ============= " .. nNumber);
	local CardsList = {};
	if nNumber == -1 then
		return CardsList;
	end

	local m_nColor, m_nWhat = MahjongCardDoc.getCardInfoByValue(MahjongTableConsole.getCurrCardValue());
	Common.log("自己可以碰的牌 MahjongTableConsole.getCurrCardValue() ============= " .. MahjongTableConsole.getCurrCardValue());
	Common.log("自己可以碰的牌 m_nWhat ============= " .. m_nWhat);
	Common.log("自己可以碰的牌 m_nColor ============= " .. m_nColor);

	table.insert(CardsList, MahjongTableConsole.getCurrCardValue());
	for index, card in pairs(getSelfCards()) do
		if MahjongTableConsole.getCurrCardValue() ~= card.m_nValue then
			Common.log("getSelfCards card.m_nWhat ============= " .. card.m_nWhat);
			Common.log("getSelfCards card.m_nColor ============= " .. card.m_nColor);
			if card.m_nWhat == m_nWhat and card.m_nColor == m_nColor then
				table.insert(CardsList, card.m_nValue);
				if #CardsList == nNumber then
					break;
				end
			end
		end
	end

	if #CardsList ~= nNumber then
		CardsList = {};
	end
	--	for i, value in pairs(CardsList) do
	--		Common.log("getSameCardsList CardsList ============== value == "..value);
	--	end
	return CardsList;
end

local function resetSameCardCnt()
	for key, card in pairs(getSelfCards()) do
		card.m_nSameCardCnt = -1;
	end
end

--[[--
--通过自己的牌查找杠的牌(默认数组已升幂排序)
--@param #number nCardNum 需要查找的牌的相同张数
--]]
function getSameCardsListForGang(CardsListForOther)
	local GangMultiSelectList = {};
	local nCardNum = 4;
	local suffix = 1;

	resetSameCardCnt();

	for i, card in pairs(getSelfCards()) do
		if i >= suffix then
			for key, var in pairs(CardsListForOther) do
				if var == card.m_nValue then
					card.m_nSameCardCnt = 4;
					break;
				end
			end
			if card.m_nSameCardCnt < 0 then
				--此牌没有被摆放过
				local n = MahjongTableCardManage.SearchSameCard(getSelfCards(), i, card.m_nColor, card.m_nWhat, nCardNum);
				--Common.log("n =============== "..n)
				if n > 0 then
					GangMultiSelectList[#GangMultiSelectList + 1] = {};
					for j = 1, n do
						getSelfCards()[suffix].m_nSameCardCnt = nCardNum;
						table.insert(GangMultiSelectList[#GangMultiSelectList], getSelfCards()[suffix].m_nValue);
						suffix = suffix + 1
						--Common.log("suffix =========== "..suffix);
					end
				else
					suffix = suffix + 1;
				end
			else
				suffix = suffix + 1;
			end
		end
	end

	resetSameCardCnt();

	if PutDownCards[1] == nil then
		--自己放下的牌
		return GangMultiSelectList;
	end
	for i, SelfCard in pairs(getSelfCards()) do
		for key, var in pairs(CardsListForOther) do
			if var == SelfCard.m_nValue then
				SelfCard.m_nSameCardCnt = 4;
				break;
			end
		end
		if SelfCard.m_nSameCardCnt < 0 then
			local CardsList = {};
			local m_nColor, m_nWhat = MahjongCardDoc.getCardInfoByValue(SelfCard.m_nValue);
			table.insert(CardsList, SelfCard.m_nValue);
			--Common.log("SelfCard ============== m_nValue == "..SelfCard.m_nValue);
			--Common.log("SelfCard ============== m_nWhat == "..m_nWhat);
			--Common.log("SelfCard ============== m_nColor == "..m_nColor);
			for index, cardList in pairs(PutDownCards[1]) do
				for j, card in pairs(cardList) do
					--Common.log("cardList["..j.."]============== card.m_nValue == "..card.m_nValue);
					--Common.log("cardList["..j.."]============== card.m_nWhat == "..card.m_nWhat);
					--Common.log("cardList["..j.."]============== card.m_nColor == "..card.m_nColor);
					if card.m_nWhat == m_nWhat and card.m_nColor == m_nColor then
						table.insert(CardsList, card.m_nValue);
						Common.log("#CardsList ========== "..#CardsList);
						if #CardsList == nCardNum then
							break;
						end
					end
				end
				if #CardsList == nCardNum then
					GangMultiSelectList[#GangMultiSelectList + 1] = CardsList;
					break;
				end
			end
		end
	end

	resetSameCardCnt();

	return GangMultiSelectList;
end

--[[--
--获取杠牌列表
--]]
function getGangCardsList()
	local SameCardsListForGang = {};
	local SameCardsListForOther = getSameCardsListForOther(4);

	if #SameCardsListForOther > 0 then
		--需要他人牌的杠
		if MahjongTableConsole.getCurrPlayer() == MahjongTableConsole.getSelfSeat() then
			--自己的摸牌暗杠
			table.insert(SameCardsListForGang, SameCardsListForOther);
		else
			return SameCardsListForOther;
		end
	end

	local SameCardsListForSelf = getSameCardsListForGang(SameCardsListForOther);
	for i, valueList in pairs(SameCardsListForSelf) do
		--自己手牌中的杠
		table.insert(SameCardsListForGang, valueList);
	--		for j, value in pairs(valueList) do
	--			Common.log("getGangCardsList value ========== "..value);
	--		end
	end
	Common.log("getGangCardsList #SameCardsListForGang ======= "..#SameCardsListForGang);
	if #SameCardsListForGang > 1 then
		--多个杠
		--显示多个杠的选择界面
		MahjongTableButtonLayer.showGangMultiSelect(SameCardsListForGang);
		return nil;
	else
		--一个杠
		return SameCardsListForGang[1];
	end
end

--[[--
--是否是出牌
--]]
function isTakeOutByPos(mPos)
	if getHandCardsCnt(mPos) % 3 == 2 then
		return true
	end
	return false;
end

--[[--
--是否是缺一门中的牌
--]]
local function isQingQueCard(nColor)
	if MahjongTableConsole.getSelfQuePaiType() == nColor then
		return true;
	end
	return false;
end

--[[--
--自己是否有缺一门中的牌
--]]
local function isSelfHaveQueCard()
	for index, card in pairs(getSelfCards()) do
		if isQingQueCard(card.m_nColor) then
			return true;
		end
	end
	return false;
end

--[[--
--显示听口牌
--]]
function showTingCards(SelectCardValueList)
	hideTingCards();
	for index, SelectCardValue in pairs(SelectCardValueList) do
		for index, card in pairs(getSelfCards()) do
			if card.m_nValue == SelectCardValue then
				card:setTingHint(true);
				break;
			end
		end
	end
end

--[[--
--隐藏听口牌
--]]
function hideTingCards()
	for index, card in pairs(getSelfCards()) do
		card:setTingHint(false);
	end
end

--[[--
--添加自己的手牌(需要多次刷新，所以先加入layer中)
--@table cards card 纸牌牌值
--]]
function addHandCard(mPos, cardsValTable)
	if cardsValTable ~= nil then
		local Dir = mPos;
		Common.log("Dir ============== " .. Dir);
		local Face = -1;
		if MahjongTableConsole.isTableRecordMode then
			Face = MahjongCardDoc.MJ_FACE_TING_CARD;
		else
			Face = MahjongCardDoc.MJ_FACE_HAND_CARD;
		end

		for index, cardValue in pairs(cardsValTable) do
			local value = tonumber(cardValue);
			Common.log("addHandCard value = " .. value);
			local card = MahjongTableCard:newCard(value, Dir, Face);
			table.insert(HandCards[mPos + 1], card);
			HandCardBatchNode:addChild(card.m_CardSprite);
		end

		if #cardsValTable == 1 then
			--摸一张牌不要马上排序，出牌后在排序
			refreshHandCard(mPos, false);
		else
			refreshHandCard(mPos, true);
		end
	end
end

--[[--
--刷新自己的手牌
--]]
function refreshHandCard(mPos, isSort)
	local pos = mPos + 1;

	local MaxIndex = 13;
	if isTakeOutByPos(mPos) then
		--当前自己出牌
		MaxIndex = 14;
	end

	if mPos == 0 then
		--自己的手牌
		if isSelfHaveQueCard() then
			--有缺牌时，需要标识可以出的牌
			for index, card in pairs(HandCards[pos]) do
				if not isQingQueCard(card.m_nColor) then
					card:setTouchMarked(true);
					card:setSelected(false);
				end
			end
		else
			for index, card in pairs(HandCards[pos]) do
				card:setTouchMarked(false);
				card:setSelected(false);
			end
		end
	end

	if (mPos == 0 or MahjongTableConsole.isTableRecordMode) and isSort then
		--自己的手牌或者是录像模式
		MahjongTableCardManage.SortCardVal(HandCards[pos], MahjongTableCardManage.SORT_MODE_COLOR);
	end

	for index, card in pairs(HandCards[pos]) do
		card:setCardRanks(1, index + (MaxIndex - #HandCards[pos]));
	end

	showAllCardsIdentify();
end

--[[--
--删除自己的手牌
--@param table Cards 牌值
--]]
function removeHandCard(mPos, CardStr, surplusCardsSize)
	local pos = mPos + 1;
	local Cards = Common.FGUtilStringSplit(CardStr, ",");
	if #Cards == 0 then
		return;
	end
	if surplusCardsSize == nil then
		surplusCardsSize = 1;
	end

	if mPos == 0 or MahjongTableConsole.isTableRecordMode then
		if HandCards[pos] ~= nil then
			local Index = 1;
			while Index <= table.maxn(HandCards[pos]) do
				if HandCards[pos][Index] ~= nil then
					local isHave = false
					for j = 1, #Cards do
						--Common.log("Cards[j] =========== "..Cards[j])
						if HandCards[pos][Index].m_nValue == tonumber(Cards[j]) then
							HandCardBatchNode:removeChild(HandCards[pos][Index].m_CardSprite, true);
							table.remove(HandCards[pos], Index);
							isHave = true;
							break;
						end
					end
					if not isHave then
						Index = Index + 1;
					end
				end
			end
		end
	else
		local HandCardsSize = #HandCards[pos];
		if #Cards > 1 then
			for i = HandCardsSize, surplusCardsSize + 1, -1 do
				HandCardBatchNode:removeChild(HandCards[pos][i].m_CardSprite, true);
				table.remove(HandCards[pos], i);
			end
		else
			--删除一张牌(最后一张)
			HandCardBatchNode:removeChild(HandCards[pos][HandCardsSize].m_CardSprite, true);
			table.remove(HandCards[pos], HandCardsSize);
		end
	end

	refreshHandCard(mPos, true);
end

--[[--
--删除自己所有的手牌
--]]
function removeAllHandCards()
	if HandCards ~= nil then
		for index, cardList in pairs(HandCards) do
			for index, card in pairs(cardList) do
				HandCardBatchNode:removeChild(card.m_CardSprite, true)
			end
		end
	end
	HandCards = {};
	HandCards[1] = {};
	HandCards[2] = {};
	HandCards[3] = {};
	HandCards[4] = {};
end

--[[--
--获取已经选中的牌
--@return #table cards
--]]
function getSelectCard()
	local cards = {};
	for index, card in pairs(getSelfCards()) do
		if (card.m_bSelected) then
			table.insert(cards, card);
		end
	end
	return cards;
end

--[[--
--设置手牌选中
--]]
function setSelectCard(cardsValTable)
	for i = 1, #cardsValTable do
		local value = tonumber(cardsValTable[i]);
		--Common.log("value =========== "..value)
		for index, card in pairs(getSelfCards()) do
			if (card:getValue() == value) then
				card:setSelected(true);
			end
		end
	end
end

--[[--
--添加放下的手牌
--@param #number nPos 位置
--@param #table cardsInfoTable 操作类型
--]]
function addPutDownCards(nPos, cardsInfoTable, isSync)

	removeAllPutDownCardsByPos(nPos);

	local cardGroupSize = #cardsInfoTable;
	for i = 1, cardGroupSize do
		--    ...cardType	Byte	操作类型	牌型1：顺子 牌型3：碰 牌型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡实牌  牌型8：胡虚牌
		local cardType = cardsInfoTable[i].cardType;
		Common.log("cardType =============== " .. cardType);
		--    ...cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开 暗杠牌值其他家为-1
		local cardStr = cardsInfoTable[i].cardStr;
		Common.log("cardStr =============== " .. cardStr);
		local cardsValTable = Common.FGUtilStringSplit(cardStr, ",");
		--    ...FromSeatID	Byte	吃碰杠外来的牌来源座位号
		local FromSeatID = -1;
		if cardsInfoTable[i].FromSeatID ~= nil then
			FromSeatID = cardsInfoTable[i].FromSeatID;
		end
		Common.log("FromSeatID =============== " .. FromSeatID);

		PutDownCards[nPos + 1][i] = {};

		--		if cardType == 4 then
		--			cardType = 5;
		--		end

		for j = 1, #cardsValTable do
			local value = tonumber(cardsValTable[j]);
			removeTakeOutCardByValue(value);
			Common.log("addPutDownCards  = " .. value);
			local card = nil;
			local nDir = nPos;
			local nFace = -1;

			if cardType == 5 then
				--牌型5：暗杠
				nFace = MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD;
			elseif cardType == 6 then
				--牌型6：手牌
				nFace = MahjongCardDoc.MJ_FACE_TING_CARD;
			elseif cardType == 7 or cardType == 8 then
				--牌型7：胡实牌  牌型8：胡虚牌
				nFace = MahjongCardDoc.MJ_FACE_HU_CARD;
			else
				--牌型1：顺子--牌型3：碰--牌型4：明杠
				nFace = MahjongCardDoc.MJ_FACE_PUTDOWN_CARD;
			end

			card = MahjongTableCard:newCard(value, nDir, nFace);
			card.m_nCardType = cardType;
			card.m_nFromSeatID = FromSeatID;
			table.insert(PutDownCards[nPos + 1][i], card);
		end

		if cardType == 6 then
			--牌型6：手牌
			MahjongTableCardManage.SortCardVal(PutDownCards[nPos + 1][i], MahjongTableCardManage.SORT_MODE_COLOR);
		end
		-- Common.log("nPos ======== "..nPos);
		-- Common.log("i ======== "..i);
		local size = #PutDownCards[nPos + 1][i];
		for w = 1, size do
			local card = PutDownCards[nPos + 1][i][w];
			if card.m_nCardType == 1 or card.m_nCardType == 3 or card.m_nCardType == 4 then
				--牌型1：顺子--牌型3：碰--牌型4：明杠
				--Common.log("w =========== "..w);
				card:setCardRanks(1, w + 4 * (i - 1));
				if FromSeatID ~= -1 then
					if (size == 3 and w == 2) or (size == 4 and w == 4) then
						--碰的第二张或杠的第四张
						local sprite = CCSprite:createWithSpriteFrameName("MJ_btn_jiantou.png");
						sprite:setScale(0.8);
						local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(FromSeatID);
						local Offset = 5;
						if PlayerPos == 0 then
							sprite:setRotation(90);
						elseif PlayerPos == 1 then
							--右侧
							sprite:setRotation(0);
						elseif PlayerPos == 2 then
							--对面
							sprite:setRotation(-90);
						elseif PlayerPos == 3 then
							--左侧
							sprite:setRotation(180);
						end

						if nPos == 0 then
							sprite:setPosition(-5, -40);
						elseif nPos == 1 then
							--右侧
							sprite:setPosition(-40, 3);
						elseif nPos == 2 then
							--对面
							sprite:setPosition(0, -20);
						elseif nPos == 3 then
							--左侧
							sprite:setPosition(40, 3);
						end
						card.m_CardSprite:addChild(sprite);
					end
				end
			elseif card.m_nCardType == 5 then
				--牌型5：暗杠
				card:setCardRanks(1, w + 4 * (i - 1));
			elseif card.m_nCardType == 6 then
				--牌型6：手牌
				if size == 14 then
					card:setCardRanks(1, w);
				else
					card:setCardRanks(1, w + (13 - size));
				end
			elseif cardType == 7 or cardType == 8 then
				--牌型7：胡实牌  牌型8：胡虚牌
				card:setCardRanks(1, w);
				if cardType == 8 then
					card:setCardRanks(1, w);
				end
			end
			HandCardBatchNode:addChild(card.m_CardSprite);
		end
	end
end

--[[--
--添加放下的手牌
--@param #number HuSeatID 位置
--@param #number cardValue 胡牌的牌值
--@param #number DianPaoSeatID 点炮人的SeatID
--@param #number HuType 1胡2自摸3杠上开花4海底捞月5抢杠胡6一炮双响7一炮多响8呼叫转移
--@param #number State 是否真胡	1实牌0虚牌
--]]
function addPutDownCardsForHu(HuSeatID, cardValue, DianPaoSeatID, HuType, State)
	local nPos = MahjongTableConsole.getPlayerPosBySeat(HuSeatID);
	--牌型：胡牌
	if PutDownCards[nPos + 1] == nil then
		PutDownCards[nPos + 1] = {};
	end
	local nFace = MahjongCardDoc.MJ_FACE_HU_CARD;
	local nDir = nPos;
	local value = tonumber(cardValue);

	removeTakeOutCardByValue(value);

	local card = MahjongTableCard:newCard(value, nDir, nFace);
	local HuNumber = 0;--一共胡过几次
	for index, cardList in pairs(PutDownCards[nPos + 1]) do
		if #cardList == 1 then
			HuNumber = HuNumber + 1;
		end
	end
	card:setCardRanks(1, HuNumber + 1);
	if State == 1 then
		--牌型7：胡实牌
		card.m_nCardType = 7;
	else
		--牌型8：胡虚牌
		card.m_nCardType = 8;
	end
	HandCardBatchNode:addChild(card.m_CardSprite);
	PutDownCards[nPos + 1][#PutDownCards[nPos + 1] + 1] = {};
	table.insert(PutDownCards[nPos + 1][#PutDownCards[nPos + 1]], card);
	--1胡 2自摸 3杠上开花 4海底捞月 5抢杠胡 6一炮双响 7一炮多响 8呼叫转移
	if HuType == 1 then
		--1胡
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_HU);
	elseif HuType == 2 then
		--2自摸
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_ZIMO);
	elseif HuType == 3 then
		--3杠上开花
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_GANGSHANGKAIHUA);
	elseif HuType == 4 then
		--4海底捞月
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_HAIDILAOYUE);
	elseif HuType == 5 then
		--5抢杠胡
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_QIANGGANGHU);
	elseif HuType == 6 then
		--6一炮双响
		--需要在点炮者用户上显示动画
		if State == 1 then
			local DianPaoPos = MahjongTableConsole.getPlayerPosBySeat(DianPaoSeatID);
			MahjongTableArmature.showCardZiAnim(DianPaoPos, MahjongTableArmature.ARMATURE_CARD_ZI_YIPAOSHUANGXIANG);
		else
			card:setCardOpacity(255/2);
		end
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_HU);
	elseif HuType == 7 then
		--7一炮多响
		--需要在点炮者用户上显示动画
		if State == 1 then
			local DianPaoPos = MahjongTableConsole.getPlayerPosBySeat(DianPaoSeatID);
			MahjongTableArmature.showCardZiAnim(DianPaoPos, MahjongTableArmature.ARMATURE_CARD_ZI_YIPAODUOXIANG);
		else
			card:setCardOpacity(255/2);
		end
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_HU);
	elseif HuType == 8 then
		--8呼叫转移
		local DianPaoPos = MahjongTableConsole.getPlayerPosBySeat(DianPaoSeatID);
		MahjongTableArmature.showCardZiAnim(DianPaoPos, MahjongTableArmature.ARMATURE_CARD_ZI_HUJIAOZHUANYI);
		MahjongTableArmature.showCardZiAnim(nPos, MahjongTableArmature.ARMATURE_CARD_ZI_HU);
	end

	if HuType == 2 or HuType == 3 or HuType == 4 then
		--2自摸3杠上开花4海底捞月
		--自摸音效
		MahjongAudioManager.playMahjongSound("ZI_MO", MahjongTableArmature.MahjongTableConsole.getPlayer(HuSeatID).mSex);
	else
		MahjongAudioManager.playMahjongSound("HU_PAI", MahjongTableArmature.MahjongTableConsole.getPlayer(HuSeatID).mSex);
	end

	--胡牌闪电动画
	MahjongTableArmature.showHuPaiAnim(nPos, card.m_nScreenX, card.m_nScreenY);

	MahjongAudioManager.playMahjongSound("MJ_DAPAI", -1);
end

--[[--
--删除自己所有的放下牌
--]]
function removeAllPutDownCardsByPos(nPos)
	if PutDownCards[nPos + 1] ~= nil then
		for i, cardsList in pairs(PutDownCards[nPos + 1]) do
			for j, card in pairs(cardsList) do
				HandCardBatchNode:removeChild(card.m_CardSprite, true);
			end
		end
	end
	PutDownCards[nPos + 1] = {};
end

--[[--
--显示上一张打出的牌
--]]
function showLastTakeOutCard(seatID, cardValue)
	local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(seatID);

	removeLastTakeOutCard();

	lastTakeOutCard = MahjongTableCard:newCard(cardValue, MahjongCardDoc.MJ_DIR_MAX, MahjongCardDoc.MJ_FACE_HAND_CARD);
	lastTakeOutCard:setCardRanks(1, 1);
	lastTakeOutCard:setCardScale(0.85);
	lastTakeOutCard:setCardPosition(MahjongTableConfig.playerCardAnimXY[PlayerPos + 1][1], MahjongTableConfig.playerCardAnimXY[PlayerPos + 1][2]);
	HandCardBatchNode:addChild(lastTakeOutCard.m_CardSprite);
end

--[[--
--删除上一张打出的牌
--]]
function removeLastTakeOutCard()
	if lastTakeOutCard ~= nil then
		HandCardBatchNode:removeChild(lastTakeOutCard.m_CardSprite, true);
		lastTakeOutCard = nil;
	end
end

--[[--
--获取自己拖动的牌
--]]
function getSelfMoveCard()
	return selfMoveCard;
end

--[[--
--显示自己拖动的牌
--]]
function showSelfMoveCard(cardValue, x, y)
	if selfMoveCard == nil then
		selfMoveCard = MahjongTableCard:newCard(cardValue, MahjongCardDoc.MJ_DIR_MAX, MahjongCardDoc.MJ_FACE_HAND_CARD);
		selfMoveCard:setCardRanks(1, 1);
		selfMoveCard:setCardScale(1);
		HandCardBatchNode:addChild(selfMoveCard.m_CardSprite);
	end
	selfMoveCard:setCardPosition(x, y);
end

--[[--
--删除自己拖动的牌
--]]
function removeSelfMoveCard()
	if selfMoveCard ~= nil then
		HandCardBatchNode:removeChild(selfMoveCard.m_CardSprite, true);
		selfMoveCard = nil;
	end
end

--[[--
--添加打出的牌
--]]
function addTakeOutCards(SeatID, cardsValTable)
	local nPos = MahjongTableConsole.getPlayerPosBySeat(SeatID);
	if TakeOutCards[nPos + 1] == nil then
		TakeOutCards[nPos + 1] = {};
	end
	for index = 1, #cardsValTable do
		local value = tonumber(cardsValTable[index]);
		Common.log("addTakeOutCards  = " .. value);
		local card = nil;
		local Dir = nPos;
		card = MahjongTableCard:newCard(value, Dir, MahjongCardDoc.MJ_FACE_OUT_CARD);

		table.insert(TakeOutCards[nPos + 1], card);

		local Row = math.ceil(#TakeOutCards[nPos + 1] / MahjongCardDoc.NormalMaxColumn); --行
		local Column = 1;

		if Row == MahjongCardDoc.MaxRow then
			--最后一行
			Column = (#TakeOutCards[nPos + 1] - MahjongCardDoc.NormalMaxColumn * (MahjongCardDoc.MaxRow - 1) - 1) % MahjongCardDoc.LastMaxColumn + 1; --列
		else
			Column = (#TakeOutCards[nPos + 1] - 1) % MahjongCardDoc.NormalMaxColumn + 1; --列
		end

		card:setCardRanks(Row, Column);
		HandCardBatchNode:addChild(card.m_CardSprite);
	end
	showAllCardsIdentify();
end

--[[--
--刷新打出去的牌
--]]
function refreshTakeOutCards(nPos)
	for index, card in pairs(TakeOutCards[nPos + 1]) do
		local Row = math.ceil(index / MahjongCardDoc.NormalMaxColumn); --行
		local Column = 1;

		if Row == MahjongCardDoc.MaxRow then
			--最后一行
			Column = (index - MahjongCardDoc.NormalMaxColumn * (MahjongCardDoc.MaxRow - 1) - 1) % MahjongCardDoc.LastMaxColumn + 1; --列
		else
			Column = (index - 1) % MahjongCardDoc.NormalMaxColumn + 1; --列
		end
		card:setCardRanks(Row, Column);
	end
end

--[[--
--删除所有打出去的手牌
--]]
function removeAllTakeOutCards()
	for i, cardsList in pairs(TakeOutCards) do
		for j, card in pairs(cardsList) do
			HandCardBatchNode:removeChild(card.m_CardSprite, true);
		end
	end
	TakeOutCards = {};
end

--[[--
--删除打出的牌
--]]
function removeTakeOutCardByValue(value)
	local index = -1;
	for i, cardsList in pairs(TakeOutCards) do
		for j, card in pairs(cardsList) do
			if card.m_nValue == value then
				HandCardBatchNode:removeChild(card.m_CardSprite, true);
				table.remove(cardsList, j);
				index = i;
				break;
			end
		end
	end

	if index > 0 then
		refreshTakeOutCards(index - 1);
	end
end

--[[--
--清除标识显示已经亮出的相同牌
--]]
function clearAllCardsIdentify()
	for i, cardsList in pairs(TakeOutCards) do
		for j, card in pairs(cardsList) do
			card:clearCardIdentify();
		end
	end
	for pos, list in pairs(PutDownCards) do
		for i, cardsList in pairs(list) do
			for j, card in pairs(cardsList) do
				card:clearCardIdentify();
			end
		end
	end
end

--[[--
--显示已经亮出的相同牌
--]]
function showAllCardsIdentify()
	clearAllCardsIdentify();
	local cards = getSelectCard();
	if #cards ~= 1 then
		return;
	end
	local value = cards[1].m_nValue;
	local nColor, nWhat = MahjongCardDoc.getCardInfoByValue(value);
	for i, cardsList in pairs(TakeOutCards) do
		for j, card in pairs(cardsList) do
			if card.m_nColor == nColor and card.m_nWhat == nWhat then
				card:showCardIdentify();
			end
		end
	end
	for pos, list in pairs(PutDownCards) do
		for i, cardsList in pairs(list) do
			for j, card in pairs(cardsList) do
				if card.m_nColor == nColor and card.m_nWhat == nWhat then
					card:showCardIdentify();
				end
			end
		end
	end
end

--[[--
-- 恢复路线中的手牌
-- ]]
function regainRecordHandCards(RecordHandCards)
	removeAllHandCards();

	for pos, cardList in pairs(RecordHandCards) do
		Common.log("pos ============= "..pos);
		local Dir = pos - 1;
		local MaxIndex = 13;
		local cardSize = #cardList;
		if cardSize % 3 == 2 then
			--当前自己出牌
			MaxIndex = 14;
		end
		for index, cardInfo in pairs(cardList) do
			local Face = cardInfo.cardFace;
			local value = cardInfo.cardValue;
			--Common.log("Dir ======== "..Dir);
			--Common.log("Face ======== "..Face);
			--Common.log("value ======== "..value);
			local card = MahjongTableCard:newCard(value, Dir, Face);
			table.insert(HandCards[pos], card);
			card:setCardRanks(1, index + (MaxIndex - cardSize));
			HandCardBatchNode:addChild(card.m_CardSprite);
		end
	end
end

--[[--
-- 恢复路线中的放下牌
-- ]]
function regainRecordPutDownCards(RecordPutDownCards)
	removeAllPutDownCardsByPos(0);
	removeAllPutDownCardsByPos(1);
	removeAllPutDownCardsByPos(2);
	removeAllPutDownCardsByPos(3);

	for pos, PutDownCardsList in pairs(RecordPutDownCards) do
		Common.log("pos ========== "..pos);
		for i, cardList in pairs(PutDownCardsList) do
			PutDownCards[pos][i] = {};
			local size = #cardList;

			for j, cardInfo in pairs(cardList) do
				local value = cardInfo.cardValue;
				removeTakeOutCardByValue(value);

				local card = nil;
				local nDir = pos - 1;
				local nFace = cardInfo.cardFace;
				local cardType = cardInfo.cardType;
				local FromSeatID = cardInfo.FromSeatID;

				card = MahjongTableCard:newCard(value, nDir, nFace);
				card.m_nCardType = cardType;
				card.m_nFromSeatID = FromSeatID;
				table.insert(PutDownCards[pos][i], card);

				if cardType == 1 or cardType == 3 or cardType == 4 then
					--牌型1：顺子--牌型3：碰--牌型4：明杠
					card:setCardRanks(1, j + 4 * (i - 1));
					if FromSeatID ~= -1 then
						if (size == 3 and j == 2) or (size == 4 and j == 4) then
							--碰的第二张或杠的第四张
							local sprite = CCSprite:createWithSpriteFrameName("MJ_btn_jiantou.png");
							sprite:setScale(0.8);
							local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(FromSeatID);
							local Offset = 5;
							if PlayerPos == 0 then
								sprite:setRotation(90);
							elseif PlayerPos == 1 then
								--右侧
								sprite:setRotation(0);
							elseif PlayerPos == 2 then
								--对面
								sprite:setRotation(-90);
							elseif PlayerPos == 3 then
								--左侧
								sprite:setRotation(180);
							end

							if nDir == 0 then
								sprite:setPosition(-5, -40);
							elseif nDir == 1 then
								--右侧
								sprite:setPosition(-40, 3);
							elseif nDir == 2 then
								--对面
								sprite:setPosition(0, -20);
							elseif nDir == 3 then
								--左侧
								sprite:setPosition(40, 3);
							end
							card.m_CardSprite:addChild(sprite);
						end
					end
				elseif cardType == 5 then
					--牌型5：暗杠
					card:setCardRanks(1, j + 4 * (i - 1));
				elseif cardType == 6 then
					--牌型6：手牌
					card:setCardRanks(1, j + (13 - size));
				elseif cardType == 7 or cardType == 8 then
					--牌型7：胡实牌  牌型8：胡虚牌
					card:setCardRanks(1, j);
				end
				HandCardBatchNode:addChild(card.m_CardSprite);
			end
		end
	end
end

--[[--
-- 恢复路线中的打出牌
-- ]]
function regainRecordTakeOutCards(RecordTakeOutCards)
	removeAllTakeOutCards();

	for pos, cardList in pairs(RecordTakeOutCards) do
		TakeOutCards[pos] = {};
		local Dir = pos - 1;
		for index, cardInfo in pairs(cardList) do
			local value = cardInfo.cardValue;
			local Face = cardInfo.cardFace;
			local card = MahjongTableCard:newCard(value, Dir, Face);

			table.insert(TakeOutCards[pos], card);

			local Row = math.ceil(#TakeOutCards[pos] / MahjongCardDoc.NormalMaxColumn); --行
			local Column = 1;
			if Row == MahjongCardDoc.MaxRow then
				--最后一行
				Column = (#TakeOutCards[pos] - MahjongCardDoc.NormalMaxColumn * (MahjongCardDoc.MaxRow - 1) - 1) % MahjongCardDoc.LastMaxColumn + 1; --列
			else
				Column = (#TakeOutCards[pos] - 1) % MahjongCardDoc.NormalMaxColumn + 1; --列
			end

			card:setCardRanks(Row, Column);

			HandCardBatchNode:addChild(card.m_CardSprite);
		end
	end
end

--[[--
--清空牌桌上的牌
--]]
function removeAllCards()
	MahjongTableTingCardsLayer.removeTingHintList();
	HandCardBatchNode:removeAllChildrenWithCleanup(true); --自己存放牌桌上展示的牌，位置0

	lastTakeOutCard = nil; --上一张打出的牌
	selfMoveCard = nil; --自己拖动的牌

	HandCards = {}; --自己的手牌

	HandCards[1] = {};
	HandCards[2] = {};
	HandCards[3] = {};
	HandCards[4] = {};

	TakeOutCards = {}; --自己本回合出的牌
	PutDownCards = {};
end

--[[--
--删除纸牌层
--]]
function reomveAllCardLayer()
	MahjongTableTingCardsLayer.reomveAllTingCardsLayer();
	HandCardBatchNode:removeAllChildrenWithCleanup(true); --自己存放牌桌上展示的牌，位置0
	lastTakeOutCard = nil; --上一张打出的牌
	selfMoveCard = nil; --自己拖动的牌

	HandCards = {}; --自己的手牌
	TakeOutCards = {} --自己本回合出的牌
	PutDownCards = {};

	CardLayer:stopAllActions();
	CardLayer:removeFromParentAndCleanup(true);
	CardLayer = nil
end
