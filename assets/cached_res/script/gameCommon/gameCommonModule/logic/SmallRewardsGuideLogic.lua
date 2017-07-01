module("SmallRewardsGuideLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
Button_close = nil;--
Panel_tabelview = nil;--


function onKeypad(event)
	if event == "backClicked" then
		mvcEngine.destroyModule(GUI_SMALLREWARDSGUIDE)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_SMALLREWARDSGUIDE;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("SmallGameRewards/SmallRewardsGuide.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("SmallGameRewards/SmallRewardsGuide.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_tabelview = cocostudio.getUIPanel(view, "Panel_tabelview");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
end

function setWebViewUrl(url)
	--url
	Panel_tabelview:setVisible(true);
	local x = Panel_tabelview:getPosition().x;
	local y = Panel_tabelview:getPosition().y;
	local w = Panel_tabelview:getSize().width;
	local h = Panel_tabelview:getSize().height;
	CommDialogConfig.commonLoadWebView(url, "URL_TABLE_SMALLREWARDS_HEIP", x, y, w, h)
end


function requestMsg()

end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.hideWebView()
		mvcEngine.destroyModule(GUI_SMALLREWARDSGUIDE)
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
