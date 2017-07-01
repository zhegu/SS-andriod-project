module(...,package.seeall);

--Load.LuaRequire("script.module.customservice.logic.GameHelpLogic");

GameHelpController = class("GameHelpController",BaseController);
GameHelpController.__index = GameHelpController;

GameHelpController.moduleLayer = nil;

function GameHelpController:reset()
	GameHelpLogic.view = nil;
end

function GameHelpController:getLayer()
	return GameHelpLogic.view;
end

function GameHelpController:createView()
	GameHelpLogic.createView();
	framework.setOnKeypadEventListener(GameHelpLogic.view, GameHelpLogic.onKeypad);
end

function GameHelpController:requestMsg()
	GameHelpLogic.requestMsg();
end

function GameHelpController:addSlot()
	GameHelpLogic.addSlot();
end

function GameHelpController:removeSlot()
	GameHelpLogic.removeSlot();
end

function GameHelpController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Button_close"), GameHelpLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Button_loudi"), GameHelpLogic.callback_Button_loudi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function GameHelpController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Button_close"), GameHelpLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(GameHelpLogic.view,"Button_loudi"), GameHelpLogic.callback_Button_loudi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function GameHelpController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function GameHelpController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function GameHelpController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(GameHelpLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(GameHelpLogic);
		GameHelpLogic.releaseData();
	end

	GameHelpLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function GameHelpController:sleepModule()
	framework.releaseOnKeypadEventListener(GameHelpLogic.view);
	GameHelpLogic.view:setTouchEnabled(false);
	Common.didHideWebview()
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function GameHelpController:wakeModule()
	framework.setOnKeypadEventListener(GameHelpLogic.view, GameHelpLogic.onKeypad);
	Common.didShowWebview()
	GameHelpLogic.view:setTouchEnabled(true);
end
