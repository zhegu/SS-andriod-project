module("CommDialogConfig", package.seeall)

local isNetKickOff = false;--强制退出

function getIsNetKickOff()
	return isNetKickOff;
end

local updateLocationCnt = 0; --更新位置信息的计数器

----[[--
----更新AppStore版本的IDFA
----]]
--function logicIDFA()
--	if not GameChannelConfig.isAppStoreChannelID() then
--		return;
--	end
--	local oldIDFA = Common.getDataForSqlite(CommSqliteConfig.IOS_APPSTORE_IDFA);
--	if oldIDFA == nil then
--		Common.setDataForSqlite(CommSqliteConfig.IOS_APPSTORE_IDFA, Common.getIDFA());
--	else
--		if oldIDFA ~= Common.getIDFA() then
--			Common.log("更新AppStore版本的IDFA =================")
--			sendCOMMONS_UPDATE_IMEI();
--		end
--	end
--end

----[[--
----获取需要上传的IP
----]]
--function uploadNetWorkIP(NetWorkIPData)
--	local NetWorkIP = nil
--	if Common.platform == Common.TargetIos then
--		NetWorkIP = NetWorkIPData["NetWorkIP"];
--	elseif Common.platform == Common.TargetAndroid then
--		NetWorkIP = NetWorkIPData;
--	end
--	Common.log("NetWorkIP ================ "..NetWorkIP);
--	if NetWorkIP ~= "error" then
--		sendMANAGERID_NETWORK_IP(NetWorkIP);
--	end
--end


--[[--
--注册后的逻辑处理
--]]
function logicRegister(parameters)
--	local result = profileCommon.UserLoginReg.getResult()
--	if (result == 0) then
--		--注册成功
--		sendPlatformMessage();
--	end
end

--[[--
--登录以后需要处理的逻辑
--]]
function logicLogin()
	CommDialogConfig.closeProgressDialog();
	local result = profile.User.getUserInfo().Result
	if (result == 0) then
		--登录成功

		if profile.User.getUserID() ~= nil then
			--微信绑定消息
--			LoginConfig.sendWeChatBindMessage();

		end

		if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
			--在大厅中收到登录消息
		end
		Common.log("登录成功================================")
		GameCommonConfig.logicGameSync();
	end
end

--[[--
--重连以后发送登录
--]]
function netlogin()
	if GameChannelConfig.isAppStoreChannelID() then
		--appstore审核版本，此时发通用配置消息
		sendMANAGERID_GET_SERVER_CONFIG_V2(ServerConfig.maMessage);
	end

	if profile.User.getUserIsWeChatLogin() then
		--如果是微信登录用户
		if LoginConfig.getWeChatToken() ~= nil then
			LoginConfig.sendWeChatThirdPartLogin();
		else
			Common.log("error getWeChatToken ====== nil");
		end
		return;
	end

	local UserID = profile.User.getSelfUserID();
	local username = profile.User.getSelfNickName();
	local password = profile.User.getSelfPassword();
	local imei = Common.getDeviceInfo();

	if (UserID ~= 0 and username ~= nil and password ~= nil) then
		Common.log("UserID ====== "..UserID);
		Common.log("username ====== "..username);
		Common.log("password ====== "..password);
		sendBASEID_LOGIN(UserID, username, password, imei);
	else
		local bIsHasData, nUserID, sUsernamevalue, sPasswordvalue = LoginConfig.getLastUserInfo();
		if bIsHasData then
			UserID = nUserID;
			username = sUsernamevalue;
			password = sPasswordvalue;
			sendBASEID_LOGIN(UserID, username, password, imei);
		end
	end
end

local SEVER_MSG_RECHARGE_POPUP = 1;-- 充值弹窗
local SEVER_MSG_FLY_WORDS = 2;-- 飘字
local SEVER_MSG_MATCH_MSG = 3;-- 比赛播报
local SEVER_MSG_SERVER_NOTICE = 4;-- 系统公告
local SEVER_MSG_EXIT = 5;-- 强制退出
local SEVER_MSG_FLY_TOAST = 6;-- Toast
local SEVER_MSG_EMIGRATED_FLY_WORDS = 7;-- 冲榜飘字
local SEVER_MSG_POPUP = 8;-- 普通弹框

--[[--
--处理ServerMsg消息,弹出相应对话框
--]]
function showServerMsg()
	Common.log("showServerMsg")
	ServerMsg = {}
	ServerMsg = profileCommon.ServerMsg.getServerMsgTable()
	-- Type Byte 类型 1:充值弹窗 2:飘字 3:比赛播报 4.系统公告 5.强制退出 6.Toast,7.冲榜飘字,8.普通弹框
	local nType = ServerMsg["nType"]
	-- Msg text 比赛状态的客户端提示语
	local sMsg = ServerMsg["sMsg"]
	-- 充值是否成功（充值特有）1成功，0失败
	local isSucceed = ServerMsg["isSucceed"]

	if nType == SEVER_MSG_RECHARGE_POPUP then
		-- 充值弹窗
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL,nil,sMsg);
		if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
		--profile.Gift.sendFirstGiftIconMsg(1);
		elseif GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
		--profile.Gift.sendFirstGiftIconMsg(2);
		end
		sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态
		sendDBID_BACKPACK_LIST()--背包
	elseif nType == SEVER_MSG_FLY_WORDS then
	-- 飘字
	--PokerTableElementLayer.addServerMsg(sMsg);
	elseif nType == SEVER_MSG_MATCH_MSG then
	-- 比赛播报
	elseif nType == SEVER_MSG_SERVER_NOTICE then
	-- 系统公告
	elseif nType == SEVER_MSG_EXIT then
		-- 强制退出
		isNetKickOff = true;
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().EXIT,nil,sMsg);
	elseif nType == SEVER_MSG_FLY_TOAST then
		-- Toast
		Common.showToast(sMsg, 2)
	elseif nType == SEVER_MSG_EMIGRATED_FLY_WORDS then
	-- 冲榜飘字
	elseif nType == SEVER_MSG_POPUP then
		Common.showDialog(sMsg)
	end
end

--完成新手任务保存数据
function getNewUserTaskFinish()
	if(Common.getDataForSqlite(CommSqliteConfig.NewUserTaskIsEnd..profile.User.getSelfUserID()) ~= nil and
		Common.getDataForSqlite(CommSqliteConfig.NewUserTaskIsEnd..profile.User.getSelfUserID()) == 1)then
		return true;
	else
		return false;
	end
end

--完成新手引导保存数据
function getNewUserGiudeFinish()
	if(Common.getDataForSqlite(CommSqliteConfig.NewUserGuideIsEnd..profile.User.getSelfUserID()) ~= nil and
		Common.getDataForSqlite(CommSqliteConfig.NewUserGuideIsEnd..profile.User.getSelfUserID()) == "1")then
		return true;
	else
		return true;
	end
end


ImageList = {}--要初始化的图片

--[[--
--初始化图片的下载回调
--]]
function downloadImageCallBack(path)
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
	if photoPath ~= nil and photoPath ~= "" then
		if #ImageList > 0 then
			table.remove(ImageList, tonumber(id));
			downloadImage();
		end
	end
end

--[[--
--下载初始化图片
--]]
function downloadImage()
	if #ImageList == 0 then
		--webview静态预加载
		sendWebViewCommonMessage()
		return;
	end

	local msPhotoUrl = ImageList[1].picUrl;
	if msPhotoUrl ~= nil and msPhotoUrl ~= "" then
		Common.getPicFile(msPhotoUrl, 1, true, downloadImageCallBack);
	end
end

--[[--
--初始化图片
--]]
function initImageList()
	ImageList = profileCommon.InitImageList.getInitImageList();
	downloadImage();
end

--[[--
--创建显示debug信息
--]]
function createDebugInfo(info)
	local view = cocostudio.createView("GameLoading.json")
	GameStartConfig.addChildForScene(view)
	local w = GameConfig.ScreenWidth;
	local h = GameConfig.ScreenHeight;
	local x = 0;
	local y = 0;
	Common.showWebView("", "<font color=#ff0000>"..info.."</font>", x, y, w, h);
end

--[[--
--判断上一次加载WEBVIEW的时间里现在是否达到24小时
--]]
function judgeTimeToLoadWebView()
	if not JUDGETIME then
		local timeStamp = Common.getDataForSqlite(WEBVIEWUPDATETIME)
		local nowStamp = Common.getServerTime()
		if timeStamp == nil or timeStamp == "" then
			Common.setDataForSqlite(WEBVIEWUPDATETIME, nowStamp);
			JUDGETIME = true --首次加载webview设置为true
		else
			nowStamp = tonumber(nowStamp);
			timeStamp = tonumber(timeStamp);
			if (nowStamp - timeStamp) / (3600 * 24) > 1 then
				JUDGETIME = true --达到24小时可以加载webview
				preLoadWebViewCommMessage()
			end
		end
	end
end

--[[--
--所有WEBVIEW的预加载
--]]
function preLoadWebViewCommMessage()
	--遍历url表获得key和url
	if webViewTable["Key"] ~= nil and #webViewTable["Key"] > 0 and #webViewTable["Url"] > 0 and not preWebViewCompleted then
		local key = webViewTable["Key"][1]
		local url = webViewTable["Url"][1]
		local itemTable = Common.LoadTable(key) --根据key加载本地本地数据
		if itemTable then
			sendCOMMONS_HTTPPROXY(url, itemTable.HashCode, key) --如果本地有数据请求服务器更新，比较hasecode判断是否有更新
		else
			sendCOMMONS_HTTPPROXY(url, 0, key) --如果本地无数据，请求服务器
		end
		table.remove(webViewTable["Key"], 1)
		table.remove(webViewTable["Url"], 1)
		return
	elseif webViewTable["Key"] ~= nil and #webViewTable["Key"] == 0 then
		Common.log("webview----webview加载完成")
		preWebViewCompleted = true --全部webview预加载完成
		Common.setDataForSqlite(WEBVIEWUPDATETIME, Common.getServerTime());
	end
end

--[[--
--初始化webview列表
--]]
function preloadMatchWebViewMessage()
	local MatchTable = {}
	webViewTable["Key"] = {}
	webViewTable["Url"] = {}

	MatchTable["MatchList"] = profile.Match.getMatchTable()
	if MatchTable["MatchList"] ~= nil and not preWebViewCompleted then
		webViewTable["Key"] = {
			"URL_TABLE_LOGIN",
			"URL_TABLE_LUKEYTURN_HELP",
			"URL_TABLE_MONTHSIGN_HELP",
			"URL_TABLE_CUSTOMSERVICE_SERVICE",
			"URL_TABLE_CUSTOMSERVICE_HELP",
			"URL_TABLE_TTHELP",
			"URL_TABLE_CRAZYSTAGE_HELP"
		}
		webViewTable["Url"] = {
			GameConfig.URL_TABLE_LOGIN,
			GameConfig.URL_TABLE_LUKEYTURN_HELP,
			GameConfig.URL_TABLE_MONTHSIGN_HELP,
			GameConfig.URL_TABLE_CUSTOMSERVICE_SERVICE,
			GameConfig.URL_TABLE_CUSTOMSERVICE_HELP,
			GameConfig.URL_TABLE_TTHELP,
			GameConfig.URL_TABLE_CRAZYSTAGE_HELP,
			GameConfig.URL_XY_PLATFORM_GIFT_BAG,
		}
		Common.log("MatchTable = "..#MatchTable["MatchList"])
		local versioncode = Common.getVersionCode() + Common.getChannelID()--版本号
		local VipLevel = profile.User.getSelfVipLevel()--vip级别
		local vipjb = VIPPub.getUserVipType(VipLevel)--vip
		local itemTable = {}
		local num = #webViewTable["Key"]
		local selfVip = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
		for j=1, #MatchTable["MatchList"] do
			local MatchID = MatchTable["MatchList"][j].MatchID
			local key = string.format("MATCH%d_%d", MatchID, selfVip) --自定义key 由MATCH加比赛ID组成
			--测试用
			--			local url = "http://10.10.0.99:8090/TqRechargeAdminMvn/matchV4DetailManager!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb
			--新比赛
			local url = "http://db.tongqutongqu.cn/tqAdmin/matchV4DetailManager!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb
			--旧比赛
			--			local url = "http://58.68.246.34/tqAdmin/matchDetailManagerNew!query.do?id="..MatchID.."&gameID=1&version="..versioncode.."&vipLevel="..vipjb;
			webViewTable["Key"][j+num] = key
			webViewTable["Url"][j+num] = url
		end
		if #ImageList == 0 then
			--webview静态预加载
			if JUDGETIME then
				preLoadWebViewCommMessage()
			end
			return;
		end
	end
end

--[[--
--webview预加载
--]]
function sendWebViewCommonMessage()
	Common.log("sendWebViewCommonMessage---------------")
	--如果比赛列表加载完成，则进行所有WEBVIEW的预加载
	judgeTimeToLoadWebView()
end

--[[--
-- 公共WEBVIEW预加载
@param webURL	读取web的url地址
@param key	存入本地的key
@param x	显示webview的x坐标
@param y	显示webview的x坐标
@param width	显示webview的宽
@param height	显示webview的高
]]
function commonLoadWebView(webURL, key, x, y, width, height)
	webViewTable.URL = webURL
	webViewTable.x = x
	webViewTable.y = y
	webViewTable.width = width
	webViewTable.height = height
	webViewTable.key = key
	local itemTable = Common.LoadTable(webViewTable.key)

	if itemTable then --存在本地数据
		Common.log("sendCOMMONS_HTTPPROXY = 有本地数据")
		--sendCOMMONS_HTTPPROXY(webURL, itemTable.HashCode, key) --获取web更新
		Common.showWebView("", itemTable.Html, x, y, width, height); --显示webview
	else
		Common.log("sendCOMMONS_HTTPPROXY = 没有本地数据")
		sendCOMMONS_HTTPPROXY(webURL, 0, key) --获取web更新
		Common.showWebView(webURL, "", x, y, width, height);	--显示webview
	end
end

--[[--
显示loadling弹出框
--]]
function showProgressDialog(msg, x, y, isHightLight)
	if not GameLoadingLogic.isLoadingShow() then
		GameLoadingLogic.showLoadingView(x, y, isHightLight)
	end
end

--[[--
关闭loadling弹出框
--]]
function closeProgressDialog()
	if GameLoadingLogic.isLoadingShow() then
		GameLoadingLogic.closeLoadingView()
	end
end

--[[--
判断loadling弹出框是否显示
--]]
function isProgressDialogShowing()
	return GameLoadingLogic.isLoadingShow();
end

--点击+金币按钮打开自由兑换界面
--变量本地写死。不请求网络
function openConvertCoin()
	--0=自由兑换=可自由兑换任意数量的金币=1001http://f.99sai.com/mahjong/shop/mj_shop_jindai.png
	ConvertCoinLogic.setGoodsData(10, "自由兑换", "可自由兑换任意数量的金币", 100 * ServerConfig.getConversionCoefficient(),"http://f.99sai.com/mahjong/shop/mj_shop_jindai.png",1)
	mvcEngine.createModule(GUI_CONVERTCOIN)
end

--[[--
--获取通用配置信号方法
--]]
function getMANAGERID_GET_SERVER_CONFIG_V2()
	if Common.platform == Common.TargetAndroid then
		if Common.getOperater() == Common.CHINA_MOBILE then
			--如果是移动的话,获取手机钱包正则表达式配置
			local PurseConfigTable = profileCommon.ServerConfig.getServerConfigDataTable(ServerConfig.LORD_DENY_SMS_LIST) --获取服务器返回的table
			if PurseConfigTable ~= nil then
				--调用java方法存储正则表达式
				Common.SavePurseRegex(PurseConfigTable)
			end
		end
	end
end

--[[--
--显示图文Toast
--]]
function showImageToast()
	local toastTable = profileCommon.ImageToast.getImageToastTable()
	if toastTable ~= nil then
		local function showToast()
			ImageToast.createView(toastTable["ImageUrl"],nil,"",toastTable["ToastMsg"],2)
		end
		if GameConfig.getTheCurrentBaseLayer() == GUI_JINHUA_TABLE then
			local delay =  CCDelayTime:create(2)
			local actioArray = CCArray:create()
			actioArray:addObject(delay)
			actioArray:addObject(CCCallFuncN:create(showToast))
			local seq = CCSequence:create(actioArray)
			JinHuaTableLogic.getTableParentLayer():runAction(seq)
		else
			showToast()
		end
	end
end

--[[--
--显示破产红包
--]]
function showRedPackets()
	local RedPacketsInfoTable = profileCommon.RedPackets.getRedPacketsInfoTable()
	if RedPacketsInfoTable ~= nil and RedPacketsInfoTable.GiveCoin ~= nil then
		mvcEngine.createModule(GUI_SENDGOLD)
	end
end

--[[--
--获取位置回调
--]]--
function gpsLocationCallback(locationStr)
	Common.log("gpsLocationCallback locationStr ============= " .. locationStr);
	sendMANAGERID_USER_GPS(locationStr)
end

--[[--
--接收心跳消息
--]]--
function msgIdle()
	updateLocationCnt = updateLocationCnt + 1;
	if updateLocationCnt >= 5*60/4 then
		--约5分钟重新获取一次GPS定位
		updateLocationCnt = 0;
		Common.getLocation();
	end
end

--微信分享
function slot_MJ_SC_SHARE_INFO()
	-- sharingURL	Text	分享路径	分享路径+CDKEY是完整路径，CDKEY可以做二维码用
	local AppDownLoadURL = profile.MahjongRecommend.getShareToWxUrl()
	if AppDownLoadURL == nil or AppDownLoadURL == "" then
		return
	end
	-- if not ServerConfig.getRecommendIsShow() then
	-- 	return
	-- end
	-- Common.log("readJINHUA_MGR_SHARING_INFO =====================")
	--一进大厅就生成推荐系统所需要的二维码
	local size = 300;
	Common.log("进大厅就生成推荐系统所需要的二维码 ====================="..AppDownLoadURL)
	--二维码图片路径
	local qrcodefullpath = QrcodeUtil.getQRCodePicPath(QrcodeUtil.getRECOMMEND_QRCODE_NAME())
	if Common.getDataForSqlite(CommSqliteConfig.WXShareDownloadUrl) == nil or not QrcodeUtil.getQRCodePicIsExist(qrcodefullpath) then
		--第一次收到分享的url 或者 二维码图片不存在了
		Common.setDataForSqlite(CommSqliteConfig.WXShareDownloadUrl,AppDownLoadURL);
		QrcodeUtil.createQRCodePicAndSaveToFile(AppDownLoadURL,Common.getResourcePath("icon_mahjong.png"),size,QrcodeUtil.getRECOMMEND_QRCODE_NAME())
		local qrFileName = QrcodeUtil.getQRCodePicPath(QrcodeUtil.getRECOMMEND_QRCODE_NAME())
		Common.log("qrFileName ====== "..qrFileName)
		QrcodeUtil.drawCreatePng(Common.getResourcePath("ui_tuijian_erweima_bg.png"),qrFileName,QrcodeUtil.RECOMMEND_QRCODE_BG_SCALE_NAME,640,640,320,184,0.2)
		QrcodeUtil.drawCreatePng(Common.getResourcePath("ui_tuijian_erweima_bg.png"),qrFileName,QrcodeUtil.RECOMMEND_QRCODE_BG_NAME,640,640,320,184,0.5)

	else
		if Common.getDataForSqlite(CommSqliteConfig.WXShareDownloadUrl) ~= AppDownLoadURL then
			--url有变动
			QrcodeUtil.createQRCodePicAndSaveToFile(AppDownLoadURL,Common.getResourcePath("icon_mahjong.png"),size,QrcodeUtil.getRECOMMEND_QRCODE_NAME())
			local qrFileName = QrcodeUtil.getQRCodePicPath(QrcodeUtil.getRECOMMEND_QRCODE_NAME())
			QrcodeUtil.drawCreatePng(Common.getResourcePath("ui_tuijian_erweima_bg.png"),qrFileName,QrcodeUtil.RECOMMEND_QRCODE_BG_SCALE_NAME,640,640,320,184,0.2)
			QrcodeUtil.drawCreatePng(Common.getResourcePath("ui_tuijian_erweima_bg.png"),qrFileName,QrcodeUtil.RECOMMEND_QRCODE_BG_NAME,640,640,320,184,0.5)
		end
	end
	--带背景的二维码路径
	local qrBgFileName = QrcodeUtil.getQRCodePicPath(QrcodeUtil.RECOMMEND_QRCODE_BG_NAME)
	if not QrcodeUtil.getQRCodePicIsExist(qrBgFileName) then
		--不存在了  重新创建
		local qrFileName = QrcodeUtil.getQRCodePicPath(QrcodeUtil.getRECOMMEND_QRCODE_NAME())
		QrcodeUtil.drawCreatePng(Common.getResourcePath("ui_tuijian_erweima_bg.png"),qrFileName,QrcodeUtil.RECOMMEND_QRCODE_BG_SCALE_NAME,640,640,320,184,0.2)
		QrcodeUtil.drawCreatePng(Common.getResourcePath("ui_tuijian_erweima_bg.png"),qrFileName,QrcodeUtil.RECOMMEND_QRCODE_BG_NAME,640,640,320,184,0.5)
	end
end

--获取牌局录像信息
function slot_MJ_SC_MGR_GET_ROOM_RECORD()
	local vedioInfoData = profile.MahjongRecord.getVedioInfoTable()
	local miniGameID = vedioInfoData["miniGameID"];
	local miniGamePack = vedioInfoData["miniGamePackage"];
	local vedioUrl = vedioInfoData["videoUrl"];

	local tipStr = "您确定要查看录像吗？"
	--			local str = "3#"..CommonDialogLogic.getTypeTable().TYPE_VEDIO.."|"..tipStr.."|"..vedioUrl;
	local str = "3#6|"..tipStr.."|"..vedioUrl;
	GameLoadModuleConfig.startMiniGameByID(miniGameID, miniGamePack, str);
	Common.setClipboard("");--清空剪切板
end