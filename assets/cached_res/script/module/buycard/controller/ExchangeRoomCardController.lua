module(...,package.seeall);

--Load.LuaRequire("script.module.buycard.logic.ExchangeRoomCardLogic");

ExchangeRoomCardController = class("ExchangeRoomCardController",BaseController);
ExchangeRoomCardController.__index = ExchangeRoomCardController;

ExchangeRoomCardController.moduleLayer = nil;

function ExchangeRoomCardController:reset()
	ExchangeRoomCardLogic.view = nil;
end

function ExchangeRoomCardController:getLayer()
	return ExchangeRoomCardLogic.view;
end

function ExchangeRoomCardController:createView()
	ExchangeRoomCardLogic.createView();
	framework.setOnKeypadEventListener(ExchangeRoomCardLogic.view, ExchangeRoomCardLogic.onKeypad);
end

function ExchangeRoomCardController:requestMsg()
	ExchangeRoomCardLogic.requestMsg();
end

function ExchangeRoomCardController:addSlot()
	ExchangeRoomCardLogic.addSlot();
end

function ExchangeRoomCardController:removeSlot()
	ExchangeRoomCardLogic.removeSlot();
end

function ExchangeRoomCardController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(ExchangeRoomCardLogic.view,"Button_sure"), ExchangeRoomCardLogic.callback_Button_sure, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(ExchangeRoomCardLogic.view,"Button_cancel"), ExchangeRoomCardLogic.callback_Button_cancel, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(ExchangeRoomCardLogic.view,"Button_close"), ExchangeRoomCardLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function ExchangeRoomCardController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeRoomCardLogic.view,"Button_sure"), ExchangeRoomCardLogic.callback_Button_sure, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeRoomCardLogic.view,"Button_cancel"), ExchangeRoomCardLogic.callback_Button_cancel, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(ExchangeRoomCardLogic.view,"Button_close"), ExchangeRoomCardLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function ExchangeRoomCardController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function ExchangeRoomCardController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function ExchangeRoomCardController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(ExchangeRoomCardLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(ExchangeRoomCardLogic);
		ExchangeRoomCardLogic.releaseData();
	end

	ExchangeRoomCardLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function ExchangeRoomCardController:sleepModule()
	framework.releaseOnKeypadEventListener(ExchangeRoomCardLogic.view);
	ExchangeRoomCardLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function ExchangeRoomCardController:wakeModule()
	framework.setOnKeypadEventListener(ExchangeRoomCardLogic.view, ExchangeRoomCardLogic.onKeypad);
	ExchangeRoomCardLogic.view:setTouchEnabled(true);
end
