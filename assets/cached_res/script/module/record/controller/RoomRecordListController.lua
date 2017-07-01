module(...,package.seeall);

--Load.LuaRequire("script.module.record.logic.RoomRecordListLogic");

RoomRecordListController = class("RoomRecordListController",BaseController);
RoomRecordListController.__index = RoomRecordListController;

RoomRecordListController.moduleLayer = nil;

function RoomRecordListController:reset()
	RoomRecordListLogic.view = nil;
end

function RoomRecordListController:getLayer()
	return RoomRecordListLogic.view;
end

function RoomRecordListController:createView()
	RoomRecordListLogic.createView();
	framework.setOnKeypadEventListener(RoomRecordListLogic.view, RoomRecordListLogic.onKeypad);
end

function RoomRecordListController:requestMsg()
	RoomRecordListLogic.requestMsg();
end

function RoomRecordListController:addSlot()
	RoomRecordListLogic.addSlot();
end

function RoomRecordListController:removeSlot()
	RoomRecordListLogic.removeSlot();
end

function RoomRecordListController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RoomRecordListLogic.view,"Button_close"), RoomRecordListLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RoomRecordListLogic.view,"Button_left"), RoomRecordListLogic.callback_Button_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RoomRecordListLogic.view,"Button_right"), RoomRecordListLogic.callback_Button_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RoomRecordListController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RoomRecordListLogic.view,"Button_close"), RoomRecordListLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RoomRecordListLogic.view,"Button_left"), RoomRecordListLogic.callback_Button_left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RoomRecordListLogic.view,"Button_right"), RoomRecordListLogic.callback_Button_right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RoomRecordListController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RoomRecordListController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RoomRecordListController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RoomRecordListLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RoomRecordListLogic);
		RoomRecordListLogic.releaseData();
	end

	RoomRecordListLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RoomRecordListController:sleepModule()
	framework.releaseOnKeypadEventListener(RoomRecordListLogic.view);
	RoomRecordListLogic.view:setTouchEnabled(false);
	RoomRecordListLogic.setAllMenuEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RoomRecordListController:wakeModule()
	framework.setOnKeypadEventListener(RoomRecordListLogic.view, RoomRecordListLogic.onKeypad);
	RoomRecordListLogic.view:setTouchEnabled(true);
	RoomRecordListLogic.setAllMenuEnabled(true)
end
