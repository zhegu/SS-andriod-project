module("NetworkMonitor", package.seeall)

--心跳发送间隔
local IDLE_INTERVAL = 4;--秒
local TIMER = 0.1;--定时器时间间隔
local mnLastRecvTime = 0;--上次收到消息的时间戳
local lookTimer = nil;--时间计时器

--[[--
--设置上一次收到心跳的时间
--]]
function initLastRecvTime()
	mnLastRecvTime = os.time();
end

local lastIdleTime = 0;--上次心跳时间
local currentTime = 0;--当前时间
function sendBeat()
    currentTime = os.time();
    if (lastIdleTime <= 0) then
        lastIdleTime = os.time();
    end
    if (currentTime - lastIdleTime >= IDLE_INTERVAL) then
        lastIdleTime = currentTime;
        sendIdleMsg();
    end
end

--[[--
--判断当前网络状况
--]]
local function logicNetwork()
    if getSocketIsPause() then
        Common.log("暂停接收消息");
    end

	if NetWorkConfig.getMessageStateIsChange() then
		NetWorkConfig.updateMessageServiceState();
	end
	if GameConfig.isConnect then
		--已经建立连接
        sendBeat();

		local currTime = os.time();
		if mnLastRecvTime == 0 then
			initLastRecvTime();
		end
		--Common.log("间隔============= "..(currTime - mnLastRecvTime))
		if currTime - mnLastRecvTime > IDLE_INTERVAL * 2 then
			initLastRecvTime();

			Common.log("两次心跳未收到消息主动连接");
		    --Common.showToast("网络超时了，请稍后重试", 2);
			Common.showToast(Localize.getLocalizeString(LocalizeStrings.strings["网络超时了请稍后重试"]), 2)
			
			Services:getMessageService():closeSocket();
            GameCommonProfile.ServerList.startPingConnect();
		end
	end

	--检测脚本是否下载完毕
	LuaUpdateConfig.logicDowloadFileDone();
end

--[[--
--启动网络监测
--]]
function startNetworkMonitor()
    Common.log("启动网络监测 ======= ")
	if lookTimer == nil then
		--定时器
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(logicNetwork, TIMER, false);
	end
end

--[[--
--关闭网络监测
--]]
function closeNetworkMonitor()
	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
		lookTimer = nil;
	end
end