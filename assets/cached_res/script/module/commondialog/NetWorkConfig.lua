module("NetWorkConfig", package.seeall)

local netErrConnFailed = 0--建立连接失败(每连续出现三次，则弹出网络异常对话框)
local netErrNetBroken = 0--网络断开(开始重连)

local MessageServiceState = "";--当前游戏联网状态
local MessageServiceStateIsChange = false;--游戏联网状态是否变化
local NETERR_CONN_FAILED = "NETERR_CONN_FAILED";--建立连接失败
local NETERR_NET_BROKEN = "NETERR_NET_BROKEN";--网络断开(开始重连)
local NETERR_CONN_SUCC = "NETERR_CONN_SUCC";--重连成功
local NETERR_CONN_HOST_FAILED = "NETERR_CONN_HOST_FAILED";--获取host失败

--[[--
--设置游戏联网状态
--]]
function setMessageServiceState(state)
	MessageServiceState = state;
end

--[[--
--获取当前游戏联网状态
--]]
function getMessageServiceState()
	return MessageServiceState;
end


function setMessageStateIsChange(isChange)
	MessageServiceStateIsChange = isChange;
end

function getMessageStateIsChange()
	if PublicLuaBridge ~= nil and PublicLuaBridge:getInstance().socketState ~= nil then
		--新版本的socket状态监测逻辑
		local ServiceState = PublicLuaBridge:getInstance():getMessageServiceState();
		if ServiceState == "" or ServiceState == "error" then
			Common.log("ServiceState ============ "..ServiceState)
			return false;
		end
		if MessageServiceState ~= ServiceState then
			Common.log("ServiceState ============ "..ServiceState)
			setMessageServiceState(ServiceState);
			setMessageStateIsChange(true);
		end
	end
	return MessageServiceStateIsChange;
end

function resetMessageState()
	setMessageStateIsChange(false);--重置连接状态变化标示
	setMessageServiceState("");--重置连接状态
end

--[[--
--切出游戏
--]]
local function applicationEnterBackground()
	Common.log("game Enter Background")
end

--[[--
--进入游戏
--]]
local function applicationEnterForeground()
	Common.log("game Enter Foreground")

	NetworkMonitor.initLastRecvTime();

	if Common.platform == Common.TargetIos then
	--逻辑在C++层实现
	elseif Common.platform == Common.TargetAndroid then
		if GameConfig.getGameMusicOff() then
			SimpleAudioEngine:sharedEngine():resumeBackgroundMusic();
		end
	end

	if GameConfig.isConnect then
		--如果已经建立过连接，则重连
		Services:getMessageService():closeSocket();
		if LoginConfig.isHasUserInfo() then
			--有用户数据and不是新手引导状态，则移除之前的积压消息
			Services:getMessageService():removeAllMessage();
		end
		GameCommonProfile.ServerList.startPingConnect();
	end
end

--[[--
--设置游戏切出/切入状态
--]]
local function EnterGameScriptHandler(state)
	if state == "EnterBackground" then
		applicationEnterBackground();
	elseif state == "EnterForeground" then
		applicationEnterForeground();
	end
end

if PublicLuaBridge ~= nil then
	PublicLuaBridge:getInstance():registerEnterGameScriptHandler(EnterGameScriptHandler);
end

--[[--
--建立连接失败(每连续出现三次，则弹出网络异常对话框)
--]]
local function netErrConnFailedFun()
	if CommDialogConfig.getIsNetKickOff() then
		return;
	end
	Common.log("建立连接失败(每连续出现三次，则弹出网络异常对话框)")
	netErrConnFailed = netErrConnFailed + 1
	if netErrConnFailed >= 3 then
		netErrConnFailed = 0;
		netErrNetBroken = 0;
		--断线提示退出
		Services:getMessageService():stopConnect();
		Services:getMessageService():closeSocket();
		GameCommonProfile.ServerList.startPingConnect(2);--建立连接失败，直接ping域名
	--		if GameConfig.getTheCurrentBaseLayer() == GUI_LOADING then
	--			--loading过程中断网，跳转到登录界面
	--			mvcEngine.createModule(GUI_LOGIN);
	--		elseif GameConfig.getTheCurrentBaseLayer() == GUI_STAND_ALONE_TABLE then
	--			Common.log("netErrConnFailedFun 单机斗地主界面不重连");
	--		else
	--			if not NetErrExitDialogLogic.viewIsRunning() then
	--				mvcEngine.createModule(GUI_NETERREXITDIALOG);
	--			end
	--		end
	end
end

--[[--
--网络断开(开始重连)
--]]
local function netErrNetBrokenFun()
	if CommDialogConfig.getIsNetKickOff() then
		return;
	end
	Common.log("网络断开(开始重连)  "..netErrNetBroken)
	netErrNetBroken = netErrNetBroken + 1
	--	if netErrNetBroken == 1 then
	--		if GameConfig.isConnect then
	--			GameConfig.isConnect = false;
	--			--Common.showToast("您的网络已断开，正在帮您重连...", 2);
	--			if GameConfig.getTheCurrentBaseLayer() == GUI_STAND_ALONE_TABLE then
	--				Common.log("netErrNetBrokenFun 单机斗地主界面不重连");
	--				return;
	--			end
	--			-- Services:getMessageService():closeSocket();
	--			-- GameCommonProfile.ServerList.startPingConnect();
	--		end
	--	end
end

--[[--
--重连成功(如果是没有出现连接失败的成功，则不是重连)
--]]
local function netErrConnSuccFun()
	--如果已经提示强制退出，则不再重联
	if CommDialogConfig.getIsNetKickOff() then
		return;
	end

	NetworkMonitor.initLastRecvTime();--重连成功以后重置超时时间帧
	Services:getMessageService():setWaitReconnect(false);--已经连接成功，设置为不再等待连接

	ResumeSocket("Connect");
	if netErrNetBroken > 0 or GameConfig.isConnect then
		--重连成功
		netErrNetBroken = 0;
		if GameConfig.isConnect then
			Common.log("重连成功");
		else
			GameConfig.isConnect = true;
			Common.log("连接成功(如果是没有出现连接失败的成功，则不是重连)");
		end
	else
		--首次连接成功
		GameConfig.isConnect = true;
		Common.log("首次连接成功");
	end
	if Common.isDebugState() and GameConfig.getTheCurrentBaseLayer() == GUI_LOGIN then
		LoginLogic.setIpLable();
	end

	if NetErrExitDialogLogic.viewIsRunning() then
		mvcEngine.destroyModule(GUI_NETERREXITDIALOG);
	end

	if LoginConfig.sendWeChatLoginMessage() then
        --微信登录逻辑已触发，不再向下处理
	    return;
	end

	if GameConfig.getTheCurrentBaseLayer() == GUI_LOADING then
		--loading界面重新建立连接后，重新走登录流程
		LoadingLogic.startLoginGame();
		return;
	end

	if not LoginConfig.isHasUserInfo() then
		--没有用户数据
		Common.log("连接以后没有用户数据,重新执行登录流程")
		LoadingLogic.startLoginGame();
		return;
	end

	if not (Common.isDebugState() and GameConfig.getTheCurrentBaseLayer() == GUI_LOGIN) then
		--非（debug模式并且在登录界面）
		CommDialogConfig.netlogin();
	end
end

--[[--
--设置socket连接状态
--]]
function updateMessageServiceState()
	if not getMessageStateIsChange() then
		Common.log("socket连接状态 =========Error========= 没有变化")
		return
	end
	setMessageStateIsChange(false);--重置连接状态变化标示
	local state = getMessageServiceState();
	Common.log("设置socket连接状态 MessageServiceState ======= "..state)
	if (state == "NETERR_CONN_FAILED") then
		--建立连接失败
		setMessageServiceState("");--重置连接状态
		netErrConnFailedFun();
	elseif (state == "NETERR_NET_BROKEN") then
		--网络断开(开始重连)
		netErrNetBrokenFun();
	elseif (state == "NETERR_CONN_SUCC") then
		--重连成功
		netErrConnSuccFun();
	elseif (state == "NETERR_CONN_HOST_FAILED") then
	--获取host失败
	end

end

local function MessageServiceScriptHandler(state)
	if type(state) ~= "string" then
		--Common.log("MessageService state error type == " .. type(state));
		return;
	end
	--Common.log("callback lua MessageService state == " .. state);
	setMessageServiceState(state);
	setMessageStateIsChange(true);
end

if PublicLuaBridge ~= nil and PublicLuaBridge:getInstance().socketState == nil then
	--老版本的socket状态监测逻辑
	PublicLuaBridge:getInstance():registerMessageServiceScriptHandler(MessageServiceScriptHandler);
end

--[[--
--ping连接失败(弹出网络异常对话框)
--]]
function pingErrConnFailedFun()
	GameConfig.isConnect = true;
	Services:getMessageService():setFristConnect(true);
	Common.log("ping失败(弹出网络异常对话框)")
	--断线提示退出
	if GameConfig.getTheCurrentBaseLayer() == GUI_LOADING then
		--loading过程中断网，跳转到登录界面
		mvcEngine.createModule(GUI_LOGIN);
	else
		if not NetErrExitDialogLogic.viewIsRunning() then
			mvcEngine.createModule(GUI_NETERREXITDIALOG);
		end
	end
end