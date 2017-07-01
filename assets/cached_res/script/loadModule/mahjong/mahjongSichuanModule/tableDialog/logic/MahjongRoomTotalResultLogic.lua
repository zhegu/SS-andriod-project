module("MahjongRoomTotalResultLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_3 = nil;--
Button_share = nil;--
Button_end = nil;--
Panel_11 = nil;--
Label_name1 = nil;--
Label_fangka1 = nil;--
Image_photo1 = nil;--
Label_zimo1 = nil;--
Label_jiepao1 = nil;--
Label_dianpao1 = nil;--
Label_angang1 = nil;--
Label_minggang1 = nil;--
Label_chadajiao1 = nil;--
Image_winner1 = nil;--
Image_fangzhu1 = nil;--
Image_paoshou1 = nil;--
Panel_166 = nil;--
AtlasLabel_totalScore1 = nil;--
Panel_171 = nil;--
Panel_11_0 = nil;--
Label_name2 = nil;--
Label_fangka2 = nil;--
Image_photo2 = nil;--
Label_zimo2 = nil;--
Label_jiepao2 = nil;--
Label_dianpao2 = nil;--
Label_angang2 = nil;--
Label_minggang2 = nil;--
Label_chadajiao2 = nil;--
Image_winner2 = nil;--
Image_fangzhu2  = nil;--
Image_paoshou2 = nil;--
Panel_166_0_00 = nil;--
AtlasLabel_totalScore2 = nil;--
Panel_171_0_00 = nil;--
Panel_11_0_1 = nil;--
Label_name3 = nil;--
Label_fangka3 = nil;--
Image_photo3 = nil;--
Label_zimo3 = nil;--
Label_jiepao3 = nil;--
Label_dianpao3 = nil;--
Label_angang3 = nil;--
Label_minggang3 = nil;--
Label_chadajiao3 = nil;--
Image_winner3 = nil;--
Image_fangzhu3  = nil;--
Image_paoshou3 = nil;--
Panel_166_0_00_1 = nil;--
AtlasLabel_totalScore3 = nil;--
Panel_171_0_00_1 = nil;--
Panel_11_0_1_2 = nil;--
Label_name4 = nil;--
Label_fangka4 = nil;--
Image_photo4 = nil;--
Label_zimo4 = nil;--
Label_jiepao4 = nil;--
Label_dianpao4 = nil;--
Label_angang4 = nil;--
Label_minggang4 = nil;--
Label_chadajiao4 = nil;--
Image_winner4 = nil;--
Image_fangzhu4   = nil;--
Image_paoshou4   = nil;--
Panel_166_0_00_1_2 = nil;--
AtlasLabel_totalScore4 = nil;--
Panel_171_0_00_1_2 = nil;--

local lableNameList = {};
local lableFangkaList = {}
local imagePhotoList = {}
local imageFangzhuList = {}
local lableZimoList = {}
local lableJiepaoList = {}
local lableDiaopaoList = {}
local lableAngangList = {}
local lableMinggangList = {}
local lableChadajiaoList = {}
local lableTotalScoreList = {}
local imageWinnerList = {}
local imagePaoshouList = {}

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGROOMTOTALRESULT)
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
	local gui = GUI_MAHJONGROOMTOTALRESULT;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_result.plist"));
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongRoomTotalResult.json"));
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
	Panel_3 = cocostudio.getUIPanel(view, "Panel_3");
	Button_share = cocostudio.getUIButton(view, "Button_share");
	Button_end = cocostudio.getUIButton(view, "Button_end");
	Panel_11 = cocostudio.getUIPanel(view, "Panel_11");
	Label_name1 = cocostudio.getUILabel(view, "Label_name1");
	Label_fangka1 = cocostudio.getUILabel(view, "Label_fangka1");
	Image_photo1 = cocostudio.getUIImageView(view, "Image_photo1");
	Label_zimo1 = cocostudio.getUILabel(view, "Label_zimo1");
	Label_jiepao1 = cocostudio.getUILabel(view, "Label_jiepao1");
	Label_dianpao1 = cocostudio.getUILabel(view, "Label_dianpao1");
	Label_angang1 = cocostudio.getUILabel(view, "Label_angang1");
	Label_minggang1 = cocostudio.getUILabel(view, "Label_minggang1");
	Label_chadajiao1 = cocostudio.getUILabel(view, "Label_chadajiao1");
	Image_winner1 = cocostudio.getUIImageView(view, "Image_winner1");
	Image_fangzhu1 = cocostudio.getUIImageView(view, "Image_fangzhu1");
	Image_paoshou1 = cocostudio.getUIImageView(view, "Image_paoshou1");
	Panel_166 = cocostudio.getUIPanel(view, "Panel_166");
	AtlasLabel_totalScore1 = cocostudio.getUILabelAtlas(view, "AtlasLabel_totalScore1");
	Panel_171 = cocostudio.getUIPanel(view, "Panel_171");
	Panel_11_0 = cocostudio.getUIPanel(view, "Panel_11_0");
	Label_name2 = cocostudio.getUILabel(view, "Label_name2");
	Label_fangka2 = cocostudio.getUILabel(view, "Label_fangka2");
	Image_photo2 = cocostudio.getUIImageView(view, "Image_photo2");
	Label_zimo2 = cocostudio.getUILabel(view, "Label_zimo2");
	Label_jiepao2 = cocostudio.getUILabel(view, "Label_jiepao2");
	Label_dianpao2 = cocostudio.getUILabel(view, "Label_dianpao2");
	Label_angang2 = cocostudio.getUILabel(view, "Label_angang2");
	Label_minggang2 = cocostudio.getUILabel(view, "Label_minggang2");
	Label_chadajiao2 = cocostudio.getUILabel(view, "Label_chadajiao2");
	Image_winner2 = cocostudio.getUIImageView(view, "Image_winner2");
	Image_fangzhu2  = cocostudio.getUIImageView(view, "Image_fangzhu2 ");
	Image_paoshou2 = cocostudio.getUIImageView(view, "Image_paoshou2");
	Panel_166_0_00 = cocostudio.getUIPanel(view, "Panel_166_0_00");
	AtlasLabel_totalScore2 = cocostudio.getUILabelAtlas(view, "AtlasLabel_totalScore2");
	Panel_171_0_00 = cocostudio.getUIPanel(view, "Panel_171_0_00");
	Panel_11_0_1 = cocostudio.getUIPanel(view, "Panel_11_0_1");
	Label_name3 = cocostudio.getUILabel(view, "Label_name3");
	Label_fangka3 = cocostudio.getUILabel(view, "Label_fangka3");
	Image_photo3 = cocostudio.getUIImageView(view, "Image_photo3");
	Label_zimo3 = cocostudio.getUILabel(view, "Label_zimo3");
	Label_jiepao3 = cocostudio.getUILabel(view, "Label_jiepao3");
	Label_dianpao3 = cocostudio.getUILabel(view, "Label_dianpao3");
	Label_angang3 = cocostudio.getUILabel(view, "Label_angang3");
	Label_minggang3 = cocostudio.getUILabel(view, "Label_minggang3");
	Label_chadajiao3 = cocostudio.getUILabel(view, "Label_chadajiao3");
	Image_winner3 = cocostudio.getUIImageView(view, "Image_winner3");
	Image_fangzhu3  = cocostudio.getUIImageView(view, "Image_fangzhu3 ");
	Image_paoshou3 = cocostudio.getUIImageView(view, "Image_paoshou3");
	Panel_166_0_00_1 = cocostudio.getUIPanel(view, "Panel_166_0_00_1");
	AtlasLabel_totalScore3 = cocostudio.getUILabelAtlas(view, "AtlasLabel_totalScore3");
	Panel_171_0_00_1 = cocostudio.getUIPanel(view, "Panel_171_0_00_1");
	Panel_11_0_1_2 = cocostudio.getUIPanel(view, "Panel_11_0_1_2");
	Label_name4 = cocostudio.getUILabel(view, "Label_name4");
	Label_fangka4 = cocostudio.getUILabel(view, "Label_fangka4");
	Image_photo4 = cocostudio.getUIImageView(view, "Image_photo4");
	Label_zimo4 = cocostudio.getUILabel(view, "Label_zimo4");
	Label_jiepao4 = cocostudio.getUILabel(view, "Label_jiepao4");
	Label_dianpao4 = cocostudio.getUILabel(view, "Label_dianpao4");
	Label_angang4 = cocostudio.getUILabel(view, "Label_angang4");
	Label_minggang4 = cocostudio.getUILabel(view, "Label_minggang4");
	Label_chadajiao4 = cocostudio.getUILabel(view, "Label_chadajiao4");
	Image_winner4 = cocostudio.getUIImageView(view, "Image_winner4");
	Image_fangzhu4   = cocostudio.getUIImageView(view, "Image_fangzhu4  ");
	Image_paoshou4   = cocostudio.getUIImageView(view, "Image_paoshou4  ");
	Panel_166_0_00_1_2 = cocostudio.getUIPanel(view, "Panel_166_0_00_1_2");
	AtlasLabel_totalScore4 = cocostudio.getUILabelAtlas(view, "AtlasLabel_totalScore4");
	Panel_171_0_00_1_2 = cocostudio.getUIPanel(view, "Panel_171_0_00_1_2");

	lableNameList = {Label_name1, Label_name2, Label_name3, Label_name4};
	lableFangkaList = {Label_fangka1, Label_fangka2, Label_fangka3, Label_fangka4}
	imagePhotoList = {Image_photo1, Image_photo2, Image_photo3, Image_photo4}
	imageFangzhuList = {Image_fangzhu1, Image_fangzhu2, Image_fangzhu3, Image_fangzhu4}
	lableZimoList = {Label_zimo1, Label_zimo2, Label_zimo3, Label_zimo4}
	lableJiepaoList = {Label_jiepao1, Label_jiepao2, Label_jiepao3, Label_jiepao4}
	lableDiaopaoList = {Label_dianpao1, Label_dianpao2, Label_dianpao3, Label_dianpao4}
	lableAngangList = {Label_angang1, Label_angang2, Label_angang3, Label_angang4}
	lableMinggangList = {Label_minggang1, Label_minggang2, Label_minggang3, Label_minggang4}
	lableChadajiaoList = {Label_chadajiao1, Label_chadajiao2, Label_chadajiao3, Label_chadajiao4}
	lableTotalScoreList = {AtlasLabel_totalScore1, AtlasLabel_totalScore2, AtlasLabel_totalScore3, AtlasLabel_totalScore4}
	imageWinnerList = {Image_winner1, Image_winner2, Image_winner3, Image_winner4}
	imagePaoshouList = {Image_paoshou1, Image_paoshou2, Image_paoshou3, Image_paoshou4}

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
	initData();
end

function requestMsg()

end

--[[--
--牌桌头像下载回调
--]]
local function updataPlayerPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = tonumber(path["id"])
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and imagePhotoList[tonumber(id)] ~= nil then
		imagePhotoList[tonumber(id)]:loadTexture(photoPath)
	end
end

function initData()
	local resultData = MahjongLoadProfile.MahjongGameDoc.getRoomTotalResultTable()
	local winnerId = 1; --大赢家
	local winnerScore = 0;
	local paoshouId = 1; --最佳炮手
	local paoshouCnt = 0;
	local playerInfo = resultData["PlayerList"];
	for index=1, #playerInfo do
		local UserID = playerInfo[index]["UserID"]
		local SeatID = playerInfo[index]["SeatID"]
		local PhotoUrl = playerInfo[index]["PhotoUrl"]
		local Name = playerInfo[index]["Name"]
		local IsRoomOwner = playerInfo[index]["IsRoomOwner"] --1是房主0不是房主
		local TotalScore = playerInfo[index]["TotalScore"]
		local ZiMoCnt = playerInfo[index]["ZiMoCnt"]
		local JiePaoCnt = playerInfo[index]["JiePaoCnt"]
		local DianPaoCnt = playerInfo[index]["DianPaoCnt"]
		local AnGangCnt = playerInfo[index]["AnGangCnt"]
		local MingGangCnt = playerInfo[index]["MingGangCnt"]
		local ChaDaJiao = playerInfo[index]["ChaDaJiao"]

		Common.log("i == "..index)
		Common.log("DianPaoCnt == "..DianPaoCnt)
		Common.log("TotalScore == "..TotalScore)

		if TotalScore > winnerScore then
			winnerId = index;
			winnerScore = TotalScore;
		end

		if DianPaoCnt > paoshouCnt then
			paoshouId = index;
			paoshouCnt = DianPaoCnt;
		elseif DianPaoCnt == paoshouCnt then
			--如果炮分相同，则分数少的为炮手
			if winnerScore < playerInfo[paoshouId]["TotalScore"] then
				paoshouId = index;
				paoshouCnt = DianPaoCnt;
			end
		end

		Common.getPicFile(PhotoUrl, index, true, updataPlayerPhoto, true);
		lableNameList[index]:setText(Name)
		lableFangkaList[index]:setText("ID:"..UserID)
		if TotalScore < 0 then
			lableTotalScoreList[index]:setStringValue(";"..math.abs(TotalScore))
		else
			lableTotalScoreList[index]:setStringValue(tostring(TotalScore))
		end
		lableZimoList[index]:setText(ZiMoCnt)
		lableJiepaoList[index]:setText(JiePaoCnt)
		lableDiaopaoList[index]:setText(DianPaoCnt)
		lableAngangList[index]:setText(AnGangCnt)
		lableMinggangList[index]:setText(MingGangCnt)
		lableChadajiaoList[index]:setText(ChaDaJiao)

		if IsRoomOwner == 1 then
			imageFangzhuList[index]:setVisible(true)
		else
			imageFangzhuList[index]:setVisible(false)
		end
	end

	for index=1, 4 do
		if winnerId == index then
			imageWinnerList[index]:setVisible(true)
		else
			imageWinnerList[index]:setVisible(false)
		end

		if paoshouId == index then
			imagePaoshouList[index]:setVisible(true)
		else
			imagePaoshouList[index]:setVisible(false)
		end
	end

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

function callback_Button_end(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		MahjongTableLogic.gameExit();
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_166(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_166_0_00(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_166_0_00_1(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Panel_166_0_00_1_2(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起

	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_result.plist"));
	lableNameList = {};
	lableFangkaList = {}
	imagePhotoList = {}
	imageFangzhuList = {}
	lableZimoList = {}
	lableJiepaoList = {}
	lableDiaopaoList = {}
	lableAngangList = {}
	lableMinggangList = {}
	lableChadajiaoList = {}
	lableTotalScoreList = {}
	imageWinnerList = {}
	imagePaoshouList = {}
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
