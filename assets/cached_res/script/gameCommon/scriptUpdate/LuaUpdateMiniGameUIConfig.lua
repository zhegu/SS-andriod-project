module("LuaUpdateMiniGameUIConfig", package.seeall)

local MiniDownloadTagTable = {}--小游戏列表下载标签

DownloadTag = 1001;--下载标签
UpdateTag = 1002;--更新标签
NewTag = 1003;--未启动标签
TimerBgTag = 1004;--进度背景标签
TimerTag = 1005;--进度标签
ProgressTextTag = 1006;--进度文字标签

function removeMiniDownloadTag()
	MiniDownloadTagTable = {};
end


--[[--
--创建小游戏脚本更新标签
--]]
function creatUpdateMiniGameTag(MiniGameID, cellWidth, cellHeight)
	local layout = MiniGameLayer.getMiniGameIconByID(MiniGameID);
	if layout == nil then
		return;
	end

	if MiniDownloadTagTable[""..MiniGameID] ~= nil then
		--已经有下载标签
		Common.log("已经有下载标签 =========== "..MiniGameID);
		return;
	end

	MiniDownloadTagTable[""..MiniGameID] = {};
	--下载标签
	local ImgDownload = CCSprite:create(loadGameConfig.getGameCommonPath("ScriptUpdateRes/btn_hall_xiaoyouxixiazai.png"));

	if GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
		--炸金花游戏中的特殊处理
		ImgDownload:setPosition(ccp(-cellWidth*2/5, -cellHeight*2/7 + 10));
	elseif GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
		ImgDownload:setPosition(ccp(cellWidth*1/5, cellHeight*1/7));
		ImgDownload:setScale(1.69)
	else
		ImgDownload:setPosition(ccp(-cellWidth*2/5, -cellHeight*2/7));
	end
	ImgDownload:setTag(DownloadTag);
	ImgDownload:setZOrder(10);
	ImgDownload:setVisible(false);
	layout:addChild(ImgDownload);
	MiniDownloadTagTable[""..MiniGameID].ImgDownload = ImgDownload;

	--更新标签
	local ImgUpdate = CCSprite:create(loadGameConfig.getGameCommonPath("ScriptUpdateRes/btn_xiaoyouxi_gengxinanniu.png"));

	if GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID then
		--炸金花游戏中的特殊处理
		ImgUpdate:setPosition(ccp(-cellWidth*2/5, -cellHeight*2/7 + 10));
	elseif GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
		ImgUpdate:setPosition(ccp(cellWidth*1/5, cellHeight*1/7));
		ImgUpdate:setScale(1.69)
	else
		ImgUpdate:setPosition(ccp(-cellWidth*2/5, -cellHeight*2/7));
	end
	ImgUpdate:setTag(UpdateTag);
	ImgUpdate:setZOrder(10);
	ImgUpdate:setVisible(false);
	layout:addChild(ImgUpdate);
	MiniDownloadTagTable[""..MiniGameID].ImgUpdate = ImgUpdate;

	--未使用标签
	local ImgNewTag = CCSprite:create(loadGameConfig.getGameCommonPath("ScriptUpdateRes/ui_hall_new.png"));
	if GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
		ImgNewTag:setPosition(ccp(cellWidth*7/10 - 4, cellHeight*13/14 - 10));
		ImgNewTag:setScale(1.3)
	else
		ImgNewTag:setPosition(ccp(cellWidth/4 + 4, cellHeight*2/7));
	end
	ImgNewTag:setTag(NewTag);
	ImgNewTag:setZOrder(11);
	ImgNewTag:setVisible(false);
	layout:addChild(ImgNewTag);
	MiniDownloadTagTable[""..MiniGameID].ImgNewTag = ImgNewTag;

	--下载进度背景
	local ImgTimerBgTag = CCSprite:create(loadGameConfig.getGameCommonPath("ScriptUpdateRes/ui_hall_xiazaidiban.png"));
	if GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
		ImgTimerBgTag:setPosition(ccp(cellWidth/2, cellHeight/2));
		ImgTimerBgTag:setScale(1.69)
	else
		ImgTimerBgTag:setPosition(ccp(0, 0));
	end
	ImgTimerBgTag:setTag(TimerBgTag);
	ImgTimerBgTag:setZOrder(12);
	ImgTimerBgTag:setVisible(false);
	layout:addChild(ImgTimerBgTag);
	MiniDownloadTagTable[""..MiniGameID].ImgTimerBgTag = ImgTimerBgTag;

	--下载进度
	local ImgTimerTag = CCProgressTimer:create(CCSprite:create(loadGameConfig.getGameCommonPath("ScriptUpdateRes/ui_hall_xiazaitiao.png")));

	if GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
		ImgTimerTag:setPosition(ccp(cellWidth/2, cellHeight/2));
		ImgTimerTag:setScale(1.69)
	else
		ImgTimerTag:setPosition(ccp(0, 0));
	end
	ImgTimerTag:setTag(TimerTag);
	--设置进度条的样式
	ImgTimerTag:setType(kCCProgressTimerTypeRadial);
	--设置进度值范围[0,100]
	ImgTimerTag:setPercentage(0);
	ImgTimerTag:setReverseProgress(true);
	ImgTimerTag:setZOrder(13);
	ImgTimerTag:setVisible(false);
	layout:addChild(ImgTimerTag);
	MiniDownloadTagTable[""..MiniGameID].ImgTimerTag = ImgTimerTag;

	--下载进度文字显示
	local progress = CCLabelAtlas:create("0:", loadGameConfig.getGameCommonPath("ScriptUpdateRes/ui_hall_xiazaishuzibiaoqian.png"), 11, 22, 48);
	progress:setAnchorPoint(ccp(0.5, 0.5));
	if GameConfig.GAME_ID == GamePub.POKER_GAME_ID then
		progress:setPosition(ccp(cellWidth/2, cellHeight/2));
		progress:setScale(1.69)
	else
		progress:setPosition(ccp(0, 0));
	end
	progress:setTag(ProgressTextTag);
	progress:setZOrder(14);
	progress:setVisible(false);
	layout:addChild(progress);
	MiniDownloadTagTable[""..MiniGameID].progress = progress;
end

--[[--
--显示小游戏更新标签
--]]
function showUpdateMiniGameTag(MiniGameID, MiniGamePackage)
	local layout = MiniGameLayer.getMiniGameIconByID(MiniGameID);
	if layout == nil then
		return;
	end

	local ImgDownload = MiniDownloadTagTable[""..MiniGameID].ImgDownload;
	local ImgUpdate = MiniDownloadTagTable[""..MiniGameID].ImgUpdate;
	local ImgNewTag = MiniDownloadTagTable[""..MiniGameID].ImgNewTag;
	local ImgTimerBgTag = MiniDownloadTagTable[""..MiniGameID].ImgTimerBgTag;
	local ImgTimerTag = MiniDownloadTagTable[""..MiniGameID].ImgTimerTag;
	local progress = MiniDownloadTagTable[""..MiniGameID].progress;

	ImgDownload:setVisible(false);
	ImgUpdate:setVisible(false);
	ImgNewTag:setVisible(false);
	ImgTimerBgTag:setVisible(false);
	ImgTimerTag:setVisible(false);
	progress:setVisible(false);

	local luaScriptUpdateData = GameCommonProfile.LuaScriptUpdate.getLuaUpdateDataByPackage(MiniGamePackage);
	if luaScriptUpdateData == nil then
		return;
	end
	--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
	local MiniGameID = luaScriptUpdateData.MiniGameID;
	Common.log("MiniGameID == "..MiniGameID);
	--…MiniGamePackage	Text	小游戏的包名
	local MiniGamePackage = luaScriptUpdateData.MiniGamePackage;
	Common.log("MiniGamePackage == "..MiniGamePackage);
	--…downloadState	byte	小游戏下载更新状态	0：无需下载 1：需要下载 2：可以更新 3：强制更新 4：需要上传客户端资源文件MD5列表
	local downloadState = luaScriptUpdateData.downloadState;
	Common.log("小游戏下载更新状态	0：无需下载 1：需要下载 2：可以更新 3：强制更新 4：需要上传客户端资源文件MD5列表 == "..downloadState);
	--…downloadUrl	text	下载(更新)地址	差异化升级
	local downloadUrl = luaScriptUpdateData.downloadUrl;
	Common.log("downloadUrl == "..downloadUrl);
	--…downloadMsgTxt	text	下载提示文字
	local downloadMsgTxt = luaScriptUpdateData.downloadMsgTxt;
	Common.log("downloadMsgTxt == "..downloadMsgTxt);

	if downloadState == 0 or downloadState == 4 then
		--0：无需下载 4：需要上传客户端资源文件MD5列表
		if not GameLoadModuleConfig.isLaunchedMiniGame(MiniGamePackage) then
			ImgNewTag:setVisible(true);
		end
	elseif downloadState == 1 then
		--1：需要下载
		ImgDownload:setVisible(true);
	elseif downloadState == 2 or downloadState == 3 then
		--2：可以更新 3：强制更新
		ImgUpdate:setVisible(true);
	end

	if LuaUpdateConfig.getDownloadFileConfig(MiniGamePackage) == LuaUpdateConfig.DOWNLOAD_APPLY then
		--申请下载中,显示0%
		ImgTimerBgTag:setVisible(true);
		ImgTimerTag:setVisible(true);
		progress:setVisible(true);
		ImgTimerTag:setPercentage(0);
		progress:setString("0:");

		ImgDownload:setVisible(false);
		ImgUpdate:setVisible(false);
	end
end

--[[--
--更新小游戏列表下载进度UI
--]]
function updateMiniGameListUI(gamePackage, downloadFileSize, fileMaxSize)
	if gamePackage ~= LuaUpdateConfig.MainScriptPackage then
		--不是主游戏升级
		local MiniGameID = GameCommonProfile.MiniGame.getMiniGameIDByPackage(gamePackage);
		if MiniGameID == nil then
			return;
		end

		local progressPoint = downloadFileSize*100/fileMaxSize;
		--Common.log("luaScriptUpdateData.MiniGameID ========= "..MiniGameID);
		--Common.log("progressPoint ============== "..progressPoint);
		local layout = MiniGameLayer.getMiniGameIconByID(MiniGameID);
		if layout ~= nil and MiniDownloadTagTable[""..MiniGameID] ~= nil then
			--在主界面
			if MiniGameID == GameLoadModuleConfig.FruitGameID or MiniGameID == GameLoadModuleConfig.JinHuangGuanGameID then
				--水果机、金皇冠的特殊处理（同一个下载包）
				for ID = GameLoadModuleConfig.FruitGameID, GameLoadModuleConfig.JinHuangGuanGameID do
					local ImgDownload = MiniDownloadTagTable[""..ID].ImgDownload;
					local ImgUpdate = MiniDownloadTagTable[""..ID].ImgUpdate;
					local ImgNewTag = MiniDownloadTagTable[""..ID].ImgNewTag;
					local ImgTimerBgTag = MiniDownloadTagTable[""..ID].ImgTimerBgTag;
					local ImgTimerTag = MiniDownloadTagTable[""..ID].ImgTimerTag;
					local progress = MiniDownloadTagTable[""..ID].progress;

					ImgDownload:setVisible(false);
					ImgUpdate:setVisible(false);
					ImgNewTag:setVisible(false);
					ImgTimerBgTag:setVisible(true);
					ImgTimerTag:setVisible(true);
					progress:setVisible(true);

					ImgTimerTag:setPercentage(progressPoint);
					progress:setString(math.floor(progressPoint)..":");
				end
			else
				local ImgDownload = MiniDownloadTagTable[""..MiniGameID].ImgDownload;
				local ImgUpdate = MiniDownloadTagTable[""..MiniGameID].ImgUpdate;
				local ImgNewTag = MiniDownloadTagTable[""..MiniGameID].ImgNewTag;
				local ImgTimerBgTag = MiniDownloadTagTable[""..MiniGameID].ImgTimerBgTag;
				local ImgTimerTag = MiniDownloadTagTable[""..MiniGameID].ImgTimerTag;
				local progress = MiniDownloadTagTable[""..MiniGameID].progress;

				ImgDownload:setVisible(false);
				ImgUpdate:setVisible(false);
				ImgNewTag:setVisible(false);
				ImgTimerBgTag:setVisible(true);
				ImgTimerTag:setVisible(true);
				progress:setVisible(true);

				ImgTimerTag:setPercentage(progressPoint);
				progress:setString(math.floor(progressPoint)..":");
			end
		end
	end
end

--[[--
--显示下载进度
--]]
function showMiniGameDownloadProgress(progressData)
	local downloadFileSize = 0;
	local fileMaxSize = 100;
	local gamePackage = "";

	local strFileSize = "";
	local strMaxSize = "";

	if Common.platform == Common.TargetIos then
		--IOS
		strFileSize = progressData["downloadFileSize"];
		strMaxSize = progressData["fileMaxSize"];
		gamePackage = progressData["package"];
	elseif Common.platform == Common.TargetAndroid then
		--Android
		--返回数据格式:GamePackage#fileMaxSize#downloadFileSize
		local i, j = string.find(progressData, "#");
		gamePackage = string.sub(progressData, 1, i - 1);
		local tempData = string.sub(progressData, j + 1, -1);

		local i, j = string.find(tempData, "#");
		strMaxSize = string.sub(tempData, 1, i - 1);
		strFileSize = string.sub(tempData, j + 1, -1);
	end

	if strFileSize == "Error" or strMaxSize == "Error" or strFileSize == "-1" or strMaxSize == "-1" then
		Common.log("下载失败 ===================== gamePackage == "..gamePackage);
		LuaUpdateConfig.deleteDownloadFileConfig(gamePackage);
		return;
	else
		downloadFileSize = tonumber(strFileSize);
		fileMaxSize = tonumber(strMaxSize);
	end

	Common.log("downloadFileSize ======= "..downloadFileSize);
	Common.log("fileMaxSize ======= "..fileMaxSize);
	Common.log("gamePackage ======= "..gamePackage);

	if gamePackage == "" then
		return;
	end

	local MiniGameID = GameCommonProfile.MiniGame.getMiniGameIDByPackage(gamePackage);
	local layout = nil;
	if MiniGameID ~= nil then
		layout = MiniGameLayer.getMiniGameIconByID(MiniGameID);
	end
	if layout ~= nil then
		--更新小游戏列表UI
		updateMiniGameListUI(gamePackage, downloadFileSize, fileMaxSize);
	else
		if gamePackage == LuaUpdateConfig.MainScriptPackage then
			--显示主游戏下载进度条
			if mvcEngine.logicModuleIsShow(GUI_MAINLUAUPDATE) then
				MainLuaUpdateLogic.setProgressPercent(downloadFileSize, fileMaxSize);
			end
		else
			--显示小游戏下载进度条
			if mvcEngine.logicModuleIsShow(GUI_MINILUAUPDATE) then
				MiniLuaUpdateLogic.setProgressPercent(downloadFileSize, fileMaxSize);
			end
		end
	end

	if downloadFileSize == fileMaxSize then
		--下载完成
		local DocumentPath = CCFileUtils:sharedFileUtils():getWritablePath();
		Common.log("DocumentPath ==== "..DocumentPath);
		local DownloadFilePath = DocumentPath.."LoadScript/downLoad/"..gamePackage..".zip";
		Common.log("DownloadFilePath ==== "..DownloadFilePath);
		if Load.isFilePathExist(DownloadFilePath) then
			Common.log("下载完成 ===================== " .. gamePackage);
			LuaUpdateConfig.setDownloadFileConfig(gamePackage, LuaUpdateConfig.DOWNLOAD_DONE);
		end
	else
		--下载进行中
		if downloadFileSize > 0 then
			LuaUpdateConfig.setDownloadFileConfig(gamePackage, LuaUpdateConfig.DOWNLOAD_UNDERWAY);
		end
	end
end
