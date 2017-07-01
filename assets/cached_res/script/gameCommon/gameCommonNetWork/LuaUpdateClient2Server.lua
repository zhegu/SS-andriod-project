
--[[--
--lua脚本版本检测
--]]
function sendMANAGERID_LUA_SCRIPT_VERSION_V3(AppMd5)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_SCRIPT_VERSION_V3)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--netType byte 网络类型 0未知1 wifi 2 2G 33G
	nMBaseMessage:writeByte(Common.getConnectionType())
	--AppMd5 Text 客户端App文件合集的MD5
	nMBaseMessage:writeString(AppMd5)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--3.7.139 lua脚本版本资源列表路径MD5上传(MANAGERID_LUA_FILE_PATH_UP)
--@param #String BatchNum 批次号
--@param #String AppMd5 客户端App文件合集的MD5
--@param #number FileListTotalNum 资源文件总条数
--@param #table FileListTable 本次资源文件上传集合
--]]--
function sendMANAGERID_LUA_FILE_PATH_UP(BatchNum, AppMd5, FileListTotalNum, FileListTable)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_FILE_PATH_UP);
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart();

	--BatchNum	Text	批次号	用户上传唯一批次号
	nMBaseMessage:writeString(BatchNum);
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--ScriptVerCode	Int	脚本版本号	(游戏版本号+渠道号)
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--AppMd5	Text	客户端App文件合集的MD5
	nMBaseMessage:writeString(AppMd5);
	--FileListTotalNum	Int	资源文件总条数
	nMBaseMessage:writeInt(FileListTotalNum)
	--CurrUpNum	Int	本次资源文件上传集合条数
	nMBaseMessage:writeInt(#FileListTable)
	for i = 1, #FileListTable do
		--…FileAbsolutePath	Text	资源文件相对路径
		--Common.log("FileListTable.FileAbsolutePath === "..FileListTable[i].FileAbsolutePath);
		nMBaseMessage:writeString(FileListTable[i].FileAbsolutePath);
		--…FileMd5	Text	资源文件Md5
		--Common.log("FileListTable.FileMd5 === "..FileListTable[i].FileMd5);
		nMBaseMessage:writeString(FileListTable[i].FileMd5);
    end

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.168 小游戏lua动态更新(MANAGERID_MINIGAME_LUA_UPDATE)
--]]
function sendMANAGERID_MINIGAME_LUA_UPDATE(miniGameList)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LUA_UPDATE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
    --NativeReleaseDate	Int	Native发布日期
    nMBaseMessage:writeInt(Common.getNativeReleaseDate());
    --Common.log("Native发布日期 NativeReleaseDate ========= "..Common.getNativeReleaseDate());
    --PlatformCode	byte	客户端类型	1-Android（不升级）2-Html5（不升级）3-IOS（不升级）4-Lua-Android 5-Lua-IOS
    if Common.platform == Common.TargetIos then
        -- iOS平台
        nMBaseMessage:writeByte(5);
    elseif Common.platform == Common.TargetAndroid then
        --Android
        nMBaseMessage:writeByte(4);
    else
        nMBaseMessage:writeByte(4);
    end
	--MiniGameListSize	Int	列表数量
	nMBaseMessage:writeInt(#miniGameList);
	for i = 1, #miniGameList do
		--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
		nMBaseMessage:writeInt(miniGameList[i].MiniGameID);
		--…MiniGamePackage	Text	小游戏的包名
		nMBaseMessage:writeString(miniGameList[i].MiniGamePackage);
		--…ReleaseDate	Int	小游戏的发布日期	16/11/18：161118 客户端无数据则传-1
		nMBaseMessage:writeInt(miniGameList[i].ReleaseDate);
		--…MiniGameMD5	Text	小游戏的MD5	客户端无数据则传空字符串
		nMBaseMessage:writeString(miniGameList[i].MiniGameMD5);
	end

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--3.7.169 小游戏lua脚本版本资源列表路径MD5上传(MANAGERID_MINIGAME_LUA_FILE_PATH_UP)
--@param #String BatchNum 批次号
--@param #String MiniGameAppMd5 小游戏App文件合集的MD5
--@param #number FileListTotalNum 资源文件总条数
--@param #table FileListTable 本次资源文件上传集合
--@param #number ReleaseDate 小游戏的发布日期	16/11/18：161118
--@param #String package 小游戏的包名
--]]
function sendMANAGERID_MINIGAME_LUA_FILE_PATH_UP(BatchNum, MiniGameAppMd5, FileListTotalNum, FileListTable, ReleaseDate, package)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LUA_FILE_PATH_UP)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	--BatchNum	Text	批次号	用户上传唯一批次号
	nMBaseMessage:writeString(BatchNum);
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--ScriptVerCode	Int	脚本版本号	(游戏版本号+渠道号)
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--ReleaseDate	Int	小游戏的发布日期	16/11/18：161118
	nMBaseMessage:writeInt(ReleaseDate)
	--package	Text	小游戏的包名
	nMBaseMessage:writeString(package);
	--MiniGameAppMd5	Text	小游戏App文件合集的MD5
	nMBaseMessage:writeString(MiniGameAppMd5);
	--FileListTotalNum	Int	资源文件总条数
	nMBaseMessage:writeInt(FileListTotalNum)
	--CurrUpNum	Int	本次资源文件上传集合条数
	nMBaseMessage:writeInt(#FileListTable)
	for i = 1, #FileListTable do
		--…FileAbsolutePath	Text	资源文件相对路径
		--Common.log("FileListTable.FileAbsolutePath === "..FileListTable[i].FileAbsolutePath);
		nMBaseMessage:writeString(FileListTable[i].FileAbsolutePath);
		--…FileMd5	Text	资源文件Md5
		--Common.log("FileListTable.FileMd5 === "..FileListTable[i].FileMd5);
		nMBaseMessage:writeString(FileListTable[i].FileMd5);
	end

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end