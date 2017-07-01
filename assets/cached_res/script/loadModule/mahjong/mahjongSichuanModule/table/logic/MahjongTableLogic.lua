module("MahjongTableLogic", package.seeall)

view = nil;

MahjongTablePanel = nil; --
Panel_Back = nil; --
Image_ZiPos3 = nil; --
Image_backPos3 = nil; --
Image_ZiPos2 = nil; --
Image_backPos2 = nil; --
Image_ZiPos1 = nil; --
Image_backPos1 = nil; --
Image_ZiPos0 = nil; --
Image_backPos0 = nil; --
AtlasLabel_Timer = nil; --
Panel_SurplusCard = nil; --
Label_SurplusCard = nil; --
Label_CurrInning = nil; --

local timerSchedule = nil -- 时间计时器
local currentTimer = 0 -- 时间
local localTime = 0 -- 记录本地时间

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	--gameExit();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("mj_table.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_prepare.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getCardResPath("MJ_HandCardsTPlist.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_tanchuang.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_video.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("mj_element.plist"));
	local gui = GUI_MAHJONGTABLE;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongTable.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongTable.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	MahjongTablePanel = cocostudio.getUIPanel(view, "MahjongTablePanel");
	Panel_Back = cocostudio.getUIPanel(view, "Panel_Back");
	Image_ZiPos3 = cocostudio.getUIImageView(view, "Image_ZiPos3");
	Image_backPos3 = cocostudio.getUIImageView(view, "Image_backPos3");
	Image_ZiPos2 = cocostudio.getUIImageView(view, "Image_ZiPos2");
	Image_backPos2 = cocostudio.getUIImageView(view, "Image_backPos2");
	Image_ZiPos1 = cocostudio.getUIImageView(view, "Image_ZiPos1");
	Image_backPos1 = cocostudio.getUIImageView(view, "Image_backPos1");
	Image_ZiPos0 = cocostudio.getUIImageView(view, "Image_ZiPos0");
	Image_backPos0 = cocostudio.getUIImageView(view, "Image_backPos0");
	AtlasLabel_Timer = cocostudio.getUILabelAtlas(view, "AtlasLabel_Timer");
	Panel_SurplusCard = cocostudio.getUIPanel(view, "Panel_SurplusCard");
	Label_SurplusCard = cocostudio.getUILabel(view, "Label_SurplusCard");
	Label_CurrInning = cocostudio.getUILabel(view, "Label_CurrInning");

	AtlasLabel_Timer:setVisible(true)
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	GameConfig.setTheCurrentBaseLayer(GUI_MAHJONGTABLE);
	GameLoadModuleConfig.setCurrentMiniGameID(MahjongConfig.MahjongSichuanGameID);

	initView();

	view:addChild(MahjongTableCardLayer.getCardLayer());
	view:addChild(MahjongTablePlayerLayer.getTablePlayerLayer());
	view:addChild(MahjongTableButtonLayer.getTableButtonLayer());
	view:addChild(MahjongTableElementLayer.getTableElementLayer());

	if MahjongTableConsole.isTableRecordMode then
		MahjongTableRecordButtonLayer.showTableRecordButtonLayer();
	end

	MahjongTableArmature.loadTableAnim();
	MahjongAudioManager.initMahjongTableAudio();
	--MahjongAudioManager.playTableBackgroundMusic();
	setSurplusCardVisible(false);
	Image_backPos0:setVisible(false);
	Image_backPos1:setVisible(false);
	Image_backPos2:setVisible(false);
	Image_backPos3:setVisible(false);
end

function requestMsg()
end

--[[--
--东南西北方位图
--]]
local DirImageList = {
	"MJ_Table_middle_box_bright_fnt_east.png",
	"MJ_Table_middle_box_bright_fnt_south.png",
	"MJ_Table_middle_box_bright_fnt_west.png",
	"MJ_Table_middle_box_bright_fnt_north.png"
};

--[[--
--刷新用户方位
--]]
function refreshPlayerDir()
	local selfDir = MahjongTableConsole.getPlayerDirBySeatID(MahjongTableConsole.getSelfSeat());
	Image_ZiPos0:loadTexture(DirImageList[selfDir + 1], 1);
	Image_ZiPos1:loadTexture(DirImageList[(selfDir + 1) % 4 + 1], 1);
	Image_ZiPos2:loadTexture(DirImageList[(selfDir + 2) % 4 + 1], 1);
	Image_ZiPos3:loadTexture(DirImageList[(selfDir + 3) % 4 + 1], 1);
end

function setImageZiVisible(Visible)
	Image_ZiPos0:setVisible(Visible);
	Image_ZiPos1:setVisible(Visible);
	Image_ZiPos2:setVisible(Visible);
	Image_ZiPos3:setVisible(Visible);
end

function setCurrPlayerDir()
	local CurrPos = MahjongTableConsole.getPlayerPosBySeat(MahjongTableConsole.getCurrPlayer());
	local CurrDir = MahjongTableConsole.getPlayerDirBySeatID(MahjongTableConsole.getCurrPlayer());
	Image_backPos0:setVisible(false);
	Image_backPos1:setVisible(false);
	Image_backPos2:setVisible(false);
	Image_backPos3:setVisible(false);
	setImageZiVisible(true);

	if CurrPos == 0 then
		Image_ZiPos0:setVisible(false);
	elseif CurrPos == 1 then
		Image_ZiPos1:setVisible(false);
	elseif CurrPos == 2 then
		Image_ZiPos2:setVisible(false);
	elseif CurrPos == 3 then
		Image_ZiPos3:setVisible(false);
	end
	MahjongTableArmature.showTableDirectionAnim(CurrPos + 1, CurrDir + 1)
	local time = 10;
	if next(MahjongTableCardLayer.getTableTakeOutCards()) == nil then
		time = 15;
	end
	startTimer(time)
end

function setSurplusCardVisible(Visible)
	Panel_SurplusCard:setVisible(Visible);
end

--[[--
--设置剩余牌数
--]]
function setSurplusCard(number)
	setSurplusCardVisible(true);
	Label_SurplusCard:setText(tostring(number))
	Label_CurrInning:setText(MahjongTableConsole.mCurrInning.."/"..MahjongTableConsole.mTotalInning)
end

--[[--
--接收心跳消息
--]]
local function readNetworkIDLE()
	MahjongTableButtonLayer.refreshRoomDetailsInfo();
end

--游戏退出
function gameExit()
	if ServerConfig.isAppstoreReview() then
		LoginConfig.setChangeAccount(true)
		mvcEngine.createModule(GUI_LOGIN)
		return
	end
	loadGameConfig.gameExit();
end

-- 更新计时器
local function updateTimer()
	if currentTimer <= 0 then
		return;
	end

	-- 为了当用户切出游戏时同步时间
	currentTimer = currentTimer - (os.time() - localTime)
	localTime = os.time()
	if currentTimer < 0 then
		currentTimer = 0
	end
	AtlasLabel_Timer:setStringValue(currentTimer)

	--	if currentTimer == 0 then
	--		--倒计时结束时，不做处理
	--	end
end

-- 更新时间倒计时
-- num秒数
function startTimer(num)
	currentTimer = tonumber(num)
	AtlasLabel_Timer:setStringValue(num)
	localTime = os.time()
	-- 开始新计时
	if timerSchedule == nil then
		timerSchedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimer, 1, false)
	end
end

-- 关闭计时器
local function closeTimerSchedule()
	if timerSchedule then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(timerSchedule)
		timerSchedule = nil
		currentTimer = 0 -- 时间
		localTime = 0 -- 记录本地时间
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	closeTimerSchedule()
	MahjongChatPopLogic.clearChatList()
	MahjongTableCardLayer.reomveAllCardLayer();
	MahjongTableButtonLayer.reomveTableButtonLayer();
	MahjongTablePlayerLayer.reomveAllTablePlayerLayer();
	MahjongTableElementLayer.reomveAllTableElementLayer();

	if MahjongTableConsole.isTableRecordMode then
		--删除录像UI
		MahjongTableRecordButtonLayer.reomveTableRecordButtonLayer();
	end
	--MahjongAudioManager.stopBgMusic();
end

function addSlot()
	MahjongTableConsole.addSignal();
	MahjongTableRecordConsole.addSignal();
	framework.addSlot2Signal(MSG_IDLE, readNetworkIDLE);
end

function removeSlot()
	MahjongTableConsole.removeSignal();
	MahjongTableRecordConsole.removeSignal();
	framework.removeSlotFromSignal(MSG_IDLE, readNetworkIDLE);

	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("mj_table.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_prepare.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getCardResPath("MJ_HandCardsTPlist.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_tanchuang.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_video.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("mj_element.plist"));
end
