module("ExchangeRoomCardLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_dialog = nil;--
Image_code = nil;--
Button_sure = nil;--
Button_cancel = nil;--
Button_close = nil;--

local edit_code = nil;  --新输入框

local function close()
	mvcEngine.destroyModule(GUI_EXCHANGEROOMCARD)
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
	local gui = GUI_EXCHANGEROOMCARD;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("ExchangeRoomCard.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("ExchangeRoomCard.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_dialog = cocostudio.getUIPanel(view, "Panel_dialog");
	Image_code = cocostudio.getUIImageView(view, "Image_code");
	Button_sure = cocostudio.getUIButton(view, "Button_sure");
	Button_cancel = cocostudio.getUIButton(view, "Button_cancel");
	Button_close = cocostudio.getUIButton(view, "Button_close");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	createEditor();
end

function requestMsg()

end

--创建玩家名输入框
function createEditor()
	local editBoxSize = CCSizeMake(480-40, 78)
	--名字输入框
	local pos = Image_code:getParent():convertToWorldSpace(Image_code:getPosition())
	edit_code = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
	edit_code:setPosition(ccp(pos.x,pos.y))
	edit_code:setAnchorPoint(ccp(0.5, 0.5))

	edit_code:setFont("微软雅黑", 30)
	--	edit_code:setFontColor(ccc3(0xae, 0x91, 0x72))
	edit_code:setPlaceHolder("请输入兑换码")
	edit_code:setMaxLength(32)
	edit_code:setReturnType(kKeyboardReturnTypeDone)
	edit_code:setInputMode(kEditBoxInputModeSingleLine);

	edit_code:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	EditBoxListener.setEditBoxFinishCallBack(edit_code, changeUserName);
	view:addChild(edit_code)

end

function callback_Button_sure(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local code = edit_code:getText()
		sendMJ_SC_MGR_EXCHANGE_CODE(code)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
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

--兑换房卡
local function slotMJ_SC_MGR_EXCHANGE_CODE()
	local exchangeData = profile.MahjongUserInfo.getExchangeRoomCardTable()
	local result = exchangeData["Result"]
	local Message = exchangeData["Message"]
	if result == 1 then
		close()
	end
	Common.showToast(Message, 2);
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	edit_code = nil;
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_EXCHANGE_CODE, slotMJ_SC_MGR_EXCHANGE_CODE)
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_EXCHANGE_CODE, slotMJ_SC_MGR_EXCHANGE_CODE)
end
