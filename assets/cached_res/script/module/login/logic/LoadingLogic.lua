module("LoadingLogic",package.seeall)

view = nil
local sceneGame = nil
--控件
local parentLayer = nil
local panel = nil
--图片
local bgGameimage = nil
local iconGameimage = nil
--字体
local lab_version = nil
local lab_copyright = nil
local lab_banquan = nil

function onKeypad(event)
	if event == "backClicked" then
		Common.AndroidExitSendOnlineTime()
	elseif event == "menuClicked" then
	end
end

--[[--
--开始登陆游戏
--]]
function startLoginGame()
	if GameConfig.isConnect then
		--已经建立链接
		Common.log("Loading =========== 已经建立链接");
		if GameChannelConfig.isAppStoreChannelID() then
			--appstore审核版本，此时发通用配置消息
			sendMANAGERID_GET_SERVER_CONFIG_V2(ServerConfig.maMessage);
        end

        if LoginConfig.getWeChatToken() ~= nil then
            Common.log("getWeChatToken ======== "..LoginConfig.getWeChatToken());
            LoginConfig.sendWeChatThirdPartLogin();
            return;
        end

		local bIsHasData, nUserID, sUsernamevalue, sPasswordvalue = LoginConfig.getLastUserInfo();
		if bIsHasData then
			LoginConfig.setLoginUserID(nUserID);
			LoginConfig.setLoginUserName(sUsernamevalue);
			if sPasswordvalue == "" then
				sPasswordvalue = GameConfig.DefaultPassword;
			end
			LoginConfig.setLoginPassword(sPasswordvalue);
			Common.log("loading startlogingame username == "..LoginConfig.getLoginUserName())
			sendBASEID_LOGIN(LoginConfig.getLoginUserID(), LoginConfig.getLoginUserName(), LoginConfig.getLoginPassword(), Common.getDeviceInfo());
			return;
        end

		--如果本地没有用户名密码则直接发送注册
		sendMANAGERID_USERLIST_FROM_IMIE();
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_LOADING;
	if GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Loading.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	else
		--适配方案 960x640
		view = cocostudio.createView("Loading.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	end
end

function createView()
	Common.log("xuweihao error 11")
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameConfig.setTheCurrentBaseLayer(GUI_LOADING)

	GameStartConfig.addChildForScene(view)

	panel = cocostudio.getUIPanel(view, "panel")
	--进入游戏的时间
	GameConfig.enterGameTime = os.time();
	parentLayer = CCLayer:create()
	sceneGame = view

	if Common.platform == Common.TargetAndroid then
		Common.closeLogo();
	end

--	startLoginGame();

	changeView();
end

function createIconLayer()
	local iconLayer  = CCLayer:create()
	--版本号
	local versioncode = Common.getVersionName().."."..Common.getChannelID()

	bgGameimage = CCSprite:create(Common.getResourcePath("MJ_UI_bg_small_white.png"))
	bgGameimage:setScaleX(GameConfig.ScreenWidth / bgGameimage:getContentSize().width)
	bgGameimage:setScaleY(GameConfig.ScreenHeight / bgGameimage:getContentSize().height)
	bgGameimage:setPosition(GameConfig.ScreenWidth/2, GameConfig.ScreenHeight/2)
	iconLayer:addChild(bgGameimage)

	iconGameimage = CCSprite:createWithSpriteFrameName("MJ_UI_LOGO_sichuan_daoying.png")
	iconGameimage:setPosition(GameConfig.ScreenWidth/2, GameConfig.ScreenHeight / 2)
	iconLayer:addChild(iconGameimage)
--	local logoUrl = GameChannelConfig.getLogoUrl()
--	if logoUrl ~= nil then
--		local texture = CCTextureCache:sharedTextureCache():addImage(logoUrl)
--		iconGameimage:setTexture(texture)
--		iconGameimage:setTextureRect(CCRectMake(0, 0, texture:getPixelsWide(), texture:getPixelsHigh()))
--	end

	--版本信息、版权
	lab_version = CCLabelTTF:create("lab_version", "Arial", 40)
	lab_version:setPosition(GameConfig.ScreenWidth/2,170)
	lab_version:setString("Version "..versioncode)
	lab_version:setColor(ccc3(0x00,0x00,0x00))
	iconLayer:addChild(lab_version)

--	lab_copyright = CCLabelTTF:create("lab_copyright", "Arial", 25)
--	lab_copyright:setPosition(GameConfig.ScreenWidth/2,5/16*GameConfig.ScreenHeight)
--	lab_copyright:setString("Copyright © 北京同趣同趣科技有限公司")
--	lab_copyright:setColor(ccc3(0x8e,0x75,0x52))
--	iconLayer:addChild(lab_copyright)
--
--	lab_banquan = CCLabelTTF:create("lab_banquan", "Arial", 25)
--	lab_banquan:setPosition(GameConfig.ScreenWidth/2,4/16*GameConfig.ScreenHeight)
--	lab_banquan:setString("版权所有 2016")
--	lab_banquan:setColor(ccc3(0x8e,0x75,0x52))
--	iconLayer:addChild(lab_banquan)

	return iconLayer
end

function changeView()
	--显示icon翻转
	sceneGame:addChild(createIconLayer())
	--icon动画
--	showTqIcon();
end

--[[--
--动画结束自动登录
--]]
local function autologin()
	-- 自动登录
	ResumeSocket("Loading");
end

function showTqIcon()
	--同趣游戏icon
	iconGameimage:setVisible(true)
	local secondAction = CCCallFuncN:create(autologin);
	local action = CCSequence:createWithTwoActions(CCDelayTime:create(1), secondAction);
	iconGameimage:runAction(action)
end

function requestMsg()

end

function addSlot()
	framework.addSlot2Signal(BASEID_LOGIN, LoginConfig.loginManage)
	framework.addSlot2Signal(BASEID_REGISTER, LoginConfig.RegisterManage)
end

function removeSlot()
	framework.removeSlotFromSignal(BASEID_LOGIN, LoginConfig.loginManage)
	framework.removeSlotFromSignal(BASEID_REGISTER, LoginConfig.RegisterManage)
end
