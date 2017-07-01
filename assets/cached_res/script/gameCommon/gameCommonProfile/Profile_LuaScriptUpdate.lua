module(..., package.seeall)

local MainScriptUpdateData = {};--主游戏脚本升级数据
local MiniGameLuaUpdateData = {};--小游戏脚本升级数据

--[[--
--获取主游戏脚本升级数据
--]]
function getMainScriptUpdateData()
	return MainScriptUpdateData
end

--[[--
--获取小游戏脚本升级数据
--]]
function getMiniGameLuaUpdateData()
	return MiniGameLuaUpdateData
end

--[[--
--处理小游戏启动逻辑
--@return #boolean isCanLaunch 是否可以启动小游戏
--@return #boolean downloadState 下载更新状态
--]]
function logicMiniGameLaunch(MiniGamePackage)
    local luaScriptUpdateData = getLuaUpdateDataByPackage(MiniGamePackage);
    if luaScriptUpdateData == nil then
        return true, 0;
    end
    local isCanLaunch = false;
    local downloadState = luaScriptUpdateData.downloadState;
    if downloadState == 0 or downloadState == 4 then
        --0：无需下载
        --4：需要上传客户端资源文件MD5列表
        isCanLaunch = true;
    end
    return isCanLaunch, downloadState;
end

--[[--
--通过包名获取小游戏升级数据
--]]
function getLuaUpdateDataByPackage(package)
    --Common.log("getLuaUpdateDataByPackage ========== "..package);
	local MiniGameList = MiniGameLuaUpdateData["MiniGameList"];
	if MiniGameList ~= nil and next(MiniGameList) ~= nil then
		for i = 1, #MiniGameList do
			--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
			local MiniGameID = MiniGameList[i].MiniGameID;
			--…MiniGamePackage	Text	小游戏的包名
			local MiniGamePackage = MiniGameList[i].MiniGamePackage;
			--…downloadState	byte	小游戏下载更新状态	0：无需下载 1：需要下载 2：可以更新 3：强制更新 4：需要上传客户端资源文件MD5列表
			local downloadState = MiniGameList[i].downloadState;
			--…downloadUrl	text	下载(更新)地址	差异化升级
			local downloadUrl = MiniGameList[i].downloadUrl;
			--…downloadMsgTxt	text	下载提示文字
			local downloadMsgTxt = MiniGameList[i].downloadMsgTxt;
			if MiniGamePackage == package then
				return MiniGameList[i];
			end
		end
		return nil;
	else
		return nil;
	end
end

--3.7.139 lua脚本版本资源列表路径MD5上传（MANAGERID_LUA_FILE_PATH_UP)
function readMANAGERID_LUA_FILE_PATH_UP(dataTable)
	--服务器暂无应答
	framework.emit(MANAGERID_LUA_FILE_PATH_UP);
end

--3.7.168 小游戏列表中lua动态更新(MANAGERID_MINIGAME_LUA_UPDATE)
function readMANAGERID_MINIGAME_LUA_UPDATE(dataTable)
	MiniGameLuaUpdateData = dataTable;
	framework.emit(MANAGERID_MINIGAME_LUA_UPDATE)
end

--3.7.169 小游戏lua脚本版本资源列表路径MD5上传(MANAGERID_MINIGAME_LUA_FILE_PATH_UP)
function readMANAGERID_MINIGAME_LUA_FILE_PATH_UP(dataTable)
	--服务器暂无应答
	framework.emit(MANAGERID_MINIGAME_LUA_FILE_PATH_UP)
end

--3.7.170 主游戏lua脚本版本检测V3 (MANAGERID_LUA_SCRIPT_VERSION_V3)
function readMANAGERID_LUA_SCRIPT_VERSION_V3(dataTable)
	MainScriptUpdateData = dataTable;
	--Common.log("脚本版本名 == "..dataTable["ScriptVerName"])
	--updateType	byte	升级方案	0、不升级 1、后台升级(wifi、2G下均后台升级) 2、需要上传客户端资源文件MD5列表
	--Common.log("升级方案 0、不升级 1、后台升级(wifi、2G下均后台升级) 2、需要上传客户端资源文件MD5列表 == "..dataTable["updateType"])
	--Common.log("升级提示 == "..dataTable["updataTxt"])
	--Common.log("脚本升级Url地址 == "..dataTable["ScriptUpdateUrl"])
	framework.emit(MANAGERID_LUA_SCRIPT_VERSION_V3)
end

registerMessage(MANAGERID_LUA_SCRIPT_VERSION_V3, readMANAGERID_LUA_SCRIPT_VERSION_V3)
registerMessage(MANAGERID_MINIGAME_LUA_UPDATE, readMANAGERID_MINIGAME_LUA_UPDATE)
registerMessage(MANAGERID_MINIGAME_LUA_FILE_PATH_UP, readMANAGERID_MINIGAME_LUA_FILE_PATH_UP)
registerMessage(MANAGERID_LUA_FILE_PATH_UP, readMANAGERID_LUA_FILE_PATH_UP)
