module(...,package.seeall);

--Load.LuaRequire("script.module.createroom.logic.JoinRoomLogic");

JoinRoomController = class("JoinRoomController",BaseController);
JoinRoomController.__index = JoinRoomController;

JoinRoomController.moduleLayer = nil;

function JoinRoomController:reset()
	JoinRoomLogic.view = nil;
end

function JoinRoomController:getLayer()
	return JoinRoomLogic.view;
end

function JoinRoomController:createView()
	JoinRoomLogic.createView();
	framework.setOnKeypadEventListener(JoinRoomLogic.view, JoinRoomLogic.onKeypad);
end

function JoinRoomController:requestMsg()
	JoinRoomLogic.requestMsg();
end

function JoinRoomController:addSlot()
	JoinRoomLogic.addSlot();
end

function JoinRoomController:removeSlot()
	JoinRoomLogic.removeSlot();
end

function JoinRoomController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(JoinRoomLogic.view,"Button_num_reset"), JoinRoomLogic.callback_Button_num_reset, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(JoinRoomLogic.view,"Button_num_del"), JoinRoomLogic.callback_Button_num_del, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(JoinRoomLogic.view,"Button_close"), JoinRoomLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function JoinRoomController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(JoinRoomLogic.view,"Button_num_reset"), JoinRoomLogic.callback_Button_num_reset, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(JoinRoomLogic.view,"Button_num_del"), JoinRoomLogic.callback_Button_num_del, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(JoinRoomLogic.view,"Button_close"), JoinRoomLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function JoinRoomController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function JoinRoomController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function JoinRoomController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(JoinRoomLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(JoinRoomLogic);
		JoinRoomLogic.releaseData();
	end

	JoinRoomLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function JoinRoomController:sleepModule()
	framework.releaseOnKeypadEventListener(JoinRoomLogic.view);
	JoinRoomLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function JoinRoomController:wakeModule()
	framework.setOnKeypadEventListener(JoinRoomLogic.view, JoinRoomLogic.onKeypad);
	JoinRoomLogic.view:setTouchEnabled(true);
end
