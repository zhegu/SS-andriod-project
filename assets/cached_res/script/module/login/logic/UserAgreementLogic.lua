module("UserAgreementLogic",package.seeall)

view = nil
Panel_20 = nil;--
Panel_webview = nil;--
Panel_13 = nil;--
panel = nil;--
btn_close = nil

function onKeypad(event)
	if event == "backClicked" then
		Common.hideWebView()
		mvcEngine.destroyModule(GUI_USERAGREEMENT)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("UserAgreement.json")
	local gui = GUI_USERAGREEMENT
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_webview = cocostudio.getUIPanel(view, "Panel_webview");
	Panel_13 = cocostudio.getUIPanel(view, "Panel_13");
	panel = cocostudio.getUIPanel(view, "Panel");
	btn_close = cocostudio.getUIButton(view, "btn_close");

	local x = Panel_webview:getPosition().x;
	local y = Panel_webview:getPosition().y;
	local w = Panel_webview:getSize().width;
	local h = Panel_webview:getSize().height;
	CommDialogConfig.commonLoadWebView(GameConfig.URL_TABLE_LOGIN, "URL_TABLE_LOGIN", x, y, w, h)

	GamePub.showDialogAmin(Panel_13);
end

function requestMsg()

end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.hideWebView()
		GamePub.closeDialogAmin(Panel_13,close)
	elseif component == CANCEL_UP then
	--取消
	end
end

function close()
	mvcEngine.destroyModule(GUI_USERAGREEMENT)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
end

function addSlot()
end

function removeSlot()
end
