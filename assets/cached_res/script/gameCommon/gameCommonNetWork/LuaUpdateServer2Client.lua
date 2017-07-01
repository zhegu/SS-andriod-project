
--[[--
--3.7.170 主游戏lua脚本版本检测V3 (MANAGERID_LUA_SCRIPT_VERSION_V3)
--]]
function read800700aa(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_LUA_SCRIPT_VERSION_V3
	dataTable["messageName"] = "MANAGERID_LUA_SCRIPT_VERSION_V3"

	--ScriptVerName	Text	脚本版本名
	dataTable["ScriptVerName"] = nMBaseMessage:readString();
	--updateType	byte	升级方案	0、不升级 1、后台升级(wifi、2G下均后台升级) 2、需要上传客户端资源文件MD5列表
	dataTable["updateType"] = nMBaseMessage:readByte();
	--updataTxt	Text	升级提示
	dataTable["updataTxt"] = nMBaseMessage:readString();
	--ScriptUpdateUrl	Text	脚本升级Url地址
	dataTable["ScriptUpdateUrl"] = nMBaseMessage:readString();

	return dataTable
end

--[[--
--3.7.171 小游戏lua动态更新(MANAGERID_MINIGAME_LUA_UPDATE)
--]]
function read800700ab(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MINIGAME_LUA_UPDATE
	dataTable["messageName"] = "MANAGERID_MINIGAME_LUA_UPDATE"

	dataTable["MiniGameList"] = {}
	--MiniGameList	Loop Loop
	local MiniGameListSize = tonumber(nMBaseMessage:readInt());
    --Common.log("MiniGameListSize ======= "..MiniGameListSize);
	for i = 1, MiniGameListSize do
		dataTable["MiniGameList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["MiniGameList"][i].MiniGameID = tonumber(nMBaseMessage:readInt());
		--…MiniGamePackage	Text	小游戏的包名
		dataTable["MiniGameList"][i].MiniGamePackage = nMBaseMessage:readString();
		--…downloadState	byte	小游戏下载更新状态	0：无需下载 1：需要下载 2：可以更新 3：强制更新 4：需要上传客户端资源文件MD5列表
		dataTable["MiniGameList"][i].downloadState = nMBaseMessage:readByte();
		--…downloadUrl	text	下载(更新)地址	差异化升级
		dataTable["MiniGameList"][i].downloadUrl = nMBaseMessage:readString();
		--…downloadMsgTxt	text	下载提示文字
		dataTable["MiniGameList"][i].downloadMsgTxt = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end
