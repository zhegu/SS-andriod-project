module(...,package.seeall);

--Load.LuaRequire("script.module.appstoreratings.logic.AppstoreRatingsLogic");

AppstoreRatingsController = class("AppstoreRatingsController",BaseController);
AppstoreRatingsController.__index = AppstoreRatingsController;

AppstoreRatingsController.moduleLayer = nil;

function AppstoreRatingsController:reset()
	AppstoreRatingsLogic.view = nil;
end

function AppstoreRatingsController:getLayer()
	return AppstoreRatingsLogic.view;
end

function AppstoreRatingsController:createView()
	AppstoreRatingsLogic.createView();
	framework.setOnKeypadEventListener(AppstoreRatingsLogic.view, AppstoreRatingsLogic.onKeypad);
end

function AppstoreRatingsController:requestMsg()
	AppstoreRatingsLogic.requestMsg();
end

function AppstoreRatingsController:addSlot()
	AppstoreRatingsLogic.addSlot();
end

function AppstoreRatingsController:removeSlot()
	AppstoreRatingsLogic.removeSlot();
end

function AppstoreRatingsController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(AppstoreRatingsLogic.view,"btn_close"), AppstoreRatingsLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(AppstoreRatingsLogic.view,"btn_ok"), AppstoreRatingsLogic.callback_btn_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function AppstoreRatingsController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(AppstoreRatingsLogic.view,"btn_close"), AppstoreRatingsLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(AppstoreRatingsLogic.view,"btn_ok"), AppstoreRatingsLogic.callback_btn_ok, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function AppstoreRatingsController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function AppstoreRatingsController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function AppstoreRatingsController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(AppstoreRatingsLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(AppstoreRatingsLogic);
		AppstoreRatingsLogic.releaseData();
	end

	AppstoreRatingsLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function AppstoreRatingsController:sleepModule()
	framework.releaseOnKeypadEventListener(AppstoreRatingsLogic.view);
	AppstoreRatingsLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function AppstoreRatingsController:wakeModule()
	framework.setOnKeypadEventListener(AppstoreRatingsLogic.view, AppstoreRatingsLogic.onKeypad);
	AppstoreRatingsLogic.view:setTouchEnabled(true);
end
