module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongRoomTotalResultLogic");

MahjongRoomTotalResultController = class("MahjongRoomTotalResultController",BaseController);
MahjongRoomTotalResultController.__index = MahjongRoomTotalResultController;

MahjongRoomTotalResultController.moduleLayer = nil;

function MahjongRoomTotalResultController:reset()
	MahjongRoomTotalResultLogic.view = nil;
end

function MahjongRoomTotalResultController:getLayer()
	return MahjongRoomTotalResultLogic.view;
end

function MahjongRoomTotalResultController:createView()
	MahjongRoomTotalResultLogic.createView();
	framework.setOnKeypadEventListener(MahjongRoomTotalResultLogic.view, MahjongRoomTotalResultLogic.onKeypad);
end

function MahjongRoomTotalResultController:requestMsg()
	MahjongRoomTotalResultLogic.requestMsg();
end

function MahjongRoomTotalResultController:addSlot()
	MahjongRoomTotalResultLogic.addSlot();
end

function MahjongRoomTotalResultController:removeSlot()
	MahjongRoomTotalResultLogic.removeSlot();
end

function MahjongRoomTotalResultController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Button_share"), MahjongRoomTotalResultLogic.callback_Button_share, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Button_end"), MahjongRoomTotalResultLogic.callback_Button_end, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166"), MahjongRoomTotalResultLogic.callback_Panel_166, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166_0_00"), MahjongRoomTotalResultLogic.callback_Panel_166_0_00, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166_0_00_1"), MahjongRoomTotalResultLogic.callback_Panel_166_0_00_1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166_0_00_1_2"), MahjongRoomTotalResultLogic.callback_Panel_166_0_00_1_2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function MahjongRoomTotalResultController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Button_share"), MahjongRoomTotalResultLogic.callback_Button_share, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Button_end"), MahjongRoomTotalResultLogic.callback_Button_end, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166"), MahjongRoomTotalResultLogic.callback_Panel_166, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166_0_00"), MahjongRoomTotalResultLogic.callback_Panel_166_0_00, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166_0_00_1"), MahjongRoomTotalResultLogic.callback_Panel_166_0_00_1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRoomTotalResultLogic.view,"Panel_166_0_00_1_2"), MahjongRoomTotalResultLogic.callback_Panel_166_0_00_1_2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function MahjongRoomTotalResultController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongRoomTotalResultController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongRoomTotalResultController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongRoomTotalResultLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongRoomTotalResultLogic);
		MahjongRoomTotalResultLogic.releaseData();
	end

	MahjongRoomTotalResultLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongRoomTotalResultController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongRoomTotalResultLogic.view);
	MahjongRoomTotalResultLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongRoomTotalResultController:wakeModule()
	framework.setOnKeypadEventListener(MahjongRoomTotalResultLogic.view, MahjongRoomTotalResultLogic.onKeypad);
	MahjongRoomTotalResultLogic.view:setTouchEnabled(true);
end
