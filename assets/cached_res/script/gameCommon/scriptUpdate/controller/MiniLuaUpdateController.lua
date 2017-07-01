module(...,package.seeall);

--Load.LuaRequire("script.module.scriptUpdate.logic.MiniLuaUpdateLogic");

MiniLuaUpdateController = class("MiniLuaUpdateController",BaseController);
MiniLuaUpdateController.__index = MiniLuaUpdateController;

MiniLuaUpdateController.moduleLayer = nil;

function MiniLuaUpdateController:reset()
	MiniLuaUpdateLogic.view = nil;
end

function MiniLuaUpdateController:getLayer()
	return MiniLuaUpdateLogic.view;
end

function MiniLuaUpdateController:createView()
	MiniLuaUpdateLogic.createView();
	framework.setOnKeypadEventListener(MiniLuaUpdateLogic.view, MiniLuaUpdateLogic.onKeypad);
end

function MiniLuaUpdateController:requestMsg()
	MiniLuaUpdateLogic.requestMsg();
end

function MiniLuaUpdateController:addSlot()
	MiniLuaUpdateLogic.addSlot();
end

function MiniLuaUpdateController:removeSlot()
	MiniLuaUpdateLogic.removeSlot();
end

function MiniLuaUpdateController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"BackButton"), MiniLuaUpdateLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"ConfirmButton"), MiniLuaUpdateLogic.callback_ConfirmButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"UpdateNowButton"), MiniLuaUpdateLogic.callback_UpdateNowButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.bindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"UpdateLaterButton"), MiniLuaUpdateLogic.callback_UpdateLaterButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function MiniLuaUpdateController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"BackButton"), MiniLuaUpdateLogic.callback_BackButton, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"ConfirmButton"), MiniLuaUpdateLogic.callback_ConfirmButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"UpdateNowButton"), MiniLuaUpdateLogic.callback_UpdateNowButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
	framework.unbindEventCallback(cocostudio.getComponent(MiniLuaUpdateLogic.view,"UpdateLaterButton"), MiniLuaUpdateLogic.callback_UpdateLaterButton, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_IN);
end

function MiniLuaUpdateController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MiniLuaUpdateController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MiniLuaUpdateController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MiniLuaUpdateLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MiniLuaUpdateLogic);
		MiniLuaUpdateLogic.releaseData();
	end

	MiniLuaUpdateLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MiniLuaUpdateController:sleepModule()
	framework.releaseOnKeypadEventListener(MiniLuaUpdateLogic.view);
	MiniLuaUpdateLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MiniLuaUpdateController:wakeModule()
	framework.setOnKeypadEventListener(MiniLuaUpdateLogic.view, MiniLuaUpdateLogic.onKeypad);
	MiniLuaUpdateLogic.view:setTouchEnabled(true);
end
