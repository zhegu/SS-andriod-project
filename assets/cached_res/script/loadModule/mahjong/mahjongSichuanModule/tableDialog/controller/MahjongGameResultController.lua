module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongGameResultLogic");

MahjongGameResultController = class("MahjongGameResultController",BaseController);
MahjongGameResultController.__index = MahjongGameResultController;

MahjongGameResultController.moduleLayer = nil;

function MahjongGameResultController:reset()
	MahjongGameResultLogic.view = nil;
end

function MahjongGameResultController:getLayer()
	return MahjongGameResultLogic.view;
end

function MahjongGameResultController:createView()
	MahjongGameResultLogic.createView();
	framework.setOnKeypadEventListener(MahjongGameResultLogic.view, MahjongGameResultLogic.onKeypad);
end

function MahjongGameResultController:requestMsg()
	MahjongGameResultLogic.requestMsg();
end

function MahjongGameResultController:addSlot()
	MahjongGameResultLogic.addSlot();
end

function MahjongGameResultController:removeSlot()
	MahjongGameResultLogic.removeSlot();
end

function MahjongGameResultController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MahjongGameResultLogic.view,"Button_share"), MahjongGameResultLogic.callback_Button_share, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongGameResultLogic.view,"Button_next"), MahjongGameResultLogic.callback_Button_next, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongGameResultController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MahjongGameResultLogic.view,"Button_share"), MahjongGameResultLogic.callback_Button_share, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongGameResultLogic.view,"Button_next"), MahjongGameResultLogic.callback_Button_next, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongGameResultController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongGameResultController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongGameResultController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongGameResultLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongGameResultLogic);
		MahjongGameResultLogic.releaseData();
	end

	MahjongGameResultLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongGameResultController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongGameResultLogic.view);
	MahjongGameResultLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongGameResultController:wakeModule()
	framework.setOnKeypadEventListener(MahjongGameResultLogic.view, MahjongGameResultLogic.onKeypad);
	MahjongGameResultLogic.view:setTouchEnabled(true);
end
