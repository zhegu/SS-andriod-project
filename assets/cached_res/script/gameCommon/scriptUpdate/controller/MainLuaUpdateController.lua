module(...,package.seeall);

--Load.LuaRequire("script.module.scriptUpdate.logic.MainLuaUpdateLogic");

MainLuaUpdateController = class("MainLuaUpdateController",BaseController);
MainLuaUpdateController.__index = MainLuaUpdateController;

MainLuaUpdateController.moduleLayer = nil;

function MainLuaUpdateController:reset()
	MainLuaUpdateLogic.view = nil;
end

function MainLuaUpdateController:getLayer()
	return MainLuaUpdateLogic.view;
end

function MainLuaUpdateController:createView()
	MainLuaUpdateLogic.createView();
	framework.setOnKeypadEventListener(MainLuaUpdateLogic.view, MainLuaUpdateLogic.onKeypad);
end

function MainLuaUpdateController:requestMsg()
	MainLuaUpdateLogic.requestMsg();
end

function MainLuaUpdateController:addSlot()
	MainLuaUpdateLogic.addSlot();
end

function MainLuaUpdateController:removeSlot()
	MainLuaUpdateLogic.removeSlot();
end

function MainLuaUpdateController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MainLuaUpdateLogic.view,"BackButton"), MainLuaUpdateLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MainLuaUpdateLogic.view,"ConfirmButton"), MainLuaUpdateLogic.callback_ConfirmButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function MainLuaUpdateController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MainLuaUpdateLogic.view,"BackButton"), MainLuaUpdateLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MainLuaUpdateLogic.view,"ConfirmButton"), MainLuaUpdateLogic.callback_ConfirmButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function MainLuaUpdateController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MainLuaUpdateController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MainLuaUpdateController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MainLuaUpdateLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MainLuaUpdateLogic);
		MainLuaUpdateLogic.releaseData();
	end

	MainLuaUpdateLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MainLuaUpdateController:sleepModule()
	framework.releaseOnKeypadEventListener(MainLuaUpdateLogic.view);
	MainLuaUpdateLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MainLuaUpdateController:wakeModule()
	framework.setOnKeypadEventListener(MainLuaUpdateLogic.view, MainLuaUpdateLogic.onKeypad);
	MainLuaUpdateLogic.view:setTouchEnabled(true);
end
