module("MiniLuaUpdateLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Image_icon = nil;--
ImageView_Bg = nil;--
BackButton = nil;--
ConfirmButton = nil;--
Label_text = nil;--
UpdateNowButton = nil;--
UpdateLaterButton = nil;--
ImageProgressBar = nil;--
ProgressBar = nil;--

local updateType = -1;
local mMiniGameID = -1;
local mMiniGamePackage = "";
local luaScriptUpdateData = {};

local MiniUpdateTypeTable = {};
MiniUpdateTypeTable.DOWNLOAD = 0;--下载
MiniUpdateTypeTable.UPDATE = 1;--可以更新
MiniUpdateTypeTable.FORCE_UPDATE = 2;--强制更新

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function getMiniLuaUpdateType()
	return MiniUpdateTypeTable;
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(loadGameConfig.getGameCommonPath("ScriptUpdateRes/commpop_update.plist"));
	local gui = GUI_MINILUAUPDATE;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("ScriptUpdateRes/MiniLuaUpdate.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("ScriptUpdateRes/MiniLuaUpdate.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Image_icon = cocostudio.getUIImageView(view, "Image_icon");
	ImageView_Bg = cocostudio.getUIImageView(view, "ImageView_Bg");
	BackButton = cocostudio.getUIButton(view, "BackButton");
	ConfirmButton = cocostudio.getUIButton(view, "ConfirmButton");
	Label_text = cocostudio.getUILabel(view, "Label_text");
	UpdateNowButton = cocostudio.getUIButton(view, "UpdateNowButton");
	UpdateLaterButton = cocostudio.getUIButton(view, "UpdateLaterButton");
	ImageProgressBar = cocostudio.getUIImageView(view, "ImageProgressBar");
	ProgressBar = cocostudio.getUILoadingBar(view, "ProgressBar");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
	ImageProgressBar:setVisible(false);
end

function requestMsg()

end

--[[--
--设置下载进度条
--]]--
function setProgressPercent(currentPro, totalPro)
	ProgressBar:setPercent(currentPro * 100 / totalPro);
	if currentPro == totalPro then
		mvcEngine.destroyModule(GUI_MINILUAUPDATE);
	end
end

local function loadMiniGameIcon(path)
	local photoPath = nil;
	local id = nil;
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = tonumber(path["id"]);
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#");
		id = tonumber(string.sub(path, 1, i - 1));
		photoPath = string.sub(path, j + 1, -1);
	end
	if photoPath ~= nil and photoPath ~= "" and id ~= nil and mMiniGameID == id then
		Common.loadImageTexture(Image_icon, photoPath);
	end
end

--[[--
--设置提示框类型
--]]
function setMiniLuaUpdateType(type, miniGameID, miniGamePackage)
	updateType = type;
	mMiniGameID = miniGameID;
	mMiniGamePackage = miniGamePackage;
	luaScriptUpdateData = GameCommonProfile.LuaScriptUpdate.getLuaUpdateDataByPackage(mMiniGamePackage);

	if updateType == MiniUpdateTypeTable.DOWNLOAD or updateType == MiniUpdateTypeTable.FORCE_UPDATE then
		--提示下载/强制更新
		Common.setButtonVisible(ConfirmButton, true);
		Common.setButtonVisible(UpdateLaterButton, false);
		Common.setButtonVisible(UpdateNowButton, false);
	elseif updateType == MiniUpdateTypeTable.UPDATE then
		--提示更新
		Common.setButtonVisible(ConfirmButton, false);
		Common.setButtonVisible(UpdateLaterButton, true);
		Common.setButtonVisible(UpdateNowButton, true);
	end

	if luaScriptUpdateData ~= nil then
		Label_text:setText(luaScriptUpdateData.downloadMsgTxt);
	else
		Common.setButtonVisible(ConfirmButton, false);
		Common.setButtonVisible(UpdateLaterButton, false);
		Common.setButtonVisible(UpdateNowButton, false);
	end

	local iconUrl = GameCommonProfile.MiniGame.getMiniGameUrlByGameID(mMiniGameID);
	if iconUrl ~= nil then
		Common.log("iconUrl ============ "..iconUrl);
		Common.getPicFile(iconUrl, mMiniGameID, true, loadMiniGameIcon);
	end

end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_MINILUAUPDATE);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_ConfirmButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.setButtonVisible(ConfirmButton, false);
		ProgressBar:setPercent(0);
		ImageProgressBar:setVisible(true);
		LuaUpdateConfig.startDownloadLuaScriptZip(luaScriptUpdateData.downloadUrl, mMiniGamePackage);
	--mvcEngine.destroyModule(GUI_MINILUAUPDATE);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_UpdateNowButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LuaUpdateConfig.startDownloadLuaScriptZip(luaScriptUpdateData.downloadUrl, mMiniGamePackage);
		mvcEngine.destroyModule(GUI_MINILUAUPDATE);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_UpdateLaterButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameLoadModuleConfig.launchMiniGameByID(mMiniGameID, mMiniGamePackage);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(loadGameConfig.getGameCommonPath("ScriptUpdateRes/commpop_update.plist"))
end

function addSlot()

end

function removeSlot()

end
