module(...,package.seeall);

--Load.LuaRequire("script.module.recommend.logic.InviteCodeLogic");

InviteCodeController = class("InviteCodeController",BaseController);
InviteCodeController.__index = InviteCodeController;

InviteCodeController.moduleLayer = nil;

function InviteCodeController:reset()
	InviteCodeLogic.view = nil;
end

function InviteCodeController:getLayer()
	return InviteCodeLogic.view;
end

function InviteCodeController:createView()
	InviteCodeLogic.createView();
	framework.setOnKeypadEventListener(InviteCodeLogic.view, InviteCodeLogic.onKeypad);
end

function InviteCodeController:requestMsg()
	InviteCodeLogic.requestMsg();
end

function InviteCodeController:addSlot()
	InviteCodeLogic.addSlot();
end

function InviteCodeController:removeSlot()
	InviteCodeLogic.removeSlot();
end

function InviteCodeController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(InviteCodeLogic.view,"Button_open"), InviteCodeLogic.callback_Button_open, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(InviteCodeLogic.view,"Button_close"), InviteCodeLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function InviteCodeController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(InviteCodeLogic.view,"Button_open"), InviteCodeLogic.callback_Button_open, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(InviteCodeLogic.view,"Button_close"), InviteCodeLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function InviteCodeController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function InviteCodeController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function InviteCodeController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(InviteCodeLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(InviteCodeLogic);
		InviteCodeLogic.releaseData();
	end

	InviteCodeLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function InviteCodeController:sleepModule()
	framework.releaseOnKeypadEventListener(InviteCodeLogic.view);
	InviteCodeLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function InviteCodeController:wakeModule()
	framework.setOnKeypadEventListener(InviteCodeLogic.view, InviteCodeLogic.onKeypad);
	InviteCodeLogic.view:setTouchEnabled(true);
end
