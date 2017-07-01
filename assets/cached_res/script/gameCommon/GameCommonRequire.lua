local path = "script.gameCommon."

Load.LuaRequire(path .. "GameCommonConfig")
Load.LuaRequire(path .. "GameLoadModuleConfig")

Load.LuaRequire(path .. "gameCommonNetWork.GameCommonNetWorkRequire")
Load.LuaRequire(path .. "gameCommonProfile.GameCommonProfileRequire")
Load.LuaRequire(path .. "gameCommonModule.GameCommonModuleRequire")
Load.LuaRequire(path .. "gameRecord.GameRecordRequire")

-------------------------lua升级----------------------------
--文件夹名字不可以以“lua”开头
Load.LuaRequire(path .. "scriptUpdate.LuaUpdateRequire")

-------------------自定义事件---------------------
Load.LuaRequire(path .. "CustomEventConfig")