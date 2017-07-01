module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongDismissRoomRequestLogic");

MahjongDismissRoomRequestController = class("MahjongDismissRoomRequestController",BaseController);
MahjongDismissRoomRequestController.__index = MahjongDismissRoomRequestController;

MahjongDismissRoomRequestController.moduleLayer = nil;

function MahjongDismissRoomRequestController:reset()
	MahjongDismissRoomRequestLogic.view = nil;
end

function MahjongDismissRoomRequestController:getLayer()
	return MahjongDismissRoomRequestLogic.view;
end

function MahjongDismissRoomRequestController:createView()
	MahjongDismissRoomRequestLogic.createView();
	framework.setOnKeypadEventListener(MahjongDismissRoomRequestLogic.view, MahjongDismissRoomRequestLogic.onKeypad);
end

function MahjongDismissRoomRequestController:requestMsg()
	MahjongDismissRoomRequestLogic.requestMsg();
end

function MahjongDismissRoomRequestController:addSlot()
	MahjongDismissRoomRequestLogic.addSlot();
end

function MahjongDismissRoomRequestController:removeSlot()
	MahjongDismissRoomRequestLogic.removeSlot();
end

function MahjongDismissRoomRequestController:addCallback()
	
end

function MahjongDismissRoomRequestController:removeCallback()
	
end

function MahjongDismissRoomRequestController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongDismissRoomRequestController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongDismissRoomRequestController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongDismissRoomRequestLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongDismissRoomRequestLogic);
		MahjongDismissRoomRequestLogic.releaseData();
	end

	MahjongDismissRoomRequestLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongDismissRoomRequestController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongDismissRoomRequestLogic.view);
	MahjongDismissRoomRequestLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongDismissRoomRequestController:wakeModule()
	framework.setOnKeypadEventListener(MahjongDismissRoomRequestLogic.view, MahjongDismissRoomRequestLogic.onKeypad);
	MahjongDismissRoomRequestLogic.view:setTouchEnabled(true);
end
