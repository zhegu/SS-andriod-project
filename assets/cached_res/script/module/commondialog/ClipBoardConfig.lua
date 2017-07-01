module("ClipBoardConfig", package.seeall)


local MAHJONGTAG = "mahjong";--麻将标识
local TYPE_ROOMCODE = "shareRoomCode";--分享房间邀请码
local TYPE_VIDEO = "shareVideo";--分享录像

--检查剪切板数据直接进入游戏
function checkAutoEnterRoom(clipboardStr)
	Common.log("getClipBoardRoomInfo ========================    ")
	if clipboardStr == nil or clipboardStr == "" then
		return
	end
	Common.log("getClipBoardRoomInfo clipboardStr =========    "..clipboardStr)

	--剪切板
	--房间号分享
	--mahjong:shareRoomCode|roomcode|minigameID|minigamePack|endTimeStamp
	--录像
	--mahjong:shareVedio|vedioID


	local clipboardTable = Common.FGUtilStringSplit(clipboardStr, ":")
	if clipboardTable[1] ~= MAHJONGTAG then
		return
	end

	local infoTable = Common.FGUtilStringSplit(clipboardTable[2], "|")
	local type = infoTable[1];
    Common.log("getClipBoardRoomInfo type  == "..type)
	if type == TYPE_ROOMCODE then
		--房间邀请码
		local roomCode = tonumber(infoTable[2])
		local miniGameID = tonumber(infoTable[3])
		local miniGamePack = infoTable[4]
		local endTimeStamp = tonumber(infoTable[5])

		Common.log("getClipBoardRoomInfo roomCode  == "..roomCode)
		Common.log("getClipBoardRoomInfo gameId  == "..miniGameID)
		Common.log("getClipBoardRoomInfo packName  == "..miniGamePack)
		Common.log("getClipBoardRoomInfo endTimeStamp  == "..endTimeStamp)
		Common.log("getClipBoardRoomInfo getServerTime  == "..Common.getServerTime())
		if endTimeStamp < Common.getServerTime() then

			Common.showToast("房间已过期", 2);
			Common.setClipboard("");--清空剪切板
			return;
		end

		if roomCode ~= nil and roomCode ~= "" then
			local tipStr = "您确定要加入房间 ".. roomCode .."吗？"
--			local str = "3#"..CommonDialogLogic.getTypeTable().TYPE_WAPTOROOM.."|"..tipStr.."|"..roomCode;
			local str = "3#1|"..tipStr.."|"..roomCode;
			GameLoadModuleConfig.startMiniGameByID(miniGameID, miniGamePack, str);
			Common.setClipboard("");--清空剪切板
		end
	elseif type == TYPE_VIDEO then
		--录像
        local vedioID = infoTable[2];
        Common.log("getClipBoardRoomInfo vedioID  == "..vedioID)
        sendMJ_SC_MGR_GET_ROOM_RECORD(vedioID);
	end


end