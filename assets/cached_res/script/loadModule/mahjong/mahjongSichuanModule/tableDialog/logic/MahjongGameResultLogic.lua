module("MahjongGameResultLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_3 = nil;--
Label_TableInfo = nil;--
Panel_Pos0_Player = nil;--
Pos0_Image_photo = nil;--
Pos0_Image_front = nil;--
Pos0_name = nil;--
Pos0_fan_txt = nil;--
Pos0_fan_number = nil;--
Pos0_score = nil;--
Pos0_Image_hu_number = nil;--
Panel_Pos1_Player = nil;--
Pos1_Image_photo = nil;--
Pos1_Image_front = nil;--
Pos1_name = nil;--
Pos1_fan_txt = nil;--
Pos1_fan_number = nil;--
Pos1_score = nil;--
Pos1_Image_hu_number = nil;--
Panel_Pos2_Player = nil;--
Pos2_Image_photo = nil;--
Pos2_Image_front = nil;--
Pos2_name = nil;--
Pos2_fan_txt = nil;--
Pos2_fan_number = nil;--
Pos2_score = nil;--
Pos2_Image_hu_number = nil;--
Panel_Pos3_Player = nil;--
Pos3_Image_photo = nil;--
Pos3_Image_front = nil;--
Pos3_name = nil;--
Pos3_fan_txt = nil;--
Pos3_fan_number = nil;--
Pos3_score = nil;--
Pos3_Image_hu_number = nil;--
Button_share = nil;--
Button_next = nil;--

local GameResultCards = {};
local GameResultCardLayer = nil;

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGGAMERESULT);
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	--		close();
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_result.plist"));
	local gui = GUI_MAHJONGGAMERESULT;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongGameResult.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongGameResult.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_3 = cocostudio.getUIPanel(view, "Panel_3");
	Label_TableInfo = cocostudio.getUILabel(view, "Label_TableInfo");
	Panel_Pos0_Player = cocostudio.getUIPanel(view, "Panel_Pos0_Player");
	Pos0_Image_photo = cocostudio.getUIImageView(view, "Pos0_Image_photo");
	Pos0_Image_front = cocostudio.getUIImageView(view, "Pos0_Image_front");
	Pos0_name = cocostudio.getUILabel(view, "Pos0_name");
	Pos0_fan_txt = cocostudio.getUILabel(view, "Pos0_fan_txt");
	Pos0_fan_number = cocostudio.getUILabel(view, "Pos0_fan_number");
	Pos0_score = cocostudio.getUILabel(view, "Pos0_score");
	Pos0_Image_hu_number = cocostudio.getUIImageView(view, "Pos0_Image_hu_number");
	Panel_Pos1_Player = cocostudio.getUIPanel(view, "Panel_Pos1_Player");
	Pos1_Image_photo = cocostudio.getUIImageView(view, "Pos1_Image_photo");
	Pos1_Image_front = cocostudio.getUIImageView(view, "Pos1_Image_front");
	Pos1_name = cocostudio.getUILabel(view, "Pos1_name");
	Pos1_fan_txt = cocostudio.getUILabel(view, "Pos1_fan_txt");
	Pos1_fan_number = cocostudio.getUILabel(view, "Pos1_fan_number");
	Pos1_score = cocostudio.getUILabel(view, "Pos1_score");
	Pos1_Image_hu_number = cocostudio.getUIImageView(view, "Pos1_Image_hu_number");
	Panel_Pos2_Player = cocostudio.getUIPanel(view, "Panel_Pos2_Player");
	Pos2_Image_photo = cocostudio.getUIImageView(view, "Pos2_Image_photo");
	Pos2_Image_front = cocostudio.getUIImageView(view, "Pos2_Image_front");
	Pos2_name = cocostudio.getUILabel(view, "Pos2_name");
	Pos2_fan_txt = cocostudio.getUILabel(view, "Pos2_fan_txt");
	Pos2_fan_number = cocostudio.getUILabel(view, "Pos2_fan_number");
	Pos2_score = cocostudio.getUILabel(view, "Pos2_score");
	Pos2_Image_hu_number = cocostudio.getUIImageView(view, "Pos2_Image_hu_number");
	Panel_Pos3_Player = cocostudio.getUIPanel(view, "Panel_Pos3_Player");
	Pos3_Image_photo = cocostudio.getUIImageView(view, "Pos3_Image_photo");
	Pos3_Image_front = cocostudio.getUIImageView(view, "Pos3_Image_front");
	Pos3_name = cocostudio.getUILabel(view, "Pos3_name");
	Pos3_fan_txt = cocostudio.getUILabel(view, "Pos3_fan_txt");
	Pos3_fan_number = cocostudio.getUILabel(view, "Pos3_fan_number");
	Pos3_score = cocostudio.getUILabel(view, "Pos3_score");
	Pos3_Image_hu_number = cocostudio.getUIImageView(view, "Pos3_Image_hu_number");

	Button_share = cocostudio.getUIButton(view, "Button_share");
	Button_next = cocostudio.getUIButton(view, "Button_next");

	if ServerConfig.isAppstoreReview() then
		Common.setButtonVisible(Button_share, false);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();

	GameResultCardLayer = CCLayer:create();
	view:addChild(GameResultCardLayer);

	--refreshGameResultInfo();
	if MahjongTableConsole.isTableRecordMode then
		Common.setButtonVisible(Button_share, false);
		Common.setButtonVisible(Button_next, false);
	else
		Common.setButtonVisible(Button_share, true);
		Common.setButtonVisible(Button_next, true);
	end
end

function requestMsg()

end

local function setPlayerInfo(Pos)

end

--[[--
--牌桌头像下载回调
--]]
local function updataPlayerPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	local Image_userPhoto = cocostudio.getUIImageView(view, "Pos" .. id .. "_Image_photo");
	if photoPath ~= nil and photoPath ~= "" and Image_userPhoto ~= nil then
		Image_userPhoto:loadTexture(photoPath)
	end
end

--[[--
--添加放下的手牌
--@param #number nPos 位置
--@param #table cardsInfoTable 操作类型
--]]
local function addGameResultCards(nPos, cardsInfoTable, isGameResult)
	GameResultCards[nPos + 1] = {};
	local cardGroupSize = #cardsInfoTable;
	for i = 1, cardGroupSize do
		--    ...cardType	Byte	操作类型	牌型1：顺子 牌型3：碰 牌型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡实牌  牌型8：胡虚牌
		local cardType = cardsInfoTable[i].cardType;
		Common.log("cardType =============== "..cardType);
		--    ...cardStr	Text	卡组牌值，逗号隔开	没牌值的玩家是-1逗号隔开 暗杠牌值其他家为-1
		local cardStr = cardsInfoTable[i].cardStr;
		Common.log("cardStr =============== "..cardStr);
		local cardsValTable = Common.FGUtilStringSplit(cardStr, ",");
		--    ...FromSeatID	Byte	吃碰杠外来的牌来源座位号
		local FromSeatID = -1;
		if cardsInfoTable[i].FromSeatID ~= nil then
			FromSeatID = cardsInfoTable[i].FromSeatID;
		end
		Common.log("FromSeatID =============== "..FromSeatID);

		GameResultCards[nPos + 1][i] = {};

		for j = 1, #cardsValTable do
			local value = tonumber(cardsValTable[j]);
			Common.log("addGameResultCards  = " .. value);
			local card = nil;
			local nDir = MahjongCardDoc.MJ_DIR_GAME_RESULT;
			local nFace = -1;
			if cardType == 5 then
				--牌型5：暗杠
				nFace = MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD;
			elseif cardType == 6 then
				--牌型6：亮手牌
				nFace = MahjongCardDoc.MJ_FACE_HAND_CARD;
			elseif cardType == 7 or cardType == 8 then
				--牌型7：胡实牌  牌型8：胡虚牌
				nFace = MahjongCardDoc.MJ_FACE_HU_CARD;
			else
				--牌型1：顺子--牌型3：碰--牌型4：明杠
				nFace = MahjongCardDoc.MJ_FACE_PUTDOWN_CARD;
			end

			card = MahjongTableCard:newCard(value, nDir, nFace);
			table.insert(GameResultCards[nPos + 1][i], card);
		end

		if cardType == 6 then
			--牌型6：手牌
			MahjongTableCardManage.SortCardVal(GameResultCards[nPos + 1][i], MahjongTableCardManage.SORT_MODE_COLOR);
		end
		-- Common.log("nPos ======== "..nPos);
		-- Common.log("i ======== "..i);
		local size = #GameResultCards[nPos + 1][i];
		local Dx = 400;
		local Dy = 888;
		local Dh = 150;
		for w = 1, size do
			local card = GameResultCards[nPos + 1][i][w];
			if cardType == 1 or cardType == 3 or cardType == 4 then
				--牌型1：顺子--牌型3：碰--牌型4：明杠--牌型5：暗杠
				--Common.log("w =========== "..w);
				card:setCardRanks(1, w);
				card:setCardScale(0.7);
				if w == 4 then
					card:setCardPosition(Dx + 2 * card:getContentSizeWidth()*0.9 + (i - 1)*(3.1*card:getContentSizeWidth()*0.9), Dy - Dh * (nPos + 1) -5 + 18);
				else
					card:setCardPosition(Dx + w * card:getContentSizeWidth()*0.9 + (i - 1)*(3.1*card:getContentSizeWidth()*0.9), Dy - Dh * (nPos + 1) -5);
				end
			elseif cardType == 5 then
				--牌型5：暗杠
				card:setCardRanks(1, w);
				card:setCardScale(0.7);
				if w == 4 then
					card:setCardPosition(Dx + 2 * card:getContentSizeWidth()*0.9 + (i - 1)*(3.1*card:getContentSizeWidth()*0.9), Dy - Dh * (nPos + 1) -5 + 18);
				else
					card:setCardPosition(Dx + w * card:getContentSizeWidth()*0.9 + (i - 1)*(3.1*card:getContentSizeWidth()*0.9), Dy - Dh * (nPos + 1) -5);
				end
			elseif cardType == 6 then
				--牌型6：手牌
				card:setCardRanks(1, 1);
				card:setCardScale(0.4);
				card:setCardPosition(Dx + (w + (13 - size)) * card:getContentSizeWidth(),Dy - Dh * (nPos + 1));
			elseif cardType == 7 or cardType == 8 then
				--牌型7：胡实牌  牌型8：胡虚牌
				card:setCardRanks(1, 1);
				card:setCardScale(0.7);
				card:setCardPosition(Dx + 14 * card:getContentSizeWidth(), Dy - Dh * (nPos + 1) -5);
				if cardType == 8 then
					card:setCardOpacity(255/2);
				end
			end
			GameResultCardLayer:addChild(card.m_CardSprite);
		end
	end
end

--[[--
--刷新牌桌结果
--]]
function refreshGameResultInfo(dataTable)
	--local dataTable = MahjongLoadProfile.MahjongGameDoc.getGameResultTable();
	--PlayerList	Loop	用户列表
	local PlayerListSize = #dataTable["PlayerList"];
	for i = 1, PlayerListSize do
		--...UserID	Int
		local UserID = dataTable["PlayerList"][i].UserID;
		--...SeatID	byte
		local SeatID = dataTable["PlayerList"][i].SeatID;
		local nPos = MahjongTableConsole.getPlayerPosBySeat(SeatID);
		--...PhotoUrl	Text
		local PhotoUrl = dataTable["PlayerList"][i].PhotoUrl;
		--PhotoUrl = "http://photo.99sai.com/upload/668/1276668_1486605838.jpg";
		Common.getPicFile(PhotoUrl, nPos, true, updataPlayerPhoto, true);
		local UI_name = cocostudio.getUILabel(view, "Pos".. nPos .."_name");
		local UI_fan_txt = cocostudio.getUILabel(view, "Pos".. nPos .."_fan_txt");
		local UI_fan_number = cocostudio.getUILabel(view, "Pos".. nPos .."_fan_number");
		local UI_score = cocostudio.getUILabel(view, "Pos".. nPos .."_score");
		local UI_Image_hu_number = cocostudio.getUIImageView(view, "Pos".. nPos .."_Image_hu_number");
		--...Name	Text
		local Name = dataTable["PlayerList"][i].Name;
		UI_name:setText(Name);
		--...Fan	Int	胡多少番	没胡0
		local Fan = dataTable["PlayerList"][i].Fan;
		UI_fan_number:setText(Fan.."番");
		--...Score	Long	输赢多少分	分正负
		local Score = dataTable["PlayerList"][i].Score;
		UI_score:setText(Score);
		--...FanTypeStr	Text	番型提示
		local FanTypeStr = dataTable["PlayerList"][i].FanTypeStr;
		UI_fan_txt:setText(FanTypeStr);
		--...HuNumber	byte	第几个胡牌	1胡，2胡，3胡,没胡传-1
		local HuNumber = dataTable["PlayerList"][i].HuNumber;
		Common.log("HuNumber ======= "..HuNumber);
		if HuNumber == -1 or HuNumber == 255 then
			UI_Image_hu_number:setVisible(false);
		else
			UI_Image_hu_number:loadTexture("MJ_icon_hu".. HuNumber ..".png", 1);
		end
		--...cardGroup	Loop	同步当前操作者的桌面牌
		local cardGroupSize = #dataTable["PlayerList"][i]["cardGroup"];
		Common.log("游戏结果 cardGroupSize =============== "..cardGroupSize);
		addGameResultCards(nPos, dataTable["PlayerList"][i]["cardGroup"], false);
	end

	Label_TableInfo:setText(MahjongTableConsole.mRoomTitle);
end

function callback_Button_share(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GamePub.shareSenceToWx(false)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_next(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close();

		sendMJ_SC_GAME_READY();
		MahjongTableConsole.resetGameTable();
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	ResumeSocket("MahjongGameResult");
	GameResultCards = {};
	GameResultCardLayer:removeAllChildrenWithCleanup(true);
	GameResultCardLayer = nil
end

function addSlot()

end

function removeSlot()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_result.plist"));
end
