module(..., package.seeall)

local SmallGameRewardsDataTable = {} -- 赚金榜


local SmallGameRewardsTodayDataTable = {} -- 今日赚金榜

todayRewards = 1
yesterdayRewards = 2

local SmallGameRewardsLocalTable = {}

--[[--
--加载本地小游戏赚金榜昨日榜
]]
local function loadSmallGameRewardsLocalTable()

	SmallGameRewardsLocalTable = Common.LoadTable("SmallGameRewardsLocalTable")
	if SmallGameRewardsLocalTable == nil then
		SmallGameRewardsLocalTable = {}
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.FruitGameID)] = {}
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.FruitGameID)]["TimeStamp"] = ""
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.JinHuangGuanGameID)] = {}
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.JinHuangGuanGameID)]["TimeStamp"] = ""
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.WanRenJinHuaGameID)] = {}
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.WanRenJinHuaGameID)]["TimeStamp"] = ""
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.WanRenFruitGameID)] = {}
		--		SmallGameRewardsLocalTable[tostring(GameLoadModuleConfig.WanRenFruitGameID)]["TimeStamp"] = ""
	end
end

loadSmallGameRewardsLocalTable()

--[[--
--获取排行
--]]
function getSmallGameRewardsData()
	return SmallGameRewardsDataTable
end

--[[--
--获取今日排行
--]]
function getTodayData()
    return SmallGameRewardsTodayDataTable
end

--[[--
--获取某小游戏的昨日榜时间戳
]]
function getSmallGameYesterdayTimeStamp(miniGameID)
	local gameKey = tostring(miniGameID)
	if SmallGameRewardsLocalTable[gameKey] == nil or SmallGameRewardsLocalTable[gameKey]["TimeStamp"] == nil then
		return "0"
	end
	return SmallGameRewardsLocalTable[gameKey]["TimeStamp"]
end

--[[--
--小游戏赚金榜
--]]
function readCOMMONS_GET_MINI_GAME_EARN_RANK(dataTable)
	SmallGameRewardsDataTable = dataTable

	if dataTable["Day"] == yesterdayRewards then
		local gameKey = tostring(dataTable["miniGameID"])
		if SmallGameRewardsLocalTable[gameKey] == nil or SmallGameRewardsLocalTable[gameKey]["TimeStamp"] == nil or SmallGameRewardsLocalTable[gameKey]["TimeStamp"] ~= dataTable["TimeStamp"] then
--			Common.log("重新加载小游戏昨日赚金榜 gameId == "..dataTable["miniGameID"])
			SmallGameRewardsLocalTable[gameKey] = dataTable
			Common.SaveTable("SmallGameRewardsLocalTable", SmallGameRewardsLocalTable)
		else
--			Common.log("使用本地小游戏昨日赚金榜 gameId == "..dataTable["miniGameID"])
			SmallGameRewardsDataTable = SmallGameRewardsLocalTable[gameKey]
		end
	elseif dataTable["Day"] == todayRewards then
		SmallGameRewardsTodayDataTable = dataTable
	end
	framework.emit(COMMONS_GET_MINI_GAME_EARN_RANK)
end

function releaseData()
	SmallGameRewardsDataTable = {}

	SmallGameRewardsTodayDataTable = {}
end

registerMessage(COMMONS_GET_MINI_GAME_EARN_RANK, readCOMMONS_GET_MINI_GAME_EARN_RANK);

