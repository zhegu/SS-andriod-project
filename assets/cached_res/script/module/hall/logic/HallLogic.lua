module("HallLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
Button_setting = nil;--
Button_help = nil;--
Button_code = nil;--
Panel_12 = nil;--
Image_head_box = nil;--
Image_head = nil;--
Label_name = nil;--
Button_record = nil;--
Button_share = nil;--
Button_service = nil;--
Button_recommend = nil;--
Button_mail = nil;--
Button_add_card = nil;--
Label_room_card = nil;--
Button_exchangeRoomCard = nil;--
Panel_29 = nil;--
Button_createroom = nil;--
Button_joinroom = nil;--
Panel_notice = nil;--

--公告相关
local ONE_WORD_WIDTH =10;--一个字的宽
local NOTICE_MOVE_TIME = 0.013 --滚动时间
local chatPanelSize = nil; --panel 大小
local TAG_LABEL_NOTICE = 12;--公告label的tag

local labelNotice = nil

local m_ClippingNode = nil
local m_ClippingContent = nil


function onKeypad(event)
	if event == "backClicked" then
		--返回键
		androidExit()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_HALL;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("Hall.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Hall.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Button_setting = cocostudio.getUIButton(view, "Button_setting");
	Button_help = cocostudio.getUIButton(view, "Button_help");
	Button_code = cocostudio.getUIButton(view, "Button_code");
	Panel_12 = cocostudio.getUIPanel(view, "Panel_12");
	Image_head_box = cocostudio.getUIImageView(view, "Image_head_box");
	Image_head = cocostudio.getUIImageView(view, "Image_head");
	Label_name = cocostudio.getUILabel(view, "Label_name");
	Button_record = cocostudio.getUIButton(view, "Button_record");
	Button_share = cocostudio.getUIButton(view, "Button_share");
	Button_service = cocostudio.getUIButton(view, "Button_service");
	Button_recommend = cocostudio.getUIButton(view, "Button_recommend");
	Button_mail = cocostudio.getUIButton(view, "Button_mail");
	Button_add_card = cocostudio.getUIButton(view, "Button_add_card");
	Label_room_card = cocostudio.getUILabel(view, "Label_room_card");
	Button_exchangeRoomCard = cocostudio.getUIButton(view, "Button_exchangeRoomCard");
	Panel_29 = cocostudio.getUIPanel(view, "Panel_29");
	Button_createroom = cocostudio.getUIButton(view, "Button_createroom");
	Button_joinroom = cocostudio.getUIButton(view, "Button_joinroom");
	Panel_notice = cocostudio.getUIPanel(view, "Panel_notice");

	if Common.getDataForSqlite(CommSqliteConfig.INVITE_CODE_USED) ~= nil then
		--使用过邀请码  屏蔽一些邀请码相关
		hideInviteCodeAbout()
	end

	--		Image_horn:setVisible(false)
	--		-- Panel_29:setVisible(false)
	--		Button_share:setVisible(false)
	--		Button_recommend:setVisible(false)
	--
	--		Button_add_card:setEnabled(false)
	--		Label_name:setText("")

	addClippingNode()
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameConfig.setTheCurrentBaseLayer(GUI_HALL)
	GameStartConfig.addChildForScene(view)

	initView();
	--	--加载大厅动画
	--	GameArmature.loadFishrmature()
	--
	AudioManager.playBackgroundMusic(AudioManager.TableBgMusic.HALL_BACKGROUND)
	--获取个人消息
	if profile.User.getSelfUserID() > 0 then
		sendMJ_SC_MGR_PLAYER_INFO(profile.User.getSelfUserID())
	end
	--	--播放大厅动画
	--	showHallAnim()
end

function requestMsg()
	sendMJ_SC_HALL_INFO()
	sendGameCommonMessage()

	--自动弹出输入邀请码的弹出框
	--	if Common.getDataForSqlite(CommSqliteConfig.IS_FIRST_GAME) == nil then
	--		Common.setDataForSqlite(CommSqliteConfig.IS_FIRST_GAME,1)
	--		local array = CCArray:create()
	--		array:addObject(CCDelayTime:create(1))
	--		array:addObject(CCCallFuncN:create(
	--			function()
	--				mvcEngine.createModule(GUI_INVITECODE);
	--			end
	--		))
	--		local seq = CCSequence:create(array)
	--		view:runAction(seq)
	--	end

	Common.getClipboard();
end

function showHallAnim()
	GameArmature.createGongGaoAnim(90,585)

	local fenxiangPos = Button_share:getPosition()
	GameArmature.createFenXiangAnim(fenxiangPos.x,fenxiangPos.y)

	local createRoomPos = Button_createroom:getPosition()
	GameArmature.createChuangjianangjianAnim(createRoomPos.x,createRoomPos.y)
	local joinRoomPos = Button_joinroom:getPosition()
	GameArmature.createJiarufangjianAnim(joinRoomPos.x,joinRoomPos.y)


	local recommendPos = Button_recommend:getPosition()
	GameArmature.createAddRoomCardAnim(recommendPos.x,recommendPos.y-6)

end

function removeHallAnim()
	GameArmature.removeGongGaoAnim()
	GameArmature.removeFenXiangAnim()
	GameArmature.removeChuangjianangjianAnim()
	GameArmature.removeJiarufangjianAnim()
	GameArmature.removeAddRoomCardAnim()
end

--[[--
--发送游戏公共消息
--]]
function sendGameCommonMessage()
	if (profile.User.getSelfUserID() ~= 0) then
		--		sendMJ_SC_MGR_PLAYER_INFO(profile.User.getSelfUserID());
		sendMJ_SC_NOTICE(0)
	end
	--	if not GameConfig.mnHallInitSendMsg then
	--		--初始化图片
	--		sendMANAGERID_GET_INIT_PIC(profileCommon.InitImageList.getInitImageListTimestamp());
	--
	--		GameConfig.mnHallInitSendMsg = true
	--	end

	--	if Common.hasWechatAPP() and not ServerConfig.isAppstoreReview() then
	--		--获取微信绑定信息
	--		sendMANAGERID_HINT_BIND_WECHAT();
	--	end
end
function callback_Button_setting(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_SETTING);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_help(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_GAMEHELP)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Image_head_box(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_SELFUSERINFO);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_record(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_ROOMRECORDLIST);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_share(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起

		isSelect = false
		local qrcodeBgScalefullpath = QrcodeUtil.getQRCodePicPath(QrcodeUtil.RECOMMEND_QRCODE_BG_SCALE_NAME)
		local qrcodeBgfullpath = QrcodeUtil.getQRCodePicPath(QrcodeUtil.RECOMMEND_QRCODE_BG_NAME)
		GamePub.sharePicToWX(isSelect,qrcodeBgScalefullpath,qrcodeBgfullpath)

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_service(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_CUSTOMSERVICE)

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_createroom(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起

		GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.MahjongSichuanGameID, GameLoadModuleConfig.MahjongSichuanPackage,"0#0");

	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_joinroom(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.MahjongSichuanGameID, GameLoadModuleConfig.MahjongSichuanPackage,"1#0");
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_mail(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameConfig.setTheLastBaseLayer(GUI_HALL)
		mvcEngine.createModule(GUI_MESSAGELIST)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_add_card(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起

		local baseHallData = profile.MahjongUserInfo.getMJHallInfoTable()
		if next(baseHallData) == nil then
			sendMJ_SC_HALL_INFO()
			Common.showToast("请稍候重试", 2);
		else
			mvcEngine.createModule(GUI_BUYCARD);
		end

	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_exchangeRoomCard(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_EXCHANGEROOMCARD);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_code(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_INVITECODE);
	elseif component == CANCEL_UP then
	--取消

	end
end


function callback_Button_recommend(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_RECOMMEND);
	elseif component == CANCEL_UP then
	--取消

	end
end


function hideInviteCodeAbout()
	-- 目前 计划是 隐藏邀请码输入入口
	Common.setButtonVisible(Button_code, false);
end

--[[----------------------大厅跑马灯-----------------------]]
--初始化遮罩界面
function addClippingNode()
	if Panel_notice == nil then
		return
	end

	local x = Panel_notice:getPosition().x
	local y = Panel_notice:getPosition().y
	local Panel_notice_size = Panel_notice:getContentSize()
	--模板精灵
	local stencil = CCLayerColor:create(ccc4(0,0,0,255));
	stencil:setContentSize(CCSize(Panel_notice_size.width,Panel_notice_size.height))
	stencil:setAnchorPoint(ccp(0.5,0.5))
	--创建一个ClippingNode对象
	m_ClippingNode = CCClippingNode:create();
	--设置模板
	m_ClippingNode:setStencil(stencil)
	--可以使用void setInverted(bool inverted);方法，
	--设置是显示被裁剪的部分，还是显示裁剪。true 显示剩余部分。false显示被剪掉部分
	m_ClippingNode:setInverted(false)

	--添加被剪裁 精灵
	m_ClippingContent = CCSprite:create()
	m_ClippingNode:addChild(m_ClippingContent, 888)

	m_ClippingNode:setAnchorPoint(ccp(0,0))
	m_ClippingNode:setPosition(ccp(x,y))
	view:addChild(m_ClippingNode)
end

function delClippingNode()
	if m_ClippingContent ~= nil then
		m_ClippingContent:removeFromParentAndCleanup(true)
		m_ClippingContent = nil
	end
	if m_ClippingNode ~= nil then
		m_ClippingNode:removeFromParentAndCleanup(true)
		m_ClippingNode = nil
	end

end
--[[--
--创建滚动条跳转机制
--]]
function setMiniGameRollInfoJump(actionId, status)
	Common.log("xwh setMiniGameRollInfoJump actionId " .. actionId .. ";status " .. status)
	local button = ccs.button({
		scale9 = false,
		size = CCSizeMake(500,41),
		pressed = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		normal = Common.getResourcePath("menghei2_hall_gengduo_ic.png"),
		text = "",
		capInsets = CCRectMake(0, 0, 0, 0),
		listener = {
			[ccs.TouchEventType.began] = function(uiwidget)
			end,
			[ccs.TouchEventType.moved] = function(uiwidget)
			end,
			[ccs.TouchEventType.ended] = function(uiwidget)
				Common.log("xiaoyouxi xixixixiixixixi actionId == " .. actionId .. ";status == " .. status)
				--通过ActionId，判断是否为同趣小妹跳转小游戏ID
				if actionId > 0 then
					GameLoadModuleConfig.startMiniGameByID(actionId)
				end
			end,
			[ccs.TouchEventType.canceled] = function(uiwidget)
				Common.log("Touch Cancel")
			end,
		}
	})
	button:setColor(ccc3(196,186,168));
	button:setAnchorPoint(ccp(0,0.4));
	button:setPosition(ccp(0,20));
	button:setScaleX(Panel_notice:getContentSize().width / button:getContentSize().width)
	m_ClippingContent:addChild(labelNotice);
	Panel_notice:addChild(button);
end

--[[--
--创建系统公告label
--@param #string systemNotice 系统公告(文本)
--@param #number textLenWidth 系统公告label的width
--]]
local function createSystemNoticeLabe(systemNotice,chatTable)
	--移除 labelNotice
	-- labelNotice = ccs.label({
	-- 	text = systemNotice,
	-- 	size = CCSizeMake(textLenWidth, Panel_notice:getContentSize().height),
	-- })

	labelNotice = CCLabelTTF:create(""..systemNotice, "Arial", 30)--
	--	labelNotice:setFontSize(25);
	labelNotice:setColor(ccc3(chatTable["colorR"],chatTable["colorG"],chatTable["colorB"]));
	labelNotice:setAnchorPoint(ccp(0,0.6));
	labelNotice:setTag(TAG_LABEL_NOTICE);
	labelNotice:setPosition(ccp(chatPanelSize.width,0));

	if chatTable ~= nil and chatTable ~= "" then
		setMiniGameRollInfoJump(chatTable.actionId, chatTable.status)
	end


end


--隐藏公告
local function hideNotice()
	if labelNotice ~= nil and m_ClippingNode ~= nil and m_ClippingContent ~= nil then
		labelNotice:stopAllActions();
		labelNotice:removeFromParentAndCleanup(true)
		labelNotice = nil;
	end
end

--展示公告
function showNotice()
	if ServerConfig.isAppstoreReview() == true then
		Common.log("AppStore审核版 不显示公告")
		return
	end
	if labelNotice ~= nil then
		return
	end

	local notice = profile.MahjongNotice.getOneNotice()
	if notice == nil or notice == "" then
		return
	end

	chatPanelSize = Panel_notice:getContentSize();
	local textNotice = notice.content
	createSystemNoticeLabe(notice.content,notice);
	if labelNotice == nil then
		return;
	end
	labelNotice:setPosition(ccp(chatPanelSize.width,chatPanelSize.height/2))
	local textLenWidth = labelNotice:getContentSize().width
	--播放系统公告
	local moveBy =  CCMoveBy:create(NOTICE_MOVE_TIME*(textLenWidth + chatPanelSize.width),ccp(-textLenWidth-chatPanelSize.width,0))
	local moveTo = CCMoveTo:create(0.01,ccp(chatPanelSize.width,20))
	local headActioArray = CCArray:create()
	headActioArray:addObject(moveBy)
	--	headActioArray:addObject(moveTo)
	headActioArray:addObject(CCCallFuncN:create(hideNotice))
	headActioArray:addObject(CCCallFuncN:create(showNotice))
	local seq = CCSequence:create(headActioArray)
	labelNotice:runAction(CCRepeatForever:create(seq))
end

--[[--------------------大厅跑马灯end----------------------]]

--[[--
--更新个人头像
--]]
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and Image_head ~= nil) then
		Image_head:loadTexture(photoPath)
	end
end

--[[--
--更新用户信息
--]]
local function updataUserInfo()
	local nickname = profile.User.getSelfNickName()
	if nickname == nil or nickname == "" then
		return;
	end
	local photoUrl = profile.User.getSelfPhotoUrl()
	local fangkaCnt = profile.User.getFangkaCnt()

	Common.log("updataUserInfo updataUserInfo fangkaCnt == "..fangkaCnt)

	if photoUrl ~= nil and photoUrl ~= "" then
		Common.getPicFile(photoUrl, 0, true, updataUserPhoto, true)
	end
	local nickNameStr = Common.SubUTF8String(nickname,1,10)
	Label_name:setText(nickNameStr)
	Label_room_card:setText(""..fangkaCnt)
end


--大厅公告
local function slot_MJ_SC_NOTICE()
	showNotice()
end

--大厅基础信息
local function slot_MJ_SC_HALL_INFO()
end

--领奖
local function slot_MJ_SC_RECEIVE_REWARD()
	local receiverRewardData = profile.MahjongRecommend.getMJReceiveRewardTable()

	-- Result	Byte	0失败1成功
	local Result = receiverRewardData["Result"]
	-- Message	String
	local Message = receiverRewardData["Message"]
	-- curRoomCardNum	int	领取后房卡的数量
	local curRoomCardNum = receiverRewardData["curRoomCardNum"]
	-- receiveType	byte	透传
	local receiveType = receiverRewardData["receiveType"]
	if Result == 1 then
		Label_room_card:setText(""..curRoomCardNum)
		if receiveType == 1 then
			--验证码输入成功  前端标记下
			Common.setDataForSqlite(CommSqliteConfig.INVITE_CODE_USED,1)
			hideInviteCodeAbout()
		end
	end
	Common.showToast(Message,2)
end


function androidExit()
	local tipStr = "亲爱的，您真的要离开了吗？"
	local str = "3#3|"..tipStr;
	GameLoadModuleConfig.startMiniGameByID(GameLoadModuleConfig.MahjongSichuanGameID, GameLoadModuleConfig.MahjongSichuanPackage,str);
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	hideNotice()
	delClippingNode()
	--	removeHallAnim()
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_UPDATE_FANGKA, updataUserInfo)
	framework.addSlot2Signal(MJ_SC_MGR_PLAYER_INFO, updataUserInfo)
	framework.addSlot2Signal(MJ_SC_NOTICE, slot_MJ_SC_NOTICE)--大厅公告

	framework.addSlot2Signal(MJ_SC_HALL_INFO, slot_MJ_SC_HALL_INFO)

	--监听领奖消息  大厅只处理房卡变动 和 toast 返回信息
	framework.addSlot2Signal(MJ_SC_RECEIVE_REWARD, slot_MJ_SC_RECEIVE_REWARD)
end


function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_UPDATE_FANGKA, updataUserInfo)
	framework.removeSlotFromSignal(MJ_SC_MGR_PLAYER_INFO, updataUserInfo)
	framework.removeSlotFromSignal(MJ_SC_NOTICE, slot_MJ_SC_NOTICE)--大厅公告


	framework.removeSlotFromSignal(MJ_SC_HALL_INFO, slot_MJ_SC_HALL_INFO)

	--监听领奖消息  大厅只处理房卡变动 和 toast 返回信息
	framework.removeSlotFromSignal(MJ_SC_RECEIVE_REWARD, slot_MJ_SC_RECEIVE_REWARD)
end
