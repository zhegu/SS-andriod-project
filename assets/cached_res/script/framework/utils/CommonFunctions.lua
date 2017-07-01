module("Common", package.seeall)

TargetWindows = "windows"
TargetIos = "ios"
TargetAndroid = "android"

AndroidGamePackage = "com.shuashuaent.client";
kLanguageEnglish = 0
kLanguageChinese = 1
kLanguageTaiwan = 12
kLanguageJapanese = 8

Language_CN = 1 --简体中文
Language_EN = 2 --英文
Language_TW = 3 --繁体中文
Language_JA = 4 --日文
LanguageType = -1; --多语言标示（消息用）
local languagePath = nil; --多语言标示（资源用）
LanguageResCode_CN = "zh_cn"; --简体中文资源目录
LanguageResCode_TW = "zh_tw"; --繁体中文资源目录
LanguageResCode_EN = "en"; --英文资源目录
LanguageResCode_JA = "ja" --日文资源目录
LANGUAGE_RES_FILE = "A_Language.data" --资源目录校验使用的文件，不做其他数据使用

--包体语言表（如包内含有多个语言包资源，按照此表单的优先级顺序使用资源，此表单供开发环境下使用）
LanguageResTable = {
	LanguageResCode_TW,
	LanguageResCode_EN,
	LanguageResCode_CN,
	LanguageResCode_JA,
};

--平台类型
platform = ""

local exitScheduler = nil -- 退出任务
local hasSendOnlineMsg = false; --是否已经发生在线时长消息

local batteryLevel = -1--电池电量等级

local TYPE_UPLOAD_PHOTO = 1;--用户头像上传
local TYPE_UPLOAD_REAL_PHOTO = 2;--用户真实头像上传

USER_PHOTO_UPLOAD = 1;--用户头像上传
FAMILY_PHOTO_UPLOAD = 2;--家族头像上传

local URL_UPLOAD_USER_PHOTO = "http://db.tongqutongqu.cn/tqAdmin/fileUploadManager!upload.do";--普通头像
local URL_UPLOAD_FAMILY_PHOTO = "http://db.tongqutongqu.cn/tqAdmin/clanPhotoFileUpload!upload.do";--家族头像
local URL_UPLOAD_REAL_PHOTO = "http://db.tongqutongqu.cn/tqAdmin/jhCertPhotoFileUpload!upload.do";--真人头像
if Load.isGlobalApp() then
	URL_UPLOAD_USER_PHOTO = "http://endb.tongqutongqu.cn/tqAdmin/fileUploadManager!upload.do"
end

local sharedApplication = CCApplication:sharedApplication();
local target = sharedApplication:getTargetPlatform();
if target == kTargetAndroid then
	platform = TargetAndroid;
elseif target == kTargetIphone or target == kTargetIpad or target == kTargetMacOS then
	platform = TargetIos;
end

Load.log("platform = ".. platform);

--[[--
--打印log日志
--]]
function log(text)
	Load.log(text)
end

--[[--
--是否是debug模式
--]]
function isDebugState()
	return Load.isDebugState()
end

--[[--
--弹出debug信息框
--]]
function showDebugInfo(info)
	if Load.isDebugState() and CommDialogConfig ~= nil then
		GameCommonConfig.showDebugInfo(info);
	end
end

--[[--
--得到版本编号
--]]
function getScriptVerCode(sVersionCode)
	return getVersionCode(sVersionCode);
end

--[[--
--获取毫秒级别的时间戳
--]]
function getTimeStamp()
	if platform == TargetIos then
		--ios平台
		local ok, ret = luaoc.callStaticMethod("Helper", "getTimeStamp")
		return tonumber(ret)
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getTimeStamp"
		local javaParams = {};
		local ok, ScriptData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		return tonumber(ScriptData);
	end
end

--[[--
--下载存放的路径
--@return
--]]--
function getAppDownloadPath()
	return getTrendsSaveFilePathSD("download");
end

--[[--
--下载应用存放的路径
--@return
--]]--
function getSavePath()
	local ScriptFilePath = "download"
	if platform == TargetIos then
		--ios平台
		return  ScriptFilePath
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getSavePath"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, ScriptFilePath = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			return ScriptFilePath
		else
			return ""
		end
	end
end

--[[--
--得到写文件的路径
--@param #string dir 目录,有子文件夹格式：xxxx/，无：""
--@return #string 文件的路径
--]]--
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
			--log("path === " .. path)
			return path
		else
			return ""
		end
	end
end

--[[--
--得到写文件的路径
--@param #string dir 目录,有子文件夹格式：xxxx/，无：""
--@return #string 文件的路径
--]]--
function getTrendsSaveFilePathSD(dir)
	if platform == TargetIos then
		--ios平台
		return dir
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getTrendsSaveFilePathSD"
		local javaParams = { dir }
		local javaMethodSig = "(Ljava/lang/String;)Ljava/lang/String;"
		local ok, path = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("path === " .. path)
			return path
		else
			return ""
		end
	end
end

--[[--
-- 获取应用缓存文件夹路径(没有此目录则会创建)
--]]
function getIOSCachesDirectoryPath(fileName)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			fileName = fileName,
		}
		local ok, path = luaoc.callStaticMethod("Helper", "getCachesDirectoryPath", args);
		return path;
	end
end

--[[--
-- 获取应用关键(本地)文件夹路径(没有此目录则会创建)
--]]
function getIOSDocumentDirectoryPath(fileName)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			fileName = fileName,
		}
		local ok, path = luaoc.callStaticMethod("Helper", "getDocumentDirectoryPath", args);
		return path;
	end
end

function getAndroidPackagekName()
	if platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getAndroidPackagekName"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, PackagekName = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("PackagekName === " .. PackagekName)
			return PackagekName
		else
			return ""
		end
	end
end

--[[--
--判断文件是否存在
--]]
function isFileExist(dir, fileName)
	local PackagePath = Load.getScriptDirectory().. dir .."/";
	local path = CCFileUtils:sharedFileUtils():fullPathForFilename(PackagePath .. fileName);
	--Common.log("path =========== ".. path);
	local fileExist = CCFileUtils:sharedFileUtils():isFileExist(path);
	if fileExist then
		--已经在包外找到文件
		return fileExist;
	end
	--继续在包外找到文件
	PackagePath = dir .."/";
	local path = CCFileUtils:sharedFileUtils():fullPathForFilename(PackagePath .. fileName);
	--Common.log("path =========== ".. path);
	fileExist = CCFileUtils:sharedFileUtils():isFileExist(path);
	return fileExist;
end

--isFileExist("res/zh_cn", "A_Language.data");
--isFileExist("res/zh_tw", "A_Language.data");
--isFileExist("res/en", "A_Language.data");

--[[--
--获取多语言类型
--]]
function getCurrentLanguageType(type)
	local currLanguageType = Language_JA
	if type == LanguageResCode_TW then
		currLanguageType = Language_TW
	elseif type == LanguageResCode_CN then
		currLanguageType = Language_CN
	elseif type == LanguageResCode_EN then
		currLanguageType = Language_EN
	else
		currLanguageType = Language_JA
	end
	return currLanguageType
end


--[[--
--结合系统语言获取当前app需要使用的语言标示
--]]
function getCurrentAppLanguage()
	if not Load.isGlobalApp() then
		--国内版本无需获取app语言
		--Common.log("国内版本无需获取app语言 ============");
		return "";
	end
	if languagePath ~= nil then
		return languagePath;
	end

	local CurrLanguageType = LanguageResCode_JA
	local systemLanguage = LanguageResCode_JA

	local function getLanguage(sysLanguage)
		--检查包体中是否包含系统语言
		local isHasFileExist = isFileExist("res/"..sysLanguage, LANGUAGE_RES_FILE)

		if isHasFileExist then
			--当前游戏包与系统语言匹配
			local tempDataTable = {}
			local tempDataIndex = 1
			for i = 1, #LanguageResTable do
				local resDir = LanguageResTable[i]
				local fileExist = isFileExist("res/"..resDir, LANGUAGE_RES_FILE)
				--过滤游戏包内的所有语言包包含Language.data文件的
				if fileExist then
					tempDataTable[tempDataIndex] = resDir
					tempDataIndex = tempDataIndex + 1
				end
			end

			local isSame = false;
			for i = 1, #tempDataTable do
				if sysLanguage == tempDataTable[i] then
					--如果包含此文件的表单与系统语言匹配，则使用系统语言
					CurrLanguageType = sysLanguage
					LanguageType = getCurrentLanguageType(sysLanguage)
					isSame = true;
					break;
				end
			end

			if not isSame then
				--如果包含此文件的表单与当前系统语言不匹配，则使用表单的最高优先级的资源目录
				CurrLanguageType = tempDataTable[1]
				LanguageType = getCurrentLanguageType(tempDataTable[1])
			end
		else
			--当前游戏包内不包含此系统语言，按照语言表的优先级使用资源
			for i = 1, #LanguageResTable do
				local resDir = LanguageResTable[i]
				local fileExist = isFileExist("res/"..resDir, LANGUAGE_RES_FILE)
				if fileExist then
					CurrLanguageType = resDir
					LanguageType = getCurrentLanguageType(resDir)
					break;
				end
			end
		end
	end

	if sharedApplication:getTargetPlatform() == kTargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "getCountry"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, countyCode = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			if countyCode == "TW" then
				systemLanguage = LanguageResCode_TW
			elseif countyCode == "CN" then
				systemLanguage = LanguageResCode_CN
			elseif countyCode == "US" or countyCode == "AU" or countyCode == "CA" or countyCode == "NZ" or countyCode == "SG" or countyCode == "GB" then
				systemLanguage = LanguageResCode_EN
			elseif countyCode == "JA" then
				systemLanguage = LanguageResCode_JA
			else
				systemLanguage = countyCode
			end
		end
	else
		local language = sharedApplication:getCurrentLanguage()

		--检查系统语言
		if language == kLanguageChinese then
			systemLanguage = LanguageResCode_CN
		elseif language == kLanguageTaiwan then
			systemLanguage = LanguageResCode_TW
		elseif language == kLanguageEnglish then
			systemLanguage = LanguageResCode_EN
		elseif language == kLanguageJapanese then
			systemLanguage = LanguageResCode_JA
		else
			systemLanguage = language
		end
	end

	getLanguage(systemLanguage)
	Common.log("CurrLanguageType ==== " .. CurrLanguageType);
	languagePath = CurrLanguageType .. "/";
	return languagePath
end

--[[--
--获取资源路径
--@param #string filename --资源文件名
--@return #string path 返回符合平台的资源路径
--]]
function getResourcePath(fileName)
	local filePath = nil;

	--if not isDebugState() then
	filePath = Load.getScriptDirectory() .. "res/" .. getCurrentAppLanguage() .. getCurrentAppLanguage() .. fileName;
	--Common.log("filePath ============== "..filePath);
	if Load.isFilePathExist(filePath) then
		--Common.log("==================加载包外资源")
		return filePath;
	end
	--end

	filePath = "res/" .. getCurrentAppLanguage() .. getCurrentAppLanguage() .. fileName;
	--Common.log("filePath ================== "..filePath)
	if Load.isFilePathExist(filePath) then
		return filePath;
	end
end

local rootDirSize = 3 --基础目录层级 eg：loadModule/poker/PokerRes/

--[[--
--获取脚本路径
--@param #string filename --资源文件名
--@param #number type --0:强制使用国内资源路径； 1:强制使用国际资源路径
--@return #string path 返回符合平台的资源路径
--]]
function getScriptPath(resourceFilePath, type)

	local tempGlobalApp = nil;

	if Load.isGlobalApp() then
		tempGlobalApp = 1;
	else
		tempGlobalApp = 0;
	end

	if type == nil then
		type = 0;
	end

	if tempGlobalApp ~= type then
		Load.setGlobalApp(""..type);
	end


	local fileName = "";
	local fileDir = "";
	if Load.isGlobalApp() then
		local filePathList = FGUtilStringSplit(resourceFilePath, "/");
		--Common.log("#StringList ============= "..#filePathList);
		for i = 1, rootDirSize do
			fileDir = fileDir..filePathList[i].."/";
		end
		--Common.log("fileDir ============= " .. fileDir);
		for i = rootDirSize + 1, #filePathList do
			local temp = ""
			if i ~= #filePathList then
				temp = "/"
			end
			fileName = fileName .. filePathList[i] .. temp
		end
		--Common.log("fileName ============= " .. fileName);

	else
		fileName = resourceFilePath;
		fileDir = "";
	end

	local filePath = nil;

	--if not isDebugState() then
	filePath = Load.getScriptDirectory().."script/" .. fileDir .. getCurrentAppLanguage() .. getCurrentAppLanguage() .. fileName;
	if Load.isFilePathExist(filePath) then
		--Common.log("==================加载包外资源json")
		Load.setGlobalApp(""..tempGlobalApp);
		return filePath;
	end
	--end

	filePath = "script/" .. fileDir .. getCurrentAppLanguage() .. getCurrentAppLanguage() .. fileName;
	--Common.log("filePath ============= " .. filePath);
	--Common.log("fileName ============= " .. fileName);

	if Load.isFilePathExist(filePath) then
		Load.setGlobalApp(""..tempGlobalApp);
		return filePath;
	else
		Common.log("Error filePath 资源不存在============= " .. filePath);
	end
	Load.setGlobalApp(""..tempGlobalApp);
end

--[[--
--获取资源中JSON路径
--@param #string filename --资源文件名
--@return #string path 返回符合平台的资源路径
--]]
function getResourceJsonPath(fileName)
	local filePath = nil;

	--if not isDebugState() then
	filePath = Load.getScriptDirectory() .. "res/" .. getCurrentAppLanguage() .. fileName;
	Common.log("filePath ============== "..filePath);
	if Load.isFilePathExist(filePath) then
		Common.log("==================加载包外资源")
		return filePath;
	end
	--end

	filePath = "res/" .. getCurrentAppLanguage() .. fileName;

	if Load.isFilePathExist(filePath) then
		return filePath;
	end
end

--[[--
--获取脚本中JSON路径
--@param #string filename --资源文件名
--@param #number type --0:强制使用国内资源路径； 1:强制使用国际资源路径
--@return #string path 返回符合平台的资源路径
--]]
function getScriptJsonPath(resourceFilePath, type)
	local tempGlobalApp = nil;

	if Load.isGlobalApp() then
		tempGlobalApp = 1;
	else
		tempGlobalApp = 0;
	end

	if type == nil then
		type = 0;
	end

	if tempGlobalApp ~= type then
		Load.setGlobalApp(""..type);
	end

	local fileName = "";
	local fileDir = "";
	if Load.isGlobalApp() then
		local filePathList = FGUtilStringSplit(resourceFilePath, "/");
		Common.log("#StringList ============= "..#filePathList);
		fileName = filePathList[#filePathList];
		Common.log("fileName ============= " .. fileName);
		fileDir = "";
		for i = 1, #filePathList - 1 do
			fileDir = fileDir..filePathList[i].."/";
		end
		Common.log("fileDir ============= " .. fileDir);
	else
		fileName = resourceFilePath;
		fileDir = "";
	end

	local filePath = nil;

	--if not isDebugState() then
	filePath = Load.getScriptDirectory() .. "script/" .. fileDir .. getCurrentAppLanguage() .. fileName;
	if Load.isFilePathExist(filePath) then
		--Common.log("==================加载包外资源json")
		Load.setGlobalApp(""..tempGlobalApp);
		return filePath;
	end
	--end

	filePath = "script/" .. fileDir .. getCurrentAppLanguage() .. fileName;

	if Load.isFilePathExist(filePath) then
		Load.setGlobalApp(""..tempGlobalApp);
		return filePath;
	end
end

local ScriptVerName = nil;--缓存脚本版本名
--[[--
--获取versionName
--]]
function getVersionName()
	if ScriptVerName ~= nil and ScriptVerName ~= "" then
		Common.log("ScriptVerName =========== "..ScriptVerName);
		return ScriptVerName;
	end
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
		ScriptVerName = scriptConfig.ScriptVerName;
	else
		ScriptVerName = "";
	end
	return ScriptVerName;
end

--[[--
--获得应用版本号(不带渠道号)
--@return #number 应用版本号
--]]
function getVersionCode(mVersionName)
	local versionName = "";
	if mVersionName ~= nil then
		versionName = mVersionName;
	else
		versionName = getVersionName();
	end

	local versionName, num = string.gsub(versionName, "%.", "#");
	--Common.log("versionName ======= "..versionName);
	local VersionTable = FGUtilStringSplit(versionName, "#");
	if VersionTable == nil or next(VersionTable) == nil or #VersionTable ~= 2 then
		ScriptVerName = nil;
		return nil;
	else
		--Common.log("VersionTable[1]  =============== "..VersionTable[1]);
		--Common.log("VersionTable[2]  =============== "..VersionTable[2]);
		local ScriptVerCode = Load.leftShiftOp(VersionTable[1], 24) + Load.leftShiftOp(VersionTable[2], 16);
		--Common.log("code  =============== "..ScriptVerCode);
		return ScriptVerCode;
	end

end

local mnChannelID = -1; --渠道号

--[[--
--获取渠道号
--@return #number 渠道号
]]
function getChannelID()
	if mnChannelID >= 0 then
		return mnChannelID;
	end
	--脚本配置信息文件：包内目录在根目录,包外在cached_res文件夹下
	local filePath = ""
	if Load.logicScriptInSD() then
		filePath = Load.getScriptDirectory();
	else
		filePath = "";
		if platform == TargetAndroid then
			--包内Android数据
			return Load.getScriptDataFromAssets("ChannelID");
		end
	end

	local scriptConfig = Load.getJsonData(filePath, "scriptConfig.json");
	if scriptConfig ~= nil then
		mnChannelID = tonumber(scriptConfig.ChannelID);
		return mnChannelID;
	else
		return 0;
	end
end

--[[--
--获得推荐人ID
--@return #number 应用版本号
--]]
function getIntroducerID()
	return 0;
end

--[[--
--获取IOS系统最新的广告标识符
--]]
function getIDFA()
	if platform == TargetIos then
		--ios平台
		local args = {};
		local ok, SimulateIDFA = luaoc.callStaticMethod("Helper", "getSimulateIDFA", args);
		if ok then
			log("SimulateIDFA ======= "..SimulateIDFA);
			return "T-"..SimulateIDFA;
		else
			return nil;
		end
	else
		return ""
	end
end

--[[--
--IMIE号
--]]
function getImei()
	if platform == TargetIos then
		local oldIDFA = Common.getLocalIDFA();
		if oldIDFA ~= nil then
			log("oldIDFA ======= "..oldIDFA);
			return oldIDFA;
		end

		local IDFA = getIDFA();
		if IDFA ~= nil then
			return IDFA;
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getImei"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, imei = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return imei
		else
			return ""
		end
	end
end

--[[--
--获取本地存储的IDFA
--]]
function getLocalIDFA()
	--本数据库
	local newIDFA = Common.getDataForSqlite(CommSqliteConfig.IOS_APPSTORE_IDFA);
	if newIDFA ~= nil then
		log("newIDFA ======= "..newIDFA);
		return newIDFA;
	end
end

--[[--
--获取需要更新的IMEI
--]]
function getNeedUpdateIMEI()
	if platform == TargetIos then
		--ios平台
		local IDFA = getIDFA();
		if IDFA ~= nil then
			return "ios_"..IDFA.."_null";
		else
			return "";
		end
	elseif platform == TargetAndroid then
		--android平台
		return "";
	end
end

--[[--
--IMIE号和MAC 以html5/android/ios +’_’开头+IMIE_MAC
--@return #string IMIE号和MAC
--]]
function getDeviceInfo()
	if platform == TargetIos then
		--ios平台
		return "ios_" .. Common.getImei() .. "_null";
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getDeviceInfo"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, imei = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("imei === " .. imei)
			return imei
		else
			return ""
		end
	end
end

--[[--
--得到Mac地址
--@return #string Mac地址
--]]
function getMacAddr()
	if platform == TargetIos then
		--ios平台

		local args = {
			userID = "",
		}
		local ok, ret = luaoc.callStaticMethod("Assistant", "macaddress", args)
		if ok then
			if ret ~= nil and ret["macaddress"] ~= nil then
				return ret["macaddress"]
			else
				return ""
			end
		else
			return "imei_test"
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getMacAddr"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, MacAddr = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("MacAddr === " .. MacAddr)
			return MacAddr
		else
			return ""
		end
	end
end

UNKNOWN = 0; --未知
CHINA_MOBILE = 1; -- 移动
CHINA_UNICOM = 2; -- 联通
CHINA_TELECOM = 3; -- 电信

--[[--
--获取运营商类型
--@return #number 运营商
--]]
function getOperater()
	if platform == TargetIos then
		--ios平台
		local args = {}

		local ok , ret = luaoc.callStaticMethod("Assistant", "yunying", args)
		if ok then
			return tonumber(ret["yunying"])
		else
			return ""
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getOperater"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, Operater = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			--log("Operater === " .. Operater)
			return Operater
		else
			return ""
		end
	end
end

NET_WIFI = 1; --wifi
NET_2G = 2;
NET_3G = 3;
NET_4G = 4;
--[[--
--获取设备网络类型
--@return #number 网络类型
--]]
function getConnectionType()
	if platform == TargetIos then
		--ios平台

		local args = {}

		local ok , ret = luaoc.callStaticMethod("Assistant", "getNetType", args)
		if ok then
			return ret["nettype"]
		else
			return ""
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getConnectionType"
		local javaParams = {}
		local javaMethodSig = "()I"
		local ok, ConnectionType = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			log("ConnectionType === " .. ConnectionType)
			return ConnectionType
		else
			return ""
		end
	end
end

--[[--
--得到当前界面是否是横屏
--@return #boolean true:横屏 false:竖屏
--]]
function isLandscape()
	if platform == TargetIos then
		--ios平台
		return true
	elseif platform == TargetAndroid then
		--android平台

		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "isLandscape"
		local javaParams = {}
		local javaMethodSig = "()Z"
		local ok, Landscape = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return Landscape
		else
			return ""
		end
	end
end

--[[--
--获取手机号
--@return #string 手机号
--]]
function getTelephonyNumber()
	if platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		--android平台
		--		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		--		local javaMethodName = "getNumber"
		--		local javaParams = {}
		--		local javaMethodSig = "()Ljava/lang/String;"
		--		local ok, TelephonyNumber = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		--
		--		if ok then
		--			log("TelephonyNumber === " .. TelephonyNumber)
		--			return TelephonyNumber
		--		else
		--			return ""
		--		end
		return ""

	end
end

--[[--
--获取手机型号
--]]
function getModel()
	if platform == TargetIos then
		--ios平台
		local args = {
			}
		local ok, DeviceModel = luaoc.callStaticMethod("Helper", "getCurrentDeviceModel", args)
		if ok then
			log("获取手机型号 DeviceModel === " .. DeviceModel)
			return DeviceModel;
		else
			local sharedApplication = CCApplication:sharedApplication()
			local target = sharedApplication:getTargetPlatform()
			local frameSize = CCEGLView:sharedOpenGLView():getFrameSize();--真实屏幕
			if target == kTargetIpad then
				DeviceModel = "Ipad_"..frameSize.width.."_"..frameSize.height;
			else
				DeviceModel = "Iphone_"..frameSize.width.."_"..frameSize.height;
			end
			log("获取手机型号 DeviceModel === " .. DeviceModel)
			return DeviceModel;
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getModel"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, MODEL = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			log("获取手机型号 DeviceModel === " .. MODEL)
			return MODEL
		else
			return ""
		end
	end
end

--[[--
--图片是否存在
--@param #String picUrl 图片地址
--@param #boolean isNeedRoundPhoto 是否需要圆形图片
--]]
function getPicExists(picUrl, isNeedRoundPhoto)
	if picUrl == nil or picUrl == "" then
		return false;
	end

	local isRoundPhoto = false;
	if isNeedRoundPhoto ~= nil then
		isRoundPhoto = isNeedRoundPhoto;
	end

	if platform == TargetIos then
		--ios平台
		local args = {
			imgurl = picUrl,
		}
		local ok, exists = luaoc.callStaticMethod("UserAvator", "picExists", args)
		if ok then
			return exists
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "picExists"
		local javaParams = {
			picUrl,
			isNeedRoundPhoto
		}
		local ok, exists = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ok then
			return exists
		else
			return false
		end
	end
end

--[[--
--下载图片文件
@param #String picUrl 图片下载地址
@param #number nResID 下载任务ID
@param #boolean bHighPri 是否紧急任务
@param #function callBackFunction 下载完成后的回调方法
@param #boolean isNeedRoundPhoto 是否需要圆形图片
--]]
function getPicFile(picUrl, nResID, bHighPri, callBackFunction, isNeedRoundPhoto)
	if picUrl == nil or picUrl == "" then
		return;
	end

	--头像默认不是圆形
	local isRoundPhoto = false;
	if isNeedRoundPhoto ~= nil then
		isRoundPhoto = isNeedRoundPhoto;
	end

	--头像下载模式不同，区分国际还是国内的标志，默认是国内
	local globalApp = Load.isGlobalApp()

	if platform == TargetIos then
		--ios平台

		local args = {
			imgurl = picUrl,
			callBackFunctionVar = callBackFunction,
			nResIDVal = ""..nResID,
			gameId = GameConfig.GAME_ID,
			isRoundPhoto = isRoundPhoto,
			globalApp = globalApp,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "downAvator", args)
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "downloadImage"
		local javaParams = {
			picUrl,
			nResID,
			callBackFunction,
			isRoundPhoto,
		--globalApp
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

function getPicFileV2(picUrl, nResID, bHighPri, callBackFunction, isNeedRoundPhoto, imageSize, isNeedCustom)
	if picUrl == nil or picUrl == "" then
		return;
	end

	--头像默认不是圆形
	local isRoundPhoto = false;
	--是否需要自定义尺寸
	local isNeedCustomSize = false

	if isNeedRoundPhoto ~= nil then
		isRoundPhoto = isNeedRoundPhoto;
	end
	if isNeedCustom ~= nil then
		isNeedCustomSize = isNeedCustom
	end

	--头像下载模式不同，区分国际还是国内的标志，默认是国内
	local globalApp = Load.isGlobalApp()

	if platform == TargetWindows then
	--windows平台

	elseif platform == TargetIos then
		--ios平台

		local args = {
			imgurl = picUrl,
			callBackFunctionVar = callBackFunction,
			nResIDVal = ""..nResID,
			gameId = GameConfig.GAME_ID,
			isRoundPhoto = isRoundPhoto,
			imageSizeWidth = imageSize.width,
			imageSizeHeight = imageSize.height,
			globalApp = globalApp,
			isNeedCustomSize = isNeedCustomSize,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "downAvator", args)
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "downloadImage"
		local javaParams = {
			picUrl,
			nResID,
			callBackFunction,
			isRoundPhoto
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

local cjson = require("cjson")

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

local DefaultGameDataDir = "DefaultGameData";

--[[--
存储table数据
@param #string fileName 文件名
@param #table data table数据
]]
function SaveTable(fileName, data)
	local file = nil;

	if platform == TargetIos then
		--ios平台
		file = io.open(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/"  .. fileName .. ".json", "w")
	elseif platform == TargetAndroid then
		--android平台
		file = io.open(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json", "w")
	end

	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		--log(wirtjson)
		file:write(wirtjson)
		file:close();
	end
end

--[[--
读取json数据,返回table
@param #string fileName 文件名
@return #table table数据
]]
function LoadTable(fileName)
	local file = nil;

	if platform == TargetIos then
		--ios平台
		file = io.open(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json", "r")
	elseif platform == TargetAndroid then
		--android平台
		file = io.open(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json", "r")
	end

	local table = nil;
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		-- log(readjson)
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	if type(table) ~= "table" then
		return nil;
	end
	return table;
end

--[[--
--读取资源目录json数据,返回table
--@param #string fileName 文件名
--@return #table table数据
--]]
function LoadResourceJsonToTable(filePath)
	local file
	file = io.open(CCFileUtils:sharedFileUtils():fullPathForFilename(filePath), "r");
	local table = nil;
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		-- log(readjson)
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	if type(table) ~= "table" then
		return nil;
	end
	return table;
end

--[[--
--存储table数据到SD卡上
--@param #string fileName 文件名
--@param #table data table数据
]]
function SaveShareTable(fileName, data, dir)
	local file
	if platform == TargetIos then
		--ios平台
		if dir ~= nil then
			file = io.open(getIOSDocumentDirectoryPath(dir) .. "/" .. fileName .. ".json", "w")
		else
			file = io.open(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json", "w")
		end
	elseif platform == TargetAndroid then
		--android平台
		if dir ~= nil then
			file = io.open(getTrendsSaveFilePath(dir) .. fileName .. ".json", "w")
		else
			file = io.open(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json", "w")
		end
	end
	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--
--从SD卡上读取json数据,返回table
--@param #string fileName 文件名
--@return #table table数据
--]]
function LoadShareTable(fileName, dir)
	local file
	if platform == TargetIos then
		--ios平台
		if dir ~= nil then
			file = io.open(getIOSDocumentDirectoryPath(dir) .. "/" .. fileName .. ".json", "r")
		else
			file = io.open(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json", "r")
		end
	elseif platform == TargetAndroid then
		--android平台
		if dir ~= nil then
			file = io.open(getTrendsSaveFilePath(dir) .. fileName .. ".json", "r")
		else
			file = io.open(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json", "r")
		end
	end
	local table
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	return table
end

--[[--
--删除文件
--]]
function deleteShareFile(fileName, dir)
	if platform == TargetIos then
		--ios平台
		if dir ~= nil then
			os.remove(getIOSDocumentDirectoryPath(dir) .. "/" .. fileName .. ".json")
		else
			os.remove(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json")
		end

	elseif platform == TargetAndroid then
		--android平台
		if dir ~= nil then
			os.remove(getTrendsSaveFilePath(dir) .. fileName .. ".json")
		else
			os.remove(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json")
		end
	end
end

--[[--
--存储用户数据到SD卡上
--@param #string fileName 文件名
--@param #table data table数据
--]]
function SaveShareUserTable(fileName, data)
	local file = nil;
	if platform == TargetIos then
		--ios平台
		file = io.open(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json", "w")
	elseif platform == TargetAndroid then
		--android平台
		local UserID = ""..data["UserID"]
		local nickname = data["nickname"]
		local password = data["password"]
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "SaveShareUserData"
		local javaParams = {
			nickname,
			password,
			UserID,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		--本地也要存储用户数据

		file = io.open(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json", "w");
	end
	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--
--从SD卡上读取用户数据,返回table
--@param #string fileName 文件名
--@return #table table数据
--]]
function LoadShareUserTable(fileName)
	local file = nil;
	local table = {}
	if platform == TargetIos then
		--ios平台
		file = io.open(getIOSDocumentDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json", "r")
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "LoadShareUserData"
		local javaParams = {
			}
		local ok, userData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
		if ok and userData ~= ""  then
			--读取到SD卡上用户数据
			local UserTable = FGUtilStringSplit(userData, "#")
			table.nickname = UserTable[1]
			table.password = UserTable[2]
			table.UserID = UserTable[3]
		else
			--读取到本地用户数据
			file = io.open(getTrendsSaveFilePath(DefaultGameDataDir) .. fileName .. ".json", "r")
		end
	end
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	return table
end

--[[--
--存储table数据到SD卡上
--@param #string fileName 文件名
--@param #table data table数据
--]]
function SaveCommonStoreTable(fileName, data, dir)
	local file;
	if platform == TargetIos then
		--ios平台
		if dir ~= nil then
			file = io.open(getIOSCachesDirectoryPath(dir) .. "/" .. fileName .. ".json", "w")
		else
			file = io.open(getIOSCachesDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json", "w")
		end
	elseif platform == TargetAndroid then
		--android平台
		if dir ~= nil then
			file = io.open(getTrendsSaveFilePathSD(dir) .. fileName .. ".json", "w")
		else
			file = io.open(getTrendsSaveFilePathSD(DefaultGameDataDir) .. fileName .. ".json", "w")
		end
	end
	if file ~= nil then
		assert(file)
		local wirtjson = encode(data) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--
--从SD卡上读取json数据,返回table
--@param #string fileName 文件名
--@return #table table数据
--]]
function LoadCommonStoreTable(fileName, dir)
	local file
	if platform == TargetIos then
		--ios平台
		if dir ~= nil then
			file = io.open(getIOSCachesDirectoryPath(dir) .. "/" .. fileName, "r");
		else
			file = io.open(getIOSCachesDirectoryPath(DefaultGameDataDir) .. "/" .. fileName, "r");
		end
	elseif platform == TargetAndroid then
		--android平台
		if dir ~= nil then
			file = io.open(getTrendsSaveFilePathSD(dir) .. fileName, "r");
		else
			file = io.open(getTrendsSaveFilePathSD(DefaultGameDataDir) .. fileName, "r");
		end
	end
	local table
	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		--Common.log("readjson ========= "..readjson);
		table = decode(readjson) --转成原来存储前的格式
		file:close()
	end
	return table
end

--[[--
--删除文件
--]]
function deleteCommonStoreFile(fileName, dir)
	if platform == TargetIos then
		--ios平台
		if dir ~= nil then
			os.remove(getIOSCachesDirectoryPath(dir) .. "/" .. fileName .. ".json")
		else
			os.remove(getIOSCachesDirectoryPath(DefaultGameDataDir) .. "/" .. fileName .. ".json")
		end

	elseif platform == TargetAndroid then
		--android平台
		if dir ~= nil then
			os.remove(getTrendsSaveFilePathSD(dir) .. fileName .. ".json")
		else
			os.remove(getTrendsSaveFilePathSD(DefaultGameDataDir) .. fileName .. ".json")
		end
	end
end

--本地数据库
local SqliteTable = {}

--[[--
--存储table数据到本地数据库中
--]]
local function SaveSqliteTable()
	local writablePath = CCFileUtils:sharedFileUtils():getWritablePath();
	local file = nil;
	local fileName = "SqliteTable";
	file = io.open(writablePath .. fileName .. ".json", "w")

	if file ~= nil then
		assert(file)
		local wirtjson = encode(SqliteTable) --转换成json格式
		file:write(wirtjson)
		file:close();
	end
end

--[[--
--从本地数据库中读取json数据,存入SqliteTable中
--]]
local function LoadSqliteTable()
	--log("从本地数据库中读取json数据,存入SqliteTable中")
	local writablePath = CCFileUtils:sharedFileUtils():getWritablePath();
	local file = nil;
	local fileName = "SqliteTable";

	file = io.open(writablePath .. fileName .. ".json", "r");

	if file ~= nil then
		assert(file)
		local readjson = file:read("*a") -- 读取所有内容
		SqliteTable = decode(readjson) --转成原来存储前的格式
		file:close()
	end
end

LoadSqliteTable();

--[[--
--存储数据到本地数据库中
--@param #string Key 数据索引
--@param #obj Value 数值
]]
function setDataForSqlite(Key, Value)
	if SqliteTable == nil then
		SqliteTable = {};
	end
	SqliteTable[Key] = Value
	SaveSqliteTable()
end

--[[--
--从本地数据库中获取数据
--@param #string Key 数据索引
--@return #obj Value 数值(返回数据或者nil)
]]
function getDataForSqlite(Key)
	if SqliteTable ~= nil and SqliteTable[Key] ~= nil then
		return SqliteTable[Key]
	else
		return nil
	end
end

--[[--
--上传头像
--]]
function uploadAvator(callBackFunction)
	if platform == TargetIos then
		--ios平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		if GameChannelConfig.getChannelIsLianYun() then
			URL_UPLOAD_USER_PHOTO = "http://codb.tongqutongqu.cn/tqAdmin/fileUploadManager!upload.do"
		end
		local args = {
			picSize = 200,
			mUrl = URL_UPLOAD_USER_PHOTO,
			userID = "" .. userID,
			password = password,
			call = callBackFunction,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "changeAvator", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "uploadingPhoto"
		local javaParams = {
			"" .. userID,
			password,
			callBackFunction,
			URL_UPLOAD_USER_PHOTO,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		return true
	end
end

--[[--
--斗地主上传头像
@param #Int type 上传头像类型
--]]
function uploadAvatorForLord(callBackFunction, type)
	if platform == TargetIos then
		--ios平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		local args = {}

		if type == FAMILY_PHOTO_UPLOAD then
			--家族头像上传
			args = {
				mUrl = URL_UPLOAD_FAMILY_PHOTO,
				userID = "" .. userID,
				password = password,
				call = callBackFunction,
			}
		else
			--用户头像上传
			args = {
				mUrl = URL_UPLOAD_USER_PHOTO,
				userID = "" .. userID,
				password = password,
				call = callBackFunction,
			}
		end

		local ok, ret = luaoc.callStaticMethod("UserAvator", "changeAvator", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		local mUrl = ""
		if type == FAMILY_PHOTO_UPLOAD then
			mUrl = URL_UPLOAD_FAMILY_PHOTO
		else
			mUrl = URL_UPLOAD_USER_PHOTO
		end
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "uploadingPhoto"
		local javaParams = {
			"" .. userID,
			password,
			callBackFunction,
			mUrl,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		return true
	end
end

--[[--
--炸金花上传头像
--]]
function uploadAvatorForJinHua(callBackFunction)
	if platform == TargetIos then
		--ios平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		if GameChannelConfig.getChannelIsLianYun() then
			URL_UPLOAD_USER_PHOTO = "http://codb.tongqutongqu.cn/tqAdmin/fileUploadManager!upload.do"
		end
		local args = {
			picSize = 200,
			mUrl = URL_UPLOAD_USER_PHOTO,
			userID = "" .. userID,
			password = password,
			call = callBackFunction,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "changeAvator", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "uploadingPhoto"
		local javaParams = {
			"" .. userID,
			password,
			TYPE_UPLOAD_PHOTO,
			callBackFunction,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		return true
	end
end

--[[--
--上传真实头像(目前仅炸金花支持)
--]]
function uploadRealFace(callBackFunction)
	if platform == TargetIos then
		--ios平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		if GameChannelConfig.getChannelIsLianYun() then
			URL_UPLOAD_REAL_PHOTO = "http://codb.tongqutongqu.cn/tqAdmin/jhCertPhotoFileUpload!upload.do"
		end
		local args = {
			picSize = 640,
			mUrl = URL_UPLOAD_REAL_PHOTO,
			userID = "" .. userID,
			password = password,
			call = callBackFunction,
		}
		local ok, ret = luaoc.callStaticMethod("UserAvator", "changeAvator", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		--android平台
		local userID = profile.User.getSelfUserID()
		local password = profile.User.getSelfPassword()
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "uploadingPhoto"
		local javaParams = {
			"" .. userID,
			password,
			TYPE_UPLOAD_REAL_PHOTO,
			callBackFunction,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
		return true
	end
end

local webViewShowStatus = false; --webView显示状态

--[[--
打開webview界面(urlValue和codeValue中有一个被赋值，另一个则为"")
--@param #string urlValue 网址
--@param #string codeValue html代码
--@param #number x 显示位置X坐标
--@param #number y 显示位置Y坐标
--@param #number width webview的宽
--@param #number height webview的高
--]]
function showWebView(urlValue, codeValue, x, y, width, height)
	webViewShowStatus = true
	if platform == TargetIos then
		--ios平台
		local function callBack()
		end
		local args = {
			width = GameConfig.WebView_Width,
			height = GameConfig.WebView_Height,
			url = urlValue,
			content = codeValue,
			xvalue = x,
			yvalue = y,
			wvalue = width,
			hvalue = height,
			callback = callBack,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openWebview", args)
		if ok then
			return ret
		else
			return nil
		end
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "displayWebView"
		local javaParams = {
			x,
			y,
			width,
			height,
			urlValue,
			codeValue,
			GameConfig.WebView_Width,
			GameConfig.WebView_Height,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end

end
--[[--
--关闭webview界面
--]]
function hideWebView()
	webViewShowStatus = false
	if platform == TargetIos then
		--ios平台
		local args = {
			view = webView,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "hideWebview", args)
		if ok then
			return true
		else
			return false
		end
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "removeWebView"
		local javaParams = {
			}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--隐藏Webview
--]]
function didHideWebview()
	webViewShowStatus = false
	if platform == TargetIos then
		local args = {
			}
		local ok, ret = luaoc.callStaticMethod("Helper", "didHideWebview", args)
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "hideWebView"
		local javaParams = {
			}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--显示Webview
--]]
function didShowWebview()
	webViewShowStatus = true
	if platform == TargetIos then
		local args = {
			}
		local ok, ret = luaoc.callStaticMethod("Helper", "didShowWebview", args)
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "showWebView"
		local javaParams = {
			}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--发短信
--@param #string mobile号码
--@param #string message内容
--]]
function sendSMSMessage(mobile, message)
	if platform == TargetIos then
		--ios平台

		local args = {
			mobilevalue = mobile,
			messagevalue = message
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openSendMessage", args)
		if ok then
			return true
		else
			return false
		end

	elseif platform == TargetAndroid then
		--andorid平台
		local javaClassName = Load.AndroidPackage .. ".utils.SMSUtils"
		local javaMethodName = "sendSms"
		local javaParams = {
			mobile,
			message,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--发二进制短信
--@param #string mobile号码
--@param #number port端口
--@param #string message内容
--]]
function sendSMSDataMessage(mobile, port, message)
	if platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then
		--andorid平台
		local javaClassName = Load.AndroidPackage .. ".utils.SMSUtils"
		local javaMethodName = "sendDataSms"
		local javaParams = {
			mobile,
			port,
			message,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--获取时间差
--@param #table mnOldTime 记录的时间戳
--@return #number dateDifference时间差(单位：小时)
--@return #table 当前时间戳
--]]
function getTimeDifference(mnOldTime)
	--获取系统时间
	local NowTime = os.date("*t", getServerTime())  --如果格式化字符串为"*t"，函数将返回table形式的日期对象。如果为"!*t"，则表示为UTC时间格式。

	local OldTime = {}

	if mnOldTime == nil or mnOldTime == "" then
		OldTime = NowTime
	else
		OldTime = mnOldTime
	end

	--从日期字符串中截取出年月日时分秒  2013010101
	local Y1 = NowTime.year
	local M1 = NowTime.month
	local D1 = NowTime.day
	local H1 = NowTime.hour

	local Y2 = OldTime.year
	local M2 = OldTime.month
	local D2 = OldTime.day
	local H2 = OldTime.hour

	local dateDifference = (Y1 - Y2) * 365 * 24 + (M1 - M2) * 30 * 24 + (D1 - D2) * 24 + H1 - H2

	return dateDifference, NowTime
end

--[[--
--分割字符串  string  分割的字符   返回值table
--]]
function FGUtilStringSplit(str, split_char)
	Common.log("FGUtilStringSplit ===== "..str);
	-- 参数:待分割的字符串,分割字符
	-- 返回:子串表.(含有空串)
	local sub_str_tab = {};
	while (true) do
		local pos = string.find(str, split_char);
		if (not pos) then
			sub_str_tab[#sub_str_tab + 1] = str;
			break;
		end
		local sub_str = string.sub(str, 1, pos - 1);
		sub_str_tab[#sub_str_tab + 1] = sub_str;
		str = string.sub(str, pos + 1, #str);
	end
	if #sub_str_tab == 1 and sub_str_tab[1] == "" then
		sub_str_tab = {};
	end
	return sub_str_tab;
end

--[[--
--上传统计事件到友盟
--]]
function setUmengUserDefinedInfo(key, value)
	if platform == TargetIos then
		--ios平台
		local args = {
			keyV = key,
			valueV = value,
		}
		local ok,ret = luaoc.callStaticMethod("UMTongjiIOS", "YMTongjiList", args)
	elseif platform == TargetAndroid then
		--andorid平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "setUmengUserDefinedInfo"
		local javaParams = {
			key,
			value,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end


LoadFunnelModel = "Lord_Load_Lua"--斗地主lua脚本加载_每次5行为--1步
ConnectFunnelModel = "Lord_Connect_Lua"--斗地主建立连接_每次2行为--2步
SwitchFunnelModel = "Lord_SendSwitch_Lua"--斗地主发送开关消息_每次2行为--3步
IMEIUsersFunnelModel = "Lord_SendIMEIUsers_Lua"--斗地主请求设备用户列表_每次2行为--4步
RegisterFunnelModel = "Lord_Register_Lua"--斗地主发送注册消息_每次2行为--5步

--[[--
--设置iOS/Android注册流程的漏斗数据
--]]
function setRegisterFunnelModel(key, value)
	if isDebugState() then
		return;
	end
	local logininfo = LoadShareUserTable("lastLoginUserInfo");
	if logininfo == nil then
		return;
	end
	if next(logininfo) ~= nil then
		Common.log("注册流程的漏斗数据 =============有用户数据============");
		return;
	end

	if platform == TargetIos then
		--ios平台
		Common.setUmengUserDefinedInfo(key, value);
	elseif platform == TargetAndroid then
		--android平台
		Common.setUmengUserDefinedInfo(key, value);
	end
end

--[[--
--获取运营商类型
--@return #number 运营商
--]]
function vibrate()
	if platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "vibrate"
		local javaParams = {}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--弹出框
--]]
function showDialog(sMsg)
	if platform == TargetIos then
		--ios平台

		local args = {
			msg= sMsg,
		}
		local ok,ret = luaoc.callStaticMethod("Helper", "openAlert", args)

	elseif platform == TargetAndroid then
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "showAndroidDialog"
		local javaParams = {
			sMsg,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--获取utf8编码字符串正确长度的方法
--]]
function utfstrlen(str)
	local len = #str;
	local left = len;
	local cnt = 0;
	local arr = { 0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc };
	while left ~= 0 do
		local tmp = string.byte(str, -left);
		local i = #arr;
		while arr[i] do
			if tmp >= arr[i] then left = left - i; break; end
			i = i - 1;
		end
		cnt = cnt + 1;
	end
	return cnt;
end

--[[--
--获取文字串宽度
--]]
function getFontStringLen(str, fontSize)
	local lenInByte = #str;
	local width = 0;

	for i = 1, lenInByte do
		local curByte = string.byte(str, i)
		local byteCount = 1;
		if curByte > 0 and curByte <= 47 then
			byteCount = 1;
		elseif curByte >= 48 and curByte <= 57 then
			--数字0-9
			byteCount = 2;
		elseif curByte >= 58 and curByte <= 127 then
			byteCount = 1;
		elseif curByte >= 192 and curByte <= 223 then
			byteCount = 3;
		elseif curByte >= 224 and curByte <= 239 then
			byteCount = 4;
		elseif curByte >= 240 and curByte <= 247 then
			byteCount = 5;
		else
			byteCount = 0;
		end
		--Common.log("byteCount = " .. byteCount)

		if byteCount == 1 then
			--英文字符
			width = width + fontSize * 0.7
		elseif byteCount == 2 then
			--数字0-9
			width = width + fontSize * 0.7
		elseif byteCount > 2 and byteCount <= 5 then
			width = width + fontSize
		else

		end
	end

	return width;
end

--[[--
--根据首字节获取UTF8需要的字节数
--截取UTF8字符串
--SubUTF8String("一二三四五六七",1,3) 返回一二三
]]
function GetUTF8CharLength(ch)
	local utf8_look_for_table = {
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
		2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
		4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 1, 1,
	}
	return utf8_look_for_table[ch]
end

function SubUTF8String(str, begin, length)
	begin = begin or 1
	length = length or -1 --length为-1时代表不限制长度
	local ret = ""
	local len = 0
	local ptr = 1
	repeat
		local char = string.byte(str, ptr)
		local char_len = GetUTF8CharLength(char)
		len = len + 1

		if len >= begin and (length == -1 or len < begin + length) then
			for i = 0, char_len - 1 do
				ret = ret .. string.char(string.byte(str, ptr + i))
			end
		end

		ptr = ptr + char_len
	until(ptr>#str)
	return ret
end

--[[--
--获取字符长度(中文占三个字符，英文占一个字符)
--]]
function getStringLength(txt)
	local txtLength = string.len(txt)
	return txtLength
end

Toast_LENGTH_LONG = 1--显示Toast.LENGTH_LONG: 3.5秒
Toast_LENGTH_SHORT = 0--显示Toast.LENGTH_SHORT: 2秒

function showNativeToast(showMsg,toastTime)
	if platform == TargetIos then
		--ios平台

		local args = {
			msg = showMsg,
			time = toastTime,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openToast", args)
		if ok then
			return true
		else
			return false
		end

	elseif platform == TargetAndroid then
		--android平台
		local toastType = Toast_LENGTH_LONG
		if toastTime <= 2 then
			toastType = Toast_LENGTH_SHORT
		end
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "showToast"
		local javaParams = {
			showMsg,
			toastType,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--显示toast
--@param #String showMsg 显示的文字
--@param #number toastTime Toast显示时间(秒)
--]]
function showToast(showMsg, toastTime)
	if GameChannelConfig.isAppStoreChannelID() and ServerConfig.isAppstoreReview() then
		if GameConfig.GAME_ID == GamePub.ZIPAI_GAME_ID then
			return true
		end
	end
	if showMsg == "" or showMsg == nil then
		return true
	end
	if toastTime == nil or toastTime < 2 then
		toastTime = 2
	end
	if webViewShowStatus then
		showNativeToast(showMsg, toastTime)
	else
		if Load.isGlobalApp() then
			GlobalToastView.showToast(showMsg, toastTime)
		else
			ToastView.showToast(showMsg, toastTime)
		end
	end
end

--[[--
--显示弹出输入框 ios专用
--消息  taskId  是否紧急  回调方法
--]]
function showAlertInput(msg, taskidvalue, isImport, callvalue)
	if platform == TargetIos then
		--ios平台
		local args = {
			flag = msg,
			call = callvalue,
			taskid = taskidvalue,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "openAlertInput", args)
		if ok then
			return true
		else
			return false
		end

	elseif platform == TargetAndroid then

	end
end

--控件平移动画效果    控件  时间     x位移              y位移   延迟时间
function ControlsCCMoveBy(view, time, x, y, delaytime)
	local move = CCMoveBy:create(time, ccp(x, y))
	local arr = CCArray:create()
	arr:addObject(CCDelayTime:create(delaytime))
	arr:addObject(move)
	local seq = CCSequence:create(arr)
	view:runAction(seq)
end

-- 上传客户端异常事件
function uploadClientExceptionInfo(str_info)
	setUmengUserDefinedInfo("throw_exception", "时间:"..os.date().." ID:"..profile.User.getSelfUserID()..str_info)
end

--[[--
--DES解密
--]]
function decryptUseDES(textString, Bytelength, keyValue)
	if platform == TargetIos then
		--ios平台
		local args = {
			cipherText = textString,
			length = Bytelength,
			key = keyValue,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "decryptUseDES", args)
		if ok then
			return ret
		else
			return 0
		end
	elseif platform == TargetAndroid then
		--Android平台
		if(Bytelength ~= 0) then
			local javaClassName = Load.AndroidPackage .. ".utils.DecryptUseDES"
			local javaMethodName = "getDecryptForDES"
			local javaParams = {
				textString,
				keyValue,
			}
			local ok, ret = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Ljava/lang/String;")
			if ok then
				return ret
			else
				return 0
			end
		else
			return 0
		end
	end
end

--itunesUpdate itunes升级
function ItunesUpdate()
	if platform == TargetIos then
		--ios平台
		local args = {
			cipherText = textString,
			length = Bytelength,
			key = keyValue,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "itunesUpdate", args)
		if ok then
			return ret
		else
			return 0
		end
	elseif platform == TargetAndroid then

	end
end

--按钮的动画效果，先放大在缩小，在执行方法
--按钮动画,先放大,后缩小
function setButtonScale(button, func)
	local scaleBig = CCScaleTo:create(0.1, 1.2)
	local scaleSmall = CCScaleTo:create(0.1, 1)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	if func then
		arr:addObject(CCCallFuncN:create(func))
	end
	local seq = CCSequence:create(arr)
	button:runAction(seq)
end

--按钮的动画效果，先放大在缩小，在执行方法
--按钮动画,先放大,后缩小
function newSetButtonScale(button, big, small, func)
	local scaleBig = CCScaleTo:create(0.1, big)
	local scaleSmall = CCScaleTo:create(0.1, small)
	local arr = CCArray:create()
	arr:addObject(scaleBig)
	arr:addObject(scaleSmall)
	if func then
		arr:addObject(CCCallFuncN:create(func))
	end
	local seq = CCSequence:create(arr)
	button:runAction(seq)
end

--[[--
--设置按钮显示状态并设置触摸监听状态
--]]
function setButtonVisible(button, visible)
	if button ~= nil then
		button:setVisible(visible)
		button:setTouchEnabled(visible)
	end
end

--lua分割字符串  输入字符串，分隔符，返回list
function Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

--设置手机钱包正则表达式
function SavePurseRegex(PurseRegexData)
	if platform == TargetIos then
		--ios平台
		if PurseRegexData ~= nil then
			ServerConfig.HAS_GET_PURES_MATCHES = true
		end
	elseif platform == TargetAndroid then
		if PurseRegexData ~= nil then
			local javaClassName = "org.tongqu.client.pay.PaymentConfig"
			local javaMethodName = "luaCallPurseRegexData"
			local javaParams = {
				PurseRegexData.VarValue,
			}
			luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
			ServerConfig.HAS_GET_PURES_MATCHES = true
		end
	end
end

--[[--
--统计在线时长
--]]
function AndroidExitSendOnlineTime()
	if GameConfig.enterGameTime > 0 and hasSendOnlineMsg == false then
		--进入游戏时间大于0：用户进入首页才计算在线时间
		sendSTAID_COMMIT_ACTIVITY_STAY(os.time() - GameConfig.enterGameTime);
		hasSendOnlineMsg = true;
	end

	if exitScheduler == nil then
		exitScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(AndroidExitSendOnlineTime, 0.1, false);
	else
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(exitScheduler)
		exitScheduler = nil;
		hasSendOnlineMsg = false;
		AndroidExit();
	end
end

--[[--
--调用android方法显示是否退后
]]
function AndroidExit()
	mvcEngine.destroyAllModules()
	AudioManager.stopBgMusic(true)
	AudioManager.stopAllSound()
	Services:getMessageService():closeSocket();
	CCDirector:sharedDirector():endToLua();
end

--[[--
--向服务器发送iOS设备的token
]]
function sendIOSDeviceToken()
	local args = {};
	local ok, ret = luaoc.callStaticMethod("AppController", "getDeviceToken", args);
	if ok then
		log("getDeviceToken ============= " .. tostring(ret["token"]));
		sendADD_DEVICE_TOKEN(tostring(ret["token"]));
	end
end

--[[--
--复制table
--lua中表之间的赋值是引用的方式进行的，意味着改变一个，另一个也跟着变化。
--如果想要避免这种情况，可以通过自定义的函数复制一份table出来。
--]]
function copyTab(st)
	local tab = {}
	for k, v in pairs(st or {}) do
		if type(v) ~= "table" then
			tab[k] = v
		else
			tab[k] = copyTab(v)
		end
	end
	return tab
end


local index = 100;

function getIndex()
	if index > 999 then
		index = 100
	end
	index = index + 1
	return index
end

--[[--
--获取本地时间戳
--]]
function getNativeTimeStamp()
	return tonumber(os.time() .. getIndex());
end

--[[--
--获取服务器时间
--时间戳（秒）
--]]
function getServerTime()
	return Common.getTimeStamp() - profileCommon.ServerMsg.getTimeDifference();
end

--[[--
--根据时间戳获取当前时间，格式为xx时xx分
--timeStemp为秒
--]]
function getTimeByTimeStemp(timeStemp)
	return os.date("%M:%S", tonumber(timeStemp));
end

--[[--
--根据时间戳获取当前时间，格式为xx时xx分
--timeStemp为秒
--]]
function getTimeByAllTimeStemp(timeStemp)
	return os.date("%H:%M:%S", tonumber(timeStemp));
end

--[[--
--IOS更新版本
--]]
function upDataGameVersionForIOS(isForce, isTest)
	if platform == TargetIos then
		if GameConfig.PaymentForIphone == GameConfig.PAYMENT_SMS then
		--短代
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
		--iap
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
		--91
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
			--海马
			--nTest == 1调试模式 0非调试模式
			local args = {
				nTest = isTest,
			};
			luaoc.callStaticMethod("Helper", "HaiMaUpData", args);
		end
	end
end

--[[--
-- 存储错误信息
--]]
function saveExceptionInfo(debugInfo)
	if not ServerConfig.getEnableUploadLuaEx() then
		return;
	end
	local iosExceptionTable = LoadShareTable(CommUploadConfig.iosExceptionFileName)
	if iosExceptionTable == nil or #iosExceptionTable == 0 then
		iosExceptionTable = {}
	end
	table.insert(iosExceptionTable, debugInfo)
	SaveShareTable(CommUploadConfig.iosExceptionFileName, iosExceptionTable)
end

--[[--
-- 显示带按钮的dialog
--]]
function showButtonDialog(title, message, callBack)
	if platform == TargetIos then
	--ios平台
	elseif platform == TargetAndroid then
		--android平台
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "showAlertDialog"
		local javaParams = {
			title,
			message,
			callBack
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[-- 获取运营商编号IMSI ]]
function getImsi()
	if platform == TargetIos then
		--ios平台
		if getOperater() == 1 then
			return "46000123456789"
		elseif getOperater() == 2 then
			return "46001123456789"
		elseif getOperater() == 3 then
			return "46003123456789"
		else
			return ""
		end
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getImsi"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, imsi = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return imsi
		else
			return ""
		end
	end
end

--[[--
--获取SIM卡的ICCID
--]]
function getICCID()
	if platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getICCID"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, iccid = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return iccid
		else
			return ""
		end
	end
end

--[[--
获取设备剩余电量
返回值:
-1为错误
为百分比数，如10表示10%
--]]
function getDeviceBatteryLevel()
	if platform == TargetIos then
		--ios
		local function callBack(params)
			batteryLevel = params.batteryLevel
		end
		local args = {
			callback = callBack,
		};
		luaoc.callStaticMethod("Helper", "getDeviceBatteryLevel", args);
	elseif platform == TargetAndroid then
		--android
		local function callBack(params)
			batteryLevel = params
		end
		local javaClassName = Load.AndroidPackage .. ".utils.BroadCastUtils"
		local javaMethodName = "luaCallGetBattery"
		local javaParams = {
			callBack,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end

	return tonumber(batteryLevel)
end

--[[--
--设备执行震动
--]]
function doVibrate()
	if platform == TargetIos then
		luaoc.callStaticMethod("Helper", "doVibrate", nil);
	elseif platform == TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "vibrate"
		local javaParams = {}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--根据包名检查应用是否安装
--@param #String sGameID 应用ID 例如：斗地主 = "1"
--@param #String packName app包名
--@return #number 1:已安装；0未安装
--]]
function checkAppIsInstalledByPackName(sGameID, packName)
	if platform == TargetIos then
		--ios平台
		return 1;
	elseif platform == TargetAndroid then
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "getAppIsInstalledByPackName"
		local javaParams = {
			packName,
			sGameID,
		};
		local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)I";
		local ok, isInstalledApp = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
		if ok then
			return isInstalledApp;
		else
			return 0;
		end
	end
end

--[[--
--设置下载完应用的回调方法
--@param #String sGameID 应用ID 例如：斗地主(GameID = "1")
--@param #Fucntion callBackFunc 回调方法
--@param #boolean isInstalled 下载完是否立即安装 true 是 false 否
--]]
function setDownloadCompleteCallBack(GameID, callBackFunc, isInstalled)
	if platform == TargetIos then
		--ios平台
		return ""
	elseif platform == TargetAndroid then
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "setDownloadAppCompleteInfo"
		local javaParams = {
			GameID,
			callBackFunc,
			isInstalled,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end
end

--[[--
--ios本地推送通知
--]]
function scheduleLocalNotification(mDelaySecond, matchTitle, matchStartTime, matchID)
	Common.log("mDelaySecond = "..mDelaySecond)
	Common.log("matchTitle = "..matchTitle)
	Common.log("matchStartTime = "..matchStartTime)

	if mDelaySecond <= 0 then
		return;
	end

	local text = Localize.getLocalizeString(LocalizeStrings.strings["您报名的"], matchTitle)
	local text1 = Localize.getLocalizeString(LocalizeStrings.strings["将在"], matchStartTime)

	local args = {
		matchID = matchID,
		delaySecond = mDelaySecond,
		--		description  = "您报名的"..matchTitle.."，将在"..matchStartTime.."开始，请做好准备！",
		description = text .. text1 .. Localize.getLocalizeString(LocalizeStrings.strings["开始请做好准备"]),
	};

	local args = {
		matchID = matchID,
		delaySecond = mDelaySecond,
		description = "您报名的"..matchTitle.."，将在"..matchStartTime.."开始，请做好准备！",
	};
	luaoc.callStaticMethod("Helper", "scheduleLocalNotification", args);
end

--[[--
--添加闹钟
--@param #number time 开赛时间
--@param #string MatchInstanceID
--@param #number MatchID 开赛时间
--@param #number ServerTime 当前时间
--@param #number matchTitle
--@param #number nMinute 闹钟倒计时
--]]--
function addAlarm(time, MatchInstanceID, MatchID, ServerTime, matchTitle, nMinute)
	if Common.platform == Common.TargetIos then
		--ios
		Common.log("比赛开始时间:" .. Common.getTimeByTimeStemp(time / 1000))

		local nLocalPushTimeStamp = time / 1000 - nMinute * 60 --本地推送的时间戳（单位：秒）
		local strPushTime = Common.getTimeByTimeStemp(time / 1000) -- 开赛时间描述

		Common.scheduleLocalNotification(nLocalPushTimeStamp, matchTitle, strPushTime, MatchID);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local timeV = time - ServerTime
		local javaClassName = Load.AndroidPackage .. ".utils.BroadCastUtils"
		local javaMethodName = "luaCallAddAlarm"
		local javaParams = {
			GameConfig.GAME_ID .. "",
			MatchID .. "",
			timeV .. "",
			MatchInstanceID .. "",
			matchTitle .. "",
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--移除闹钟
--]]--
function removeAlarm(MatchID)
	if Common.platform == Common.TargetIos then
		--ios
		local args = {
			matchID = MatchID,
		};
		luaoc.callStaticMethod("Helper", "cancelNotification", args);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".utils.BroadCastUtils"
		local javaMethodName = "luaCallremoveAlarm"
		local javaParams = {
			GameConfig.GAME_ID .. "",
			MatchID .. "",
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--获取当前应用的包名是不是同趣包名
--@return #boolean true 是 false 否
--]]
function getCurrentNameOfAppPackageIsTQ()
	if Common.platform == Common.TargetIos then
		--ios
		return true;
	elseif Common.platform == Common.TargetAndroid then
		local TQAppPackageName = Load.AndroidPackageName;--同趣包名
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getAndroidPackagekName"
		local javaParams = {};
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, appPackageName = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			if TQAppPackageName == appPackageName then
				return true;
			else
				return false;
			end
		else
			return false;
		end
	end
end

--[[--
--安装app
--@param #String FilePath 应用的本地路径
--]]
function installApp(FilePath)
	if Common.platform == Common.TargetIos then
	--ios
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "installApp"
		local javaParams = {
			FilePath,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
--调用浏览器
--]]
function openURL(url)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			strURL = url,
		};
		luaoc.callStaticMethod("Helper", "openSafariURL", args);
	elseif Common.platform == Common.TargetAndroid then
		local javaClassName = Common.AndroidGamePackage .. ".game.TQGameAndroidBridge"
		local javaMethodName = "openURL"
		local javaParams = {
			url,
		};
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end
end

--[[--
--判断是否包含表情符
--]]
function logicEmoji(sendChat)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			msg = sendChat;
		}
		local ok, isEmoji = luaoc.callStaticMethod("Helper", "stringContainsEmoji", args);
		if ok then
			if isEmoji == "YES" then
				return true
			else
				return false
			end
		else
			return false;
		end
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "containsEmoji"
		local javaParams = {
			sendChat,
		}
		local ok, isEmoji = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ok then
			return isEmoji;
		else
			return false;
		end
	end
end

--[[--
--重新加载图片纹理
--这么写的原因是 ImageView_vip这个控件在loadTextures()之前设置opacity为非255 时，loadTexture后就不能再改变透明度了
@param #UIImageView imageView 图片控件名
@param #string path 符合平台的资源路径
--]]
function loadImageTexture(imageView, path)
	if imageView ~= nil and path ~= nil and path ~= "" and type(path) == "string" then
		local temp = imageView:getOpacity()
		imageView:setOpacity(255)
		imageView:loadTexture(path)
		imageView:setOpacity(temp)
	end
end

--[[--
--重新加载按钮纹理
--这么写的原因是 控件在loadTextures()之前设置opacity为非255 时，loadTexture后就不能再改变透明度了
@param #getUIButton button 图片控件名
@param #string pathNor 符合平台的资源路径
@param #string pathSelect 符合平台的资源路径
@param #string pathDisable 符合平台的资源路径
--]]
function loadButtonTexture(button, pathNor, pathSelect, pathDisable)
	if button ~= nil and pathNor ~= nil and pathNor ~= "" and type(pathNor) == "string" and pathSelect ~= nil and pathSelect ~= "" and type(pathSelect) == "string" then
		local temp = button:getOpacity()
		button:setOpacity(255)
		button:loadTextures(pathNor, pathSelect, pathDisable)
		button:setOpacity(temp)
	end
end

--[[--
--获取系统版本号
--]]
function getSystemVersion()
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {}
		local ok, Version = luaoc.callStaticMethod("Helper", "getSystemVersion", args);
		if ok then
			return Version;
		else
			return "";
		end
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getSDK_VERSION"
		local javaParams = {}
		local javaMethodSig = "()Ljava/lang/String;"
		local ok, Version = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
		if ok then
			return Version;
		else
			return ""
		end
	end
end

function closeLogo()
	if Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackageName .. ".TQGameMainScene"
		local javaMethodName = "closeLogo"
		local javaParams = {}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--启动微信登录
--]]
function getWeChatUserinfo(state)
	Common.log("启动微信登录 state ==  "..state)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			callbackLogined = LoginConfig.setWechatLoginDataForIOS,
			wechatLoginState = state
		}
		local ok, ret = luaoc.callStaticMethod("WechatConfig", "weixinLogin",args);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".pay.weixinpay.WechatUtils"
		local javaMethodName = "getWechatUserinfo"
		local javaParams = {
			LoginConfig.setWechatLoginDataForAndroid,
			state
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--是否有微信客户端
--]]
function hasWechatAPP()
	local hasWechat = false;--默认是没安装

	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {}
		local ok, sFlag = luaoc.callStaticMethod("WechatConfig", "gethasWechatAPP",args);
		if ok and sFlag ~= nil then
			if sFlag == "YES" then
				hasWechat = true;
			end
		end
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".pay.weixinpay.WechatUtils"
		local javaMethodName = "hasWechatAPP"
		local javaParams = {}
		local ok, sFlag = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ok then
			hasWechat = sFlag;
		end
	end

	return hasWechat;

end

--[[--
--是否是模拟器
--]]
function isEmulator()

	if Load.isDebugState() then
		--debug模式下默认返回真机
		return false;
	end

	local emulator = false;--默认是真机

	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {}
		local ok, sEmulator = luaoc.callStaticMethod("Helper", "isEmulator",args);
		if ok and sEmulator ~= nil then
			if sEmulator == "YES" then
				emulator = true;
			end
		end
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "isEmulator"
		local javaParams = {}
		local ok, sEmulator = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "Z")
		if ok then
			emulator = sEmulator;
		end
	end

	if emulator then
		Common.log("设备是模拟器======================")
	else
		Common.log("设备是真机======================")
	end

	return emulator;
end

--[[--
--开始ping地址
--]]
function startPing(ip, Callback)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			ipAddr = ip,
			pingCallback = Callback,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "startPing", args);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".utils.PingConfig"
		local javaMethodName = "startPing"
		local javaParams = {
			ip,
			Callback,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--获取本机的联网地址
--]]
function getNetWorkIP(ipUrl, callback)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			url = ipUrl,
			ipCallback = callback,
		}
		local ok, ret = luaoc.callStaticMethod("Helper", "getNetWorkIP", args);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local javaClassName = Load.AndroidPackage .. ".utils.PingConfig"
		local javaMethodName = "getNetWorkIP"
		local javaParams = {
			ipUrl,
			callback,
		}
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--收到推送消息后 清除消息
function clearPushSceneId()
	local args = {};
	local ok, ret = luaoc.callStaticMethod("AppController", "ClearPushSceneId", args);

end

--处理推送消息
function handlePushSceneId()
	--处理推送消息
	local args = {};
	local ok, ret = luaoc.callStaticMethod("AppController", "getPushSceneId", args);
	if ok and ret then
		return tonumber(ret);
	end
	return 0;
end

--[[--
--是否是真实的IMEI
--]]
function isRealIMEI()
	if Common.platform == Common.TargetIos then
		--ios平台
		--		local args = {
		--			}
		--		local ok, isCanUse = luaoc.callStaticMethod("Helper", "isCanUseIDFA", args);
		--		Common.log("isCanUse ========= "..isCanUse);
		--		if isCanUse == "YES" then
		--			Common.log("可以获取广告标识符 ========== ");
		--			return true;
		--		else
		--			return false;
		--		end
		return true;
	elseif Common.platform == Common.TargetAndroid then
		--android
		return true;
	end

end

PingStartFunnelModel = "Ping_Start"--开始ping
PingEndFunnelModel = "Ping_End"--结束ping
PingTimeFunnelModel = "Ping_Time"--ping耗时

--[[--
--设置 iOS/Android Ping流程的漏斗数据
--]]
function setPingFunnelModel(key, value)
	if isDebugState() then
		return;
	end
	if platform == TargetIos then
		--ios平台
		Common.setUmengUserDefinedInfo(key, value);
	elseif platform == TargetAndroid then
		--android平台
		Common.setUmengUserDefinedInfo(key, value);
	end
end

local NativeReleaseDate = -1;--native发布日期

--[[--
-- 获取native发布日期
-- ]]
function getNativeReleaseDate()
	if tonumber(NativeReleaseDate) > 0 then
		return tonumber(NativeReleaseDate);
	end
	--脚本配置信息文件：包内目录在根目录,包外在cached_res文件夹下
	local filePath = ""
	if Load.logicScriptInSD() then
		filePath = Load.getScriptDirectory();
	else
		filePath = "";
		if platform == TargetAndroid then
			NativeReleaseDate = Load.getScriptDataFromAssets("AndroidNativeVerCode");
			return tonumber(NativeReleaseDate);
		end
	end

	local scriptConfig = Load.getJsonData(filePath, "scriptConfig.json");
	if scriptConfig ~= nil then
		if platform == TargetAndroid then
			NativeReleaseDate = scriptConfig.AndroidNativeVerCode;
		else
			NativeReleaseDate = scriptConfig.IOSNativeVerCode;
		end
	end
	return tonumber(NativeReleaseDate);
end

--[[--
--将字符串中的表情符替换为指定字符串
--]]
function replaceEmojiToEmptyStr(oriText, replaceText)
	local replaceStr = ""
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			oriText = oriText;
			replaceText = replaceText;
		}
		local ok, str = luaoc.callStaticMethod("Helper", "replaceEmojiToStr", args);
		if ok then
			replaceStr = str
		end
	elseif Common.platform == Common.TargetAndroid then
	--android
	end
	return replaceStr
end

--[[--
--复制到剪切板
--]]
function setClipboard(clipBoardText)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			clipBoardContent = clipBoardText,
		};
		luaoc.callStaticMethod("Helper", "setClipboard", args);
	elseif Common.platform == Common.TargetAndroid then
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "setClipboard"
		local javaParams = {
			clipBoardText,
		};
		luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V");
	end
end

--[[--
--获取剪切板
--]]
function getClipboard()
	if Common.platform == Common.TargetIos then
		--ios平台
		local ok, ret = luaoc.callStaticMethod("Helper", "getClipboard")
		ClipBoardConfig.checkAutoEnterRoom(ret);
	elseif Common.platform == Common.TargetAndroid then
		--android
		local function callback(parameters)
			Common.log("parameters ============= "..parameters);
			ClipBoardConfig.checkAutoEnterRoom(parameters);
		end
		local javaClassName = Load.AndroidPackage .. ".utils.Pub"
		local javaMethodName = "getClipboard"
		local javaParams = {callback};
		local ok, clipBoardData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
	end
end

--[[--
--获取经纬度
--]]
function getLocation()
    Common.log("getLocation ============= ============= ");
    if Common.platform == Common.TargetIos then
        --ios平台
        local args = {
            getLocationCallback = CommDialogConfig.gpsLocationCallback,
        };
        luaoc.callStaticMethod("GetGPSLocation", "openGPSLocation", args);

    elseif Common.platform == Common.TargetAndroid then
        --android

        local javaClassName = Load.AndroidPackage .. ".utils.Pub"
        local javaMethodName = "getLocation"
        local javaParams = { CommDialogConfig.gpsLocationCallback };
        local ok, clipBoardData = luaj.callStaticMethodPro(javaClassName, javaMethodName, javaParams, "V")
    end
end
