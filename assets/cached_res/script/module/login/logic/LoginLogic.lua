module("LoginLogic",package.seeall)

view = nil;

Panel_20 = nil;--
btn_reg = nil;--
lable_ip_text = nil;--
Image_text_login = nil;--
check_agree = nil;--
ImageView_ip = nil;--
btn_setIp = nil;--
btn_showLog = nil;--
Panel_login_btn = nil;--
btn_weixin_login = nil;--
btn_olduser_login = nil;--
Panel_login = nil;--
--btn_more = nil;--
ImageView_password = nil;--
btn_login = nil;--
Button_login_close = nil;--
ImageView_username = nil;--



local userIDvalue = 0
local usernamevalue = nil
local passwordvalue = nil
local lookTimer = nil --时间计时器
local fx = nil--移动方向 1向左，0向右

local port = 65002;--连接端口

edit_username = nil;  --新输入框
edit_password = nil;
edit_ip = nil;

currentTxtInput = nil; --当前文本输入框
currentTxtShow = nil; --当前文本显示
defaultValueLabelsTable ={}; --label的默认值table
defaultValueLabel = "";--label默认值

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		Common.AndroidExitSendOnlineTime()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_LOGIN;
	if GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("Login.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	else
		--适配方案 960x640
		view = cocostudio.createView("Login.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	btn_reg = cocostudio.getUIButton(view, "btn_reg");
	lable_ip_text = cocostudio.getUILabel(view, "lable_ip_text");
	Image_text_login = cocostudio.getUIImageView(view, "Image_text_login");
	check_agree = cocostudio.getUICheckBox(view, "check_agree");
	ImageView_ip = cocostudio.getUIImageView(view, "ImageView_ip");
	btn_setIp = cocostudio.getUIButton(view, "btn_setIp");
	btn_showLog = cocostudio.getUIButton(view, "btn_showLog");
	Panel_login_btn = cocostudio.getUIPanel(view, "Panel_login_btn");
	btn_weixin_login = cocostudio.getUIButton(view, "btn_weixin_login");
	btn_olduser_login = cocostudio.getUIButton(view, "btn_olduser_login");
	Panel_login = cocostudio.getUIPanel(view, "Panel_login");
--	btn_more = cocostudio.getUIImageView(view, "btn_more");
	ImageView_password = cocostudio.getUIImageView(view, "ImageView_password");
	btn_login = cocostudio.getUIButton(view, "btn_login");
	Button_login_close = cocostudio.getUIButton(view, "Button_login_close");
	ImageView_username = cocostudio.getUIImageView(view, "ImageView_username");

	local logoUrl = GameChannelConfig.getLogoUrl()
	if logoUrl ~= nil then
		Image_logo:loadTexture(logoUrl)
	end

	check_agree:setSelectedState(true);

	Button_login_close:setTouchEnabled(false)
	--新的输入框
	createUsernameEditor();
end

local function changeUserName()
	if LoginConfig.getLoginUserID() ~= 0 then
		LoginConfig.setLoginUserID(0);
	end
end

--创建玩家名输入框
function createUsernameEditor()
	local editBoxSize = CCSizeMake(300, 46)
	--名字输入框
	local pos = ImageView_username:getParent():convertToWorldSpace(ImageView_username:getPosition())
	edit_username = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
	edit_username:setPosition(ccp(pos.x,pos.y))
	edit_username:setAnchorPoint(ccp(0.5, 0.5))

	edit_username:setFont("微软雅黑", 22)
	edit_username:setFontColor(ccc3(0xae, 0x91, 0x72))
	edit_username:setPlaceHolder("输入账号")
	edit_username:setMaxLength(32)
	edit_username:setReturnType(kKeyboardReturnTypeDone)
	edit_username:setInputMode(kEditBoxInputModeSingleLine);

	edit_username:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	EditBoxListener.setEditBoxFinishCallBack(edit_username, changeUserName);
	view:addChild(edit_username)

	--密码输入框
	pos = ImageView_password:getParent():convertToWorldSpace(ImageView_password:getPosition())
	edit_password = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
	edit_password:setPosition(ccp(pos.x,pos.y))
	edit_password:setAnchorPoint(ccp(0.5, 0.5))
	edit_password:setFont("微软雅黑", 22)
	edit_password:setFontColor(ccc3(0xae, 0x91, 0x72))
	edit_password:setPlaceHolder("输入密码")
	edit_password:setMaxLength(32)
	edit_password:setReturnType(kKeyboardReturnTypeDone)
	edit_password:setInputMode(kEditBoxInputModeSingleLine);

	edit_password:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	view:addChild(edit_password)

	--ip输入框
	edit_ip = CCEditBox:create(editBoxSize, CCScale9Sprite:create(Common.getResourcePath("ui_opacity_1.png")))
	edit_ip:setPosition(ccp(200, 937))
	edit_ip:setAnchorPoint(ccp(0.5, 0))
	edit_ip:setFont("微软雅黑", 22)
	edit_ip:setFontColor(ccc3(0xae, 0x91, 0x72))
	edit_ip:setPlaceHolder("ip")
	edit_ip:setMaxLength(32)
	edit_ip:setReturnType(kKeyboardReturnTypeDone)
	edit_ip:setInputMode(kEditBoxInputModeAny);

	edit_ip:registerScriptEditBoxHandler(EditBoxListener.editBoxTextEventHandle)
	view:addChild(edit_ip)
	edit_ip:setVisible(Common.isDebugState())

end

--屏蔽输入框
function setEditorEnable(isTouch)
	edit_username:setTouchEnabled(isTouch)
	edit_password:setTouchEnabled(isTouch)
	edit_ip:setTouchEnabled(isTouch)
end

--[[--
--设置显示IP
--]]
function setIpLable()
	local ip = "";
	if #MassageConnect.getServerIpList() == 1 then
		ip = MassageConnect.getServerIpList()[1];
	else
		local index = math.random(1, #MassageConnect.getServerIpList());
		ip = MassageConnect.getServerIpList()[index]
	end
	if GameConfig.isConnect then
		lable_ip_text:setText("连接:"..ip..":"..port);
	else
		lable_ip_text:setText("无连接");
	end
	Common.log("设置显示IP ========== "..ip);
	edit_ip:setText(ip);
end

--[[--
--初始化Text label
--]]
local function initTextLabel()
	if Common.isDebugState() then
		setIpLable();
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());

	GameConfig.setTheCurrentBaseLayer(GUI_LOGIN)

	GameStartConfig.addChildForScene(view)

	HallModeConfig.setHallShowMode(0)--大厅模式

	if GameConfig.isConnect then
		--建立连接才发送消息
		sendMANAGERID_USERLIST_FROM_IMIE();
	end

	Common.closeLogo();

	--初始化控件
	initView();
	--初始化Text label
	initTextLabel();
	--自动登录
	local bIsHasData, nUserID, sUsernamevalue, sPasswordvalue = LoginConfig.getLastUserInfo();
	if bIsHasData then
		LoginConfig.setLoginUserID(nUserID);
		LoginConfig.setLoginUserName(sUsernamevalue);
		if sPasswordvalue == "" then
			sPasswordvalue = GameConfig.DefaultPassword;
		end
		LoginConfig.setLoginPassword(sPasswordvalue);

		edit_username:setText(LoginConfig.getLoginUserName());
		edit_password:setText(LoginConfig.getLoginPassword());
	else
		local NickName = profileCommon.MoreUser.geLastLoginUserName();
		if NickName ~= nil then
			Common.log("LastLoginUserName ======== "..NickName);
			LoginConfig.setLoginUserName(NickName);
			edit_username:setText(LoginConfig.getLoginUserName());
		end
	end
	setPanelLoginVisible(false)
	setLoginChoseVisible(true)
	if not Common.isDebugState() then
		ImageView_ip:setVisible(false);
		lable_ip_text:setVisible(false);
		Common.setButtonVisible(btn_reg, false);
		Common.setButtonVisible(btn_setIp, false);
		Common.setButtonVisible(btn_showLog, false);
		Common.setButtonVisible(btn_olduser_login, false);
	end
	if ServerConfig.isAppstoreReview() then
		--评审中
		Common.setButtonVisible(btn_weixin_login, false);
		Common.setButtonVisible(btn_reg, true);
        Common.setButtonVisible(btn_olduser_login, true);
		btn_reg:setPosition(btn_weixin_login:getParent():convertToWorldSpace(btn_weixin_login:getPosition()))
	end
end

function requestMsg()

end

local function login()
	LoginConfig.setLoginUserName(edit_username:getText());
	LoginConfig.setLoginPassword(edit_password:getText());

	Common.log("username === "..LoginConfig.getLoginUserName());
	Common.log("password === "..LoginConfig.getLoginPassword());
	Common.log("UserID === "..LoginConfig.getLoginUserID());

	local agreeflag = check_agree:getSelectedState()
	if agreeflag then
		if (LoginConfig.getLoginUserName() ~= nil and LoginConfig.getLoginPassword() ~= nil) then
			sendBASEID_LOGIN(LoginConfig.getLoginUserID(), LoginConfig.getLoginUserName(), LoginConfig.getLoginPassword(), Common.getDeviceInfo());
		else
			Common.showToast("用户名或密码不能为空", 2)
		end
	else
		Common.showToast("请先同意同趣游戏用户协议", 2)
	end
end

function callback_btn_login(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		login();
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_reg(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		local agreeflag = check_agree:getSelectedState()
		if agreeflag then
			sendBASEID_REGISTER(Common.getDeviceInfo())
		else
			Common.showToast("请先同意同趣游戏用户协议", 2)
		end
	elseif component == CANCEL_UP then
	--取消
	end
end

--function callback_btn_more(component)
--	if component == PUSH_DOWN then
--	--按下
--
--	elseif component == RELEASE_UP then
--		--抬起
--		if  profileCommon.MoreUser.getUserSize() == 0 then
--			--如果没有NickName信息,不展开
--			return;
--		end
--		mvcEngine.createModule(GUI_MORE)
--		MoreLogic.setCurViewTag(MoreLogic.getViewTag().LOGIN);
--		MoreLogic.setPanelPosition(Panel_login:getPosition().x + ImageView_username:getPosition().x, Panel_login:getPosition().y + ImageView_username:getPosition().y - ImageView_username:getContentSize().height / 2)
--		MoreLogic.setRotationInfo(Image_more);
--	elseif component == CANCEL_UP then
--	--取消
--
--	end
--end

function callback_Image_text_login(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_USERAGREEMENT)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_btn_setIp(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if Common.isDebugState() then
			local Value = edit_ip:getText();
			local i, j = string.find(Value, ":");
			NetWorkConfig.resetMessageState("");
			PublicLuaBridge:getInstance():changeMessageServiceState(-1);
			Services:getMessageService():setWaitReconnect(true);
			if i ~= nil and j ~= nil then
				local ip = string.sub(Value, 1, i - 1);
				port = string.sub(Value, j + 1, -1);
				MassageConnect.reConnect(ip, tonumber(port));
			else
				MassageConnect.reConnect(Value, tonumber(port));
			end
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_showLog(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GameCommonConfig.showLogListView();
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_login_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanelLoginVisible(false)
		setLoginChoseVisible(true)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_weixin_login(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if Common.hasWechatAPP() then
			Common.getWeChatUserinfo(LoginConfig.WECHAT_LOGIN);
		else
			Common.showToast("请安装微信!", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_olduser_login(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		setPanelLoginVisible(true);
		setLoginChoseVisible(false);
	elseif component == CANCEL_UP then
	--取消

	end
end

function setPanelLoginVisible(isVisible)
	Panel_login:setVisible(isVisible)
	edit_username:setTouchEnabled(isVisible)
	edit_username:setVisible(isVisible)
	edit_password:setTouchEnabled(isVisible)
	edit_password:setVisible(isVisible)
	Button_login_close:setTouchEnabled(isVisible)
	btn_login:setTouchEnabled(isVisible)
--	btn_more:setTouchEnabled(isVisible)

	if ServerConfig.isAppstoreReview() then
--		Common.setButtonVisible(btn_more, false);
	end
end

function setLoginChoseVisible(isVisible)
	btn_olduser_login:setVisible(isVisible)
	btn_olduser_login:setTouchEnabled(isVisible)
	btn_weixin_login:setVisible(isVisible)
	btn_weixin_login:setTouchEnabled(isVisible)
	if ServerConfig.isAppstoreReview() then
		--AppStore评审期间
		Common.setButtonVisible(btn_weixin_login, false);
		Common.setButtonVisible(btn_reg, isVisible);
		btn_reg:setPosition(btn_weixin_login:getParent():convertToWorldSpace(btn_weixin_login:getPosition()));
	end
end

function slot_MoreUser()
	LoginConfig.setLoginUserName(profileCommon.MoreUser.getLoginWithMore())

	edit_username:setText(LoginConfig.getLoginUserName())

	local userIDAndPassword = Common.getDataForSqlite(CommSqliteConfig.UserNicknameAndPassword .. LoginConfig.getLoginUserName())
	if userIDAndPassword == nil or userIDAndPassword == ""  then
		LoginConfig.setLoginUserID(0);
		LoginConfig.setLoginPassword(GameConfig.DefaultPassword);
		edit_password:setText(GameConfig.DefaultPassword);
	else
		local i, j = string.find(userIDAndPassword, "#")
		local userID = string.sub(userIDAndPassword, 1, i-1)
		local password = string.sub(userIDAndPassword, j+1, -1)

		LoginConfig.setLoginUserID(userID);
		LoginConfig.setLoginPassword(password);

		Common.log("slot_MoreUser UserID =========== "..LoginConfig.getLoginUserID())
		Common.log("slot_MoreUser username =========== "..LoginConfig.getLoginUserName())
		Common.log("slot_MoreUser password =========== "..LoginConfig.getLoginPassword())

		edit_password:setText(LoginConfig.getLoginPassword())
	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
end

function addSlot()
	framework.addSlot2Signal(BASEID_LOGIN, LoginConfig.loginManage)
	framework.addSlot2Signal(BASEID_REGISTER, LoginConfig.RegisterManage)
	framework.addSlot2Signal(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME, slot_MoreUser) --点击more之后username要改
end

function removeSlot()
	framework.removeSlotFromSignal(BASEID_LOGIN, LoginConfig.loginManage)
	framework.removeSlotFromSignal(BASEID_REGISTER, LoginConfig.RegisterManage)
	framework.removeSlotFromSignal(signal.common.Signal_BASEID_GET_LOGINCHANEUSERNAMME, slot_MoreUser)
end
