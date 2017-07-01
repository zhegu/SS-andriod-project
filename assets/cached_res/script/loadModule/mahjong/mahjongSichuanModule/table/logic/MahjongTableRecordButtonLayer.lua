module("MahjongTableRecordButtonLayer", package.seeall)

local TableRecordButtonLayer = nil --

MahjongTableRecordButtonPanel = nil; --
Panel_Record = nil; --
Image_Record = nil; --
Button_exitRecord = nil; --
Button_shareRecord = nil; --
Button_lastRecord = nil; --
Button_pauseRecord = nil; --
Button_playRecord = nil; --
Button_nextRecord = nil; --
Button_menuRecord = nil; --

--[[--
--初始化控件
--]]
local function initTableRecordButtonLayer()
	MahjongTableRecordButtonPanel = cocostudio.getUIPanel(TableRecordButtonLayer, "MahjongTableRecordButtonPanel");
	Panel_Record = cocostudio.getUIPanel(TableRecordButtonLayer, "Panel_Record");
	Image_Record = cocostudio.getUIImageView(TableRecordButtonLayer, "Image_Record");
	Button_exitRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_exitRecord");
	Button_shareRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_shareRecord");
	Button_lastRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_lastRecord");
	Button_pauseRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_pauseRecord");
	Button_playRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_playRecord");
	Button_nextRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_nextRecord");
	Button_menuRecord = cocostudio.getUIButton(TableRecordButtonLayer, "Button_menuRecord");

	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_exitRecord"), callback_Button_exitRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_shareRecord"), callback_Button_shareRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_lastRecord"), callback_Button_lastRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_pauseRecord"), callback_Button_pauseRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_playRecord"), callback_Button_playRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_nextRecord"), callback_Button_nextRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_menuRecord"), callback_Button_menuRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

--[[--
--创建层
--]]
local function creatTableRecordButtonLayer()
	TableRecordButtonLayer = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongTableRecordButton.json"));
	TableRecordButtonLayer:setZOrder(20);
	initTableRecordButtonLayer();

	setRecordPauseOrResume();
end

--[[--
--获取层
--]]
function showTableRecordButtonLayer()
	if TableRecordButtonLayer == nil then
		creatTableRecordButtonLayer()
		GameStartConfig.addChildForScene(TableRecordButtonLayer);
	end
end

--[[--
--设置录像按钮
--]]
function setPanelRecordVisible(visible)
	Panel_Record:setVisible(visible);
	Common.setButtonVisible(Button_exitRecord, visible);
	Common.setButtonVisible(Button_shareRecord, visible);
	Common.setButtonVisible(Button_lastRecord, visible);
	Common.setButtonVisible(Button_playRecord, visible);
	Common.setButtonVisible(Button_pauseRecord, visible);
	Common.setButtonVisible(Button_nextRecord, visible);
	Common.setButtonVisible(Button_menuRecord, visible);
end

--[[--
--设置录像按钮状态
--]]
function setRecordState()
	if Image_Record:isVisible() then
		Button_menuRecord:setScale(-1);
		Image_Record:setVisible(false);
		Common.setButtonVisible(Button_exitRecord, false);
		Common.setButtonVisible(Button_shareRecord, false);
		Common.setButtonVisible(Button_lastRecord, false);
		Common.setButtonVisible(Button_playRecord, false);
		Common.setButtonVisible(Button_pauseRecord, false);
		Common.setButtonVisible(Button_nextRecord, false);
	else
		Button_menuRecord:setScale(1);
		Image_Record:setVisible(true);
		Common.setButtonVisible(Button_exitRecord, true);
		Common.setButtonVisible(Button_shareRecord, true);
		Common.setButtonVisible(Button_lastRecord, true);
		Common.setButtonVisible(Button_nextRecord, true);
		setRecordPauseOrResume();
	end
end

function setRecordPauseOrResume()
	if ShowTableRecord.getRecordIsPause() then
		--当前是暂停,显示播放按钮
		Common.setButtonVisible(Button_playRecord, true);
		Common.setButtonVisible(Button_pauseRecord, false);
	else

		Common.setButtonVisible(Button_playRecord, false);
		Common.setButtonVisible(Button_pauseRecord, true);
	end
end

function callback_Button_exitRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		ShowTableRecord.stopTableRecord();
		MahjongTableLogic.gameExit();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_shareRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local urlFront = profile.MahjongRecommend.getShareToWxUrl()
		local url = urlFront .. "&videoID=" .. RecordConfig.getRecordFileName();
		GamePub.shareToWX(0, "麻友局", "邀请您查看录像", url)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_lastRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		ShowTableRecord.showLastAction();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_playRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		ShowTableRecord.setRecordResume();
		setRecordPauseOrResume();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_pauseRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		ShowTableRecord.setRecordPause();
		setRecordPauseOrResume();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_nextRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		ShowTableRecord.showNextAction();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_menuRecord(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setRecordState();
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
--删除层
--]]
function reomveTableRecordButtonLayer()

	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_exitRecord"), callback_Button_exitRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_shareRecord"), callback_Button_shareRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_lastRecord"), callback_Button_lastRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_pauseRecord"), callback_Button_pauseRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_playRecord"), callback_Button_playRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_nextRecord"), callback_Button_nextRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordButtonLayer, "Button_menuRecord"), callback_Button_menuRecord, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if TableRecordButtonLayer ~= nil then
		TableRecordButtonLayer:removeFromParentAndCleanup(true);
		TableRecordButtonLayer = nil
	end
end
