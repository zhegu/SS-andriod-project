module("BuyCardLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_tableView = nil;--
Panel_24 = nil;--
Panel_17 = nil;--
btn_done = nil;--
Label_daili = nil;--
Button_copyDaili = nil;--
Panel_19 = nil;--

local CommonWeiXinListData = {} --界面数据
local DaiLiWeiXin = "";

local CommonWeiXinTableView = nil;

local function close()
	mvcEngine.destroyModule(GUI_BUYCARD)
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
	local gui = GUI_BUYCARD;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("BuyCard.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("BuyCard.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_tableView = cocostudio.getUIPanel(view, "Panel_tableView");
	Panel_24 = cocostudio.getUIPanel(view, "Panel_24");
	Panel_17 = cocostudio.getUIPanel(view, "Panel_17");
	btn_done = cocostudio.getUIButton(view, "btn_done");
	Label_daili = cocostudio.getUILabel(view, "Label_daili");
	Button_copyDaili = cocostudio.getUIButton(view, "Button_copyDaili");
	Panel_19 = cocostudio.getUIPanel(view, "Panel_19");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	initData();
end

function requestMsg()

end

function initData()

	local baseHallData = profile.MahjongUserInfo.getMJHallInfoTable()
	-- DaiLiWeiXin	Text	代理微信号
	DaiLiWeiXin = baseHallData["DaiLiWeiXin"]
	Label_daili:setText(DaiLiWeiXin);

	for i=1, #baseHallData["CommonWeiXinList"] do
		local type = baseHallData["CommonWeiXinList"][i].type
		local value = baseHallData["CommonWeiXinList"][i].value
		if type == 1 then
			--微信
			table.insert(CommonWeiXinListData,value);
		end
	end

	createCommonWeiXinTableView();
end

function createCommonWeiXinTableView()
	local tableSize = 0; --元素数量
	local TableView_X = 512; --TableView的左下角X坐标
	local TableView_Y = 266; --TableView的左下角Y坐标
	local TableView_W = 900; --TableView的显示宽度
	local TableView_H = 360; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 100; --每个元素的高
	local spacingW = 2; --横向间隔
	local spacingH = 2 --纵向间隔

	local loadCellSize = 0;--已经加载的元素数
	--数据不存在, return
	if CommonWeiXinListData == nil or CommonWeiXinListData == "" then
		return;
	end

	CommonWeiXinTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	CommonWeiXinTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function CommonWeiXinTableView.initTableViewData()
		loadCellSize = 0;
		if CommonWeiXinListData ~= nil and #CommonWeiXinListData > 0 then
			--接收道具列表物品的数量
			tableSize = #CommonWeiXinListData
			--计算一共多少行
			rowSize = math.floor(tableSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function CommonWeiXinTableView.numberOfrow()
		return rowSize;
	end

	function CommonWeiXinTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight * GameConfig.ScaleOrdinate;
	end

	function CommonWeiXinTableView.getCellWidth()
		return cellWidth * GameConfig.ScaleAbscissa;
	end

	function CommonWeiXinTableView.CellOfAtNumberOfRow(cell, i)
		if i <= #CommonWeiXinListData then
			i = #CommonWeiXinListData - i + 1
		end

		--微信号
		local weiXinNumber = CommonWeiXinListData[i]

		--追踪
		local function buttonMenuCallBack()
			if CommonWeiXinTableView.isMoved then
				return
			end
			Common.log("微信号 weiXinNumber == "..weiXinNumber)
			Common.setClipboard(weiXinNumber)
			Common.showToast("复制成功" ,2);
		end

		--玩家名称
		local labelName = CCLabelTTF:create(weiXinNumber, "Arial", 34)
		labelName:setPosition(ccp(cellWidth * 0.35, cellHeight/2));
		cell:addChild(labelName)
		labelName:setColor(ccc3(0xc5, 0xa1, 0x68))

		local pRibbon = CCSprite:createWithSpriteFrameName("MJ_lananniu.png")
		local pRibbon1 = CCSprite:createWithSpriteFrameName("MJ_lananniu.png")
		local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
		diSpriteItem:registerScriptTapHandler(buttonMenuCallBack)
		diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))
		local menuCell = CCMenu:create()
		menuCell:setPosition(cellWidth * 0.65, cellHeight/2)
		menuCell:setAnchorPoint(ccp(0.5, 0.5))
		menuCell:addChild(diSpriteItem)
		cell:addChild(menuCell)
		--traceClickList["button"][index] = menuCell

		local buttonLogo = CCSprite:createWithSpriteFrameName("MJ_btn_lansefuzhianniu_nor.png")
		buttonLogo:setPosition(diSpriteItem:getContentSize().width /2, diSpriteItem:getContentSize().height /2)
		diSpriteItem:addChild(buttonLogo);
	end

	view:addChild(CommonWeiXinTableView)
	ccTableView.reloadData(CommonWeiXinTableView)
end

function callback_btn_done(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_copyDaili(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.setClipboard(DaiLiWeiXin)
		Common.showToast("复制成功" ,2);
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CommonWeiXinListData = {};
	DaiLiWeiXin = "";
	CommonWeiXinTableView = nil;
end

function addSlot()
end

function removeSlot()
end
