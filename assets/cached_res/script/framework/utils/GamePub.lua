module("GamePub", package.seeall)

LORD_GAME_ID = 1--斗地主gameID
POKER_GAME_ID = 2--德州gameID
MAHJONG_GAME_ID = 3--麻将gameID
JINHUA_GAME_ID = 4--炸金花gameID
DOUNIU_GAME_ID = 5--斗牛gameID
FISH_GAME_ID = 108--捕鱼gameID
ZIPAI_GAME_ID = 12--字牌gameID
MAHJONG_SICHUAN_GAMEID = 50--麻将-四川gameID

--[[--
--当前是否在德州牌桌上
--]]
function isInPokerGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_POKERTABLE then
		return true
	else
		return false
	end
end

--[[--
--当前是否在字牌牌桌上
--]]
function isInZiPaiGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_WORDPLATETABLE then
		return true
	else
		return false
	end
end
--[[--
--当前是否在斗地主牌桌上
--]]
function isInLordGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		return true
	else
		return false
	end
end
--[[--
--当前是否在金花牌桌上
--]]
function isInJinHuaGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_JINHUA_TABLE then
		return true
	else
		return false
	end
end

--[[--
--当前是否在斗牛牌桌上
--]]
function isInNiuNiuGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_NIUNIUTABLE then
		return true
	else
		return false
	end
end

--[[--
--当前是否在金牛牌桌上
--]]
function isInJinNiuGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_JINNIUTABLE then
		return true
	else
		return false
	end
end

--[[--
--当前是否在百牛牌桌上
--]]
function isInMillionNiuNiuGameTable()
	if GameConfig.getTheCurrentBaseLayer() == GUI_MILLIONNIUNIUTABLE then
		return true
	else
		return false
	end
end

--[[--
--当前是否在捕鱼游戏中
--]]
function isInCrazyFishGame()
	if GameConfig.getTheCurrentBaseLayer() == GUI_FISH then
		return true
	else
		return false
	end
end

--[[--
--当前是否百家乐游戏中
--]]
function isInBaccaratGame()
	if GameConfig.getTheCurrentBaseLayer() == GUI_BACCARAT_TABLE then
		return true
	else
		return false
	end
end

--[[--
--当前是否在骰宝游戏中
--]]
function isInSicboGame()
	if GameConfig.getTheCurrentBaseLayer() == GUI_SICBOMAIN then
		return true
	else
		return false
	end
end

--[[--
--判断是否发送破产送金
]]
function logicGiveCoin()
	local isGiveCoin = false;
	Common.log("profile.User.getSelfCoin() === "..profile.User.getSelfCoin())
	Common.log("profile.User.mnRemainCount === "..profile.User.mnRemainCount)
	--if tonumber(profile.User.getSelfCoin()) < 1000 and profile.User.mnRemainCount > 0 then
	if tonumber(profile.User.getSelfCoin()) < 1000 then
		isGiveCoin = true
	end
	return isGiveCoin
end

function isShowRecommendLogic()
	local isShowRecommend = false;
	Common.log("profile.User.getSelfCoin() === "..profile.User.getSelfCoin())
	if tonumber(profile.User.getSelfCoin()) < 1000 and profile.User.mnRemainCount <= 0 then
		isShowRecommend = true
	end
	return isShowRecommend
end

--[[--
--得到九宫格精灵
--@param #String imageNamePath 图片地址
--@param #number insetWidth 图片保留宽
--@param #number insetHeight 图片保留高
--@param #number ScaleWidth 图片显示宽
--@param #number ScaleHeight 图片显示高
--]]
function createPointNineSpriteForPlist(imageNamePath, insetWidth, insetHeight, ScaleWidth, ScaleHeight)
	local tmp = CCSprite:createWithSpriteFrameName(imageNamePath);
	local tmpsize = tmp:getContentSize();
	local fullRect = CCRectMake(0,0, tmpsize.width, tmpsize.height);--图片的大小
	local rectInsets = CCRectMake(insetWidth,insetHeight,tmpsize.width-insetWidth*2,tmpsize.height-insetHeight*2);
	local winRect = CCSizeMake(ScaleWidth, ScaleHeight);--设置要拉伸后的的大小
	--	local m_pNextBG  = CCScale9Sprite:createWithSpriteFrameName(imageNamePath, fullRect, rectInsets);
	local m_pNextBG  = CCScale9Sprite:createWithSpriteFrameName(imageNamePath, rectInsets);
	m_pNextBG:setContentSize(winRect);
	return m_pNextBG
end

--[[--
--得到九宫格精灵
--@param #String imageNamePath 图片地址
--@param #number insetWidth 图片保留宽
--@param #number insetHeight 图片保留高
--@param #number ScaleWidth 图片显示宽
--@param #number ScaleHeight 图片显示高
--]]
function createPointNineSprite(imageNamePath, insetWidth, insetHeight, ScaleWidth, ScaleHeight)
	local tmp = CCSprite:create(imageNamePath);
	local tmpsize = tmp:getContentSize();
	local fullRect = CCRectMake(0,0, tmpsize.width, tmpsize.height);--图片的大小
	local rectInsets = CCRectMake(insetWidth,insetHeight,tmpsize.width-insetWidth*2,tmpsize.height-insetHeight*2);
	local winRect = CCSizeMake(ScaleWidth, ScaleHeight);--设置要拉伸后的的大小
	local m_pNextBG  = CCScale9Sprite:create(imageNamePath, fullRect, rectInsets);
	m_pNextBG:setContentSize(winRect);
	return m_pNextBG
end

--[[--
--得到九宫格精灵--只拉中间
--@param #String frameName 图片精灵帧名称
--@param #number leftWidth 图片保留左
--@param #number topHeight 图片保留上
--@param #number RightWidth 图片显示右
--@param #number downHeight 图片显示下
--@param #number ScaleWidth 图片显示高
--@param #number ScaleHeight 图片显示宽
--]]
function createPointNineSpriteWithFrameName(frameName, insetWidth, insetHeight, ScaleWidth, ScaleHeight)
    local tmp = CCSprite:createWithSpriteFrameName(frameName);
    local tmpsize = tmp:getContentSize();
    local fullRect = CCRectMake(0, 0, tmpsize.width, tmpsize.height); --图片的大小
    local rectInsets = CCRectMake(insetWidth, insetHeight, tmpsize.width - insetWidth * 2, tmpsize.height - insetHeight * 2);
    local winRect = CCSizeMake(ScaleWidth, ScaleHeight); --设置要拉伸后的的大小
    -- local m_pNextBG  = CCScale9Sprite:createWithSpriteFrameName(frameName, fullRect, rectInsets);
    local m_pNextBG = CCScale9Sprite:createWithSpriteFrameName(frameName, rectInsets);
    m_pNextBG:setContentSize(winRect);
    return m_pNextBG
end

--[[--
--tableview按钮按下点击效果
--]]
function showTableViewMenuBtnPress(btn)
    if btn:numberOfRunningActions() > 0 then
        return;
    end
    local time = 0.1;
    local array = CCArray:create();
    array:addObject(CCEaseOut:create(CCScaleTo:create(time, 1.05), 0.5));
    btn:runAction(CCSequence:create(array));
end

--[[--
--tableview按钮抬起点击效果
--]]
function showTableViewMenuBtnUp(btn)
    btn:stopAllActions();
    local time = 0.1;
    local array = CCArray:create();
    array:addObject(CCEaseOut:create(CCScaleTo:create(time, 0.95), 0.5));
    array:addObject(CCSpawn:createWithTwoActions((CCTintTo:create(time, 255, 255, 255)), CCEaseIn:create(CCScaleTo:create(time, 1), 0.5)));
    btn:runAction(CCSequence:create(array));
end

--[[--
--得到九宫格精灵--只拉中间
--@param #String imageNamePath 图片地址
--@param #number leftWidth 图片保留左
--@param #number topHeight 图片保留上
--@param #number RightWidth 图片显示右
--@param #number downHeight 图片显示下
--@param #number ScaleWidth 图片显示高
--@param #number ScaleHeight 图片显示宽
--]]
function createPointNineSpriteByScaleWH(imageNamePath, leftWidth, topHeight, RightWidth, downHeight , ScaleWidth, ScaleHeight)
	local tmp = CCSprite:create(imageNamePath);
	local tmpsize = tmp:getContentSize();
	local fullRect = CCRectMake(0,0, tmpsize.width, tmpsize.height);--图片的大小
	local rectInsets = CCRectMake(leftWidth,topHeight,tmpsize.width-RightWidth-leftWidth,tmpsize.height- downHeight - topHeight);
	local winRect = CCSizeMake(ScaleWidth, ScaleHeight);--设置要拉伸后的的大小
	local m_pNextBG  = CCScale9Sprite:create(imageNamePath, fullRect, rectInsets);
	m_pNextBG:setContentSize(winRect);
	return m_pNextBG
end

--呼吸动画
function breathEffect(senter)
	local array = CCArray:create()
	array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, 0.9), 0.5))
	array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, 1.05), 0.5))
	local seq = CCSequence:create(array)
	senter:runAction(CCRepeatForever:create(seq))
end

--[[--
--呼吸动画
--small:缩小倍数
--big:放大倍数
--]]
function NewbreathEffect(senter,small,big)
	local array = CCArray:create()
	array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, small), 0.5))
	array:addObject(CCEaseInOut:create(CCScaleTo:create(0.5, big), 0.5))
	local seq = CCSequence:create(array)
	senter:runAction(CCRepeatForever:create(seq))
end

--获得当前屏幕截图的精灵
local CurrentSenceSprite = nil
function addCurrentSenceSprite()
	if(CurrentSenceSprite ~= nil)then
		CurrentSenceSprite:removeFromParentAndCleanup(true)
		CurrentSenceSprite = nil
	end
	local runingScene = CCDirector:sharedDirector():getRunningScene();
	local DZJWinSize =  CCDirector:sharedDirector():getVisibleSize()
	local renderTexture = CCRenderTexture:create(DZJWinSize.width, DZJWinSize.height);
	renderTexture:begin();
	runingScene:visit();
	renderTexture:endToLua();
	CurrentSenceSprite = CCSprite:createWithTexture(renderTexture:getSprite():getTexture());
	--CurrentSenceSprite:setColor(ccc3(125,125,125))
	CurrentSenceSprite:setFlipY(true);
	--CurrentSenceSprite:setScale(0.5)
	CurrentSenceSprite:setAnchorPoint(ccp(0,0))
	runingScene:addChild(CurrentSenceSprite)

end

local UP = 1
local DOWN = 2
local LEFT = 3
local RIGHT = 4
local isBackDirection = false

function showBaseLayerAction(view, viewName)
	isBackDirection = true
	mvcEngine.createModule(GameConfig.getTheLastBaseLayer())
end

--全屏移动动画
--view:最动画的层,comeFrom:从哪个方向来,1:上，2:下,3:左，4:右,time:时间
function runSenceAction(view, callBack, isBack)
	if true then
		if callBack ~= nil then
			callBack()
		end
		return
	end

	local DZJWinSize =  view:getContentSize()
	DZJWinSize.width =  DZJWinSize.width*view:getScaleX()
	DZJWinSize.height =  DZJWinSize.height*view:getScaleY()
	local time = 0.25
	local comeFrom = RIGHT
	if(isBackDirection)then
		if(isBack)then
			comeFrom = RIGHT
		else
			comeFrom = LEFT
		end
	else
		if(isBack)then
			comeFrom = LEFT
		else
			comeFrom = RIGHT
		end
	end
	local beginPosition = nil
	local process = nil
	if(comeFrom == 1)then
		beginPosition = ccp(view:getPositionX(),view:getPositionY()+DZJWinSize.height)
		process = ccp(0,-DZJWinSize.height)
	elseif(comeFrom == 2)then
		beginPosition = ccp(view:getPositionX(),view:getPositionY()-DZJWinSize.height)
		process = ccp(0,DZJWinSize.height)
	elseif(comeFrom == 3)then
		beginPosition = ccp(view:getPositionX() - DZJWinSize.width,view:getPositionY())
		process = ccp(DZJWinSize.width,0)
	elseif(comeFrom == 4)then
		beginPosition = ccp(view:getPositionX() + DZJWinSize.width,view:getPositionY())
		process = ccp(-DZJWinSize.width,0)
	end
	local action = nil
	local moveby = nil
	moveby = CCMoveBy:create(time, process)
	local array = CCArray:create()
	if(not isBack)then
		view:setPosition(beginPosition)
		array:addObject(moveby)
		if callBack ~= nil then
			array:addObject(CCCallFuncN:create(callBack))
		end
		array:addObject(CCCallFuncN:create(function() isBackDirection = false end))
		view:runAction(CCSequence:create(array))
	else
		array:addObject(moveby:reverse())
		return CCSequence:create(array)
	end
end

--[[--
--tableview按钮按下点击效果
--]]
function showTableViewMenuBtnPress(btn)
	if btn:numberOfRunningActions() > 0 then
		return;
	end
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, 1.05), 0.5));
	btn:runAction(CCSequence:create(array));
end

--[[--
--tableview按钮抬起点击效果
--]]
function showTableViewMenuBtnUp(btn)
	btn:stopAllActions();
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, 0.95), 0.5));
	array:addObject(CCSpawn:createWithTwoActions((CCTintTo:create(time, 255, 255, 255)), CCEaseIn:create(CCScaleTo:create(time, 1), 0.5)));
	btn:runAction(CCSequence:create(array));
end

--[[--
--显示对话框动画
--]]
function showDialogAmin(view, isCentre, callBack)
	--	view:setOpacity(0);
	--	if not(isCentre ~= nil and isCentre) then
	--		view:setAnchorPoint(ccp(0.5, 0.5))
	--		view:setPosition(ccp(view:getPosition().x + view:getSize().width / 2,view:getPosition().y + view:getSize().height / 2))
	--	end
	--	local action = CCFadeIn:create(1);
	--	local array = CCArray:create()
	--	array:addObject(action)
	--	if(callBack)then
	--		array:addObject(CCCallFuncN:create(callBack))
	--	end
	--	view:runAction(CCSequence:create(array))
	if view == nil then
		return
	end

	view:setScale(0.8)
	if not(isCentre ~= nil and isCentre) then
		view:setAnchorPoint(ccp(0.5, 0.5))
		view:setPosition(ccp(view:getPosition().x + view:getSize().width / 2,view:getPosition().y + view:getSize().height / 2))
	end
	local action = CCScaleTo:create(0.1, 1);
	local array = CCArray:create()
	array:addObject(CCEaseBackOut:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	view:runAction(CCSequence:create(array))
end

--[[--
--隐藏对话框动画
--]]
function closeDialogAmin(view, callBack)
    if GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
        --德州扑克，屏蔽动画
        --		local array = CCArray:create()
        --		if(callBack)then
        --			array:addObject(CCCallFuncN:create(callBack))
        --		end
        --		if view then
        --			view:runAction(CCSequence:create(array))
        --		end
        if callBack ~= nil then
            callBack();
        end
        return;
    end
	local action = nil
	if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
		action = CCScaleTo:create(0.15, 0.2);
	elseif GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
		action = CCScaleTo:create(0.15, 1.2);
	else
		action = CCScaleTo:create(0.15, 1.2);
	end
	local array = CCArray:create()
	array:addObject(CCEaseBackIn:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	if view ~= nil then
		view:runAction(CCSequence:create(array))
	end
end

--从icon的位置触发
function comeFromIconPosition(view,iconPosition,callBack,isBack)
	local time = 0.1
	local DZJWinSize =  CCDirector:sharedDirector():getWinSize()
	local scaleAction = CCScaleTo:create(time,1)
	view:ignoreAnchorPointForPosition(false)
	view:setAnchorPoint(ccp(0.5,0.5))
	local moveto = CCMoveTo:create(time,ccp(DZJWinSize.width*0.5,DZJWinSize.height*0.5))
	if(not isBack)then
		view:setScale(0)
		view:setPosition(iconPosition)
	else
		scaleAction = CCScaleTo:create(time,0)
		moveto = CCMoveTo:create(time,iconPosition)
	end

	local array = CCArray:create()
	array:addObject(scaleAction)
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	view:runAction(CCSequence:create(array))
	view:runAction(moveto)
end

--页面快速滑入
function moveinAction(view)
	local DZJWinSize =  CCDirector:sharedDirector():getWinSize()
	view:setPosition(ccp(view:getPosition().x + DZJWinSize.width,view:getPosition().y))
	view:runAction(CCEaseOut:create(CCMoveBy:create(0.25,ccp(-DZJWinSize.width,0)),0.8))
end

--[[--
--列表展示效果
--@param #table itemList 列表队列
--]]
function showLandscapeList(itemList, callback, callBackEnd)
	for i = 1, #itemList do
		itemList[i]:setOpacity(0);
	end
	local index = 1;
	local function showItemAmin()
		if index <= #itemList then
			local FadeInAction = CCFadeIn:create(0.2);
			local ScaleBigAction = CCScaleTo:create(0.06, 1.05);
			local ScaleSmallAction = CCScaleTo:create(0.1, 1);
			local arrayFadeIn = CCArray:create();
			local arrayScale = CCArray:create();
			arrayFadeIn:addObject(FadeInAction);
			arrayScale:addObject(ScaleBigAction);
			arrayScale:addObject(CCCallFunc:create(showItemAmin));
			arrayScale:addObject(ScaleSmallAction);
			itemList[index]:runAction(CCSequence:create(arrayFadeIn));
			itemList[index]:runAction(CCSequence:create(arrayScale));

			if callback ~= nil then
				callback(index);
			end

			if index == #itemList and callBackEnd ~= nil then
				--0.1秒后的回调是为了解决大厅按钮的半透明问题
				local array = CCArray:create()
				array:addObject(CCDelayTime:create(0.1))
				array:addObject(CCCallFunc:create(callBackEnd))
				itemList[index]:runAction(CCSequence:create(array));
			end

            		index = index + 1;
        	end
    	end

    showItemAmin();
end

function showLandscapeListFadeIn(itemList, callback, callBackEnd, FadeInInterval)
    for i = 1, #itemList do
        itemList[i]:setOpacity(0);
    end

    local index = 1;
    local function showItemAmin()
        if index <= #itemList then
            local FadeInAction = CCFadeIn:create(FadeInInterval);
            -- local ScaleBigAction = CCScaleTo:create(0.06, 1.05);
            -- local ScaleSmallAction = CCScaleTo:create(0.1, 1);
            local arrayFadeIn = CCArray:create();
            -- local arrayScale = CCArray:create();
            arrayFadeIn:addObject(FadeInAction);
            -- arrayScale:addObject(ScaleBigAction);
            -- arrayScale:addObject(CCCallFunc:create(showItemAmin));
            arrayFadeIn:addObject(CCCallFunc:create(showItemAmin));
            -- arrayScale:addObject(ScaleSmallAction);
            itemList[index]:runAction(CCSequence:create(arrayFadeIn));
            -- itemList[index]:runAction(CCSequence:create(arrayScale));

            if callback ~= nil then
                callback(index);
            end

            if index == #itemList and callBackEnd ~= nil then
                --0.1秒后的回调是为了解决大厅按钮的半透明问题
                local array = CCArray:create()
                array:addObject(CCDelayTime:create(0.1))
                array:addObject(CCCallFunc:create(callBackEnd))
                itemList[index]:runAction(CCSequence:create(array));
            end

            index = index + 1;
        end
    end

    showItemAmin();
end

function showNodeFadeIn(node, interval, callback)
    node:setOpacity(0);

    local FadeInAction = CCFadeIn:create(interval);
    local arrayFadeIn = CCArray:create();
    arrayFadeIn:addObject(FadeInAction);
    arrayFadeIn:addObject(CCCallFunc:create(callback))
    node:runAction(CCSequence:create(arrayFadeIn));
end

function showNodeScale(node, callback)
    local scale1 = CCScaleTo:create(0.06, 0.5);
    local scale2 = CCScaleTo:create(0.1, 1.1);
    local scale3 = CCScaleTo:create(0.5, 1);
    local array = CCArray:create();
    array:addObject(scale1)
    array:addObject(scale2)
    array:addObject(scale3)
    array:addObject(CCCallFunc:create(callback))
    local action = CCSequence:create(array)
    node:runAction(action)
end

local orginalScale = 1;

--[[--
--按钮按下点击效果
--@param #uiWidget btn 控件
--@param #float byScale 缩放倍数
--@param #boolean isBlack 是否变黑
--@param #function func 回调函数
--@param #string event 点击事件
--]]
function buttonActionPress(btn, byScale, isBlack, func, event)
	if btn:numberOfRunningActions() > 0 then
		return;
	end
	--btn:stopAllActions();
	local time = 0.1;
	orginalScale = btn:getScale();
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale * byScale), 0.5));
	if(func ~= nil and event ~= nil)then
		local function callBack()
			func(event);
		end
		array:addObject(CCCallFunc:create(callBack));
	end
	btn:runAction(CCSequence:create(array));
	if(isBlack)then
		btn:runAction(CCTintTo:create(time, 255*0.7, 255*0.7, 255*0.7));
	end
end

--[[--
--按钮抬起点击效果
--@param #uiWidget btn 控件
--@param #float byScale 缩放倍数
--@param #function func 回调函数
--@param #string event 点击事件
--]]
function buttonActionUp(btn, byScale, func, event)
	btn:stopAllActions();
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale * byScale), 0.5));

	array:addObject(CCSpawn:createWithTwoActions((CCTintTo:create(time, 255, 255, 255)), CCEaseIn:create(CCScaleTo:create(time, orginalScale), 0.5)));

	if(func ~= nil and event ~= nil)then
		local function callBack()
			func(event);
		end
		array:addObject(CCCallFunc:create(callBack));
	end
	btn:runAction(CCSequence:create(array));
end

--设置动画效果
function setActionAnimate(btn, noIcon, func)
	btn:stopAllActions();
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale*0.95), 0.5));
	array:addObject(CCEaseIn:create(CCScaleTo:create(time, orginalScale), 0.5));
	if(func ~= nil and noIcon ~= nil)then
		noIcon:setScale(8);
		noIcon:setVisible(true);
		noIcon:setOpacity(125);
		noIcon:runAction(CCEaseOut:create(CCScaleTo:create(time, 1), 0.8));
		noIcon:runAction(CCFadeTo:create(time, 255));
		array:addObject(CCDelayTime:create(time));
		array:addObject(CCCallFunc:create(func));
	else
		noIcon:setVisible(false);
	end
	btn:runAction(CCSequence:create(array));
end

--感叹号动画
function getGanTanHao()
	local GanTanHao = UIImageView:create()
	GanTanHao:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	local move1 = CCEaseInOut:create(CCMoveBy:create(0.13, ccp(0,20)), 0.8)
	local move2 = move1:reverse()
	local array = CCArray:create()
	array:addObject(CCDelayTime:create(3))
	array:addObject(move1)
	array:addObject(move2)
	array:addObject(move2:reverse())
	array:addObject(move1:reverse())
	GanTanHao:runAction(CCRepeatForever:create(CCSequence:create(array)))
	return GanTanHao
end

--[[--
--左摇右摆动画
--]]
function showShakeAnimate(view)
	local array = CCArray:create()
	array:addObject(CCRotateBy:create(0.08, 20))
	array:addObject(CCRotateBy:create(0.08, -40))
	array:addObject(CCRotateBy:create(0.08, 40))
	array:addObject(CCRotateBy:create(0.08, -20))
	array:addObject(CCDelayTime:create(0.8))
	view:runAction(CCRepeatForever:create(CCSequence:create(array)))
end

function showBoxPrizeAnimate(box, prize, callBack)
	local BoxArray = CCArray:create()
	local PrizeArray = CCArray:create()
	local FadeInAction = CCFadeIn:create(0.12);
	local ScaleBigAction = CCScaleTo:create(0.24, 2.3);
	local time = CCDelayTime:create(0.12);
	local FadeOutAction = CCFadeOut:create(0.24);
	BoxArray:addObject(CCSpawn:createWithTwoActions(FadeOutAction, ScaleBigAction));
	PrizeArray:addObject(time);
	PrizeArray:addObject(FadeInAction);
	if callBack ~= nil then
		PrizeArray:addObject(CCDelayTime:create(0.5));
		PrizeArray:addObject(CCCallFunc:create(callBack));
	end
	box:runAction(CCSequence:create(BoxArray));
	prize:runAction(CCSequence:create(PrizeArray));
end

function showOtherBoxPrizeAnimate(box, prize, callBack, timer)
	local BoxArray = CCArray:create()
	local PrizeArray = CCArray:create()
	local FadeInAction = CCFadeIn:create(0.12);
	local time = CCDelayTime:create(0.12);
	local FadeOutAction = CCFadeOut:create(0.24);
	BoxArray:addObject(FadeOutAction);
	PrizeArray:addObject(time);
	PrizeArray:addObject(FadeInAction);
	if callBack ~= nil and timer > 0 then
		PrizeArray:addObject(CCDelayTime:create(timer));
		PrizeArray:addObject(CCCallFunc:create(callBack));
	end
	box:runAction(CCSequence:create(BoxArray));
	prize:runAction(CCSequence:create(PrizeArray));
end

--[[--
--根据字符分割字符串
--]]
function split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--[[
--根据字符分割字符串
--注意：使用子字符串的时候需要加上.str 如：table[index].str
]]
function stingSplit(str, separator)
    if str == nil then
        Common.log("stingSplit str can not be nil")
        return
    end

    if str == "" then
        Common.log("stingSplit str can not be ''")
        return
    end

    if separator == nil then
        Common.log("stingSplit separator can not be nil")
        return
    end

    local strTable = {}
    local strTableIndex = 1
    strTable[strTableIndex] = {}
    strTable[strTableIndex].str = ""
    for i = 1, string.len(str) do
        if string.sub(str, i, i) == separator then
            strTableIndex = strTableIndex + 1

            strTable[strTableIndex] = {}
            strTable[strTableIndex].str = ""
        else
            strTable[strTableIndex].str = strTable[strTableIndex].str .. string.sub(str, i, i)
        end
    end

    return strTable
end

--[[--
--分享到微信 isCircle 是否分享到朋友圈,1为朋友圈,0为好友
--]]--
function shareToWX(isCircle, showTil, showMsg, downLoadUrl)
	local params = 0
	if isCircle ~= nil and isCircle == true then
		params = 1
	end
	local userID = profile.User.getSelfUserID()
	local showTitle = showTil
	local showMessage = showMsg
	local function shareCallBack(parameters)
		if parameters == nil or parameters == "" then
			return
		end

		if parameters == "OK" then
			Common.log("shareCallBack OK")
			-- local mTimeStamp = os.time()
			-- local ShareCompleteTable = Common.LoadShareTable("ShareCompleteTable")
			-- if ShareCompleteTable == nil then
			-- 	Common.log("getSharingReward ShareCompleteTable == nil mTimeStamp is " .. mTimeStamp)
			-- 	ShareCompleteTable = {}
			-- end
			-- ShareCompleteTable[profile.User.getSelfUserID() .. ""] = {}
			-- ShareCompleteTable[profile.User.getSelfUserID() .. ""].TimeStamp = mTimeStamp
			-- Common.SaveShareTable("ShareCompleteTable", ShareCompleteTable)
			-- if CommShareConfig.SHARETYPE == CommShareConfig.SHARE_TYPE_INITIATIVE then
			-- 	InitiativeShareLogic.close()
			-- elseif CommShareConfig.SHARETYPE == CommShareConfig.SHARE_TYPE_PASSIVE then
			-- 	CommShareLogic.close()
			-- elseif CommShareConfig.isRedGiftShareFirst() == true then
			-- 	RedGiftShareLogic.close()
			-- 	CommShareConfig.isSuccessShare = true
			-- 	if CommShareConfig.isNewUserBLoginShare == false then
			-- 		CommShareConfig.setRedGiftShareReceiveRewardEnabled(true)
			-- 		local nowStamp = Common.getServerTime()
			-- 		Common.setDataForSqlite("REDGIFTSHARETIME", nowStamp);
			-- 	end
			-- end
			if GameConfig.GAME_ID == GamePub.ZIPAI_GAME_ID then
				sendZIPAI_SHARING()
			end
			Common.showToast("分享成功  O(∩_∩)O",2)
		elseif parameters == "CANCEL" then
			Common.showToast("不要啦,分享一下下嘛 %>_<%",2)
		elseif parameters == "DENIDE" then
			Common.showToast("分享失败了  %>_<%",2)
		elseif parameters == "OTHER" then
			Common.showToast("分享出错了  %>_<%",2)
		elseif parameters == "HAVE_NO_WX" then
			Common.showToast("安装微信才可以分享哟 O(∩_∩)O",2)
		end
	end
	if Common.platform == Common.TargetIos then
		--ios平台
		--Common.log("ios版本暂未开放分享功能,敬请期待!")
		local AppDownLoadURL = "";

		if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
			if SelfBuildRoomShareLogic.getIsShareBuildRoom() then
				--分享自建房间
				AppDownLoadURL = profile.SelfBuildRoom.getShareRoomURL();
			else
				AppDownLoadURL = profile.ShareToWX.getAppDownLoadURL();
			end
		elseif GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
			AppDownLoadURL = profile.ShareToWXJinhua.getShareToWxUrl();
		elseif GameConfig.GAME_ID == GamePub.ZIPAI_GAME_ID then
			AppDownLoadURL = profile.ShareToWXJinhua.getShareToWxUrl();
		elseif GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID then
			AppDownLoadURL = NiuNiuLoadProfile.NiuNiuGameDoc.getShareURL();
		elseif GameConfig.GAME_ID == GamePub.MAHJONG_SICHUAN_GAMEID then
			if downLoadUrl ~= nil then
				AppDownLoadURL = downLoadUrl;
			end
		end

		if AppDownLoadURL == "" then
			Common.log("没有微信分享链接地址");
			return;
		end

		local args = {
			params = params,
			AppDownLoadURL = AppDownLoadURL,
			showTitle = showTitle,
			showMessage = showMessage,
			shareCallBack = shareCallBack,
		}
		local ok, ret = luaoc.callStaticMethod("WechatConfig", "weixinShare", args);
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local AppDownLoadURL = "";

		if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
			if SelfBuildRoomShareLogic.getIsShareBuildRoom() then
				--分享自建房间
				AppDownLoadURL = profile.SelfBuildRoom.getShareRoomURL();
			else
				AppDownLoadURL = profile.ShareToWX.getAppDownLoadURL();
			end
			Common.log("AppDownLoadURL = " .. AppDownLoadURL)
		elseif GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID then
			AppDownLoadURL = NiuNiuLoadProfile.NiuNiuGameDoc.getShareURL();
		elseif GameConfig.GAME_ID == GamePub.MAHJONG_SICHUAN_GAMEID then
			if downLoadUrl ~= nil then
				AppDownLoadURL = downLoadUrl;
			end
		end
		Common.log("AppDownLoadURL = " .. AppDownLoadURL)
		local javaClassName = Load.AndroidPackage..".pay.weixinpay.WechatUtils"
		local javaMethodName = "luaCallWXShare"
		local javaParams = {
			params,
			userID,
			shareCallBack,
			showTitle,
			showMessage,
			AppDownLoadURL,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--分享图片到微信 isCircle 是否分享到朋友圈,1为朋友圈,0为好友
--]]--
function sharePicToWX(isCircle,mIconPath, mPicPath)
	local params = 0
	if isCircle ~= nil and isCircle == true then
		params = 1
	end
	local userID = profile.User.getSelfUserID()
	local iconPath = mIconPath
	local picPath = mPicPath
	local function shareCallBack(parameters)
		if parameters == nil or parameters == "" then
			return
		end

		if parameters == "OK" then
			--回调成功
			if GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
				RecommendLogic.shareToWXCallBack()
			elseif GameConfig.GAME_ID == GamePub.ZIPAI_GAME_ID then
				sendZIPAI_SHARING()
			end
			Common.showToast("分享成功  O(∩_∩)O",2)
		elseif parameters == "CANCEL" then
			Common.showToast("不要啦,分享一下下嘛 %>_<%",2)
		elseif parameters == "DENIDE" then
			Common.showToast("分享失败了  %>_<%",2)
		elseif parameters == "OTHER" then
			Common.showToast("分享出错了  %>_<%",2)
		elseif parameters == "HAVE_NO_WX" then
			Common.showToast("安装微信才可以分享哟 O(∩_∩)O",2)
		end
	end
	if Common.platform == Common.TargetIos then
		--ios平台

		local args = {
			params = params,
			iconPath = iconPath,
			picPath = picPath,
			shareCallBack = shareCallBack,
		}
		local ok, ret = luaoc.callStaticMethod("WechatConfig", "weixinSharePic", args);
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage..".pay.weixinpay.WechatUtils"
		local javaMethodName = "luaCallWXSharePic"
		local javaParams = {
			params,
			userID,
			shareCallBack,
			iconPath,
			picPath,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end
--微信分享截屏
function shareSenceToWx(isSelect)
	-- CCClippingNode 这个会对截屏有影响
	local shareIconPng = "shareIconPng.png"
	local shareContentPng = "shareContentPng.png"
	--创建截屏图片
	QrcodeUtil.drawSencePng(shareContentPng,1)
	local sencePngPath = QrcodeUtil.getQRCodePicPath(shareContentPng)
	--压缩截屏文件
	--获取截屏图片 分享的图标
	QrcodeUtil.drawScaleSencePng(sencePngPath,shareIconPng,0.1)
	local senceScalePngPath = QrcodeUtil.getQRCodePicPath(shareIconPng)
	--重新获取截屏图片  目的是压缩一下
	QrcodeUtil.drawScaleSencePng(sencePngPath,shareContentPng,0.7)
	sharePicToWX(isSelect,senceScalePngPath,sencePngPath)
end


--[[--
--下载图片（判断本地是否有对应图片）
--]]
function downloadImageForNative(picUrl, nResID, bHighPri, callBackFunction)
	--金币：
	--新手引导/牌桌宝盒：http://f.99sai.com/assets/coin/coin_0001.png
	--月签：http://f.99sai.com/assets/coin/coin_0007.png
	--包中："ic_recharge_guide_jinbi.png"
	if picUrl == "http://f.99sai.com/assets/coin/coin_0001.png" or picUrl == "http://f.99sai.com/assets/coin/coin_0007.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_recharge_guide_jinbi.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_recharge_guide_jinbi.png"))
			return
		end
	end

	--碎片：
	--新手引导/牌桌宝盒：http://f.99sai.com/assets/pieces/pieces_0006.png
	--月签：http://f.99sai.com/assets/pieces/pieces_0004.png
	--包中
	if picUrl == "http://f.99sai.com/assets/pieces/pieces_0006.png" or picUrl == "http://f.99sai.com/assets/pieces/pieces_0004.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
				path["useravatorInApp"] = Common.getResourcePath("ic_sign_dasuipian.png");
			elseif GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
				path["useravatorInApp"] = Common.getResourcePath("ic_caishen_suipian0.png");
			else
				path["useravatorInApp"] = Common.getResourcePath("ic_caishen_suipian0.png");
			end
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
				callBackFunction(nResID.."#"..Common.getResourcePath("ic_sign_dasuipian.png"));
			elseif GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
				callBackFunction(nResID.."#"..Common.getResourcePath("ic_caishen_suipian0.png"));
			else
				callBackFunction(nResID.."#"..Common.getResourcePath("ic_caishen_suipian0.png"));
			end

			return
		end
		return
	end
	--元宝：
	--新手引导：http://f.99sai.com/assets/yuanbao/yuanbao_0001.png
	--包中：ic_activity_yuanbao.png
	if picUrl == "http://f.99sai.com/assets/yuanbao/yuanbao_0001.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_activity_yuanbao.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_activity_yuanbao.png"))
			return
		end
		return
	end

	--1元话费：
	--http://f.99sai.com/assets/cash-award/cash-award_0004.png
	--包中没有

	--合成符：
	--月签http://f.99sai.com/assets/item/item18_003.png
	--牌桌宝盒http://f.99sai.com/assets/item/item18_001.png
	--包中：ic_hecheng_hechengfu.png
	if picUrl == "http://f.99sai.com/assets/item/item18_003.png" or picUrl == "http://f.99sai.com/assets/item/item18_001.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_hecheng_hechengfu.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_hecheng_hechengfu.png"))
			return
		end
		return
	end

	--复活石：
	--月签：http://f.99sai.com/assets/item/item26_001.png
	--包中：ic_chuangguan_fuhuoshi.png
	if picUrl == "http://f.99sai.com/assets/item/item26_001.png" then
		if Common.platform == Common.TargetIos then
			--ios平台
			local path = {};
			path["useravatorInApp"] = Common.getResourcePath("ic_chuangguan_fuhuoshi.png")
			path["id"] = nResID
			callBackFunction(path)
			return
		elseif Common.platform == Common.TargetAndroid then
			callBackFunction(nResID.."#"..Common.getResourcePath("ic_chuangguan_fuhuoshi.png"))
			return
		end
		return
	end

	Common.getPicFile(picUrl, nResID, bHighPri, callBackFunction)
end

--[[--
--检测客户端安装的应用
--]]
function detectClientInstalledApp()
	if profile.AndroidExit.hasAppNoDownloadCompleted() then
		--如果上一次的应用没下载完
		if Common.getConnectionType() == Common.NET_WIFI or Common.getConnectionType() == Common.NET_4G then
			--当前是WIFI网络或4G网络,则继续下
			local appUrlTable = profile.AndroidExit.getDownloadAppUrlData();
			if appUrlTable ~= nil and appUrlTable.GameID ~= nil and appUrlTable.AppUrl ~= nil then
				--设置下载完成回调的方法 参数：应用ID 回调方法 下载完是否立即安装 true 是 false 否
				Common.setDownloadCompleteCallBack(appUrlTable.GameID, callBackAfterDownloadAppComplete, false);
				--将所有应用设为已安装
				profile.AndroidExit.setAllAppDownloadStatus(1);--1是已安装应用
				--后台下载
				DownloadControler.getDownloadFile(appUrlTable.AppUrl, Common.getAppDownloadPath(), DownloadControler.DOWNLOAD_ACTION_A, true, false, appUrlTable.DownloadTips);
				return;
			end
		end
	end

	if not profile.AndroidExit.isDetectedAppInstalledComplete() then
		--如果已经检测完应用的安装情况, 则检测app是否安装
		checkAppIsInstalled();
	end
end

--[[--
--检查应用是否安装
--]]
function checkAppIsInstalled()
	local appInfoTable = profile.AndroidExit.getAppInfoTable();
	for key, value in pairs(appInfoTable) do
		if tonumber(key) == GameConfig.GAME_ID then
			--GameID为当前游戏,则不用检测 参数：应用英文名 是否安装
			profile.AndroidExit.setAppIsInstalledByName(key, 1);
		else
			--GameID为不为当前游戏,则检测
			--根据应用的名字设置游戏是否安装
			profile.AndroidExit.setAppIsInstalledByName(key, Common.checkAppIsInstalledByPackName(key, appInfoTable[key]["packName"]));
		end
	end
end

--[[--
--加载完应用的回调方法
--]]
function callBackAfterDownloadAppComplete(data)
	local sGameID = "";--应用的ID
	local FilePath = "";--下载的文件路径
	local i, j = string.find(data, "#")
	sGameID = string.sub(data, 1, i-1)
	FilePath = string.sub(data, j+1, -1);

	Common.log("callBackAfterDownloadAppComplete")

	--删除保存在本地的下载路径
	profile.AndroidExit.deleteDownloadAppUrl(sGameID);
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		--如果当前的界面时大厅,则直接安装下载完的应用
		Common.installApp(FilePath);
	else
		--如果当前界面不是大厅,则返回大厅后才安装应用
		GameConfig.NeedToInstallApp = true;
		GameConfig.AppFilePath = FilePath;
	end

end

--[[--
--交叉推广下载游戏后的回调方法
--]]
function callBackDownloadAppTuiGuang(data)
	local sGameID = "";--应用的ID
	local FilePath = "";--下载的文件路径
	local i, j = string.find(data, "#")
	sGameID = string.sub(data, 1, i-1)
	FilePath = string.sub(data, j+1, -1);
	Common.log("tuiguang call address:"..FilePath)

	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		--如果当前的界面时大厅,则直接安装下载完的应用
		Common.installApp(FilePath);
	end
end

--[[--
-- lua中截取UTF8字符串的方法（无乱码）
--]]
function SubUTF8String(s, n)
	local dropping = string.byte(s, n+1)
	if not dropping then return s end
	if dropping >= 128 and dropping < 192 then
		return SubUTF8String(s, n-1)
	end
	return string.sub(s, 1, n)
end

--[[--
延时执行方法
@param #view view 控件
@param #float delayTime 延时时间
@param #function func 要执行的方法
]]
function delayDoFunc(view, delayTime, func)
	local delayAnim = CCDelayTime:create(delayTime);
	local funcAnim = CCCallFuncN:create(func);
	local array = CCArray:create();
	array:addObject(delayAnim);
	array:addObject(funcAnim);
	local seq = CCSequence:create(array);
	view:runAction(seq);
end

--[[--
--扎金花牌桌按钮抬起点击效果
--@param #uiWidget btn 控件
--@param #float byScale 缩放倍数
--@param #function func 回调函数
--@param #string event 点击事件
--]]
function buttonActionUpInTable(btn, byScale, func, event)
	local orginalScale = 0.95
	btn:stopAllActions();
	local time = 0.1;
	local array = CCArray:create();
	array:addObject(CCEaseOut:create(CCScaleTo:create(time, orginalScale * byScale), 0.5));

	array:addObject(CCSpawn:createWithTwoActions((CCTintTo:create(time, 255, 255, 255)), CCEaseIn:create(CCScaleTo:create(time, orginalScale), 0.5)));

	if(func ~= nil and event ~= nil)then
		local function callBack()
			func(event);
		end
		array:addObject(CCCallFunc:create(callBack));
	end
	btn:runAction(CCSequence:create(array));
end

--[[--
--友盟推送：给服务器发送token
--]]
function UmengPushToken()
	local function CallBack(parameters)
		if parameters == nil or parameters == "" then
			return
		end
		sendMANAGERID_ADD_ANDROID_DEVICE_TOKEN(parameters)
	end

	if Common.platform == Common.TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "luaCallUmengToken"
		local javaParams = {
			CallBack,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

function setSubUIElementPosition(parentView, parentViewScaleRate, subUIElementPoint, tableSubUIElement, subUIElementGap, align)
    if parentView == nil then
        Common.log("parentView can not be nil")
        return
    end

    if tableSubUIElement == nil then
        Common.log("setSubUIElementPosition tableSubUIElement can not be nil")
        return
    end

    if #tableSubUIElement == 0 then
        Common.log("setSubUIElementPosition tableSubUIElement count can not be 0")
        return
    end

    local subUIElementTotalWidth = 0
    for i = 1, #tableSubUIElement do
        local element = tableSubUIElement[i]
        subUIElementTotalWidth = subUIElementTotalWidth + element:getContentSize().width * GameConfig.SCALE_UI + subUIElementGap
    end

    --	Common.log("setSubUIElementPosition subUIElementTotalWidth = "..subUIElementTotalWidth)
    --	Common.log("parentView:getContentSize().width = "..parentView:getContentSize().width*parentViewScaleRate)
    --	Common.log("parentView:getContentSize().height = "..parentView:getContentSize().height*parentViewScaleRate)

    if align == "center" then
        local preElementPosX = 0
        local preElementSizeWidth = 0
        for i = 1, #tableSubUIElement do
            local preElement = tableSubUIElement[i - 1]

            local element = tableSubUIElement[i]
            element:setAnchorPoint(ccp(0, 0.5))
            local elementPosX = 0

            if preElement then
                elementPosX = preElementPosX + preElementSizeWidth + subUIElementGap

                preElementPosX = 0
                preElementSizeWidth = 0
            else
                elementPosX = parentView:getContentSize().width * parentViewScaleRate / 2 - subUIElementTotalWidth / 2
            end

            --			Common.log("elementPosX = "..elementPosX)
            --			Common.log("subUIElementPoint.y = "..subUIElementPoint.y)
            element:setPosition(ccp(elementPosX, subUIElementPoint.y))
            parentView:addChild(element)

            preElementPosX = elementPosX
            preElementSizeWidth = element:getContentSize().width * GameConfig.SCALE_UI
        end
    end
end

--[[--
--获取时间字符串
--]]
function getTimeStr(time)
	local sounds = (time%60) - (time%60)%1
	local minute = ((time/60)%60) - ((time/60)%60)%1
	local ours = (time/3600) - (time/3600)%1
	local oursString = ours > 9 and tostring(ours) or ("0" .. ours)
	local minuteString = minute > 9 and tostring(minute) or ("0" .. minute)
	local soundsString = sounds > 9 and tostring(sounds) or ("0" .. sounds)
	--	minuteString = minuteString + (60 * ours);
	return oursString..":"..minuteString..":"..soundsString
end

--[[--
--下载全部图片后调用回调方法
--@param #imageTable table 图片table
--@param #isNeedRoundPhoto boolean 是否需要圆形图像
--@param #callBack func 回调函数
--]]
function downloadAllImgAndCallBack(imageTable,isNeedRoundPhoto,callBack)
	if imageTable == nil or #imageTable == 0 then
		Common.log("downloadAllImgAndCallBack 1")
		callBack()
		return
	end

	--定时器,用于超时处理
	local lookTimer = nil
	local function overtime()
		Common.log("overtime ============= ")
		if lookTimer ~= nil then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer);
			lookTimer = nil;
		end
		callBack()
	end

	local tableIndex = #imageTable
	--下载图片
	local function downloadImg(path)
		local photoPath = nil
		local id = nil
		if Common.platform == Common.TargetIos then
			photoPath = path["useravatorInApp"]
			id = path["id"]
		elseif Common.platform == Common.TargetAndroid then
			--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
			local i, j = string.find(path, "#")
			id = string.sub(path, 1, i - 1)
			photoPath = string.sub(path, j + 1, -1)
		end
		Common.log("downloadAllImgAndCallBack downloadImg photoPath " .. photoPath);
		Common.log("downloadAllImgAndCallBack downloadImg id " .. id);
		if id ~= nil and photoPath ~= nil and photoPath ~= "" then
			tableIndex = tableIndex - 1
			if tableIndex == 0 then
				Common.log("全部图片下载后调用 ============ ");
				overtime()
			end
		end
	end
	--依次下载图片
	for i = 1, #imageTable do
		Common.log("downloadAllImgAndCallBack for imageTable["..i.."] == " .. imageTable[i]);
		Common.getPicFile(imageTable[i], i, true, downloadImg, isNeedRoundPhoto);
	end
	--设置超时时间
	lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(overtime, 30 ,false)
end

--[[--
--精确保留N位小数
--]]
function getPreciseDecimal(nNum, n)
	if type(nNum) ~= "number" then
		return nNum;
	end
	n = n or 0;
	n = math.floor(n)
	if n < 0 then
		n = 0;
	end
	local nDecimal = 1/(10 ^ n)
	if nDecimal == 1 then
		nDecimal = nNum;
	end
	local nLeft = nNum % nDecimal;
	return nNum - nLeft;
end

--[[--
--获取筹码格式化数据
--]]
function getChipFormat(chip)
    local chipFormat = chip;
    if chip / 1000000000 >= 1 then
        local num = chip / 1000000000
        if math.floor(num) < num then
            --小数
            chipFormat = getPreciseDecimal(num, 2) .. "B"
        else
            --整数
            chipFormat = num .. "B";
        end
    elseif chip / 1000000 >= 1 then
        local num = chip / 1000000
        if math.floor(num) < num then
            --小数
            chipFormat = getPreciseDecimal(num, 2) .. "M"
        else
            --整数
            chipFormat = num .. "M";
        end
    elseif chip / 1000 >= 1 then
        local num = chip / 1000
        if math.floor(num) < num then
            --小数
            chipFormat = getPreciseDecimal(num, 2) .. "K"
        else
            --整数
            chipFormat = num .. "K";
        end
    else
        chipFormat = "" .. chipFormat
    end

    return chipFormat;
end

--[[--
--获取数字格式化数据（用逗号隔开）
--]]
function getTypefaceFormatDiot(chip)
    local chipFormat = "" .. chip;
    local len = math.floor((string.len(chipFormat) - 1) / 3)
    --计算位数
    if len == 0 then
        --不到千位 直接返回
        return chipFormat
    end
    chipFormat = "" --最终字符串
    local numChip = chip --中间变量
    for i = 1, len do
        local number = string.format("%.3f", numChip / 1000)
        local endNum = string.sub(number, -3)

        --取整数部分
        numChip = math.floor(numChip / 1000)
        if i == 1 then
            chipFormat = chipFormat .. endNum
        else
            chipFormat = endNum .. "," .. chipFormat
        end
        if i == len then
            --把整数部分加上
            chipFormat = numChip .. "," .. chipFormat
        end
    end
    return chipFormat;
end

--[[--
--倒序排列数组(只适用于数字下标的数组)
--]]
function reverseTable(tab)
    local tmp = {}
    for i = 1, #tab do
        local key = #tab
        tmp[i] = table.remove(tab)
    end

    return tmp
end
