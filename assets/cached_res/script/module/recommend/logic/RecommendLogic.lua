module("RecommendLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_tableview = nil;--
Panel_58 = nil;--
Button_close = nil;--
Panel_25 = nil;--
Label_tip = nil;--
Label_tip1 = nil;--
Button_invite = nil;--
Panel_45 = nil;--
ProgressBar = nil;--
Image_light1 = nil;--
AtlasLabel_box1 = nil;--
Image_light2 = nil;--
AtlasLabel_box2 = nil;--
Image_light3 = nil;--
AtlasLabel_box3 = nil;--
Image_light4 = nil;--
AtlasLabel_box4 = nil;--
Image_light5 = nil;--
AtlasLabel_box5 = nil;--
Panel_29 = nil;--
AtlasLabel_friend_num = nil;--
Button_left = nil;--
Button_right = nil;--
Button_reward = nil;--


local MAX_CNT = 20
local CELL_CNT = 6
local DEVIATION_DIS = 30

local CELL_WIDTH = 154
--table的偏移量
local OffsetMax = CELL_WIDTH * (CELL_CNT - MAX_CNT)
--宝箱相关控件
BoxTbale = {}
--进度条
ProgressBarTable = {}

firendListTable = {}
boxListTable = {}


avatarSpTable = {}
lingquBtnTable = {}
LingQuMenuTable = {}
boxAnimTable = {}

local lightTable = {} --点亮集合

--结算的tableview
FriendTableView = nil;--

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
	local gui = GUI_RECOMMEND;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("request.plist"))
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("Recommend.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Recommend.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_tableview = cocostudio.getUIPanel(view, "Panel_tableview");
	Panel_58 = cocostudio.getUIPanel(view, "Panel_58");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_25 = cocostudio.getUIPanel(view, "Panel_25");
	Label_tip = cocostudio.getUILabel(view, "Label_tip");
	Label_tip1 = cocostudio.getUILabel(view, "Label_tip1");
	Button_invite = cocostudio.getUIButton(view, "Button_invite");
	Panel_45 = cocostudio.getUIPanel(view, "Panel_45");
	ProgressBar = cocostudio.getUILoadingBar(view, "ProgressBar");
	Image_light1 = cocostudio.getUIImageView(view, "Image_light1");
	AtlasLabel_box1 = cocostudio.getUILabelAtlas(view, "AtlasLabel_box1");
	Image_light2 = cocostudio.getUIImageView(view, "Image_light2");
	AtlasLabel_box2 = cocostudio.getUILabelAtlas(view, "AtlasLabel_box2");
	Image_light3 = cocostudio.getUIImageView(view, "Image_light3");
	AtlasLabel_box3 = cocostudio.getUILabelAtlas(view, "AtlasLabel_box3");
	Image_light4 = cocostudio.getUIImageView(view, "Image_light4");
	AtlasLabel_box4 = cocostudio.getUILabelAtlas(view, "AtlasLabel_box4");
	Image_light5 = cocostudio.getUIImageView(view, "Image_light5");
	AtlasLabel_box5 = cocostudio.getUILabelAtlas(view, "AtlasLabel_box5");
	Panel_29 = cocostudio.getUIPanel(view, "Panel_29");
	AtlasLabel_friend_num = cocostudio.getUILabelAtlas(view, "AtlasLabel_friend_num");
	Button_left = cocostudio.getUIButton(view, "Button_left");
	Button_right = cocostudio.getUIButton(view, "Button_right");
	Button_reward = cocostudio.getUIButton(view, "Button_reward");

	BoxTbale = {}
	BoxTbale[1] = {}
	--	BoxTbale[1].box = Button_box1
	BoxTbale[1].num = AtlasLabel_box1
	BoxTbale[2] = {}
	--	BoxTbale[2].box = Button_box2
	BoxTbale[2].num = AtlasLabel_box2
	BoxTbale[3] = {}
	--	BoxTbale[3].box = Button_box3
	BoxTbale[3].num = AtlasLabel_box3
	BoxTbale[4] = {}
	--	BoxTbale[4].box = Button_box4
	BoxTbale[4].num = AtlasLabel_box4
	BoxTbale[5] = {}
	--	BoxTbale[5].box = Button_box5
	BoxTbale[5].num = AtlasLabel_box5

	--	ProgressBarTable = {}
	--	ProgressBarTable[1] = ProgressBar_jindutiao1
	--	ProgressBarTable[2] = ProgressBar_jindutiao2
	--	ProgressBarTable[3] = ProgressBar_jindutiao3
	--	ProgressBarTable[4] = ProgressBar_jindutiao4

	--	for i=1,#BoxTbale do
	--		--初始化是 按钮禁用状态
	--		showBoxState(i,3)
	--	end
	--
	--	for i=1,#ProgressBarTable do
	--		showProBarState(i,0)
	--	end

	lightTable = {Image_light1, Image_light2, Image_light3, Image_light4, Image_light5}

end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)

	initView();
end

function requestMsg()
	sendMJ_SC_RECOMMEND_INFO()
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end


function callback_Button_reward(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		sendMJ_SC_RECEIVE_REWARD(2,0)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_invite(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		local cdKey = profile.MahjongRecommend.getShareToWxKey()
		local nickName = profile.User.getSelfNickName()
		local urlFront = profile.MahjongRecommend.getShareToWxUrl()
		local url = urlFront.."&shareCode="..cdKey;
		GamePub.shareToWX(0,"麻友局","'"..nickName.."'".."邀请您加入麻友局，邀请码为"..cdKey.."。游戏中输入邀请码，即可获得房卡礼包。" ,url)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_left(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if FriendTableView == nil then
			return
		end

		--当前tableview的坐标
		local curPos = getFriendTableViewPos()
		if curPos.x == 0 then
			Common.showToast("已经显示第一个好友~");
		end
		--点击向右后的目标坐标
		local tarPosX = curPos.x + (CELL_WIDTH * CELL_CNT)
		if tarPosX >= 0 then
			--已经没有内容了
			setFriendTableViewOffsetInDuration(0,0,0.2)
		else
			--偏移坐标必须是cell宽的整数
			tarPosX = math.floor(tarPosX/CELL_WIDTH) * CELL_WIDTH
			setFriendTableViewOffsetInDuration(tarPosX,0,0.2)
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
		if FriendTableView == nil then
			return
		end

		--当前tableview的坐标
		local curPos = getFriendTableViewPos()
		if curPos.x == OffsetMax then
			Common.showToast("已经显示最后一个好友~");
		end
		--点击向右后的目标坐标
		local tarPosX = curPos.x - (CELL_WIDTH * CELL_CNT)
		if tarPosX < OffsetMax then
			--已经没有内容了
			setFriendTableViewOffsetInDuration(OffsetMax,0,0.2)
		else
			tarPosX = math.floor(tarPosX/CELL_WIDTH) * CELL_WIDTH
			setFriendTableViewOffsetInDuration(tarPosX,0,0.2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--更新图片
]]
local function updataImageGooods(path)
	local photoPath = nil
	local id = nil

	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		id = string.sub(path, 1, i-1)
		photoPath = string.sub(path, j+1, -1)
	end
	if photoPath ~= nil and photoPath ~= "" and avatarSpTable[""..id] ~= nil then
		local texture = CCTextureCache:sharedTextureCache():addImage(photoPath)
		avatarSpTable[""..id]:setTexture(texture)
	end
end


function setAllTouchEnabled(flag)
	if FriendTableView ~= nil then
		FriendTableView:setTouchEnabled(flag)
		for i = 1, table.maxn(LingQuMenuTable) do
			if LingQuMenuTable[i] ~= nil then
				LingQuMenuTable[i]:setTouchEnabled(flag)
			end
		end
	end
end

function showResultTableView()

	local PanelListSize = Panel_tableview:getContentSize()
	local PanelListPosX = Panel_tableview:getPosition().x
	local PanelListPosY = Panel_tableview:getPosition().y

	if firendListTable ~= nil then
		local length = #firendListTable
		if length < MAX_CNT then
			for i=length+1,MAX_CNT do
				firendListTable[i] = {}
				firendListTable[i].userID = -1
			end
		end
	end

	local tableSize = 0 --元素数量
	local TableView_W = PanelListSize.width --TableView的显示宽度
	local TableView_H = PanelListSize.height --TableView的显示高度
	local TableView_X = PanelListPosX --* GameConfig.ScaleAbscissa; --TableView的左下角X坐标
	local TableView_Y = PanelListPosY --* GameConfig.ScaleOrdinate; --TableView的左下角Y坐标
	local rowSize = 1; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 0; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local spacingW = 0; --横向间隔
	local spacingH = 2 --纵向间隔
	local loadCellSize = 0;--已经加载的元素数
	local cellWidth = CELL_WIDTH; --每个元素的宽
	local cellHeight = 172; --每个元素的高

	if FriendTableView ~= nil then
		FriendTableView:removeFromParentAndCleanup(true)
	end

	-- TableView_X = TableView_X - TableView_W * (1 - GameConfig.ScaleAbscissa) / 2
	-- TableView_Y = TableView_Y - TableView_H * (1 - GameConfig.ScaleOrdinate) / 2

	local loadCellSize = 0;--已经加载的元素数
	FriendTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionHorizontal);
	FriendTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function FriendTableView.initTableViewData()
		FriendTableView.SeparatorWidth = spacingW
		loadCellSize = 0;
		if firendListTable ~= nil and #firendListTable > 0 then
			--接收排行榜数量
			tableSize = #firendListTable
			--计算一共多少行
			-- rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)

			columnSize = #firendListTable
		end
	end

	function FriendTableView.getTableViewInfo()
		local TableViewInfo = {}

		TableViewInfo.TableView_X = TableView_X --* GameConfig.ScaleAbscissa;--TableView的左下角X坐标
		TableViewInfo.TableView_Y = TableView_Y --* GameConfig.ScaleOrdinate;--TableView的左下角Y坐标
		TableViewInfo.TableView_W = TableView_W --* GameConfig.ScaleAbscissa;--TableView的显示宽度
		TableViewInfo.TableView_H = TableView_H --* GameConfig.ScaleOrdinate;--TableView的显示高度
		TableViewInfo.rowSize = rowSize;--一共多少行
		TableViewInfo.columnSize = columnSize;--一共多少列
		TableViewInfo.spacingW = spacingW; --横向间隔
		TableViewInfo.spacingH = spacingH; --纵向间隔

		return TableViewInfo
	end

	function FriendTableView.getCellWidth()
		return cellWidth --* GameConfig.ScaleAbscissa;--每个元素的宽
	end

	function FriendTableView.numberOfrow()
		return columnSize;
	end

	function FriendTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight --* GameConfig.ScaleOrdinate;--每个元素的高
	end

	function FriendTableView.CellOfAtNumberOfRow(cell, i)
		-- ...userID	int	好友id
		local userID = firendListTable[i].userID

		if userID < 0 then

			--父节点layer
			local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
			itemParentNode:setPosition(ccp(cellWidth / 2 , cellHeight / 2))
			itemParentNode:setCascadeOpacityEnabled(true);
			cell:addChild(itemParentNode)


			local avatarBoxSp = CCSprite:createWithSpriteFrameName("MJ_outgame_pz_touxiangkuang.png")
			avatarBoxSp:setPosition(ccp(0, cellHeight/2))
			avatarBoxSp:setScale(0.9)
			itemParentNode:addChild(avatarBoxSp)


			local idxLabel = CCLabelAtlas:create(""..i, Common.getResourcePath("MJ_pz_fangj_shuizi_1.png"), 22, 35, 48);
			idxLabel:setAnchorPoint(ccp(0.5,0.5))
			idxLabel:setPosition(ccp(0, cellHeight/2))
			itemParentNode:addChild(idxLabel)

			return
		end

		-- ...curGames	int	当前局数
		local curGames = firendListTable[i].curGames
		-- ...tarGames	int	目标局数
		local tarGames = firendListTable[i].tarGames
		-- ...isReceive	Byte	是否已领取
		local isReceive = firendListTable[i].isReceive
		-- ...photoUrl	string
		local photoUrl = firendListTable[i].photoUrl
		-- ...nickNmae	string
		local nickName = firendListTable[i].nickName

		Common.log("userID ========= "..userID)
		Common.log("curGames ======= "..curGames)
		Common.log("tarGames ======= "..tarGames)
		Common.log("isReceive ======== "..isReceive)
		Common.log("photoUrl ========= "..photoUrl)
		Common.log("nickName ========= "..nickName)

		--父节点layer
		local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
		itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)


		local avatarBoxSp = CCSprite:createWithSpriteFrameName("MJ_outgame_pz_touxiangkuang.png")
		avatarBoxSp:setPosition(ccp(0, cellHeight/7*6))
		avatarBoxSp:setScale(0.9)
		itemParentNode:addChild(avatarBoxSp)


		local avatarSp = CCSprite:create(Common.getResourcePath("MJ_default_avatar.png"))
		avatarSp:setPosition(ccp(avatarBoxSp:getContentSize().width /2, avatarBoxSp:getContentSize().height /2 + 15))
		avatarBoxSp:addChild(avatarSp)
		avatarSpTable[""..i] = avatarSp


		if photoUrl ~= nil and  photoUrl ~= ""  then
			Common.getPicFile(photoUrl, i, true, updataImageGooods,true)
		end

		--		local nameBg = GamePub.createPointNineSpriteForPlist("zp_bg_24.png", 11, 11, 90, 30)
		--		nameBg:setPosition(ccp(0, cellHeight/7 - 45))
		--		itemParentNode:addChild(nameBg)

		local length = Common.getStringLength(nickName)
		if length > 5 then
			nickName = Common.SubUTF8String(nickName,1,3)
			nickName = nickName.."..."
		end
		local nameLabel = CCLabelTTF:create(nickName, "Arial", 20)
		nameLabel:setColor(ccc3(0xed,0xca,0x70))
		nameLabel:setPosition(ccp(0, cellHeight/7*6 - 55))
		itemParentNode:addChild(nameLabel)

		local function clickGameCallBack()
			if(FriendTableView.isMoved)then
				return
			end
			Common.log("friend userID === "..userID)
			sendMJ_SC_RECEIVE_REWARD(3,userID)
		end

		if curGames >= tarGames then
			--满足领取条件 显示按钮
			---领取按钮

			local lingquSpStr = "MJ_hall_btn_kefuxiaomei.png"
			if isReceive == 1 then
				lingquSpStr = "MJ_fnt_inventfriends_yilingqu.png"
			else
				--满足领取条件 显示按钮
				---领取按钮
				local pRibbon = CCSprite:createWithSpriteFrameName("MJ_outgame_btn_fasong_nor.png")
				local pRibbon1 = CCSprite:createWithSpriteFrameName("MJ_outgame_btn_fasong_nor.png")

				local diSpriteItem = CCMenuItemSprite:create(pRibbon, pRibbon1, nil)
				diSpriteItem:registerScriptTapHandler(clickGameCallBack)
				diSpriteItem:setAnchorPoint(ccp(0.5, 0.5))

				local menuCell = CCMenu:create()
				menuCell:setPosition(ccp(0,cellHeight/9))
				menuCell:addChild(diSpriteItem)
				itemParentNode:addChild(menuCell)

				LingQuMenuTable[""..userID] = menuCell

			end

			local lingquSp = CCSprite:createWithSpriteFrameName(lingquSpStr)
			lingquSp:setPosition(ccp(0,cellHeight/9))
			itemParentNode:addChild(lingquSp)
			lingquSp:setZOrder(99)
			Common.log("userIDuserIDuserIDuserID === "..userID)
			lingquBtnTable[""..userID] = lingquSp
		else
			local gamesStr = curGames..":"..tarGames;
			--没满足领取条件  显示局数数字
			local GamesLabel = CCLabelAtlas:create(""..gamesStr, Common.getResourcePath("MJ_pz_fangj_shuizi_1.png"), 22, 35, 48);
			GamesLabel:setAnchorPoint(ccp(0.5,0.5))
			GamesLabel:setScale(0.6)
			GamesLabel:setPosition(ccp(0,cellHeight/9))
			itemParentNode:addChild(GamesLabel)
		end

	end

	-- FriendTableView:setScaleX(GameConfig.ScaleAbscissa);
	-- FriendTableView:setScaleY(GameConfig.ScaleOrdinate);
	view:addChild(FriendTableView)
	ccTableView.reloadData(FriendTableView)
end
--[[--
--获取tableview的偏移量
--]]
function getFriendTableViewPos()
	if FriendTableView ~= nil then
		return FriendTableView:getContentOffset()
	end
	return nil
end
--[[--
--设置tableview偏移量 by 时间
--]]
function setFriendTableViewOffsetInDuration(x,y,t)
	if FriendTableView ~= nil then
		FriendTableView:setContentOffsetInDuration(ccp(x, y),t);
	end
end

function senBoxRewardByIdx(idx)
	local tarNum = boxListTable[idx].tarNum
	sendMJ_SC_RECEIVE_REWARD(2,tarNum)
end


--邀请好友信息
local function slot_MJ_SC_RECOMMEND_INFO()
	local MJ_SC_RECOMMEND_INFO_data = profile.MahjongRecommend.getMJRecommendInfoTable()
	--好友最大上限
	local friendCntMax = MJ_SC_RECOMMEND_INFO_data["friendCntMax"]
	--邀请的好友列表
	firendListTable = MJ_SC_RECOMMEND_INFO_data["friendList"]
	--宝箱列表
	boxListTable = MJ_SC_RECOMMEND_INFO_data["giftList"]
	--当前好友个数
	local friendCntCur = #firendListTable

	--获取tableview的最大偏移量
	--显示好友数量
	AtlasLabel_friend_num:setStringValue(friendCntCur..":"..friendCntMax)
	-- --规则中游戏
	-- Label_tip1:setText("2.被邀请玩家"..6.."局游戏时，您可获得额外的奖励")

	showGiftBoxInfo()


	showResultTableView()

end

function showGiftBoxInfo()

	--当前好友个数
	local friendCntCur = #firendListTable
	local friendMax = boxListTable[#BoxTbale].tarNum

	Button_reward:loadTextures("MJ_btn_weikailingquanniug.png", "MJ_btn_weikailingquanniug.png","", 1)
	Button_reward:setTouchEnabled(false)

	local nowPer = 1;

	local lastTarNum = 0
	for i=1,#BoxTbale do
		local tarNum = boxListTable[i].tarNum
		local isReceive = boxListTable[i].isReceive

		local atlasLabel = BoxTbale[i].num
		if atlasLabel ~= nil then
			atlasLabel:setStringValue(""..tarNum)
		end

		if friendCntCur >= tarNum then
			--宝箱为可领取状态
			if isReceive == 0 then
				--没有被领取
				--这里要播放动画
				--				showBoxState(i,1,tarNum)
				Button_reward:loadTextures("MJ_btn_lingquanniug.png", "MJ_btn_lingquanniug.png","", 1)
				Button_reward:setTouchEnabled(true)
			else
			--已被领取
			--				showBoxState(i,2)
			end
			lightTable[i]:setVisible(true)
		end
		--		--设置进度条显示
		--		if i > 1 then
		--			--从第二个开始
		--			local percent = 1
		--			if friendCntCur >= tarNum then
		--				percent = 100
		--			elseif friendCntCur < tarNum and friendCntCur > lastTarNum then
		--				percent = math.floor((friendCntCur - lastTarNum)/(tarNum - lastTarNum)*100)
		--			end
		--			showProBarState(i-1,percent)
		--		end
		--		--存储下上一个宝箱需要的 好友人数  用来线进度条
		--		lastTarNum = tarNum

		if friendCntCur >= boxListTable[i].tarNum then
			nowPer = i;
		end
	end

	local percent = math.floor((nowPer - 1)/(#BoxTbale - 1)*100)
	ProgressBar:setPercent(percent)

end

--进度条显示
function showProBarState(index,percent)
	Common.log("进度条显示 showProBarState index === "..index.."  percent ==== "..percent)
	local bar = ProgressBarTable[index]
	if bar == nil then
		return
	end
	bar:setPercent(percent)
end

--[[
--显示宝箱状态
--index table中的索引
--state  1 打开 可领取 2 打开 以领取 3关闭
--tarNum 用来做存储动画table的key
--]]
function showBoxState(index,state,tarNum)
	local Button_box = BoxTbale[index].box
	if Button_box == nil then
		return
	end
	if state == 1 then
		Button_box:loadTextures("zp_ic_baoxiang_3.png","zp_ic_baoxiang_3.png","",1)
		Button_box:setTouchEnabled(true)
		--添加可领取动画 key为tarNum
		local boxAnim = GameArmature.createFriendBoxAnim()
		local pos = Button_box:getPosition()
		boxAnim:setPosition(ccp(pos.x,pos.y))
		view:addChild(boxAnim)
		boxAnimTable[""..tarNum] = boxAnim
	elseif state == 2 then
		Button_box:loadTextures("zp_ic_baoxiang_3.png","zp_ic_baoxiang_3.png","",1)
		Common.log("显示宝箱状态 2 显示宝箱状态 2 显示宝箱状态 2")
		Button_box:setTouchEnabled(false)
		--移除可领取动画 key为tarNum
		if tarNum ~= nil then
			local boxAnim = boxAnimTable[""..tarNum]
			if boxAnim ~= nil then
				boxAnim:stopAllActions()
				boxAnim:removeFromParentAndCleanup(true)
				boxAnimTable[""..tarNum] = nil
			end
		end
	else
		Button_box:loadTextures("zp_ic_baoxiang_2.png","zp_ic_baoxiang_2.png","",1)
		Button_box:setTouchEnabled(false)
	end
end

--领奖
local function slot_MJ_SC_RECEIVE_REWARD()
	local MJ_SC_RECEIVE_REWARD_data = profile.MahjongRecommend.getMJReceiveRewardTable()

	-- Result	Byte	0失败1成功
	local Result = MJ_SC_RECEIVE_REWARD_data["Result"]
	-- receiveType	byte	领奖类型	1验证码输入
	-- 2好友数量礼包
	-- 3好友局数满足礼包
	local receiveType = MJ_SC_RECEIVE_REWARD_data["receiveType"]
	-- receiveCode	int	游戏版本号	这个字段根据receiveType意义不同
	-- 1验证码
	-- 2满足礼包的好友数量
	-- 3满足领取条件的好友userid
	local receiveCode = MJ_SC_RECEIVE_REWARD_data["receiveCode"]
	if Result == 1 then
		if receiveType == 2 then
			--好友数量礼包
			--			--会有一个用人数来存储动画的table   这里用receiveCode（人数key）来进行删除
			--				Common.log("#boxListTable ===== "..#boxListTable)
			--			for i=1,#boxListTable do
			--				Common.log("boxListTable[i].tarNum ===== "..boxListTable[i].tarNum)
			--				if tonumber(receiveCode) == boxListTable[i].tarNum then
			--					showBoxState(i,2,receiveCode)
			--					return
			--				end
			--			end
			Button_reward:loadTextures("MJ_btn_weikailingquanniug.png", "MJ_btn_weikailingquanniug.png", "", 1)
			Button_reward:setTouchEnabled(false)

		elseif receiveType == 3 then
			Common.log("receiveCode ======= "..receiveCode)
			--好友局数
			if lingquBtnTable[""..receiveCode] ~= nil then
				local SpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache();
				local mSpriteFrame = SpriteFrameCache:spriteFrameByName("MJ_fnt_inventfriends_yilingqu.png")
				lingquBtnTable[""..receiveCode]:setDisplayFrame(mSpriteFrame)

				LingQuMenuTable[""..receiveCode]:setEnabled(false)
				LingQuMenuTable[""..receiveCode]:setVisible(false)
			end
		end
	end
end


function close()
	mvcEngine.destroyModule(GUI_RECOMMEND)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("request.plist"))
	lightTable = {} --点亮集合
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_RECOMMEND_INFO, slot_MJ_SC_RECOMMEND_INFO)
	framework.addSlot2Signal(MJ_SC_RECEIVE_REWARD, slot_MJ_SC_RECEIVE_REWARD)

end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_RECOMMEND_INFO, slot_MJ_SC_RECOMMEND_INFO)
	framework.removeSlotFromSignal(MJ_SC_RECEIVE_REWARD, slot_MJ_SC_RECEIVE_REWARD)
end
