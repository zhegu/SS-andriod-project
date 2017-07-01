module(..., package.seeall)

--[[--
--续玩通知
--]]
local function readGAMEID_SYNC_TABLE(dataTable)
	local miniGameID = dataTable["miniGameID"];
	local miniGamePackage = dataTable["miniGamePackage"];
	Common.log("续玩通知 ======== miniGameID = "..miniGameID);
	Common.log("续玩通知 ======== miniGamePackage = "..miniGamePackage);
	Common.log("续玩 ======== GameLoadModuleConfig.getLoadModuleGameID() == "..GameLoadModuleConfig.getLoadModuleGameID());
	if GameLoadModuleConfig.getLoadModuleGameID() > 0 and GameLoadModuleConfig.getLoadModuleGameID() ~= miniGameID then
		--已经在别的小游戏中，不再续玩
		Common.log("已经在别的小游戏中，不再续玩 =================== ");
		return;
	end
	if miniGameID == 0 or miniGamePackage == "" then
		return;
	end
	GameLoadModuleConfig.startMiniGameByID(miniGameID, miniGamePackage, "GAME_SYNC");
end

registerMessage(GAMEID_SYNC_TABLE, readGAMEID_SYNC_TABLE);

