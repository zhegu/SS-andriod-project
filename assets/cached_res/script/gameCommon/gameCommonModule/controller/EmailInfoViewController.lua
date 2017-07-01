module(...,package.seeall);

--Load.LuaRequire("script.module.gameCommonModule.logic.EmailInfoViewLogic");

EmailInfoViewController = class("EmailInfoViewController",BaseController);
EmailInfoViewController.__index = EmailInfoViewController;

EmailInfoViewController.moduleLayer = nil;

function EmailInfoViewController:reset()
	EmailInfoViewLogic.view = nil;
end

function EmailInfoViewController:getLayer()
	return EmailInfoViewLogic.view;
end

function EmailInfoViewController:createView()
	EmailInfoViewLogic.createView();
	framework.setOnKeypadEventListener(EmailInfoViewLogic.view, EmailInfoViewLogic.onKeypad);
end

function EmailInfoViewController:requestMsg()
	EmailInfoViewLogic.requestMsg();
end

function EmailInfoViewController:addSlot()
	EmailInfoViewLogic.addSlot();
end

function EmailInfoViewController:removeSlot()
	EmailInfoViewLogic.removeSlot();
end

function EmailInfoViewController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(EmailInfoViewLogic.view,"Button_close"), EmailInfoViewLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(EmailInfoViewLogic.view,"Button_send"), EmailInfoViewLogic.callback_Button_send, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function EmailInfoViewController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(EmailInfoViewLogic.view,"Button_close"), EmailInfoViewLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(EmailInfoViewLogic.view,"Button_send"), EmailInfoViewLogic.callback_Button_send, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function EmailInfoViewController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function EmailInfoViewController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function EmailInfoViewController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(EmailInfoViewLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(EmailInfoViewLogic);
		EmailInfoViewLogic.releaseData();
	end

	EmailInfoViewLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function EmailInfoViewController:sleepModule()
	framework.releaseOnKeypadEventListener(EmailInfoViewLogic.view);
	EmailInfoViewLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function EmailInfoViewController:wakeModule()
	framework.setOnKeypadEventListener(EmailInfoViewLogic.view, EmailInfoViewLogic.onKeypad);
	EmailInfoViewLogic.view:setTouchEnabled(true);
end
