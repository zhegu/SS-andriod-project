module(...,package.seeall);

--Load.LuaRequire("script.module.createroom.logic.CreateRoomLogic");

CreateRoomController = class("CreateRoomController",BaseController);
CreateRoomController.__index = CreateRoomController;

CreateRoomController.moduleLayer = nil;

function CreateRoomController:reset()
	CreateRoomLogic.view = nil;
end

function CreateRoomController:getLayer()
	return CreateRoomLogic.view;
end

function CreateRoomController:createView()
	CreateRoomLogic.createView();
	framework.setOnKeypadEventListener(CreateRoomLogic.view, CreateRoomLogic.onKeypad);
end

function CreateRoomController:requestMsg()
	CreateRoomLogic.requestMsg();
end

function CreateRoomController:addSlot()
	CreateRoomLogic.addSlot();
end

function CreateRoomController:removeSlot()
	CreateRoomLogic.removeSlot();
end

function CreateRoomController:addCallback()
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_games1"), CreateRoomLogic.callback_Image_games1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_games2"), CreateRoomLogic.callback_Image_games2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_fan1"), CreateRoomLogic.callback_Image_fan1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_fan2"), CreateRoomLogic.callback_Image_fan2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_fan3"), CreateRoomLogic.callback_Image_fan3, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_create_room"), CreateRoomLogic.callback_Button_create_room, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_close"), CreateRoomLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_XueZhan"), CreateRoomLogic.callback_Button_XueZhan, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_DeYang"), CreateRoomLogic.callback_Button_DeYang, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_ziMo1"), CreateRoomLogic.callback_Image_ziMo1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_ziMo2"), CreateRoomLogic.callback_Image_ziMo2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_gang1"), CreateRoomLogic.callback_Image_gang1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_gang2"), CreateRoomLogic.callback_Image_gang2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_huanSanZhang"), CreateRoomLogic.callback_Image_huanSanZhang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_yaoJiu"), CreateRoomLogic.callback_Image_yaoJiu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_menQing"), CreateRoomLogic.callback_Image_menQing, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_tianDiHu"), CreateRoomLogic.callback_Image_tianDiHu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_ZiMo1"), CreateRoomLogic.callback_Image_DeYang_ZiMo1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_ZiMo2"), CreateRoomLogic.callback_Image_DeYang_ZiMo2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_Gang1"), CreateRoomLogic.callback_Image_DeYang_Gang1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_Gang2"), CreateRoomLogic.callback_Image_DeYang_Gang2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_YaoJiu"), CreateRoomLogic.callback_Image_DeYang_YaoJiu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function CreateRoomController:removeCallback()
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_games1"), CreateRoomLogic.callback_Image_games1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_games2"), CreateRoomLogic.callback_Image_games2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_fan1"), CreateRoomLogic.callback_Image_fan1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_fan2"), CreateRoomLogic.callback_Image_fan2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_fan3"), CreateRoomLogic.callback_Image_fan3, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_create_room"), CreateRoomLogic.callback_Button_create_room, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_close"), CreateRoomLogic.callback_Button_close, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_XueZhan"), CreateRoomLogic.callback_Button_XueZhan, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Button_DeYang"), CreateRoomLogic.callback_Button_DeYang, BUTTON_CLICK, BUTTON_SOUND_BACK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_ziMo1"), CreateRoomLogic.callback_Image_ziMo1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_ziMo2"), CreateRoomLogic.callback_Image_ziMo2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_gang1"), CreateRoomLogic.callback_Image_gang1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_gang2"), CreateRoomLogic.callback_Image_gang2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_huanSanZhang"), CreateRoomLogic.callback_Image_huanSanZhang, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_yaoJiu"), CreateRoomLogic.callback_Image_yaoJiu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_menQing"), CreateRoomLogic.callback_Image_menQing, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_tianDiHu"), CreateRoomLogic.callback_Image_tianDiHu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_ZiMo1"), CreateRoomLogic.callback_Image_DeYang_ZiMo1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_ZiMo2"), CreateRoomLogic.callback_Image_DeYang_ZiMo2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_Gang1"), CreateRoomLogic.callback_Image_DeYang_Gang1, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_Gang2"), CreateRoomLogic.callback_Image_DeYang_Gang2, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(CreateRoomLogic.view,"Image_DeYang_YaoJiu"), CreateRoomLogic.callback_Image_DeYang_YaoJiu, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
end

function CreateRoomController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function CreateRoomController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function CreateRoomController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(CreateRoomLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		framework.moduleCleanUp(CreateRoomLogic);
		CreateRoomLogic.releaseData();
	end

	CreateRoomLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function CreateRoomController:sleepModule()
	framework.releaseOnKeypadEventListener(CreateRoomLogic.view);
	CreateRoomLogic.view:setTouchEnabled(false);
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function CreateRoomController:wakeModule()
	framework.setOnKeypadEventListener(CreateRoomLogic.view, CreateRoomLogic.onKeypad);
	CreateRoomLogic.view:setTouchEnabled(true);
end
