module("InviteCodeLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
Button_open = nil;--
Button_close = nil;--


local oldStrFmt = "";
local FinishCallBack = {};
local ChangeCallBack = {};

InviteCodeEdit = nil


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
	local gui = GUI_INVITECODE;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("outgame_invite.plist"))
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("InviteCode.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("InviteCode.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Button_open = cocostudio.getUIButton(view, "Button_open");
	Button_close = cocostudio.getUIButton(view, "Button_close");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)

	initView();
	createInviteCodeEditor()

	showDialogAmin(Panel_1)
end

function requestMsg()

end

--[[--
--显示对话框动画
--]]
function showDialogAmin(m_view, isCentre, callBack)
	if m_view == nil then
		return
	end

	m_view:setScale(0.2)
	if not(isCentre ~= nil and isCentre) then
		m_view:setAnchorPoint(ccp(0.5, 0.5))
		m_view:setPosition(ccp(m_view:getPosition().x + m_view:getSize().width / 2,m_view:getPosition().y + m_view:getSize().height / 2))
	end
	local action = CCScaleTo:create(0.3, 1);
	local array = CCArray:create()
	array:addObject(CCEaseBackOut:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	m_view:runAction(CCSequence:create(array))
end

--[[--
--隐藏对话框动画
--]]
function closeDialogAmin(m_view, callBack)
	-- local action1 = CCScaleTo:create(0.1, 1.2);
	local action = CCScaleTo:create(0.3, 0.2);
	local array = CCArray:create()
	-- array:addObject(CCEaseBackIn:create(action1))
	array:addObject(CCEaseBackIn:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	if m_view ~= nil then
		m_view:runAction(CCSequence:create(array))
	end
end

--[[--
--设置输入完毕后的回调方法(无回调方法则传nil)
--]]
function setEditBoxFinishCallBack(pSender, callback)
	if pSender == nil or callback == nil then
		return;
	end
	FinishCallBack[pSender] = callback;
end

function setEditBoxChangeCallBack(pSender, callback)
	if pSender == nil or callback == nil then
		return;
	end
	ChangeCallBack[pSender] = callback;
end

--[[--
--监听EditBox输入
--]]
function editBoxTextEventHandle(strEventName, pSender)
	--local edit = tolua.cast(pSender,"CCEditBox")
	local strFmt = pSender:getText();
	if strEventName == "began" then
--		if Image_edit_box ~= nil then
--			Image_edit_box:setVisible(false)
--		end
		oldStrFmt = strFmt;
	elseif strEventName == "ended" then
		if strFmt == "" or strFmt == nil then
--			if Image_edit_box ~= nil then
--				Image_edit_box:setVisible(true)
--			end
		end
	elseif strEventName == "changed" then
		if Common.logicEmoji(strFmt) then
			--有表情符
			pSender:setText(oldStrFmt);
			Common.log("initChatInputBox changed 有表情符");
			if Common.platform == Common.TargetAndroid then
				Common.showToast("亲，某些特殊表情或字符无法识别，请您重新输入", 2);
			end
		else
			oldStrFmt = strFmt;
		end
		if ChangeCallBack[pSender] ~= nil then
			ChangeCallBack[pSender]();
		end
		Common.log("initChatInputBox changed"..pSender:getText());
	elseif strEventName == "return" then
		Common.log("initChatInputBox return"..strFmt);
		oldStrFmt = "";
		if FinishCallBack[pSender] ~= nil then
			FinishCallBack[pSender]();
		end
	end
end


--创建玩家名输入框
function createInviteCodeEditor()
	local editBoxSize = CCSizeMake(440, 78)

	--ip输入框
	InviteCodeEdit = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
	InviteCodeEdit:setPosition(ccp(962 , 343))
	InviteCodeEdit:setAnchorPoint(ccp(0.5, 0.5))
	InviteCodeEdit:setFont("微软雅黑", 30)
	 InviteCodeEdit:setFontColor(ccc3(0xc5, 0xa1, 0x68))
	InviteCodeEdit:setPlaceHolder("点击输入邀请码")
	InviteCodeEdit:setMaxLength(32)
	InviteCodeEdit:setReturnType(kKeyboardReturnTypeDone)
	InviteCodeEdit:setInputMode(kEditBoxInputModeAny);

	InviteCodeEdit:registerScriptEditBoxHandler(editBoxTextEventHandle)
	view:addChild(InviteCodeEdit)
end

function callback_Button_open(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		local code = InviteCodeEdit:getText()
		if code ~= "" and code ~= nil then
			sendMJ_SC_RECEIVE_REWARD(1,code)
		else
			Common.showToast("邀请码不能为空~",2)
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

function close()
	closeDialogAmin(Panel_1, closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_INVITECODE)
end

local function slot_MJ_SC_RECEIVE_REWARD()
	local MJ_SC_RECEIVE_REWARD_data = profile.MahjongRecommend.getMJReceiveRewardTable()

	-- Result	Byte	0失败1成功
	local Result = MJ_SC_RECEIVE_REWARD_data["Result"]
	if Result == 1 then

		close()
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("outgame_invite.plist"))
	oldStrFmt = "";
	FinishCallBack = {};
	ChangeCallBack = {};
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_RECEIVE_REWARD, slot_MJ_SC_RECEIVE_REWARD)
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_RECEIVE_REWARD, slot_MJ_SC_RECEIVE_REWARD)
end
