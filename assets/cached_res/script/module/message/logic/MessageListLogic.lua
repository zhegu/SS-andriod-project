module("MessageListLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_list = nil;--
Panel_11 = nil;--
btn_back = nil;--
Panel_10 = nil;--
Button_left = nil;--
Button_right = nil;--


MsgServerTableView = nil; --系统消息tableview
local MsgServerTableViewUITable = {};--系统消息tableviewUITable

local messageListBeforSplitData = {} --分割前数据集合
local messageListData = {} --信息列表
local MsgPageIndex = 1;--消息的当前第几页
local MsgMaxPaging = 1;--消息的最大分页
local MsgPageCount = 20;--消息的每页条数

local pageFlagNode = nil; --分页标志图
--页底标志的位置
local pageFlagPos = {
	{ 568, 45},--1
	{ 553, 45},--2
	{ 538, 45},--3
	{ 523, 45},--4
	{ 508, 45},--5
};
local pageFlagDis = 30 --分布标志的间隔
local pageFlagList = {} --分页标志集合

local function close()
	hideMsgServerTableView()
	mvcEngine.destroyModule(GUI_MESSAGELIST)
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		GamePub.closeDialogAmin(Panel_11,close)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("MJ_mail.plist"))
	local gui = GUI_MESSAGELIST;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		view = cocostudio.createView("MessageList.json")
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		view = cocostudio.createView("MessageList.json")
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end

end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_list = cocostudio.getUIPanel(view, "Panel_list");
	Panel_11 = cocostudio.getUIPanel(view, "Panel_11");
	btn_back = cocostudio.getUIButton(view, "btn_back");
	Panel_10 = cocostudio.getUIPanel(view, "Panel_10");
	Button_left = cocostudio.getUIButton(view, "Button_left");
	Button_right = cocostudio.getUIButton(view, "Button_right");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();
	sendMAIL_SYSTEM_MESSGE_LIST(0,100)
	GamePub.showDialogAmin(Panel_11)
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
	if MsgMaxPaging == 1 or MsgMaxPaging > #pageFlagPos then
		--默认数据为100行，即是5页
		return
	end
	local beginPosX = pageFlagPos[MsgMaxPaging][1]
	local beginPosY = pageFlagPos[MsgMaxPaging][2]
	pageFlagNode = CCSprite:create(Common.getResourcePath("px1.png"))
	pageFlagNode:setPosition(ccp(0, 0))
	view:addChild(pageFlagNode)
	for index=1, MsgMaxPaging do
		local spr = CCSprite:createWithSpriteFrameName("MJ_HALL_rank_point_small.png")
		spr:setPosition(beginPosX + (index-1) * pageFlagDis,beginPosY)
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
local function splitMessageListPage()
	MsgPageIndex = 1;
	MsgMaxPaging = 1;
	messageListData = {}

	if messageListBeforSplitData == nil or #messageListBeforSplitData == 0 then
		if pageFlagNode ~= nil then
			pageFlagNode:removeFromParentAndCleanup(true);
			pageFlagNode = nil
		end
		return;
	end

	--分页存储数据
	for i = 1, #messageListBeforSplitData do
		if messageListData[math.ceil(i/MsgPageCount)] == nil then
			messageListData[math.ceil(i/MsgPageCount)] = {}
		end
		messageListData[math.ceil(i/MsgPageCount)][(i-1)%MsgPageCount + 1] = messageListBeforSplitData[i];
	end
	MsgMaxPaging = #messageListData;
	createSplitPageFlag()
end

--展示列表
function showMessageList()
	MsgServerTableViewUITable = {}

	local PanelListSize = Panel_list:getContentSize()
	local PanelListPosX = Panel_list:getPosition().x
	local PanelListPosY = Panel_list:getPosition().y

	local tableSize = 0; --元素数量
	local TableView_X = PanelListPosX - PanelListSize.width / 2; --TableView的左下角X坐标
	local TableView_Y = PanelListPosY - PanelListSize.height / 2; --TableView的左下角Y坐标
	local TableView_W = PanelListSize.width; --TableView的显示宽度
	local TableView_H = PanelListSize.height; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = PanelListSize.width - 10; --每个元素的宽
	local cellHeight = 208; --每个元素的高
	local spacingW = 70; --横向间隔
	local spacingH = 2 --纵向间隔

	if messageListData[MsgPageIndex] == nil or #messageListData[MsgPageIndex] == 0 then
		return
	end

	MsgServerTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	MsgServerTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function MsgServerTableView.initTableViewData()
		--loadCellSize = 0;
		if messageListData[MsgPageIndex] ~= nil and #messageListData[MsgPageIndex] > 0 then
			--接收道具列表物品的数量
			tableSize = #messageListData[MsgPageIndex]
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function MsgServerTableView.getTableViewInfo()
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

	function MsgServerTableView.getCellWidth()
		return cellWidth;--每个元素的宽
	end

	function MsgServerTableView.numberOfrow()
		return rowSize;
	end

	function MsgServerTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight;
	end

	function MsgServerTableView.CellOfAtNumberOfRow(cell, i)
		if i <= #messageListData[MsgPageIndex] then
			i = #messageListData[MsgPageIndex] - i + 1
		end
		local systemMessage = messageListData[MsgPageIndex][i]
		MsgServerTableViewUITable[i] = {}
		--server系统消息
		--消息内容
		local sMessageContent_temp =systemMessage.MessageContent;
		local ContentLength = Common.utfstrlen(sMessageContent_temp)
		local LastMsgContentShort = nil
		if ContentLength > 20 then
			LastMsgContentShort = Common.SubUTF8String(sMessageContent_temp,1,20).."......"
		else
			LastMsgContentShort = sMessageContent_temp
		end
		--消息类型 0：普通消息  1 ：领奖消息   2：执行Action
		local sMessageType = systemMessage.MessageType;
		--消息状态 0：未读  1：已读  2：已领奖
		local sMessageFlag = systemMessage.MessageFlag;
		--消息时间
		local LastMsgTime = systemMessage.CreateTime;
		--消息标题
		local labelName= systemMessage.MessageTitle
		if systemMessage.MessageFlag == 2 then
			labelName = labelName .. "[已领取]"
		end
		local nameLength = Common.utfstrlen(labelName)
		local nameShort = nil
		if nameLength > 10 then
			nameShort = Common.SubUTF8String(labelName,1,10).."......"
		else
			nameShort = labelName
		end

		--头像
		local avatorurl = nil
		if sMessageType == 1 or sMessageType == 3 then
			if sMessageFlag ~= 0 then
				avatorurl = "MJ_btn_yilingqu.png"
			else
				avatorurl = "MJ_btn_liwutubiao.png"
			end
		else
			if sMessageFlag == 0  then
				avatorurl = "MJ_btn_xiaoxitub.png"
			else
				avatorurl = "MJ_btn_yichakanxinxi.png"
			end
		end

		local cellBgStr = nil
		if sMessageFlag == 0  then
			cellBgStr = "MJ_btn_youjiandiban.png"
		else
			cellBgStr = "MJ_btn_youjian_zhezhao.png"
		end

		--父节点layer
		local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
		itemParentNode:setPosition(ccp(TableView_W / 2, cellHeight/2 + spacingH))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)

		--按钮事件
		local function buttonCallBack()
			if(MsgServerTableView.isMoved)then
				return
			end
			--系统消息列表cell点击事件 :param1:消息ID
			if systemMessage.MessageFlag == 0 then
				profileCommon.Message.setSystemMessage_no_ReadCount()
			end
			callSeverCellClicked(systemMessage.MessageId)
		end

		--创建背景图片，用作menu
		--		local pRibbon = GamePub.createPointNineSprite(Common.getResourcePath(cellBgStr), 25, 25, cellWidth, cellHeight-6)
		--		local pRibbon1 = GamePub.createPointNineSprite(Common.getResourcePath(cellBgStr), 25, 25, cellWidth, cellHeight-6)
		local pRibbon = CCSprite:createWithSpriteFrameName(cellBgStr);
		local pRibbon1 = CCSprite:createWithSpriteFrameName(cellBgStr);

		local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
		diSpriteItem:registerScriptTapHandler(buttonCallBack)
		diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))

		local menuCell = CCMenu:create()
		menuCell:setPosition(0, 0)
		menuCell:addChild(diSpriteItem)
		itemParentNode:addChild(menuCell)
		MsgServerTableViewUITable[i] = diSpriteItem;
		diSpriteItem:setScale(0.9)

		--tableview点击监听
		menuCell:setEnabled(false)
		local layerClick = CCLayer:create()
		MsgServerTableViewUITable[i].layerClick = layerClick;
		cell:addChild(layerClick)
		ccTableView.initTableViewClickedListener(1, rowSize - i + 1, itemParentNode, MsgServerTableView, buttonCallBack, layerClick)

--		local logoBg = CCSprite:createWithSpriteFrameName("DN_HALL_mail_btn_magic_golden.png");
--		logoBg:setPosition(ccp(-cellWidth/2+spacingW, 0))
--		itemParentNode:addChild(logoBg)

		--消息标题
		local labelTitle = CCLabelTTF:create(nameShort, "Arial", 40)
		labelTitle:setPosition(ccp(0, 26))
		itemParentNode:addChild(labelTitle)
		MsgServerTableViewUITable[i].labelTitle = labelTitle

		--消息时间
		local labelTime = CCLabelTTF:create(LastMsgTime, "Arial", 20)
		labelTime:setAnchorPoint(ccp(1, 0.5))

		labelTime:setPosition(ccp((cellWidth - spacingW)/2, 0))
		itemParentNode:addChild(labelTime)
		MsgServerTableViewUITable[i].labelTime = labelTime

		--消息内容
		local LabelContent = CCLabelTTF:create(LastMsgContentShort, "Arial", 36)
		LabelContent:setAnchorPoint(ccp(0.5, 0.5))
		LabelContent:setPosition(ccp(0, -26))
		itemParentNode:addChild(LabelContent)
		MsgServerTableViewUITable[i].LabelContent = LabelContent



		--头像
		local imageAvato = CCSprite:createWithSpriteFrameName(avatorurl);
		imageAvato:setPosition(ccp(-cellWidth/2+spacingW+40, 0))
		itemParentNode:addChild(imageAvato)
		MsgServerTableViewUITable[i].imageAvato = imageAvato
		imageAvato:setScale(0.9)

		if sMessageFlag == 0 then
			--未读
			labelTitle:setColor(ccc3(255,255,255))
			labelTime:setColor(ccc3(0xff,0xbe,0x61))
			LabelContent:setColor(ccc3(0xff,0xbe,0x61))
			--添加new 标识
			local imageNew = CCSprite:create(Common.getResourcePath("ui_new.png"))
			imageNew:setAnchorPoint(ccp(0, 0))
			imageNew:setPosition(ccp(-cellWidth/2+spacingW+70, 10))
			itemParentNode:addChild(imageNew)
			MsgServerTableViewUITable[i].imageNew = imageNew
			imageNew:setScale(0.9)
		else
			labelTitle:setColor(ccc3(0xdc,0xa1,0x67))
			labelTime:setColor(ccc3(0xa0,0x72,0x41))
			LabelContent:setColor(ccc3(0xa0,0x72,0x41))
		end

		-- --设置透明度
		-- if sMessageFlag ~= 0 then
		-- 	diSpriteItem:setOpacity(178)
		-- 	labelTime:setOpacity(178)
		-- 	labelTitle:setOpacity(178)
		-- 	LabelContent:setOpacity(178)
		-- 	imageAvato:setOpacity(178)
		-- end

	end
	--	MsgServerTableView:setScaleX(GameConfig.ScaleAbscissa);
	--	MsgServerTableView:setScaleY(GameConfig.ScaleOrdinate);
	view:addChild(MsgServerTableView)
	ccTableView.reloadData(MsgServerTableView)
	if rowSize * cellHeight > TableView_H then
		MsgServerTableView:setContentOffset(ccp(0, -(rowSize * cellHeight - TableView_H) - rowSize*2),false);
	end

end

--隐藏列表
function hideMsgServerTableView()
	if MsgServerTableView ~= nil then
		MsgServerTableView:setVisible(false)
		for i = 1, table.maxn(MsgServerTableViewUITable) do
			if MsgServerTableViewUITable[i].layerClick ~= nil then
				MsgServerTableViewUITable[i].layerClick:setTouchEnabled(false)
			end
		end
	end
end

--[[--
--更新系统站内信 领奖状态
--@param #number MessageID 消息ID
--]]
function updateServerReveiveState(MessageID, type)
	if messageListData[MsgPageIndex] ~= nil then
		for i = 1, #messageListData[MsgPageIndex] do
			if messageListData[MsgPageIndex][i] ~= nil then
				if MessageID == messageListData[MsgPageIndex][i].MessageId then
					--如果是系统消息
					messageListData[MsgPageIndex][i].MessageFlag = type;
					--type :2.已领奖
					if type == 2 then
						messageListData[MsgPageIndex][i].MessageTitle = (messageListData[MsgPageIndex][i].MessageTitle .. "[已领奖]")

						--替换底图
						local menuSprite = MsgServerTableViewUITable[i]
						--保持与tableview的cell 大小相同
						local pRibbon = CCSprite:createWithSpriteFrameName("MJ_btn_youjian_zhezhao.png");
						local pRibbon1 = CCSprite:createWithSpriteFrameName("MJ_btn_youjian_zhezhao.png");

						menuSprite:setNormalImage(pRibbon)
						menuSprite:setSelectedImage(pRibbon1)

						--type :1.已读
					elseif type == 1 then
						messageListData[MsgPageIndex][i].MessageTitle = (messageListData[MsgPageIndex][i].MessageTitle .. "[已读]")
					end
					local titleStr = messageListData[MsgPageIndex][i].MessageTitle
					local nameLength = Common.utfstrlen(titleStr)
					local nameShort = nil
					if nameLength > 10 then
						nameShort = Common.SubUTF8String(titleStr,1,10).."......"
					else
						nameShort = titleStr
					end
					MsgServerTableViewUITable[i].labelTitle:setString(nameShort)
					break;
				end
			end
		end
	end
end

--[[--
--系统消息列表cell点击事件
--@param #Byte MessageID 消息ID
--]]
function callSeverCellClicked(MessageID)
	if messageListData[MsgPageIndex] ~= nil then
		for i = 1, #messageListData[MsgPageIndex] do

			if messageListData[MsgPageIndex][i] ~= nil then
				if MessageID == messageListData[MsgPageIndex][i].MessageId then
					--					local j = #messageListData[MsgPageIndex] - i + 1
					local avatorurl = nil
					local sMessageType = messageListData[MsgPageIndex][i].MessageType
					if sMessageType == 1 or sMessageType == 3 then
						avatorurl = "MJ_btn_yilingqu.png"
					else
						avatorurl = "MJ_btn_yichakanxinxi.png"
					end
					MsgServerTableViewUITable[i].imageAvato:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(avatorurl))
					updateServerReveiveState(MessageId, messageListData[MsgPageIndex][i].MessageFlag);
					--传递该消息的所有相关属性  消息标题，消息内容，消息类型 ，消息状态  动作类  动作参数
					MessageServerLogic.setServerViewNeedParams(messageListData[MsgPageIndex][i].MessageId, messageListData[MsgPageIndex][i].MessageTitle, messageListData[MsgPageIndex][i].MessageContent, messageListData[MsgPageIndex][i].MessageType, messageListData[MsgPageIndex][i].MessageFlag, messageListData[MsgPageIndex][i].Action, messageListData[MsgPageIndex][i].ActionParam)
					mvcEngine.createModule(GUI_MESSAGESERVER)


					--如果是系统消息是未读状态
					if messageListData[MsgPageIndex][i].MessageFlag == 0 then
						--更新消息状态  1：消息类型 2：消息ID
						--						updateSeverImageState(messageListData[MsgPageIndex][i].MessageType, messageListData[MsgPageIndex][i].MessageId);
						sendMAIL_SYSTEM_MESSAGE_READ(messageListData[MsgPageIndex][i].MessageId);
						messageListData[MsgPageIndex][i].MessageFlag = 1;
						-- MsgServerTableViewUITable[i]:setOpacity(178)
						MsgServerTableViewUITable[i].labelTime:setColor(ccc3(0xa0,0x72,0x41))
						MsgServerTableViewUITable[i].labelTitle:setColor(ccc3(0xdc,0xa1,0x67))
						MsgServerTableViewUITable[i].LabelContent:setColor(ccc3(0xa0,0x72,0x41))
						--隐藏new标识
						MsgServerTableViewUITable[i].imageNew:setVisible(false)

						if sMessageType == 0 then
							--替换底图
							local menuSprite = MsgServerTableViewUITable[i]
							--保持与tableview的cell 大小相同
							local pRibbon = CCSprite:createWithSpriteFrameName("MJ_btn_youjian_zhezhao.png");
							local pRibbon1 = CCSprite:createWithSpriteFrameName("MJ_btn_youjian_zhezhao.png");

							menuSprite:setNormalImage(pRibbon)
							menuSprite:setSelectedImage(pRibbon1)

							--							sendMANAGERID_REMOVE_REDP(profile.HongDian.MESSAGE, messageListData[MsgPageIndex][i].MessageId);
						end
					end

					break;
				end
			end
		end
	end
end

--[[--
--设置TableView是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if MsgServerTableView ~= nil then
		MsgServerTableView:setTouchEnabled(Enabled)
		for i = 1, table.maxn(MsgServerTableViewUITable) do
			if MsgServerTableViewUITable[i].layerClick ~= nil then
				MsgServerTableViewUITable[i].layerClick:setTouchEnabled(Enabled);
			end
		end
	end
end

function requestMsg()
	MsgServerTableView = nil
	MsgServerTableViewUITable = {}
end

--刷新TableView
local function refreshTableView()
	if messageListData ~= nil and #messageListData > 0 then
		MsgServerTableViewUITable  = {}
		if MsgServerTableView ~= nil then
			MsgServerTableView:setVisible(true)
			ccTableView.reloadData(MsgServerTableView);
		else
			showMessageList()
		end
		--		Label_noPlayer:setVisible(false)
	else
		if MsgServerTableView ~= nil then
			local container = MsgServerTableView:getChildren():objectAtIndex(0)
			tolua.cast(container,"CCLayer")
			container:removeAllChildrenWithCleanup(true)
		end
		--		Label_noPlayer:setVisible(true)
	end
end

function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GamePub.closeDialogAmin(Panel_11,close)
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
			refreshTableView();
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
			refreshTableView();
			changePageFlag()
		else
			Common.showToast("已经是最后一页", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--显示系统消息列表
local function setSystemMessageList()
	Common.log("setSystemMessageList======")
	messageListBeforSplitData = profileCommon.Message.getSystemMessageTable();
	splitMessageListPage()
	showMessageList()
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("MJ_mail.plist"))
	MsgPageIndex = 1;--消息的当前第几页
	MsgMaxPaging = 1;--消息的最大分页
	pageFlagNode = nil; --分页标志图
	pageFlagList = {} --分页标志集合
	messageListBeforSplitData = {} --分割前数据集合
	messageListData = {}
	sendMANAGERID_REQUEST_REDP(profile.HongDian.getRedPointConstant())
end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(MAIL_SYSTEM_MESSGE_LIST, setSystemMessageList)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(MAIL_SYSTEM_MESSGE_LIST, setSystemMessageList)
end
