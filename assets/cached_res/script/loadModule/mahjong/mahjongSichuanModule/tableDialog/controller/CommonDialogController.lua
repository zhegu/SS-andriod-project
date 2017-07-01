module(...,package.seeall);

--Load.LuaRequire("script.module.commondialog.logic.CommonDialogLogic");

CommonDialogController = class("CommonDialogController",BaseController);
CommonDialogController.__index = CommonDialogController;

CommonDialogController.moduleLayer = nil;

function CommonDialogController:reset()
	CommonDialogLogic.view = nil;
end

function CommonDialogController:getLayer()
	return CommonDialogLogic.view;
end

function CommonDialogController:createView()
	CommonDialogLogic.createView();
	framework.setOnKeypadEventListener(CommonDialogLogic.view, CommonDialogLogic.onKeypad);
end

function CommonDialogController:requestMsg()
	CommonDialogLogic.requestMsg();
end

function CommonDialogController:addSlot()
	CommonDialogLogic.addSlot();
end

function CommonDialogController:removeSlot()
	CommonDialogLogic.removeSlot();
end

function CommonDialogController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CommonDialogLogic.view,"btn_done"), CommonDialogLogic.callback_btn_done, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CommonDialogLogic.view,"btn_cancel"), CommonDialogLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CommonDialogController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CommonDialogLogic.view,"btn_done"), CommonDialogLogic.callback_btn_done, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CommonDialogLogic.view,"btn_cancel"), CommonDialogLogic.callback_btn_cancel, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function CommonDialogController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CommonDialogController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CommonDialogController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CommonDialogLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CommonDialogLogic);
		CommonDialogLogic.releaseData();
	end

	CommonDialogLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CommonDialogController:sleepModule()
	framework.releaseOnKeypadEventListener(CommonDialogLogic.view);
	CommonDialogLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CommonDialogController:wakeModule()
	framework.setOnKeypadEventListener(CommonDialogLogic.view, CommonDialogLogic.onKeypad);
	CommonDialogLogic.view:setTouchEnabled(true);
end
