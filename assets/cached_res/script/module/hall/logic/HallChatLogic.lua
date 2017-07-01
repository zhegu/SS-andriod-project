module("HallChatLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_tableView = nil;--
Panel_dialog = nil;--
hall_chat_dimiss_btn = nil;--
Panel_16 = nil;--
hall_chat_edit_bg = nil;--
hall_chat_send_bg = nil;--
Button_bugle = nil;--

isSystemMessage = false
isBugleMessage = false
systemMessage = nil
bugleMessage = nil

local chatTextTable = {} -- 聊天记录
local chatMaxCount = 30 -- 聊天最大条数

local isChatViewShowing = false -- 聊天框是否在显示中
local TextHeight = 33; --一行文本的高度
local fontSize = 25 --消息内容的字号
ChatRecordTableView = nil; --聊天tableview
ChatRecordTableViewUITable = nil; --聊天tableviewUITable

local isEnterLuckyGame = false; --进入小游戏列表

local function close()
	mvcEngine.destroyModule(GUI_HALLCHAT)
end


function onKeypad(event)
	if event == "backClicked" then
		--返回键
		closeChatPanel()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
--	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("home_chat.plist"))
	local gui = GUI_HALLCHAT;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("HallChat.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("HallChat.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_tableView = cocostudio.getUIPanel(view, "Panel_tableView");
	Panel_dialog = cocostudio.getUIPanel(view, "Panel_dialog");
	hall_chat_dimiss_btn = cocostudio.getUIButton(view, "hall_chat_dimiss_btn");
	Panel_16 = cocostudio.getUIPanel(view, "Panel_16");
	hall_chat_edit_bg = cocostudio.getUIImageView(view, "hall_chat_edit_bg");
	hall_chat_send_bg = cocostudio.getUIButton(view, "hall_chat_send_bg");
	Button_bugle = cocostudio.getUIButton(view, "Button_bugle");
end


local function initChatInputBox()
	local editBoxSize = CCSizeMake(400, 70)
	edit_hall_chat = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("px1.png")))

	edit_hall_chat:setPosition(ccp(419, 58))
	edit_hall_chat:setAnchorPoint(ccp(0.5, 0.5))
	edit_hall_chat:setFont("微软雅黑", 30)
	edit_hall_chat:setFontColor(ccc3(178, 62, 100))
	edit_hall_chat:setPlaceHolder("每次发言将消耗30魅力值")
	edit_hall_chat:setPlaceholderFontColor(ccc3(178, 62, 100))
	edit_hall_chat:setReturnType(kKeyboardReturnTypeDone);
	edit_hall_chat:setInputMode(kEditBoxInputModeSingleLine);
	edit_hall_chat:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle);
	view:addChild(edit_hall_chat, 10)
end

--获取聊天数据
local function getChatData()
	local chatTableSize = #chatTextTable
	if (chatTableSize ~= 0) then
		showChatRecordTableView()
	else
		sendEnterChatRoom()
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
	GamePub.showDialogAmin(Panel_dialog,false,getChatData)

	isChatViewShowing = true
	initChatInputBox()
	isSystemMessage = false
end

function requestMsg()

end

--未解锁小游戏时，进入小游戏列表
function unlockEnterLuckyGame()
	callback_hall_chat_dimiss_btn(RELEASE_UP)
	isEnterLuckyGame = true
end

--登录初始化调用了
function initAllChatData()
	clearChatText()
end

--[[发送进入聊天室]]
function sendEnterChatRoom()
	local dataTable = {}
	dataTable["NickName"] = profile.User.getSelfNickName()
	dataTable["IsFirstEnter"] = 1
	dataTable["ChatRoomName"] = ""
	Common.log("发送进入聊天室"..profile.User.getSelfNickName())
	sendIMID_ENTER_CHAT_ROOM(dataTable);
end

--[[得到聊天信息并且加入列表中]]
local function getAndSaveNewChatTable()
	local chatTable = nil
	if(isSystemMessage)then
		chatTable = systemMessage
	elseif (isBugleMessage) then
		chatTable = bugleMessage
	else
		chatTable = profile.IM.getUserChatTable()
	end
	local chatTableSize = #chatTextTable
	if (chatTableSize >= chatMaxCount) then
		table.remove(chatTextTable, 1)
	end
	table.insert(chatTextTable, chatTable)
	return chatTable
end


--[[把得到的聊天消息加入list]]
function addChatToList()
	if (isChatViewShowing == true) then
		local chatTable = getAndSaveNewChatTable()
		showChatRecordTableView()
	else
		getAndSaveNewChatTable()
	end
end

--[[--
--设置TableView是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if ChatRecordTableView ~= nil then
		ChatRecordTableView:setTouchEnabled(Enabled)
		for i = 1, table.maxn(ChatRecordTableViewUITable) do
			if ChatRecordTableViewUITable[i] ~= nil then
				ChatRecordTableViewUITable[i]:setEnabled(Enabled);
			end
		end
	end
	if edit_hall_chat ~= nil then
		edit_hall_chat:setTouchEnabled(Enabled);
	end
end

--隐藏tableview
function hideChatRecordTableView()
	if ChatRecordTableView ~= nil and ChatRecordTableView ~= "" then
		ChatRecordTableView:setVisible(false)
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
		setAllMenuEnabled(ChatRecordTableView:isTouchEnabled());
	else
		createChatRecordTableView();
	end
end

function createChatRecordTableView()

	if chatTextTable == nil or #chatTextTable == 0 then
		return
	end
	local tableSize = 0; --元素数量
	local TableView_X = 226; --TableView的左下角X坐标
	local TableView_Y = 108; --TableView的左下角Y坐标
	local TableView_W = 680; --TableView的显示宽度
	local TableView_H = 410; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = 680; --每个元素的宽
	local cellHeight = 40; --每个元素的高
	local spacingW = 50; --横向间隔
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
		if type(numVipLevel) == "string" and numVipLevel == "S_VIP" then
			if chatTextTable[i]["ActionId"] ~= nil and chatTextTable[i]["ActionId"] ~= 0 then
				chatText = "[等级：[#" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"] .. "  点这里强势进入!"
			else
				chatText = "[等级：[#" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"]
			end
		else
			if numVipLevel > 0 then
				if chatTextTable[i]["ActionId"] ~= nil and chatTextTable[i]["ActionId"] ~= 0 then
					chatText = "[等级：" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"] .. "  点这里强势进入!"
				else
					chatText = "[等级：" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"]
				end
			else
				if chatTextTable[i]["ActionId"] ~= nil and chatTextTable[i]["ActionId"] ~= 0 then
					chatText = "[" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"] .. "  点这里强势进入!"
				else
					chatText = "[" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"]
				end
			end

		end
		local txtLength = Common.getFontStringLen(chatText, fontSize);
		local heightNum = txtLength / (cellWidth - 10) + 1
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
		if type(numVipLevel) == "string" and numVipLevel == "S_VIP" then
			--SVIP
			if chatTextTable[i]["ActionId"] ~= nil and chatTextTable[i]["ActionId"] ~= 0 then
				chatText = "[等级：[#" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"] .. "  点这里强势进入!"
				actionId = chatTextTable[i]["ActionId"]
			else
				chatText = "[等级：[#" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"]
			end
		else
			if numVipLevel > 0 then
				if chatTextTable[i]["ActionId"] ~= nil and chatTextTable[i]["ActionId"] ~= 0 then
					chatText = "[等级：" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"] .. "  点这里强势进入!"
					actionId = chatTextTable[i]["ActionId"]
				else
					chatText = "[等级：" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"]
				end
			else
				if chatTextTable[i]["ActionId"] ~= nil and chatTextTable[i]["ActionId"] ~= 0 then
					chatText = "[" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"] .. "  点这里强势进入!"
					actionId = chatTextTable[i]["ActionId"]
				else
					chatText = "[" .. chatTextTable[i]["SpeakerNickName"] .. "]：" .. chatTextTable[i]["SpeechText"]
				end
			end
		end
		local txtLength = Common.getFontStringLen(chatText, fontSize);
		local heightNum = txtLength / (cellWidth - 10) + 1
		cellHeight = heightNum * TextHeight

		--按钮事件
		local function buttonCallBack()
			if(ChatRecordTableView.isMoved)then
				return
			end
			Common.log("hallchat buttonCallBack chatType " .. chatTextTable[i]["chatType"])
			if chatTextTable[i]["chatType"] == profile.IM.TYPE_TWO_MINI_GAME then
				--通过ActionId，判断是否为同趣小妹跳转小游戏ID
				if chatTextTable[i]["ActionParam"] == 1 then
					GameLoadModuleConfig.startMiniGameByID(actionId);
				elseif chatTextTable[i]["ActionParam"] == 2 then
					Common.showToast("您还没有解锁该游戏",2)
					unlockEnterLuckyGame()
				elseif chatTextTable[i]["ActionParam"] == 3 then
					Common.showToast("您的金币不足",2)
				end
			elseif chatTextTable[i]["chatType"] == profile.IM.TYPE_ONE_COMMON then
				local SpeakerUserID = chatTextTable[i]["SpeakerUserID"]
				if(SpeakerUserID ~= 0)then
					mvcEngine.createModule(GUI_NIUNIUTABLEUSERINFO);
					NiuNiuTableUserInfoLogic.setPlayerUserID(tonumber(chatTextTable[i]["SpeakerUserID"]));
					NiuNiuTableUserInfoLogic.shieldMofa()
				end
			end

		end

		--父节点layer
		local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
		itemParentNode:setPosition(ccp(0, cellHeight/2 - 13))
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

		--vipIcon
		if type(numVipLevel) == "string" and numVipLevel == "S_VIP" then
			local vipIcon = CCSprite:create(Common.getResourcePath("ic_svip.png"))
			vipIcon:setAnchorPoint(ccp(0, 1))
			vipIcon:setPosition(ccp(7, cellHeight/2 + 18));
			vipIcon:setZOrder(2);
			itemParentNode:addChild(vipIcon)
		else
			if numVipLevel > 0 then
				local vipIcon = CCSprite:create(Common.getResourcePath("hall_vip_icon.png"))
				vipIcon:setAnchorPoint(ccp(0, 1))
				vipIcon:setPosition(ccp(5, cellHeight/2 + 18));
				vipIcon:setZOrder(2);
				itemParentNode:addChild(vipIcon)

				--vip等级数字
				local vipNum = CCSprite:create(Common.getResourcePath("num_vip_level.png"),CCRectMake(numVipLevel * 21, 0, 21, 27))
				vipNum:setAnchorPoint(ccp(0, 1))
				vipNum:setPosition(ccp(61, cellHeight/2 + 12));
				vipNum:setZOrder(3);
				itemParentNode:addChild(vipNum)
			end
		end

		--消息内容
		local LabelContent = CCLabelTTF:create(chatText, "Arial", fontSize, CCSizeMake (cellWidth-10, cellHeight), kCCTextAlignmentLeft)
		LabelContent:setAnchorPoint(ccp(0, 1))
		LabelContent:setPosition(ccp(0, cellHeight/2))
		itemParentNode:addChild(LabelContent)
		if actionId ~= nil and actionId ~= 0 then
			LabelContent:setColor(ccc3(228, 78, 63))
		else
			LabelContent:setColor(ccc3(chatTextTable[i]["ARGB1"], chatTextTable[i]["ARGB2"], chatTextTable[i]["ARGB3"]))
		end


	end
	view:addChild(ChatRecordTableView)
	ccTableView.reloadData(ChatRecordTableView)
	ChatRecordTableView:setContentOffset(ccp(0, 0),false);
end

--关闭聊天框
function closeChatPanel()
	hideChatRecordTableView()
	if(isEnterLuckyGame)then
		isEnterLuckyGame = false
	end
	GamePub.closeDialogAmin(Panel_dialog, close)
end

function callback_hall_chat_dimiss_btn(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		closeChatPanel()
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_hall_chat_send_bg(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		Common.setUmengUserDefinedInfo("hall_btn_click", "聊天-提交")
		notSendText = ""
		local sendChat = edit_hall_chat:getText()
		if (sendChat ~= "") then
			Common.log("sendChat=="..sendChat)
			sendIMID_CHAT_ROOM_SPEAK(sendChat)
			edit_hall_chat:setText("");
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_bugle(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local sendChat = edit_hall_chat:getText()
		if (sendChat ~= nil and sendChat ~= "") then
			sendOPERID_MGR_SEND_BUGLE(sendChat)
			edit_hall_chat:setText("");
		else
			Common.showToast("请输入内容",3)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end


function getIMID_OPERATE_CHAT_USER_TYPEInfo()
	local dataTable = profile.IM.getIMID_OPERATE_CHAT_USER_TYPETable()
	local chatTable = {}
	chatTable["chatType"] = profile.IM.TYPE_ONE_COMMON
	chatTable["SpeakerNickName"] = "系统公告"
	chatTable["SpeakerUserID"] = 0
	chatTable["SpeechText"] = dataTable["resultMsg"]
	chatTable["ARGB1"] = 228
	chatTable["ARGB2"] = 78
	chatTable["ARGB3"] = 63
	chatTable["VipLevel"] = 0;
	isSystemMessage = true
	systemMessage = chatTable
	addChatToList()
	isSystemMessage = false
	CommDialogConfig.closeProgressDialog()
end

--使用大喇叭
local function slot_OPERID_MGR_SEND_BUGLE()
	local SendBugleTable = GameCommonProfile.GameCommon.getSendBugleTable()
	if SendBugleTable == nil then
		return
	end
	--	if SendBugleTable["Result"] == 1 then
	--		--成功
	--		closeChatPanel()
	--	end
	if SendBugleTable["Message"] ~= nil then
		Common.showToast(SendBugleTable["Message"],3)
	end
end
--大喇叭广播
local function slot_OPERID_SEND_ALL_BUGLE()
	local BugleTable =  GameCommonProfile.GameCommon.getBugleTable()
	if BugleTable ~= nil and #BugleTable > 0 then
		local chatTable = {}
		chatTable["chatType"] = profile.IM.TYPE_ONE_COMMON
		chatTable["SpeakerNickName"] = BugleTable[#BugleTable].NickName
		chatTable["SpeakerUserID"] = 0
		chatTable["SpeechText"] = BugleTable[#BugleTable].Message
		chatTable["ARGB1"] = 126
		chatTable["ARGB2"] = 165
		chatTable["ARGB3"] = 255
		chatTable["VipLevel"] = 0;
		isBugleMessage = true
		bugleMessage = chatTable
		addChatToList()
		isBugleMessage = false
		CommDialogConfig.closeProgressDialog()
	end
end

function clearChatText()
	chatTextTable = {}
	if ChatRecordTableView ~= nil then
		for i = 1, table.maxn(ChatRecordTableViewUITable) do
			if ChatRecordTableViewUITable[i] ~= nil then
				ChatRecordTableViewUITable[i]:removeFromParentAndCleanup(true)
				ChatRecordTableViewUITable[i] = nil
			end
		end
		ChatRecordTableView:removeFromParentAndCleanup(true)
	end
	ChatRecordTableView = nil
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
--	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("home_chat.plist"))

	--	clearChatText()
	isChatViewShowing = false
	--	HallLogic.btn_show_chat:setVisible(true);

	chatMaxCount = 30 -- 聊天最大条数
	TextHeight = 33; --一行文本的高度
	isEnterLuckyGame = false; --进入小游戏列表
	fontSize = 25 --消息内容的字号
end

function addSlot()
	framework.addSlot2Signal(IMID_OPERATE_CHAT_USER_TYPE, getIMID_OPERATE_CHAT_USER_TYPEInfo)
	framework.addSlot2Signal(OPERID_MGR_SEND_BUGLE, slot_OPERID_MGR_SEND_BUGLE) --发送大喇叭
	framework.addSlot2Signal(OPERID_SEND_ALL_BUGLE, slot_OPERID_SEND_ALL_BUGLE) --大喇叭广播
end

function removeSlot()
	framework.removeSlotFromSignal(IMID_OPERATE_CHAT_USER_TYPE, getIMID_OPERATE_CHAT_USER_TYPEInfo)
	framework.removeSlotFromSignal(OPERID_MGR_SEND_BUGLE, slot_OPERID_MGR_SEND_BUGLE) --发送大喇叭
	framework.removeSlotFromSignal(OPERID_SEND_ALL_BUGLE, slot_OPERID_SEND_ALL_BUGLE)  --大喇叭广播
end
