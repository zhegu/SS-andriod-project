module(...,package.seeall);

--Load.LuaRequire("script.module.login.logic.LoginLogic");

LoginController = class("LoginController",BaseController);
LoginController.__index = LoginController;

LoginController.moduleLayer = nil;

function LoginController:reset()
	LoginLogic.view = nil;
end

function LoginController:getLayer()
	return LoginLogic.view;
end

function LoginController:createView()
	LoginLogic.createView();
	framework.setOnKeypadEventListener(LoginLogic.view, LoginLogic.onKeypad);
end

function LoginController:requestMsg()
	LoginLogic.requestMsg();
end

function LoginController:addSlot()
	LoginLogic.addSlot();
end

function LoginController:removeSlot()
	LoginLogic.removeSlot();
end

function LoginController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"Image_text_login"), LoginLogic.callback_Image_text_login, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_weixin_login"), LoginLogic.callback_btn_weixin_login, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function LoginController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"Image_text_login"), LoginLogic.callback_Image_text_login, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(LoginLogic.view,"btn_weixin_login"), LoginLogic.callback_btn_weixin_login, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function LoginController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function LoginController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function LoginController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(LoginLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(LoginLogic);
		LoginLogic.releaseData();
	end

	LoginLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function LoginController:sleepModule()
	framework.releaseOnKeypadEventListener(LoginLogic.view);
	LoginLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function LoginController:wakeModule()
	framework.setOnKeypadEventListener(LoginLogic.view, LoginLogic.onKeypad);
	LoginLogic.view:setTouchEnabled(true);
end
