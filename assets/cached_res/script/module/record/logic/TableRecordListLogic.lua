module("TableRecordListLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_tableView = nil;--
Panel_dialog = nil;--
Button_close = nil;--
Label_userName1 = nil;--
Label_userName2 = nil;--
Label_userName3 = nil;--
Label_userName4 = nil;--

local tableRecordTableView = nil --TableView
local tableRecordClickList = {} --点击集合
local tableRecordListData = {} --排行数据集合

local labelNameTable = {};

local function close()
	mvcEngine.destroyModule(GUI_TABLERECORDLIST)
end

local function closePanel()
	GamePub.closeDialogAmin(Panel_dialog,close)
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		closePanel()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_TABLERECORDLIST;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("TableRecordList.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("TableRecordList.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_tableView = cocostudio.getUIPanel(view, "Panel_tableView");
	Panel_dialog = cocostudio.getUIPanel(view, "Panel_dialog");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Label_userName1 = cocostudio.getUILabel(view, "Label_userName1");
	Label_userName2 = cocostudio.getUILabel(view, "Label_userName2");
	Label_userName3 = cocostudio.getUILabel(view, "Label_userName3");
	Label_userName4 = cocostudio.getUILabel(view, "Label_userName4");

	labelNameTable = {Label_userName1, Label_userName2, Label_userName3, Label_userName4}
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	GamePub.showDialogAmin(Panel_dialog)

	local roomRecordData = profile.MahjongRecord.getTableRecordTable()

	for index=1, #labelNameTable do
		local name = roomRecordData["userInfoList"][index].nickname;
		local txtLength = Common.getFontStringLen(name, 45);
		if txtLength > 5 then
			name = Common.SubUTF8String(name,1,5).."...";
		end
		labelNameTable[index]:setText(name)
	end

	tableRecordListData = roomRecordData["infoList"]
	createtableRecordTableView()
end

function requestMsg()

end

--创建列表
function createtableRecordTableView()
	tableRecordClickList = {}
	tableRecordClickList["button"] = {}

	local PanelListSize = Panel_tableView:getContentSize()
	local PanelListPosX = Panel_tableView:getPosition().x
	local PanelListPosY = Panel_tableView:getPosition().y

	local tableSize = 0; --元素数量
	local TableView_X = PanelListPosX ; --TableView的左下角X坐标
	local TableView_Y = PanelListPosY ; --TableView的左下角Y坐标
	local TableView_W = PanelListSize.width; --TableView的显示宽度
	local TableView_H = PanelListSize.height; --TableView的显示高度

	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 140; --每个元素的高
	local spacingW = 2; --横向间隔
	local spacingH = 2 --纵向间隔

	if tableRecordListData == nil or #tableRecordListData == 0 then
		return
	end

	tableRecordTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	tableRecordTableView:setPosition(TableView_X + TableView_W/2, TableView_Y + TableView_H/2);

	function tableRecordTableView.initTableViewData()
		--loadCellSize = 0;
		if tableRecordListData ~= nil and #tableRecordListData > 0 then
			--接收道具列表物品的数量
			tableSize = #tableRecordListData
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function tableRecordTableView.getTableViewInfo()
		local TableViewInfo = {}

		TableViewInfo.TableView_X = TableView_X * GameConfig.ScaleAbscissa;--TableView的左下角X坐标
		TableViewInfo.TableView_Y = TableView_Y * GameConfig.ScaleOrdinate;--TableView的左下角Y坐标
		TableViewInfo.TableView_W = TableView_W * GameConfig.ScaleAbscissa;--TableView的显示宽度
		TableViewInfo.TableView_H = TableView_H * GameConfig.ScaleOrdinate;--TableView的显示高度
		TableViewInfo.rowSize = rowSize;--一共多少行
		TableViewInfo.columnSize = columnSize;--一共多少列
		TableViewInfo.spacingW = spacingW; --横向间隔
		TableViewInfo.spacingH = spacingH; --纵向间隔

		return TableViewInfo
	end

	function tableRecordTableView.getCellWidth()
		return cellWidth * GameConfig.ScaleAbscissa;--每个元素的宽
	end

	function tableRecordTableView.numberOfrow()
		return rowSize;
	end

	function tableRecordTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight * GameConfig.ScaleOrdinate;
	end

	function tableRecordTableView.CellOfAtNumberOfRow(cell, i)
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
		--循环当前行
		for j = 1, currentColumn do

			local index = (rowSize - i) * columnSize + j--当前索引

			local time = tableRecordListData[index].time
			local videoID = tableRecordListData[index].videoID
			local videoUrl = tableRecordListData[index].videoUrl
			local userInfoList = tableRecordListData[index]["userList"]

			--父节点layer
			local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
			itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)

			--按钮事件
			local function buttonCallBack()
				if tableRecordTableView.isMoved then
					return
				end
				Common.log("videoID == "..videoID)
				Common.log("videoUrl == "..videoUrl)

				RecordConsole.downloadRecordFile(videoUrl);
			end


--			local layerClick = CCLayer:create()
--			cell:addChild(layerClick)
--			ccTableView.initTableViewClickedListener(j, i, itemParentNode, tableRecordTableView, buttonCallBack, layerClick)
--			tableRecordClickList["layerClick"][i] = layerClick;

			if index % 2 == 0 then
				local bgspr = CCSprite:createWithSpriteFrameName("MJ_btn_zhanji_dibangedang.png")
				bgspr:setPosition(ccp(0,0))
				itemParentNode:addChild(bgspr)
			end

			--NO.
			local labelNum = CCLabelTTF:create(tostring(index), "Arial", 35)
			labelNum:setPosition(ccp(-650, 0));
			itemParentNode:addChild(labelNum)
			labelNum:setColor(ccc3(0xc5, 0xa1, 0x68))

			--时间
			local labelRoomCode = CCLabelTTF:create(time, "Arial", 40)
			labelRoomCode:setPosition(ccp(-440, 0));
			itemParentNode:addChild(labelRoomCode)
			labelRoomCode:setColor(ccc3(0xc5, 0xa1, 0x68))


			--玩家
			local labelScore1 = CCLabelTTF:create(userInfoList[1].score, "Arial", 35)
			labelScore1:setPosition(ccp(-180, 0));
			itemParentNode:addChild(labelScore1)
			labelScore1:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelScore2 = CCLabelTTF:create(userInfoList[2].score, "Arial", 35)
			labelScore2:setPosition(ccp(50, 0));
			itemParentNode:addChild(labelScore2)
			labelScore2:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelScore3 = CCLabelTTF:create(userInfoList[3].score, "Arial", 35)
			labelScore3:setPosition(ccp(280, 0));
			itemParentNode:addChild(labelScore3)
			labelScore3:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelScore4 = CCLabelTTF:create(userInfoList[4].score, "Arial", 35)
			labelScore4:setPosition(ccp(510, 0));
			itemParentNode:addChild(labelScore4)
			labelScore4:setColor(ccc3(0xc5, 0xa1, 0x68))

			--播放按钮
			local pRibbon = CCSprite:createWithSpriteFrameName("MJ_btn_xuanzhong_nor.png")
			local pRibbon1 = CCSprite:createWithSpriteFrameName("MJ_btn_xuanzhong_nor.png")

			local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
			diSpriteItem:registerScriptTapHandler(buttonCallBack)
			diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))

			local menuCell = CCMenu:create()
			menuCell:setPosition(660,0)
			menuCell:setAnchorPoint(ccp(0.5, 0.5))
			menuCell:addChild(diSpriteItem)
			itemParentNode:addChild(menuCell)
			tableRecordClickList["button"][i] = menuCell

		end
	end

	view:addChild(tableRecordTableView)
	ccTableView.reloadData(tableRecordTableView)

end

--[[--
--设置tableview是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if tableRecordTableView ~= nil then
		tableRecordTableView:setTouchEnabled(Enabled)
		for i=1, #tableRecordClickList["button"] do
			tableRecordClickList["button"][i]:setTouchEnabled(Enabled);
		end
	end
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		closePanel()
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
	tableRecordTableView = nil --TableView
	tableRecordClickList = {} --点击集合
	tableRecordListData = {} --排行数据集合
	labelNameTable = {}
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
