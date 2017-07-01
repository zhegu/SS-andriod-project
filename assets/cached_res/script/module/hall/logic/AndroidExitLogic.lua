module("AndroidExitLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_18 = nil;--
panel_bg = nil;--
btn_cancel = nil;--
Label_messagelow = nil;--
btn_exit = nil;--
ImageView_Right = nil;--
btn_continue = nil;--

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_18 = cocostudio.getUIPanel(view, "Panel_18");
	panel_bg = cocostudio.getUIPanel(view, "panel_bg");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
	Label_messagelow = cocostudio.getUILabel(view, "Label_messagelow");
	btn_exit = cocostudio.getUIButton(view, "btn_exit");
	ImageView_Right = cocostudio.getUIImageView(view, "ImageView_Right");
	btn_continue = cocostudio.getUIButton(view, "btn_continue");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("AndroidExit.json")
	local gui = GUI_ANDROID_EXIT;
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
	view:setTag(getDiffTag());
	isExitViewShow = true;
	initView();

	GamePub.showDialogAmin(Panel_18)
	GameStartConfig.addChildForScene(view)
end

function requestMsg()

end

--[[--
--销毁退出弹框
--]]
local function close()
	mvcEngine.destroyModule(GUI_ANDROID_EXIT)
end

--[[--
--关闭
--]]
function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GamePub.closeDialogAmin(Panel_18,close)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--退出游戏
--]]
function callback_btn_exit(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.AndroidExitSendOnlineTime();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_continue(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
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

