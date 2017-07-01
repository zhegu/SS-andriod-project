module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongChatPopLogic");

MahjongChatPopController = class("MahjongChatPopController",BaseController);
MahjongChatPopController.__index = MahjongChatPopController;

MahjongChatPopController.moduleLayer = nil;

function MahjongChatPopController:reset()
	MahjongChatPopLogic.view = nil;
end

function MahjongChatPopController:getLayer()
	return MahjongChatPopLogic.view;
end

function MahjongChatPopController:createView()
	MahjongChatPopLogic.createView();
	framework.setOnKeypadEventListener(MahjongChatPopLogic.view, MahjongChatPopLogic.onKeypad);
end

function MahjongChatPopController:requestMsg()
	MahjongChatPopLogic.requestMsg();
end

function MahjongChatPopController:addSlot()
	MahjongChatPopLogic.addSlot();
end

function MahjongChatPopController:removeSlot()
	MahjongChatPopLogic.removeSlot();
end

function MahjongChatPopController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MahjongChatPopLogic.view,"btn_sendmsg_log"), MahjongChatPopLogic.callback_btn_sendmsg_log, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongChatPopLogic.view,"btn_close"), MahjongChatPopLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongChatPopController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MahjongChatPopLogic.view,"btn_sendmsg_log"), MahjongChatPopLogic.callback_btn_sendmsg_log, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongChatPopLogic.view,"btn_close"), MahjongChatPopLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongChatPopController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongChatPopController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongChatPopController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongChatPopLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongChatPopLogic);
		MahjongChatPopLogic.releaseData();
	end

	MahjongChatPopLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongChatPopController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongChatPopLogic.view);
	MahjongChatPopLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongChatPopController:wakeModule()
	framework.setOnKeypadEventListener(MahjongChatPopLogic.view, MahjongChatPopLogic.onKeypad);
	MahjongChatPopLogic.view:setTouchEnabled(true);
end
