module(...,package.seeall);

--Load.LuaRequire("script.module.gameCommonModule.logic.BugInfoViewLogic");

BugInfoViewController = class("BugInfoViewController",BaseController);
BugInfoViewController.__index = BugInfoViewController;

BugInfoViewController.moduleLayer = nil;

function BugInfoViewController:reset()
	BugInfoViewLogic.view = nil;
end

function BugInfoViewController:getLayer()
	return BugInfoViewLogic.view;
end

function BugInfoViewController:createView()
	BugInfoViewLogic.createView();
	framework.setOnKeypadEventListener(BugInfoViewLogic.view, BugInfoViewLogic.onKeypad);
end

function BugInfoViewController:requestMsg()
	BugInfoViewLogic.requestMsg();
end

function BugInfoViewController:addSlot()
	BugInfoViewLogic.addSlot();
end

function BugInfoViewController:removeSlot()
	BugInfoViewLogic.removeSlot();
end

function BugInfoViewController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BugInfoViewLogic.view,"Button_close"), BugInfoViewLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(BugInfoViewLogic.view,"Button_send"), BugInfoViewLogic.callback_Button_send, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function BugInfoViewController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BugInfoViewLogic.view,"Button_close"), BugInfoViewLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(BugInfoViewLogic.view,"Button_send"), BugInfoViewLogic.callback_Button_send, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function BugInfoViewController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function BugInfoViewController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function BugInfoViewController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BugInfoViewLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BugInfoViewLogic);
		BugInfoViewLogic.releaseData();
	end

	BugInfoViewLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function BugInfoViewController:sleepModule()
	framework.releaseOnKeypadEventListener(BugInfoViewLogic.view);
	Common.didHideWebview()
	BugInfoViewLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function BugInfoViewController:wakeModule()
	framework.setOnKeypadEventListener(BugInfoViewLogic.view, BugInfoViewLogic.onKeypad);
	Common.didShowWebview()
	BugInfoViewLogic.view:setTouchEnabled(true);
end
