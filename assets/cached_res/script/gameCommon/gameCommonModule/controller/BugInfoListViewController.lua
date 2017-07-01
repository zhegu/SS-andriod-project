module(...,package.seeall);

--Load.LuaRequire("script.module.gameCommonModule.logic.BugInfoListViewLogic");

BugInfoListViewController = class("BugInfoListViewController",BaseController);
BugInfoListViewController.__index = BugInfoListViewController;

BugInfoListViewController.moduleLayer = nil;

function BugInfoListViewController:reset()
	BugInfoListViewLogic.view = nil;
end

function BugInfoListViewController:getLayer()
	return BugInfoListViewLogic.view;
end

function BugInfoListViewController:createView()
	BugInfoListViewLogic.createView();
	framework.setOnKeypadEventListener(BugInfoListViewLogic.view, BugInfoListViewLogic.onKeypad);
end

function BugInfoListViewController:requestMsg()
	BugInfoListViewLogic.requestMsg();
end

function BugInfoListViewController:addSlot()
	BugInfoListViewLogic.addSlot();
end

function BugInfoListViewController:removeSlot()
	BugInfoListViewLogic.removeSlot();
end

function BugInfoListViewController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BugInfoListViewLogic.view,"Button_close"), BugInfoListViewLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function BugInfoListViewController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BugInfoListViewLogic.view,"Button_close"), BugInfoListViewLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function BugInfoListViewController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function BugInfoListViewController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function BugInfoListViewController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BugInfoListViewLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BugInfoListViewLogic);
		BugInfoListViewLogic.releaseData();
	end

	BugInfoListViewLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function BugInfoListViewController:sleepModule()
	framework.releaseOnKeypadEventListener(BugInfoListViewLogic.view);
	BugInfoListViewLogic.view:setTouchEnabled(false);
	BugInfoListViewLogic.setAllMenuEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function BugInfoListViewController:wakeModule()
	framework.setOnKeypadEventListener(BugInfoListViewLogic.view, BugInfoListViewLogic.onKeypad);
	BugInfoListViewLogic.view:setTouchEnabled(true);
	BugInfoListViewLogic.setAllMenuEnabled(true);
end
