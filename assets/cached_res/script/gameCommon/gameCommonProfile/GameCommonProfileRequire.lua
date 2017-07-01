module("GameCommonProfile", package.seeall)

local path = "script.gameCommon.gameCommonProfile.Profile_"

ServerList = Load.LuaRequire(path .. "ServerList")
GameCommon = Load.LuaRequire(path .. "GameCommon")
LuaScriptUpdate = Load.LuaRequire(path .. "LuaScriptUpdate")
MiniGameChat = Load.LuaRequire(path .. "MiniGameChat")
SmallGameRewards = Load.LuaRequire(path .. "SmallGameRewards")
MiniGame = Load.LuaRequire(path .. "Minigame")
GameSyncTable = Load.LuaRequire(path .. "GameSyncTable")
