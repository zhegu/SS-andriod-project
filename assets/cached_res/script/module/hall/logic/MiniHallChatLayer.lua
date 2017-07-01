--显示大厅mini聊天框的
module("MiniHallChatLayer",package.seeall)

--聊天相关
local chatTextTable = {}
local chatMaxCount = 3 -- 聊天最大条数
ChatRecordTableView = nil; --聊天tableview
ChatRecordTableViewUITable = nil; --聊天tableviewUITable
local TextHeight = 24; --一行文本的高度
local fontSize = 20 --消息内容的字号

--[[--
--设置TableView是否可触摸/Menu是否可点击
--]]
function setChatRecordEnabled(Enabled)
	if ChatRecordTableView ~= nil then
		ChatRecordTableView:setTouchEnabled(Enabled)
		for i = 1, table.maxn(ChatRecordTableViewUITable) do
			if ChatRecordTableViewUITable[i] ~= nil then
				ChatRecordTableViewUITable[i]:setEnabled(Enabled);
			end
		end
	end
end

function removeChatRecordTableViewUITable()
	if ChatRecordTableView ~= nil then
		for i = 1, table.maxn(ChatRecordTableViewUITable) do
			if ChatRecordTableViewUITable[i] ~= nil then
				ChatRecordTableViewUITable[i]:setEnabled(false)
				ChatRecordTableViewUITable[i]:removeFromParentAndCleanup(true)
				ChatRecordTableViewUITable[i] = nil
			end
		end
	end
end

--[[--
--显示聊天tableview
--]]
function showChatRecordTableView()
	if ChatRecordTableView ~= nil then
		ChatRecordTableView:setVisible(true)
		ccTableView.reloadData(ChatRecordTableView);
		ChatRecordTableView:setContentOffset(ccp(0, 0),false);
		setChatRecordEnabled(ChatRecordTableView:isTouchEnabled());
	else
		createChatRecordTableView();
	end
end

function createChatRecordTableView()
	if chatTextTable == nil or #chatTextTable == 0 then
		return
	end


	local Panel_miniChatSize = HallLogic.Panel_miniChat:getContentSize()
	local Panel_miniChatPosX = HallLogic.Panel_miniChat:getPosition().x
	local Panel_miniChatPosY = HallLogic.Panel_miniChat:getPosition().y


	local tableSize = 0; --元素数量
	local TableView_X = Panel_miniChatPosX + 5; --TableView的左下角X坐标
	local TableView_Y = Panel_miniChatPosY; --TableView的左下角Y坐标
	local TableView_W = Panel_miniChatSize.width; --TableView的显示宽度
	local TableView_H = Panel_miniChatSize.height; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 20; --每个元素的高
	local spacingW = 0; --横向间隔
	local spacingH = 3 --纵向间隔

	ChatRecordTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	ChatRecordTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function ChatRecordTableView.initTableViewData()
		ChatRecordTableViewUITable = {}
		--		loadCellSize = 0;MessageTable["MessageList"]
		if chatTextTable ~= nil and #chatTextTable > 0 then
			--接收道具列表物品的数量
			tableSize = #chatTextTable
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function ChatRecordTableView.numberOfrow()
		return rowSize;
	end

	function ChatRecordTableView.HeightOfCellAtNumberOfRow(i)
		if i <= #chatTextTable then
			i = #chatTextTable - i + 1
		end
		--vip等级
		local numVipLevel = VIPPub.getUserVipType(chatTextTable[i]["VipLevel"]);
		--消息内容
		local chatText = nil;
		chatText = chatTextTable[i]["SpeakerNickName"] .. ":" .. chatTextTable[i]["SpeechText"]
		local txtLength = Common.getFontStringLen(chatText, fontSize);
		local heightNum = txtLength / (cellWidth - 5) + 1
		cellHeight = heightNum * TextHeight
		return cellHeight + spacingH;
	end

	function ChatRecordTableView.getCellWidth()
		return cellWidth;
	end

	function ChatRecordTableView.CellOfAtNumberOfRow(cell, i)
		if i <= #chatTextTable then
			i = #chatTextTable - i + 1
		end
		ChatRecordTableViewUITable[i] = {}

		--vip等级
		local numVipLevel = VIPPub.getUserVipType(chatTextTable[i]["VipLevel"]);
		--ActionId
		local actionId = nil
		--消息内容
		local chatText = nil;
		chatText = chatTextTable[i]["SpeakerNickName"] .. ":" .. chatTextTable[i]["SpeechText"]
		local txtLength = Common.getFontStringLen(chatText, fontSize);
		local heightNum = txtLength / (cellWidth - 5) + 1
		cellHeight = heightNum * TextHeight

		--按钮事件
		local function buttonCallBack()
			if(ChatRecordTableView.isMoved)then
				return
			end
			mvcEngine.createModule(GUI_HALLCHAT)
		end

		--父节点layer
		local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
		itemParentNode:setPosition(ccp(0, cellHeight/2 - 5))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)

		--创建背景图片，用作menu
		local pRibbon = GamePub.createPointNineSprite(Common.getResourcePath("px1.png"), 25, 25, cellWidth, cellHeight)
		local pRibbon1 = GamePub.createPointNineSprite(Common.getResourcePath("px1.png"), 25, 25, cellWidth, cellHeight)
		pRibbon1:setColor(ccc3(200, 200, 200))

		local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
		diSpriteItem:registerScriptTapHandler(buttonCallBack)
		diSpriteItem:setAnchorPoint(ccp(0, 0.5))

		local menuCell = CCMenu:create()
		menuCell:setPosition(0, 25)
		diSpriteItem:setAnchorPoint(ccp(0, 0.5))
		menuCell:addChild(diSpriteItem)
		itemParentNode:addChild(menuCell)
		ChatRecordTableViewUITable[i] = diSpriteItem;


		--消息内容
		local LabelContent = CCLabelTTF:create(chatText, "Arial", fontSize, CCSizeMake (cellWidth-5, cellHeight), kCCTextAlignmentLeft)
		LabelContent:setAnchorPoint(ccp(0, 1))
		LabelContent:setPosition(ccp(0, cellHeight/2 + 5))
		itemParentNode:addChild(LabelContent)
		if actionId ~= nil and actionId ~= 0 then
			LabelContent:setColor(ccc3(228, 78, 63))
		else
			LabelContent:setColor(ccc3(chatTextTable[i]["ARGB1"], chatTextTable[i]["ARGB2"], chatTextTable[i]["ARGB3"]))
		end


	end
	HallLogic.view:addChild(ChatRecordTableView)
	ccTableView.reloadData(ChatRecordTableView)
	ChatRecordTableView:setContentOffset(ccp(0, 0),false);


	if mvcEngine.logicModuleIsSleep(GUI_HALL) then
		setChatRecordEnabled(false)
	end
end

function addMiniHallChat(chatTable)
--	local chatTable = profile.IM.getUserChatTable()
	local chatTableSize = #chatTextTable
	if (chatTableSize >= chatMaxCount) then
		table.remove(chatTextTable, 1)
	end
	table.insert(chatTextTable, chatTable)
	showChatRecordTableView()
end

function clearData()
	chatTextTable = {}
	chatMaxCount = 3 -- 聊天最大条数
	TextHeight = 24; --一行文本的高度
	removeChatRecordTableViewUITable()
	ChatRecordTableView = nil
end

