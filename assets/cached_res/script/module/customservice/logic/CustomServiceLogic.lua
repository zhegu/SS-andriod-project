module("CustomServiceLogic",package.seeall)


view = nil
local scene = nil
local viewShowTag = 1--显示tab
local ConversationID = -1--回话id
local PageSize = 10--显示数量
local PageStartID = 0
--控件
--btn_back = nil--返回键
--btn_send = nil--发送键
--lab_userid = nil--用户id
--panel_fankui = nil--
--messagelistScrollView = nil
--txt_sendmsg = nil --发送消息输入框(用于输入)
--label_sendmsg = nil --发送消息输入框(用于输入)

panel_main = nil;--
btn_back = nil;--
Panel_fankui = nil;--
scroll_msglist = nil;--
Panel_15 = nil;--
lab_userid = nil;--
btn_send = nil;--
txt_sendmsg = nil;--
label_sendmsg = nil;--
ImageView_44 = nil


--动态添加数据
local ShowMessageContent = {}
local MessageContent = {}
--全局变量
local size = nil
local useravator = nil --个人头像在本地的地址
--菜单
local menuTable = {};--菜单table

local tab = nil --当前的tab

local leftMargin = 50 --左边和右边的间距
local cellWidth = 0  --每个元素的宽
local cellHeight = 100 --每个元素的高
local lieSize = 1 --列数
local spacingW = 0 --横向间隔
local spacingH = 10 --纵向间隔
local avatorWidth = 77 --头像的大小

local viewW = 0
local viewHMax = 450
local viewH = 0
local viewX = 0
local viewY = 100

local ImageOffXY = 10 --字体和背景图的间距
local MYSELF = 0; --发消息的人是自己
local FRIEND = 1; --发消息的人是聊天列表的好友
local TextHeight = 38; --一行文本的高度
local oneFontWidth = 38; --一个字的宽度为33
ChatRecordTableView = nil; --聊天tableview
local ChatRecordTableViewUITable = nil; --聊天tableviewUITable

edit_sendMsg = nil;

local function close()
	mvcEngine.destroyModule(GUI_CUSTOMSERVICE)
end

function onKeypad(event)
	if event == "backClicked" then
		close()
	elseif event == "menuClicked" then
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("CustomService.json")
	local gui = GUI_CUSTOMSERVICE
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view);
	size = CCDirector:sharedDirector():getWinSize()
	initView()

	useravator = Common.getDataForSqlite(CommSqliteConfig.SelfAvatorInSD..profile.User.getSelfUserID())

	local function delaySentMessage()
		--请求消息
		sendDBID_V2_GET_CONVERSATION(ConversationID, PageSize, PageStartID)
	end

	GamePub.runSenceAction(view,delaySentMessage,false)
	createSendMsgEditor()
end

function initView()
	panel_main = cocostudio.getUIPanel(view, "panel_main");
	btn_back = cocostudio.getUIButton(view, "btn_back");
	Panel_fankui = cocostudio.getUIPanel(view, "Panel_fankui");
	scroll_msglist = cocostudio.getUIScrollView(view, "scroll_msglist");
	Panel_15 = cocostudio.getUIPanel(view, "Panel_15");
	lab_userid = cocostudio.getUILabel(view, "lab_userid");
	btn_send = cocostudio.getUIButton(view, "btn_send");
	txt_sendmsg = cocostudio.getUITextField(view, "txt_sendmsg");
	label_sendmsg = cocostudio.getUILabel(view, "Label_sendmsg");
	ImageView_44 = cocostudio.getUIImageView(view, "ImageView_44")

	--	btn_back = cocostudio.getUIButton(view, "btn_back")
	--	btn_send = cocostudio.getUIButton(view, "btn_send")
	--	lab_userid = cocostudio.getUILabel(view,"lab_userid")
	--	panel_fankui = cocostudio.getUITextField(view, "Panel_fankui")
	--	messagelistScrollView = cocostudio.getUIScrollView(view, "scroll_msglist")
	--	txt_sendmsg = cocostudio.getUITextField(view, "txt_sendmsg")
	txt_sendmsg:setVisible(false);
	txt_sendmsg:setTouchEnabled(false)
	--	label_sendmsg = cocostudio.getUILabel(view, "Label_sendmsg")
	label_sendmsg:setVisible(false);
	--初始化
	if #MessageContent == 0 then
		CommDialogConfig.showProgressDialog("数据加载中,请稍后...")
	end
	--初始化界面信息
	lab_userid:setText("ID:"..profile.User.getSelfUserID())
	cellWidth = (size.width-leftMargin*2)/2 -10
	viewW = size.width-100
	viewY = 100
end

function createSendMsgEditor()

	local editBoxSize = CCSizeMake(1200 * GameConfig.ScaleAbscissa, 70)
	--信息输入框
	edit_sendMsg = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
	edit_sendMsg:setAnchorPoint(ccp(0, 0.5))
	edit_sendMsg:setPosition(ccp(424, 81))
	edit_sendMsg:setFont("微软雅黑", 38)
	edit_sendMsg:setFontColor(ccc3(0xc4, 0x88, 0x57))
	edit_sendMsg:setReturnType(kKeyboardReturnTypeDone)
	edit_sendMsg:setInputMode(kEditBoxInputModeSingleLine);
	edit_sendMsg:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	view:addChild(edit_sendMsg)
end

function requestMsg()

end

--返回
function callback_btn_back(component)
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
--更新头像的图片
--]]
local function updataHeadImage(path)
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
	if photoPath ~= nil and photoPath ~= "" and ChatRecordTableViewUITable[id] and ChatRecordTableViewUITable[id].imageAvato ~= nil then
		local texture = CCTextureCache:sharedTextureCache():addImage(photoPath)
		if texture ~= nil then
			ChatRecordTableViewUITable[id].imageAvato:setTexture(texture)--刷新icon
			-- ChatRecordTableViewUITable[id].imageAvato:setTextureRect(CCRectMake(0, 0, texture:getPixelsWide (), texture:getPixelsHigh ()))
			-- ChatRecordTableViewUITable[id].imageAvato:setScale(0.8)
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
	else
		createChatRecordTableView();
	end
end

function createChatRecordTableView()
	ChatRecordTableViewUITable = {}
	if ShowMessageContent == nil or #ShowMessageContent == 0 then
		return
	end

	local PanelListSize = Panel_fankui:getContentSize()
	local PanelListPosX = Panel_fankui:getPosition().x
	local PanelListPosY = Panel_fankui:getPosition().y
	local tableSize = 0; --元素数量
	local TableView_X = PanelListPosX - PanelListSize.width / 2; --TableView的左下角X坐标
	local TableView_Y = PanelListPosY - PanelListSize.height / 2; --TableView的左下角Y坐标
	local TableView_W = Panel_fankui:getContentSize().width; --TableView的显示宽度
	local TableView_H = Panel_fankui:getContentSize().height; --TableView的显示高度
	local rowSize = 0; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 1; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local cellWidth = TableView_W; --每个元素的宽
	local cellHeight = 130; --每个元素的高
	local spacingW = 70; --横向间隔
	local spacingH = 20 --纵向间隔


	ChatRecordTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionVertical);
	ChatRecordTableView:setPosition(TableView_X + TableView_W, TableView_Y + TableView_H);

	function ChatRecordTableView.initTableViewData()
		if ShowMessageContent ~= nil and #ShowMessageContent > 0 then
			--接收道具列表物品的数量
			tableSize = #ShowMessageContent
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
		if i <= #ShowMessageContent then
			i = #ShowMessageContent - i + 1
		end
		--获取消息内容
		local messageContent = ShowMessageContent[i].Content;
		--获取消息内容的字数
		-- local textNum = Common.utfstrlen(messageContent);
		--计算消息气泡的宽度和高度
		local messagePropertyTable = caculateMessageWidth(messageContent);
		local contentHeight = messagePropertyTable.contentHeight;
		--将要新添的消息内容和加上时间条的的总高度
		--将要新添的消息内容和加上时间条的的总高度
		cellHeight = contentHeight + 150;
		if cellHeight < 200 then
			cellHeight = 200
		end
		return cellHeight;
	end

	function ChatRecordTableView.getCellWidth()
		return cellWidth;--每个元素的宽
	end

	function ChatRecordTableView.CellOfAtNumberOfRow(cell, i)
		if i <= #ShowMessageContent then
			i = #ShowMessageContent - i + 1
		end
		ChatRecordTableViewUITable[i] = {}

		--坐标标记，用于设置坐标，元素在左边positionFlag为-1，否则为1 positionWidth为cellwidth
		local positionFlag = 1
		local positionWidth = 0
		--默认头像
		local defaultAvatoImage = nil
		--头像
		local PhotoUrl = nil
		--获取消息产生的时间
		local creatTime = ShowMessageContent[i].CreateTime;
		--获取消息内容
		local messageContent = ShowMessageContent[i].Content;
		--发送消息的人
		local sender = ShowMessageContent[i].Sender;
		--获取消息内容的字数
		-- local textNum = Common.utfstrlen(messageContent);
		local contentPanelWidth = 0;
		local contentHeight = 0;
		--计算消息气泡的宽度和高度
		local messagePropertyTable = caculateMessageWidth(messageContent);
		contentPanelWidth = messagePropertyTable.contentPanelWidth;
		contentHeight = messagePropertyTable.contentHeight;
		--将要新添的消息内容和加上时间条的的总高度
		-- cellHeight = contentHeight + 30;

		--父节点layer
		local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
		itemParentNode:setPosition(ccp(0, cellHeight/2 - spacingH))
		itemParentNode:setCascadeOpacityEnabled(true);
		itemParentNode:setZOrder(10);
		cell:addChild(itemParentNode)

		local m_w = contentPanelWidth+ 80
		if m_w < 140 then
			m_w = 140
		end
		local m_h = contentHeight+ 40
		if m_h < 80 then
			m_h = 80
		end

		--气泡背景
		local chatImageBgSprite = nil;
		if sender == MYSELF then
			defaultAvatoImage = "zp_default_avatar.png"
			positionFlag = 1
			positionWidth = cellWidth
			PhotoUrl = profile.User.getSelfPhotoUrl()
			chatImageBgSprite = GamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("MJ_fankui_btn_liaotianqipao_right.png"), 12, 30, 30, 12, m_w, m_h);
			chatImageBgSprite:setAnchorPoint(ccp(1, 1))
		else
			defaultAvatoImage = "zp_default_avatar.png"
			positionFlag = -1
			positionWidth = 0
			PhotoUrl = ""
			chatImageBgSprite = GamePub.createPointNineSpriteByScaleWH(Common.getResourcePath("MJ_fankui_btn_liaotianqipao_left.png"), 30, 30, 12, 12, m_w, m_h);
			chatImageBgSprite:setAnchorPoint(ccp(0, 1))
		end

		chatImageBgSprite:setPosition(ccp(positionFlag * (positionWidth - spacingW - 93), cellHeight-5))
		cell:addChild(chatImageBgSprite)

		--时间
		local labelTime = CCLabelTTF:create(creatTime, "Arial", 24)
		labelTime:setAnchorPoint(ccp(0.5, 0.5))
		labelTime:setColor(ccc3(0xae, 0x91, 0x72))
		labelTime:setPosition(ccp(positionFlag * (positionWidth - spacingW), cellHeight/2 - 80))
		itemParentNode:addChild(labelTime)

		--消息内容
		local labelInfro = CCLabelTTF:create(messageContent, "Arial", 38, CCSizeMake (contentPanelWidth, contentHeight+20), kCCTextAlignmentLeft)
		labelInfro:setAnchorPoint(ccp(0, 1));
		labelInfro:setZOrder(10);
		labelInfro:setColor(ccc3(0xff, 0xe0, 0xaf));
		if sender == MYSELF then
			labelInfro:setPosition(ccp(positionFlag * (positionWidth - spacingW - 130 - contentPanelWidth), cellHeight/2 ));
			labelInfro:setColor(ccc3(0xff, 0xff, 0xc8))
		else
			labelInfro:setPosition(ccp(positionFlag * (positionWidth - spacingW - 130), cellHeight/2));
		end
		itemParentNode:addChild(labelInfro)

		--头像
		local imageAvato = CCSprite:create(Common.getResourcePath(defaultAvatoImage))
		imageAvato:setAnchorPoint(ccp(0.5, 1))
		imageAvato:setPosition(ccp(positionFlag * (positionWidth - spacingW), cellHeight/2 + spacingH))
		itemParentNode:addChild(imageAvato)
		ChatRecordTableViewUITable[i].imageAvato = imageAvato


		if PhotoUrl ~= nil and  PhotoUrl ~= ""  then
			Common.getPicFile(PhotoUrl, i, true, updataHeadImage)
		end

	end
	--	ChatRecordTableView:setScaleX(GameConfig.ScaleAbscissa);
	--	ChatRecordTableView:setScaleY(GameConfig.ScaleOrdinate);
	view:addChild(ChatRecordTableView)
	ccTableView.reloadData(ChatRecordTableView)
	ChatRecordTableView:setContentOffset(ccp(0, 0),false);
end

--[[--
--计算消息气泡的宽度和高度
--]]
function caculateMessageWidth(text)
	local messagePropertyTable = {}; --存储消息气泡布局的宽和高
	local contentHeight = 0;
	local contentPanelWidth = 0;

	local textRealLength = Common.getFontStringLen(text,1)
	if textRealLength <= 11 then
		contentHeight = TextHeight
		contentPanelWidth = oneFontWidth*textRealLength
	else
		contentPanelWidth = oneFontWidth*11
		local row = math.floor((textRealLength -1)/11) + 1
		contentHeight = TextHeight * row * 1.2
	end

	messagePropertyTable.contentHeight = contentHeight;
	messagePropertyTable.contentPanelWidth = contentPanelWidth;
	return messagePropertyTable;
end

--发信息
function callback_btn_send(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		--local sendvalue = label_sendmsg:getStringValue()
		local sendvalue = edit_sendMsg:getText()
		local imei = Common.getDeviceInfo()

		if sendvalue ~= nil and sendvalue ~= "" then
			Common.log(1001, sendvalue)
			local connecttype = Common.getConnectionType()
			local version = Common.getVersionName()
			Common.log("sendmsgto1001"..connecttype..version)
			Common.log("sendmsgto1001 sendvalue = "..sendvalue)
			sendDBID_V2_SEND_MESSAGE(1001, sendvalue, "", "", imei, connecttype,version)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

function slot_Content()
	CommDialogConfig.closeProgressDialog()
	MessageContent = profileCommon.Message.getMessageContent()
	ShowMessageContent = MessageContent["MessageTable"]
	showChatRecordTableView()
end

function slot_Send()
	local flagTable = profileCommon.Message.getSendMessage()
	if flagTable["Result"] == 0 then
		Common.showToast(flagTable["ResultTxt"], 2)
		local NewCnt = #ShowMessageContent + 1
		ShowMessageContent[NewCnt] = {}
		ShowMessageContent[NewCnt].Sender = 0
		ShowMessageContent[NewCnt].CreateTime = "刚刚"
		ShowMessageContent[NewCnt].Content = edit_sendMsg:getText()
		showChatRecordTableView()
	else
		Common.showToast(flagTable["ResultTxt"], 2)
	end
	--txt_sendmsg:setText("")
	--label_sendmsg:setText("")
	edit_sendMsg:setText("")
end

--[[--
---发送消息输入框(ios)
--]]
function callback_txt_sendmsg_ios(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		Common.showAlertInput(txt_sendmsg:getStringValue(),0,true,callbackSendInput)
	elseif component == CANCEL_UP then
	--取消
	end
end

--[[--
---发送消息输入框(Android)
--]]
function callback_txt_sendmsg()
	--控件不存在,return
	if label_sendmsg == nil then
		return;
	end

	--如果用户输入内容,则将输入的内容赋给显示的label
	if txt_sendmsg:getStringValue() ~= nil and txt_sendmsg:getStringValue() ~= "" then
		label_sendmsg:setText(txt_sendmsg:getStringValue());
	end
end


function callbackSendInput(valuetable)
	local value = valuetable["value"]
	--输入数据为空, return
	if value == nil or value == "" then
		return;
	end

	--控件存在
	if txt_sendmsg ~= nil and label_sendmsg ~= nil then
		txt_sendmsg:setText(value);
		label_sendmsg:setText(value);
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	framework.addSlot2Signal(DBID_V2_GET_CONVERSATION, slot_Content)
	framework.addSlot2Signal(DBID_V2_SEND_MESSAGE, slot_Send)
end

function removeSlot()
	framework.removeSlotFromSignal(DBID_V2_GET_CONVERSATION, slot_Content)
	framework.removeSlotFromSignal(DBID_V2_SEND_MESSAGE, slot_Send)
end