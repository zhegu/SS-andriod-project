module(...,package.seeall);

--Load.LuaRequire("script.module.message.logic.MessageServerLogic");

MessageServerController = class("MessageServerController",BaseController);
MessageServerController.__index = MessageServerController;

MessageServerController.moduleLayer = nil;

function MessageServerController:reset()
	MessageServerLogic.view = nil;
end

function MessageServerController:getLayer()
	return MessageServerLogic.view;
end

function MessageServerController:createView()
	MessageServerLogic.createView();
	framework.setOnKeypadEventListener(MessageServerLogic.view, MessageServerLogic.onKeypad);
end

function MessageServerController:requestMsg()
	MessageServerLogic.requestMsg();
end

function MessageServerController:addSlot()
	MessageServerLogic.addSlot();
end

function MessageServerController:removeSlot()
	MessageServerLogic.removeSlot();
end

function MessageServerController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MessageServerLogic.view,"Button_close"), MessageServerLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MessageServerLogic.view,"Button_sure"), MessageServerLogic.callback_Button_sure, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MessageServerController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MessageServerLogic.view,"Button_close"), MessageServerLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MessageServerLogic.view,"Button_sure"), MessageServerLogic.callback_Button_sure, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MessageServerController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MessageServerController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MessageServerController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MessageServerLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MessageServerLogic);
		MessageServerLogic.releaseData();
	end

	MessageServerLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MessageServerController:sleepModule()
	framework.releaseOnKeypadEventListener(MessageServerLogic.view);
	MessageServerLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MessageServerController:wakeModule()
	framework.setOnKeypadEventListener(MessageServerLogic.view, MessageServerLogic.onKeypad);
	MessageServerLogic.view:setTouchEnabled(true);
end
