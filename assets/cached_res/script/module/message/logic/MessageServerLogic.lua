module("MessageServerLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_6 = nil;--
Button_close = nil;--
Panel_Content = nil;--
label_content = nil;--
Panel_40 = nil;--
Button_sure = nil;--
Image_sure = nil;--

local MessageId;--消息id
local MessageTitle = nil;--消息标题
local MessageContent = nil;--消息内容

--[[--消息类型  --]]
local MessageType= nil;--消息类型
local NORMALMESSAGE = 0;--普通消息类型
local RECEIVEMESSAGE= 1;--领奖消息类型
local ACTIONMESSAGE = 2;--执行消息类型
local XY_GIFT_BAG = 3;--XY平台新用户礼包兑换

--[[--消息状态  --]]
local MessageFlag= nil;--消息状态
local READEDMESSAGE = 1;--已读消息状态
local RECEIVEEDMESSAGE = 2;--已领奖消息状态

--[[--动作类型  --]]
local Action = nil ;--动作类型
local ACTIONBAOMINBISAI = 1;--报名比赛
local ACTIONENTERROOM = 2;--直接进入一个房间
local ACTIONMINIGAME = 3;--直接进入一个小游戏
local ACTIONACTIVITY = 4;--直接进入一个活动的页面
local ACTIONCREAZYGAME = 5;--疯狂闯关的首页
local ACTIONSHOPGOODSDETAILS = 6;--商城金币标签页
local ACTIONEXCHANGEVIEW = 7;--兑奖专区
local ACTIONPAIHANGBANG = 8;--排行榜页
local ACTIONCHONGZHI = 9;--充值首页
local ACTIONVIPVIEW = 10;--VIP首页
local ACTIONMISSIONVIEW = 11;--任务页
local ACTIONQIANDAOVIEW = 12;--签到页
local ACTIONINFORMATION = 13;--个人资料
local ACTIONYUANBAOHUANJINBI = 14;--元宝换金币
local ACTIONQUICKBEGIN = 15;--快速开始
local ACTIONCAISHEN = 16;--财神页面
local ACTIONINVITE = 17;--绑定邀请码（IOS）
local ACTIONATTESTATION = 21;--真人认证
local ACTIONREFEREE = 22;--推荐奖励
local ACTIONRECOMMEND = 23;--最新推荐系统

--[[--动作参数  --]]
local ActionParam = nil ;--动作参数

--[[--小游戏--]]
local MINIGAMEFRUITMACHINE = 102;--水果机
local MINIGAMEJINHUANGGUAN = 103;--金皇冠
local MINIGAMEWANRENJINHUA = 104;--万人金花
local MINIGAMEWANRENFRUITJ  = 105;--万人水果机

--[[--活动--]]
local ACTIVITYAIXINNVSHEN = 4;--爱心女神
local ACTIVITYFUXINGAOZHAO = 3;--福星高照
local ACTIVITYLUCKYTURNTABLE = 6;--幸运转盘

--向服务器请求成功
local REQUIRESUCCED = 1;

--[[--
--销毁界面
--]]
local function close()
	mvcEngine.destroyModule(GUI_MESSAGESERVER);
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		GamePub.closeDialogAmin(Panel_40,close)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_6 = cocostudio.getUIPanel(view, "Panel_6");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_Content = cocostudio.getUIPanel(view, "Panel_Content");
	label_content = cocostudio.getUILabel(view, "label_content");
	label_content:setText(MessageContent);
	Panel_40 = cocostudio.getUIPanel(view, "Panel_40");
	Button_sure = cocostudio.getUIButton(view, "Button_sure");
	Image_sure = cocostudio.getUIImageView(view, "Image_sure");

	--如果属于    普通文本类型     或者    前往类型       否则领奖类型
	if MessageType == NORMALMESSAGE then
		-- 普通文本类型
		Image_sure:loadTexture("MJ_outgame_btn_dqueding_nor.png",1)
	elseif MessageType == ACTIONMESSAGE then
		--前往类型
--		Image_sure:loadTexture("DN_HALL_signed_btn_spiralgreen_fnt_go.png",1)
	elseif MessageType == RECEIVEMESSAGE then
		--领奖类型
		if MessageFlag ~= RECEIVEEDMESSAGE then
			--未领取
			Image_sure:loadTexture("MJ_hall_btn_kefuxiaomei.png",1)
		else
			Image_sure:loadTexture("MJ_btn_yilingqu_nor.png",1)
			Button_sure:loadTextures("MJ_btn_yilingqu_anniu_nor.png", "MJ_btn_yilingqu_anniu_nor.png","", 1)
		end
	elseif MessageType == XY_GIFT_BAG then
		label_content:setVisible(false);
		--展示奖品列表
		showPrizeList();
		Image_sure:loadTexture("MJ_hall_btn_kefuxiaomei.png",1)
	end
	--	if MessageFlag == RECEIVEEDMESSAGE or MessageFlag == READEDMESSAGE then
	--		Button_sure:setOpacity(120)
	--	end
	GamePub.showDialogAmin(Panel_40)
end

--[[--
--展示奖品列表
--]]
function showPrizeList()
	local position = Panel_Content:getParent():convertToWorldSpace(Panel_Content:getPosition());
	local size = Panel_Content:getContentSize();

	CommDialogConfig.commonLoadWebView(GameConfig.URL_XY_PLATFORM_GIFT_BAG, "URL_XY_PLATFORM_GIFT_BAG", position.x, position.y, size.width, size.height)
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("MessageServer.json")
	local gui = GUI_MESSAGESERVER
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
	view:setTag(getDiffTag());
	scene = CCDirector:sharedDirector():getRunningScene();
	scene:addChild(view);
	initView();
end

function requestMsg()

end

--function callback_Button_close(component)
--	if component == PUSH_DOWN then
--	--按下
--
--	elseif component == RELEASE_UP then
--		--抬起
--		GamePub.closeDialogAmin(panel_Notice,close);
--	elseif component == CANCEL_UP then
--	--取消
--
--	end
--end

function setConversationID(msgValue)
	msg = msgValue
	Common.log("msg = " .. msg)
end

--[[--
--设置本视图显示需要的数据
--@param number sMessageId 消息id
--@param String sMessageTitle 消息标题
--@param String sMessageContent 消息内容
--@param Byte sMessageType 消息类型
--@param Byte sMessageFlag 消息状态
--@param number sAction 动作
--@param String sActionParam 动作参数
--]]
function setServerViewNeedParams(sMessageId,sMessageTitle,sMessageContent,sMessageType,sMessageFlag,sAction,sActionParam)
	MessageId = sMessageId;
	MessageTitle = sMessageTitle;
	MessageContent = sMessageContent;
	MessageType = sMessageType;
	MessageFlag = sMessageFlag;
	Action = sAction;
	ActionParam = sActionParam;
	Common.log("MessageId 		=== "..MessageId)
	Common.log("MessageTitle 	=== "..MessageTitle)
	Common.log("MessageContent 	=== "..MessageContent)
	Common.log("MessageType 	=== "..MessageType)
	Common.log("MessageFlag 	=== "..MessageFlag)
	Common.log("Action 			=== "..Action)
	Common.log("ActionParam 	=== "..ActionParam)
end

--[[--
--多状态按钮（领取，前往）回调方法封装
--]]
function btnGoOrReceive()
	Common.log("MessageServerLogic ====== ====== lingqu")
	if MessageType == RECEIVEMESSAGE then
		--领取奖品列表
		local systemReceiveList= profileCommon.Message.getMessageReceiveAwardTable();
		if systemReceiveList.Success == REQUIRESUCCED then
			--MessageId: 已领奖的消息ID 2:标记为已读
			MessageListLogic.updateServerReveiveState(MessageId,2)
			--播放领奖动画
			for i = 1 ,#systemReceiveList.MessageReceiveListTable  do
				local description = systemReceiveList.MessageReceiveListTable[i].PciDescription .. "X" .. systemReceiveList.MessageReceiveListTable[i].Count
				ImageToast.createView(systemReceiveList.MessageReceiveListTable[i].PicUrl,nil,description,systemReceiveList.Message,3)
			end
			--优化  顺序执行 执行完领奖效果后   就再执行 显示已领取
			Image_sure:loadTexture("DN_HALL_mail_btn_spiralbrown_fnt_already.png",1)
			Button_sure:loadTextures("DN_HALL_btn_spiralgray.png", "DN_HALL_btn_spiralgray.png","", 1)
			Image_sure:setVisible(true)
			Button_sure:setVisible(true)
			Button_sure:setTouchEnabled(false)

--			sendMANAGERID_REMOVE_REDP(profile.HongDian.MESSAGE, MessageId);
		else
			--toast显示领奖失败
			Common.showToast("抱歉，您领奖失败！", 2);
		end
	end
	close()
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

--
--[[--
多状态按钮  触发事件方法回调方法
--]]
function callback_Button_sure(component)
	Common.log("MessageServerLogic ====== ====== queding")
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起

		if MessageType == NORMALMESSAGE then
			Common.log("callback_Button_sure === NORMALMESSAGE")
			close()
		elseif MessageType == RECEIVEMESSAGE then
			Common.log("callback_Button_sure === RECEIVEMESSAGE")
			--发送请求领奖消息信号
			if MessageFlag ~= RECEIVEEDMESSAGE then
				sendMAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4(MessageId)
			else
				close()
			end
		elseif MessageType == ACTIONMESSAGE then
			Common.log("callback_Button_sure === ACTIONMESSAGE")
--			sendMANAGERID_REMOVE_REDP(profile.HongDian.MESSAGE, MessageId);
			--如果该消息是执行动作类型
			if Action == ACTIONBAOMINBISAI then
				--1，比赛列表、比赛详情、直接报名一场比赛
				local param_table = Common.FGUtilStringSplit(ActionParam, ",")
				if param_table ~= nil and param_table[1] ~= nil and param_table[2] ~= nil then
					HallModeConfig.setHallShowMode(tonumber(param_table[1]))
					HallModeConfig.setHallRoomItem(tonumber(param_table[2]))
					mvcEngine.createModule(GUI_HALL)
				end
			elseif Action == ACTIONENTERROOM then
				--2，房间列表、直接进入一个房间
				local param_table = Common.FGUtilStringSplit(ActionParam, ",")
				CommDialogConfig.showProgressDialog("正在进入房间中,请稍后...");
				sendJHID_QUICK_START_REQ()
			elseif Action == ACTIONMINIGAME then
				--3，小游戏列表、直接进入一个小游戏
				if tonumber(ActionParam) == MINIGAMEFRUITMACHINE then
					GameConfig.setTheLastBaseLayer(GUI_HALL)
					GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.FruitGameID);
				end
				if tonumber(ActionParam) == MINIGAMEJINHUANGGUAN then
					GameConfig.setTheLastBaseLayer(GUI_HALL)
					GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.JinHuangGuanGameID);
				end
				if tonumber(ActionParam) == MINIGAMEWANRENJINHUA then
					--万人金花
					GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.WanRenJinHuaGameID);
				end
				if tonumber(ActionParam) == MINIGAMEWANRENFRUITJ then
					GameConfig.setTheLastBaseLayer(GUI_HALL)
					GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.WanRenFruitGameID);
				end
			elseif Action == ACTIONACTIVITY then
				--4，活动列表、直接进入一个活动的页面
				if(tonumber(ActionParam) == ACTIVITYAIXINNVSHEN)then
					GameConfig.setTheLastBaseLayer(GUI_HUODONG)
					mvcEngine.createModule(GUI_AIXINNVSHEN)
				elseif(tonumber(ActionParam) == ACTIVITYFUXINGAOZHAO) then
					GameConfig.setTheLastBaseLayer(GUI_HUODONG)
                    FuXingGaoZhaoConfig.startFuXingGame()
					--mvcEngine.createModule(GUI_FUXINGGAOZHAO)
				elseif(tonumber(ActionParam) == ACTIVITYLUCKYTURNTABLE) then
					GameConfig.setTheLastBaseLayer(GUI_HUODONG)
--					mvcEngine.createModule(GUI_LUCKY_TURNTABLE)
				else
					GameLoadModuleConfig.startActivityByID(tonumber(ActionParam))
				end
			elseif Action == ACTIONCREAZYGAME then
				--5，疯狂闯关的首页
				mvcEngine.createModule(GUI_CHUANGGUAN)
			elseif Action == ACTIONSHOPGOODSDETAILS then
				--6，商城的金币标签页、道具标签页、礼包标签页，以上三类物品的详情页
--				local param_table = Common.FGUtilStringSplit(ActionParam, ",")
--				ShopLogic.setTabAndGoodsID(param_table[1],param_table[2])
--				mvcEngine.createModule(GUI_SHOP)
			elseif Action == ACTIONEXCHANGEVIEW then
				--7，兑奖的(Action = 1)兑奖券专区页、(Action = 2)碎片兑奖页、(Action = 3)我的奖品页，以上分类中某一个具体物品的详情页；
				local param_table = Common.FGUtilStringSplit(ActionParam, ",")
				ExchangeLogic.setState(param_table[1])
				ExchangeLogic.setGoodsID(param_table[2])
				mvcEngine.createModule(GUI_EXCHANGE)
			elseif Action == ACTIONPAIHANGBANG then
				--8，排行榜的3个标签页（其中每日充值榜还要区分今日排行页和昨日排行页）
				mvcEngine.createModule(GUI_RANK)
			elseif Action == ACTIONCHONGZHI then
				--9，充值首页
				mvcEngine.createModule(GUI_RECHARGE_CENTER)
			elseif Action == ACTIONVIPVIEW then
				--10，VIP首页
				mvcEngine.createModule(GUI_VIPINFO)
			elseif Action == ACTIONMISSIONVIEW then
				--11，任务首页
				mvcEngine.createModule(GUI_TASK)
			elseif Action == ACTIONQIANDAOVIEW then
				--12，签到首页
--				if ServerConfig.isAppstoreReview() == false then
--					mvcEngine.createModule(GUI_MONTHSIGN)
--				end
			elseif Action == ACTIONINFORMATION then
				--13，个人资料的各个标签页
				mvcEngine.createModule(GUI_SELFUSERINFO)
			elseif Action == ACTIONYUANBAOHUANJINBI then
				--14，元宝换金币的弹框
				mvcEngine.createModule(GUI_CONVERTCOININROOM)
			elseif Action == ACTIONQUICKBEGIN then
				--15，快速开始
				CommDialogConfig.showProgressDialog("正在进入房间中,请稍后...");
				sendJHID_QUICK_START_REQ()
			elseif Action == ACTIONCAISHEN then
				--16，财神页面
				mvcEngine.createModule(GUI_CAISHEN)
			elseif Action == ACTIONINVITE then
				--17
--				RedeemLogic.setCurViewType(RedeemLogic.getViewTypeTable().TAG_INVITE_PRIZE);
--				mvcEngine.createModule(GUI_REDEEM)
			elseif Action == ACTIONATTESTATION then
				--21 真人认证
				mvcEngine.createModule(GUI_UPLOADREALPIC)
			elseif Action == ACTIONREFEREE then
				--22 推荐奖励
--				RefereeLogic.setMessageId(MessageId)
--				mvcEngine.createModule(GUI_REFEREE)
			elseif Action == ACTIONRECOMMEND then
				--mvcEngine.createModule(GUI_RECOMMENDVERIFY)
			end
			close()
		elseif MessageType == XY_GIFT_BAG then
			--XY平台新用户兑奖：打开兑换码兑奖界面
--			RedeemLogic.setCurViewType(RedeemLogic.getViewTypeTable().TAG_REDEMPTION_CODE);
--			mvcEngine.createModule(GUI_REDEEM);
			close()
		else
			close()
		end
	elseif component == CANCEL_UP then
	--取消

	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
	Common.hideWebView();
end

function addSlot()
	--奖品领取
	framework.addSlot2Signal(MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4, btnGoOrReceive)
end

function removeSlot()
	--奖品领取移除
	framework.removeSlotFromSignal(MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4, btnGoOrReceive)
end
