module("MahjongChatPopLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_4 = nil;--
Panel_7 = nil;--
ImageView_chat_edit = nil;--
btn_sendmsg_log = nil;--
panel_biaoqing_common = nil;--
panel_common = nil;--
btn_close = nil;--
Panel_chatlog = nil;--

local tableMaleChatCommonText = {}
tableMaleChatCommonText[1] = "大家好,很高兴见到各位"
tableMaleChatCommonText[2] = "快点吧,花开花谢好多回了"
tableMaleChatCommonText[3] = "不好意思,又赢了"
tableMaleChatCommonText[4] = "底裤都要输光了"
tableMaleChatCommonText[5] = "我先走了,后会有期"
tableMaleChatCommonText[6] = "怎么又是你坐庄啊"
tableMaleChatCommonText[7] = "你们这是自寻死路"
tableMaleChatCommonText[8] = "投降吧,算你少输点"
tableMaleChatCommonText[9] = "你敢上,我就敢跟"
tableMaleChatCommonText[10] = "能不能下大点啊"

local tableFeMaleChatCommonText = {}
tableFeMaleChatCommonText[1] = "大家好,很高兴见到各位"
tableFeMaleChatCommonText[2] = "快点吧,花开花谢好多回了"
tableFeMaleChatCommonText[3] = "不好意思,又赢了"
tableFeMaleChatCommonText[4] = "底裤都要输光了"
tableFeMaleChatCommonText[5] = "我先走了,后会有期"
tableFeMaleChatCommonText[6] = "怎么又是你坐庄啊"
tableFeMaleChatCommonText[7] = "你们这是自寻死路"
tableFeMaleChatCommonText[8] = "投降吧,算你少输点"
tableFeMaleChatCommonText[9] = "你敢上,我就敢跟"
tableFeMaleChatCommonText[10] = "能不能下大点啊"

local tableQuickChatCommonText = {}
tableQuickChatCommonText[1] = "快点吧.花谢花开好多回了"
tableQuickChatCommonText[2] = "莫要慌嘛，我在想咋下叫"
tableQuickChatCommonText[3] = "还让不让人摸牌了!"
tableQuickChatCommonText[4] = "打一个来碰噻"
tableQuickChatCommonText[5] = "哎呦！一不小心就胡了"
tableQuickChatCommonText[6] = "你这样以后没朋友"
tableQuickChatCommonText[7] = "哥这把要胡个大的!"
tableQuickChatCommonText[8] = "来来来，要哪张哥打给你们"
tableQuickChatCommonText[9] = "你的牌打得太好了"
tableQuickChatCommonText[10] = "哎呦…我都着你们洗白了"

edit_msg = nil; --聊天输入框
CommonTextTableView = nil --常用语TableView
TextLogTableView = nil --历史信息TableView
emotionTableView = nil --表情按钮TableView
local chatLog = {}--存放聊天记录

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGCHATPOP)
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
--获取快捷聊天语
--@return #table 常用语
--]]
function gettableQuickChatCommonText()
	return tableQuickChatCommonText;
end

--[[--
--获取男性常用语
--@return #table 常用语
--]]
function gettableMaleChatCommonText()
	return tableMaleChatCommonText;
end

--[[--
--获取女性常用语
--@return #table 常用语
--]]
function gettableFeMaleChatCommonText()
	return tableFeMaleChatCommonText;
end

--[[--
--获取聊天记录
--@return #table 聊天记录
--]]
function getChatLog()
	return chatLog;
end

--[[--
--清空聊天记录
--]]
function clearChatList()
	chatLog = {};
end


--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_MAHJONGCHATPOP;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_talk.plist"));
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongChatPop.json"));
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		GameConfig.setCurrentScreenResolution(view, gui, 1920,1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		GameConfig.setCurrentScreenResolution(view, gui, 1920,1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_4 = cocostudio.getUIPanel(view, "Panel_4");
	Panel_7 = cocostudio.getUIPanel(view, "Panel_7");
	ImageView_chat_edit = cocostudio.getUIImageView(view, "ImageView_chat_edit");
	btn_sendmsg_log = cocostudio.getUIButton(view, "btn_sendmsg_log");
	panel_biaoqing_common = cocostudio.getUIPanel(view, "panel_biaoqing_common");
	panel_common = cocostudio.getUIPanel(view, "panel_common");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Panel_chatlog = cocostudio.getUIPanel(view, "Panel_chatlog");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)
	initView();

	--初始化聊天输入框
	initChatEdit()
	--初始化常用聊天与列表
	initCommonTextTableView()
	--初始化历史消息列表
	initTextLogTableView()
	--初始化表情按钮列表
	initEmotionTableView()
end


--初始化历史消息列表
function initTextLogTableView()
	--	local PanelListSize = Panel_chatlog:getContentSize()
	--	local PanelListPosX = Panel_chatlog:getPosition().x
	--	local PanelListPosY = Panel_chatlog:getPosition().y

	local tableSize = 0; --元素数量
	local TableView_X = 1028; --TableView的左下角X坐标
	local TableView_Y = 188; --TableView的左下角Y坐标
	local TableView_W = 816; --TableView的显示宽度
	local TableView_H = 710; --TableView的显示高度

	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 60; --每个元素的高
	local spacingW = 0; --横向间隔
	local spacingH = 2 --纵向间隔

	if chatLog == nil or #chatLog == 0 then
		return
	end

	--	TableView_X = TableView_X - TableView_W * (1 - GameConfig.ScaleAbscissa) / 2
	--	TableView_Y = TableView_Y - TableView_H * (1 - GameConfig.ScaleOrdinate) / 2

	TextLogTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	TextLogTableView:setPosition(TableView_X + TableView_W/2, TableView_Y + TableView_H/2);

	function TextLogTableView.initTableViewData()
		--loadCellSize = 0;
		if chatLog ~= nil and #chatLog > 0 then
			--接收道具列表物品的数量
			tableSize = #chatLog
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function TextLogTableView.getTableViewInfo()
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

	function TextLogTableView.getCellWidth()
		return cellWidth * GameConfig.ScaleAbscissa;--每个元素的宽
	end

	function TextLogTableView.numberOfrow()
		return rowSize;
	end

	function TextLogTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight * GameConfig.ScaleOrdinate;
	end

	function TextLogTableView.CellOfAtNumberOfRow(cell, i)
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

			--父节点layer
			local itemParentNode = CCSprite:create(MahjongTableConfig.getResPath("table0.png"))
			itemParentNode:setPosition(ccp(cellWidth / 2 + (j - 1) * (cellWidth + spacingW), cellHeight / 2))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)

			--按钮事件
			local function buttonCallBack()
				if TextLogTableView.isMoved then
					return
				end
			end

			local textValue = chatLog[index].nickName .. ":" .. chatLog[index].msg

			local labelText = CCLabelTTF:create(textValue, "Arial", 36, CCSizeMake(cellWidth,cellHeight),kCCTextAlignmentLeft)

			local commonTextSize = Common.utfstrlen(textValue)

			labelText:setPosition(ccp(0, 0))

			--			if commonTextSize > 13 then
			--				labelText:setPosition(ccp(cellWidth / 2 - 30, cellHeight / 2 - 10))
			--			else
			--				labelText:setPosition(ccp(cellWidth / 2 - 30, cellHeight / 2 - 20))
			--			end

			itemParentNode:addChild(labelText)

			local layerClick = CCLayer:create()
			cell:addChild(layerClick)
			ccTableView.initTableViewClickedListener(j, i, itemParentNode, TextLogTableView, buttonCallBack, layerClick)

		end
	end

	view:addChild(TextLogTableView)
	ccTableView.reloadData(TextLogTableView)
	TextLogTableView:setContentOffset(ccp(0, 0),false);

end


--初始化常用聊天与列表
function initCommonTextTableView()
	--	local PanelListSize = panel_common:getContentSize()
	--	local PanelListPosX = panel_common:getPosition().x
	--	local PanelListPosY = panel_common:getPosition().y

	local tableSize = 0; --元素数量
	local TableView_X = 0; --TableView的左下角X坐标
	local TableView_Y = 0; --TableView的左下角Y坐标
	local TableView_W = 585; --TableView的显示宽度
	local TableView_H = 960; --TableView的显示高度

	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 148; --每个元素的高
	local spacingW = 2; --横向间隔
	local spacingH = 0 --纵向间隔

	local tableChatCommonText = {}

--	if profile.User.getSelfSex() ~= nil and profile.User.getSelfSex() == MahjongLoadProfile.MahjongUserInfo.MALE or profile.User.getSelfSex() == MahjongLoadProfile.MahjongUserInfo.SECRECY then
--		tableChatCommonText = tableMaleChatCommonText
--	else
--		tableChatCommonText = tableFeMaleChatCommonText
--	end
	tableChatCommonText = tableQuickChatCommonText;

	if tableChatCommonText == nil or #tableChatCommonText == 0 then
		return
	end

	--	TableView_X = TableView_X - TableView_W * (1 - GameConfig.ScaleAbscissa) / 2
	--	TableView_Y = TableView_Y - TableView_H * (1 - GameConfig.ScaleOrdinate) / 2
	CommonTextTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	CommonTextTableView:setPosition(TableView_X + TableView_W/2, TableView_Y + TableView_H/2);

	function CommonTextTableView.initTableViewData()
		--loadCellSize = 0;
		if tableChatCommonText ~= nil and #tableChatCommonText > 0 then
			--接收道具列表物品的数量
			tableSize = #tableChatCommonText
			--计算一共多少行
			rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
			--计算一共多少列
			--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		end
	end

	function CommonTextTableView.getTableViewInfo()
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

	function CommonTextTableView.getCellWidth()
		return cellWidth * GameConfig.ScaleAbscissa;--每个元素的宽
	end

	function CommonTextTableView.numberOfrow()
		return rowSize;
	end

	function CommonTextTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight * GameConfig.ScaleOrdinate;
	end

	function CommonTextTableView.CellOfAtNumberOfRow(cell, i)
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

			--父节点layer
			local itemParentNode = CCSprite:createWithSpriteFrameName("MJ_btn_liaotianneirong_nor.png")
			itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)

			--按钮事件
			local function buttonCallBack()
				if CommonTextTableView.isMoved then
					return
				end

				if tableChatCommonText[index] ~= nil then
					sendChatEmotion(MahjongTableConfig.TYPE_CHAT_TEXT,tableChatCommonText[index])
				end

			end

			local labelText = CCLabelTTF:create(tableChatCommonText[index], "Arial", 36, CCSizeMake(itemParentNode:getContentSize().width - 10,itemParentNode:getContentSize().height - 20),kCCTextAlignmentLeft)

			labelText:setPosition(ccp(cellWidth / 2 + 30, cellHeight/2 - 43))
			labelText:setColor(ccc3(0xff,0xef,0xa6))
			labelText:setAnchorPoint(ccp(0.5, 0.5))
			itemParentNode:addChild(labelText)

			local layerClick = CCLayer:create()
			cell:addChild(layerClick)
			ccTableView.initTableViewClickedListener(j, i, itemParentNode, CommonTextTableView, buttonCallBack, layerClick)

		end
	end

	view:addChild(CommonTextTableView)
	ccTableView.reloadData(CommonTextTableView)

end

--初始化聊天输入框
function initChatEdit()
	Common.log("initChatEdit " .. ImageView_chat_edit:getContentSize().width .. ";" .. ImageView_chat_edit:getContentSize().height)
	--	local editBoxSize = CCSizeMake(ImageView_chat_edit:getContentSize().width, ImageView_chat_edit:getContentSize().height)
	local editBoxSize = CCSizeMake(620, 100)
	--名字输入框
	edit_msg = CCEditBox:create(editBoxSize, CCScale9Sprite:create(MahjongTableConfig.getResPath("table0.png")))
	edit_msg:setPosition(ccp(1338, 105))
	edit_msg:setAnchorPoint(ccp(0.5, 0.5))

	edit_msg:setFont("微软雅黑", 36)
	edit_msg:setFontColor(ccc3(0x00, 0x00, 0x00))
	edit_msg:setPlaceHolder("")
	edit_msg:setMaxLength(32)
	edit_msg:setReturnType(kKeyboardReturnTypeDone)
	edit_msg:setInputMode(kEditBoxInputModeSingleLine);

	edit_msg:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle);
	view:addChild(edit_msg)
end

--初始化表情按钮列表
function initEmotionTableView()
	local tableSize = 0; --元素数量
	local TableView_X = 620; --TableView的左下角X坐标
	local TableView_Y = 3; --TableView的左下角Y坐标
	local TableView_W = 318; --TableView的显示宽度
	local TableView_H = 960; --TableView的显示高度

	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 132; --每个元素的高
	local spacingW = 0; --横向间隔
	local spacingH = 0 --纵向间隔

	TableView_X = TableView_X - TableView_W * (1 - GameConfig.ScaleAbscissa) / 2
	TableView_Y = TableView_Y - TableView_H * (1 - GameConfig.ScaleOrdinate) / 2
	emotionTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	emotionTableView:setPosition(TableView_X + TableView_W/2, TableView_Y + TableView_H/2);

	function emotionTableView.initTableViewData()
		--		if tableChatCommonText ~= nil and #tableChatCommonText > 0 then
		--接收道具列表物品的数量
		tableSize = 7
		--计算一共多少行
		rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)
		--计算一共多少列
		--columnSize = math.floor((tableSize + (rowSize - 1)) / rowSize)
		--		end
	end

	function emotionTableView.getTableViewInfo()
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

	function emotionTableView.getCellWidth()
		return cellWidth;--每个元素的宽
	end

	function emotionTableView.numberOfrow()
		return rowSize;
	end

	function emotionTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight;
	end

	function emotionTableView.CellOfAtNumberOfRow(cell, i)
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

			--父节点layer
			local itemParentNode = CCSprite:create(MahjongTableConfig.getResPath("table0.png"))
			itemParentNode:setPosition(ccp(cellWidth / 2 + (j - 1) * (cellWidth + spacingW), cellHeight / 2))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)

			local tempIndex = (index - 1) * 2 + 1;
			local tempIndexR = (index - 1) * 2 + 2;

			--按钮事件
			local function buttonCallBack()
				if emotionTableView.isMoved then
					return
				end
			end
			local function emotionLeft()
				if emotionTableView.isMoved then
					return
				end
				Common.log("emotionLeft emotionLeft index "..index.."tempInd == "..tempIndex)
				sendChatEmotion(MahjongTableConfig.TYPE_CHAT_EMOTION,tempIndex)
			end
			local function emotionRight()
				if emotionTableView.isMoved then
					return
				end
				Common.log("emotionRight emotionRight index "..index.." tempIndR == "..tempIndexR)
				sendChatEmotion(MahjongTableConfig.TYPE_CHAT_EMOTION,tempIndexR)
			end

			local emotionName = "MJ_ingame_talk_ordinary_face_"..tempIndex..".png"
			local pRibbon = CCSprite:createWithSpriteFrameName(emotionName)
			local pRibbon1 = CCSprite:createWithSpriteFrameName(emotionName)
			local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
			diSpriteItem:registerScriptTapHandler(emotionLeft)
			diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))
			diSpriteItem:setPosition(-cellWidth*0.25, 0)
			local menuCell = CCMenu:create()
			menuCell:setPosition(0, 0)
			menuCell:setAnchorPoint(ccp(0.5, 0.5))
			menuCell:addChild(diSpriteItem)
			itemParentNode:addChild(menuCell)


			emotionName = "MJ_ingame_talk_ordinary_face_"..tempIndexR..".png"
			local pRibbonR = CCSprite:createWithSpriteFrameName(emotionName)
			local pRibbon1R = CCSprite:createWithSpriteFrameName(emotionName)
			local diSpriteItemR = CCMenuItemSprite:create(pRibbonR, pRibbon1R, nil)
			diSpriteItemR:registerScriptTapHandler(emotionRight)
			diSpriteItemR:setAnchorPoint(ccp(0.5, 0.5))
			diSpriteItemR:setPosition(cellWidth*0.25, 0)
			local menuCellR = CCMenu:create()
			menuCellR:setPosition(0, 0)
			menuCellR:setAnchorPoint(ccp(0.5, 0.5))
			menuCellR:addChild(diSpriteItemR)
			itemParentNode:addChild(menuCellR)

			--			local layerClick = CCLayer:create()
			--			cell:addChild(layerClick)
			--			ccTableView.initTableViewClickedListener(j, i, itemParentNode, emotionTableView, buttonCallBack, layerClick)

		end
	end
	view:addChild(emotionTableView)
	ccTableView.reloadData(emotionTableView)

end

function requestMsg()

end


--发送聊天信息
function sendChatEmotion(type,msg)
	sendMJ_SC_ROOM_CHAT(type,""..msg)
	close()
end

function callback_btn_sendmsg_log(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local sendChat = edit_msg:getText()
		if (sendChat ~= "") then
			sendChatEmotion(MahjongTableConfig.TYPE_CHAT_TEXT,sendChat)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
