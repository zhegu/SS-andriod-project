module("LoginConfig", package.seeall)

WECHAT_BIND = "wechat_bind" --微信绑定,用于微信登录透传
WECHAT_LOGIN = "wechat_login"--微信登录,用于微信登录透传

local WechatInfo = {}  --微信登陆回调信息

function getWechatInfo()
	return WechatInfo;
end

function getWeChatToken()
	local userInfo = Common.LoadShareTable(CommSqliteConfig.LAST_LOGIN_TOKEN);
	if userInfo ~= nil and next(userInfo) ~= nil and userInfo.token ~= "" then
		return userInfo.token;
	end
	return nil;
end

function setWeChatToken(token)
	Common.log("setWeChatToken token = " .. token);
	local userInfo = Common.LoadShareTable(CommSqliteConfig.LAST_LOGIN_TOKEN);
	if userInfo ~= nil and next(userInfo) ~= nil and userInfo.token == token then
		return;
	end
	local userInfo = {};
	userInfo.token = token
	Common.SaveShareTable(CommSqliteConfig.LAST_LOGIN_TOKEN, userInfo);
end

--[[--
--微信登录native的回调(android)
--]]--
function setWechatLoginDataForAndroid(wechatData)
	local UserTable = Common.FGUtilStringSplit(wechatData, "#")
	Common.log("setWechatLoginData length == "..#UserTable)
	WechatInfo = {};
	WechatInfo.code = UserTable[1];
	WechatInfo.openId = UserTable[2];
	WechatInfo.state = UserTable[3];
	WechatInfo.transaction = UserTable[4];
	WechatInfo.url = UserTable[5];
	Common.log("setWechatLoginData code == "..WechatInfo.code)
	Common.log("setWechatLoginData state == "..WechatInfo.state)
	Common.log("setWechatLoginData url == "..WechatInfo.url)
	if WechatInfo.code == "-1" or WechatInfo.state == "-1" then
		Common.showNativeToast("登录失败，请重试！", 2);
		return;
	end
end

--[[--
--微信登录native的回调(IOS)
--]]--
function setWechatLoginDataForIOS(wechatData)
	WechatInfo = {};
	WechatInfo.code = wechatData["wxcode"];
	WechatInfo.state = wechatData["wxstate"];
	--	Common.log("setWechatLoginData code == "..WechatInfo.code)
	--	Common.log("setWechatLoginData state == "..WechatInfo.state)
	if WechatInfo.code == "-1" or WechatInfo.state == "-1" then
		Common.showToast("微信信息获取失败，请稍后重试！", 2);
		return;
	end
end

--[[--
-- 微信登出
--]]
function setWechatLogout()
	WechatInfo = {};
	local userInfo = {};
	userInfo.token = ""
	Common.SaveShareTable(CommSqliteConfig.LAST_LOGIN_TOKEN, userInfo);
end

--[[--
--绑定微信
--]]--
function bindWechatUserInfo()
	if WechatInfo.code == nil then
		return;
	end
	--发消息
	local strToken = WechatInfo.code
	sendMANAGERID_WECHAT_BIND(strToken)
	if WechatInfo.state ~= nil then
		WechatInfo.state = -1;--清除数据
	end
	CommDialogConfig.showProgressDialog();
end

--[[--
--微信登陆
--]]
function sendWeChatThirdPartLogin()
	if WechatInfo.code == nil and getWeChatToken() == nil then
		return;
	end
	local strToken = ""
	if getWeChatToken() ~= nil then
		strToken = getWeChatToken();
	end
	if WechatInfo.code ~= nil then
		strToken = WechatInfo.code;
	end
	local strThirdPartPlatUID = ""
	local nThirdPartPlatId = 15 --微信
	local lastUsername = "" --java
	local lastPassword = "" --java
	--	local bIsHasData, nUserID, sUsernamevalue, sPasswordvalue = getLastUserInfo();
	--	if bIsHasData then
	--		if sPasswordvalue == "" then
	--			sPasswordvalue = GameConfig.DefaultPassword;
	--		end
	--		lastUsername = sUsernamevalue;
	--		lastPassword = sPasswordvalue;
	--	end
	--	sendBASEID_THIRD_PART_PLAT_LOGIN(strToken, strThirdPartPlatUID, nThirdPartPlatId, lastUsername, lastPassword);
	sendMAHJONG_THIRD_PART_PLAT_LOGIN(strToken)
	if WechatInfo.state ~= nil and WechatInfo.state ~= -1 then
		WechatInfo.state = -1;--清除数据
		CommDialogConfig.showProgressDialog();
	end
end

function sendWeChatLoginMessage()
	local isNeedReturn = false;
	if next(getWechatInfo()) ~= nil then
		--可以使用微信登录
		Common.log("可以使用微信登录 ================")
		if getWechatInfo().state == WECHAT_LOGIN then
			--微信登录/注册
			--微信注册账号，微信登录老账号
			Common.log("重连以后需要发送 微信登录/注册");
			sendWeChatThirdPartLogin();
			isNeedReturn = true;
		end
	end
	return isNeedReturn;
end

function sendWeChatBindMessage()
	if next(getWechatInfo()) ~= nil then
		--可以使用微信登录
		Common.log("可以使用微信绑定 ================")
		if getWechatInfo().state == WECHAT_BIND then
			--微信绑定
			Common.log("重连以后需要发送 微信绑定");
			bindWechatUserInfo();
		end
	end
end


function getLoginUserID()
	return mUserIDValue;
end

function setLoginUserID(userID)
	mUserIDValue = userID;
end

function getLoginUserName()
	return mUserNameValue;
end

function setLoginUserName(username)
	mUserNameValue = username;
end

function getLoginPassword()
	return mPasswordValue;
end

function setLoginPassword(password)
	mPasswordValue = password;
end

--[[--
--界面收到登录消息后处理
--]]--
function loginManage()
	local result = profile.User.getUserInfo().Result
	local resultText = profile.User.getUserInfo().ResultTxt

	if ServerConfig.isAppstoreReview() then
		if (result == 0) then

		else

		end

		return
	end


	if (result == 0) then

		--是微信登录用户
		if WechatInfo.code ~= nil then
			setWeChatToken(WechatInfo.code);
		end

		mvcEngine.createModule(GUI_HALL)
	else
		if GameConfig.getTheCurrentBaseLayer() == GUI_LOADING then
			--不使用微信登录
			mvcEngine.createModule(GUI_LOGIN)
		elseif GameConfig.getTheCurrentBaseLayer() == GUI_LOGIN then
			Common.showToast(resultText, 2)
		end
	end
end

--[[--
--界面收到注册消息后处理
--]]--
function RegisterManage()
	local result = profile.User.getUserInfo().Result
	local resultText = profile.User.getUserInfo().ResultTxt

	if ServerConfig.isAppstoreReview() then
		if (result == 0) then
		else
		end

		return
	end

	if (result == 0) then
		if not ServerConfig.isAppstoreReview() then
		end
		mvcEngine.createModule(GUI_HALL);
	else
		if GameConfig.getTheCurrentBaseLayer() == GUI_LOADING then
			mvcEngine.createModule(GUI_LOGIN)
		elseif GameConfig.getTheCurrentBaseLayer() == GUI_LOGIN then
			Common.showToast(resultText, 2)
		end
	end
end
