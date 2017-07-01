module("GameHelpLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_15 = nil;--
Panel_88 = nil;--
Panel_25 = nil;--
Button_close = nil;--
Panel_Help = nil;--
Panel_27 = nil;--
Button_loudi = nil;--

local URL_MAHJONG_HELP_XUEZHAN = "http://f.99sai.com/mj/sc/help/xuezhandaodi.html"

local function close()
	Common.hideWebView()
	mvcEngine.destroyModule(GUI_GAMEHELP);
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
	local gui = GUI_GAMEHELP;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("GameHelp.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("GameHelp.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_15 = cocostudio.getUIPanel(view, "Panel_15");
	Panel_88 = cocostudio.getUIPanel(view, "Panel_88");
	Panel_25 = cocostudio.getUIPanel(view, "Panel_25");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_Help = cocostudio.getUIPanel(view, "Panel_Help");
	Panel_27 = cocostudio.getUIPanel(view, "Panel_27");
	Button_loudi = cocostudio.getUIButton(view, "Button_loudi");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();

	initData(1)
end

function requestMsg()

end

function initData(tag)
	local x = Panel_Help:getPosition().x
	local y = Panel_Help:getPosition().y
	local w = Panel_Help:getSize().width
	local h = Panel_Help:getSize().height
	Common.hideWebView()

	if tag == 1 then
		Common.showWebView(URL_MAHJONG_HELP_XUEZHAN, "URL_MAHJONG_HELP_XUEZHAN", x, y, w, h)
--	else
--		Common.showWebView(GameConfig.URL_ZIPAI_HELP, "URL_ZIPAI_HELP", x, y, w, h)
	end
	showBtnStateByTag(tag)
end

function showBtnStateByTag(tag)
--	if tag == 1 then
--		Button_loudi:loadTextures("zp_button_4.png","zp_button_4.png","",1)
--		Button_dazipai:loadTextures("zp_button_1.png","zp_button_1.png","",1)
--	else
--		Button_loudi:loadTextures("zp_button_1.png","zp_button_1.png","",1)
--		Button_dazipai:loadTextures("zp_button_4.png","zp_button_4.png","",1)
--	end
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

function callback_Button_loudi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
--		initData(1)
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	Common.hideWebView()
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
end
