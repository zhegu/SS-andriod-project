module(...,package.seeall);

--Load.LuaRequire("script.module.message.logic.MessageListLogic");

MessageListController = class("MessageListController",BaseController);
MessageListController.__index = MessageListController;

MessageListController.moduleLayer = nil;

function MessageListController:reset()
	MessageListLogic.view = nil;
end

function MessageListController:getLayer()
	return MessageListLogic.view;
end

function MessageListController:createView()
	MessageListLogic.createView();
	framework.setOnKeypadEventListener(MessageListLogic.view, MessageListLogic.onKeypad);
end

function MessageListController:requestMsg()
	MessageListLogic.requestMsg();
end

function MessageListController:addSlot()
	MessageListLogic.addSlot();
end

function MessageListController:removeSlot()
	MessageListLogic.removeSlot();
end

function MessageListController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_back"), MessageListLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Button_left"), MessageListLogic.callback_Button_left, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Button_right"), MessageListLogic.callback_Button_right, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MessageListController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"btn_back"), MessageListLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Button_left"), MessageListLogic.callback_Button_left, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MessageListLogic.view,"Button_right"), MessageListLogic.callback_Button_right, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MessageListController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MessageListController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MessageListController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MessageListLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MessageListLogic);
		MessageListLogic.releaseData();
	end

	MessageListLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MessageListController:sleepModule()
	framework.releaseOnKeypadEventListener(MessageListLogic.view);
	MessageListLogic.view:setTouchEnabled(false);
	MessageListLogic.setAllMenuEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MessageListController:wakeModule()
	framework.setOnKeypadEventListener(MessageListLogic.view, MessageListLogic.onKeypad);
	MessageListLogic.view:setTouchEnabled(true);
	MessageListLogic.setAllMenuEnabled(true)
end
