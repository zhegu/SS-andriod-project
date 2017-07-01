module("MainLuaUpdateLogic",package.seeall)

view = nil;

Panel_20 = nil;--
ImageView_Bg = nil;--
BackButton = nil;--
ConfirmButton = nil;--
Label_text = nil;--
ImageProgressBar = nil;--
ProgressBar = nil;--

local updateType = -1;
local mScriptUpdateUrl = nil;

local LuaUpdateTypeTable = {};
LuaUpdateTypeTable.DOWNLOAD = 0;--下载
LuaUpdateTypeTable.UNZIP = 1;--解压
LuaUpdateTypeTable.UPDATE_NATIVE_IOS = 2; --ios提示跳转下载新版app
LuaUpdateTypeTable.UPDATE_FORCE_NATIVE_IOS = 3; --ios提示强制跳转下载新版app
LuaUpdateTypeTable.FORCE_UPDATE_LUA = 4;--lua强制更新

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

function getLuaUpdateType()
	return LuaUpdateTypeTable;
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(loadGameConfig.getGameCommonPath("ScriptUpdateRes/commpop_update.plist"));
	local gui = GUI_MAINLUAUPDATE;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("ScriptUpdateRes/MainLuaUpdate.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("ScriptUpdateRes/MainLuaUpdate.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	ImageView_Bg = cocostudio.getUIImageView(view, "ImageView_Bg");
	BackButton = cocostudio.getUIButton(view, "BackButton");
	ConfirmButton = cocostudio.getUIButton(view, "ConfirmButton");
	Label_text = cocostudio.getUILabel(view, "Label_text");
	ImageProgressBar = cocostudio.getUIImageView(view, "ImageProgressBar");
	ProgressBar = cocostudio.getUILoadingBar(view, "ProgressBar");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
	Common.setButtonVisible(BackButton, false);
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
		CommDialogConfig.showProgressDialog();
		LuaUpdateConfig.unzipFileByPackage(LuaUpdateConfig.MainScriptPackage);
	end
end

--[[--
--设置提示框类型
--]]
function setLuaUpdateType(type, ScriptUpdateUrl)
	updateType = type;
	mScriptUpdateUrl = ScriptUpdateUrl;
	if updateType == LuaUpdateTypeTable.DOWNLOAD then
	--提示下载
	elseif updateType == LuaUpdateTypeTable.UNZIP then
		--提示更新(解压)
		Label_text:setText("亲，有新内容可以更新了！");
	elseif updateType == LuaUpdateTypeTable.UPDATE_NATIVE_IOS then
		--ios提示跳转下载新版app
		Label_text:setText("亲，有新内容可以更新了！");
		Common.setButtonVisible(BackButton, true);
	elseif updateType == LuaUpdateTypeTable.UPDATE_FORCE_NATIVE_IOS then
		--ios提示强制跳转下载新版app
		Label_text:setText("亲，有新内容可以更新了！");
	elseif updateType == LuaUpdateTypeTable.FORCE_UPDATE_LUA then
		--lua强制更新
		Label_text:setText("亲，有新内容可以更新了！");
	end
end

function callback_BackButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		LuaUpdateConfig.setCloseUpdateTime()
		mvcEngine.destroyModule(GUI_MAINLUAUPDATE);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_ConfirmButton(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if updateType == LuaUpdateTypeTable.DOWNLOAD then
			--提示下载
			mvcEngine.destroyModule(GUI_MAINLUAUPDATE);
		elseif updateType == LuaUpdateTypeTable.UNZIP then
			--提示更新(解压)
			CommDialogConfig.showProgressDialog();
			Common.setButtonVisible(ConfirmButton, false);
			LuaUpdateConfig.unzipFileByPackage(LuaUpdateConfig.MainScriptPackage);
		elseif updateType == LuaUpdateTypeTable.UPDATE_NATIVE_IOS then
			--ios提示跳转下载新版app
			local data = profileCommon.Version.getAppVersionTable()
			if data ~= nil then
				Common.openURL(data.updateUrl);
			end
		elseif updateType == LuaUpdateTypeTable.UPDATE_FORCE_NATIVE_IOS then
			--ios提示强制跳转下载新版app
			local data = profileCommon.Version.getAppVersionTable()
			if data ~= nil then
				Common.openURL(data.updateUrl);
			end
		elseif updateType == LuaUpdateTypeTable.FORCE_UPDATE_LUA then
			--lua强制更新
			if mScriptUpdateUrl ~= nil then
				Common.setButtonVisible(ConfirmButton, false);
				ProgressBar:setPercent(0);
				ImageProgressBar:setVisible(true);
				LuaUpdateConfig.startDownloadLuaScriptZip(mScriptUpdateUrl, LuaUpdateConfig.MainScriptPackage);
			end
		else
			mvcEngine.destroyModule(GUI_MAINLUAUPDATE);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	updateType = -1;
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(loadGameConfig.getGameCommonPath("ScriptUpdateRes/commpop_update.plist"))
end

function addSlot()
end

function removeSlot()
end
