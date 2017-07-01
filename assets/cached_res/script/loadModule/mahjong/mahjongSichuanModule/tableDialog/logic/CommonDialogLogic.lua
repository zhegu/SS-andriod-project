module("CommonDialogLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_24 = nil;--
Label_content = nil;--
btn_done = nil;--
ImageView_done = nil;--
btn_cancel = nil;--
Image_cancel = nil;--


local mType = 0
local typeTable = {}
typeTable.TYPE_WAPTOROOM = 1 --分享房间号进入房间
typeTable.TYPE_DISMISSROOM = 2 --解散房间投票框
typeTable.TYPE_EXITGAME = 3 --退出游戏
typeTable.TYPE_DISMISSROOM_REQUEST = 4 --解散房间询问框
typeTable.TYPE_EXITTABLE_REQUEST = 5 --退出房间询问框
typeTable.TYPE_VEDIO = 6 --查看录像询问框

local roomCode = -1; --分享房间号
local videoUrl = ""; --分享录像地址

function onKeypad(event)
	if event == "backClicked" then
		--返回键
--		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_COMMONDIALOG;
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("CommonDialog.json"));
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_24 = cocostudio.getUIPanel(view, "Panel_24");
	Label_content = cocostudio.getUILabel(view, "Label_content");
	btn_done = cocostudio.getUIButton(view, "btn_done");
	ImageView_done = cocostudio.getUIImageView(view, "ImageView_done");
	btn_cancel = cocostudio.getUIButton(view, "btn_cancel");
	Image_cancel = cocostudio.getUIImageView(view, "Image_cancel");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();

	GamePub.showDialogAmin(Panel_24)
end

function requestMsg()

end

function getTypeTable()
	return typeTable
end

function setData(m_type,content)
	Common.log("m_type ============ "..m_type)
	mType = m_type
	Label_content:setText(content)
	if mType == typeTable.TYPE_DISMISSROOM then
		ImageView_done:loadTexture("MJ_ingame_btn_fnt_agree.png",1);
		Image_cancel:loadTexture("MJ_ingame_btn_fnt_refuse.png",1);
	end
end

--设置分享房间号
function setRoomCode(id)
	roomCode = id
end

function setVideoUrl(url)
    videoUrl = url
end

function checkClose()
	if mType == typeTable.TYPE_DISMISSROOM then
		close()
	end
end

function callback_btn_done(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if mType == typeTable.TYPE_WAPTOROOM then
			--			sendMJ_SC_MGR_ENTER_ROOM(roomCode)
			GameLoadModuleConfig.startMiniGameByID(MahjongConfig.MahjongSichuanGameID, MahjongConfig.MahjongSichuanPackage,"2#"..roomCode);
		elseif mType == typeTable.TYPE_DISMISSROOM then
			sendMJ_SC_GAME_DISMISS_VOTE(1)
		elseif mType == typeTable.TYPE_EXITGAME then
			Common.AndroidExitSendOnlineTime();
		elseif mType == typeTable.TYPE_DISMISSROOM_REQUEST then
			sendMJ_SC_GAME_DISMISS_ROOM()
		elseif mType == typeTable.TYPE_EXITTABLE_REQUEST then
			sendMJ_SC_MGR_QUIT_ROOM()
        elseif mType == typeTable.TYPE_VEDIO then
            --下载录像
			RecordConsole.downloadRecordFile(videoUrl);
        end
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_cancel(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if mType == typeTable.TYPE_DISMISSROOM then
			sendMJ_SC_GAME_DISMISS_VOTE(0)
		end
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

local function closePanel()
	mvcEngine.destroyModule(GUI_COMMONDIALOG)
end

function close()
	GamePub.closeDialogAmin(Panel_24, closePanel)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	mType = 0;
	roomCode = -1;
    videoUrl = "";
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
