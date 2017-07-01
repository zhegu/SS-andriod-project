module("SettingLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_23 = nil;--
Panel_1 = nil;--
Button_music = nil;--
Button_effect = nil;--
Button_login = nil;--
Button_close = nil;--
Panel_12 = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
		GamePub.closeDialogAmin(Panel_23, closePanel)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_SETTING;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("outgame_set.plist"))
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("Setting.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Setting.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_23 = cocostudio.getUIPanel(view, "Panel_23");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Button_music = cocostudio.getUIButton(view, "Button_music");
	Button_effect = cocostudio.getUIButton(view, "Button_effect");
	Button_login = cocostudio.getUIButton(view, "Button_login");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_12 = cocostudio.getUIPanel(view, "Panel_12");


	if GameConfig.getGameMusicOff() then
		Button_music:loadTextures("MJ_outgame_btn_duigou.png", "MJ_outgame_btn_duigou.png","", 1)
	else
		Button_music:loadTextures("MJ_outgame_btn_duikongkuag.png", "MJ_outgame_btn_duikongkuag.png","", 1)
	end

	if GameConfig.getGameSoundOff() then
		Button_effect:loadTextures("MJ_outgame_btn_duigou.png", "MJ_outgame_btn_duigou.png","", 1)
	else
		Button_effect:loadTextures("MJ_outgame_btn_duikongkuag.png", "MJ_outgame_btn_duikongkuag.png","", 1)
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)

	initView();

	GamePub.showDialogAmin(Panel_23)
end

function requestMsg()

end

function callback_Button_music(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

		if GameConfig.getGameMusicOff() then
			GameConfig.setGameMusicOff(false)
			Button_music:loadTextures("MJ_outgame_btn_duikongkuag.png", "MJ_outgame_btn_duikongkuag.png","", 1)
		else
			GameConfig.setGameMusicOff(true)
			Button_music:loadTextures("MJ_outgame_btn_duigou.png", "MJ_outgame_btn_duigou.png","", 1)
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_effect(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		if GameConfig.getGameSoundOff() then
			GameConfig.setGameSoundOff(false)
			Button_effect:loadTextures("MJ_outgame_btn_duikongkuag.png", "MJ_outgame_btn_duikongkuag.png","", 1)
		else
			GameConfig.setGameSoundOff(true)
			Button_effect:loadTextures("MJ_outgame_btn_duigou.png", "MJ_outgame_btn_duigou.png","", 1)
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_login(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		LoginConfig.setChangeAccount(true)
		mvcEngine.createModule(GUI_LOGIN)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		GamePub.closeDialogAmin(Panel_23, closePanel)
	elseif component == CANCEL_UP then
	--取消

	end
end





function closePanel()
	mvcEngine.destroyModule(GUI_SETTING)
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("outgame_set.plist"))
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
