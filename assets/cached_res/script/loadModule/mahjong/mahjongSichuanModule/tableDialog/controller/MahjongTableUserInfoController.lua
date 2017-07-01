module(...,package.seeall);

--Load.LuaRequire("script.module.tableDialog.logic.MahjongTableUserInfoLogic");

MahjongTableUserInfoController = class("MahjongTableUserInfoController",BaseController);
MahjongTableUserInfoController.__index = MahjongTableUserInfoController;

MahjongTableUserInfoController.moduleLayer = nil;

function MahjongTableUserInfoController:reset()
	MahjongTableUserInfoLogic.view = nil;
end

function MahjongTableUserInfoController:getLayer()
	return MahjongTableUserInfoLogic.view;
end

function MahjongTableUserInfoController:createView()
	MahjongTableUserInfoLogic.createView();
	framework.setOnKeypadEventListener(MahjongTableUserInfoLogic.view, MahjongTableUserInfoLogic.onKeypad);
end

function MahjongTableUserInfoController:requestMsg()
	MahjongTableUserInfoLogic.requestMsg();
end

function MahjongTableUserInfoController:addSlot()
	MahjongTableUserInfoLogic.addSlot();
end

function MahjongTableUserInfoController:removeSlot()
	MahjongTableUserInfoLogic.removeSlot();
end

function MahjongTableUserInfoController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(MahjongTableUserInfoLogic.view,"Button_close"), MahjongTableUserInfoLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongTableUserInfoController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(MahjongTableUserInfoLogic.view,"Button_close"), MahjongTableUserInfoLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
end

function MahjongTableUserInfoController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongTableUserInfoController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongTableUserInfoController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongTableUserInfoLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(MahjongTableUserInfoLogic);
		MahjongTableUserInfoLogic.releaseData();
	end

	MahjongTableUserInfoLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongTableUserInfoController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongTableUserInfoLogic.view);
	MahjongTableUserInfoLogic.view:setTouchEnabled(false);
	MahjongTableUserInfoLogic.setAllMenuEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongTableUserInfoController:wakeModule()
	framework.setOnKeypadEventListener(MahjongTableUserInfoLogic.view, MahjongTableUserInfoLogic.onKeypad);
	MahjongTableUserInfoLogic.view:setTouchEnabled(true);
	MahjongTableUserInfoLogic.setAllMenuEnabled(true);
end
