module(...,package.seeall);

--Load.LuaRequire("script.module.buycard.logic.BuyCardLogic");

BuyCardController = class("BuyCardController",BaseController);
BuyCardController.__index = BuyCardController;

BuyCardController.moduleLayer = nil;

function BuyCardController:reset()
	BuyCardLogic.view = nil;
end

function BuyCardController:getLayer()
	return BuyCardLogic.view;
end

function BuyCardController:createView()
	BuyCardLogic.createView();
	framework.setOnKeypadEventListener(BuyCardLogic.view, BuyCardLogic.onKeypad);
end

function BuyCardController:requestMsg()
	BuyCardLogic.requestMsg();
end

function BuyCardController:addSlot()
	BuyCardLogic.addSlot();
end

function BuyCardController:removeSlot()
	BuyCardLogic.removeSlot();
end

function BuyCardController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BuyCardLogic.view,"btn_done"), BuyCardLogic.callback_btn_done, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(BuyCardLogic.view,"Button_copyDaili"), BuyCardLogic.callback_Button_copyDaili, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function BuyCardController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BuyCardLogic.view,"btn_done"), BuyCardLogic.callback_btn_done, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(BuyCardLogic.view,"Button_copyDaili"), BuyCardLogic.callback_Button_copyDaili, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function BuyCardController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function BuyCardController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function BuyCardController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BuyCardLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BuyCardLogic);
		BuyCardLogic.releaseData();
	end

	BuyCardLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function BuyCardController:sleepModule()
	framework.releaseOnKeypadEventListener(BuyCardLogic.view);
	BuyCardLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function BuyCardController:wakeModule()
	framework.setOnKeypadEventListener(BuyCardLogic.view, BuyCardLogic.onKeypad);
	BuyCardLogic.view:setTouchEnabled(true);
end
