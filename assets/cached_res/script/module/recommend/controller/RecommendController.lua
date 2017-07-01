module(...,package.seeall);

--Load.LuaRequire("script.module.recommend.logic.RecommendLogic");

RecommendController = class("RecommendController",BaseController);
RecommendController.__index = RecommendController;

RecommendController.moduleLayer = nil;

function RecommendController:reset()
	RecommendLogic.view = nil;
end

function RecommendController:getLayer()
	return RecommendLogic.view;
end

function RecommendController:createView()
	RecommendLogic.createView();
	framework.setOnKeypadEventListener(RecommendLogic.view, RecommendLogic.onKeypad);
end

function RecommendController:requestMsg()
	RecommendLogic.requestMsg();
end

function RecommendController:addSlot()
	RecommendLogic.addSlot();
end

function RecommendController:removeSlot()
	RecommendLogic.removeSlot();
end

function RecommendController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_close"), RecommendLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_invite"), RecommendLogic.callback_Button_invite, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_left"), RecommendLogic.callback_Button_left, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_right"), RecommendLogic.callback_Button_right, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_reward"), RecommendLogic.callback_Button_reward, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RecommendController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_close"), RecommendLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_invite"), RecommendLogic.callback_Button_invite, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_left"), RecommendLogic.callback_Button_left, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_right"), RecommendLogic.callback_Button_right, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RecommendLogic.view,"Button_reward"), RecommendLogic.callback_Button_reward, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RecommendController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RecommendController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RecommendController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RecommendLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RecommendLogic);
		RecommendLogic.releaseData();
	end

	RecommendLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RecommendController:sleepModule()
	framework.releaseOnKeypadEventListener(RecommendLogic.view);
	RecommendLogic.view:setTouchEnabled(false);
	RecommendLogic.setAllTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RecommendController:wakeModule()
	framework.setOnKeypadEventListener(RecommendLogic.view, RecommendLogic.onKeypad);
	RecommendLogic.setAllTouchEnabled(true)
	RecommendLogic.view:setTouchEnabled(true);
end
