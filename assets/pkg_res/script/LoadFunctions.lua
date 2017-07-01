module("Load", package.seeall)

local cjson = require("cjson");

--[[--
--从Assets卡获取脚本数据
--]]
function getScriptDataFromAssets(key)
	if platform == TargetIos then
		--ios平台
		return "";
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getScriptDataFromAssets"
		local javaParams = {
			key
		};
		local ok, ScriptData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		return ScriptData;
	end
end

--Android包名前缀
AndroidPackage = "org.shuashuaent.client";
--App名称
APP_NAME = "";
--Android应用包名
AndroidPackageName = "";

TargetWindows = "windows";
TargetIos = "ios";
TargetAndroid = "android";
--平台类型
platform = "";
--国际版APP标示: 1国际版;0国内版
local mnGlobalApp = 0;

--应用本地目录
writablePath = CCFileUtils:sharedFileUtils():getWritablePath()

local sharedApplication = CCApplication:sharedApplication()
local target = sharedApplication:getTargetPlatform()
if target == kTargetWindows then
	platform = TargetWindows
elseif target == kTargetAndroid then
	require("script.framework.utils.Luaj")
	platform = TargetAndroid
elseif target == kTargetIphone or target == kTargetIpad or target == kTargetMacOS then
	require("script.framework.utils.Luaoc")
	platform = TargetIos
end

--[[--
数据转json
@param #table tab table数据
@return #json 转换后的json数据
]]
local function encode(tab)
	local status, result = pcall(cjson.encode, tab)
	if status then return result end
end

--[[--
json转数据
@param #json jsonData json数据
@return #table 转换后的table数据
]]
local function decode(jsonData)
	local status, result = pcall(cjson.decode, jsonData)
	if status then
		return result;
	end
end

--[[--
-- 读取json数据
-- ]]--
function getJsonData(fileDir, fileName)
	local path = CCFileUtils:sharedFileUtils():fullPathForFilename(fileDir .. fileName);
	--Common.log("path =========== ".. path);
	local fileExist = CCFileUtils:sharedFileUtils():isFileExist(path);
	if fileExist then
		local file = io.open(path, "r");
		local table = nil;
		if file ~= nil then
			assert(file);
			local readjson = file:read("*a"); -- 读取所有内容
			--Common.log(readjson);
			table = decode(readjson); --转成原来存储前的格式
			file:close();
		end
		if type(table) ~= "table" then
			return nil;
		end
		return table;
	else
		log("getJsonData 文件 ==== "..path.." 不存在");
		return nil;
	end
end

--[[--
--是否是国际版APP
--]]
function isGlobalApp()
	if mnGlobalApp == nil or mnGlobalApp == "" then
		--无配置数据
		return false
	end
	--    log("mnGlobalApp === "..mnGlobalApp);
	if mnGlobalApp == "1" then
		return true
	end
	return false;
end

function setGlobalApp(globalApp)
	mnGlobalApp = globalApp;
end

if platform == TargetAndroid then
	APP_NAME = getScriptDataFromAssets("AppName");
	AndroidPackageName = getScriptDataFromAssets("AndroidPackageName");
	local globalApp = getScriptDataFromAssets("GlobalApp");
	setGlobalApp(globalApp);
else
	local scriptConfig = getJsonData("", "scriptConfig.json");
	APP_NAME = scriptConfig.AppName;
	AndroidPackageName = scriptConfig.AndroidPackageName;
	local globalApp = scriptConfig.GlobalApp;
	setGlobalApp(globalApp);
end

local isDeBug = true--当前是否是debug状态

isOutPutLog = false--是否打印lua日志

local LuaLogFile;
local LuaLogFileName = APP_NAME .. "_" .. os.date("%Y").."_"..os.date("%m").."_"..os.date("%d").."_".. os.date("%H").."_"..os.date("%M").."_"..os.date("%S");

local function outputLuaLog(text)
	if isOutPutLog then
		if LuaLogFile ~= nil then
			LuaLogFile:write(os.date("%X", os.time()) .. " : " .. text .. "\n");
		--LuaLogFile:close();
		end
	else
		if LuaLogFile ~= nil then
			LuaLogFile:close();
			LuaLogFile = nil;
		end
	end
end

--[[--
--打印log日志
--]]
function log(text)
	if isDeBug then
		print(text);
		outputLuaLog(text.."<br>");
	end
end

log("writablePath ==== "..writablePath);
log("LuaLogFileName === "..LuaLogFileName)
log("APP_NAME === "..APP_NAME)
log("AndroidPackageName === "..AndroidPackageName)

--[[--
--是否是debug模式
--]]
function isDebugState()
	return isDeBug
end

--[[--
-- left左移num位
-- ]]
function leftShiftOp(left, num)
	return left * (2 ^ num)
end

--[[--
-- right右移num位
-- ]]
function rightShiftOp(left,num)
	return math.floor(left / (2 ^ num))
end

--[[--
--获得应用版本号(不带渠道号)
--@return #number 应用版本号
--]]
local function getVersionCode(mVersionName)

	local versionName = mVersionName;
	local versionName, num = string.gsub(versionName, "%.", "#");
	--log("versionName ======= "..versionName);
	local i, j = string.find(versionName, "#");
	local version1 = tonumber(string.sub(versionName, 1, i-1));
	local version2 = tonumber(string.sub(versionName, j+1, -1));
	--log("version1  =============== "..version1);
	--log("version2  =============== "..version2);
	local code = leftShiftOp(version1, 24) + leftShiftOp(version2, 16);
	--log("code  =============== "..code);

	return code;
end

--[[--
-- 判断脚本文件是否已经复制到SD卡中
-- @return true:已经在sd卡中
--]]--
function logicScriptInSD()
	--脚本配置信息文件：包内目录在根目录,包外在cached_res文件夹下
	local filePath = Load.getScriptDirectory();
	--获取包外脚本信息配置
	local externalScriptConfig = getJsonData(filePath, "scriptConfig.json");
	if externalScriptConfig ~= nil then
		--包外存在版本信息
		local nativeScriptConfig = getJsonData("", "scriptConfig.json");
		local nativeScriptVerName = "";
		if platform == TargetAndroid then
			nativeScriptVerName = getScriptDataFromAssets("ScriptVerName");
		else
			nativeScriptVerName = nativeScriptConfig.ScriptVerName;
		end
		local externalVerCode = getVersionCode(externalScriptConfig.ScriptVerName);
		local nativeVerCode = getVersionCode(nativeScriptVerName);
		if (nativeVerCode <= externalVerCode) then
			log("logicScriptInSD ======= 包外存在版本信息,可以使用包外代码");
			return true;
		else
			log("logicScriptInSD ======= 包外存在版本信息,依然使用包内代码,包外代码版本号低");
			return false;
		end
	else
		--包外没有版本信息
		log("logicScriptInSD ======= 包外没有版本信息,使用包内代码");
		return false;
	end
end

--[[--
--添加脚本搜索路径
-- ]]--
function addScriptSearchPath()
	if platform == TargetIos then
		--ios平台
		local ok, LoadSDScript = luaoc.callStaticMethod("ScriptUpdate","addIOSSearchPath");
	elseif platform == TargetAndroid then
		--android平台
		local path = Load.getTrendsSaveFilePath("LoadScript") .. "?.lua";
		package.path = package.path..";"..path;
		CCFileUtils:sharedFileUtils():addSearchPath(Load.getTrendsSaveFilePath("LoadScript"));
	end
end

--[[--
--得到写文件的路径()
--@param #string dir 目录,有子文件夹格式：xxxx/，无：""
--@return #string 文件的路径
--]]
function getTrendsSaveFilePath(dir)
	if platform == TargetIos then
		--ios平台
		return dir
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getTrendsSaveFilePath"
		local javaParams = { dir }
		local javaMethodSig = "(Ljava/lang/String;)Ljava/lang/String;"
		local ok, path = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("path === " .. path)
			return path
		else
			return ""
		end
	end
end

ScriptDirectory = "";--脚本加载路径

--[[--
--获取脚本在游戏包外的路径
--]]
function getScriptDirectory()
	if ScriptDirectory ~= nil and ScriptDirectory ~= "" then
		--log("ScriptDirectory ======= "..ScriptDirectory);
		return ScriptDirectory;
	end
	if platform == TargetIos then
		--ios平台
		local args = {
			}
		local ok, ret = luaoc.callStaticMethod("ScriptUpdate", "getScriptDirectory", args)
		if ok then
			ScriptDirectory = ret["scriptDirectory"].."/";
		end
	elseif platform == TargetAndroid then
		--android平台
		ScriptDirectory = getTrendsSaveFilePath("LoadScript/LuaScript");
	end

	if ScriptDirectory == nil or ScriptDirectory == "" then
		ScriptDirectory = "Error/"
	end
	--log("获取脚本在游戏包外的路径 ScriptDirectory ======= "..ScriptDirectory);

	return ScriptDirectory;
end

--[[--
-- 获取应用缓存文件夹路径
--]]
function getIOSCachesDirectoryPath(fileName)
	if platform == TargetIos then
		--ios平台
		local args = {
			fileName = fileName,
		}
		local ok, path = luaoc.callStaticMethod("Helper", "getCachesDirectoryPath", args);
		return path;
	end
end

--[[--
-- 获取应用关键(本地)文件夹路径
--]]
function getIOSDocumentDirectoryPath(fileName)
	if platform == TargetIos then
		--ios平台
		local args = {
			fileName = fileName,
		}
		local ok, path = luaoc.callStaticMethod("Helper", "getDocumentDirectoryPath", args);
		log("getIOSDocumentDirectoryPath path ====== "..path);
		return path;
	end
end

--[[--
--判断文件是否存在
--]]
function isFilePathExist(filePath)
	local fullPath = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath);
	--log("isFilePathExist fullPath ========== "..fullPath);
	local fileExist = CCFileUtils:sharedFileUtils():isFileExist(fullPath);
	return fileExist;
end

isReLoadLua = false;

function require_ex(_mname)
	if isReLoadLua then
		if package.loaded[_mname] ~= nil then
			--Load.log(string.format("require_ex module[%s] reload", _mname))
			package.loaded[_mname] = nil
		end
		--Load.log(string.format("require_ex = %s", _mname))
	end
	return require(_mname)
end

--[[--
--加载lua文件(加载游戏包外的文件时需要修改)
--]]
function LuaRequire(luaFilePath)

	local filePath = nil;

	--非debug模式
	filePath = luaFilePath;
	filePath = string.gsub(filePath, "%.", "/");
	filePath = getScriptDirectory() .. filePath;
	--log("filePath === "..filePath);
	if isFilePathExist(filePath .. ".lua") then
		if package.loaded[luaFilePath] ~= nil then
			--Load.log(string.format("require_ex module[%s] reload", luaFilePath))
			package.loaded[luaFilePath] = nil
		end
		log("存在 包外 LuaRequire filePath =========" .. filePath .. ".lua");
		return require_ex("LuaScript."..luaFilePath);
	else
	--log("不存在 包外 LuaRequire filePath ========="..filePath);
	end

	filePath = luaFilePath;
	filePath = string.gsub(filePath, "%.", "/");
	if isFilePathExist(filePath .. ".lua") then
		--log("存在 包内 LuaRequire filePath ========="..filePath);
		return require_ex(luaFilePath);
	else
	--log("不存在 包内 LuaRequire filePath ========="..filePath);
	end
end

--[[--
--获取versionName
--]]
local function getVersionName()
	--脚本配置信息文件：包内目录在根目录,包外在cached_res文件夹下
	local filePath = ""
	if Load.logicScriptInSD() then
		filePath = Load.getScriptDirectory();
	else
		filePath = "";
		if platform == TargetAndroid then
			return Load.getScriptDataFromAssets("ScriptVerName");
		end
	end

	local scriptConfig = Load.getJsonData(filePath, "scriptConfig.json");
	if scriptConfig ~= nil then
		return scriptConfig.ScriptVerName;
	else
		return "";
	end
end

--[[--
--获取客户端所有小游戏分支发布日期
--]]
local function getAllMiniGameReleaseDate()
	local mAllMiniGameReleaseDate = "";

	if Load.logicScriptInSD() then
		Common.log("检测小游戏列表数据=====================");
		local MiniGameFileMD5ListTable = LuaUpdateConsole.getNativeFileMD5ListConfig();
		for Package, PackageConfig in pairs(MiniGameFileMD5ListTable) do
			--Common.log(Package .. " =======AllListMD5====== " .. PackageConfig.AllListMD5);
			--Common.log(Package .. " =======FileMD5List====== " .. PackageConfig.FileMD5List);
			local miniGameConfig = "";
			local ReleaseDate = "";
			local AllListMD5, MiniGameVersion = LuaUpdateConsole.getAllFlieListMD5(Package, PackageConfig.AllListMD5);
			if AllListMD5 ~= nil and MiniGameVersion ~= nil then
				ReleaseDate = MiniGameVersion;
				Common.log("ReleaseDate == "..ReleaseDate);
			end
			miniGameConfig = " ["..Package.."_".. ReleaseDate .. "] ";
			mAllMiniGameReleaseDate = mAllMiniGameReleaseDate .. miniGameConfig;
		end
	end

	return mAllMiniGameReleaseDate;
end

--[[--
--上传lua错误日志
--]]
function catchDebugInfo(debugMsg, debugInfo)

	debugMsg = getVersionName() .. debugMsg;

	local i, j = string.find(debugInfo, "\n", 18);
	if i > 0 and j > 0 then
		--前两行数据清除
		debugInfo = string.sub(debugInfo, j + 1, -1);
	end

	local uploadingInfo = debugMsg .. debugInfo  .. "\n".. getAllMiniGameReleaseDate();

	if isDebugState() then
		if Common ~= nil then
			Common.showDebugInfo(uploadingInfo);
		end
	else
		--上传lua错误日志
		if buglySetUserId ~= nil then
			buglySetUserId(profile.User.getSelfUserID());
		end

		if buglyReportLuaException ~= nil then
			--添加Bugly的Lua异常上报
			buglyReportLuaException(debugMsg, debugInfo);
		end
	end
end

--[[--
--设置lua日志输出配置
--]]
function setLuaLogConfig()
	if isDeBug and isOutPutLog then
		--io.open
		--r  是只读方式打开， 不能写入。
		--w 只写方式打开，不能读取。
		--a 末尾追加。
		--r+ 以读写方式打开，保留原有数据。这个模式是自由度最高的。
		--w+ 以读写方式打开，删除原有数据。就是打开后文件是空文件。
		--a+ 以读写方式打开，保留原有数据，只能在文件末尾添加，不能在文件中间改写数据。
		if platform == TargetIos then
			--ios平台
			LuaLogFile = io.open(getIOSDocumentDirectoryPath("LuaLog/"..APP_NAME) .. "/" .. LuaLogFileName .. ".txt", "a+");
		elseif platform == TargetAndroid then
			--android平台
			LuaLogFile = io.open(getTrendsSaveFilePath("LuaLog/"..APP_NAME) .. LuaLogFileName .. ".txt", "a+");
		end

		if LuaLogFile ~= nil then
			assert(LuaLogFile)
		end
	end
end

--[[--
--按行读取文件并保存到table
--@param #string path 文件路径
--@return #table description
--]]
function readfileForLineFromSharedFile(path)
	local file = io.open(path, "r")
	local dataLineTable = {}
	if file ~= nil then
		for line in file:lines() do
			table.insert(dataLineTable, line);
		end
	else
		log("按行读取文件并保存到 file:lines() ========= nil")
	end
	return dataLineTable;
end