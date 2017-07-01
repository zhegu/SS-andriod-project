module("MahjongTableButtonLayer",package.seeall)

local TableButtonLayer = nil--

MahjongTableButtonPanel = nil;--
Panel_Menu = nil;--
Button_menu = nil;--
Button_talk = nil;--
Button_chaTing = nil;--
Panel_CaoZuo = nil;--
Button_chi = nil;--
Button_peng = nil;--
Button_gang = nil;--
Button_ting = nil;--
Button_hu = nil;--
Button_guo = nil;--
Panel_DingQue = nil;--
Button_Wan = nil;--
Button_Tong = nil;--
Button_Tiao = nil;--
Panel_ChangeCards = nil;--
Button_ChangeOK = nil;--
Panel_Room = nil;--
Button_invite = nil;--
Button_exit = nil;--
Image_jiesanfangjian = nil;--
Panel_RoomDetails = nil;--
Button_ShowDetails = nil;--
Label_closeRoomCode = nil;--
Button_CloseDetails = nil;--
Label_showRoomCode = nil;--
Label_Time = nil;--
Label_RoomTitle = nil;--
Panel_Gang_MultiSelect = nil;--
Button_GangSelect_Right = nil;--
Button_GangSelect_Middle = nil;--
Button_GangSelect_Left = nil;--
Button_GangSelect_Close = nil;--
Panel_distanceWarn = nil;--
Label_tip1 = nil;--
Label_tip2 = nil;--
Label_tip3 = nil;--

local ButtonPosList = {};--操作按钮坐标列表
local mGangCardsList = {};--多个杠牌数据
local GangCardsLayer = nil;

local lableInfos = {}; --警告信息显示

--[[--
--初始化控件
--]]
local function initTableButtonLayer()
	MahjongTableButtonPanel = cocostudio.getUIPanel(TableButtonLayer, "MahjongTableButtonPanel");
	Panel_Menu = cocostudio.getUIPanel(TableButtonLayer, "Panel_Menu");
	Button_menu = cocostudio.getUIButton(TableButtonLayer, "Button_menu");
	Button_talk = cocostudio.getUIButton(TableButtonLayer, "Button_talk");
	Button_chaTing = cocostudio.getUIButton(TableButtonLayer, "Button_chaTing");
	Panel_CaoZuo = cocostudio.getUIPanel(TableButtonLayer, "Panel_CaoZuo");
	Button_chi = cocostudio.getUIButton(TableButtonLayer, "Button_chi");
	Button_peng = cocostudio.getUIButton(TableButtonLayer, "Button_peng");
	Button_gang = cocostudio.getUIButton(TableButtonLayer, "Button_gang");
	Button_ting = cocostudio.getUIButton(TableButtonLayer, "Button_ting");
	Button_hu = cocostudio.getUIButton(TableButtonLayer, "Button_hu");
	Button_guo = cocostudio.getUIButton(TableButtonLayer, "Button_guo");
	Panel_DingQue = cocostudio.getUIPanel(TableButtonLayer, "Panel_DingQue");
	Button_Wan = cocostudio.getUIButton(TableButtonLayer, "Button_Wan");
	Button_Tong = cocostudio.getUIButton(TableButtonLayer, "Button_Tong");
	Button_Tiao = cocostudio.getUIButton(TableButtonLayer, "Button_Tiao");
	Panel_ChangeCards = cocostudio.getUIPanel(TableButtonLayer, "Panel_ChangeCards");
	Button_ChangeOK = cocostudio.getUIButton(TableButtonLayer, "Button_ChangeOK");
	Panel_Room = cocostudio.getUIPanel(TableButtonLayer, "Panel_Room");
	Button_invite = cocostudio.getUIButton(TableButtonLayer, "Button_invite");
	Button_exit = cocostudio.getUIButton(TableButtonLayer, "Button_exit");
	Image_jiesanfangjian = cocostudio.getUIImageView(TableButtonLayer, "Image_jiesanfangjian");
	Panel_RoomDetails = cocostudio.getUIPanel(TableButtonLayer, "Panel_RoomDetails");
	Button_ShowDetails = cocostudio.getUIButton(TableButtonLayer, "Button_ShowDetails");
	Label_closeRoomCode = cocostudio.getUILabel(TableButtonLayer, "Label_closeRoomCode");
	Button_CloseDetails = cocostudio.getUIButton(TableButtonLayer, "Button_CloseDetails");
	Label_showRoomCode = cocostudio.getUILabel(TableButtonLayer, "Label_showRoomCode");
	Label_Time = cocostudio.getUILabel(TableButtonLayer, "Label_Time");
	Label_RoomTitle = cocostudio.getUILabel(TableButtonLayer, "Label_RoomTitle");
	Panel_Gang_MultiSelect = cocostudio.getUIPanel(TableButtonLayer, "Panel_Gang_MultiSelect");
	Button_GangSelect_Right = cocostudio.getUIButton(TableButtonLayer, "Button_GangSelect_Right");
	Button_GangSelect_Middle = cocostudio.getUIButton(TableButtonLayer, "Button_GangSelect_Middle");
	Button_GangSelect_Left = cocostudio.getUIButton(TableButtonLayer, "Button_GangSelect_Left");
	Button_GangSelect_Close = cocostudio.getUIButton(TableButtonLayer, "Button_GangSelect_Close");
	Panel_distanceWarn = cocostudio.getUIPanel(TableButtonLayer, "Panel_distanceWarn");
	Label_tip1 = cocostudio.getUILabel(TableButtonLayer, "Label_tip1");
	Label_tip2 = cocostudio.getUILabel(TableButtonLayer, "Label_tip2");
	Label_tip3 = cocostudio.getUILabel(TableButtonLayer, "Label_tip3");

	lableInfos = {Label_tip1, Label_tip2, Label_tip3};
	hideDistanceWarn();

	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_menu"), callback_Button_menu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_talk"), callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_chaTing"), callback_Button_chaTing, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_chi"), callback_Button_chi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_peng"), callback_Button_peng, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_gang"), callback_Button_gang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_ting"), callback_Button_ting, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_hu"), callback_Button_hu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_guo"), callback_Button_guo, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_Wan"), callback_Button_Wan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_Tong"), callback_Button_Tong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_ChangeOK"), callback_Button_ChangeOK, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_Tiao"), callback_Button_Tiao, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_invite"), callback_Button_invite, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_exit"), callback_Button_exit, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_ShowDetails"), callback_Button_ShowDetails, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_CloseDetails"), callback_Button_CloseDetails, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Right"), callback_Button_GangSelect_Right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Middle"), callback_Button_GangSelect_Middle, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Left"), callback_Button_GangSelect_Left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.bindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Close"), callback_Button_GangSelect_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);

end

--[[--
--创建层
--]]
local function creatTableButtonLayer()
	TableButtonLayer = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongTableButton.json"));
	TableButtonLayer:setZOrder(3);
	initTableButtonLayer();

	hidePanelCaoZuoVisible();

	setPanelDingQueVisible(false);
	setPanelChangeCardsVisible(false);
	setPanelRoomVisible(false);
	setTingCardsListButtonVisible(false);
	hideGangMultiSelectVisible();

	if MahjongTableConsole.isTableRecordMode then
		setPanelMenuVisible(false);
	else
		setPanelMenuVisible(true);
	end

	setRoomDetailsType(true);
	initCaoZuoButton();
end

--[[--
--获取层
--]]
function getTableButtonLayer()
	if TableButtonLayer == nil then
		creatTableButtonLayer()
	end
	return TableButtonLayer
end

function setPanelMenuVisible(visible)
	Panel_Menu:setVisible(visible);
	Common.setButtonVisible(Button_menu, visible);
	Common.setButtonVisible(Button_talk, visible);
end

--[[--
--设置听牌提示按钮是否显示
--]]
function setTingCardsListButtonVisible(visible)
	Common.setButtonVisible(Button_chaTing, visible);
end

--[[--
--初始化操作按钮坐标
--]]
function initCaoZuoButton()
	local PosX = Button_hu:getPosition().x
	local PosY = Button_hu:getPosition().y
	ButtonPosList[1] = {PosX, PosY};
	local PosX = Button_ting:getPosition().x
	local PosY = Button_ting:getPosition().y
	ButtonPosList[2] = {PosX, PosY};
	local PosX = Button_gang:getPosition().x
	local PosY = Button_gang:getPosition().y
	ButtonPosList[3] = {PosX, PosY};
	local PosX = Button_peng:getPosition().x
	local PosY = Button_peng:getPosition().y
	ButtonPosList[4] = {PosX, PosY};
	local PosX = Button_chi:getPosition().x
	local PosY = Button_chi:getPosition().y
	ButtonPosList[5] = {PosX, PosY};
end

--[[--
--隐藏操作按钮
--]]
function hidePanelCaoZuoVisible()
	hideGangMultiSelectVisible();
	Panel_CaoZuo:setVisible(false);
	Common.setButtonVisible(Button_chi, false);
	Common.setButtonVisible(Button_peng, false);
	Common.setButtonVisible(Button_gang, false);
	Common.setButtonVisible(Button_ting, false);
	Common.setButtonVisible(Button_hu, false);
	Common.setButtonVisible(Button_guo, false);
end

--[[--
--刷新操作按钮
--]]
function refreshCaoZuoButton(isChi, isPeng, isHu, isGang)
	local index = 0;
	Common.log("refreshCaoZuoButton isChi =========== "..isChi)
	Common.log("refreshCaoZuoButton isPeng =========== "..isPeng)
	Common.log("refreshCaoZuoButton isHu =========== "..isHu)
	Common.log("refreshCaoZuoButton isGang =========== "..isGang)
	hidePanelCaoZuoVisible();
	Panel_CaoZuo:setVisible(true);
	if isHu == 1 then
		Common.setButtonVisible(Button_hu, true);
		index = index + 1;
		Button_hu:setPosition(ccp(ButtonPosList[index][1],ButtonPosList[index][2]));
	end
	if isGang == 1 then
		Common.setButtonVisible(Button_gang, true);
		index = index + 1;
		Button_gang:setPosition(ccp(ButtonPosList[index][1],ButtonPosList[index][2]));
	end
	if isPeng == 1 then
		Common.setButtonVisible(Button_peng, true);
		index = index + 1;
		Button_peng:setPosition(ccp(ButtonPosList[index][1],ButtonPosList[index][2]));
	end
	if isChi == 1 then
		Common.setButtonVisible(Button_chi, true);
		index = index + 1;
		Button_chi:setPosition(ccp(ButtonPosList[index][1],ButtonPosList[index][2]));
	end
	Common.setButtonVisible(Button_ting, false);
	Common.setButtonVisible(Button_guo, true);
end

--[[--
--定缺按钮
--]]
function setPanelDingQueVisible(visible)
	Panel_DingQue:setVisible(visible);
	Common.setButtonVisible(Button_Wan, visible);
	Common.setButtonVisible(Button_Tong, visible);
	Common.setButtonVisible(Button_Tiao, visible);
end

--[[--
--换牌按钮
--]]
function setPanelChangeCardsVisible(visible)
	Panel_ChangeCards:setVisible(visible);
	Common.setButtonVisible(Button_ChangeOK, visible);
end

function setPanelRoomVisible(visible)
	Panel_Room:setVisible(visible);
	Common.setButtonVisible(Button_invite, visible);
	Common.setButtonVisible(Button_exit, visible);

	if ServerConfig.isAppstoreReview() then
		Common.setButtonVisible(Button_invite, false);
	end
end

function getPanelRoomIsShow()
	return Panel_Room:isVisible();
end

--设置解散房间按钮状态
function setJieSanButtonLogo()
	if MahjongTableConsole.getSelfSeat() ~= MahjongTableConsole.mBankerSeatID then
		Image_jiesanfangjian:loadTexture("MJ_ingame_prepare_tuichufangjian.png",1);
	else
		Image_jiesanfangjian:loadTexture("MJ_ingame_prepare_btn_jsfj_zi_nor.png",1);
	end
end

--[[--
--设置房间信息
--]]
function setRoomDetailsType(show)
	Panel_RoomDetails:setVisible(true);
	if show then
		Common.setButtonVisible(Button_ShowDetails, true);
		Common.setButtonVisible(Button_CloseDetails, false);
	else
		Common.setButtonVisible(Button_ShowDetails, false);
		Common.setButtonVisible(Button_CloseDetails, true);
	end
end

--[[--
--刷新房间信息
--]]
function refreshRoomDetailsInfo()
	Label_closeRoomCode:setText("房间号："..MahjongTableConsole.mRoomID);
	Label_showRoomCode:setText("房间号："..MahjongTableConsole.mRoomID);
	Label_Time:setText(os.date("%H:%M", tonumber(Common.getServerTime())/1000));
	Label_RoomTitle:setText(""..MahjongTableConsole.mRoomTitle);
end

--[[--
--设置杠牌多选框
--]]
function hideGangMultiSelectVisible()
	mGangCardsList = {};--多个杠牌数据
	removeGangMultiSelectList();
	Panel_Gang_MultiSelect:setVisible(false);
	Common.setButtonVisible(Button_GangSelect_Right, false);
	Common.setButtonVisible(Button_GangSelect_Middle, false);
	Common.setButtonVisible(Button_GangSelect_Left, false);
	Common.setButtonVisible(Button_GangSelect_Close, false);
end

--设置距离警告
function hideDistanceWarn()
	Panel_distanceWarn:setVisible(false);
end

function setDistanceWarnVisible()
	Panel_distanceWarn:setVisible(true);
	local distanceData = MahjongLoadProfile.MahjongCreateRoomInfo.getDistanceWarningData()
	local distancelist = distanceData["InfoList"]
	for index=1, #lableInfos do
		if index <= #distancelist then
			local infoStr = distancelist[index].info
			if infoStr ~= nil then
				lableInfos[index]:setText(infoStr);
			end
		end
		TableButtonLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5.0),CCCallFuncN:create(hideDistanceWarn)))
	end
end


function removeGangMultiSelectList()
	if GangCardsLayer ~= nil then
		GangCardsLayer:removeAllChildrenWithCleanup(true);
	end
end
--[[--
--显示多个杠选择界面
--]]
function showGangMultiSelect(GangCardsList)
	mGangCardsList = GangCardsList;

	if GangCardsLayer == nil then
		GangCardsLayer = CCLayer:create();
		TableButtonLayer:addChild(GangCardsLayer);
	end

	Panel_Gang_MultiSelect:setVisible(true);
	Common.setButtonVisible(Button_GangSelect_Right, true);
	Common.setButtonVisible(Button_GangSelect_Middle, true);
	Common.setButtonVisible(Button_GangSelect_Close, true);
	if #GangCardsList == 2 then
		--两个杠
		Common.setButtonVisible(Button_GangSelect_Left, false);
	else
		--三个杠
		Common.setButtonVisible(Button_GangSelect_Left, true);
	end
	for index, CardList in pairs(mGangCardsList) do
		local CardX = 0;
		local CardY = 0;
		if index == 1 then
			--第一个杠
			CardX = Button_GangSelect_Right:getPosition().x;
			CardY = Button_GangSelect_Right:getPosition().y;
		elseif index == 2 then
			--第二个杠
			CardX = Button_GangSelect_Middle:getPosition().x;
			CardY = Button_GangSelect_Middle:getPosition().y;
		elseif index == 3 then
			--第三个杠
			CardX = Button_GangSelect_Left:getPosition().x;
			CardY = Button_GangSelect_Left:getPosition().y;
		end
		for j, value in pairs(CardList) do
			local card = MahjongTableCard:newCard(value, MahjongCardDoc.MJ_DIR_MAX, MahjongCardDoc.MJ_FACE_HAND_CARD);
			card:setCardRanks(1, 1);
			card:setCardScale(0.6);
			card:setCardPosition(CardX - (2.5 - j)*card:getContentSizeWidth(), CardY);
			GangCardsLayer:addChild(card.m_CardSprite);
		end
	end
end

--[[--
--设置出牌触摸监听
--]]
function setButtonLayerTouchEnabled(isTouchEnabled)
	TableButtonLayer:setTouchEnabled(isTouchEnabled)
end

function callback_Button_menu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_MAHJONGTABLESETTING);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_talk(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_MAHJONGCHATPOP);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_chaTing(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local table = MahjongTableConsole.getCurrTingCardList();
		MahjongTableTingCardsLayer.showTingCardListByValue(nil, table);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_invite(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local urlFront = profile.MahjongRecommend.getShareToWxUrl()
		--			roomCode=32111&miniGameId=1&packName=rew.com.cm&shareCode=&endTimeStamp
		local url = urlFront.."&roomCode="..MahjongTableConsole.mRoomID.."&miniGameId="..MahjongConfig.MahjongSichuanGameID.."&packName="..MahjongConfig.MahjongSichuanPackage.."&endTimeStamp="..MahjongTableConsole.mEndTimeStamp;

		local typeStr = "";
		if MahjongTableConsole.mnTableType == MahjongTableConsole.TABLE_TYPE_XZ then
			typeStr = "血战"
		end
		local title = "麻友局麻将:房间号【".. MahjongTableConsole.mRoomID.. "】 ".. typeStr .."麻将 ";
		GamePub.shareToWX(0, title, MahjongTableConsole.mRoomTitle, url)

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_exit(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		--牌局开始前解散房间或者是退出游戏
		mvcEngine.createModule(GUI_COMMONDIALOG);
		if MahjongTableConsole.getSelfSeat() == MahjongTableConsole.mBankerSeatID then
			--房主
			CommonDialogLogic.setData(CommonDialogLogic.getTypeTable().TYPE_DISMISSROOM_REQUEST, "您确定要解散房间吗？")
		else
			CommonDialogLogic.setData(CommonDialogLogic.getTypeTable().TYPE_EXITTABLE_REQUEST, "您确定要退出房间么？")
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_chi(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hidePanelCaoZuoVisible();
		MahjongTableCardLayer.hideTingCards();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_peng(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hidePanelCaoZuoVisible();
		--type	byte	0过 2碰 3杠 4胡
		sendMJ_SC_GAME_SELECT_ACTION_OPTION(2, MahjongTableCardLayer.getSameCardsListForOther(3));
		MahjongTableCardLayer.hideTingCards();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_gang(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hidePanelCaoZuoVisible();
		--type	byte	0过 2碰 3杠 4胡
		local GangCardsList = MahjongTableCardLayer.getGangCardsList();
		if GangCardsList ~= nil then
			--type	byte	0过 2碰 3杠 4胡
			sendMJ_SC_GAME_SELECT_ACTION_OPTION(3, GangCardsList);
		end
		MahjongTableCardLayer.hideTingCards();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_ting(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hidePanelCaoZuoVisible();
		MahjongTableCardLayer.hideTingCards();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_hu(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hidePanelCaoZuoVisible();
		--type	byte	0过 2碰 3杠 4胡
		sendMJ_SC_GAME_SELECT_ACTION_OPTION(4, nil);
		MahjongTableCardLayer.hideTingCards();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_guo(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hidePanelCaoZuoVisible();
		--type	byte	0过 2碰 3杠 4胡
		sendMJ_SC_GAME_SELECT_ACTION_OPTION(0, nil);
		MahjongTableCardLayer.hideTingCards();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Wan(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanelDingQueVisible(false);
		sendMJ_SC_GAME_SELECT_DING_QUE(0);
		MahjongTableArmature.removeDingQueAnim();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Tong(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanelDingQueVisible(false);
		sendMJ_SC_GAME_SELECT_DING_QUE(1);
		MahjongTableArmature.removeDingQueAnim();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_Tiao(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanelDingQueVisible(false);
		sendMJ_SC_GAME_SELECT_DING_QUE(2);
		MahjongTableArmature.removeDingQueAnim();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_ChangeOK(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local Cardstr = MahjongTableConsole.getChangeCards();
		if Cardstr ~= nil then
			Common.log("Cardstr ================ "..Cardstr);
			MahjongTableCardLayer.removeHandCard(0, Cardstr);
			sendMJ_SC_GAME_SELECT_CHANGE_CARD(Cardstr);
			setPanelChangeCardsVisible(false);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_ShowDetails(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setRoomDetailsType(false);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_CloseDetails(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setRoomDetailsType(true);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_GangSelect_Right(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if mGangCardsList[1] ~= nil and #mGangCardsList[1] == 4 then
			--type	byte	0过 2碰 3杠 4胡
			sendMJ_SC_GAME_SELECT_ACTION_OPTION(3, mGangCardsList[1]);
		else
			Common.showToast("杠牌数据异常", 2);
		end
		hideGangMultiSelectVisible();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_GangSelect_Middle(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if mGangCardsList[2] ~= nil and #mGangCardsList[2] == 4 then
			--type	byte	0过 2碰 3杠 4胡
			sendMJ_SC_GAME_SELECT_ACTION_OPTION(3, mGangCardsList[2]);
		else
			Common.showToast("杠牌数据异常", 2);
		end
		hideGangMultiSelectVisible();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_GangSelect_Left(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if mGangCardsList[3] ~= nil and #mGangCardsList[3] == 4 then
			--type	byte	0过 2碰 3杠 4胡
			sendMJ_SC_GAME_SELECT_ACTION_OPTION(3, mGangCardsList[3]);
		else
			Common.showToast("杠牌数据异常", 2);
		end
		hideGangMultiSelectVisible();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_GangSelect_Close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		hideGangMultiSelectVisible();
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--删除层
--]]
function reomveTableButtonLayer()
	ButtonPosList = {};--操作按钮坐标列表
	mGangCardsList = {};--多个杠牌数据
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_menu"), callback_Button_menu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_talk"), callback_Button_talk, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_chaTing"), callback_Button_chaTing, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_chi"), callback_Button_chi, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_peng"), callback_Button_peng, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_gang"), callback_Button_gang, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_ting"), callback_Button_ting, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_hu"), callback_Button_hu, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_guo"), callback_Button_guo, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_Wan"), callback_Button_Wan, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_Tong"), callback_Button_Tong, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_ChangeOK"), callback_Button_ChangeOK, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_Tiao"), callback_Button_Tiao, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_invite"), callback_Button_invite, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_exit"), callback_Button_exit, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_ShowDetails"), callback_Button_ShowDetails, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_CloseDetails"), callback_Button_CloseDetails, BUTTON_CLICK, BUTTON_SOUND_NONE + BUTTON_ANIMATION_NONE);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Right"), callback_Button_GangSelect_Right, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Middle"), callback_Button_GangSelect_Middle, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Left"), callback_Button_GangSelect_Left, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	framework.unbindEventCallback(cocostudio.getComponent(TableButtonLayer,"Button_GangSelect_Close"), callback_Button_GangSelect_Close, BUTTON_CLICK, BUTTON_SOUND_CLICK + BUTTON_ANIMATION_ZOOM_OUT);
	if GangCardsLayer ~= nil then
		GangCardsLayer:removeFromParentAndCleanup(true);
		GangCardsLayer = nil;
	end
	TableButtonLayer:removeFromParentAndCleanup(true);
	TableButtonLayer = nil
	lableInfos = {};
end
