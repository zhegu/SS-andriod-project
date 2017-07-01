--手牌层的触摸监听
module("MahjongTableOnTouch", package.seeall)

local CCTOUCHBEGAN = "began"
local CCTOUCHMOVED = "moved"
local CCTOUCHENDED = "ended"

local m_nTouchIdx = -1;

--[[--
--判断两次点击的牌是不是同一张
--]]
local function isSameCard()
	local CardsList = MahjongTableCardLayer.getSelectCard();
	local lastSelectedCard = nil;
	if #CardsList ~= 1 then
		return false;
	end
	lastSelectedCard = CardsList[1];
	local onTouchCard = MahjongTableCardLayer.getSelfCards()[m_nTouchIdx];
	if onTouchCard == nil then
		return false;
	end
	--Common.log("lastSelectedCard:getValue() ======== "..lastSelectedCard:getValue());
	--Common.log("onTouchCard:getValue() ======== "..onTouchCard:getValue());
	if lastSelectedCard:getValue() == onTouchCard:getValue() then
		return true;
	else
		return false;
	end
end

--[[--
--按下
--]]
local function onTouchBegan(x, y)
	local CardsList = MahjongTableCardLayer.getSelectCard();
	for index, card in pairs(MahjongTableCardLayer.getSelfCards()) do
		if MahjongTableConsole.mTableStatus == MahjongTableConsole.STAT_CHANGE_CARD then
			--换三张阶段
			if card:click(x, y) then
				--判断选中
				m_nTouchIdx = index;--设置触摸起点
			end
		else
			if card:click(x, y) then
				--判断选中
				m_nTouchIdx = index;--设置触摸起点
			--Common.log("index ========= "..index);
			else
				card:setSelected(false);
			end
		end
	end
end

--[[--
--滑动
--]]
local function onTouchMoved(x, y)
	if (m_nTouchIdx ~= -1) then
		if MahjongTableConsole.mTableStatus == MahjongTableConsole.STAT_CHANGE_CARD then
		else
			local onTouchCard = MahjongTableCardLayer.getSelfCards()[m_nTouchIdx];
			if onTouchCard == nil then
				return ;
			end
			if math.abs(x - 50) > onTouchCard.m_nScreenX or y - 50 > onTouchCard.m_nScreenY then
				--可以判定用户已经开始拖动牌
				MahjongTableCardLayer.showSelfMoveCard(onTouchCard:getValue(), x, y);
			end
		end
	end
end

--[[--
--抬起
--]]
local function onTouchEnded(x, y)
	if (m_nTouchIdx ~= -1) then
		local onTouchCard = MahjongTableCardLayer.getSelfCards()[m_nTouchIdx];
		if onTouchCard == nil then
			return;
		end

		--		if MahjongTableConsole.getCurrPlayer() ~= MahjongTableConsole.getSelfSeat() then
		--			--当前不是自己操作
		--			if MahjongTableElementLayer.getPlayerIsHu(MahjongTableConsole.getSelfSeat()) then
		--				--已经胡了
		--				return;
		--			end
		--		end

		if MahjongTableConsole.mTableStatus == MahjongTableConsole.STAT_CHANGE_CARD then
			local EndIndex = -1;
			for index, card in pairs(MahjongTableCardLayer.getSelfCards()) do
				if card:click(x, y) then
					--判断选中
					EndIndex  = index;--设置触摸起点
				end
			end
			if EndIndex ~= m_nTouchIdx then
				return;
			end

			local value = onTouchCard.m_nValue;
			--Common.log("value ============== "..value);
			onTouchCard:OnSelected();
		else
			if MahjongTableCardLayer.getSelfMoveCard() ~= nil then
				--有自己拖拽的牌
				if MahjongTableConsole.getCurrPlayer() == MahjongTableConsole.getSelfSeat() then
					if y - MahjongTableConfig.cardHeight > onTouchCard.m_nScreenY then
						--拖拽到出牌位置
						local value = onTouchCard.m_nValue;
						--Common.log("value ============== "..value);
						if onTouchCard:IsTouchMarked() then
							Common.showToast("只能出缺牌", 2);
							return;
						end
						MahjongTableConsole.sendDisCard(value);
					else
						return;
					end
				else
					return;
				end
			else
				local EndIndex = -1;
				for index, card in pairs(MahjongTableCardLayer.getSelfCards()) do
					if card:click(x, y) then
						--判断选中
						EndIndex  = index;--设置触摸起点
					end
				end

				if EndIndex ~= m_nTouchIdx then
					return;
				end

				local value = onTouchCard.m_nValue;
				--Common.log("value ============== "..value);
				if isSameCard() then
					if MahjongTableConsole.getCurrPlayer() == MahjongTableConsole.getSelfSeat() then
						if onTouchCard:IsTouchMarked() then
							Common.showToast("只能出缺牌", 2);
							return;
						end
						MahjongTableConsole.sendDisCard(value);
					end
				else
					if MahjongTableConsole.getCurrPlayer() == MahjongTableConsole.getSelfSeat() then
						MahjongTableTingCardsLayer.showTingCardListByValue(value);
					end
					onTouchCard:setSelected(true);
					MahjongAudioManager.playMahjongSound("MJ_XUANIPAI", -1);
					MahjongTableCardLayer.showAllCardsIdentify();
				end
			end
		end
	else
		--清除标识显示已经亮出的相同牌
		MahjongTableCardLayer.clearAllCardsIdentify();
	end
end

--[[--
--牌桌触摸监听
--]]
function OnTouchEvent(eventType, x, y)
	if MahjongTableConsole.isTableRecordMode then
		return;
	end
	if eventType == CCTOUCHBEGAN then
		m_nTouchIdx = -1;
		onTouchBegan(x, y);
		return true;
	elseif eventType == CCTOUCHMOVED then
		onTouchMoved(x, y);
	elseif eventType == CCTOUCHENDED then
		MahjongTableTingCardsLayer.removeTingHintList();
		onTouchEnded(x, y);
		m_nTouchIdx = -1;
		MahjongTableCardLayer.removeSelfMoveCard();
	end
end