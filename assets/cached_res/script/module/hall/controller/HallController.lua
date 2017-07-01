module(...,package.seeall);

--Load.LuaRequire("script.module.hall.logic.HallLogic");

HallController = class("HallController",BaseController);
HallController.__index = HallController;

HallController.moduleLayer = nil;

function HallController:reset()
	HallLogic.view = nil;
end

function HallController:getLayer()
	return HallLogic.view;
end

function HallController:createView()
	HallLogic.createView();
	framework.setOnKeypadEventListener(HallLogic.view, HallLogic.onKeypad);
end

function HallController:requestMsg()
	HallLogic.requestMsg();
end

function HallController:addSlot()
	HallLogic.addSlot();
end

function HallController:removeSlot()
	HallLogic.removeSlot();
end

function HallController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_setting"), HallLogic.callback_Button_setting, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_help"), HallLogic.callback_Button_help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_code"), HallLogic.callback_Button_code, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Image_head_box"), HallLogic.callback_Image_head_box, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_record"), HallLogic.callback_Button_record, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_share"), HallLogic.callback_Button_share, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_service"), HallLogic.callback_Button_service, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_recommend"), HallLogic.callback_Button_recommend, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_mail"), HallLogic.callback_Button_mail, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_add_card"), HallLogic.callback_Button_add_card, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_exchangeRoomCard"), HallLogic.callback_Button_exchangeRoomCard, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_createroom"), HallLogic.callback_Button_createroom, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_joinroom"), HallLogic.callback_Button_joinroom, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HallController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_setting"), HallLogic.callback_Button_setting, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_help"), HallLogic.callback_Button_help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_code"), HallLogic.callback_Button_code, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Image_head_box"), HallLogic.callback_Image_head_box, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_record"), HallLogic.callback_Button_record, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_share"), HallLogic.callback_Button_share, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_service"), HallLogic.callback_Button_service, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_recommend"), HallLogic.callback_Button_recommend, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_mail"), HallLogic.callback_Button_mail, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_add_card"), HallLogic.callback_Button_add_card, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_exchangeRoomCard"), HallLogic.callback_Button_exchangeRoomCard, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_createroom"), HallLogic.callback_Button_createroom, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallLogic.view,"Button_joinroom"), HallLogic.callback_Button_joinroom, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HallController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function HallController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function HallController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HallLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(HallLogic);
		HallLogic.releaseData();
	end

	HallLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function HallController:sleepModule()
	framework.releaseOnKeypadEventListener(HallLogic.view);
	HallLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function HallController:wakeModule()
	framework.setOnKeypadEventListener(HallLogic.view, HallLogic.onKeypad);
	HallLogic.view:setTouchEnabled(true);
end
