module("RoomRecordListLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_tableView = nil;--
Panel_dialog = nil;--
Button_close = nil;--
Button_left = nil;--
Button_right = nil;--

local current_page = -1  --当前的页签

local roomRecordTableView = nil --TableView
local roomRecordClickList = {} --点击集合
local roomRecordListBeforSplitData = {} --分割前数据集合
local roomRecordListData = {} --排行数据集合

local MsgPageIndex = 1;--消息的当前第几页
local MsgMaxPaging = 1;--消息的最大分页
local MsgPageCount = 20;--消息的每页条数

local pageFlagNode = nil; --分页标志图
local pageFlagDis = 30 --分布标志的间隔
local pageFlagList = {} --分页标志集合

local function close()
	mvcEngine.destroyModule(GUI_ROOMRECORDLIST)
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
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("exploits.plist"))
	local gui = GUI_ROOMRECORDLIST;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("RoomRecordList.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("RoomRecordList.json");
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
	Button_left = cocostudio.getUIButton(view, "Button_left");
	Button_right = cocostudio.getUIButton(view, "Button_right");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	GamePub.showDialogAmin(Panel_dialog)
end

function requestMsg()
	sendMJ_SC_MGR_ROOM_RECORD()
end

local function removeSplitPageFlag()
	pageFlagList = {}
	if pageFlagNode ~= nil then
		pageFlagNode:removeFromParentAndCleanup(true);
		pageFlagNode = nil
	end
end

--创建分页标志
local function createSplitPageFlag()
	removeSplitPageFlag()
	if MsgMaxPaging == 1 then
		--默认数据为100行，即是5页
		return
	end

	--浮点间距
	local posY = 118
	local x = GameConfig.ScreenWidth / 2 - (math.floor(MsgMaxPaging/2)*pageFlagDis)
	if math.mod(MsgMaxPaging,2) == 0 then
		--偶数个
		x = x + pageFlagDis/2
	end

	pageFlagNode = CCSprite:create(Common.getResourcePath("px1.png"))
	pageFlagNode:setPosition(ccp(0, 0))
	view:addChild(pageFlagNode)
	for index=1, MsgMaxPaging do
		local spr = CCSprite:createWithSpriteFrameName("MJ_HALL_rank_point_small.png")
		spr:setPosition(ccp(x + (index-1) * pageFlagDis,posY))
		pageFlagNode:addChild(spr)
		pageFlagList[index] = spr
	end
	pageFlagList[MsgPageIndex]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("MJ_HALL_rank_point_big.png"))
end

--切换分页的标志
local function changePageFlag()
	for index=1, MsgMaxPaging do
		if pageFlagList[MsgPageIndex] ~= nil then
			if index == MsgPageIndex then
				pageFlagList[index]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("MJ_HALL_rank_point_big.png"))
			else
				pageFlagList[index]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("MJ_HALL_rank_point_small.png"))
			end
		end
	end
end

--[[--
--消息分页
]]
local function splitFriendListPage()
	MsgPageIndex = 1;
	MsgMaxPaging = 1;
	roomRecordListData = {}

	if roomRecordListBeforSplitData == nil or #roomRecordListBeforSplitData == 0 then
		if pageFlagNode ~= nil then
			pageFlagNode:removeFromParentAndCleanup(true);
			pageFlagNode = nil
		end
		return;
	end

	--分页存储数据
	for i = 1, #roomRecordListBeforSplitData do
		if roomRecordListData[math.ceil(i/MsgPageCount)] == nil then
			roomRecordListData[math.ceil(i/MsgPageCount)] = {}
		end
		roomRecordListData[math.ceil(i/MsgPageCount)][(i-1)%MsgPageCount + 1] = roomRecordListBeforSplitData[i];
	end
	MsgMaxPaging = #roomRecordListData;
	Common.log("最大分页 maxPaging ============ "..MsgMaxPaging);

	--	for i = 1, #roomRecordListData do
	--		Common.log("#roomRecordListData["..i.."] ========= "..#roomRecordListData[i]);
	--	end

	--	if Label_server_page ~= nil then
	--		Label_server_page:setText(MsgPageIndex.."/"..MsgMaxPaging)
	--	end
	createSplitPageFlag()
end

--创建列表
local function createroomRecordTableView()
	roomRecordClickList = {}
	roomRecordClickList["layerClick"] = {}

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
	local cellHeight = 208; --每个元素的高
	local spacingW = 2; --横向间隔
	local spacingH = 2 --纵向间隔

	if roomRecordListData[MsgPageIndex] == nil or #roomRecordListData[MsgPageIndex] == 0 then
		return
	end

	roomRecordTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	roomRecordTableView:setPosition(TableView_X + TableView_W/2, TableView_Y + TableView_H/2);

	function roomRecordTableView.initTableViewData()
		--loadCellSize = 0;
		if roomRecordListData[MsgPageIndex] ~= nil and #roomRecordListData[MsgPageIndex] > 0 then
			--接收道具列表物品的数量
			tableSize = #roomRecordListData[MsgPageIndex]
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function roomRecordTableView.getTableViewInfo()
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

	function roomRecordTableView.getCellWidth()
		return cellWidth * GameConfig.ScaleAbscissa;--每个元素的宽
	end

	function roomRecordTableView.numberOfrow()
		return rowSize;
	end

	function roomRecordTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight * GameConfig.ScaleOrdinate;
	end

	function roomRecordTableView.CellOfAtNumberOfRow(cell, i)
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

			--……RecordID	Int	房间录像记录ID(透传)
			local RecordID = roomRecordListData[MsgPageIndex][index].RecordID
			--…roomCode	int	房间号
			local roomCode = roomRecordListData[MsgPageIndex][index].roomCode
			--…time	Text	时间	1999-12-22 22:32:22
			local time = roomRecordListData[MsgPageIndex][index].time
			local userInfoList = roomRecordListData[MsgPageIndex][index]["userList"]
			--											dataTable["infoList"][i]["userList"][j].userId

			--父节点layer
			local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
			itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)

			--按钮事件
			local function buttonCallBack()
				if roomRecordTableView.isMoved then
					return
				end
				Common.log("RecordID == "..RecordID)
				sendMJ_SC_MGR_INNING_RECORD(RecordID)
			end


			local layerClick = CCLayer:create()
			cell:addChild(layerClick)
			ccTableView.initTableViewClickedListener(j, i, itemParentNode, roomRecordTableView, buttonCallBack, layerClick)
			roomRecordClickList["layerClick"][i] = layerClick;

			--父节点layer
			local bgspr = CCSprite:createWithSpriteFrameName("MJ_btn_zhanjiwenzidiban_nor.png.png")
			bgspr:setPosition(ccp(0,0))
			itemParentNode:addChild(bgspr)

			--NO.
			local labelNum = CCLabelTTF:create(tostring(index), "Arial", 45)
			labelNum:setPosition(ccp(-610, 0));
			itemParentNode:addChild(labelNum)
			labelNum:setColor(ccc3(0xc5, 0xa1, 0x68))

			--房间号
			local labelRoomCode = CCLabelTTF:create(roomCode.."号房间", "Arial", 40)
			labelRoomCode:setPosition(ccp(-388, 60));
			itemParentNode:addChild(labelRoomCode)
			labelRoomCode:setColor(ccc3(0xc5, 0xa1, 0x68))

			--对战时间
			local labelTime = CCLabelTTF:create(time, "Arial", 40)
			labelTime:setPosition(ccp(364, 60));
			itemParentNode:addChild(labelTime)
			labelTime:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelName1 = CCLabelTTF:create(userInfoList[1].nickname, "Arial", 35)
			labelName1:setPosition(ccp(-470, 5));
			itemParentNode:addChild(labelName1)
			labelName1:setColor(ccc3(0xc5, 0xa1, 0x68))

			local labelScore1 = CCLabelTTF:create(userInfoList[1].score, "Arial", 35)
			labelScore1:setPosition(ccp(-200, 5));
			itemParentNode:addChild(labelScore1)
			labelScore1:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelName2 = CCLabelTTF:create(userInfoList[2].nickname, "Arial", 35)
			labelName2:setPosition(ccp(-470, -55));
			itemParentNode:addChild(labelName2)
			labelName2:setColor(ccc3(0xc5, 0xa1, 0x68))

			local labelScore2 = CCLabelTTF:create(userInfoList[2].score, "Arial", 35)
			labelScore2:setPosition(ccp(-200, -55));
			itemParentNode:addChild(labelScore2)
			labelScore2:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelName3 = CCLabelTTF:create(userInfoList[3].nickname, "Arial", 35)
			labelName3:setPosition(ccp(140, 5));
			itemParentNode:addChild(labelName3)
			labelName3:setColor(ccc3(0xc5, 0xa1, 0x68))

			local labelScore3 = CCLabelTTF:create(userInfoList[3].score, "Arial", 35)
			labelScore3:setPosition(ccp(410, 5));
			itemParentNode:addChild(labelScore3)
			labelScore3:setColor(ccc3(0xc5, 0xa1, 0x68))

			--玩家
			local labelName4 = CCLabelTTF:create(userInfoList[4].nickname, "Arial", 35)
			labelName4:setPosition(ccp(140, -55));
			itemParentNode:addChild(labelName4)
			labelName4:setColor(ccc3(0xc5, 0xa1, 0x68))

			local labelScore4 = CCLabelTTF:create(userInfoList[4].score, "Arial", 35)
			labelScore4:setPosition(ccp(410, -55));
			itemParentNode:addChild(labelScore4)
			labelScore4:setColor(ccc3(0xc5, 0xa1, 0x68))

		end
	end

	view:addChild(roomRecordTableView)
	ccTableView.reloadData(roomRecordTableView)

end


--刷新TableView
local function refreshroomRecordTableView()
	--	deleteFriendAllClickedLayer()
	if roomRecordListData ~= nil and #roomRecordListData > 0 then
		if roomRecordTableView ~= nil then
			roomRecordTableView:setVisible(true)
			ccTableView.reloadData(roomRecordTableView);
		else
			createroomRecordTableView()
		end
		--		Label_noFriend:setVisible(false)
	else
		if roomRecordTableView ~= nil then
			local container = roomRecordTableView:getChildren():objectAtIndex(0)
			tolua.cast(container,"CCLayer")
			container:removeAllChildrenWithCleanup(true)
		end
		--		Label_noFriend:setVisible(true)
	end
end


--[[--
--设置tableview是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if roomRecordTableView ~= nil then
		roomRecordTableView:setTouchEnabled(Enabled)
		for i=1, #roomRecordClickList["layerClick"] do
			roomRecordClickList["layerClick"][i]:setTouchEnabled(Enabled);
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

function callback_Button_left(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if MsgPageIndex > 1 then
			MsgPageIndex = MsgPageIndex - 1;
			refreshroomRecordTableView()
			changePageFlag()
		else
			Common.showToast("已经是第一页", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_right(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if MsgPageIndex < MsgMaxPaging then
			MsgPageIndex = MsgPageIndex + 1;
			refreshroomRecordTableView()
			changePageFlag()
		else
			Common.showToast("已经是最后一页", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--房间战绩
local function readMJ_SC_MGR_ROOM_RECORD()
	roomRecordListBeforSplitData = profile.MahjongRecord.getRoomRecordTable()
	if roomRecordListBeforSplitData ~= nil then
		splitFriendListPage()
		refreshroomRecordTableView()
	end
end

--牌局战绩
local function readMJ_SC_MGR_INNING_RECORD()
	mvcEngine.createModule(GUI_TABLERECORDLIST)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("exploits.plist"))
	current_page = -1  --当前的页签

	roomRecordTableView = nil --TableView
	roomRecordClickList = {} --点击集合
	roomRecordListBeforSplitData = {} --分割前数据集合
	roomRecordListData = {} --排行数据集合

	MsgPageIndex = 1;--消息的当前第几页
	MsgMaxPaging = 1;--消息的最大分页
	pageFlagNode = nil; --分页标志图
	pageFlagList = {} --分页标志集合
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_ROOM_RECORD, readMJ_SC_MGR_ROOM_RECORD) --房间战绩
	framework.addSlot2Signal(MJ_SC_MGR_INNING_RECORD, readMJ_SC_MGR_INNING_RECORD) --牌局战绩
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_ROOM_RECORD, readMJ_SC_MGR_ROOM_RECORD) --房间战绩
	framework.removeSlotFromSignal(MJ_SC_MGR_INNING_RECORD, readMJ_SC_MGR_INNING_RECORD) --牌局战绩
end
