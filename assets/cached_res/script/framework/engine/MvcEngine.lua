module("mvcEngine", package.seeall)

local needCreateModuleName = nil;--当前要创建的界面名称(GUIConfig中定义)

local needDestoryModuleName = nil;--需要销毁的界面名称(GUIConfig中定义)

local needHandleModuleCount = 0;--记录当前需要处理的界面数

local needAddActiveModuleTable = {};--记录当前需要添加到活跃队列的界面

local activeModuleTable = {};--当前显示的层(包括休眠的层)

local wakeModuleTable = {};--需要唤醒的层

local delayTime = 0.2;--延时添加界面

--[[--
--获取需要删除的界面
--]]
local function removeModuleFromTable(moduleName)
	local module = nil
	for key, value in pairs(activeModuleTable) do
		if(key == moduleName) then
			module = activeModuleTable[key]
			activeModuleTable[key] = nil
			break;
		end
	end
	return module
end

--[[--
--删除需要添加到活跃队列的界面
--]]
local function removeNeedAddActiveModuleFromTable(moduleName)
	local module = nil
	for key, value in pairs(needAddActiveModuleTable) do
		if(key == moduleName) then
			module = needAddActiveModuleTable[key]
			needAddActiveModuleTable[key] = nil
			break;
		end
	end
	return module;
end

--[[--
--获取需要添加到活跃队列的界面数量
--]]
local function getNeedAddActiveModuleSize()
	local size = 0;
	for key, value in pairs(needAddActiveModuleTable) do
		if(value ~= nil) then
			size = size + 1
		end
	end
	return size;
end

--[[--
--获取当前显示的界面中的最大层级
--]]
local function getActiveModuleMaxLayer()
	local maxLayer = 1;
	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (maxLayer < Layer[moduleLayer]) then
			maxLayer = Layer[moduleLayer];
		end
	end
	return maxLayer + getNeedAddActiveModuleSize();
end

--[[--
--获取下一级的层级定义
--]]
local function getNextLevelLayer(level)
	for key, value in pairs(Layer) do
		if value - level == 1 then
			return key;
		end
	end
end

--[[--
--唤醒界面
--]]
local function doWakeModule(addModuleName)
	if addModuleName ~= nil and type(addModuleName) == "string" then
		--createView方法中可能同时创建了多个界面,需要屏蔽界面
		local isHasDestroyModule = false--是否有需要销毁的层
		local sleepModuleTable = {}--休眠的层
		local layerOfCreateModule = ModuleTable[addModuleName]["layer"]--要创建的界面层级
		for key, value in pairs(activeModuleTable) do
			local moduleLayer = value:getModuleLayer()
			if (Layer[layerOfCreateModule] < Layer[moduleLayer]) then
				--高于新打开界面的层级销毁
				isHasDestroyModule = true;
			--activeModuleTable[key] = nil
			elseif (Layer[layerOfCreateModule] > Layer[moduleLayer]) then
				--小于新打开界面的层级休眠
				sleepModuleTable[#sleepModuleTable + 1] = value
			end
		end

		if isHasDestroyModule then
			--连续创建界面时，保证下层不会唤醒
			--Common.log("连续创建界面时，保证下层不会唤醒  ========== ")
			if activeModuleTable[addModuleName]:getLayer() ~= nil then
				activeModuleTable[addModuleName]:sleepModule();
			end
		end

		for k = 1,#sleepModuleTable do
			if sleepModuleTable[k]:getLayer() ~= nil then
				--Common.log("小于新打开界面的层级休眠  ========== ")
				sleepModuleTable[k]:sleepModule()
			end
		end
	end

	if needDestoryModuleName ~= nil then
		local destoryModuleLayer = ModuleTable[needDestoryModuleName]["layer"]--要销毁的界面层级
		for key, value in pairs(activeModuleTable) do
			local moduleLayer = value:getModuleLayer()
			if(Layer[destoryModuleLayer] < Layer[moduleLayer]) then
				--高于关闭界面的层级,则说明有延迟弹出的界面
				wakeModuleTable = {}
				break;
			elseif(Layer[destoryModuleLayer] > Layer[moduleLayer]) then
				--小于关闭界面的层级唤醒
				wakeModuleTable[#wakeModuleTable + 1] = value
			end
		end


		if (#wakeModuleTable > 0) then
			--唤醒下一层级
			local maxLayer = 0;
			local wakeModule = nil;
			--筛选需要唤醒的界面中层级最高的
			for key, value in pairs(wakeModuleTable) do
				local moduleLayer = value:getModuleLayer()
				if (maxLayer < Layer[moduleLayer]) then
					maxLayer = Layer[moduleLayer];
					wakeModule = value;
				end
			end

			if wakeModule ~= nil then
				if wakeModule:getLayer() ~= nil then
					wakeModule:wakeModule();
				end
			end

			wakeModuleTable = {}
		end

		needDestoryModuleName = nil;
	end

end

--[[--
--创建界面
--]]
local function doCreateModule(isDelay)

	if needCreateModuleName ~= nil then
		local moduleName = needCreateModuleName;

		if ModuleTable[moduleName] == nil then
			return;
		end

		local modulePath = ModuleTable[moduleName]["ControllerPath"];
		--每次都要重新加载Controller
		Load.isReLoadLua = true;
		local control = Load.LuaRequire(modulePath);
		Load.isReLoadLua = false;

		local moduleControl = control[moduleName.."Controller"]:new();

		moduleControl:init();

		moduleControl:setModuleLayer(ModuleTable[moduleName]["layer"]);

		needAddActiveModuleTable[moduleName] = moduleControl;
		--Common.log("needAddActiveModuleCount CreateModule == "..getNeedAddActiveModuleSize());

		local function addActiveModule()
			local removeModule = removeNeedAddActiveModuleFromTable(moduleName);
			--Common.log("needAddActiveModuleCount addActiveModule == "..getNeedAddActiveModuleSize());
			if removeModule ~= nil then
				--Common.log("needAddActiveModuleCount moduleName == "..moduleName);
				activeModuleTable[moduleName] = removeModule;
				doWakeModule(moduleName);
			end
		end

		if isDelay and Layer[ModuleTable[moduleName]["layer"]] ~= 1 then
			--创建一级界面不延时
			--Common.log("=======延时添加唤醒界面=======");
			local array = CCArray:create();
			array:addObject(CCDelayTime:create(delayTime));
			array:addObject(CCCallFuncN:create(addActiveModule));
			local seq = CCSequence:create(array);
			CCDirector:sharedDirector():getRunningScene():runAction(seq);
		else
			addActiveModule();
		end

		needCreateModuleName = nil;
	else
		--Common.log("=======延时唤醒界面=======");
		if needDestoryModuleName ~= nil and Layer[ModuleTable[needDestoryModuleName]["layer"]] == 1 then
			--销毁一级界面不延时
			doWakeModule();
		else
			local array = CCArray:create();
			array:addObject(CCDelayTime:create(delayTime));
			array:addObject(CCCallFuncN:create(doWakeModule));
			local seq = CCSequence:create(array);
			CCDirector:sharedDirector():getRunningScene():runAction(seq);
		end

	end
end

--[[--
--当前界面休眠/销毁结束以后调用(界面Controller发送信号)
--如没有需要休眠/销毁的界面，则直接调用
--]]
local function slot_Destory_Sleep_Done()
	needHandleModuleCount = needHandleModuleCount - 1
	--Common.log("needHandleModuleCount =========== "..needHandleModuleCount)

	local isDelay = false;
	if needHandleModuleCount == 0 and needCreateModuleName ~= nil then
		--有至少一个界面需要关闭&&有界面需要创建,关闭界面时有延时，所以新的界面加入队列中也要加延时
		isDelay = true;
	end

	if (needHandleModuleCount <= 0) then
		needHandleModuleCount = 0;

		if CCDirector:sharedDirector():getRunningScene() ~= nil then
			local function finallyCallback()
				if needCreateModuleName ~= nil then
					--创建失败
					Common.log("创建界面失败 =============== "..needCreateModuleName);
					needDestoryModuleName = needCreateModuleName;
					needCreateModuleName = nil;
					doWakeModule();
					framework.removeSlotFromSignal(signal.common.Signal_SleepModule_Done, slot_Destory_Sleep_Done);
					framework.removeSlotFromSignal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done);
				end
			end

			local array = CCArray:create();
			array:addObject(CCDelayTime:create(delayTime * 2));
			array:addObject(CCCallFuncN:create(finallyCallback));
			local seq = CCSequence:create(array);
			CCDirector:sharedDirector():getRunningScene():runAction(seq);
		end

		doCreateModule(isDelay);

		framework.removeSlotFromSignal(signal.common.Signal_SleepModule_Done, slot_Destory_Sleep_Done);
		framework.removeSlotFromSignal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done);
	end

end

--[[--
--休眠或者销毁(打开新界面时调用，等于/高于新打开界面的层级销毁，小于新打开界面的层级休眠),执行结束以后，等待界面Controller发送信号调用slot_Destory_Sleep_Done
--不可以在1秒的时间内创建多个相同界面
--]]
local function sleepOrDestroyModules(moduleName, action)
	local layerOfCreateModule = ModuleTable[moduleName]["layer"]--要创建的界面层级

	if Layer[layerOfCreateModule] ~= 1 then
		--如果要创建的界面不是第一层级
		for key, value in pairs(needAddActiveModuleTable) do
			if key == moduleName then
				Common.log("当前界面已存在 ========= 不与创建 "..moduleName)
				return;
			end
		end
		for key, value in pairs(activeModuleTable) do
			if key == moduleName then
				Common.log("当前界面已存在 ========= 不与创建 "..moduleName)
				return;
			end
		end
		local maxLayer = getActiveModuleMaxLayer();--当前显示界面的最大层级
		local LayerKey = getNextLevelLayer(maxLayer);
		Common.log("修正 LayerKey ========= "..LayerKey);
		ModuleTable[moduleName]["layer"] = LayerKey;
		layerOfCreateModule = LayerKey;
	end

	local destroyModuleTable = {}--销毁的层
	local sleepModuleTable = {}--休眠的层
	local destroyType = {}--销毁类型

	needCreateModuleName = moduleName
	Common.log("sleepOrDestroyModules  needCreateModuleName == "..needCreateModuleName)
	needDestoryModuleName = nil;--有新创建的界面，之前需要销毁的界面就不再处理唤醒事件

	--已显示界面
	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (Layer[layerOfCreateModule] <= Layer[moduleLayer]) then
			--等于/高于新打开界面的层级销毁
			if needCreateModuleName == key then
				--界面已经显示，则不销毁数据
				destroyType[#destroyModuleTable + 1] = DESTORY_TYPE_EFFECT
			else
				destroyType[#destroyModuleTable + 1] = DESTORY_TYPE_CLEAN
			end
			destroyModuleTable[#destroyModuleTable + 1] = value
			activeModuleTable[key] = nil
			--Common.log("已显示界面 =======destroyModuleTable====== key == "..key)
		elseif (Layer[layerOfCreateModule] > Layer[moduleLayer]) then
			--小于新打开界面的层级休眠
			sleepModuleTable[#sleepModuleTable + 1] = value
		end
	end

	--待显示界面
	for key, value in pairs(needAddActiveModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (Layer[layerOfCreateModule] <= Layer[moduleLayer]) then
			--等于/高于新打开界面的层级销毁
			if needCreateModuleName == key then
				--界面已经显示，则不销毁数据
				destroyType[#destroyModuleTable + 1] = DESTORY_TYPE_EFFECT
			else
				destroyType[#destroyModuleTable + 1] = DESTORY_TYPE_CLEAN
			end
			destroyModuleTable[#destroyModuleTable + 1] = value
			needAddActiveModuleTable[key] = nil
			--Common.log("待显示界面 =======destroyModuleTable====== key == "..key)
		elseif (Layer[layerOfCreateModule] > Layer[moduleLayer]) then
			--小于新打开界面的层级休眠
			sleepModuleTable[#sleepModuleTable + 1] = value
		end
	end

	needHandleModuleCount = #destroyModuleTable + #sleepModuleTable + needHandleModuleCount;
	--Common.log("needHandleModuleCount =========== "..needHandleModuleCount)

	if(needHandleModuleCount == 0) then
		slot_Destory_Sleep_Done()
		return;
	end

	--销毁界面,销毁完成以后会调用 slot_Destory_Sleep_Done
	if action ~= nil then
		local function destroyModule()
			for j = 1, #destroyModuleTable do
				if destroyModuleTable[j]:getLayer() ~= nil then
					destroyModuleTable[j]:destoryModule(destroyType[j])
				end
			end
		end
		for j = 1, #destroyModuleTable do
			if destroyModuleTable[j]:getLayer() ~= nil then
				destroyModuleTable[j]:sleepModule()
				if j == #destroyModuleTable then
					local array = CCArray:create()
					array:addObject(action)
					array:addObject(CCCallFuncN:create(destroyModule))
					local seq = CCSequence:create(array)
					destroyModuleTable[j]:getLayer():runAction(seq)
				else
					destroyModuleTable[j]:getLayer():runAction(action)
				end
			end
		end
	else
		for j = 1, #destroyModuleTable do
			if destroyModuleTable[j]:getLayer() ~= nil then
				destroyModuleTable[j]:destoryModule(destroyType[j])
			end
		end
	end

	--休眠界面,休眠完成以后会调用 slot_Destory_Sleep_Done
	for k = 1,#sleepModuleTable do
		if sleepModuleTable[k]:getLayer() ~= nil then
			sleepModuleTable[k]:sleepModule()
		end
	end
end

--[[--
--销毁界面(关闭界面时调用，高于关闭界面的层级销毁，小于关闭界面的层级唤醒)并存储需要唤醒的界面，执行结束以后，等待界面Controller发送信号调用slot_Destory_Sleep_Done
--]]
local function wakeOrDestroyModules(moduleName, destroy_type)
	if moduleName == nil then
		return;
	end

	local removeModule = removeModuleFromTable(moduleName)--获取当前需要删除的界面

	if removeModule == nil then
		Common.log("销毁界面 activeModule ===== nil == "..moduleName);
		removeModule = removeNeedAddActiveModuleFromTable(moduleName);
		if removeModule == nil then
			Common.log("销毁界面 NeedAddActiveModule ===== nil == "..moduleName);
			return;
		end
	end

	needDestoryModuleName = moduleName;

	needHandleModuleCount = 0;

	local destoryModuleTable = {};


	local destoryModuleLayer = ModuleTable[moduleName]["layer"]--要销毁的界面层级

	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if Layer[destoryModuleLayer] == 1 then
			--如果要销毁的界面是第一层级，则高于一级的界面都要销毁
			if(Layer[destoryModuleLayer] < Layer[moduleLayer]) then
				--高于关闭界面的层级销毁
				destoryModuleTable[#destoryModuleTable + 1] = value
				activeModuleTable[key] = nil
				--elseif(Layer[destoryModuleLayer] > Layer[moduleLayer]) then
				--	--小于关闭界面的层级唤醒
				--	wakeModuleTable[#wakeModuleTable + 1] = value
			end
		end
	end

	needHandleModuleCount = #destoryModuleTable + 1

	if(#destoryModuleTable > 0) then
		for j = 1,#destoryModuleTable do
			if destoryModuleTable[j]:getLayer() ~= nil then
				destoryModuleTable[j]:destoryModule(DESTORY_TYPE_CLEAN)
			end
		end
	end

	if destroy_type == nil then
		if removeModule:getLayer() ~= nil then
			removeModule:destoryModule(DESTORY_TYPE_CLEAN)
		end
	else
		if removeModule:getLayer() ~= nil then
			removeModule:destoryModule(destroy_type)
		end
	end
end

--[[--
--@param #string moduleName 要打开的界面
--@param #action action 关闭上一界面的动画(主要用户第一层级)
--]]
function createModule(moduleName, action)
	framework.releaseClick();
	framework.addSlot2Signal(signal.common.Signal_SleepModule_Done, slot_Destory_Sleep_Done)--休眠界面结束后的回调
	framework.addSlot2Signal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done)--销毁界面结束后的回调
	sleepOrDestroyModules(moduleName, action)
end

function destroyModule(moduleName, destroy_type)
	framework.releaseClick();
	framework.addSlot2Signal(signal.common.Signal_DestroyModule_Done, slot_Destory_Sleep_Done)--销毁界面结束后的回调
	wakeOrDestroyModules(moduleName, destroy_type)
end

--[[--
--唤醒最高层级的界面
--]]
function wakeMaxModule()
	local moduleKey = nil
	local module = nil
	local maxLayer = 0;
	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (maxLayer < Layer[moduleLayer]) then
			maxLayer = Layer[moduleLayer];
			moduleKey = key;
			module = value;
		end
	end
	if moduleKey ~= nil and module ~= nil then
		if module:getLayer() ~= nil then
			Common.log("唤醒最高层级的界面 ==================== "..moduleKey);
			module:wakeModule();
		end
	end
end

function destroyAllModules()
	local module = nil
	for key, value in pairs(activeModuleTable) do
		if value:getLayer() ~= nil then
			value:destoryModule(DESTORY_TYPE_CLEAN)
		end
	end
	activeModuleTable = {}
end

--[[--
--获取当前界面是否显示
--]]
function logicModuleIsShow(moduleName)
	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (key == moduleName) then
			Common.log("当前界面显示 ========= "..key)
			return true;
		end
	end
	return false;
end

--[[--
--判断界面是否是休眠状态
--]]
function logicModuleIsSleep(moduleName)
	local layerModule = ModuleTable[moduleName]["layer"]--要创建的界面层级
	local maxLayer = 0;
	for key, value in pairs(activeModuleTable) do
		local moduleLayer = value:getModuleLayer()
		if (maxLayer < Layer[moduleLayer]) then
			maxLayer = Layer[moduleLayer];
		end
	end
	if Layer[layerModule] ~= maxLayer then
		--不是最高层级，则是休眠状态
		Common.log(moduleName.." == 休眠状态");
		return true;
	else
		--是最高层级，则是唤醒状态
		Common.log(moduleName.." == 唤醒状态");
		return false;
	end
end
