module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongRefuseDismissRoomLogic");

MahjongRefuseDismissRoomController = class("MahjongRefuseDismissRoomController",BaseController);
MahjongRefuseDismissRoomController.__index = MahjongRefuseDismissRoomController;

MahjongRefuseDismissRoomController.moduleLayer = nil;

function MahjongRefuseDismissRoomController:reset()
	MahjongRefuseDismissRoomLogic.view = nil;
end

function MahjongRefuseDismissRoomController:getLayer()
	return MahjongRefuseDismissRoomLogic.view;
end

function MahjongRefuseDismissRoomController:createView()
	MahjongRefuseDismissRoomLogic.createView();
	framework.setOnKeypadEventListener(MahjongRefuseDismissRoomLogic.view, MahjongRefuseDismissRoomLogic.onKeypad);
end

function MahjongRefuseDismissRoomController:requestMsg()
	MahjongRefuseDismissRoomLogic.requestMsg();
end

function MahjongRefuseDismissRoomController:addSlot()
	MahjongRefuseDismissRoomLogic.addSlot();
end

function MahjongRefuseDismissRoomController:removeSlot()
	MahjongRefuseDismissRoomLogic.removeSlot();
end

function MahjongRefuseDismissRoomController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MahjongRefuseDismissRoomLogic.view,"Button_done"), MahjongRefuseDismissRoomLogic.callback_Button_done, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongRefuseDismissRoomController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MahjongRefuseDismissRoomLogic.view,"Button_done"), MahjongRefuseDismissRoomLogic.callback_Button_done, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongRefuseDismissRoomController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongRefuseDismissRoomController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongRefuseDismissRoomController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongRefuseDismissRoomLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongRefuseDismissRoomLogic);
		MahjongRefuseDismissRoomLogic.releaseData();
	end

	MahjongRefuseDismissRoomLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongRefuseDismissRoomController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongRefuseDismissRoomLogic.view);
	MahjongRefuseDismissRoomLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongRefuseDismissRoomController:wakeModule()
	framework.setOnKeypadEventListener(MahjongRefuseDismissRoomLogic.view, MahjongRefuseDismissRoomLogic.onKeypad);
	MahjongRefuseDismissRoomLogic.view:setTouchEnabled(true);
end
