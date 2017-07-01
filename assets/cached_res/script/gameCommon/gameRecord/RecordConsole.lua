module("RecordConsole",package.seeall)

RecordDir = "RecordFile_";

function getRecordFileDir()
	return RecordDir .. GameConfig.GAME_ID;
end

--[[--
--下载录像文件回调
--]]
local function downloadRecordFileCallBack(progressData)
	local downloadFileSize = 0;
	local fileMaxSize = 100;
	local FlieName = "";

	local strFileSize = "";
	local strMaxSize = "";

	if Common.platform == Common.TargetIos then
		--IOS
		strFileSize = progressData["downloadFileSize"];
		strMaxSize = progressData["fileMaxSize"];
		FlieName = progressData["fileName"];
	elseif Common.platform == Common.TargetAndroid then
		--Android
		--返回数据格式:GamePackage#fileMaxSize#downloadFileSize
		local i, j = string.find(progressData, "#");
		FlieName = string.sub(progressData, 1, i - 1);
		local tempData = string.sub(progressData, j + 1, -1);

		local i, j = string.find(tempData, "#");
		strMaxSize = string.sub(tempData, 1, i - 1);
		strFileSize = string.sub(tempData, j + 1, -1);
	end

	if strFileSize == "Error" or strMaxSize == "Error" or strFileSize == "-1" or strMaxSize == "-1" then
		Common.log("下载牌桌记录失败 ===================== FlieName == "..FlieName);
		return;
	else
		downloadFileSize = tonumber(strFileSize);
		fileMaxSize = tonumber(strMaxSize);
	end

	Common.log("下载牌桌记录downloadFileSize ======= "..downloadFileSize);
	Common.log("下载牌桌记录fileMaxSize ======= "..fileMaxSize);
	Common.log("下载牌桌记录FlieName ======= "..FlieName);

	if FlieName == "" then
		return;
	end

	if downloadFileSize == fileMaxSize then
		--下载完成
		local function loadRecord()
			local Info = Common.LoadCommonStoreTable(FlieName, getRecordFileDir());
			if Info ~= nil then
				Common.log("Info.MiniGameID ======== "..Info.MiniGameID);
				Common.log("Info.MiniGamePackage ======== "..Info.MiniGamePackage);
				GameLoadModuleConfig.startMiniGameByID(Info.MiniGameID, Info.MiniGamePackage,"Record#"..FlieName);
			else
				Common.log("RecordConsole 读取牌局记录数据 Info ==== nil");
			end
		end

		GamePub.delayDoFunc(CCDirector:sharedDirector():getRunningScene(), 1, loadRecord);
	else
	--下载进行中

	end
end

--[[--
--下载录像文件
--]]
function downloadRecordFile(Url)
	CommDialogConfig.showProgressDialog();

	local dir = nil;
	if Common.platform == Common.TargetIos then
		--ios平台
		dir = Common.getIOSCachesDirectoryPath(getRecordFileDir());
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		dir = Common.getTrendsSaveFilePathSD(getRecordFileDir());
	end

	local TxtList = Common.FGUtilStringSplit(Url, "/");

	DownloadControler.downloadFile(Url, dir, downloadRecordFileCallBack, TxtList[#TxtList]);
end