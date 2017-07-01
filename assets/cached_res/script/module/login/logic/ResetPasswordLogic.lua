module("ResetPasswordLogic",package.seeall)

view = nil
Panel_20 = nil;--
Panel_25 = nil;--
panel = nil;--
btn_commit = nil
btn_cancel = nil
username = nil
phonenum = nil
Label_phonenum = nil;--
Label_username = nil;--
ImageView_nickBg = nil;--
btn_more = nil;--
Image_more = nil;--
Image_moreup = nil;--
local imei = nil

edit_usernick = nil;
edit_phonenum = nil;

function onKeypad(event)
	if event == "backClicked" then
		mvcEngine.destroyModule(GUI_RESETPASSWORD)
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("ResetPassword.json")
	local gui = GUI_RESETPASSWORD
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())

	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_25 = cocostudio.getUIPanel(view, "Panel_25");
	panel = cocostudio.getUIPanel(view, "Panel");
	btn_commit = cocostudio.getUIButton(view, "btn_commit")
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel")
	GamePub.showDialogAmin(Panel_25)
	GameStartConfig.addChildForScene(view)

	--iemi
	imei = Common.getDeviceInfo()
	initView()
	openLoginButton()
end

function initView()
	--username = cocostudio.getUITextField(view, "txt_username")
	--phonenum = cocostudio.getUITextField(view, "txt_phonenum")
	--Label_phonenum = cocostudio.getUILabel(view, "Label_phonenum");
	--Label_username = cocostudio.getUILabel(view, "Label_username");
	ImageView_nickBg = cocostudio.getUIImageView(view, "ImageView_nickBg");
	btn_more = cocostudio.getUIButton(view, "btn_more");
	Image_more = cocostudio.getUIImageView(view, "Image_more");
	Image_moreup = cocostudio.getUIImageView(view, "Image_moreup");
	--username:setText("")
	--phonenum:setText("")
	--username:setVisible(false);
	--phonenum:setVisible(false);

	--弃用
	--phonenum:setTouchEnabled(false)
	--username:setTouchEnabled(false)

	--Label_phonenum:setVisible(false)
	--Label_username:setVisible(false)

	--新的输入框
	createUsernameEditor();
end

function createUsernameEditor()
 	--昵称输入框
 	local editBoxSize = CCSizeMake(250, 49)
    edit_usernick = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
    edit_usernick:setPosition(ccp(485, 372))
    edit_usernick:setAnchorPoint(ccp(0,0))
    edit_usernick:setFont("微软雅黑", 30)
    edit_usernick:setFontColor(ccc3(0xae, 0x91, 0x72))
    edit_usernick:setPlaceHolder("输入昵称")
    edit_usernick:setMaxLength(32)
    edit_usernick:setReturnType(kKeyboardReturnTypeDone)
    edit_usernick:setInputMode(kEditBoxInputModeSingleLine);

	edit_usernick:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
    view:addChild(edit_usernick, 2)

    --手机输入框
    edit_phonenum = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
    edit_phonenum:setPosition(ccp(0, -94))
    edit_phonenum:setAnchorPoint(ccp(0, 0))
    edit_phonenum:setFont("微软雅黑", 30)
    edit_phonenum:setFontColor(ccc3(0xae, 0x91, 0x72))
    edit_phonenum:setPlaceHolder("")
    edit_phonenum:setMaxLength(32)
    edit_phonenum:setReturnType(kKeyboardReturnTypeDone)
    edit_phonenum:setInputMode(kEditBoxInputModePhoneNumber);

	edit_phonenum:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
    edit_usernick:addChild(edit_phonenum)
end

--屏蔽输入框
function setEditorEnable(isTouch)
	edit_usernick:setTouchEnabled(isTouch)
	edit_phonenum:setTouchEnabled(isTouch)
end

function requestMsg()

end

function callback_btn_more(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if profileCommon.MoreUser.getUserSize() == 0 then
			--如果没有NickName信息,不展开
			sendMANAGERID_USERLIST_FROM_IMIE();
			return;
		end
		mvcEngine.createModule(GUI_MORE)
		MoreLogic.setCurViewTag(MoreLogic.getViewTag().RESET);
		local bgPosition = ImageView_nickBg:getParent():convertToWorldSpace(ImageView_nickBg:getPosition())
		MoreLogic.setPanelPosition(bgPosition.x, bgPosition.y -ImageView_nickBg:getContentSize().height / 2 )
		--		Image_more:setRotation(180);
		closeLoginButton()
		MoreLogic.setRotationInfo(Image_more,Image_moreup);
	elseif component == CANCEL_UP then
	--取消
	end
end

function closeLoginButton()
	Image_more:setVisible(false)
	Image_moreup:setVisible(true)
end

function openLoginButton()
	Image_more:setVisible(true)
	Image_moreup:setVisible(false)
end

function callback_btn_commit(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local usernamevalue =  edit_usernick:getText();
		local phonenumvalue = edit_phonenum:getText();
		local dataTable = {}
		dataTable["username"] = usernamevalue
		dataTable["phonenum"] = phonenumvalue
		dataTable["imei"] = imei
		sendDBID_FIND_PASSWORD(dataTable)
	elseif component == CANCEL_UP then
	--取消
	end
end

function setUsername(usernamevalue)
	--username:setText(usernamevalue)
	--Label_username:setText(usernamevalue)
	--新
	if edit_usernick ~= nil then
		edit_usernick:setText(usernamevalue)
	end
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		GamePub.closeDialogAmin(Panel_25,close)
	elseif component == CANCEL_UP then
	--取消
	end

end

function close()
	mvcEngine.destroyModule(GUI_RESETPASSWORD)
end

function slot_MoreUser()
	--username:setText(profileCommon.MoreUser.getLoginWithMore())
end
function slot_RetPass()
	local result = profileCommon.ResetPass.getResult()
	local resultTxt = profileCommon.ResetPass.getResultText()
	Common.showToast(resultTxt, 2)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME, slot_MoreUser)--点击more之后username要改
	framework.addSlot2Signal(DBID_FIND_PASSWORD, slot_RetPass)--点击more之后username要改
end

function removeSlot()
	framework.removeSlotFromSignal(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME, slot_MoreUser)
	framework.removeSlotFromSignal(DBID_FIND_PASSWORD, slot_RetPass)
end
