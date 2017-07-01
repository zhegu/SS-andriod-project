module("LuaUpdateConsole", package.seeall)

local lfs = require("lfs"); --载入lfs

--主游戏脚本包名
local MainScriptPackage = "cached_res";

--[[--
--开始脚本复制
--]]
function startScriptCopy()
	if Load.platform == Load.TargetIos then
		--ios平台
		--luaoc.callStaticMethod("ScriptUpdate", "startScriptCopy");
		luaoc.callStaticMethod("ScriptUpdate", "startMD5FileListCopy");
	elseif Load.platform == Load.TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.LuaUpdateConsole"
		--local javaMethodName = "copyScriptFile"
		local javaMethodName = "copyMD5ListFile"
		local javaParams = {};
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end
end

--[[--
-- 删除指定目录文件(可添加排除目录)
-- ]]
function deleteExcludeScriptFile(nDeleteFilePath, nExcludeFile)
	if nExcludeFile == nil then
		nExcludeFile = "";
	end

	if Load.platform == Load.TargetIos then
		--ios平台
		local args = {
			deletePath = nDeleteFilePath,
			ExcludeFile = nExcludeFile,
		}
		luaoc.callStaticMethod("ScriptUpdate", "deleteExcludeScriptFile", args)
	elseif Load.platform == Load.TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "deleteExcludeScriptFile"
		local javaParams = {
			nDeleteFilePath,
			nExcludeFile,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
-- 复制脚本MD5文件
-- ]]
function copyScriptUpDate()
	local PackagePath = "cached_res/cached_res_FileMD5List.data";
	if Load.isFilePathExist(PackagePath) then
		--可以复制文件
		startScriptCopy();
	end
end

--[[--
-- 删除老版本所有脚本文件
-- ]]
function deleteOldAllScriptFile()
	deleteExcludeScriptFile(CCFileUtils:sharedFileUtils():getWritablePath() .. "tongquGame");
end

--[[--
-- 删除主版本游戏包外代码
-- ]]
function deleteMainGameScriptFile()
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "scriptConfig.json");
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "cached_res_AllListMD5.data");
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "cached_res_FileMD5List.data");
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "NativeCommonFileMD5List");
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "res");
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "script", "loadModule");
end

--[[--
--删除小游戏包外代码
--]]
function deleteMiniGameByPackage(gamePackage)
	deleteExcludeScriptFile(Load.getScriptDirectory() .. "script/loadModule/" .. gamePackage);
end

--[[--
--获取所有文件MD5列表的MD5
--]]
function getAllFlieListMD5(package, AllListMD5Path)
	--直接读取包外的数据文件
	local AllListMD5Table = {};
	if package == MainScriptPackage then
		--主游戏脚本
		AllListMD5Table = Load.readfileForLineFromSharedFile(Load.getScriptDirectory() .. package .. "_AllListMD5.data");
	else
		--小游戏脚本
		AllListMD5Table = Load.readfileForLineFromSharedFile(AllListMD5Path);
	end
	--index 1:总MD5 2:小游戏版本日期
	if package == MainScriptPackage and #AllListMD5Table == 1 then
		local AllListMD5 = AllListMD5Table[1];
		Load.log("AllListMD5 ========= " .. AllListMD5);
		return AllListMD5, 0;
	elseif package ~= MainScriptPackage and #AllListMD5Table == 2 then
		local AllListMD5 = AllListMD5Table[1];
		local MiniGameVersion = tonumber(AllListMD5Table[2]);
		Load.log("AllListMD5 ========= " .. AllListMD5);
		Load.log("MiniGameVersion ========= "..MiniGameVersion);
		return AllListMD5, MiniGameVersion;
	else
		Load.log("AllListMD5 ========= nil");
		return nil, nil;
	end
end

--[[--
--获取本地的MD5列表信息
--]]
function getNativeFileMD5ListConfig(needReturnData)
	local FileMD5TableList = {};
	local DirFileTableList = {};

	--检索包外的MD5文件夹
	local MD5ListPackagePath = Load.getScriptDirectory() .. "NativeCommonFileMD5List";
	if Load.isFilePathExist(MD5ListPackagePath) then
		--包外存在MD5列表
		local path = CCFileUtils:sharedFileUtils():fullPathForFilename(MD5ListPackagePath);
		-- 定义一个目录迭代器
		for file in lfs.dir(path) do
			if file ~= "." and file ~= ".." then
				local filePath = path.."/"..file
				local attr = lfs.attributes(filePath)
				assert(type(attr) == "table")
				if attr.mode ~= "directory" then
					--是文件
					local index1, index2 = string.find(file, ".data");
					if index1 ~= nil and index2 ~= nil then
						local fileName = string.sub(file, 1, index1-1);
						--Common.log("fileName ==== "..fileName);
						--是MD5文件
						local i, j = string.find(fileName, "_");
						local Package = string.sub(fileName, 1, i-1);
						--fileType类型: AllListMD5; FileMD5List
						local fileType = string.sub(fileName, j+1, -1);
						--Common.log("Package ========== "..Package);
						--Common.log("fileType ========== "..fileType);
						if Package ~= nil then
							if FileMD5TableList[Package] == nil then
								FileMD5TableList[Package] = {};
							end
							FileMD5TableList[Package][fileType] = filePath;
							if fileType == "AllListMD5" then
								--总文件列表的MD5
								local AllListMD5, MiniGameVersion = getAllFlieListMD5(Package, filePath);
								--Common.log("MiniGameVersion ======== "..MiniGameVersion);
								FileMD5TableList[Package]["GameVersion"] = MiniGameVersion;
							end
						end
					end
				end
			end
		end
	end

	--检索包外的公共模块
	local loadModulePackagePath = Load.getScriptDirectory() .. "script/loadModule";
	if Load.isFilePathExist(loadModulePackagePath) then
		--包外存在公共模块
		local path = CCFileUtils:sharedFileUtils():fullPathForFilename(loadModulePackagePath);

		-- 定义一个目录迭代器
		for file in lfs.dir(path) do
			if file ~= "." and file ~= ".." then
				local filePath = path.."/"..file
				local attr = lfs.attributes(filePath)
				assert(type(attr) == "table")
				if attr.mode == "directory" then
					--文件夹
					--Common.log("filePath ====== "..filePath)
					--Common.log("file ====== "..file)
					DirFileTableList[file] = filePath;
				end
			end
		end
	end

	--清理native中MD5数据
	for Package, PackagePath in pairs(DirFileTableList) do
		local AllListMD5Path = PackagePath .. "/" .. Package .. "_AllListMD5.data";
		local FileMD5ListPath = PackagePath .. "/" .. Package .. "_FileMD5List.data";
		if Load.isFilePathExist(AllListMD5Path) and Load.isFilePathExist(FileMD5ListPath) then
			local AllListMD5, MiniGameVersion = getAllFlieListMD5(Package, AllListMD5Path);
			if FileMD5TableList[Package] ~= nil then
				local nativeGameVer = FileMD5TableList[Package].GameVersion;
				--Common.log("nativeGameVer ========== "..nativeGameVer);
				--Common.log("MiniGameVersion ========== "..MiniGameVersion);
				if nativeGameVer >= MiniGameVersion then
					--native包中的小游戏版本是较新的版本
					--需要删除包外的小游戏脚本
					DirFileTableList[Package] = nil;
					deleteMiniGameByPackage(Package);
				else
					--公共模块中存在新版本的MD5文件,删除native数据
					FileMD5TableList[Package] = {};
				end
			end
		else
			DirFileTableList[Package] = nil;
		end
	end
	if needReturnData ~= nil and needReturnData == false then
		--明确不需要返回MD5数据
		Load.log("明确不需要返回MD5数据 ======== ");
	else
		for Package, PackagePath in pairs(DirFileTableList) do
			--Common.log(Package.." ============= "..PackagePath);
			if FileMD5TableList[Package] == nil then
				FileMD5TableList[Package] = {};
			end
			local AllListMD5Path = PackagePath .. "/" .. Package .. "_AllListMD5.data";
			local FileMD5ListPath = PackagePath .. "/" .. Package .. "_FileMD5List.data";
			FileMD5TableList[Package].AllListMD5 = AllListMD5Path;
			FileMD5TableList[Package].FileMD5List = FileMD5ListPath;
		end

		return FileMD5TableList;
	end
end

--[[--
-- 处理包外游戏脚本
-- boolean isForceClear 是否强制清除包外主版本游戏
-- ]]
function disposeOutsideScript(isForceClear)

	deleteOldAllScriptFile();

	if isForceClear or not Load.logicScriptInSD() then
		--包外版本信息文件需要更新
		Load.log("disposeOutsideScript ================ ");

		--清理包外主版本游戏脚本
		deleteMainGameScriptFile();

		--清理包外小游戏脚本
		getNativeFileMD5ListConfig(false);

		--复制脚本MD5文件
		copyScriptUpDate();
	end
end

function buildLuaPath()
	Load.ScriptDirectory = "";
	Load.addScriptSearchPath();
	Load.log("package.path ====== "..package.path);
	--    if Load.logicScriptInSD() then
	--        Load.log("SD卡重新构建搜索路径 =========== ")
	--    else
	--        Load.log("包中搜索路径 =========== ")
	--    end

	-- 处理包外游戏脚本
	disposeOutsideScript(false);
end

--[[--
--释放所有已加载的Controller
--]]
local function resetAllController()
	local path = "";
	if Load.logicScriptInSD() then
		--log("加载SDK中lua文件 =========== ")
		--SD卡中加载脚本
		if Load.platform == Load.TargetIos then
			--ios平台
			path = "LuaScript.";
		elseif Load.platform == Load.TargetAndroid then
			--andorid平台
			path = "LuaScript.";
		end
	end
	for key, Module in pairs(ModuleTable) do
		if package.loaded[path .. Module["ControllerPath"]] ~= nil then
			Load.log(string.format("释放已加载的Controller module[%sController] reload", key))
			package.loaded[path .. Module["ControllerPath"]] = nil
		end
	end
end

--[[--
-- 加载游戏中所有的脚本文件
-- ]]
function requireAllScript()
	Load.isReLoadLua = true;
	Load.LuaRequire("script.framework.FrameworkRequire");
	Load.LuaRequire("script.game.GameRequire");
	Load.LuaRequire("script.gameCommon.GameCommonRequire");
	Load.LuaRequire("script.module.ModuleRequire");
	Load.isReLoadLua = false;
end

--[[--
-- 重置游戏数据
-- ]]
local function resetGameData()
	CommDialogConfig.closeProgressDialog();
	NetworkMonitor.closeNetworkMonitor();
	framework.clearFrameworkData();
	mvcEngine.destroyAllModules();
	AudioManager.stopBgMusic(true);
	AudioManager.stopAllSound();

    CCArmatureDataManager:sharedArmatureDataManager():removeAllArmatureFileInfo();
    CCDirector:sharedDirector():purgeCachedData();
    CCTextureCache:sharedTextureCache():removeUnusedTextures();
	CCTextureCache:sharedTextureCache():removeAllTextures();

	resetAllController();
end

--[[--
-- 启动游戏
-- boolean isConnectNetWork是否重启网络模块
-- ]]
function startGame(isConnectNetWork)
	--构建搜索路径
	buildLuaPath();
	--重新加载所有脚本文件
	requireAllScript();
	--初始化游戏公共配置信息
	GameCommonConfig.initGameCommonConfig();
	if isConnectNetWork then
		--需要启动连接网络
		--启动网络
		MassageConnect.startConnect();
	else
		--设置网络已连接
		GameConfig.isConnect = true;
		--启动网络监听
		NetworkMonitor.startNetworkMonitor();
	end
	--启动游戏主逻辑
	GameStartConfig.GameStart();
end

--[[--
--重新加载lua更新控制类
--]]
function reLoadSelf()
	Load.isReLoadLua = true;
	Load.LuaRequire("script.gameCommon.scriptUpdate.LuaUpdateConsole");
	Load.isReLoadLua = false;
end

--[[--
--重新加载所有脚本
--]]
function reLoadAllLua()
	--Common.log("reLoadSelf ============== ");
	--reLoadSelf();
	--停止当前游戏
	Common.log("停止当前游戏 ============== ");
	resetGameData();
	--启动游戏
	Common.log("启动游戏 ============== ");
	startGame(false);
end
