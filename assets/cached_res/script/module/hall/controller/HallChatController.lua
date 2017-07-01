module(...,package.seeall);

--Load.LuaRequire("script.module.hall.logic.HallChatLogic");

HallChatController = class("HallChatController",BaseController);
HallChatController.__index = HallChatController;

HallChatController.moduleLayer = nil;

function HallChatController:reset()
	HallChatLogic.view = nil;
end

function HallChatController:getLayer()
	return HallChatLogic.view;
end

function HallChatController:createView()
	HallChatLogic.createView();
	framework.setOnKeypadEventListener(HallChatLogic.view, HallChatLogic.onKeypad);
end

function HallChatController:requestMsg()
	HallChatLogic.requestMsg();
end

function HallChatController:addSlot()
	HallChatLogic.addSlot();
end

function HallChatController:removeSlot()
	HallChatLogic.removeSlot();
end

function HallChatController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(HallChatLogic.view,"hall_chat_dimiss_btn"), HallChatLogic.callback_hall_chat_dimiss_btn, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallChatLogic.view,"hall_chat_send_bg"), HallChatLogic.callback_hall_chat_send_bg, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(HallChatLogic.view,"Button_bugle"), HallChatLogic.callback_Button_bugle, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HallChatController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(HallChatLogic.view,"hall_chat_dimiss_btn"), HallChatLogic.callback_hall_chat_dimiss_btn, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallChatLogic.view,"hall_chat_send_bg"), HallChatLogic.callback_hall_chat_send_bg, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(HallChatLogic.view,"Button_bugle"), HallChatLogic.callback_Button_bugle, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function HallChatController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function HallChatController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function HallChatController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(HallChatLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(HallChatLogic);
		HallChatLogic.releaseData();
	end

	HallChatLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function HallChatController:sleepModule()
	HallChatLogic.setAllMenuEnabled(false)
	framework.releaseOnKeypadEventListener(HallChatLogic.view);
	HallChatLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function HallChatController:wakeModule()
	framework.setOnKeypadEventListener(HallChatLogic.view, HallChatLogic.onKeypad);
	HallChatLogic.view:setTouchEnabled(true);
	HallChatLogic.setAllMenuEnabled(true);
end
