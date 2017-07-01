local path = "script.gameCommon.scriptUpdate."

Load.LuaRequire(path .. "LuaUpdateConfig")
Load.LuaRequire(path .. "LuaUpdateGUIConfig")
Load.LuaRequire(path .. "LuaUpdateMiniGameUIConfig")
Load.LuaRequire(path .. "LuaUpdateModuleConfig")
Load.LuaRequire(path .. "LuaUpdateSignalConfig")

Load.LuaRequire(path .. "logic.MainLuaUpdateLogic")
Load.LuaRequire(path .. "logic.MiniLuaUpdateLogic")