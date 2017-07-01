module("GameStartConfig", package.seeall)

local scene = nil
local backGroundSprite = nil

--[[--
--初始化的缩放值
--]]
local function initScaleValue()
--	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
--		--如果手机当前的分比率小于1.6大于1.4,使用960x640的UI工程
--		GameConfig.ScaleAbscissa = 960 / GameConfig.ScreenWidth;
--		GameConfig.ScaleOrdinate = 640 / GameConfig.ScreenHeight;
--	else
--		--大于1.6, 小于1.4(目前ipad留黑边)
--		GameConfig.ScaleAbscissa = 1136 / GameConfig.ScreenWidth;
--		GameConfig.ScaleOrdinate = 640 / GameConfig.ScreenHeight;
--	end
	GameConfig.ScaleAbscissa = 1920 / GameConfig.ScreenWidth;
	GameConfig.ScaleOrdinate = 1080 / GameConfig.ScreenHeight;
	Common.log("test ===== GameConfig.ScaleAbscissa ==" .. GameConfig.ScaleAbscissa);
end

--[[--
--游戏开始的配置/跳转界面
--]]
function GameStart()
	Common.log("xuweihao GameStart 1")
	local frameSize = CCEGLView:sharedOpenGLView():getFrameSize();--真实屏幕
	--local visibleSize = CCDirector:sharedDirector():getVisibleSize();--显示屏幕
	GameConfig.RealProportion = frameSize.width / frameSize.height;
	local ActualProportion = GameConfig.ScreenWidth / GameConfig.ScreenHeight;
	Common.log("frameSize.width ============ "..frameSize.width);
	Common.log("frameSize.height ============ "..frameSize.height);
	Common.log("RealProportion ============ "..GameConfig.RealProportion);
	Common.log("ActualProportion ============ "..ActualProportion);

	--设置屏幕尺寸
	--1) kResolutionExactFit：强制拉伸游戏方案，这个方案实用性很低，用暴力的拉伸直接将游戏拉伸到全屏，会导致图片比例失真
	--2) kResolutionNoBorder：无黑边保持高宽比拉伸方案，这个方案最美观，但是等比拉伸会导致左右或上下总会有一部分显示到屏幕外，需要自己去保证UI元素不会显示在屏幕外
	--3) kResolutionShowAll：有黑边保持宽高比全显示拉伸方案，这个方案在在上两种方案之间，保持了宽高比也显示了全部内容，但是会在屏幕两侧留下黑边

	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL  then
		--加黑边
		CCEGLView:sharedOpenGLView():setDesignResolutionSize(GameConfig.ScreenWidth, GameConfig.ScreenHeight, kResolutionShowAll);
	else
		--拉伸
		CCEGLView:sharedOpenGLView():setDesignResolutionSize(GameConfig.ScreenWidth, GameConfig.ScreenHeight, kResolutionExactFit);
	end
	--CCDirector:sharedDirector():setDisplayStats(true)
	--初始化的缩放值
	initScaleValue();
	--首次加载游戏资源
	GameStartConfig.GameInit();

	if Common.isDebugState() then
		Load.isOutPutLog = true;
		Load.setLuaLogConfig();
		mvcEngine.createModule(GUI_LOGIN);
	else
		mvcEngine.createModule(GUI_LOADING);
	end
end

function addChildForScene(view)
	if (CCDirector:sharedDirector():getRunningScene() == nil) then
		--创建场景
		Common.log("CCDirector  ======创建场景====== ");
		scene = CCScene:create()
		backGroundSprite = CCSprite:create(Common.getResourcePath("SS_denglu_beijing.png"))
		backGroundSprite:setAnchorPoint(ccp(0,0))
		backGroundSprite:setScaleX(GameConfig.ScreenWidth / backGroundSprite:getContentSize().width)
		backGroundSprite:setScaleY(GameConfig.ScreenHeight / backGroundSprite:getContentSize().height)
		scene:addChild(backGroundSprite)
		CCDirector:sharedDirector():runWithScene(scene)

		scene:addChild(view)
	else
		--适配需要：改变背景大小
		if backGroundSprite == nil then
			backGroundSprite = CCSprite:create(Common.getResourcePath("SS_denglu_beijing.png"))
			backGroundSprite:setAnchorPoint(ccp(0,0))
			backGroundSprite:setScaleX(GameConfig.ScreenWidth / backGroundSprite:getContentSize().width)
			backGroundSprite:setScaleY(GameConfig.ScreenHeight / backGroundSprite:getContentSize().height)
			scene = CCDirector:sharedDirector():getRunningScene()
			CCDirector:sharedDirector():getRunningScene():addChild(backGroundSprite)
		else
			backGroundSprite:setScaleX(GameConfig.ScreenWidth / backGroundSprite:getContentSize().width)
			backGroundSprite:setScaleY(GameConfig.ScreenHeight / backGroundSprite:getContentSize().height)
		end
		CCDirector:sharedDirector():getRunningScene():addChild(view)
	end
end

--[[--
--加载游戏动画，音效
--]]
function GameInit()
	AudioManager.initGameAudio()
	--加载首页动画
	GameArmature.loadHallArmature()
end
