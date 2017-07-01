require("script.LoadFunctions");
require("script.LuaUpdateConsole");

local function main()
    --启动游戏
    LuaUpdateConsole.startGame(true);
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
	Load.log("----------------------------------------")
	local debugMsg = "LUA ERROR: " .. tostring(msg) .. "\n"
	local debugInfo = debug.traceback()
	Load.log(debugMsg)
	Load.log(debugInfo)
	Load.catchDebugInfo(debugMsg, debugInfo)
	Load.log("----------------------------------------")
end

xpcall(main, __G__TRACKBACK__)