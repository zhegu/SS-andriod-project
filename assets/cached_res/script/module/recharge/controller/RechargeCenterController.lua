module(...,package.seeall);

--Load.LuaRequire("script.module.recharge.logic.RechargeCenterLogic");

RechargeCenterController = class("RechargeCenterController",BaseController);
RechargeCenterController.__index = RechargeCenterController;

RechargeCenterController.moduleLayer = nil;

function RechargeCenterController:reset()
	RechargeCenterLogic.view = nil;
end

function RechargeCenterController:getLayer()
	return RechargeCenterLogic.view;
end

function RechargeCenterController:createView()
	RechargeCenterLogic.createView();
	framework.setOnKeypadEventListener(RechargeCenterLogic.view, RechargeCenterLogic.onKeypad);
end

function RechargeCenterController:requestMsg()
	RechargeCenterLogic.requestMsg();
end

function RechargeCenterController:addSlot()
	RechargeCenterLogic.addSlot();
end

function RechargeCenterController:removeSlot()
	RechargeCenterLogic.removeSlot();
end

function RechargeCenterController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_back"), RechargeCenterLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_alipay"), RechargeCenterLogic.callback_img_alipay, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_duanxin"), RechargeCenterLogic.callback_img_duanxin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_wechat"), RechargeCenterLogic.callback_img_wechat, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_iap"), RechargeCenterLogic.callback_img_iap, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Button_vipInfo"), RechargeCenterLogic.callback_Button_vipInfo, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RechargeCenterController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"btn_back"), RechargeCenterLogic.callback_btn_back, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_alipay"), RechargeCenterLogic.callback_img_alipay, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_duanxin"), RechargeCenterLogic.callback_img_duanxin, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_wechat"), RechargeCenterLogic.callback_img_wechat, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"img_iap"), RechargeCenterLogic.callback_img_iap, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(RechargeCenterLogic.view,"Button_vipInfo"), RechargeCenterLogic.callback_Button_vipInfo, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function RechargeCenterController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function RechargeCenterController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function RechargeCenterController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(RechargeCenterLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(RechargeCenterLogic);
		RechargeCenterLogic.releaseData();
	end

	RechargeCenterLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function RechargeCenterController:sleepModule()
	framework.releaseOnKeypadEventListener(RechargeCenterLogic.view);
	RechargeCenterLogic.view:setTouchEnabled(false);
	RechargeCenterLogic.setAllMenuEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function RechargeCenterController:wakeModule()
	framework.setOnKeypadEventListener(RechargeCenterLogic.view, RechargeCenterLogic.onKeypad);
	RechargeCenterLogic.view:setTouchEnabled(true);
	RechargeCenterLogic.setAllMenuEnabled(true);
end
