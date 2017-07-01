
--主游戏脚本版本检测
framework.addSlot2Signal(MANAGERID_LUA_SCRIPT_VERSION_V3, LuaUpdateConfig.showMainScriptUpdatePrompt, true);

--小游戏脚本版本检测
framework.addSlot2Signal(MANAGERID_MINIGAME_LUA_UPDATE, LuaUpdateConfig.showMiniGameScriptUpdatePrompt, true);

--版本检测
framework.addSlot2Signal(BASEID_PLAT_VERSION, LuaUpdateConfig.showVersionPrompt, true);