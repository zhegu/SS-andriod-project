module("BugInfoViewLogic", package.seeall)

view = nil;

PanelBugInfoView = nil;--
Button_close = nil;--
Panel_WebView = nil;--
Label_BugInfo = nil;--
Button_send = nil;--

LogName = nil;

isBugInfo = false;

ViewState = 1;
local BUG_INFO = 1;--显示bug信息
local EMAIL_INFO = 2;--显示发送邮件列表

shopMoneyItemList = {}  --列表父节点，用于播放动画
emailListTableView = nil;
shopMoneyClickList = {}

local emailList = {
	{name = "于鹏", email = "yupeng@tongqutongqu.cn"},
	{name = "徐伟浩", email = "XuWH@tongqutongqu.cn"},
	{name = "赵柏林", email = "zhaobailin@tongqutongqu.cn"},
	{name = "李雪", email = "lixue@tongqutongqu.cn"},
	{name = "焦风", email = "jiaofeng@tongqutongqu.cn"},
	{name = "姜力", email = "JiangLi@tongqutongqu.cn"},
	{name = "李海阳", email = "LiHaiYang@tongqutongqu.cn"},
	{name = "刘梦晶", email = "liumengjing@tongqutongqu.cn"},
};

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

local ScaleAbscissa;
local ScaleOrdinate;

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_BUGINFOVIEW;
	if GameConfig.ScreenWidth >= 1920 then
		--适配1920*1080
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/BugInfoView_1920_1080.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	else
		if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			--适配方案 1136x640
			view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/BugInfoView.json"));
			GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
		elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
			--适配方案 Pad加黑边
			view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/BugInfoView.json"));
			GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
		end
	end

	ScaleAbscissa = 1136 / GameConfig.ScreenWidth;
	ScaleOrdinate = 640 / GameConfig.ScreenHeight;
end

--[[--
--初始化控件
--]]
local function initView()
	PanelBugInfoView = cocostudio.getUIPanel(view, "PanelBugInfoView");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_WebView = cocostudio.getUIPanel(view, "Panel_WebView");
	Label_BugInfo = cocostudio.getUILabel(view, "Label_BugInfo");
	Button_send = cocostudio.getUIButton(view, "Button_send");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
end

function requestMsg()

end

local function setState(state)
	ViewState = state;
	if ViewState == BUG_INFO then
		Common.didShowWebview()
		Label_BugInfo:setText("游戏日志信息(可滑动)");
		Common.setButtonVisible(Button_send, true);
		deleteAllClickedLayer();
		hideEmailListTableView();
	elseif ViewState == EMAIL_INFO then
		Common.didHideWebview();
		Label_BugInfo:setText("请选择要发送的同学");
		Common.setButtonVisible(Button_send, false);
		createEmailListTableView();
	end
end

--[[--
--删除所有当点击层
--]]
function deleteAllClickedLayer()
	if emailListTableView ~= nil then
		for i = 1, table.maxn(shopMoneyClickList) do
			if shopMoneyClickList[i] ~= nil then
				shopMoneyClickList[i]:setTouchEnabled(false)
				shopMoneyClickList[i]:removeFromParentAndCleanup(true)
				shopMoneyClickList[i] = nil
			end
		end
	end
end

--[[--
--隐藏道具列表
--]]
function hideEmailListTableView()
	if emailListTableView ~= nil then
		emailListTableView:setVisible(false)
	end
end

local function sendEmail(logName, email, isBug)
	local path = "";
	if Common.platform == Common.TargetIos then
		path = Common.getIOSDocumentDirectoryPath("LuaLog/" .. Load.APP_NAME) .. "/" .. logName;
	elseif Common.platform == Common.TargetAndroid then
		path = Common.getTrendsSaveFilePath("LuaLog/" .. Load.APP_NAME) .. logName;
	end

	mvcEngine.createModule(GUI_EMAILINFOVIEW);
	EmailInfoViewLogic.setEmailInfo(path, logName, email, isBug);
end

--[[--
--创建金币列表
--]]
function createEmailListTableView()
	deleteAllClickedLayer();
	local tableSize = 0; --元素数量
	local TableView_X = 30; --TableView的左下角X坐标
	local TableView_Y = 0; --TableView的左下角Y坐标
	local TableView_W = 1136; --TableView的显示宽度
	local TableView_H = 564; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 5; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = 209; --每个元素的宽
	local cellHeight = 244; --每个元素的高
	local spacingW = 8; --横向间隔
	local spacingH = 10 --纵向间隔

	TableView_X = TableView_X - TableView_W * (1 - GameConfig.ScaleAbscissa) / 2
	TableView_Y = TableView_Y - TableView_H * (1 - GameConfig.ScaleOrdinate) / 2

	local loadCellSize = 0;--已经加载的元素数

	emailListTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	emailListTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function emailListTableView.initTableViewData()

		shopMoneyItemList = {};
		loadCellSize = 0;
		if emailList ~= nil and #emailList > 0 then
			--接收道具列表物品的数量
			tableSize = #emailList
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function emailListTableView.getTableViewInfo()
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

	function emailListTableView.getCellWidth()
		return cellWidth;--每个元素的宽
	end

	function emailListTableView.numberOfrow()
		Common.log("rowSize"..rowSize)
		return rowSize;
	end

	function emailListTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight;
	end

	function emailListTableView.CellOfAtNumberOfRow(cell, i)
		--元素默认从下往上排列,i=1即最后一行
		local currentColumn = 0;--当前行有多少列
		if i == 1 then
			--首次调用
			currentColumn = tableSize % columnSize;
			if currentColumn == 0 then
				currentColumn = columnSize;
			end
		else
			currentColumn = columnSize;
		end
		Common.log("currentColumn"..currentColumn)
		--循环当前行
		for j = 1, currentColumn do

			local index = (rowSize - i) * columnSize + j--当前索引

			loadCellSize = loadCellSize + 1;
			local name = emailList[index].name
			local email = emailList[index].email

			--父节点layer
			local itemParentNode = CCSprite:create(loadGameConfig.getGameCommonPath("px1.png"))
			itemParentNode:setPosition(ccp(cellWidth / 2 + (j - 1) * (cellWidth + spacingW), cellHeight / 2 - spacingH))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)

			--按钮事件
			local function buttonCallBack()
				if emailListTableView.isMoved then
					return;
				end
				if LogName == nil then
					return;
				end
				local logName = LogName;
				local isBug = isBugInfo;
				mvcEngine.destroyModule(GUI_BUGINFOVIEW);
				sendEmail(logName, email, isBug);
			end

			--创建背景图片，用作menu
			local pRibbon = GamePub.createPointNineSprite(loadGameConfig.getGameCommonPath("BugInfo/bg_bag_item.png"), 25, 25, cellWidth, cellHeight - 20)
			local pRibbon1 = GamePub.createPointNineSprite(loadGameConfig.getGameCommonPath("BugInfo/bg_bag_item.png"), 25, 25, cellWidth, cellHeight - 20)
			pRibbon1:setColor(ccc3(200, 200, 200))

			local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
			diSpriteItem:registerScriptTapHandler(buttonCallBack)
			diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))

			local menuCell = CCMenu:create()
			menuCell:setPosition(0, 0)
			diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))
			menuCell:addChild(diSpriteItem)
			itemParentNode:addChild(menuCell)
			diSpriteItem:setEnabled(false)
			menuCell:setEnabled(false)

			local layerClick = CCLayer:create()
			shopMoneyClickList[index] = layerClick;
			cell:addChild(layerClick)
			ccTableView.initTableViewClickedListener(j, i, itemParentNode, emailListTableView, buttonCallBack, layerClick)

			--创建title文本 名称
			local titleLabel = CCLabelTTF:create("点击发送", "Arial", 28);
			titleLabel:setColor(ccc3(65, 41, 25));
			titleLabel:setPosition(ccp(0, 50));
			itemParentNode:addChild(titleLabel);

			local titleLabel = CCLabelTTF:create(name, "Arial", 28);
			titleLabel:setColor(ccc3(65, 41, 25));
			titleLabel:setPosition(ccp(0, 0));
			itemParentNode:addChild(titleLabel);

			local titleLabel = CCLabelTTF:create(email, "Arial", 14);
			titleLabel:setColor(ccc3(65, 41, 25));
			titleLabel:setPosition(ccp(0, -50));
			itemParentNode:addChild(titleLabel);

			itemParentNode:setVisible(false);

			shopMoneyItemList[index] = itemParentNode

			if loadCellSize == tableSize then
				--加载完毕
				playTabelViewAnimation(shopMoneyItemList);
			end

		end
	end

	emailListTableView:setScaleX(GameConfig.ScaleAbscissa);
	emailListTableView:setScaleY(GameConfig.ScaleOrdinate);
	view:addChild(emailListTableView)
	ccTableView.reloadData(emailListTableView)
end

--[[--
-- 播放道具列表动画
--]]
function playTabelViewAnimation(ItemList)
	local function callbackShowList(index)
		if ItemList[index] ~= nil then
			ItemList[index]:setVisible(true);
		end
	end
	local function tabelViewAnimationEnd()
		Common.log("tabelViewAnimationEnd ================ ");
	end
	GamePub.showLandscapeList(ItemList, callbackShowList, tabelViewAnimationEnd);
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if ViewState == BUG_INFO then
			mvcEngine.destroyModule(GUI_BUGINFOVIEW)
		elseif ViewState == EMAIL_INFO then
			setState(BUG_INFO);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_send(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setState(EMAIL_INFO);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--创建显示debug信息
--]]
function showDebugInfo(info, isBug, fileName)
	isBugInfo = isBug;
	ViewState = BUG_INFO;
	if fileName ~= nil then
		LogName = fileName;
		Common.setButtonVisible(Button_send, true);
	else
		Common.setButtonVisible(Button_send, false);
	end
	local x = Panel_WebView:getPosition().x;
	local y = Panel_WebView:getPosition().y;
	local w = Panel_WebView:getSize().width;
	local h = Panel_WebView:getSize().height;
	if isBug ~= nil and not isBug then
		Common.showWebView("", "<font color=#EEE8AA>"..info.."</font>", x, y, w, h);
	else
		Common.showWebView("", "<font color=#FF0000>"..info.."</font>", x, y, w, h);
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	Common.hideWebView();
end

function addSlot()
end

function removeSlot()
end
