module("MahjongLoadProfile", package.seeall)

local path = "script.loadModule.mahjongSichuan.mahjongSichuanProfile.Profile_"

MahjongGameDoc = Load.LuaRequire(path .. "MahjongGameDoc")
MahjongUserInfo = Load.LuaRequire(path .. "MahjongUserInfo")
MahjongSocial = Load.LuaRequire(path .. "MahjongSocial")

MahjongCreateRoomInfo = Load.LuaRequire(path .. "MahjongCreateRoomInfo")--创建房间
