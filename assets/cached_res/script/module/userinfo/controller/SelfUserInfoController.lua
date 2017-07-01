module(...,package.seeall);

--Load.LuaRequire("script.module.userinfo.logic.SelfUserInfoLogic");

SelfUserInfoController = class("SelfUserInfoController",BaseController);
SelfUserInfoController.__index = SelfUserInfoController;

SelfUserInfoController.moduleLayer = nil;

function SelfUserInfoController:reset()
	SelfUserInfoLogic.view = nil;
end

function SelfUserInfoController:getLayer()
	return SelfUserInfoLogic.view;
end

function SelfUserInfoController:createView()
	SelfUserInfoLogic.createView();
	framework.setOnKeypadEventListener(SelfUserInfoLogic.view, SelfUserInfoLogic.onKeypad);
end

function SelfUserInfoController:requestMsg()
	SelfUserInfoLogic.requestMsg();
end

function SelfUserInfoController:addSlot()
	SelfUserInfoLogic.addSlot();
end

function SelfUserInfoController:removeSlot()
	SelfUserInfoLogic.removeSlot();
end

function SelfUserInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(SelfUserInfoLogic.view,"Button_close"), SelfUserInfoLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SelfUserInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(SelfUserInfoLogic.view,"Button_close"), SelfUserInfoLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function SelfUserInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function SelfUserInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function SelfUserInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(SelfUserInfoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(SelfUserInfoLogic);
		SelfUserInfoLogic.releaseData();
	end

	SelfUserInfoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function SelfUserInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(SelfUserInfoLogic.view);
	SelfUserInfoLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function SelfUserInfoController:wakeModule()
	framework.setOnKeypadEventListener(SelfUserInfoLogic.view, SelfUserInfoLogic.onKeypad);
	SelfUserInfoLogic.view:setTouchEnabled(true);
end
