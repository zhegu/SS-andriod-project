
module("MahjongTableElementLayer", package.seeall)

local TableElementLayer = nil--存放牌桌上展示的牌

local changeCardNode = nil --换三张牌

--[[--
--创建动画层
]]
local function creatTableElementLayer()
	TableElementLayer = CCLayer:create();
	TableElementLayer:setZOrder(5);

	initTableElementLayer();
end

--[[--
--获取动画层
--]]
function getTableElementLayer()
	if TableElementLayer == nil then
		creatTableElementLayer()
	end
	return TableElementLayer
end

function initTableElementLayer()

end

--显示骰子
function showDice()
	local diceData = MahjongTableConsole.getDiceValue();
	local diceNode = CCSprite:create(MahjongTableConfig.getResPath("table0.png"))

	local function callBackRemove()
		diceNode:removeFromParentAndCleanup(true);
	end

	diceNode:setPosition(ccp(0,0))
	diceNode:setCascadeOpacityEnabled(true);
	TableElementLayer:addChild(diceNode)
	diceNode:setZOrder(10);
	for index=1, #diceData do
		local value = diceData[index]
		local str = "MJ_Table_middle_box_dice"..value..".png"
		local sprite = CCSprite:createWithSpriteFrameName(str);
		sprite:setPosition(MahjongTableConfig.DiceXY[index][1], MahjongTableConfig.DiceXY[index][2])
		diceNode:addChild(sprite);
	end
	GamePub.delayDoFunc(diceNode,1,callBackRemove)
end

--显示用户换出的三张牌
function showChangeCard(SeatId)
	if MahjongTableConsole.mTableStatus ~= MahjongTableConsole.STAT_CHANGE_CARD then
		return;
	end

	if changeCardNode == nil then
		changeCardNode = CCSprite:create(MahjongTableConfig.getResPath("table0.png"))
		changeCardNode:setPosition(ccp(0,0))
		TableElementLayer:addChild(changeCardNode)
	end

	local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(SeatId);
	local sprite = nil
	if PlayerPos == 0 then
		--0下
		sprite = CCSprite:createWithSpriteFrameName("MJ_table_changecard_cards_self.png");
	elseif PlayerPos == 1 then
		--1右
		sprite = CCSprite:createWithSpriteFrameName("MJ_table_changecard_cards_right.png");
	elseif PlayerPos == 2 then
		--2上
		sprite = CCSprite:createWithSpriteFrameName("MJ_table_changecard_cards_up.png");
	elseif PlayerPos == 3 then
		--3左
		sprite = CCSprite:createWithSpriteFrameName("MJ_table_changecard_cards_right.png");
		sprite:setFlipX(true)
	end
	sprite:setPosition(MahjongTableConfig.playerChangeCardsXY[PlayerPos + 1][1], MahjongTableConfig.playerChangeCardsXY[PlayerPos + 1][2])
	changeCardNode:addChild(sprite);
end

function removeChangeCards()
	Common.log("removeChangeCards ======= ")
	if changeCardNode ~= nil then
		Common.log("removeChangeCards ~~~~~~~~~~~======= nil")
		changeCardNode:removeFromParentAndCleanup(true);
		changeCardNode = nil;
	end
end

--[[--
--赠送礼物动画
@param #Int ItemId 礼物Id
--]]
function playSendGiftAnimation(ItemId, fromPosX, fromPosY, toPosX, toPosY)
	local sendPicSprite = nil

	if ItemId == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_FLOWER then
		sendPicSprite = CCSprite:createWithSpriteFrameName("DN_publish_gift_flowers.png");
	elseif ItemId == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_CAR then
		sendPicSprite = CCSprite:createWithSpriteFrameName("DN_publish_gift_car.png")
	elseif ItemId == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_HOUSE then
		sendPicSprite = CCSprite:createWithSpriteFrameName("DN_publish_gift_villa.png")
	elseif ItemId == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_YACHT then
		sendPicSprite = CCSprite:createWithSpriteFrameName("DN_publish_gift_yacht.png")
	end
	sendPicSprite:setPosition(fromPosX, fromPosY)
	TableElementLayer:addChild(sendPicSprite)

	local function showGiftAnim()
		TableElementLayer:removeChild(sendPicSprite,true)
		sendPicSprite = nil
		MahjongInteractionAnim.showSendGiftAmin(ItemId,toPosX, toPosY)
	end

	--礼物移动
	local moveTo = CCMoveTo:create(1,ccp(toPosX, toPosY))
	local giftActioArray = CCArray:create()
	giftActioArray:addObject(moveTo)
	giftActioArray:addObject(CCCallFuncN:create(showGiftAnim))
	local seq = CCSequence:create(giftActioArray)
	sendPicSprite:runAction(CCRepeatForever:create(seq))
end

--[[--
--显示流局
--]]
function showLiuJuAnim()
	local sprite = CCSprite:createWithSpriteFrameName("MJ_ues_table_fnt_liuju.png");
	sprite:setPosition(960, 630)
	TableElementLayer:addChild(sprite);
end

local PlayerHuList = {};

--[[--
--用户是否胡牌
--]]
function getPlayerIsHu(SeatID)
	for index, seat in pairs(PlayerHuList) do
		if seat == SeatID then
			return true;
		end
	end
	return false;
end

--[[--
--显示胡
--]]
function showPlayerHu(SeatID, HuNumber)
	if HuNumber == 0 or HuNumber == -1 or HuNumber == 255 then
		return;
	end

	table.insert(PlayerHuList, SeatID);

	local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(SeatID);
	local sprite = nil
	if HuNumber == 1 then
		--1胡
		sprite = CCSprite:createWithSpriteFrameName("pic_mj_table_xiaoguozi_hu_yihu.png");
	elseif HuNumber == 2 then
		--2胡
		sprite = CCSprite:createWithSpriteFrameName("pic_mj_table_xiaoguozi_hu_erhu.png");
	elseif HuNumber == 3 then
		--3胡
		sprite = CCSprite:createWithSpriteFrameName("pic_mj_table_xiaoguozi_hu_sanhu.png");
	end
	sprite:setPosition(MahjongTableConfig.playerCardAnimXY[PlayerPos + 1][1], MahjongTableConfig.playerCardAnimXY[PlayerPos + 1][2])
	TableElementLayer:addChild(sprite);
end

--[[--
--重置牌桌
--]]
function resetTableElement()
	PlayerHuList = {};
	removeChangeCards()
	MahjongTableArmature.releaseAllTableAnimation()
	TableElementLayer:removeAllChildrenWithCleanup(true);
end

--[[--
--删除层
--]]
function reomveAllTableElementLayer()
	resetTableElement();
	TableElementLayer:stopAllActions();
	TableElementLayer:removeFromParentAndCleanup(true);
	TableElementLayer = nil
	changeCardNode = nil
end