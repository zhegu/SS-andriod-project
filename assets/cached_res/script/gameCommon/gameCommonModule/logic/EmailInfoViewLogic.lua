module("EmailInfoViewLogic",package.seeall)

view = nil;

PanelEmailInfoView = nil;--
Button_close = nil;--
Label_BugTitle = nil;--
Image_Name = nil;--
Image_LogInfo = nil;--
Button_send = nil;--

edit_username = nil;--输入框
edit_LogInfo = nil;

mLogPath = nil;
mLogName = nil;
mEmail = nil;
mIsBug = nil;

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_EMAILINFOVIEW;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/EmailInfoView.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/EmailInfoView.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	PanelEmailInfoView = cocostudio.getUIPanel(view, "PanelEmailInfoView");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Label_BugTitle = cocostudio.getUILabel(view, "Label_BugTitle");
	Image_Name = cocostudio.getUIImageView(view, "Image_Name");
	Image_LogInfo = cocostudio.getUIImageView(view, "Image_LogInfo");
	Button_send = cocostudio.getUIButton(view, "Button_send");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
	createEmailInfoEditor();
end

function requestMsg()

end

function setEmailInfo(LogPath, logName, email, isBug)
	mLogPath = LogPath;
	mLogName = logName;
	mEmail = email;
	mIsBug = isBug;
end

--创建输入框
function createEmailInfoEditor()
	local editBoxSize = CCSizeMake(331, 51)
	--名字输入框
	edit_username = CCEditBox:create(editBoxSize, CCScale9Sprite:create(loadGameConfig.getGameCommonPath("BugInfo/ui_opacity_1-1.png")))
	edit_username:setPosition(ccp(568, 498))
	edit_username:setAnchorPoint(ccp(0.5, 0.5))

	edit_username:setFont("微软雅黑", 22)
	edit_username:setFontColor(ccc3(0xB3, 0x9C, 0x77))
	edit_username:setPlaceHolder("请输入您的姓名:")
	edit_username:setMaxLength(32)
	edit_username:setReturnType(kKeyboardReturnTypeDone)
	edit_username:setInputMode(kEditBoxInputModeSingleLine);

	edit_username:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	EditBoxListener.setEditBoxFinishCallBack(edit_username, changeUserName);
	view:addChild(edit_username)

	--log信息输入框
	editBoxSize = CCSizeMake(800, 320)
	edit_LogInfo = CCEditBox:create(editBoxSize, CCScale9Sprite:create(loadGameConfig.getGameCommonPath("BugInfo/ui_opacity_1-1.png")))
	edit_LogInfo:setPosition(ccp(568, 286))
	edit_LogInfo:setAnchorPoint(ccp(0.5, 0.5))
	edit_LogInfo:setFont("微软雅黑", 22)
	edit_LogInfo:setFontColor(ccc3(0xB3, 0x9C, 0x77))
	edit_LogInfo:setPlaceHolder("请结合日志信息描述一下您游戏中遇到的问题:")
	edit_LogInfo:setMaxLength(800)
	edit_LogInfo:setReturnType(kKeyboardReturnTypeDone)
	edit_LogInfo:setInputMode(kEditBoxInputModeAny);

	edit_LogInfo:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	view:addChild(edit_LogInfo)
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_EMAILINFOVIEW);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_send(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local UserName = edit_username:getText();
		local LogInfo = edit_LogInfo:getText();
		if UserName == "" or LogInfo == "" then
			Common.showToast("请补充完整邮件信息", 2);
		else
			EmailUtils.sendTXTAttachmentByEmail(mLogPath, mLogName, mEmail, mIsBug, UserName, LogInfo);
			mvcEngine.destroyModule(GUI_EMAILINFOVIEW);
		end
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
end

function removeSlot()
end
