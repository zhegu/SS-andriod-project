--存放牌桌上显示的听牌列表
module("MahjongTableTingCardsLayer", package.seeall)

local TingCardsLayer = nil;--存放牌桌上展示的牌

local TingHintLayer = nil;--听方案列表界面

--[[--
--创建纸牌层
--]]
local function creatTingCardsLayer()
	TingCardsLayer = CCLayer:create()
	TingCardsLayer:setZOrder(1);

	TingHintLayer = CCLayer:create();
	TingCardsLayer:addChild(TingHintLayer);
end

--[[--
--设置出牌触摸监听
--]]
function setTingCardsLayerTouchEnabled(isTouchEnabled)
	TingCardsLayer:setTouchEnabled(isTouchEnabled);
end
--[[--
--获取纸牌层
--]]
function getTingCardsLayer()
	if TingCardsLayer == nil then
		creatTingCardsLayer();
	end
	return TingCardsLayer;
end

--[[--
--显示胡牌列表
--]]
function showTingCardListByValue(SelectCardValue, nTingCardInfoList)
	removeTingHintList();
	local TingCardList = nil;
	if nTingCardInfoList ~= nil then
		TingCardList = nTingCardInfoList;
	else
		TingCardList = MahjongTableConsole.getTingPaiListByValue(SelectCardValue);
	end

	if TingCardList == nil or next(TingCardList) == nil then
		return;
	end

	local maxColumn = 5
	local m_nRow = math.ceil(#TingCardList/5);
	local m_nColumn = maxColumn;
	if #TingCardList < maxColumn then
		m_nColumn = #TingCardList;
	end

	local CellW = 200;
	local CellH = 220;

	local BackW = 430 + CellW * (m_nColumn - 1);
	local BackH = CellH * m_nRow;

	local back = GamePub.createPointNineSprite(MahjongTableConfig.getResPath("MJ_use_Table_redframe_bg.png"), 160, 50, BackW, BackH);
	back:setAnchorPoint(ccp(0.5, 0));
	back:setPosition(MahjongTableConfig.TableDefaultWidth/2 + 100, 240);
	TingHintLayer:addChild(back);

	local HuSprite = CCSprite:createWithSpriteFrameName("MJ_use_Table_button_action_fnt_hu_small.png");
	HuSprite:setPosition(95, BackH/2);

	back:addChild(HuSprite);
	for index, TingCardInfo in pairs(TingCardList) do
		Common.log("TingCardInfo.CardValue =============== "..TingCardInfo.CardValue);
		Common.log("TingCardInfo.Multiple =============== "..TingCardInfo.Multiple);
		Common.log("TingCardInfo.LeaveCardsCnt =============== "..TingCardInfo.LeaveCardsCnt);
		local nRow = math.ceil(index / maxColumn);--行
		local nColumn = (index - 1)%5 + 1;--列
		local CardX = 50 + nColumn * CellW;
		local CardY = BackH - (-CellH/2 + nRow * CellH);
		local card = MahjongTableCard:newCard(TingCardInfo.CardValue, MahjongCardDoc.MJ_DIR_MAX, MahjongCardDoc.MJ_FACE_HAND_CARD);
		card:setCardRanks(1, 1);
		card:setCardScale(0.6);
		card:setCardPosition(CardX, CardY);
		back:addChild(card.m_CardSprite);

		local promptLabel = CCLabelTTF:create("", "", 50)
		promptLabel:setAnchorPoint(ccp(0, 0.5));
		promptLabel:setColor(ccc3(255,255,255))
		promptLabel:setPosition(card:getContentSizeWidth(), card:getContentSizeHeight()/2);
		card.m_CardSprite:addChild(promptLabel);
		promptLabel:setString(TingCardInfo.Multiple.."番");
		promptLabel:setZOrder((MahjongTableConfig.TableDefaultWidth + MahjongTableConfig.TableDefaultHeight)*2);

		local promptLabel = CCLabelTTF:create("", "", 50)
		promptLabel:setAnchorPoint(ccp(0, 0.5));
		promptLabel:setColor(ccc3(255,255,255))
		promptLabel:setPosition(card:getContentSizeWidth(), -card:getContentSizeHeight()/2);
		card.m_CardSprite:addChild(promptLabel);
		promptLabel:setString(TingCardInfo.LeaveCardsCnt.."张");
		promptLabel:setZOrder((MahjongTableConfig.TableDefaultWidth + MahjongTableConfig.TableDefaultHeight)*2);
	end
end

function removeTingHintList()
	if TingHintLayer ~= nil then
		TingHintLayer:removeAllChildrenWithCleanup(true);
	end
end

--[[--
--删除纸牌层
--]]
function reomveAllTingCardsLayer()
	removeTingHintList();
	if TingCardsLayer ~= nil then
		TingCardsLayer:stopAllActions();
		TingCardsLayer:removeFromParentAndCleanup(true);
		TingCardsLayer = nil
	end
end
