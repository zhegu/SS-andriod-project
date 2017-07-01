module("DownloadControler",package.seeall)

--安装：即表示下载后自动执行安装操作，不需要用户确认。一般在户客户端下载或强制更新时使用。
DOWNLOAD_ACTION_A = 0;
--特殊处理：即表示在执行完下载操作后对所下载目标进行有针对性的特殊操作。需等待用户触发或其他需求。
DOWNLOAD_ACTION_B = 1;
--解压：即表示下载完成后自动进行解压操作，无需用户主动执行操作。一般用于小游戏的下载或更新。
DOWNLOAD_ACTION_C = 2;
--删除：即表示该目标在完成下载后即刻删除，不做任何其他处理。一般用于自动下载APK功能。
DOWNLOAD_ACTION_D = 3;
--通知：即表示下载成功后不做操作，只对用户进行弹通知操作。
DOWNLOAD_ACTION_E = 4;
--弹Toast：即表示下载成功后不做操作，只对用户进行弹Toast操作。
DOWNLOAD_ACTION_F = 5;
--弹启动询问：即表示下载成功后对用户进行启动询问，若用户同意则直接进入所启动程序。一般用于小游戏下载、更新或主体游戏更新。
DOWNLOAD_ACTION_G = 6;
--lua升级文件下载
DOWNLOAD_ACTION_H = 7;

--[[--
-- 下载文件
@param url 下载地址
@param dir 存放路径
@param engineId 通知ID DOWNLOAD_ACTION_A...
@param isRestriction 是否限速
@param isShowDialog 是否显示现在进度界面
@param sDownloadTips 下载提示语,传进来的为"",则会显示默认的提示语
--]]
function getDownloadFile(url, dir, engineId, isRestriction, isShowDialog, sDownloadTips)
	if sDownloadTips == nil or sDownloadTips == "" then
		sDownloadTips = "正在为您下载游戏,请稍后...";
	end

	if Common.platform == Common.TargetIos then
	--ios平台
	elseif Common.platform == Common.TargetAndroid then
		--Android平台
		local javaClassName = Load.AndroidPackage .. ".utils.LuaUpdateConsole"
		local javaMethodName = "LuaCallGetDownloadFile"
		local javaParams = {
			url,
			dir,
			engineId,
			isRestriction,
			isShowDialog,
			sDownloadTips,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
-- 下载文件
--@param #String Url 下载地址
--@param #String dir 目录
--@param #function callback 下载完成后回调
--]]
function downloadFile(Url, dir, callback, fileName)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			fileUrl = Url,
			fileDir = dir,
			callback = callback,
            name = fileName,
		}
		luaoc.callStaticMethod("DownloadFile", "startDownloadFile", args);

	elseif Common.platform == Common.TargetAndroid then
		--Android平台
		local javaClassName = Load.AndroidPackage .. ".utils.LuaUpdateConsole"
		local javaMethodName = "downloadFile"
		local javaParams = {
			Url,
			dir,
			callback,
            fileName,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

--[[--
-- 下载lua脚本升级文件
--@param #String zipUrl zip包下载地址
--@param #String gamePackage 包名
--@param #function callback 下载完成后回调
--]]
function getDownloadLuaUpdateFile(zipUrl, gamePackage, callback)
	if Common.platform == Common.TargetIos then
		--ios平台
		local args = {
			ScriptUpdateUrl = zipUrl,
			callback = callback,
			package = gamePackage,
		}
		luaoc.callStaticMethod("ScriptUpdate", "startDownloadScript", args);

	elseif Common.platform == Common.TargetAndroid then
		--Android平台
		local javaClassName = Load.AndroidPackage .. ".utils.LuaUpdateConsole"
		local javaMethodName = "getDownloadLuaUpdateFile"
		local javaParams = {
			zipUrl,
			callback,
			gamePackage,
		}
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	end
end

