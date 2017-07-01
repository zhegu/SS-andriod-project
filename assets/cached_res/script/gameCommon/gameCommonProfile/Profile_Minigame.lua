module(..., package.seeall)

local MiniGameList = {}

local MinigametypeTable = {}
local Minigame_DuiJiang_Table = {}
Minigame_DuiJiang_Table["nMultipleDetail"] = {}
Minigame_DuiJiang_Table["nMultipleDetail"][1] = {}
Minigame_DuiJiang_Table["nMultipleDetail"][1]["content"] = ""
local Minigame_DuiJiang_Table_V3 = {}
local miniGameGuideInfoTable = {}



local miniGameNeedReload = false --小游戏列表是否需要reload
local miniGameNeedRefresh = false --小游戏列表是否需要refresh

local function initMinigametypeTable(miniGameList,typeList)
	local MinigametypeTable = {}
	if miniGameList ~= nil and typeList ~= nil then
		for i = 1,#miniGameList do
			MinigametypeTable[i] = {}
			MinigametypeTable[i].MiniGameID = miniGameList[i].MiniGameID
			MinigametypeTable[i].MiniGameIconUrl = miniGameList[i].MiniGameIconUrl
			MinigametypeTable[i].MiniGamePackage = miniGameList[i].MiniGamePackage
			for j = 1,#typeList do
				if miniGameList[i].MiniGameID == typeList[j].MiniGameID then
					MinigametypeTable[i].MiniGameState = typeList[j].MiniGameState
					MinigametypeTable[i].StateMsgTxt = typeList[j].StateMsgTxt
				end
			end
		end
	end
	return MinigametypeTable
end

--[[--
--加载本地商城列表数据
]]
function loadMiniGameListTable()

	local MiniGameList = Common.LoadTable("MiniGameList")
	local MiniGameTypeList = Common.LoadTable("MiniGameTypeList" .. profile.User.getSelfUserID())
	MinigametypeTable = initMinigametypeTable(MiniGameList,MiniGameTypeList)
end

--去除不显示模块的小游戏列表
function getShowGameList(gameList)
	local itemTable = {}
	if gameList ~= nil then
		for i = 1,#gameList do
			if(gameList[i].MiniGameState ~= 0) then
				table.insert(itemTable,gameList[i])
			end
		end
	end
	return itemTable
end

--[[--
--获取小游戏列表状态信息
--]]
function getGameTypeInfo()
	--去除不显示的模块
	local itemTable = {}
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].MiniGameState ~= 0) then
			table.insert(itemTable,MinigametypeTable[i])
		end
	end
	return itemTable
end

--[[--
-- 获取小游戏icon的URL
-- ]]
function getMiniGameUrlByGameID(gameID)
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].MiniGameID == gameID) then
			return MinigametypeTable[i].MiniGameIconUrl;
		end
	end
	return nil;
end

--[[--
-- 通过ID获取小游戏包名
-- ]]
function getMiniGamePackageByID(miniGameID)
	Common.log("getMiniGamePackageByID ========== "..miniGameID);
	local MiniGameList = MinigametypeTable;
	if MiniGameList ~= nil and next(MiniGameList) ~= nil then
		for i = 1, #MiniGameList do
			--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
			local MiniGameID = MiniGameList[i].MiniGameID;
			--…MiniGamePackage	Text	小游戏的包名
			local MiniGamePackage = MiniGameList[i].MiniGamePackage;
			if MiniGameID == miniGameID then
				return MiniGamePackage;
			end
		end
		return nil;
	else
		return nil;
	end
end

--[[--
-- 通过包名获取小游戏ID
-- ]]
function getMiniGameIDByPackage(package)
	Common.log("getMiniGameIDByPackage ========== "..package);
	local MiniGameList = MinigametypeTable;
	if MiniGameList ~= nil and next(MiniGameList) ~= nil then
		for i = 1, #MiniGameList do
			--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
			local MiniGameID = MiniGameList[i].MiniGameID;
			--…MiniGamePackage	Text	小游戏的包名
			local MiniGamePackage = MiniGameList[i].MiniGamePackage;
			if MiniGamePackage == package then
				return MiniGameID;
			end
		end
		return nil;
	else
		return nil;
	end
end

--[[--
--获取上次获取小游戏列表的时间戳
--]]
function getMiNiGameStamp()
	return MinigametypeTable["timeStamp"]
end

--[[--
--是否小游戏已经全部解锁
--]]
function isAllGameUnlock()
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].MiniGameState ~= 1) then
			return false
		end
	end
	return true
end

--[[--
--获取小游戏列表图片地址
--]]
function getGameImgTable()
	--去除不显示的模块
	local imgTable = {}
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].MiniGameState ~= 0) then
			--Common.log("getGameImgTable url == " .. MinigametypeTable[i].MiniGameIconUrl)
			table.insert(imgTable,MinigametypeTable[i].MiniGameIconUrl)
		end
	end
	return imgTable
end


--[[--
--获取小游戏列表时间戳
--]]
function getMiniGameTimeStamp()
	local timeStamp = nil
	if MiniGameList == nil or MiniGameList.miniGameTimeStamp == nil then
		timeStamp = 0
	else
		timeStamp = MiniGameList.miniGameTimeStamp
	end
	return timeStamp
end

--[[--
--获取可更新的小游戏列表
--]]
function getCanUpdateMiniGameInfo()
	local itemTable = {}
	for i = 1,#MinigametypeTable do
		if(MinigametypeTable[i].isUpdate == 1) then
			table.insert(itemTable, MinigametypeTable[i])
		end
	end
	return itemTable
end

function readMANAGERID_MINIGAME_LIST_TYPE_V2(dataTable)
	MinigametypeTable = dataTable.typeList
	MinigametypeTable["timeStamp"] = Common.getServerTime()
	framework.emit(MANAGERID_MINIGAME_LIST_TYPE_V2)
end
function readMINI_COMMON_WINNING_RECORD(dataTable)
	Minigame_DuiJiang_Table	 = dataTable
	Common.setDataForSqlite("MINI_COMMON_WINNING_RECORD",Minigame_DuiJiang_Table.timestamp)
	framework.emit(MINI_COMMON_WINNING_RECORD)
end
function getMinigame_DuiJiang_Table()
	if Minigame_DuiJiang_Table~= nil and Minigame_DuiJiang_Table["nMultipleDetail"] ~= nil and Minigame_DuiJiang_Table["nMultipleDetail"][1]["content"] ~= "" then
		return Minigame_DuiJiang_Table["nMultipleDetail"][1].content
	end
end

function setMinigame_DuiJiang_TableNull()
	Minigame_DuiJiang_Table = nil
end

function getMinigame_DuiJiang_TableV2()
	if Minigame_DuiJiang_Table ~= nil and Minigame_DuiJiang_Table["nMultipleDetail"] ~= nil then
		return Minigame_DuiJiang_Table["nMultipleDetail"][1]
	end
end

--判断小游戏列表是否需要reload
function miniGameListNeedReload(serviceMiniGameTable,nativeMiniGameTable)
	if nativeMiniGameTable ~= nil and serviceMiniGameTable ~= nil then
		if #serviceMiniGameTable == #nativeMiniGameTable then
			for i = 1,#serviceMiniGameTable do
				if serviceMiniGameTable[i].MiniGameID ~= nativeMiniGameTable[i].MiniGameID then
					return true
				end
				if serviceMiniGameTable[i].MiniGameIconUrl ~= nativeMiniGameTable[i].MiniGameIconUrl then
					return true
				end
				if serviceMiniGameTable[i].MiniGamePackage ~= nativeMiniGameTable[i].MiniGamePackage then
					return true
				end
			end
		else
			return true
		end
	else
		return true
	end
	return false
end

--判断小游戏列表是否需要refresh
function miniGameListNeedRefresh(serviceMiniGameTable,nativeMiniGameTable)
	if nativeMiniGameTable ~= nil and serviceMiniGameTable ~= nil then
		if #serviceMiniGameTable == #nativeMiniGameTable then
			for i = 1,#serviceMiniGameTable do
				if serviceMiniGameTable[i].MiniGameID ~= nativeMiniGameTable[i].MiniGameID then
					return true
				end
				if serviceMiniGameTable[i].MiniGameState ~= nativeMiniGameTable[i].MiniGameState then
					return true
				end
				if serviceMiniGameTable[i].StateMsgTxt ~= nativeMiniGameTable[i].StateMsgTxt then
					return true
				end
			end
		else
			return true
		end
	else
		return true
	end
	return false
end

--获取小游戏列表是否需要reload
function getMiniGameNeedReload()
	return miniGameNeedReload
end

--获取小游戏列表是否需要refresh
function getMiniGameNeedRefresh()
	return miniGameNeedRefresh
end

--
function readMANAGERID_MINIGAME_LIST_TYPE_V3(dataTable)
	if dataTable ~= nil and dataTable["miniGameTimeStamp"] ~= nil then
		local ServerMiniGameList = dataTable.miniGameList
		local ServerMiniGameTypeList = dataTable.typeList
		local ServerMiniGameDataList = initMinigametypeTable(ServerMiniGameList,ServerMiniGameTypeList)
		local ServerMiniGameShowList = getShowGameList(ServerMiniGameDataList)

		local NativeMiniGameList = Common.LoadTable("MiniGameList")
		local NativeMiniGameTypeList = Common.LoadTable("MiniGameTypeList" .. profile.User.getSelfUserID())
		local NativeMiniGameDataList = initMinigametypeTable(NativeMiniGameList,NativeMiniGameTypeList)
		local NativeMiniGameShowList = getShowGameList(NativeMiniGameDataList)

		miniGameNeedReload = miniGameListNeedReload(ServerMiniGameShowList,NativeMiniGameShowList)
		miniGameNeedRefresh = miniGameListNeedRefresh(ServerMiniGameTypeList,NativeMiniGameTypeList)
		if miniGameNeedReload == true then
			Common.SaveTable("MiniGameList", ServerMiniGameList)
		end
		if miniGameNeedRefresh == true then
			Common.SaveTable("MiniGameTypeList" .. profile.User.getSelfUserID(), ServerMiniGameTypeList)
		end
		MinigametypeTable = initMinigametypeTable(ServerMiniGameList,ServerMiniGameTypeList)
	end
	framework.emit(MANAGERID_MINIGAME_LIST_TYPE_V3)
end

function readMINI_COMMON_RECOMMEND(dataTable)
	Minigame_DuiJiang_Table_V3	 = dataTable
	framework.emit(MINI_COMMON_RECOMMEND)
end

function getMinigame_DuiJiang_TableV3()
	return Minigame_DuiJiang_Table_V3
end

function readMINI_COMMON_NEWGUIDE(dataTable)
	miniGameGuideInfoTable = dataTable
	framework.emit(MINI_COMMON_NEWGUIDE)
end

function getMiniGameGuideInfoTable()
	return miniGameGuideInfoTable
end

function clearData()
	MinigametypeTable = {}
end

--非评审默认小游戏列表
function createMiniGame()
	local MiniGameTable = {}
	if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
		local FishGameTable = {}
		FishGameTable.MiniGameID = GameLoadModuleConfig.FishGameID;
		FishGameTable.MiniGameState = 1;
		FishGameTable.StateMsgTxt = "";
		FishGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jiejibuyu.png";
		FishGameTable.MiniGamePackage = GameLoadModuleConfig.FishPackage;
		table.insert(MiniGameTable,FishGameTable)

		local JinHuaGameTable = {}
		JinHuaGameTable.MiniGameID = GameLoadModuleConfig.JinHuaGameID
		JinHuaGameTable.MiniGameState = 1
		JinHuaGameTable.StateMsgTxt = ""
		JinHuaGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jinhua.png"
		JinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.JinHuaPackage;
		table.insert(MiniGameTable,JinHuaGameTable)

		local MillionNiuNiuGameTable = {}
		MillionNiuNiuGameTable.MiniGameID = GameLoadModuleConfig.MillionNiuNiuGameID
		MillionNiuNiuGameTable.MiniGameState = 1
		MillionNiuNiuGameTable.StateMsgTxt = ""
		MillionNiuNiuGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_bairenniuniu.png"
		MillionNiuNiuGameTable.MiniGamePackage = GameLoadModuleConfig.MillionNiuNiuPackage;
		table.insert(MiniGameTable,MillionNiuNiuGameTable)

		local HhmfTable = {}
		HhmfTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfTable.MiniGameState = 1
		HhmfTable.StateMsgTxt = ""
		HhmfTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_hhmf.png"
		HhmfTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfTable)

	elseif GameConfig.GAME_ID == GamePub.FISH_GAME_ID then
		local MillionNiuNiuGameTable = {}
		MillionNiuNiuGameTable.MiniGameID = GameLoadModuleConfig.MillionNiuNiuGameID
		MillionNiuNiuGameTable.MiniGameState = 1
		MillionNiuNiuGameTable.StateMsgTxt = ""
		MillionNiuNiuGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_bairenniuniu.png"
		MillionNiuNiuGameTable.MiniGamePackage = GameLoadModuleConfig.MillionNiuNiuPackage;
		table.insert(MiniGameTable,MillionNiuNiuGameTable)

		local JinHuaTable = {}
		JinHuaTable.MiniGameID = GameLoadModuleConfig.JinHuaGameID
		JinHuaTable.MiniGameState = 1
		JinHuaTable.StateMsgTxt = ""
		JinHuaTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jinhua.png"
		JinHuaTable.MiniGamePackage = GameLoadModuleConfig.JinHuaPackage;
		table.insert(MiniGameTable,JinHuaTable)

		local HhmfTable = {}
		HhmfTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfTable.MiniGameState = 1
		HhmfTable.StateMsgTxt = ""
		HhmfTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_hhmf.png"
		HhmfTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfTable)

		local MillionJinHuaGameTable = {}
		MillionJinHuaGameTable.MiniGameID = GameLoadModuleConfig.WanRenJinHuaGameID
		MillionJinHuaGameTable.MiniGameState = 1
		MillionJinHuaGameTable.StateMsgTxt = ""
		MillionJinHuaGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_wanrenjinhua.png"
		MillionJinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.WanRenJinHuaPackage;
		table.insert(MiniGameTable,MillionJinHuaGameTable)

	elseif GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
		local FishGameTable = {}
		FishGameTable.MiniGameID = GameLoadModuleConfig.FishGameID
		FishGameTable.MiniGameState = 1
		FishGameTable.StateMsgTxt = ""
		FishGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jiejibuyu.png"
		FishGameTable.MiniGamePackage = GameLoadModuleConfig.FishPackage;
		table.insert(MiniGameTable,FishGameTable)

		local MillionNiuNiuGameTable = {}
		MillionNiuNiuGameTable.MiniGameID = GameLoadModuleConfig.MillionNiuNiuGameID
		MillionNiuNiuGameTable.MiniGameState = 1
		MillionNiuNiuGameTable.StateMsgTxt = ""
		MillionNiuNiuGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_bairenniuniu.png"
		MillionNiuNiuGameTable.MiniGamePackage = GameLoadModuleConfig.MillionNiuNiuPackage;
		table.insert(MiniGameTable,MillionNiuNiuGameTable)

		local MillionJinHuaGameTable = {}
		MillionJinHuaGameTable.MiniGameID = GameLoadModuleConfig.WanRenJinHuaGameID
		MillionJinHuaGameTable.MiniGameState = 1
		MillionJinHuaGameTable.StateMsgTxt = ""
		MillionJinHuaGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_wanrenjinhua.png"
		MillionJinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.WanRenJinHuaPackage;
		table.insert(MiniGameTable,MillionJinHuaGameTable)

		local HhmfTable = {}
		HhmfTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfTable.MiniGameState = 1
		HhmfTable.StateMsgTxt = ""
		HhmfTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_hhmf.png"
		HhmfTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfTable)
	elseif GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID then
		--非评审：街机捕鱼、万人金花、炸金花、黑红梅方、澳门扑克（百家乐）、水果机、万人水果派、金皇冠、德州
		local FishGameTable = {}
		FishGameTable.MiniGameID = GameLoadModuleConfig.FishGameID
		FishGameTable.MiniGameState = 1
		FishGameTable.StateMsgTxt = ""
		FishGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_JJBY.png"
		FishGameTable.MiniGamePackage = GameLoadModuleConfig.FishPackage;
		table.insert(MiniGameTable,FishGameTable)

		local MillionJinHuaGameTable = {}
		MillionJinHuaGameTable.MiniGameID = GameLoadModuleConfig.WanRenJinHuaGameID
		MillionJinHuaGameTable.MiniGameState = 1
		MillionJinHuaGameTable.StateMsgTxt = ""
		MillionJinHuaGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_WRJH.png"
		MillionJinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.WanRenJinHuaPackage;
		table.insert(MiniGameTable,MillionJinHuaGameTable)

		local JinHuaGameTable = {}
		JinHuaGameTable.MiniGameID = GameLoadModuleConfig.JinHuaGameID
		JinHuaGameTable.MiniGameState = 1
		JinHuaGameTable.StateMsgTxt = ""
		JinHuaGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_ZJH.png"
		JinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.JinHuaPackage;
		table.insert(MiniGameTable,JinHuaGameTable)

		local HhmfGameTable = {}
		HhmfGameTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfGameTable.MiniGameState = 1
		HhmfGameTable.StateMsgTxt = ""
		HhmfGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_HHMF.png"
		HhmfGameTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfGameTable)
	end
	return MiniGameTable
end

--评审默认小游戏列表
function createReviewMiniGame()
	local MiniGameTable = {}
	if GameConfig.GAME_ID == GamePub.LORD_GAME_ID then
		local FishGameTable = {}
		FishGameTable.MiniGameID = GameLoadModuleConfig.FishGameID;
		FishGameTable.MiniGameState = 1;
		FishGameTable.StateMsgTxt = "";
		FishGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jiejibuyu.png";
		FishGameTable.MiniGamePackage = GameLoadModuleConfig.FishPackage;
		table.insert(MiniGameTable,FishGameTable)

		local JinHuaGameTable = {}
		JinHuaGameTable.MiniGameID = GameLoadModuleConfig.JinHuaGameID
		JinHuaGameTable.MiniGameState = 1
		JinHuaGameTable.StateMsgTxt = ""
		JinHuaGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jinhua.png"
		JinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.JinHuaPackage;
		table.insert(MiniGameTable,JinHuaGameTable)

		local MillionNiuNiuGameTable = {}
		MillionNiuNiuGameTable.MiniGameID = GameLoadModuleConfig.MillionNiuNiuGameID
		MillionNiuNiuGameTable.MiniGameState = 1
		MillionNiuNiuGameTable.StateMsgTxt = ""
		MillionNiuNiuGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_bairenniuniu.png"
		MillionNiuNiuGameTable.MiniGamePackage = GameLoadModuleConfig.MillionNiuNiuPackage;
		table.insert(MiniGameTable,MillionNiuNiuGameTable)

		local HhmfTable = {}
		HhmfTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfTable.MiniGameState = 1
		HhmfTable.StateMsgTxt = ""
		HhmfTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_hhmf.png"
		HhmfTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfTable)
	elseif GameConfig.GAME_ID == GamePub.FISH_GAME_ID then
		local MillionNiuNiuGameTable = {}
		MillionNiuNiuGameTable.MiniGameID = GameLoadModuleConfig.MillionNiuNiuGameID
		MillionNiuNiuGameTable.MiniGameState = 1
		MillionNiuNiuGameTable.StateMsgTxt = ""
		MillionNiuNiuGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_bairenniuniu.png"
		MillionNiuNiuGameTable.MiniGamePackage = GameLoadModuleConfig.MillionNiuNiuPackage;
		table.insert(MiniGameTable,MillionNiuNiuGameTable)

		local JinHuaTable = {}
		JinHuaTable.MiniGameID = GameLoadModuleConfig.JinHuaGameID
		JinHuaTable.MiniGameState = 1
		JinHuaTable.StateMsgTxt = ""
		JinHuaTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jinhua.png"
		JinHuaTable.MiniGamePackage = GameLoadModuleConfig.JinHuaPackage;
		table.insert(MiniGameTable,JinHuaTable)

		local HhmfTable = {}
		HhmfTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfTable.MiniGameState = 1
		HhmfTable.StateMsgTxt = ""
		HhmfTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_hhmf.png"
		HhmfTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfTable)

		local MillionJinHuaGameTable = {}
		MillionJinHuaGameTable.MiniGameID = GameLoadModuleConfig.WanRenJinHuaGameID
		MillionJinHuaGameTable.MiniGameState = 1
		MillionJinHuaGameTable.StateMsgTxt = ""
		MillionJinHuaGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_wanrenjinhua.png"
		MillionJinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.WanRenJinHuaPackage;
		table.insert(MiniGameTable,MillionJinHuaGameTable)
	elseif GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
		local FishGameTable = {}
		FishGameTable.MiniGameID = GameLoadModuleConfig.FishGameID
		FishGameTable.MiniGameState = 1
		FishGameTable.StateMsgTxt = ""
		FishGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jiejibuyu.png"
		FishGameTable.MiniGamePackage = GameLoadModuleConfig.FishPackage;
		table.insert(MiniGameTable,FishGameTable)

		local MillionNiuNiuGameTable = {}
		MillionNiuNiuGameTable.MiniGameID = GameLoadModuleConfig.MillionNiuNiuGameID
		MillionNiuNiuGameTable.MiniGameState = 1
		MillionNiuNiuGameTable.StateMsgTxt = ""
		MillionNiuNiuGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_bairenniuniu.png"
		MillionNiuNiuGameTable.MiniGamePackage = GameLoadModuleConfig.MillionNiuNiuPackage;
		table.insert(MiniGameTable,MillionNiuNiuGameTable)

		local MillionJinHuaGameTable = {}
		MillionJinHuaGameTable.MiniGameID = GameLoadModuleConfig.WanRenJinHuaGameID
		MillionJinHuaGameTable.MiniGameState = 1
		MillionJinHuaGameTable.StateMsgTxt = ""
		MillionJinHuaGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_wanrenjinhua.png"
		MillionJinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.WanRenJinHuaPackage;
		table.insert(MiniGameTable,MillionJinHuaGameTable)

		local HhmfTable = {}
		HhmfTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfTable.MiniGameState = 1
		HhmfTable.StateMsgTxt = ""
		HhmfTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_hhmf.png"
		HhmfTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfTable)
	elseif GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID then
		--捕鱼,万人金花、炸金花、黑红梅方、水果机、万人水果派
		local FishGameTable = {}
		FishGameTable.MiniGameID = GameLoadModuleConfig.FishGameID
		FishGameTable.MiniGameState = 1
		FishGameTable.StateMsgTxt = ""
		FishGameTable.MiniGameIconUrl = "btn_hall_xiaoyouxi_jiejibuyu.png"
		FishGameTable.MiniGamePackage = GameLoadModuleConfig.FishPackage;
		table.insert(MiniGameTable,FishGameTable)
		local MillionJinHuaGameTable = {}
		MillionJinHuaGameTable.MiniGameID = GameLoadModuleConfig.WanRenJinHuaGameID
		MillionJinHuaGameTable.MiniGameState = 1
		MillionJinHuaGameTable.StateMsgTxt = ""
		MillionJinHuaGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_WRJH.png"
		MillionJinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.WanRenJinHuaPackage;
		table.insert(MiniGameTable,MillionJinHuaGameTable)
		local JinHuaGameTable = {}
		JinHuaGameTable.MiniGameID = GameLoadModuleConfig.JinHuaGameID
		JinHuaGameTable.MiniGameState = 1
		JinHuaGameTable.StateMsgTxt = ""
		JinHuaGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_ZJH.png"
		JinHuaGameTable.MiniGamePackage = GameLoadModuleConfig.JinHuaPackage;
		table.insert(MiniGameTable,JinHuaGameTable)
		local HhmfGameTable = {}
		HhmfGameTable.MiniGameID = GameLoadModuleConfig.HhmfGameID
		HhmfGameTable.MiniGameState = 1
		HhmfGameTable.StateMsgTxt = ""
		HhmfGameTable.MiniGameIconUrl = "DN_HALL_smallgame_btn_HHMF.png"
		HhmfGameTable.MiniGamePackage = GameLoadModuleConfig.HhmfPackage;
		table.insert(MiniGameTable,HhmfGameTable)
	end
	return MiniGameTable
end

registerMessage(MINI_COMMON_NEWGUIDE, readMINI_COMMON_NEWGUIDE)
registerMessage(MINI_COMMON_RECOMMEND, readMINI_COMMON_RECOMMEND)
registerMessage(MINI_COMMON_WINNING_RECORD, readMINI_COMMON_WINNING_RECORD)
registerMessage(MANAGERID_MINIGAME_LIST_TYPE_V3, readMANAGERID_MINIGAME_LIST_TYPE_V3)
