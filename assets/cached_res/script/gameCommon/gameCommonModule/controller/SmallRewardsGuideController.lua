module(...,package.seeall);

--Load.LuaRequire("script.gameCommon.gameCommonModule.logic.SmallRewardsGuideLogic");

SmallRewardsGuideController = class("SmallRewardsGuideController",BaseController);
SmallRewardsGuideController.__index = SmallRewardsGuideController;

SmallRewardsGuideController.moduleLayer = nil;

function SmallRewardsGuideController:reset()
	SmallRewardsGuideLogic.view = nil;
end

function SmallRewardsGuideController:getLayer()
	return SmallRewardsGuideLogic.view;
end

function SmallRewardsGuideController:createView()
	SmallRewardsGuideLogic.createView();
	framework.setOnKeypadEventListener(SmallRewardsGuideLogic.view, SmallRewardsGuideLogic.onKeypad);
end

function SmallRewardsGuideController:requestMsg()
	SmallRewardsGuideLogic.requestMsg();
end

function SmallRewardsGuideController:addSlot()
	SmallRewardsGuideLogic.addSlot();
end

function SmallRewardsGuideController:removeSlot()
	SmallRewardsGuideLogic.removeSlot();
end

function SmallRewardsGuideController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SmallRewardsGuideLogic.view,"Button_close"), SmallRewardsGuideLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SmallRewardsGuideController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SmallRewardsGuideLogic.view,"Button_close"), SmallRewardsGuideLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SmallRewardsGuideController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SmallRewardsGuideController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SmallRewardsGuideController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SmallRewardsGuideLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SmallRewardsGuideLogic);
		SmallRewardsGuideLogic.releaseData();
	end

	SmallRewardsGuideLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SmallRewardsGuideController:sleepModule()
	framework.releaseOnKeypadEventListener(SmallRewardsGuideLogic.view);
	SmallRewardsGuideLogic.view:setTouchEnabled(false);
	Common.didHideWebview()
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SmallRewardsGuideController:wakeModule()
	framework.setOnKeypadEventListener(SmallRewardsGuideLogic.view, SmallRewardsGuideLogic.onKeypad);
	Common.didShowWebview()
	SmallRewardsGuideLogic.view:setTouchEnabled(true);
end
