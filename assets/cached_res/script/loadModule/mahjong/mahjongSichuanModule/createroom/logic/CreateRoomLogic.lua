module("CreateRoomLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_dialog = nil;--
Panel_zipai = nil;--
Panel_jushu = nil;--
Image_games1 = nil;--
Label_games1 = nil;--
Image_games2 = nil;--
Label_games2 = nil;--
Panel_fengding = nil;--
Image_fan1 = nil;--
Label_fan1 = nil;--
Image_fan2 = nil;--
Label_fan2 = nil;--
Image_fan3 = nil;--
Label_fan3 = nil;--
Button_create_room = nil;--
Button_close = nil;--
Button_XueZhan = nil;--
Button_DeYang = nil;--
Panel_XueZhan = nil;--
Image_ziMo1 = nil;--
Image_ziMo2 = nil;--
Image_gang1 = nil;--
Image_gang2 = nil;--
Image_huanSanZhang = nil;--
Image_yaoJiu = nil;--
Image_menQing = nil;--
Image_tianDiHu = nil;--
Panel_DeYang = nil;--
Image_DeYang_ZiMo1 = nil;--
Image_DeYang_ZiMo2 = nil;--
Image_DeYang_Gang1 = nil;--
Image_DeYang_Gang2 = nil;--
Image_DeYang_YaoJiu = nil;--
Panel_28 = nil;--

local gamesItemTable = {};--局数控件列表
local fanItmeTable = {};--番数控件列表
local ziMoTable = {}; --自摸
local dianGangTable = {}; --点杠
local ziMoDeYangTable = {}; --德阳自摸
local dianGangDeYangTable = {}; --德阳点杠

--local gamesItemIndex = 1; --局数选中下标
--local fanItemIndex = 1; --番数选中下标

local gamesValue = 8;--局数：默认选择8局
local fanValue = 3;--封顶：默认选择3番
local ziMoValue = 1;--玩法：默认选择自摸加底
local dianGangHua = 2;--默认选择点杠花（自摸）
local huangSanZhang = 1;--默认勾选换三张
local yaoJiu = 1;--默认勾选幺九将对
local menQing = 0;--默认不选择门清中张
local tianDiHu = 1; --默认勾选天地胡

local ziMoDeYangValue = 1;--玩法：默认选择自摸加底
local dianGangHuaDeYang = 2;--默认选择点杠花（自摸）
local yaoJiuDeYang = 0;--默认勾选幺九将对

--界面数据
local createRoomInfo = {} --房间选项数据

local GAMESTAG = 1;  --局数
local FANTAG = 2;	--番数
local ZIMOTAG = 3; 	--自摸
local DIANGANGTAG = 4; --点杠
local ZIMO_DEYANG_TAG = 5; 	--德阳自摸
local DIANGANG_DEYANG_TAG = 6; --德阳点杠

local current_page = -1  --当前的页签

local XUEZHAN_TYPE = 1; --血战
local DEYANG_TYPE = 2; --德阳


local function close()
	mvcEngine.destroyModule(GUI_CREATEROOM)
end
function onKeypad(event)
	if event == "backClicked" then
		--返回键
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_CREATEROOM;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("create.plist"))
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("CreateRoom.json"));
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
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_dialog = cocostudio.getUIPanel(view, "Panel_dialog");
	Panel_zipai = cocostudio.getUIPanel(view, "Panel_zipai");
	Panel_jushu = cocostudio.getUIPanel(view, "Panel_jushu");
	Image_games1 = cocostudio.getUIImageView(view, "Image_games1");
	Label_games1 = cocostudio.getUILabel(view, "Label_games1");
	Image_games2 = cocostudio.getUIImageView(view, "Image_games2");
	Label_games2 = cocostudio.getUILabel(view, "Label_games2");
	Panel_fengding = cocostudio.getUIPanel(view, "Panel_fengding");
	Image_fan1 = cocostudio.getUIImageView(view, "Image_fan1");
	Label_fan1 = cocostudio.getUILabel(view, "Label_fan1");
	Image_fan2 = cocostudio.getUIImageView(view, "Image_fan2");
	Label_fan2 = cocostudio.getUILabel(view, "Label_fan2");
	Image_fan3 = cocostudio.getUIImageView(view, "Image_fan3");
	Label_fan3 = cocostudio.getUILabel(view, "Label_fan3");
	Button_create_room = cocostudio.getUIButton(view, "Button_create_room");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Button_XueZhan = cocostudio.getUIButton(view, "Button_XueZhan");
	Button_DeYang = cocostudio.getUIButton(view, "Button_DeYang");
	Panel_XueZhan = cocostudio.getUIPanel(view, "Panel_XueZhan");
	Image_ziMo1 = cocostudio.getUIImageView(view, "Image_ziMo1");
	Image_ziMo2 = cocostudio.getUIImageView(view, "Image_ziMo2");
	Image_gang1 = cocostudio.getUIImageView(view, "Image_gang1");
	Image_gang2 = cocostudio.getUIImageView(view, "Image_gang2");
	Image_huanSanZhang = cocostudio.getUIImageView(view, "Image_huanSanZhang");
	Image_yaoJiu = cocostudio.getUIImageView(view, "Image_yaoJiu");
	Image_menQing = cocostudio.getUIImageView(view, "Image_menQing");
	Image_tianDiHu = cocostudio.getUIImageView(view, "Image_tianDiHu");
	Panel_DeYang = cocostudio.getUIPanel(view, "Panel_DeYang");
	Image_DeYang_ZiMo1 = cocostudio.getUIImageView(view, "Image_DeYang_ZiMo1");
	Image_DeYang_ZiMo2 = cocostudio.getUIImageView(view, "Image_DeYang_ZiMo2");
	Image_DeYang_Gang1 = cocostudio.getUIImageView(view, "Image_DeYang_Gang1");
	Image_DeYang_Gang2 = cocostudio.getUIImageView(view, "Image_DeYang_Gang2");
	Image_DeYang_YaoJiu = cocostudio.getUIImageView(view, "Image_DeYang_YaoJiu");
	Panel_28 = cocostudio.getUIPanel(view, "Panel_28");

	gamesItemTable = {}
	gamesItemTable[1] = {}
	gamesItemTable[1].gamesItem = Image_games1
	gamesItemTable[1].gamesLabel = Label_games1
	gamesItemTable[2] = {}
	gamesItemTable[2].gamesItem = Image_games2
	gamesItemTable[2].gamesLabel = Label_games2

	fanItmeTable = {}
	fanItmeTable[1] = {}
	fanItmeTable[1].gamesItem = Image_fan1
	fanItmeTable[1].gamesLabel = Label_fan1
	fanItmeTable[2] = {}
	fanItmeTable[2].gamesItem = Image_fan2
	fanItmeTable[2].gamesLabel = Label_fan2
	fanItmeTable[3] = {}
	fanItmeTable[3].gamesItem = Image_fan3
	fanItmeTable[3].gamesLabel = Label_fan3

	ziMoTable = {Image_ziMo1, Image_ziMo2}
	dianGangTable = {Image_gang1, Image_gang2}

	ziMoDeYangTable = {Image_DeYang_ZiMo1, Image_DeYang_ZiMo2}
	dianGangDeYangTable = {Image_DeYang_Gang1, Image_DeYang_Gang2}

end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();

	initData()
end

function requestMsg()
	changePage(XUEZHAN_TYPE)
end

--[[--
--@param #Int itemTag 选项标志
--@param #Int index 选项下标
--]]--
local function seletItems(itemTag, index)
	if itemTag == GAMESTAG then
		--局数
		for i=1, #gamesItemTable do
			if i == index then
				gamesItemTable[i].gamesItem:setVisible(true)
				gamesValue = createRoomInfo["JuShuList"][index].value
			else
				gamesItemTable[i].gamesItem:setVisible(false)
			end
		end
	elseif itemTag == FANTAG then
		--番数
		for i=1, #fanItmeTable do
			if i == index then
				fanItmeTable[i].gamesItem:setVisible(true)
				fanValue = createRoomInfo["fanList"][index].value
			else
				fanItmeTable[i].gamesItem:setVisible(false)
			end
		end
	elseif itemTag == ZIMOTAG then
		for i=1, #ziMoTable do
			if i == index then
				ziMoTable[i]:setVisible(true)
				ziMoValue = index
			else
				ziMoTable[i]:setVisible(false)
			end
		end
	elseif itemTag == DIANGANGTAG then
		for i=1, #dianGangTable do
			if i == index then
				dianGangTable[i]:setVisible(true)
				dianGangHua = index
			else
				dianGangTable[i]:setVisible(false)
			end
		end
	elseif itemTag == ZIMO_DEYANG_TAG then
		for i=1, #ziMoDeYangTable do
			if i == index then
				ziMoDeYangTable[i]:setVisible(true)
				ziMoDeYangValue = index
			else
				ziMoDeYangTable[i]:setVisible(false)
			end
		end
	elseif itemTag == DIANGANG_DEYANG_TAG then
		for i=1, #dianGangDeYangTable do
			if i == index then
				dianGangDeYangTable[i]:setVisible(true)
				dianGangHuaDeYang = index
			else
				dianGangDeYangTable[i]:setVisible(false)
			end
		end
	end
end

function initData()
	createRoomInfo = MahjongLoadProfile.MahjongCreateRoomInfo.getCreateRoomInfoTable()
	local JuShuList = createRoomInfo["JuShuList"]
	local fanList = createRoomInfo["fanList"]

	for i=1, #gamesItemTable do
		--		local value = JuShuList[i].value
		local text = JuShuList[i].text
		gamesItemTable[i].gamesLabel:setText(text);
	--		if value == gamesValue then
	--			gamesItemIndex = i;
	--			selectGamesItem(gamesItemIndex)
	--		end
	end
	for i=1, #fanItmeTable do
		--		local value = fanList[i].value
		local text = fanList[i].text
		fanItmeTable[i].gamesLabel:setText(text);
	--		if value == fanValue then
	--			fanItemIndex = i;
	--			selectFanItem(fanItemIndex)
	--		end
	end

end

--设置血战玩法的显隐
local function setXueZhanVisible(isVisible)
	if isVisible then
		Button_XueZhan:loadTextures("MJ_ingame_btn_jiantouanniu_nor.png", "MJ_ingame_btn_jiantouanniu_nor.png", "",1)
	else
		Button_XueZhan:loadTextures("MJ_ingame_btn_jiantouanniu_nor_brown.png", "MJ_ingame_btn_jiantouanniu_nor_brown.png", "",1)
	end
	Panel_XueZhan:setVisible(isVisible)
	Image_ziMo1:setTouchEnabled(isVisible)
	Image_ziMo2:setTouchEnabled(isVisible)
	Image_gang1:setTouchEnabled(isVisible)
	Image_gang2:setTouchEnabled(isVisible)
	Image_huanSanZhang:setTouchEnabled(isVisible)
	Image_yaoJiu:setTouchEnabled(isVisible)
	Image_menQing:setTouchEnabled(isVisible)
	Image_tianDiHu:setTouchEnabled(isVisible)
end

--设置德阳玩法的显隐
local function setDeYangVisible(isVisible)
	if isVisible then
		Button_DeYang:loadTextures("MJ_ingame_btn_jiantouanniu_nor.png", "MJ_ingame_btn_jiantouanniu_nor.png", "",1)
	else
		Button_DeYang:loadTextures("MJ_ingame_btn_jiantouanniu_nor_brown.png", "MJ_ingame_btn_jiantouanniu_nor_brown.png", "",1)
	end
	Panel_DeYang:setVisible(isVisible)
	Image_DeYang_ZiMo1:setTouchEnabled(isVisible)
	Image_DeYang_ZiMo2:setTouchEnabled(isVisible)
	Image_DeYang_Gang1:setTouchEnabled(isVisible)
	Image_DeYang_Gang2:setTouchEnabled(isVisible)
	Image_DeYang_YaoJiu:setTouchEnabled(isVisible)
end

--[[--
--切换页签
--]]--
function changePage(page)
	if current_page == page then
		return
	end
	current_page = page

	setXueZhanVisible(false)
	setDeYangVisible(false)

	if current_page == XUEZHAN_TYPE then
		setXueZhanVisible(true)
	elseif current_page == DEYANG_TYPE then
		setDeYangVisible(true)
	end
end

function callback_Image_games1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(GAMESTAG, 1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_games2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(GAMESTAG, 2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_fan1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(FANTAG,1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_fan2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(FANTAG,2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_fan3(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(FANTAG,3)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_create_room(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if current_page == XUEZHAN_TYPE then
			sendMJ_SC_MGR_CREATE_ROOM(gamesValue, fanValue, ziMoValue, dianGangHua, huangSanZhang, yaoJiu, menQing, tianDiHu, XUEZHAN_TYPE)
		else
			sendMJ_SC_MGR_CREATE_ROOM(gamesValue, fanValue, ziMoDeYangValue, dianGangHuaDeYang, 0, yaoJiuDeYang, 0, 0, DEYANG_TYPE)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_XueZhan(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		changePage(XUEZHAN_TYPE)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_DeYang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		changePage(DEYANG_TYPE)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_ziMo1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(ZIMOTAG,1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_ziMo2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(ZIMOTAG,2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_gang1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(DIANGANGTAG,1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_gang2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(DIANGANGTAG,2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_huanSanZhang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		huangSanZhang = (huangSanZhang + 1) % 2
		if huangSanZhang == 0 then
			Image_huanSanZhang:setVisible(false)
		else
			Image_huanSanZhang:setVisible(true)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_yaoJiu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		yaoJiu = (yaoJiu + 1) % 2
		if yaoJiu == 0 then
			Image_yaoJiu:setVisible(false)
		else
			Image_yaoJiu:setVisible(true)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_menQing(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		menQing = (menQing + 1) % 2
		if menQing == 0 then
			Image_menQing:setVisible(false)
		else
			Image_menQing:setVisible(true)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_tianDiHu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		tianDiHu = (tianDiHu + 1) % 2
		if tianDiHu == 0 then
			Image_tianDiHu:setVisible(false)
		else
			Image_tianDiHu:setVisible(true)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_DeYang_ZiMo1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(ZIMO_DEYANG_TAG,1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_DeYang_ZiMo2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(ZIMO_DEYANG_TAG,2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_DeYang_Gang1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(DIANGANG_DEYANG_TAG,1)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_DeYang_Gang2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		seletItems(DIANGANG_DEYANG_TAG,2)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_DeYang_YaoJiu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		yaoJiuDeYang = (yaoJiuDeYang + 1) % 2
		if yaoJiuDeYang == 0 then
			Image_DeYang_YaoJiu:setVisible(false)
		else
			Image_DeYang_YaoJiu:setVisible(true)
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

local function slot_MJ_SC_MGR_CREATE_ROOM()
	local createRoomBackInfo = MahjongLoadProfile.MahjongCreateRoomInfo.getCreateRoomResultTable()

	-- Result	Byte	1成功0失败
	local Result = createRoomBackInfo["Result"]
	-- Message	String	结果提示
	local Message = createRoomBackInfo["Message"]

	Common.showToast(Message,2)

end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("create.plist"))

	gamesItemTable = {};--局数控件列表
	fanItmeTable = {};--番数控件列表
	ziMoTable = {};
	dianGangTable = {};
	ziMoDeYangTable = {}; --德阳自摸
	dianGangDeYangTable = {}; --德阳点杠

	gamesValue = 8;--局数：默认选择8局
	fanValue = 3;--封顶：默认选择3番
	ziMoValue = 1;--玩法：默认选择自摸加底
	dianGangHua = 2;--默认选择点杠花（自摸）
	huangSanZhang = 1;--默认勾选换三张
	yaoJiu = 1;--默认勾选幺九将对
	menQing = 0;--默认不选择门清中张
	tianDiHu = 1; --默认勾选天地胡

	--界面数据
	createRoomInfo = {} --房间选项数据

	current_page = -1;
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_CREATE_ROOM, slot_MJ_SC_MGR_CREATE_ROOM)
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_CREATE_ROOM, slot_MJ_SC_MGR_CREATE_ROOM)
end
