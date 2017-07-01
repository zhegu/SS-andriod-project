module("AppstoreRatingsLogic",package.seeall)

view = nil;

Panel_20 = nil;--
panel = nil;--
Panel_18 = nil;--
lab_title = nil;--
btn_close = nil;--
btn_ok = nil;--
lab_msg = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
		GamePub.closeDialogAmin(Panel_18, close);
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_APPSTORERATINGS;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("AppstoreRatings.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("AppstoreRatings.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	panel = cocostudio.getUIPanel(view, "panel");
	Panel_18 = cocostudio.getUIPanel(view, "Panel_18");
	lab_title = cocostudio.getUILabel(view, "lab_title");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	btn_ok = cocostudio.getUIButton(view, "btn_ok");
	lab_msg = cocostudio.getUILabel(view, "lab_msg");

	local msg = ServerConfig.getAppstoreCommentGuide()
	if msg ~= nil and msg ~= "" then
		lab_msg:setText(msg)
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)

	initView();
	GamePub.showDialogAmin(Panel_18);
end

function requestMsg()

end

function callback_btn_ok(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		sendAPPSTORE_COMMENT_COIN()
		Common.openURL(ServerConfig.getAppstoreGameUrl());
		Common.setDataForSqlite(CommSqliteConfig.appStorePingJia, 1)
		GamePub.closeDialogAmin(Panel_18, close);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		GamePub.closeDialogAmin(Panel_18, close);
	elseif component == CANCEL_UP then
	--取消

	end
end

function close()
	mvcEngine.destroyModule(GUI_APPSTORERATINGS)
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
