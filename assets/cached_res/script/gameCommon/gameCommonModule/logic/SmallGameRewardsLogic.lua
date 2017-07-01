module("SmallGameRewardsLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
Button_close = nil;--
Panel_13 = nil;--
Label_name_one = nil;--
AtlasLabel_reward_one = nil;--
Image_touxiang_one = nil;--
Label_coin_one = nil;--
Label_reward_one = nil;--
Label_name_three = nil;--
Image_touxiang_three = nil;--
Label_coin_three = nil;--
AtlasLabel_reward_three = nil;--
Label_reward_three = nil;--
AtlasLabel_reward_two = nil;--
Image_touxiang_two = nil;--
Label_name_two = nil;--
Label_coin_two = nil;--
Label_reward_two = nil;--
Panel_15 = nil;--
Label_nicheng = nil;--
Label_mingci = nil;--
Label_jiangli = nil;--
Label_zhuanjinshu = nil;--
Panel_25 = nil;--
Image_RewardsTitle = nil;--
Image_jinri = nil;--
Image_jinri_title = nil;--
Image_zuori = nil;--
Image_zuori_title = nil;--
Label_rank = nil;--
Button_help = nil;--
Panel_tableView = nil;--

paihangData = {}

PaiHangBangTableView = nil

Image_touxiang = {}
Label_name = {}
Label_coin = {}
AtlasLabel_reward = {}
Label_reward = {}

URL_SMALLGAMEREWARDS_HELP = "http://f.99sai.com/html/minigame/miniGame-rankListHelp.html" --小游戏赚金榜帮助

local function close()
	mvcEngine.destroyModule(GUI_SMALLGAMEREWARDS)
end

--[[--
--加载图片素材
--]]
local function getSmallGameRewardsResource(path)
	return Common.getScriptPath("gameCommon/gameCommonRes/SmallGameRewards/"..path);
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
	local gui = GUI_SMALLGAMEREWARDS;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("SmallGameRewards/SmallGameRewards.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("SmallGameRewards/SmallGameRewards.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_13 = cocostudio.getUIPanel(view, "Panel_13");
	Label_name_one = cocostudio.getUILabel(view, "Label_name_one");
	AtlasLabel_reward_one = cocostudio.getUILabelAtlas(view, "AtlasLabel_reward_one");
	Image_touxiang_one = cocostudio.getUIImageView(view, "Image_touxiang_one");
	Label_coin_one = cocostudio.getUILabel(view, "Label_coin_one");
	Label_reward_one = cocostudio.getUILabel(view, "Label_reward_one");
	Label_name_three = cocostudio.getUILabel(view, "Label_name_three");
	Image_touxiang_three = cocostudio.getUIImageView(view, "Image_touxiang_three");
	Label_coin_three = cocostudio.getUILabel(view, "Label_coin_three");
	AtlasLabel_reward_three = cocostudio.getUILabelAtlas(view, "AtlasLabel_reward_three");
	Label_reward_three = cocostudio.getUILabel(view, "Label_reward_three");
	AtlasLabel_reward_two = cocostudio.getUILabelAtlas(view, "AtlasLabel_reward_two");
	Image_touxiang_two = cocostudio.getUIImageView(view, "Image_touxiang_two");
	Label_name_two = cocostudio.getUILabel(view, "Label_name_two");
	Label_coin_two = cocostudio.getUILabel(view, "Label_coin_two");
	Label_reward_two = cocostudio.getUILabel(view, "Label_reward_two");
	Panel_15 = cocostudio.getUIPanel(view, "Panel_15");
	Label_nicheng = cocostudio.getUILabel(view, "Label_nicheng");
	Label_mingci = cocostudio.getUILabel(view, "Label_mingci");
	Label_jiangli = cocostudio.getUILabel(view, "Label_jiangli");
	Label_zhuanjinshu = cocostudio.getUILabel(view, "Label_zhuanjinshu");
	Panel_25 = cocostudio.getUIPanel(view, "Panel_25");
	Image_RewardsTitle = cocostudio.getUIImageView(view, "Image_RewardsTitle");
	Image_jinri = cocostudio.getUIImageView(view, "Image_jinri");
	Image_jinri_title = cocostudio.getUIImageView(view, "Image_jinri_title");
	Image_zuori = cocostudio.getUIImageView(view, "Image_zuori");
	Image_zuori_title = cocostudio.getUIImageView(view, "Image_zuori_title");
	Label_rank = cocostudio.getUILabel(view, "Label_rank");
	Button_help = cocostudio.getUIButton(view, "Button_help");
	Panel_tableView = cocostudio.getUIPanel(view, "Panel_tableView");

	Image_touxiang = {Image_touxiang_one,Image_touxiang_two,Image_touxiang_three}
	Label_name = {Label_name_one,Label_name_two,Label_name_three}
	Label_coin = {Label_coin_one,Label_coin_two,Label_coin_three}
	AtlasLabel_reward = {AtlasLabel_reward_one,AtlasLabel_reward_two,AtlasLabel_reward_three}
	Label_reward = {Label_reward_one,Label_reward_two,Label_reward_three}

	if GameLoadModuleConfig.getLoadModuleGameID() == GameLoadModuleConfig.FruitGameID then
		Image_RewardsTitle:loadTexture(getSmallGameRewardsResource("tit_zhuanjin_shuiguoji.png"))
	elseif GameLoadModuleConfig.getLoadModuleGameID() == GameLoadModuleConfig.JinHuangGuanGameID then
		Image_RewardsTitle:loadTexture(getSmallGameRewardsResource("tit_zhuanjin_jinhuangguan.png"))
	elseif GameLoadModuleConfig.getLoadModuleGameID() == GameLoadModuleConfig.WanRenJinHuaGameID then
		Image_RewardsTitle:loadTexture(getSmallGameRewardsResource("tit_zhuanjin_wanrenjinhua.png"))
	elseif GameLoadModuleConfig.getLoadModuleGameID() == GameLoadModuleConfig.WanRenFruitGameID then
		Image_RewardsTitle:loadTexture(getSmallGameRewardsResource("tit_zhuanjin_shuiguopai.png"))
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();

	CommDialogConfig.showProgressDialog("正在加载游戏，请稍后...")
	sendCOMMONS_GET_MINI_GAME_EARN_RANK(GameCommonProfile.SmallGameRewards.todayRewards,"")
end

local function changeMenuState()
	if paihangData == nil then
		return;
	end
	local day =  paihangData["Day"]
	if day == GameCommonProfile.SmallGameRewards.todayRewards then
		Image_jinri:loadTexture(getSmallGameRewardsResource("btn_zhuanjin_tab_press.png"))
		Image_zuori:loadTexture(getSmallGameRewardsResource("btn_zhuanjin_tab_nor.png"))
		Image_jinri_title:loadTexture(getSmallGameRewardsResource("txt_zhuanjin_jinri_press.png"))
		Image_zuori_title:loadTexture(getSmallGameRewardsResource("txt_zhuanjin_zuori_nor.png"))
		Image_zuori:setFlipX(true)
		Image_jinri:setTouchEnabled(false);
		Image_zuori:setTouchEnabled(true);
	elseif day == GameCommonProfile.SmallGameRewards.yesterdayRewards then
		Image_zuori:loadTexture(getSmallGameRewardsResource("btn_zhuanjin_tab_press.png"))
		Image_jinri:loadTexture(getSmallGameRewardsResource("btn_zhuanjin_tab_nor.png"))
		Image_jinri_title:loadTexture(getSmallGameRewardsResource("txt_zhuanjin_jinri_nor.png"))
		Image_zuori_title:loadTexture(getSmallGameRewardsResource("txt_zhuanjin_zuori_press.png"))
		Image_zuori:setFlipX(true)
		Image_zuori:setTouchEnabled(false);
		Image_jinri:setTouchEnabled(true);
	end
end

local function reloadRank()
	if paihangData == nil then
		return;
	end
	local PanelListSize = Panel_tableView:getContentSize()
	local PanelListPosX = Panel_tableView:getPosition().x
	local PanelListPosY = Panel_tableView:getPosition().y

	local tableSize = 0; --元素数量
	local TableView_X = PanelListPosX - PanelListSize.width / 2; --TableView的左下角X坐标
	local TableView_Y = PanelListPosY - PanelListSize.height / 2; --TableView的左下角Y坐标
	local TableView_W = PanelListSize.width; --TableView的显示宽度
	local TableView_H = PanelListSize.height; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local spacingW = 10; --横向间隔
	local spacingH = 20 --纵向间隔
	local loadCellSize = 0;--已经加载的元素数
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 28; --每个元素的高

	PaiHangBangTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	PaiHangBangTableView:setPosition(TableView_X + TableView_W, TableView_Y + TableView_H);

	function PaiHangBangTableView.initTableViewData()
		loadCellSize = 0;
		if paihangData ~= nil and #paihangData["Rewards"] > 0 then
			--接收排行榜数量
			tableSize = #paihangData["Rewards"]
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
		end
	end

	function PaiHangBangTableView.numberOfrow()
		return rowSize;
	end

	function PaiHangBangTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight;
	end

	function PaiHangBangTableView.getCellWidth()
		return cellWidth;--每个元素的宽
	end

	function PaiHangBangTableView.CellOfAtNumberOfRow(cell, i)

		local index = PaiHangBangTableView.numberOfrow() + 1 - i
		--父节点layer
		local itemParentNode = CCSprite:create(loadGameConfig.getGameCommonPath("px1.png"))
		itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)
		--名次
		local labelMing = "第" .. paihangData["Rewards"][index].rank.."名"
		local labelNum = CCLabelTTF:create(labelMing,"Arial",22)
		--		end
		labelNum:setAnchorPoint(ccp(0, 0.5))
		SET_POS(labelNum, -cellWidth*0.45, 0);
		itemParentNode:addChild(labelNum)

		--名字
		local labelName = CCLabelTTF:create(paihangData["Rewards"][index].nickName,"Arial",22)
		labelName:setAnchorPoint(ccp(0.5, 0.5))
		itemParentNode:addChild(labelName)
		SET_POS(labelName, -cellWidth*0.15, 0);

		--赚金数
		local labelEarn = CCLabelTTF:create(tostring(paihangData["Rewards"][index].earnCoins),"Arial",22)
		labelEarn:setAnchorPoint(ccp(0.5, 0.5))
		SET_POS(labelEarn, cellWidth*0.15, 0);
		itemParentNode:addChild(labelEarn)

		--奖励
		local rewardCoin = paihangData["Rewards"][index].rewardCoins
		--金币label
		local labelCoin = CCLabelTTF:create(rewardCoin,"Arial",22)
		labelCoin:setAnchorPoint(ccp(0, 0.5))
		itemParentNode:addChild(labelCoin)
		SET_POS(labelCoin, cellWidth*0.3, 0);

	end

	view:addChild(PaiHangBangTableView)

	ccTableView.reloadData(PaiHangBangTableView)

end

local function setUserImage(path)
	local photoPath = nil;
	local id = nil;
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = tonumber(path["id"])
	elseif Common.platform == Common.TargetAndroid then
		local i, j = string.find(path, "#")
		id = tonumber(string.sub(path, 1, i - 1))
		photoPath = string.sub(path, j + 1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and Image_touxiang[id]~= nil then
		Image_touxiang[id]:loadTexture(photoPath);
	end
end

local function updateView()
	local SelfRank =  paihangData["SelfRank"]
	if SelfRank == -1 then
		Label_rank:setText("50+")
	else
		Label_rank:setText(tostring(SelfRank))
	end

	--前三名
	local length = 3
	local rankSize = #paihangData["Rewards"]
	for var=1, length do
		Image_touxiang[var]:loadTexture(getSmallGameRewardsResource("image_games_man.png"));
		if var <= rankSize then
			Common.getPicFile(paihangData["Rewards"][var].photoUrl, var, true, setUserImage,true)
			Label_name[var]:setText(paihangData["Rewards"][var].nickName)
			Label_coin[var]:setText(paihangData["Rewards"][var].earnCoins)
			Label_reward[var]:setText(paihangData["Rewards"][var].rewardCoins)
		else
			Label_name[var]:setText("")
			Label_coin[var]:setText("")
			Label_reward[var]:setText("")
		end

	end

	changeMenuState()
	if #paihangData["Rewards"] > 0 then
		showPaiHangBangTableView()
	else
		--排行榜里没有数据
		Common.showToast("目前还没有人上榜哦！抓紧时间冲榜吧！", 2)
		if PaiHangBangTableView ~= nil then
			PaiHangBangTableView:removeFromParentAndCleanup(true)
			PaiHangBangTableView = nil
		end
	end

end

function showPaiHangBangTableView()
	if PaiHangBangTableView ~= nil then
		PaiHangBangTableView:setVisible(true)
		ccTableView.reloadData(PaiHangBangTableView);
	else
		reloadRank()
	end
end

function requestMsg()

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

function callback_Image_jinri(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local data = GameCommonProfile.SmallGameRewards.getTodayData()
		if data == nil or data["Rewards"] == nil then
			CommDialogConfig.showProgressDialog("正在加载游戏，请稍后...")
			sendCOMMONS_GET_MINI_GAME_EARN_RANK(GameCommonProfile.SmallGameRewards.todayRewards,"")
		else
			paihangData = data
			updateView()
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_zuori(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		CommDialogConfig.showProgressDialog("正在加载游戏，请稍后...")
		sendCOMMONS_GET_MINI_GAME_EARN_RANK(GameCommonProfile.SmallGameRewards.yesterdayRewards,GameCommonProfile.SmallGameRewards.getSmallGameYesterdayTimeStamp(GameLoadModuleConfig.getLoadModuleGameID()))
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_SMALLREWARDSGUIDE)
		SmallRewardsGuideLogic.setWebViewUrl(URL_SMALLGAMEREWARDS_HELP)
	elseif component == CANCEL_UP then
	--取消

	end
end

function readCOMMONS_GET_MINI_GAME_EARN_RANK()
	CommDialogConfig.closeProgressDialog()
	paihangData = GameCommonProfile.SmallGameRewards.getSmallGameRewardsData()
	updateView()
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	GameCommonProfile.SmallGameRewards.releaseData()
end

function addSlot()
	framework.addSlot2Signal(COMMONS_GET_MINI_GAME_EARN_RANK, readCOMMONS_GET_MINI_GAME_EARN_RANK)--领取每日任务奖励
end

function removeSlot()
	framework.removeSlotFromSignal(COMMONS_GET_MINI_GAME_EARN_RANK, readCOMMONS_GET_MINI_GAME_EARN_RANK)--领取每日任务奖励
end
