module("ToastView",package.seeall)

view = nil;

Panel_20 = nil;--
local toastGUITable = {};
local toastLabelTable = {};
local toastCloseTime = {};--存放toast显示截至时间戳

local MOST_TOAST_NUM = 4;--最多支持toast个数
local slowDisappearTime = 0.7;--渐隐渐现时间
local ONE_ROW_HEIGHT = 45
local mnWidth = 100--背景条宽度
local mLabelWidth = 100--label宽度
local mnHeight = ONE_ROW_HEIGHT
local fontSize = 25;--字号
local MaxWordNum = 25;--每一行最大字的个数
local MaxHeight = 80;--最大高度

local showViewX = 1136 / 2;
local showViewY = 640 * 2/5;

--[[--
--获取toast显示的剩余时间
--]]
local function getToastCloseTime(index)
	local time = toastCloseTime[index] - Common.getServerTime();
	if time < slowDisappearTime then
		time = slowDisappearTime + 0.1
	end
	return time;
end
function setCurrentScreenResolution(UIView, gui, UIDesignWidth, UIDesignHeight, kResolution)

	--不是一级界面,二三级界面使用当前一级界面屏幕比例进行缩放
	if UIDesignWidth ~= GameConfig.ScreenWidth then
		--如果当前游戏设计的分辨率的宽不等于当前UI工程的宽,将当前的UI进行缩放
		UIView:setScaleX(GameConfig.ScreenWidth / UIDesignWidth);
	end
	if UIDesignHeight ~= GameConfig.ScreenHeight then
		--如果当前游戏设计的分辨率的宽不等于当前UI工程的宽,将当前的UI进行缩放
		UIView:setScaleY(GameConfig.ScreenHeight / UIDesignHeight);
	end
	--二三级界面适配需要：将锚点设为(0,0)
	UIView:setAnchorPoint(ccp(0,0));
end
--[[--
--初始化当前界面
--]]
local function initLayer()
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("Toast.json"));
		setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("Toast.json"));
		setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_20:setTouchEnabled(false)
end

local function colseLayer()
	toastGUITable = {};
	toastLabelTable = {};
	toastCloseTime = {};
	if view ~= nil then
		view:removeFromParentAndCleanup(true);
		view = nil;
	end
end

function showToast(text, time)
	if view == nil then
		createView()
	end
	createToast(text, time)
end

function createView()
	--初始化当前界面
	initLayer();
	GameStartConfig.addChildForScene(view)
	initView();
	view:setZOrder(20)

	--	local touchLayer = CCLayer:create()
	--	view:addChild(touchLayer)
	--	touchLayer:setTouchPriority(-99999)
	--	touchLayer:registerScriptTouchHandler(colseLayer, false, -99999, true)
	--	touchLayer:setTouchEnabled(true)
end

local function removeToastByIndex(index)
	if toastGUITable[index] ~= nil then
		toastGUITable[index]:stopAllActions()
		toastGUITable[index]:removeFromParentAndCleanup(true)
		table.remove(toastGUITable, index);
		table.remove(toastLabelTable, index);
		table.remove(toastCloseTime, index);
	end
end

--[[--
--删除toast
--]]
--local function removeToast(sprte)
--	for i = 1,#toastGUITable do
--		if toastGUITable[i] == sprte then
--			removeToastByIndex(i);
--			break;
--		end
--	end
--	if #toastGUITable == 0 then
--		colseLayer()
--	end
--end

--[[--
--添加toast
--]]
local function addToast(text, time, a_ARGB, r_ARGB, g_ARGB, b_ARGB)
	local txtLength = Common.getFontStringLen(text, fontSize);
	--Common.log("size ============================= "..size);
	--local txtLength = string.len(text)--中文占3个字符，英文占1个字符
	Common.log("txtLength ============================= "..txtLength);
	if txtLength < MaxWordNum * fontSize then
		--每行显示18个汉字
		mLabelWidth = txtLength + 2 * fontSize
		mnHeight = ONE_ROW_HEIGHT
		mnWidth = mLabelWidth + 2 * fontSize
	elseif txtLength > 2 * MaxWordNum * fontSize then
		--多余两行
		text = Common.SubUTF8String(text, 1, MaxWordNum * 2 - 2).."..."
		mLabelWidth = MaxWordNum * fontSize;
		mnHeight = MaxHeight;
		mnWidth = mLabelWidth + 2 * fontSize--在Label两侧各加两个字的宽度，为背景sprite的宽
	else
		mLabelWidth = MaxWordNum * fontSize;
		mnHeight = MaxHeight;
		mnWidth = mLabelWidth + 2 * fontSize--在Label两侧各加两个字的宽度，为背景sprite的宽
	end

	local toastSprbg = GamePub.createPointNineSprite(loadGameConfig.getGameCommonPath("toast_bg.png"), 10, 10, mnWidth, mnHeight);
	toastSprbg:setPosition(ccp(showViewX, showViewY));
	view:addChild(toastSprbg);

	local toastLable = CCLabelTTF:create(text, "Arial", fontSize, CCSizeMake(mLabelWidth, mnHeight), kCCTextAlignmentCenter);
	toastLable:setPosition(ccp(mnWidth/2, mnHeight/2 - 5));
	toastLable:setOpacity(a_ARGB);
	toastLable:setColor(ccc3(r_ARGB,g_ARGB,b_ARGB))
	toastSprbg:addChild(toastLable)
	--toastSprbg:setCascadeOpacityEnabled(true);
	toastSprbg:setScale(0.1)

	table.insert(toastGUITable, 1, toastSprbg);
	table.insert(toastLabelTable, 1, toastLable);
	table.insert(toastCloseTime, 1, Common.getServerTime() + time);
end

local function callBackRemoveToast(parameters)
	--removeToast(parameters)
	parameters:setVisible(false)

	local hideNum = 0--被隐藏精灵的个数
	for index=1, #toastGUITable do
		if toastGUITable[index]:isVisible() == false then
			hideNum = hideNum + 1;
		end
	end
	if hideNum == #toastGUITable then
		colseLayer()
	end
end

local function runToastAction(index)
	local labelFadeOut = CCCallFuncN:create(function()
		local arr = CCArray:create();
		arr:addObject(CCFadeOut:create(slowDisappearTime));
		local seq = CCSequence:create(arr)
		if toastLabelTable[index] ~= nil then
			toastLabelTable[index]:runAction(seq)
		end
	end)

	local mFadeOutAction = CCFadeOut:create(slowDisappearTime)
	local mMovetoAction = CCMoveTo:create(0.3, ccp(showViewX, showViewY + (index - 1)* MaxHeight))
	local array = CCArray:create();
	if index == 1 then
		array:addObject(CCScaleTo:create(0.2,1.1))
		array:addObject(CCScaleTo:create(0.1,1))
	end
	array:addObject(mMovetoAction);
	array:addObject(CCDelayTime:create(getToastCloseTime(index) - slowDisappearTime))
	--array:addObject(mFadeOutAction);
	array:addObject(CCSpawn:createWithTwoActions(mFadeOutAction,labelFadeOut))
	array:addObject(CCCallFuncN:create(callBackRemoveToast))
	local seq = CCSequence:create(array)
	toastGUITable[index]:runAction(seq)
end

--[[--
--设置toast位置
--]]
local function setToastPosition(time)
	for index = 1, #toastGUITable do
		if index > MOST_TOAST_NUM then
			--个数超过MOST_TOAST_NUM个，删除最后一个
			removeToastByIndex(index);
		else
			if toastGUITable[index]:numberOfRunningActions() > 0 then
				--如果正在移动，先让回到原来位置然后再移动
				toastGUITable[index]:setScale(1)
				toastGUITable[index]:stopAllActions()
				toastLabelTable[index]:stopAllActions()
				toastGUITable[index]:setPosition(ccp(showViewX, showViewY + (index - 1 - 1)* MaxHeight));
				runToastAction(index);
			else
				runToastAction(index);
			end
		end
	end
end

--[[--
--创建Toast
@param #String text Toast文字内容
@param #Int time 显示时间
@param #Byte a_ARGB 透明度
@param #Byte r_ARGB description
@param #Byte g_ARGB description
@param #Byte b_ARGB description
--]]
function createToast(text, time, a_ARGB, r_ARGB, g_ARGB, b_ARGB)
	if text == nil or text == "" then
		Common.log("createToast text = nil return");
		return;
	end
	if a_ARGB == nil or r_ARGB == nil or g_ARGB == nil or b_ARGB == nil then
		a_ARGB = 0xff;
		r_ARGB = 0xf4;
		g_ARGB = 0xe4;
		b_ARGB = 0xd5;
	end
	addToast(text, time, a_ARGB, r_ARGB, g_ARGB, b_ARGB)
	setToastPosition(time)
end

function closeToast()
	colseLayer()
end