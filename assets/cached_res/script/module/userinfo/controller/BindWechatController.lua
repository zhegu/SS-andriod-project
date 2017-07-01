module(...,package.seeall);

--Load.LuaRequire("script.module.userinfo.logic.BindWechatLogic");

BindWechatController = class("BindWechatController",BaseController);
BindWechatController.__index = BindWechatController;

BindWechatController.moduleLayer = nil;

function BindWechatController:reset()
	BindWechatLogic.view = nil;
end

function BindWechatController:getLayer()
	return BindWechatLogic.view;
end

function BindWechatController:createView()
	BindWechatLogic.createView();
	framework.setOnKeypadEventListener(BindWechatLogic.view, BindWechatLogic.onKeypad);
end

function BindWechatController:requestMsg()
	BindWechatLogic.requestMsg();
end

function BindWechatController:addSlot()
	BindWechatLogic.addSlot();
end

function BindWechatController:removeSlot()
	BindWechatLogic.removeSlot();
end

function BindWechatController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(BindWechatLogic.view,"btn_bindWechat"), BindWechatLogic.callback_btn_bindWechat, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(BindWechatLogic.view,"btn_close"), BindWechatLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function BindWechatController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(BindWechatLogic.view,"btn_bindWechat"), BindWechatLogic.callback_btn_bindWechat, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(BindWechatLogic.view,"btn_close"), BindWechatLogic.callback_btn_close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function BindWechatController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function BindWechatController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function BindWechatController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(BindWechatLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(BindWechatLogic);
		BindWechatLogic.releaseData();
	end

	BindWechatLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function BindWechatController:sleepModule()
	framework.releaseOnKeypadEventListener(BindWechatLogic.view);
	BindWechatLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function BindWechatController:wakeModule()
	framework.setOnKeypadEventListener(BindWechatLogic.view, BindWechatLogic.onKeypad);
	BindWechatLogic.view:setTouchEnabled(true);
end
