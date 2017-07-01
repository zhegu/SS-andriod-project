module("MahjongTableSettingLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_23 = nil;--
Button_music = nil;--
Button_effect = nil;--
Button_close = nil;--
Button_jiesan = nil;--

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGTABLESETTING)
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_MAHJONGTABLESETTING;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_setting.plist"));
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongTableSetting.json"));
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_23 = cocostudio.getUIPanel(view, "Panel_23");
	Button_music = cocostudio.getUIButton(view, "Button_music");
	Button_effect = cocostudio.getUIButton(view, "Button_effect");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Button_jiesan = cocostudio.getUIButton(view, "Button_jiesan");

	if GameConfig.getGameMusicOff() then
		Button_music:loadTextures("MJ_ingame_btn_duigou.png", "MJ_ingame_btn_duigou.png","", 1)
	else
		Button_music:loadTextures("MJ_ingame_btn_duikongkuag.png", "MJ_ingame_btn_duikongkuag.png","", 1)
	end

	if GameConfig.getGameSoundOff() then
		Button_effect:loadTextures("MJ_ingame_btn_duigou.png", "MJ_ingame_btn_duigou.png","", 1)
	else
		Button_effect:loadTextures("MJ_ingame_btn_duikongkuag.png", "MJ_ingame_btn_duikongkuag.png","", 1)
	end

	if MahjongTableButtonLayer.getPanelRoomIsShow() then
		Common.setButtonVisible(Button_jiesan, false);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
end

function requestMsg()

end

function setShenqingBtnState(flag)
--	Button_shenqing:setVisible(true)
--	if flag then
--		Image_jiesan:loadTexture("zp_txt_button_jiesan.png",1)
--	else
--		Image_jiesan:loadTexture("zp_txt_shenqingjiesan.png",1)
--	end
end

function callback_Button_music(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if GameConfig.getGameMusicOff() then
			GameConfig.setGameMusicOff(false)
			Button_music:loadTextures("MJ_ingame_btn_duikongkuag.png", "MJ_ingame_btn_duikongkuag.png","", 1)
		else
			GameConfig.setGameMusicOff(true)
			Button_music:loadTextures("MJ_ingame_btn_duigou.png", "MJ_ingame_btn_duigou.png","", 1)
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
			Button_effect:loadTextures("MJ_ingame_btn_duikongkuag.png", "MJ_ingame_btn_duikongkuag.png","", 1)
		else
			GameConfig.setGameSoundOff(true)
			Button_effect:loadTextures("MJ_ingame_btn_duigou.png", "MJ_ingame_btn_duigou.png","", 1)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_jiesan(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		sendMJ_SC_GAME_DISMISS_ROOM()
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_setting.plist"));
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
