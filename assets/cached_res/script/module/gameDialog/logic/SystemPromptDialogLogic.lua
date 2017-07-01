module("SystemPromptDialogLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_14 = nil;--
panel = nil;--
Image_tit = nil;--
Label_text = nil;--
btn_logout = nil;--
local SystemDialogType = {};
SystemDialogType.NORMAL = 0;--普通
SystemDialogType.EXIT = 1;--强制退出
SystemDialogType.RECHARGE_FOR_MATCH = 2; -- 进比赛前金币不足，需要充值
SystemDialogType.UPDATA_SCRIPT_EXIT = 3; -- 脚本更新后退出
SystemDialogType.ACTIVITY = 4; -- 领奖后提示框
matchNeedCoin = -1; -- 比赛入场金币数量

DialogType = 0;

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
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	panel = cocostudio.getUIPanel(view, "panel");
	Image_tit = cocostudio.getUIImageView(view, "Image_tit");
	Label_text = cocostudio.getUILabel(view, "Label_text");
	btn_logout = cocostudio.getUIButton(view, "btn_logout");
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("SystemPromptDialog.json")
	local gui = GUI_SYSTEMPROMPTDIALOG
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
	GameStartConfig.addChildForScene(view)
	initView();
	Common.log("SystemPro createView")
	GamePub.showDialogAmin(Panel_14);
end

function requestMsg()

end

function getSystemDialogType()
	return SystemDialogType;
end

function setDialogData(type, title, text)
	DialogType = type;
	if text ~= nil and text ~= "" then
		Label_text:setText(text);
	end
end


local function back()
	mvcEngine.destroyModule(GUI_SYSTEMPROMPTDIALOG);
end

function callback_btn_logout(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if DialogType == SystemDialogType.NORMAL then
			GamePub.closeDialogAmin(Panel_14,back)
		elseif DialogType == SystemDialogType.EXIT then
			GamePub.closeDialogAmin(Panel_14,back);
			Common.AndroidExitSendOnlineTime();
		elseif DialogType == SystemDialogType.RECHARGE_FOR_MATCH then
			GamePub.closeDialogAmin(Panel_14,back);
			-- show充值引导
			local userCurCoin = profile.User.getSelfCoin()
			local needConCnt = matchNeedCoin - userCurCoin
			Common.log("needConCnt = "..needConCnt)
			GiftGuideConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, needConCnt, RechargeGuidePositionID.MatchListPositionI)
		elseif DialogType == SystemDialogType.UPDATA_SCRIPT_EXIT then
			GamePub.closeDialogAmin(Panel_14,back);
			if Common.platform == Common.TargetIos then
				--IOS退出游戏
				Common.AndroidExitSendOnlineTime();
			end
		elseif DialogType == SystemDialogType.ACTIVITY then
			GamePub.closeDialogAmin(Panel_14,back);
			local activityTable = profile.JinHuaActivity.getJinHuaActivityTable()
			Common.showToast(activityTable["Toast"],3)
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
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
