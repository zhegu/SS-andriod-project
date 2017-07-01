module(...,package.seeall);

--Load.LuaRequire("script.module.mahjong.logic.MahjongTableLogic");

MahjongTableController = class("MahjongTableController",BaseController);
MahjongTableController.__index = MahjongTableController;

MahjongTableController.moduleLayer = nil;

function MahjongTableController:reset()
	MahjongTableLogic.view = nil;
end

function MahjongTableController:getLayer()
	return MahjongTableLogic.view;
end

function MahjongTableController:createView()
	MahjongTableLogic.createView();
	framework.setOnKeypadEventListener(MahjongTableLogic.view, MahjongTableLogic.onKeypad);
end

function MahjongTableController:requestMsg()
	MahjongTableLogic.requestMsg();
end

function MahjongTableController:addSlot()
	MahjongTableLogic.addSlot();
end

function MahjongTableController:removeSlot()
	MahjongTableLogic.removeSlot();
end

function MahjongTableController:addCallback()

end

function MahjongTableController:removeCallback()

end

function MahjongTableController:setModuleLayer(moduleLayer)
	self.moduleLayer = moduleLayer;
end

function MahjongTableController:getModuleLayer(moduleLayer)
	return self.moduleLayer;
end

function MahjongTableController:destoryModule(destroyType)
	framework.releaseOnKeypadEventListener(MahjongTableLogic.view);
	self:destroy();

	if destroyType == DESTORY_TYPE_EFFECT then
	--不销毁数据
	elseif destroyType == DESTORY_TYPE_CLEAN then
		--销毁数据
		MahjongConfig.removeAllMahjongTextureCache();
	end
	MahjongTableLogic.view:stopAllActions();
	framework.moduleCleanUp(MahjongTableLogic);
	MahjongTableLogic.releaseData();
	MahjongTableLogic.view:removeFromParentAndCleanup(true);
	self:reset();

	framework.emit(signal.common.Signal_DestroyModule_Done);
end

function MahjongTableController:sleepModule()
	framework.releaseOnKeypadEventListener(MahjongTableLogic.view);
	MahjongTableLogic.view:setTouchEnabled(false);
	MahjongTableCardLayer.setCardLayerTouchEnabled(false);
	MahjongTableButtonLayer.setButtonLayerTouchEnabled(false)
	MahjongTablePlayerLayer.setPlayerLayerTouchEnabled(false)
	framework.emit(signal.common.Signal_SleepModule_Done);
end

function MahjongTableController:wakeModule()
	framework.setOnKeypadEventListener(MahjongTableLogic.view, MahjongTableLogic.onKeypad);
	MahjongTableLogic.view:setTouchEnabled(true);
	MahjongTableCardLayer.setCardLayerTouchEnabled(true);
	MahjongTableButtonLayer.setButtonLayerTouchEnabled(true)
	MahjongTablePlayerLayer.setPlayerLayerTouchEnabled(true)
end
