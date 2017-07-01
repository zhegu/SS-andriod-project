module("loadGameConfig",package.seeall)

--[[--
--延时执行方法
--@param #function func 要执行的方法
--@param #float delayTime 延时时间
]]
function delayDoFunc(func, delayTime)
	local delayAnim = CCDelayTime:create(delayTime);
	local funcAnim = CCCallFuncN:create(func);
	local array = CCArray:create();
	array:addObject(delayAnim);
	array:addObject(funcAnim);
	local seq = CCSequence:create(array);
	CCDirector:sharedDirector():getRunningScene():runAction(seq);
end

--[[--
--公共模块统一退出
--]]
function gameExit()
	GameLoadModuleConfig.setCurrentMiniGameID(0);
	GameLoadModuleConfig.setCurrentActivityID(0);
	GameConfig.setTheLastBaseLayer(GameConfig.getTheCurrentBaseLayer());
	mvcEngine.createModule(GUI_HALL);

	--	local layer = GameConfig.getTheLastBaseLayer();
	--	if GameLoadModuleConfig.IsMiniGameLastLayer() or GameLoadModuleConfig.IsHuoDongLastLayer() or layer == GUI_TABLE then
	--		GameConfig.setTheLastBaseLayer(GameConfig.getTheCurrentBaseLayer());
	--		mvcEngine.createModule(GUI_HALL);
	--		return;
	--	end
	--	GameConfig.setTheLastBaseLayer(GameConfig.getTheCurrentBaseLayer());
	--	mvcEngine.createModule(layer);
end

--[[--
--获取资源路径
--]]
function getGameCommonJsonPath(name)
	return "gameCommon/gameCommonRes/"..name;
end

--[[--
--获取资源路径
--]]
function getGameCommonPath(name)
	return Common.getScriptPath("gameCommon/gameCommonRes/"..name);
end