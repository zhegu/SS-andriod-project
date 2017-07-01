module("MahjongTableUserInfoLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_dialog = nil;--
Button_close = nil;--
Label_ID = nil;--
Panel_10 = nil;--
Label_name = nil;--
Image_sex = nil;--
Image_fangka = nil;--
AtlasLabel_fangka = nil;--
Label_distance = nil;--
Panel_24 = nil;--
Image_userPhoto = nil;--
Panel_tableView = nil;--

local mUserID = 0;
local mofaListInfo = {} --魔法表情

local mofaEmotionView = nil;
local mofaMenuListLayer = {};
local mofaIconList = {};

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGTABLEUSERINFO)
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
	local gui = GUI_MAHJONGTABLEUSERINFO;
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongTableUserInfo.json"));
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
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Label_ID = cocostudio.getUILabel(view, "Label_ID");
	Panel_10 = cocostudio.getUIPanel(view, "Panel_10");
	Label_name = cocostudio.getUILabel(view, "Label_name");
	Image_sex = cocostudio.getUIImageView(view, "Image_sex");
	Image_fangka = cocostudio.getUIImageView(view, "Image_fangka");
	AtlasLabel_fangka = cocostudio.getUILabelAtlas(view, "AtlasLabel_fangka");
	Label_distance = cocostudio.getUILabel(view, "Label_distance");
	Panel_24 = cocostudio.getUIPanel(view, "Panel_24");
	Image_userPhoto = cocostudio.getUIImageView(view, "Image_userPhoto");
	Panel_tableView = cocostudio.getUIPanel(view, "Panel_tableView");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
	GamePub.showDialogAmin(Panel_dialog)
end

function requestMsg()

end

--[[--
--设置用户ID
--]]
function setPlayerUserID(userID)
	mUserID = userID
	if MahjongTableConsole.PlayerInfo["UserID_"..userID] ~= nil then
		updatePlayer(MahjongTableConsole.PlayerInfo["UserID_"..userID])
	else
		sendMJ_SC_MGR_PLAYER_INFO_IN_TABLE(userID)
	end
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
	if photoPath ~= nil and photoPath ~= "" and Image_userPhoto ~= nil then
		Image_userPhoto:loadTexture(photoPath)
	end
end

--[[--
--更新用户信息
--]]
function updatePlayer(playerInfo)
	--	local player = MahjongTableConsole.getPlayerByUserID(mUserID)

	local nickName = playerInfo.nickName
	local sex = playerInfo.sex
	local ip = playerInfo.ip
	local photoUrl = playerInfo.photoUrl
	local fangkaCnt = playerInfo.fangkaCnt
	local DistanceList = playerInfo.DistanceList
	mofaListInfo = playerInfo.MofaList

	Label_name:setText(nickName);
	if sex == MahjongLoadProfile.MahjongGameDoc.MALE then
		Image_sex:loadTexture("MJ_ingame_infomation_ic_nan.png",1)
	end
	Common.getPicFile(playerInfo.PhotoUrl, 0, true, updataPlayerPhoto, true);
	AtlasLabel_fangka:setStringValue(""..fangkaCnt);
	Label_ID:setText("ID:"..mUserID)

	local str = "";
	for index=1, #DistanceList do
		local otherUserid = DistanceList[index].userId
		local otherName = DistanceList[index].nickname
		local Distance = DistanceList[index].Distance
		local nameStr = otherName;
		if otherUserid == profile.User.getSelfUserID() then
			nameStr = "您"
		end
		str = str .. nameStr .. ": " ..Distance.." ";
	end
	Label_distance:setText(str)

	showMofaTableView();
end


--[[--
--头像下载回调
--]]
local function updateIconUrl(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = tonumber(path["id"])
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = tonumber(string.sub(path, 1, i-1))
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and mofaIconList[id] ~= nil then
		local texture = CCTextureCache:sharedTextureCache():addImage(photoPath)
		if texture ~= nil then
			mofaIconList[id]:setTexture(texture)
		end
	end
end

function showMofaTableView()
	mofaMenuListLayer = {}
	Common.log("showMofaTableView === ")
	if mofaListInfo == nil or mofaListInfo == "" then
		Common.log("showMofaTableView === return")
		return;
	end
	Common.log("showMofaTableView === Success")
	local tableSize = 0 --元素数量
	local TableView_W = 1200 --TableView的显示宽度
	local TableView_H = 200 --TableView的显示高度
	local TableView_X = 357 --* GameConfig.ScaleAbscissa; --TableView的左下角X坐标
	local TableView_Y = 242 --* GameConfig.ScaleOrdinate; --TableView的左下角Y坐标
	local rowSize = 1; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 0; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local spacingW = 2; --横向间隔
	local spacingH = 2 --纵向间隔
	local cellWidth = 202; --每个元素的宽
	local cellHeight = 187; --每个元素的高


	if mofaEmotionView ~= nil then
		mofaEmotionView:removeFromParentAndCleanup(true)
	end

	mofaEmotionView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionHorizontal);
	mofaEmotionView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function mofaEmotionView.initTableViewData()
		if mofaListInfo ~= nil and #mofaListInfo > 0 then
			--接收排行榜数量
			tableSize = #mofaListInfo
			--计算一共多少行
			-- rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)

			columnSize = #mofaListInfo
		end
	end

	function mofaEmotionView.getTableViewInfo()
		local TableViewInfo = {}

		TableViewInfo.TableView_X = TableView_X;--TableView的左下角X坐标
		TableViewInfo.TableView_Y = TableView_Y;--TableView的左下角Y坐标
		TableViewInfo.TableView_W = TableView_W;--TableView的显示宽度
		TableViewInfo.TableView_H = TableView_H;--TableView的显示高度
		TableViewInfo.rowSize = rowSize;--一共多少行
		TableViewInfo.columnSize = columnSize;--一共多少列
		TableViewInfo.spacingW = spacingW; --横向间隔
		TableViewInfo.spacingH = spacingH; --纵向间隔

		return TableViewInfo
	end

	function mofaEmotionView.getCellWidth()
		return cellWidth ;--每个元素的宽
	end

	function mofaEmotionView.numberOfrow()
		return columnSize;
	end

	function mofaEmotionView.HeightOfCellAtNumberOfRow(i)
		return cellHeight;--每个元素的高
	end

	local PayRechargeList = {}
	function mofaEmotionView.CellOfAtNumberOfRow(cell, i)

		-- mofaId	int	魔法id
		local mofaId = mofaListInfo[i].mofaId
		-- mofaUrl	Text
		local mofaUrl = mofaListInfo[i].mofaUrl

		--按钮事件
		local function buttonCallBack()
			if(mofaEmotionView.isMoved)then
				return
			end
			Common.log("mofaEmotionView.buttonCallBack == "..i)
			sendMJ_SC_SEND_MAGIC(mUserID, mofaId);
		end

		--父节点layer
		local itemParentNode = CCSprite:createWithSpriteFrameName("MJ_ingame_infomation_btn_wupinkuang.png")
		itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2 ))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)

		local layerClick = CCLayer:create()
		mofaMenuListLayer[i] = layerClick;
		cell:addChild(layerClick)
		ccTableView.initTableViewClickedListener(i, 1, itemParentNode, mofaEmotionView, buttonCallBack, layerClick)

		--头像
		local photoSprite = CCSprite:create(MahjongTableConfig.getResPath("MJ_bianbian.png"))
		photoSprite:setPosition(ccp(cellWidth / 2, cellHeight / 2))
		itemParentNode:addChild(photoSprite)
		photoSprite:setScale(0.75)
		mofaIconList[i] = photoSprite
		Common.getPicFile(mofaUrl, i, true, updateIconUrl, false);

	end

	view:addChild(mofaEmotionView)
	ccTableView.reloadData(mofaEmotionView)
end

--[[--
--设置元宝充值tableview是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if mofaEmotionView ~= nil then
		mofaEmotionView:setTouchEnabled(Enabled)
		for i = 1, table.maxn(mofaMenuListLayer) do
			if mofaMenuListLayer[i] ~= nil then
				mofaMenuListLayer[i]:setTouchEnabled(Enabled);
			end
		end
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


--查看个人信息
local function processMJ_SC_MGR_PLAYER_INFO_IN_TABLE()
	local userInfo = MahjongLoadProfile.MahjongUserInfo.getUserInfoTable()
	local userId = userInfo["userID"]
	if mUserID == userId then
		updatePlayer(userInfo)
	end
end

--发送魔法表情
local function readMJ_SC_SEND_MAGIC()
	local sendMagicData = MahjongLoadProfile.MahjongUserInfo.getSendMagicEmotionTable()
	local result = sendMagicData["result"];
--	if result == 1 then
--		close()
--	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	mUserID = 0;
	mofaListInfo = {}
	mofaEmotionView = nil;
	mofaMenuListLayer = {};
	mofaIconList = {}
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_PLAYER_INFO_IN_TABLE, processMJ_SC_MGR_PLAYER_INFO_IN_TABLE) --查看个人信息
	framework.addSlot2Signal(MJ_SC_SEND_MAGIC, readMJ_SC_SEND_MAGIC) --发送魔法表情
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_PLAYER_INFO_IN_TABLE, processMJ_SC_MGR_PLAYER_INFO_IN_TABLE) --查看个人信息
	framework.removeSlotFromSignal(MJ_SC_SEND_MAGIC, readMJ_SC_SEND_MAGIC) --发送魔法表情
end
