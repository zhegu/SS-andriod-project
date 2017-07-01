module("MahjongTableCardManage", package.seeall)


-- 排序类型
SORT_MODE_SAMECOUNT = 0;--以相同牌的数量排序(三带二,四带二)
SORT_MODE_WHAT = 1;--大小排序
SORT_MODE_COLOR = 2;--花色排序

local mnSortMethod = 0;

--[[--
-- 牌比较函数，nVal和nVal2最高位字节用来作为同类牌的计数
--]]
local function CardCompare(card1, card2)
	local nVal1 = card1.m_nValue;
	local nVal2 = card2.m_nValue;
	local nWhat1 = card1.m_nWhat;
	local nWhat2 = card2.m_nWhat;
	local nColor1 = card1.m_nColor;
	local nColor2 = card2.m_nColor;
	local nWeight1 = card1.m_nSameCardCnt;
	local nWeight2 = card2.m_nSameCardCnt;
	local bTouchMarked1 = card1.m_bTouchMarked;
	local bTouchMarked2 = card2.m_bTouchMarked;

	if mnSortMethod == SORT_MODE_WHAT then
		if (nWhat1 ~= nWhat2) then
			return nWhat1 < nWhat2;
		end
		return nColor2 < nColor1;
	elseif mnSortMethod == SORT_MODE_COLOR then
		if (bTouchMarked1 ~= bTouchMarked2) then
			return bTouchMarked1;
		end
		if (nColor1 ~= nColor2) then
			return nColor1 < nColor2;
		end
		return nWhat1 < nWhat2;
	elseif mnSortMethod == SORT_MODE_SAMECOUNT then
		if (nWeight1 ~= nWeight2) then
			return nWeight2 < nWeight1;
		end
		if (nWhat1 ~= nWhat2) then
			--从小到大排
			return nWhat1 < nWhat2;
		end
		return nColor2 < nColor1;
	end

	return false;
end

--[[--
--排序
--@param #table cardsTable 自己的牌
--@param #number nSortMethod 排序模式
--]]
function SortCardVal(cardsTable, nSortMethod)
	if cardsTable == nil then
		return cardsTable
	end
	mnSortMethod = nSortMethod
	local nVal;
	local cnSame = 0;
	local nColor;

	if (mnSortMethod == SORT_MODE_SAMECOUNT) then
		-- 只有此类排序需要附加数据，附加数据放在最高字节
		for i = 1, table.maxn(cardsTable) do
			if cardsTable[i] ~= nil then
				cardsTable[i].m_nSameCardCnt = -1;
			end
		end

		for i = 1, table.maxn(cardsTable) do
			if (cardsTable[i] ~= nil and cardsTable[i].m_nSameCardCnt == -1) then
				nVal = cardsTable[i].m_nWhat;
				nColor = cardsTable[i].m_nColor;
				cnSame = 0;

				for j = 1, table.maxn(cardsTable) do
					if (cardsTable[j] ~= nil and cardsTable[j].m_nWhat == nVal and cardsTable[j].m_nColor == nColor) then
						cnSame = cnSame + 1;
					end
				end
				for j = 1, table.maxn(cardsTable) do
					if (cardsTable[j] ~= nil and cardsTable[j].m_nWhat == nVal and cardsTable[j].m_nColor == nColor) then
						cardsTable[j].m_nSameCardCnt = cnSame;
					end
				end

			end
		end
	end

	table.sort(cardsTable, CardCompare)
end

--[[--
--查找同张 (也就是 2,3,4同张)
--@param #table SelfCards 自己的牌
--@param #number nStart 开始搜索的下标
--@param #number nColor 花色
--@param #number nWhat 牌值
--@param #number nCardNum 需要找的相同张数
--@return #number n 查找到n张相同的牌
--]]
function SearchSameCard(SelfCards, nStart, nColor, nWhat, nCardNum)
	local nRet = 0;
	local index = nStart;
	local cnHandCard = table.maxn(SelfCards);
	for i = nStart, cnHandCard do
		if (SelfCards[i] ~= nil and SelfCards[i].m_nSameCardCnt < 0 and SelfCards[i].m_nColor == nColor and SelfCards[i].m_nWhat == nWhat) then
			index = index + 1
		end
	end

	if (index - nStart ~= nCardNum) then
		return 0;
	end

	return index - nStart;
end

--[[--
--查找同花顺子
--@param #table SelfCards 自己的牌
--@param #number nStart 开始搜索的下标
--@param #number nColor 花色
--@param #number nWhat 牌值
--@return #table indexTable 顺子牌的下标
--]]
function SearchStraight(SelfCards, nStart, nColor, nWhat)
	local n = 3;


	local abStraight = {};
	local indexTable = {};
	for i = 1, n do
		table.insert(abStraight, false);
	end

	local cnHandCard = table.maxn(SelfCards);
	local suffix = nStart;
	for i = 1, cnHandCard do
		if i >= suffix then
			if SelfCards[i] ~= nil and SelfCards[i].m_nSameCardCnt < 0 and SelfCards[i].m_nColor == nColor then
				--花色相同
				local nWhatTmp = math.abs(nWhat - SelfCards[i].m_nWhat);
				--Common.log("nWhatTmp =========== "..nWhatTmp);
				if (nWhatTmp >= 0 and nWhatTmp < n) then
					abStraight[nWhatTmp + 1] = true;
					table.insert(indexTable, i);
				end

				nWhatTmp = SelfCards[i].m_nWhat;
				while (suffix <= cnHandCard and SelfCards[suffix].m_nWhat == nWhatTmp) do
					suffix = suffix + 1;
				end
			end
		end
	end

	for i = 1, n do
		if (not abStraight[i]) then
			return nil;
		end
	end
	return indexTable;
end

--[[--
--查找指定数字
--@param #table SelfCards 自己的牌
--@param #number nStart 开始搜索的下标
--@param #number nColor 花色(-1：不需要同花色)
--@param #number nWhat 牌值
--@return #number appointIndex 指定数字牌的下标
--]]
function SearchAppointNumber(SelfCards, nStart, nColor, nWhat)

	local appointIndex = -1;

	local cnHandCard = table.maxn(SelfCards);
	local suffix = nStart;
	for i = 1, cnHandCard do
		if i >= suffix then
			if SelfCards[i] ~= nil and SelfCards[i].m_nSameCardCnt < 0 and SelfCards[i].m_nWhat == nWhat then
				if nColor == -1 then
					appointIndex = i;
				elseif SelfCards[i].m_nColor == nColor then
					--花色相同
					appointIndex = i;
				end
			end
		end
	end
	return appointIndex;
end