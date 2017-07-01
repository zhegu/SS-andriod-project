module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongTableSettingLogic");

MahjongTableSettingController = class("MahjongTableSettingController",BaseController);
MahjongTableSettingController.__index = MahjongTableSettingController;

MahjongTableSettingController.moduleLayer = nil;

function MahjongTableSettingController:reset()
	MahjongTableSettingLogic.view = nil;
end

function MahjongTableSettingController:getLayer()
	return MahjongTableSettingLogic.view;
end

function MahjongTableSettingController:createView()
	MahjongTableSettingLogic.createView();
	framework.setOnKeypadEventListener(MahjongTableSettingLogic.view, MahjongTableSettingLogic.onKeypad);
end

function MahjongTableSettingController:requestMsg()
	MahjongTableSettingLogic.requestMsg();
end

function MahjongTableSettingController:addSlot()
	MahjongTableSettingLogic.addSlot();
end

function MahjongTableSettingController:removeSlot()
	MahjongTableSettingLogic.removeSlot();
end

function MahjongTableSettingController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_music"), MahjongTableSettingLogic.callback_Button_music, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_effect"), MahjongTableSettingLogic.callback_Button_effect, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_close"), MahjongTableSettingLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_jiesan"), MahjongTableSettingLogic.callback_Button_jiesan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongTableSettingController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_music"), MahjongTableSettingLogic.callback_Button_music, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_effect"), MahjongTableSettingLogic.callback_Button_effect, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_close"), MahjongTableSettingLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(MahjongTableSettingLogic.view,"Button_jiesan"), MahjongTableSettingLogic.callback_Button_jiesan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongTableSettingController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongTableSettingController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongTableSettingController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongTableSettingLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongTableSettingLogic);
		MahjongTableSettingLogic.releaseData();
	end

	MahjongTableSettingLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongTableSettingController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongTableSettingLogic.view);
	MahjongTableSettingLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongTableSettingController:wakeModule()
	framework.setOnKeypadEventListener(MahjongTableSettingLogic.view, MahjongTableSettingLogic.onKeypad);
	MahjongTableSettingLogic.view:setTouchEnabled(true);
end
