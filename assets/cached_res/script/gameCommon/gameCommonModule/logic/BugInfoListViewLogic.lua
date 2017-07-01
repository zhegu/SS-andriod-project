module("BugInfoListViewLogic",package.seeall)

view = nil;

PanelBugInfoListView = nil;--
Button_close = nil;--
Panel_InfoList = nil;--
Label_BugInfo = nil;--

LogListTableView = nil; --系统消息tableview
LogListTableViewUITable = {};
LogListTable = {};--log路径列表

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
	local gui = GUI_BUGINFOLISTVIEW;
	if GameConfig.ScreenWidth >= 1920 then
		--适配1920*1080
		view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/BugInfoListView_1920_1080.json"));
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	else
		if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			--适配方案 1136x640
			view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/BugInfoListView.json"));
			GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
		elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
			--适配方案 Pad加黑边
			view = cocostudio.createScriptView(loadGameConfig.getGameCommonJsonPath("BugInfo/BugInfoListView.json"));
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
	PanelBugInfoListView = cocostudio.getUIPanel(view, "PanelBugInfoListView");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_InfoList = cocostudio.getUIPanel(view, "Panel_InfoList");
	Label_BugInfo = cocostudio.getUILabel(view, "Label_BugInfo");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();

	LogListTable = LogFileUtils.LoadLogFileList();

	createLogListTableView();
end

function requestMsg()

end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_BUGINFOLISTVIEW)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--设置TableView是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if LogListTableView ~= nil then
		LogListTableView:setTouchEnabled(Enabled)
		for i = 1, table.maxn(LogListTableViewUITable) do
			if LogListTableViewUITable[i].layerClick ~= nil then
				LogListTableViewUITable[i].layerClick:setTouchEnabled(Enabled);
			end
		end
	end
end

function createLogListTableView()
	if #LogListTable == 0 then
		Common.showToast("没有找到日志文件", 2)
		return;
	end

	local tableSize = 0; --元素数量
	local TableView_X = 0; --TableView的左下角X坐标
	local TableView_Y = 0; --TableView的左下角Y坐标
	local TableView_W = 1136; --TableView的显示宽度
	local TableView_H = 564; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = 1100; --每个元素的宽
	local cellHeight = 110; --每个元素的高
	local spacingW = 2; --横向间隔
	local spacingH = 2 --纵向间隔

	LogListTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	LogListTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function LogListTableView.initTableViewData()
		--loadCellSize = 0;
		LogListTableViewUITable = {}
		if LogListTable ~= nil and #LogListTable > 0 then
			--接收道具列表物品的数量
			tableSize = #LogListTable
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function LogListTableView.getTableViewInfo()
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

	function LogListTableView.getCellWidth()
		return cellWidth;--每个元素的宽
	end

	function LogListTableView.numberOfrow()
		return rowSize;
	end

	function LogListTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight;
	end

	function LogListTableView.CellOfAtNumberOfRow(cell, i)
		local LogInfo = LogListTable[i]

		LogListTableViewUITable[i] = {}

		local LogName = LogInfo.name;--文件名
		local LogPath = LogInfo.path;--文件路径
		local LogLength = LogInfo.length;--文件大小
		local LogDetails = LogFileUtils.readFile(LogPath);
		local isErrorLog = false; --是否含有lua报错

		--匹配字符串
		--"LUA ERROR"
		local startIndex, endIndex = string.find(LogDetails, "LUA ERROR")
		if startIndex ~= nil and endIndex ~= nil then
			isErrorLog = true;
			--Common.log("startIndex =============== " .. startIndex);
			--Common.log("endIndex =============== " .. endIndex);
			startIndex = startIndex - 10000;
			if startIndex < 1 then
				startIndex = 1;
			end
			LogDetails = string.sub(LogDetails, startIndex, -1);
		end
		--Common.log("length ================ ".. LogLength/1024 .."k");

		--父节点layer
		local itemParentNode = CCSprite:create(loadGameConfig.getGameCommonPath("px1.png"))
		itemParentNode:setPosition(ccp(cellWidth / 2 + 17, cellHeight/2 + spacingH))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)

		--按钮事件
		local function buttonCallBack()
			if(LogListTableView.isMoved)then
				return
			end
			if isErrorLog then
				Common.showToast("已截取到Lua Error附近信息", 2);
			end
			GameCommonConfig.showDebugInfo(LogDetails, isErrorLog, LogName);
		end

		--创建背景图片
		local imageBg = GamePub.createPointNineSprite(loadGameConfig.getGameCommonPath("BugInfo/bg_email_information0.png"), 25, 25, cellWidth, cellHeight + 20)
		imageBg:setPosition(ccp(0, 0));
		itemParentNode:addChild(imageBg);

		--tableview点击监听
		local layerClick = CCLayer:create()
		LogListTableViewUITable[i].layerClick = layerClick;
		cell:addChild(layerClick)
		ccTableView.initTableViewClickedListener(1, i, itemParentNode, LogListTableView, buttonCallBack, layerClick)

		--消息内容
		local showlog = LogName.."  (点击查看)   " .. math.floor(LogLength/1024) .."k";
		if isErrorLog then
			showlog = LogName.."  含有Lua报错(点击查看)   " .. math.floor(LogLength/1024) .."k";
		end
		local LabelContent = CCLabelTTF:create(showlog, "Arial", 30);
		LabelContent:setAnchorPoint(ccp(0, 0.5));
		if isErrorLog then
			LabelContent:setColor(ccc3(255, 0, 0));
		else
			LabelContent:setColor(ccc3(84, 36, 7));
		end
		LabelContent:setPosition(ccp(-360, 0));
		itemParentNode:addChild(LabelContent);

		--NO
		local LabelNumber = CCLabelTTF:create("NO."..(rowSize - i + 1), "Arial", 30);
		LabelNumber:setAnchorPoint(ccp(0, 0.5));
		if isErrorLog then
			LabelNumber:setColor(ccc3(255, 0, 0));
		else
			LabelNumber:setColor(ccc3(84, 36, 7));
		end
		LabelNumber:setPosition(ccp(-500, 0));
		itemParentNode:addChild(LabelNumber);
	end
	view:addChild(LogListTableView);
	ccTableView.reloadData(LogListTableView);
	if rowSize * cellHeight > TableView_H then
		LogListTableView:setContentOffset(ccp(0, -(rowSize * cellHeight - TableView_H) - rowSize*2),false);
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
end

function removeSlot()
end
