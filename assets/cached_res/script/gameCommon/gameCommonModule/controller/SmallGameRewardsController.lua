module(...,package.seeall);

--Load.LuaRequire("script.gameCommon.gameCommonModule.logic.SmallGameRewardsLogic");

SmallGameRewardsController = class("SmallGameRewardsController",BaseController);
SmallGameRewardsController.__index = SmallGameRewardsController;

SmallGameRewardsController.moduleLayer = nil;

function SmallGameRewardsController:reset()
	SmallGameRewardsLogic.view = nil;
end

function SmallGameRewardsController:getLayer()
	return SmallGameRewardsLogic.view;
end

function SmallGameRewardsController:createView()
	SmallGameRewardsLogic.createView();
	framework.setOnKeypadEventListener(SmallGameRewardsLogic.view, SmallGameRewardsLogic.onKeypad);
end

function SmallGameRewardsController:requestMsg()
	SmallGameRewardsLogic.requestMsg();
end

function SmallGameRewardsController:addSlot()
	SmallGameRewardsLogic.addSlot();
end

function SmallGameRewardsController:removeSlot()
	SmallGameRewardsLogic.removeSlot();
end

function SmallGameRewardsController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Button_close"), SmallGameRewardsLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Image_jinri"), SmallGameRewardsLogic.callback_Image_jinri, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Image_zuori"), SmallGameRewardsLogic.callback_Image_zuori, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Button_help"), SmallGameRewardsLogic.callback_Button_help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SmallGameRewardsController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Button_close"), SmallGameRewardsLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Image_jinri"), SmallGameRewardsLogic.callback_Image_jinri, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Image_zuori"), SmallGameRewardsLogic.callback_Image_zuori, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(SmallGameRewardsLogic.view,"Button_help"), SmallGameRewardsLogic.callback_Button_help, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SmallGameRewardsController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SmallGameRewardsController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SmallGameRewardsController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SmallGameRewardsLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SmallGameRewardsLogic);
		SmallGameRewardsLogic.releaseData();
	end

	SmallGameRewardsLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SmallGameRewardsController:sleepModule()
	framework.releaseOnKeypadEventListener(SmallGameRewardsLogic.view);
	SmallGameRewardsLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SmallGameRewardsController:wakeModule()
	framework.setOnKeypadEventListener(SmallGameRewardsLogic.view, SmallGameRewardsLogic.onKeypad);
	SmallGameRewardsLogic.view:setTouchEnabled(true);
end
