module("LuaUpdateConfig", package.seeall)

local lfs = require("lfs"); --载入lfs

local lookTimer = nil --时间计时器

--主游戏脚本包名
MainScriptPackage = "cached_res";

--当前在下载的脚本更新文件,type:下载类型，time:申请下载的时间
local downloadFileConfigList = {};
--type:0申请下载; 1下载中; 2已下载
DOWNLOAD_APPLY = 0; --0申请下载
DOWNLOAD_UNDERWAY = 1; --1下载中
DOWNLOAD_DONE = 2; --2已下载

--[[--
-- 检测脚本升级逻辑
-- ]]
function logicLuaUpdateMessage()
	GameConfig.isCheckScript = false;--可以重新检测脚本版本升级
	--初始化本地脚本下载信息
	initDownloadFileConfigList();
	--检测小游戏版本升级
	logicMiniGameListVersion();
	--检测脚本升级
	checkScriptVersion();
end

--[[--
-- 初始化下载文件信息
-- ]]
function initDownloadFileConfigList()
	Common.log("初始化下载文件信息 initDownloadFileConfigList =============== ");
	local DocumentPath = CCFileUtils:sharedFileUtils():getWritablePath();
	--Common.log("DocumentPath ==== "..DocumentPath);
	local DownloadFilePath = DocumentPath.."LoadScript/downLoad";
	if Load.isFilePathExist(DownloadFilePath) then
		--包外存在公共模块
		local path = CCFileUtils:sharedFileUtils():fullPathForFilename(DownloadFilePath);
		-- 定义一个目录迭代器
		for file in lfs.dir(path) do
			if file ~= "." and file ~= ".." then
				local filePath = path.."/"..file
				local attr = lfs.attributes(filePath)
				assert(type(attr) == "table")
				if attr.mode ~= "directory" then
					--文件
					--Common.log("filePath ====== "..filePath)
					local index1, index2 = string.find(file, ".zip");
					if index1 ~= nil and index2 ~= nil then
						local package = string.sub(file, 1, index1-1);
						--Common.log("package ====== "..package);
						setDownloadFileConfig(package, DOWNLOAD_DONE);
					end
				end
			end
		end
	end
end

--[[--
-- 获取下载文件信息
--return type: 0下载中; 1已下载
-- ]]
function getDownloadFileConfig(package)
	if Common.platform == Common.TargetAndroid then
		--Android平台只允许下载一个
		if next(downloadFileConfigList) ~= nil then
			return DOWNLOAD_UNDERWAY;
		end
	end

	if downloadFileConfigList[package] == nil then
		return nil;
	end

	local type = downloadFileConfigList[package].type;
	local time = downloadFileConfigList[package].time;
	Common.log("getDownloadFileConfig === package == "..package);
	Common.log("getDownloadFileConfig === type == "..type);
	Common.log("getDownloadFileConfig === time == "..time);
	--	if type == DOWNLOAD_APPLY then
	--		--申请下载状态下
	--		Common.log("getDownloadFileConfig === os.time-time == "..(os.time() - time));
	--		if os.time() - time  > 60 * 1 then
	--			--1分钟内没有响应下载,重置下载任务
	--			deleteDownloadFileConfig(package);
	--			return nil
	--		end
	--	end

	return type;
end

--[[--
-- 设置下载文件信息
-- ]]
function setDownloadFileConfig(package, type)
	if downloadFileConfigList[package] == nil then
		downloadFileConfigList[package] = {};
	end

	downloadFileConfigList[package].type = type;
	downloadFileConfigList[package].time = os.time();
--Common.log("downloadFileConfigList[package].time ======= "..downloadFileConfigList[package].time);
end

--[[--
--删除下载队列信息
--]]
function deleteDownloadFileConfig(package)
	Common.log("删除下载队列信息 =============== package == "..package);
	if Common.platform == Common.TargetAndroid then
		--Android平台只允许下载一个
		downloadFileConfigList = {};
	else
		downloadFileConfigList[package] = nil;
	end

	--检测小游戏列表数据
	logicMiniGameListVersion();
end

--当前正在解压的文件包名
local unzipFilePackageName = nil;

--[[--
-- 判断下载文件信息(会触发解压提示)
-- ]]
function logicDowloadFileDone()
	if GameLoadModuleConfig.getLoadModuleGameID() ~= 0 then
		--当前在游戏牌桌中
		--Common.log("当前在游戏牌桌中 ======= getLoadModuleGameID() ====== "..GameLoadModuleConfig.getLoadModuleGameID());
		return;
	end

	if unzipFilePackageName ~= nil then
		Common.log("有文件正在解压更新 ============= "..unzipFilePackageName);
		return;
	end

	if downloadFileConfigList == nil or next(downloadFileConfigList) == nil then
		return;
	end

	for package, info in pairs(downloadFileConfigList) do
		local type = info.type;
		local time = info.time;
		--Common.log("package ========== "..package);
		--Common.log("type ========== "..type);
		if type == DOWNLOAD_DONE then
			if package == MainScriptPackage then
				unzipFilePackageName = MainScriptPackage;
				showUnzipLuaPrompt();
			else
				unzipFileByPackage(package);
			end
			return true;
		end
	end
	return false;
end

--[[--
-- 解压
-- ]]
function unzipFileByPackage(package)
	unzipFilePackageName = package;
	local DocumentPath = CCFileUtils:sharedFileUtils():getWritablePath();
	--Common.log("DocumentPath ==== "..DocumentPath);
	local DownloadFilePath = DocumentPath.."LoadScript/downLoad/"..package..".zip";
	Common.log("DownloadFilePath ==== "..DownloadFilePath);
	if Load.isFilePathExist(DownloadFilePath) then
		--文件存在
		upZipDownloadFile(package);
	end
end

--[[--
--脚本更新结束回调
--]]
local function luaUpdateDoneCallBack(callbackData)
	CommDialogConfig.closeProgressDialog();

	local type = "";
	local zipFileName = "";

	if Common.platform == Common.TargetIos then
		--IOS
		type = callbackData.type;
		--zipFileName = callbackData.zipFileName;
		zipFileName = unzipFilePackageName;
	elseif Common.platform == Common.TargetAndroid then
		--Android
		--返回数据格式:type#zipFileName
		local i, j = string.find(callbackData, "#");
		type = string.sub(callbackData, 1, i - 1);
		zipFileName = string.sub(callbackData, j + 1, -1);
	end

	Common.log("脚本更新完成  type ========= "..type);
	Common.log("zipFileName ======== "..zipFileName);

	if zipFileName ~= unzipFilePackageName then
		Common.log("解压文件不符 ============ ");
		return;
	else
		deleteDownloadFileConfig(unzipFilePackageName);
		unzipFilePackageName = nil;--重置解压标示
	end

	if type == "Success" then
		--更新成功
		if zipFileName == MainScriptPackage then
			--主版本更新成功

			--重载游戏代码
			LuaUpdateConsole.reLoadAllLua();
		else
			--小游戏版本更新成功

			--检测小游戏列表数据
			logicMiniGameListVersion();
			--加载小游戏脚本代码
			GameLoadModuleConfig.loadMiniGameByPackage(zipFileName, true);
		end
	elseif type == "Error" then
		--更新失败
		--需要处理解压文件失败的逻辑
		if zipFileName == MainScriptPackage then
			--主版本更新失败

			--强制清除游戏包外代码
			LuaUpdateConsole.disposeOutsideScript(true);
			--重载游戏代码
			LuaUpdateConsole.reLoadAllLua();
		else
			--小游戏版本更新失败

			--强制清除小游戏包外代码
			LuaUpdateConsole.deleteMiniGameByPackage(zipFileName);
			--加载小游戏脚本代码
			GameLoadModuleConfig.loadMiniGameByPackage(zipFileName, true);
		end
	end

end

--[[--
--解压脚本
--]]
function upZipDownloadFile(gamePackage)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			zipFileName = gamePackage,
			updateDoneCallback = luaUpdateDoneCallBack,
		}
		luaoc.callStaticMethod("ScriptUpdate", "logicLuaUpdateFile", args)

	elseif Common.platform == Common.TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.LuaUpdateConsole"
		local javaMethodName = "logicLuaUpdateFile"
		local javaParams = {
			gamePackage,
			luaUpdateDoneCallBack,
		};
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--lua更新主版本游戏
--]]
function startDownloadLuaScriptZip(zipUrl, package)
	Common.log("zipUrl ====== "..zipUrl);
	Common.log("package ====== "..package);
	if getDownloadFileConfig(package) ~= nil then
		if package == MainScriptPackage then
			--主版本不提示toast
			return;
		end
		Common.showToast("文件正在下载中...", 3);
		return;
	end

	LuaUpdateMiniGameUIConfig.updateMiniGameListUI(package, 0, 100);

	setDownloadFileConfig(package, DOWNLOAD_APPLY);

	DownloadControler.getDownloadLuaUpdateFile(zipUrl, package, LuaUpdateMiniGameUIConfig.showMiniGameDownloadProgress);
end

--[[--
-- 显示小游戏脚本更新提示
-- ]]
function showMiniGameLuaUpdatePrompt(downloadState, miniGameID, package)
	if downloadState == 1 then
		--1：需要下载
		mvcEngine.createModule(GUI_MINILUAUPDATE);
		MiniLuaUpdateLogic.setMiniLuaUpdateType(MiniLuaUpdateLogic.getMiniLuaUpdateType().DOWNLOAD, miniGameID, package);
	elseif downloadState == 2 then
		--2：可以更新
		mvcEngine.createModule(GUI_MINILUAUPDATE);
		MiniLuaUpdateLogic.setMiniLuaUpdateType(MiniLuaUpdateLogic.getMiniLuaUpdateType().UPDATE, miniGameID, package);
	elseif downloadState == 3 then
		--3：强制更新
		mvcEngine.createModule(GUI_MINILUAUPDATE);
		MiniLuaUpdateLogic.setMiniLuaUpdateType(MiniLuaUpdateLogic.getMiniLuaUpdateType().FORCE_UPDATE, miniGameID, package);
	end
end

--[[--
--显示解压lua脚本提示框
--]]
function showUnzipLuaPrompt()
	if not mvcEngine.logicModuleIsShow(GUI_MAINLUAUPDATE) then
		mvcEngine.createModule(GUI_MAINLUAUPDATE);
		MainLuaUpdateLogic.setLuaUpdateType(MainLuaUpdateLogic.getLuaUpdateType().UNZIP);
	end
end

--[[--
--显示IOS跳转下载提示框
--]]
function showIOSUpdatePrompt(type)
	mvcEngine.createModule(GUI_MAINLUAUPDATE);
	MainLuaUpdateLogic.setLuaUpdateType(type);
end

--存储关闭更新时间戳
function setCloseUpdateTime()
	local updateTimeTable = {}
	updateTimeTable["closeTime"] = os.time()
	Common.SaveTable("updateTimeTable", updateTimeTable)
end

--通过时间戳检测是否可以显示升级页面
function checkShowUpdateView()
	local updateTimeTable = Common.LoadTable("updateTimeTable")
	if updateTimeTable == nil or updateTimeTable.closeTime == nil then
		return true
	end
	if os.time() - tonumber(updateTimeTable.closeTime) >= 7200 then
		return true
	else
		return false
	end
end

--[[--
--显示版本升级提示
--]]
function showVersionPrompt()
	local dataTable = profileCommon.Version.getAppVersionTable()
	if dataTable ~= nil then
		Common.log("**********************显示版本升级提示")
		if Common.platform == Common.TargetIos then
			-- …updateType byte 升级方案0不升级1建议升级2强制升级3需要安装
			if dataTable.updateType == 0 then
				--不升级
				if profileCommon.Version.getUserInitiative() then
					Common.showToast("您当前是最新版本，无需更新！", 2);
				end
			elseif dataTable.updateType == 2 then
				--强制升级
				showIOSUpdatePrompt(MainLuaUpdateLogic.getLuaUpdateType().UPDATE_FORCE_NATIVE_IOS);
			else
				--提示升级
				if checkShowUpdateView() then
					showIOSUpdatePrompt(MainLuaUpdateLogic.getLuaUpdateType().UPDATE_NATIVE_IOS);
				end
			end
		elseif Common.platform == Common.TargetAndroid then
			local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
			local javaMethodName = "downAppUpdate"
			local javaParams = {
				dataTable.isUserInitiative,
				dataTable.updateType,
				dataTable.updateTxt,
				dataTable.updataAwardTxt,
				dataTable.updateAppSizeTxt,
				dataTable.NotificationTxt,
				dataTable.updateUrl,
			}
			luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
			Common.log("**********************显示版本升级提示" .. dataTable.gameName)
		end
	end
	profileCommon.Version.setUserInitiative(false);
end

--[[--
--显示脚本升级提示
--]]
function showMainScriptUpdatePrompt()
	Common.log("**********************显示脚本升级提示")
	local ScriptUpdate = GameCommonProfile.LuaScriptUpdate.getMainScriptUpdateData();
	--升级方案
	Common.log("脚本版本名 == "..ScriptUpdate["ScriptVerName"])
	--updateType	byte	升级方案	0、不升级 1、后台升级(wifi、2G下均后台升级) 2、需要上传客户端资源文件MD5列表
	Common.log("升级方案 0、不升级 1、后台升级(wifi、2G下均后台升级) 2、需要上传客户端资源文件MD5列表 == "..ScriptUpdate["updateType"]);
	Common.log("升级提示 == "..ScriptUpdate["updataTxt"]);
	Common.log("脚本升级Url地址 == "..ScriptUpdate["ScriptUpdateUrl"]);


	local function callBackMainScriptUpdate()
		if ScriptUpdate["updateType"]  == 0 then
		--0、不升级
		elseif ScriptUpdate["updateType"]  == 1 then
			--1、后台升级(wifi、2G下均后台升级)
			startDownloadLuaScriptZip(ScriptUpdate["ScriptUpdateUrl"], MainScriptPackage);
		elseif ScriptUpdate["updateType"]  == 2 then
			--2、需要上传客户端资源文件MD5列表
			pushFlieMD5List({MainScriptPackage});
		elseif ScriptUpdate["updateType"]  == 3 then
			--3、强制更新
			mvcEngine.createModule(GUI_MAINLUAUPDATE);
			MainLuaUpdateLogic.setLuaUpdateType(MainLuaUpdateLogic.getLuaUpdateType().FORCE_UPDATE_LUA, ScriptUpdate["ScriptUpdateUrl"]);
		end
	end
	if ScriptUpdate["updateType"]  == 2 then
		loadGameConfig.delayDoFunc(callBackMainScriptUpdate, 8);
	else
		callBackMainScriptUpdate();
	end
end

--[[--
--小游戏脚本检测
--]]
function showMiniGameScriptUpdatePrompt()

	local MiniGameScriptUpdate = GameCommonProfile.LuaScriptUpdate.getMiniGameLuaUpdateData();
	local miniGamePushList = {};
	--MiniGameList	Loop Loop
	for i = 1, #MiniGameScriptUpdate["MiniGameList"] do
		--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
		local MiniGameID = MiniGameScriptUpdate["MiniGameList"][i].MiniGameID;
		--Common.log("MiniGameID == "..MiniGameID);
		--…MiniGamePackage	Text	小游戏的包名
		local MiniGamePackage = MiniGameScriptUpdate["MiniGameList"][i].MiniGamePackage;
		Common.log("MiniGamePackage == "..MiniGamePackage);
		--…downloadState	byte	小游戏下载更新状态	0：无需下载 1：需要下载 2：可以更新 3：强制更新 4：需要上传客户端资源文件MD5列表
		local downloadState = MiniGameScriptUpdate["MiniGameList"][i].downloadState;
		Common.log("小游戏下载更新状态	0：无需下载 1：需要下载 2：可以更新 3：强制更新 4：需要上传客户端资源文件MD5列表 == "..downloadState);
		--…downloadUrl	text	下载(更新)地址	差异化升级
		local downloadUrl = MiniGameScriptUpdate["MiniGameList"][i].downloadUrl;
		Common.log("downloadUrl == "..downloadUrl);
		--…downloadMsgTxt	text	下载提示文字
		local downloadMsgTxt = MiniGameScriptUpdate["MiniGameList"][i].downloadMsgTxt;
		--Common.log("downloadMsgTxt == "..downloadMsgTxt);

		if downloadState == 0 then
		--0：无需下载
		elseif downloadState == 1 then
		--1：需要下载
		--startDownloadLuaScriptZip(downloadUrl, MiniGamePackage);
		elseif downloadState == 2 then
		--2：可以更新
		--startDownloadLuaScriptZip(downloadUrl, MiniGamePackage);
		elseif downloadState == 3 then
		--3：强制更新
		--startDownloadLuaScriptZip(downloadUrl, MiniGamePackage);
		elseif downloadState == 4 then
			--4：需要上传客户端资源文件MD5列表
			table.insert(miniGamePushList, MiniGamePackage);
		end
	end

	local function callBackMiniGameScriptUpdate()
		if #miniGamePushList > 0 then
			Common.log("#miniGamePushList ======== "..#miniGamePushList);
			pushFlieMD5List(miniGamePushList);
		end
	end
	if #miniGamePushList > 0 then
		loadGameConfig.delayDoFunc(callBackMiniGameScriptUpdate, 8);
	end
	MiniGameLayer.initMiniGameList(MiniGameLayer.isLoadDefultList);
end

--[[--
--检测主游戏脚本升级
--]]
function checkScriptVersion()
	if GameConfig.isCheckScript then
		--已经检测过
		return
	end
	Common.log("checkScriptVersion =========== ");
	if Load.logicScriptInSD() --[[-- and CommDialogConfig.getNewUserGiudeFinish()--]] then
		--复制完脚本&&完成新手引导
		Common.log("复制完脚本&&完成新手引导 =========== ");
		--脚本升级检测
		local mainAppMD5 = LuaUpdateConsole.getAllFlieListMD5(MainScriptPackage);
		if mainAppMD5 ~= nil then
			GameConfig.isCheckScript = true;
			sendMANAGERID_LUA_SCRIPT_VERSION_V3(mainAppMD5);
		end
	end
end

--[[--
--检测小游戏脚本升级
--]]
local function checkMiniGameScriptVersion(miniGameList)
	Common.log("checkMiniGameScriptVersion =========== ");
	if Load.logicScriptInSD() then
		--复制完脚本&&完成新手引导
		Common.log("小游戏复制完脚本 =========== ");
		--		for i = 1, #miniGameList do
		--			--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
		--			Common.log("MiniGameID == "..miniGameList[i].MiniGameID);
		--			--…MiniGamePackage	Text	小游戏的包名
		--			Common.log("MiniGamePackage == "..miniGameList[i].MiniGamePackage);
		--			--…ReleaseDate	Int	小游戏的发布日期	16/11/18：161118 客户端无数据则传-1
		--			Common.log("ReleaseDate == "..miniGameList[i].ReleaseDate);
		--			--…MiniGameMD5	Text	小游戏的MD5	客户端无数据则传空字符串
		--			Common.log("MiniGameMD5 == "..miniGameList[i].MiniGameMD5);
		--		end
		--小游戏脚本升级检测
		sendMANAGERID_MINIGAME_LUA_UPDATE(miniGameList);
	end
end

--[[--
--检测小游戏列表数据
-- ]]
function logicMiniGameListVersion()
	if Load.logicScriptInSD() then
		Common.log("检测小游戏列表数据=====================");
		local MiniGameFileMD5ListTable = LuaUpdateConsole.getNativeFileMD5ListConfig();
		local miniGameList = {};
		for Package, PackageConfig in pairs(MiniGameFileMD5ListTable) do
			--Common.log(Package .. " =======AllListMD5====== " .. PackageConfig.AllListMD5);
			--Common.log(Package .. " =======FileMD5List====== " .. PackageConfig.FileMD5List);
			local miniGameConfig = {};
			--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
			miniGameConfig.MiniGameID = -1;
			--…MiniGamePackage	Text	小游戏的包名
			miniGameConfig.MiniGamePackage = Package;
			--Common.log("MiniGamePackage == "..miniGameConfig.MiniGamePackage);
			--…ReleaseDate	Int	小游戏的发布日期	16/11/18：161118 客户端无数据则传-1
			local AllListMD5, MiniGameVersion = LuaUpdateConsole.getAllFlieListMD5(miniGameConfig.MiniGamePackage, PackageConfig.AllListMD5);
			if AllListMD5 ~= nil and MiniGameVersion ~= nil then
				miniGameConfig.ReleaseDate = MiniGameVersion;
				--Common.log("ReleaseDate == "..miniGameConfig.ReleaseDate);
				--…MiniGameMD5	Text	小游戏的MD5	客户端无数据则传空字符串
				miniGameConfig.MiniGameMD5 = AllListMD5;
			--Common.log("MiniGameMD5 == "..miniGameConfig.MiniGameMD5);
			end
			table.insert(miniGameList, miniGameConfig);
		end
		checkMiniGameScriptVersion(miniGameList);
	end
end

--[[--
--上传MD5列表
--]]
function pushFlieMD5List(packageList)
	if lookTimer ~= nil then
		--当前有文件正在上传
		return;
	end

	if packageList[1] == nil then
		--MD5列表已经没有数据
		return;
	end

	local package = packageList[1];
	local MiniGameFileMD5ListTable = LuaUpdateConsole.getNativeFileMD5ListConfig();
	local AllListMD5Path = "";
	local FileMD5ListPath = "";
	if MiniGameFileMD5ListTable[package] == nil and package ~= MainScriptPackage then
		Common.log("传MD5列表 ======== " .. package .. "数据错误");
		return;
	end

	if package ~= MainScriptPackage then
		AllListMD5Path = MiniGameFileMD5ListTable[package].AllListMD5;
		FileMD5ListPath = MiniGameFileMD5ListTable[package].FileMD5List;
	end

	local AllListMD5, MiniGameVersion = LuaUpdateConsole.getAllFlieListMD5(package, AllListMD5Path);
	if AllListMD5 ~= nil and MiniGameVersion ~= nil --[[--and not Load.isDebugState() ]] then
		--可以找到合集MDE and 不是debug模式
		Common.log("开始上传MD5文件列表");
		local MD5List = {};
		if package == MainScriptPackage then
			--主游戏脚本
			MD5List = Load.readfileForLineFromSharedFile(Load.getScriptDirectory() .. package .. "_FileMD5List.data");
		else
			--小游戏脚本
			MD5List = Load.readfileForLineFromSharedFile(FileMD5ListPath);
		end

		if #MD5List > 0 then
			--切割table数据，重新分配table
			local MAX = 30;
			local FileListTable = {};
			local index = -1;
			local function allotMD5List()
				--Common.log("allotMD5List ============== index == "..index)
				FileListTable[index + 1] = {}
				if (index + 1) * MAX >= #MD5List then
					for i = 1 + index * MAX, #MD5List do
						local begin, after = string.find(MD5List[i], "###")
						local FileMD5Data = {}
						FileMD5Data.FileAbsolutePath = string.sub(MD5List[i], 1, begin - 1)
						FileMD5Data.FileMd5 = string.sub(MD5List[i], after + 1, -1)
						--Common.log("FileMD5Data.FileAbsolutePath ========== "..FileMD5Data.FileAbsolutePath)
						--Common.log("FileMD5Data.FileMd5 ========== "..FileMD5Data.FileMd5)
						table.insert(FileListTable[index + 1], FileMD5Data);
					end
				else
					for i = 1 + index * MAX, (index + 1) * MAX do
						local begin, after = string.find(MD5List[i], "###")
						local FileMD5Data = {}
						FileMD5Data.FileAbsolutePath = string.sub(MD5List[i], 1, begin - 1)
						FileMD5Data.FileMd5 = string.sub(MD5List[i], after + 1, -1)
						--Common.log("FileMD5Data.FileAbsolutePath ========== "..FileMD5Data.FileAbsolutePath)
						--Common.log("FileMD5Data.FileMd5 ========== "..FileMD5Data.FileMd5)
						table.insert(FileListTable[index + 1], FileMD5Data);
					end
				end
			end

			while (index + 1) * MAX < #MD5List do
				index = index + 1;
				allotMD5List();
			end

			local BatchNum = Common.getNativeTimeStamp();
			Common.log("BatchNum ========== "..BatchNum)
			Common.log("getFlieMD5ListMD5() ========== "..AllListMD5)
			Common.log("#MD5List ========== "..#MD5List)
			Common.log("#FileListTable ========== "..#FileListTable)

			local ListIndex = 0
			local function sendFlieMD5List()
				if ListIndex < #FileListTable then
					ListIndex = ListIndex + 1;
					Common.log("#FileListTable ============ "..ListIndex)
					if package == MainScriptPackage then
						--主游戏脚本
						sendMANAGERID_LUA_FILE_PATH_UP(BatchNum, AllListMD5, #MD5List, FileListTable[ListIndex]);
					else
						--小游戏脚本
						sendMANAGERID_MINIGAME_LUA_FILE_PATH_UP(BatchNum, AllListMD5, #MD5List, FileListTable[ListIndex], MiniGameVersion, package);
					end
				else

					Common.log(package .. "目录下上传MD5文件列表结束 ========== ")
					table.remove(packageList, 1);
					CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer);
					lookTimer = nil;

					if #packageList > 0 then
						pushFlieMD5List(packageList);
					else
						Common.log("所有MD5文件列表上传结束 ========== ")
					end
				end
			end
			if lookTimer == nil then
				--定时器
				lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(sendFlieMD5List, 0.1 ,false);
			end
		end
	else
		Common.log("不合符上传MD5文件列表条件");
	end
end
