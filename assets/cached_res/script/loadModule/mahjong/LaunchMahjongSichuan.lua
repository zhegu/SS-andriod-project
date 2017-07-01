--小游戏四川麻将GameIDgameID
--MahjongSichuanGameID = 109

--[[--
--启动麻将牌桌内界面
--@param #string launchParam 游戏启动参数(用于启动游戏的不同玩法,可以是nil,默认是快速开始)
--launchParam格式：type#roomParam,
--type:0,创建房间;1,加入房间弹框;2,加入房间;3,公共弹框
--roomParam:0无(创建房间)/1无(加入房间弹框)/2房间号(加入房间)/3具体信息(公共弹框)
--]]
function startMiniGameBy109(launchParam)
	CommDialogConfig.closeProgressDialog();

	MahjongConfig.addCommonSpriteFrames();

	local type = -1;
	local roomParam = -1;--进房间ID/自建房间号
	if launchParam == nil then
		--默认是快速开始
		MahjongTableConsole.EnterGame();
	elseif launchParam == "GAME_SYNC" then
		--断线续玩
		sendMJ_SC_GAME_SYNC_TABLE();--请求牌桌同步
	elseif launchParam == "AppstoreReview" then
			--评审中直接创建房间进入游戏
		sendMJ_SC_MGR_CREATE_ROOM(8, 3, 1, 2, 1, 1, 0, 1, 1)
	else
		local launchParamTable = Common.FGUtilStringSplit(launchParam, "#")
		local type = launchParamTable[1];
		local roomParam = launchParamTable[2];
		if type == "0" then
			--type:0,创建房间
			sendMJ_SC_MGR_CREATE_OPTION();
		elseif type == "1" then
			--type:1,加入房间弹框
			mvcEngine.createModule(GUI_JOINROOM)
		elseif type == "2" then
			--type:2,加入房间
			sendMJ_SC_MGR_ENTER_ROOM(tonumber(roomParam))
		elseif type == "3" then
			--type:3,公共弹框
			mvcEngine.createModule(GUI_COMMONDIALOG);

			local infoTable = Common.FGUtilStringSplit(roomParam, "|")
			local moduleType = tonumber(infoTable[1]);
			local tipStr = infoTable[2];
			local otherParam = infoTable[3];
			if moduleType == CommonDialogLogic.getTypeTable().TYPE_WAPTOROOM then
				CommonDialogLogic.setRoomCode(tonumber(otherParam))
			elseif moduleType == CommonDialogLogic.getTypeTable().TYPE_VEDIO then
				CommonDialogLogic.setVideoUrl(otherParam)
			end
			CommonDialogLogic.setData(moduleType,tipStr)
		elseif type == "Record" then
			--启动牌局录像
			--roomParam:文件名
			ShowTableRecord.playTableRecord(roomParam)
		else
			--快速开始
			mvcEngine.createModule(GUI_MAHJONGTABLE);
		end
	end
end