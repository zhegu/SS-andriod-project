module(..., package.seeall)

--服务器地址数据更新
local nativeServerList = {};

local ServerList = {};

local DNSServerList = {};

if not Load.isGlobalApp() then
	--国内版
	if GameChannelConfig.getChannelIsLianYun() then
		--联运渠道
		nativeServerList = {
			"101.200.152.71",
			"139.196.25.54",
			"120.24.189.8"
		};
		ServerList = {
			"101.200.152.71",
			"139.196.25.54",
			"120.24.189.8"
		};
		DNSServerList = {
			"cog97.tongqutongqu.cn",
			"cog98.tongqutongqu.cn",
			"cog99.tongqutongqu.cn"
		};
	else
		--主渠道
		nativeServerList = {
			"123.57.72.206",
			"139.196.169.104",
			"120.25.65.132"
		};

		ServerList = {
			"123.57.72.206",
			"139.196.169.104",
			"120.25.65.132"
		};

		DNSServerList = {
			"g97.tongqutongqu.cn",
			"g98.tongqutongqu.cn",
			"g99.tongqutongqu.cn"
		};
	end
else
	--国际版
	nativeServerList = {
		--	"123.57.213.228",
		--	"59.124.73.186",
		--	"220.128.180.110"
		"59.124.73.186"
	};

	ServerList = {
		--	"123.57.213.228",
		--	"59.124.73.186",
		--	"220.128.180.110"
		"59.124.73.186"
	};

	DNSServerList = {
		"eng97.tongqutongqu.cn",
		"eng98.tongqutongqu.cn",
		"eng99.tongqutongqu.cn"
	};
end

local ImportMessageList = {
	0x80000000,
};

local PingAddrTime = {}--是连接使用的时间

function setPingAddrStartTime(key, value)
	if PingAddrTime[key] == nil then
		PingAddrTime[key] = {};
	end
	PingAddrTime[key].TimeStart = value;
	Common.setPingFunnelModel(Common.PingStartFunnelModel, key .. " Start");
end

function setPingAddrEndTime(key, value)
	if PingAddrTime[key] == nil then
		PingAddrTime[key] = {};
	end
	PingAddrTime[key].TimeEnd = value;
	Common.setPingFunnelModel(Common.PingEndFunnelModel, key .. " Succ");
	local time = getPingAddrTime(key);
	if time >= 0 then
		Common.setPingFunnelModel(Common.PingTimeFunnelModel, key .. " 消耗时间 " .. math.floor(time/100).."百毫秒");
	end
end

function getPingAddrTime(key)
	if PingAddrTime[key] ~= nil and PingAddrTime[key].TimeStart ~= nil and PingAddrTime[key].TimeEnd ~= nil then
		return PingAddrTime[key].TimeEnd - PingAddrTime[key].TimeStart;
	end
	return -1;
end

local lookTimer = nil --时间计时器

--[[--
--获取不暂停的消息列表
--]]
function getImportServerList()
	return ImportMessageList;
end

--[[--
--添加不暂停的消息
--]]
function addUnpauseServerList(MessageList)
	local messageService = Services:getMessageService();
	for index, MessageID in pairs(MessageList) do
		--4294967296 = 2的32次方
		--2147483648 = 2的16次方
		if(MessageID >= 2147483648) then
			MessageID = -4294967296 + MessageID
		end
		messageService:setImportMessage(MessageID)
	end
end

function debugServerList()
	return ServerList;
end

--[[--
--ping IP地址
--]]
local function updatePingIPServerList()

	--	local ServerListEnableTable = Common.LoadTable("EnableServerList_V2")
	--
	--	if ServerListEnableTable ~= nil and #ServerListEnableTable > 0 then
	--		ServerList = {}
	--		for i = 1, #ServerListEnableTable do
	--			Common.log("可用Ip === " .. ServerListEnableTable[i].EnableServerIP)
	--			table.insert(ServerList, ServerListEnableTable[i].EnableServerIP)
	--		end
	--	end
	--	Common.log("ServerList num === ".. #ServerList)
	--	if Common.isDebugState() then
	--		ServerList = MassageConnect.getServerIpList()
	--	end
	ServerList = MassageConnect.getServerIpList()
end

--[[--
--ping 域名
--]]
local function updatePingDomainServerList()

	local EnableDomainListTable = Common.LoadTable("EnableDomainList_V2")

	if EnableDomainListTable ~= nil and #EnableDomainListTable > 0 then
		for i = 1, #EnableDomainListTable do
			DNSServerList = {}
			local isHave = false
			Common.log("可用域名 === " .. EnableDomainListTable[i].EnableServerIP)
			table.insert(DNSServerList, EnableDomainListTable[i].EnableServerIP)
		end
	end
	Common.log("DNSServerList num === ".. #DNSServerList)
	if Common.isDebugState() then
		DNSServerList = MassageConnect.getServerIpList()
	end
end


local pingBrightIp = 1;--ping明ip
local pingDarkIp = 2;--ping暗ip
local pingNativeIp = 3;--ping本地ip

--[[--
--获取精确IP列表的url
--]]
--local function getPreciseIpURL()
--	local url = "http://halllist.99sai.com/" .. GameConfig.GAME_ID .."_".. Common.getChannelID() .. ".html";
--	Common.log("getPreciseIpURL === " .. url);
--	return url;
--end

--[[--
--获取公共IP列表的url
--]]
local function getCommonIpURL()
	local url = "http://halllist.99sai.com/" .. GameConfig.GAME_ID .. ".html";
	if GameChannelConfig.getChannelIsLianYun() then
		url = "http://halllist.99sai.com/co" .. GameConfig.GAME_ID .. ".html";
	end

	if Load.isGlobalApp() then
		url = "http://halllist.99sai.com/en" .. GameConfig.GAME_ID .. ".html";
	end
	Common.log("getCommonIpURL === " .. url);
	return url;
end

--[[--
--关闭http超时请求
--]]
local function closeCommonIpList()

	NetworkMonitor.initLastRecvTime();--重置版本消息超时时间帧

	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
		lookTimer = nil;
	end
end

--[[--
--获取公共的IP列表
--]]
local function getCommonIpList()

	closeCommonIpList();

	local function callbackCommonIp(CommonIpData)
		local NetWorkIP = nil
		if Common.platform == Common.TargetIos then
			NetWorkIP = CommonIpData["NetWorkIP"];
		elseif Common.platform == Common.TargetAndroid then
			NetWorkIP = CommonIpData;
		end
		Common.log("获取公共的IP列表================ "..NetWorkIP);
		if NetWorkIP ~= "error" then
			--成功获取列表
			ServerList = Common.FGUtilStringSplit(NetWorkIP, ",")
			--开始ping所有的暗可用ip(公共)
			pingIP(pingDarkIp);
		end
	end

	--获取公共的可用ip列表
	Common.getNetWorkIP(getCommonIpURL(), callbackCommonIp);

	if lookTimer == nil then
		local function callback()
			pingDomain();
		end
		--定时器,获取公共可用的ip列表超时后,直接ping域名列表
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback, 3, false);
	end
end

--[[--
--获取精确的IP列表
--]]
--local function getPreciseIpList()
--
--	local function callbackPreciseIp(PreciseIpData)
--
--		closeCommonIpList();
--
--		local NetWorkIP = nil
--		if Common.platform == Common.TargetIos then
--			NetWorkIP = PreciseIpData["NetWorkIP"];
--		elseif Common.platform == Common.TargetAndroid then
--			NetWorkIP = PreciseIpData;
--		end
--		Common.log("获取精确的IP列表================ "..NetWorkIP);
--		if NetWorkIP ~= "error" then
--			--成功获取列表
--			ServerList = Common.FGUtilStringSplit(NetWorkIP, ",");
--			--开始ping所有的暗可用ip(精确)
--			pingIP(pingDarkIp);
--		else
--			--失败，获取公共的列表
--			getCommonIpList();
--		end
--	end
--
--	--获取精确的可用ip列表
--	Common.getNetWorkIP(getPreciseIpURL(), callbackPreciseIp);
--
--	if lookTimer == nil then
--		--定时器,获取精确的可用ip超时后,则获取公共ip列表
--		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(getCommonIpList, 3, false);
--	end
--end

local isPingStartConnect = false;--是否在ping连接进程中
local pingIPConut = 0;--ping IP地址次数
local pingDomainConut = 0;--ping 域名次数

--[[--
--获取当前是否在ping连接中
--]]
function getPingStartConnect()
	return isPingStartConnect;
end

--[[--
--重置ping连接数据
--]]
function resetPingData()
	closeCommonIpList();--关闭计时器
	isPingStartConnect = false;
	pingIPConut = 0;--ping IP地址次数
	pingDomainConut = 0;--ping 域名次数
end

--[[--
--开始建立连接
--]]
local function ServiceConnect(ipAddr)

	setPingAddrEndTime(ipAddr, Common.getTimeStamp());

	if not getPingStartConnect() then
		--已经结束ping连接
		Common.log("已经结束ping连接 ===========".. ipAddr);
		return;
	end

	resetPingData();

	Common.log("ServiceConnect === ".. ipAddr);
	Services:getMessageService():removeAllServerIp();
	Services:getMessageService():init(ipAddr, 65002);
	Services:getMessageService():reConnect();
end

local function DNSServicesConnect()
	resetPingData();

	Services:getMessageService():removeAllServerIp();
	local messageService = Services:getMessageService()
	for i = 1, #DNSServerList do
		Common.log("DNSServerList === ".. DNSServerList[i])
		messageService:init(DNSServerList[i], 65002)
	end
	messageService:reConnect();
end

--[[--
--ping IP地址
--]]
function pingIP(pingType)

	closeCommonIpList();--关闭计时器

	--pingIPConut = pingIPConut + 1;
	--
	--	if pingIPConut + pingDomainConut > 2 then
	--		resetPingData();
	--		--如果ping所有域名和IP的总次数超过2，则说明网络不通，需要提示断网
	--		CommDialogConfig.pingErrConnFailedFun();
	--		return;
	--	end

	local FailNum = 0;--失败的数量
	local function pingResult(pingData)
		local result = nil
		local ipAddr = nil
		if Common.platform == Common.TargetIos then
			result = pingData["pingResult"];--结果
			ipAddr = pingData["ipAddr"];--ip
		elseif Common.platform == Common.TargetAndroid then
			--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
			local i, j = string.find(pingData, "#");
			result = string.sub(pingData, 1, i-1);
			ipAddr = string.sub(pingData, j+1, -1);
		end
		--Common.log("pingResult result ====== "..result);
		Common.log("pingResult ipAddr ====== "..ipAddr);
		if result == "YES" then
			--ping成功
			ServiceConnect(ipAddr);
		else
			--ping失败
			Common.setPingFunnelModel(Common.PingEndFunnelModel, ipAddr .. " Fail")
			FailNum = FailNum + 1;
			if pingType == pingDarkIp then
				if FailNum >= #ServerList then
					--暗ip全部都ping失败，开始ping域名
					pingDomain();
				end
			elseif pingType == pingBrightIp then
				if FailNum >= #ServerList then
					--明ip全部都ping失败，开始通过http获取可用的ip列表
					getCommonIpList();
				end
			elseif pingType == pingNativeIp then
				if FailNum >= #nativeServerList then
					if Common.platform == Common.TargetIos then
						--本地ip全部都ping失败，提示用户断网
						resetPingData();
						--如果ping所有ip和域名失败，则说明网络不通，需要提示断网
						NetWorkConfig.pingErrConnFailedFun();
					elseif Common.platform == Common.TargetAndroid then
						--本地ip全部都ping失败，直接连域名
						DNSServicesConnect()
					end
				end
			end
		end
	end

	if pingType == pingNativeIp then
		--增删ip之后，开始ping IP地址
		for key, ipAdrr in pairs(nativeServerList) do
			Common.startPing(ipAdrr, pingResult);
			setPingAddrStartTime(ipAdrr, Common.getTimeStamp());
		end
	else
		--增删ip之后，开始ping IP地址
		for key, ipAdrr in pairs(ServerList) do
			Common.startPing(ipAdrr, pingResult);
			setPingAddrStartTime(ipAdrr, Common.getTimeStamp());
		end
	end
end

--[[--
--同时ping域名地址（暂时放弃）
--]]
--function pingDomain()
--	pingDomainConut = pingDomainConut + 1;
--
--	if pingIPConut + pingDomainConut > 6 then
--		resetPingData();
--		--如果ping所有域名和IP的总次数超过6，则说明网络不通，需要提示断网
--		CommDialogConfig.pingErrConnFailedFun();
--		return;
--	end
--
--	local FailNum = 0;--失败的数量
--	local function pingResult(pingData)
--		local result = nil
--		local ipAddr = nil
--		if Common.platform == Common.TargetIos then
--			result = pingData["pingResult"];--结果
--			ipAddr = pingData["ipAddr"];--ip
--		elseif Common.platform == Common.TargetAndroid then
--			--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
--			local i, j = string.find(pingData, "#");
--			result = string.sub(pingData, 1, i-1);
--			ipAddr = string.sub(pingData, j+1, -1);
--		end
--		--Common.log("pingResult result ====== "..result);
--		Common.log("pingResult ipAddr ====== "..ipAddr);
--		if result == "YES" then
--			--ping成功
--			ServiceConnect(ipAddr)
--		else
--			--ping失败
--			FailNum = FailNum + 1;
--			if FailNum == #DNSServerList then
--				--全部都ping失败，开始ping ip地址
--				pingIP();
--			end
--		end
--	end
--	--增删ip之后，开始ping 域名地址
--	for key, ipAdrr in pairs(DNSServerList) do
--		Common.startPing(ipAdrr, pingResult);
--	end
--end

--[[--
--递归逐个ping域名地址
--]]
function pingDomain(num, index)

	closeCommonIpList();--关闭计时器

	--	pingDomainConut = pingDomainConut + 1;
	--
	--	if pingIPConut + pingDomainConut > 2 then
	--		resetPingData();
	--		--如果ping所有域名和IP的总次数超过2，则说明网络不通，需要提示断网
	--		CommDialogConfig.pingErrConnFailedFun();
	--		return;
	--	end

	local ServerListIndex = 0;--当前连接IP的下标
	local FailNum = 0;--失败的数量
	if num ~= nil then
		FailNum = num
	end

	if index ~= nil then
		ServerListIndex = index;
	else
		ServerListIndex = 1;
	end

	local function pingResult(pingData)
		local result = nil
		local ipAddr = nil
		if Common.platform == Common.TargetIos then
			result = pingData["pingResult"];--结果
			ipAddr = pingData["ipAddr"];--ip
		elseif Common.platform == Common.TargetAndroid then
			--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
			local i, j = string.find(pingData, "#");
			result = string.sub(pingData, 1, i-1);
			ipAddr = string.sub(pingData, j+1, -1);
		end
		--Common.log("pingResult result ====== "..result);
		Common.log("pingResult ipAddr ====== "..ipAddr);
		if result == "YES" then
			--ping成功
			ServiceConnect(ipAddr);
		else
			--ping失败
			Common.setPingFunnelModel(Common.PingEndFunnelModel, ipAddr .. " Fail")
			FailNum = FailNum + 1;
			if FailNum >= #DNSServerList then
				--域名全部都ping失败
				ServerListIndex = 0;

				--开始ping本地ip
				pingIP(pingNativeIp);
			else
				--ping下一个IP地址
				ServerListIndex = ServerListIndex % #DNSServerList + 1;
				pingDomain(FailNum, ServerListIndex);
			end
		end
	end
	--增删ip之后，开始ping地址
	if DNSServerList[ServerListIndex] ~= nil then
		Common.startPing(DNSServerList[ServerListIndex], pingResult);
		setPingAddrStartTime(DNSServerList[ServerListIndex], Common.getTimeStamp());
	end
end

--[[--
--开始ping后建立连接
--@param #type ping逻辑类型 1：IP；2：域名
--]]
function startPingConnect(type)
	if getPingStartConnect() then
		--有连接正在建立
		Common.log("有连接正在建立 =================== ");
		return;
	end

	resetPingData();

	isPingStartConnect = true;--设置为在ping连接进程中

	updatePingIPServerList();

	updatePingDomainServerList();

	NetWorkConfig.resetMessageState("");
	PublicLuaBridge:getInstance():changeMessageServiceState(-1);
	Services:getMessageService():setWaitReconnect(true);
	if type ~= nil and type == 2 then
		--ping域名
		pingDomain();
	else
		--ping IP地址
		pingIP(pingBrightIp);
	end
end

--[[-- 解析服务器列表]]
function readMANAGERID_SERVER_LIST(dataTable)
	if Common.isDebugState() then
		return;
	end
	--EnableServerCnt  可用的服务器数量
	local EnableTable = dataTable["EnableServerTable"]
	Common.SaveTable("EnableServerList_V2", EnableTable);
	--EnableDomainCnt short 可用的域名
	local EnableDomainTable = dataTable["EnableDomainTable"]
	Common.SaveTable("EnableDomainList_V2", EnableDomainTable);
--DisableServerCnt  停用的服务器数量
--	local DisableTable = dataTable["DisableServerTable"]
--	Common.SaveTable("DisableServerList_V2", DisableTable);
end

registerMessage(MANAGERID_SERVER_LIST, readMANAGERID_SERVER_LIST)
