module(...,package.seeall);

--Load.LuaRequire("script.module.record.logic.TableRecordListLogic");

TableRecordListController = class("TableRecordListController",BaseController);
TableRecordListController.__index = TableRecordListController;

TableRecordListController.moduleLayer = nil;

function TableRecordListController:reset()
	TableRecordListLogic.view = nil;
end

function TableRecordListController:getLayer()
	return TableRecordListLogic.view;
end

function TableRecordListController:createView()
	TableRecordListLogic.createView();
	framework.setOnKeypadEventListener(TableRecordListLogic.view, TableRecordListLogic.onKeypad);
end

function TableRecordListController:requestMsg()
	TableRecordListLogic.requestMsg();
end

function TableRecordListController:addSlot()
	TableRecordListLogic.addSlot();
end

function TableRecordListController:removeSlot()
	TableRecordListLogic.removeSlot();
end

function TableRecordListController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(TableRecordListLogic.view,"Button_close"), TableRecordListLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TableRecordListController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(TableRecordListLogic.view,"Button_close"), TableRecordListLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function TableRecordListController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function TableRecordListController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function TableRecordListController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(TableRecordListLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(TableRecordListLogic);
		TableRecordListLogic.releaseData();
	end

	TableRecordListLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function TableRecordListController:sleepModule()
	framework.releaseOnKeypadEventListener(TableRecordListLogic.view);
	TableRecordListLogic.view:setTouchEnabled(false);
	TableRecordListLogic.setAllMenuEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function TableRecordListController:wakeModule()
	framework.setOnKeypadEventListener(TableRecordListLogic.view, TableRecordListLogic.onKeypad);
	TableRecordListLogic.view:setTouchEnabled(true);
	TableRecordListLogic.setAllMenuEnabled(true)
end
