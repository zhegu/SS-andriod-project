--[[--
-- 发送注册请求
]]
function sendBASEID_REGISTER(imei)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_REGISTER)
	nMBaseMessage:setMsgVer(2) --消息版本号
	nMBaseMessage:writeStart()

	--IMIE	text	IMIE号和MAC	以html5/android/ios +’_’开头+IMIE_MAC
	nMBaseMessage:writeString(imei)
	--NickName	text	昵称	（若为空则自动生成）
	nMBaseMessage:writeString("")
	--Password	text	密码	（若为空则自动生成）
	nMBaseMessage:writeString("")
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--PlatVer	Text	平台版本
	nMBaseMessage:writeString(Common.getVersionName())
	--RegChannelID	text	注册渠道号
	nMBaseMessage:writeString(""..Common.getChannelID())
	--RobotModel	Byte	机器人型号	0普通用户  1,2,3 机器人等级
	nMBaseMessage:writeByte(0)
	--mobile	Text	手机号码	自动获取的
	nMBaseMessage:writeString("")
	--PlatformCode	byte	客户端类型
	--	public static final int OSID_ANDROID = 1;
	--	public static final int OSID_HTML5 = 2;
	--	public static final int OSID_IPHONE = 3;
	--	public static final int OSID_LUA_ANDROID = 4;
	--	public static final int OSID_LUA_IOS = 5;
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--GameID	byte	发起注册的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--IntroducerUserID	int	推荐人的ID	从apk包中解析出来的ID
	nMBaseMessage:writeInt(Common.getIntroducerID());
	--Enctype int 字符串编码类型 0 : Unicode1 : Utf-8
	nMBaseMessage:writeInt(0);
	--PhoneType	String	手机型号
	nMBaseMessage:writeString(Common.getModel());
	--isEmulator byte 是否是模拟器 0：不是；1：是
	if Common.isEmulator() then
		--模拟器
		nMBaseMessage:writeByte(1)
	else
		--真机
		nMBaseMessage:writeByte(0)
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--
--发送登录请求
]]
function sendBASEID_LOGIN(UserID, username, password, imei)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_LOGIN)
	nMBaseMessage:writeStart()
	--IMIE	text	IMIE号和MAC	以html5/android/ios +’_’开头+IMIE_MAC
	nMBaseMessage:writeString(imei)
	--NickName	text	昵称	（若为空则自动生成）
	nMBaseMessage:writeString(username)
	--Password	text	密码	（若为空则自动生成）
	nMBaseMessage:writeString(password)
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--RegChannelID	text	注册渠道号
	nMBaseMessage:writeString(""..Common.getChannelID())
	--PlatformCode	byte	客户端类型
	--	public static final int OSID_ANDROID = 1;
	--	public static final int OSID_HTML5 = 2;
	--	public static final int OSID_IPHONE = 3;
	--	public static final int OSID_LUA_ANDROID = 4;
	--	public static final int OSID_LUA_IOS = 5;
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--GameID	byte	发起注册的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--PhoneType	String	手机型号
	nMBaseMessage:writeString(Common.getModel());
	--UserID	int	用户ID	用户名or用户ID中一个正确就可以登录
	nMBaseMessage:writeInt(UserID);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求取出基本信息]]
function sendBASEID_GET_BASEINFO(userID)

	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_GET_BASEINFO)

	nMBaseMessage:writeStart()
	--UserID  用户ID
	nMBaseMessage:writeInt(userID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求修改基本信息]]
function sendBASEID_EDIT_BASEINFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_EDIT_BASEINFO)


	local userID = dataTable["userID"]
	local editCnt = dataTable["editCnt"]
	local editContentTable= {}
	for i = 1,editCnt do
		editContentTable[i] = {}
		editContentTable[i].attID = dataTable["editContent"][i].attID
		editContentTable[i].attVal = dataTable["editContent"][i].attVal
		--Common.log("edituserinfo"..editContentTable[i].attVal)
	end

	nMBaseMessage:writeStart()
	nMBaseMessage:writeInt(userID)
	nMBaseMessage:writeByte(editCnt)
	for i = 1,editCnt do
		nMBaseMessage:writeByte(editContentTable[i].attID)
		nMBaseMessage:writeString(editContentTable[i].attVal)
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("修改个人信息请求 = ")
end

--[[-- 请求取出兑奖信息]]
function sendBASEID_GET_AWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_GET_AWARD)

	nMBaseMessage:writeStart()
	--userID  用户ID
	nMBaseMessage:writeInt()
	--password  密码
	nMBaseMessage:writeString()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求同步客户端时间]]
function sendBASEID_TIMESTAMP_SYNC()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_TIMESTAMP_SYNC)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 检测游戏版本升级]]
function sendBASEID_PLAT_VERSION()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_PLAT_VERSION)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(1);
	nMBaseMessage:writeString(Load.APP_NAME);
	--	nMBaseMessage:writeString("lord");
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	nMBaseMessage:writeByte(Common.getConnectionType());
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求获取用户充值信息
-- ]]
function sendGIFTBAGID_USER_ENCHARGE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_USER_ENCHARGE_INFO)
	nMBaseMessage:writeStart()
	--GameID Byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--
-- 发送通用礼包请求消息
-- @param #number type 礼包类别ID
-- @param #number inBackPack 时间间隔限制是否无效 1:无效,0:有效,2:无条件弹出
-- @param #number IsRepurchase 是否为重新购买 0：不重购，1：重购
-- ]]
function sendGIFTBAGID_REQUIRE_GIFTBAG(type, inBackPack, IsRepurchase)
	if Services:getMessageService():getCutOut() then
		return
	end

	if DelayShowGiftConfig.setShowGiftAtMiniGame ~= nil then
		DelayShowGiftConfig.setShowGiftAtMiniGame();
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_REQUIRE_GIFTBAG)
	nMBaseMessage:writeStart()

	-- GameID Byte 游 戏 ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- GiftBagType int 礼 包 类 别 ID 服 务 器 判 断 更 准 确
	nMBaseMessage:writeInt(tonumber(type));
	-- InBackPack byte 时 间 间 隔 限 制 是 否 无 效 1 :无 效 , 0 :有 效
	nMBaseMessage:writeByte(inBackPack);
	-- IsRepurchase	byte 是否为重新购买 0：不重购，1：重购
	if IsRepurchase ~= nil then
		nMBaseMessage:writeByte(IsRepurchase);
	else
		nMBaseMessage:writeByte(0);
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求客户端展示礼包]]
function sendGIFTBAGID_SHOW_GIFTBAG(GiftTypeID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_SHOW_GIFTBAG)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GiftID  礼包ID
	nMBaseMessage:writeInt(GiftTypeID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求使用元宝购买礼包]]
function sendGIFTBAGID_BUY_GIFTBAG(GiftID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_BUY_GIFTBAG)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GiftID  礼包ID
	nMBaseMessage:writeInt(GiftID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户背包中新礼包状态]]
function sendGIFTBAGID_NEWGIFT_TYPE(isShow)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_NEWGIFT_TYPE)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--IsShow  是否有/查看新礼包
	nMBaseMessage:writeByte(isShow)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户可购买礼包列表]]
function sendGIFTBAGID_GIFTBAG_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GIFTBAG_LIST)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户礼包状态]]
function sendGIFTBAGID_GET_GIFTBAG_MSG()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GET_GIFTBAG_MSG)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户删除背包礼包列表]]
function sendGIFTBAGID_PUSH_DELBACKLIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_PUSH_DELBACKLIST)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 用户可购买礼包列表(精简)]]
function sendGIFTBAGID_GIFTBAG_LIST_SIMPLE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GIFTBAG_LIST_SIMPLE)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	Common.log("read80510010  send")
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求得到短信通道号码]]
function sendDBID_GET_SMS_NUMBER()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_GET_SMS_NUMBER)

	nMBaseMessage:writeStart()
	--OperatorID  运营商
	nMBaseMessage:writeByte(Common.getOperater())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑换列表]]
function sendDBID_EXCHANGE_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_EXCHANGE_LIST)

	nMBaseMessage:writeStart()
	--Timestamp
	nMBaseMessage:writeLong(0)
	--
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求服务器列表]]
function sendMANAGERID_SERVER_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_SERVER_LIST)

	nMBaseMessage:writeStart()

	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Version	Int	版本
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
-- 请求购买商品
--#number ItemID 商品ID
--#number Num 购买数量
-- ]]
function sendDBID_PAY_GOODS(ItemID, Num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_PAY_GOODS)

	Common.log("send message convert"..ItemID.."----"..Num)
	nMBaseMessage:writeStart()
	--ItemID
	nMBaseMessage:writeInt(ItemID)
	--Num
	nMBaseMessage:writeInt(Num)
	--BackgroundColor  购买成功webview的背景颜色
	nMBaseMessage:writeString("")
	--GameID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取服务器通用配置]]
function sendMANAGERID_GET_SERVER_CONFIG_V2(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_SERVER_CONFIG_V2)

	nMBaseMessage:writeStart()
	--VarCnt  变量数目
	nMBaseMessage:writeInt(#dataTable)
	--…VarName  变量名
	for i = 1,#dataTable do
		nMBaseMessage:writeString(dataTable[i])
	end
	--VersionCode  版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Imsi  运营商代码(Imsi)
	nMBaseMessage:writeString(Common.getImsi())
	--ICCID Text 手机sim卡iccid
	nMBaseMessage:writeString(Common.getICCID());
	--GameID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取修改昵称的次数]]
function sendDBID_GET_NICKNAME_MODIFY_TIMES()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_GET_NICKNAME_MODIFY_TIMES)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取指定商品详情（可多个）]]
function sendDBID_MALL_GOODS_DETAIL()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_MALL_GOODS_DETAIL)

	nMBaseMessage:writeStart()
	--Num  同时请求多少个商品
	nMBaseMessage:writeInt()
	--...GoodsID  商品ID
	nMBaseMessage:writeInt()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求通过昵称发送消息]]
function sendDBID_V2_SEND_MSG_NICKNAME(toNickname,sendvalue)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_SEND_MSG_NICKNAME)

	nMBaseMessage:writeStart()
	--ReciverNickName  接收者用户昵称
	nMBaseMessage:writeString(toNickname)
	--MessageContent  消息内容
	nMBaseMessage:writeString(sendvalue)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求用户客户端手机信息]]
function sendDBID_USER_PHONE_MSG(userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_USER_PHONE_MSG)

	nMBaseMessage:writeStart()
	--UserID  用户ID
	nMBaseMessage:writeInt(userID)
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVer  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--ChannelID  渠道号
	nMBaseMessage:writeInt(Common.getChannelID())
	--moblieType  手机型号
	nMBaseMessage:writeString(Common.getModel())
	--moblieNumber  手机号码
	nMBaseMessage:writeString(Common.getTelephonyNumber())
	--Imei  Imei
	nMBaseMessage:writeString(Common.getDeviceInfo())
	--MacAddr  Mac地址
	nMBaseMessage:writeString("")
	--ConnectionType  连接类型
	nMBaseMessage:writeString(Common.getConnectionType())
	--Imsi  运营商代码(Imsi)
	nMBaseMessage:writeString(Common.getImsi())
	--SysVerNumber  系统版本号
	nMBaseMessage:writeString(Common.getSystemVersion())
	--ScreenSize  手机屏幕尺寸
	nMBaseMessage:writeString("")
	--OsID  手机终端ID
	if Common.platform == Common.TargetIos then
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(0)
	end
	--ICCID Text 手机sim卡iccid
	nMBaseMessage:writeString(Common.getICCID());
	--CPUInfo 手机CPU信息
	--MemoryInfo 内存信息

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求屏蔽某玩家站内信
--]]--
function sendDBID_SHIELD_MAIL_USERID(gameId,type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_SHIELD_MAIL_USERID)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()
	-- 被屏蔽用户ID
	nMBaseMessage:writeInt(gameId)
	-- 操作类别
	nMBaseMessage:writeByte(type)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

end

--[[--
--请求移动支付方式
--]]
function sendMANAGERID_MOBILE_PAYMENT_MODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MOBILE_PAYMENT_MODE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- GameID byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- VersionCode Int 游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--ICCID	Text	SIM卡ICCID
	nMBaseMessage:writeString(Common.getICCID());
	--IMEI	Text	手机IMEI和MAC地址
	nMBaseMessage:writeString(Common.getDeviceInfo());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求联通支付方式
--]]
function sendMANAGERID_CU_PAYMENT_MODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_CU_PAYMENT_MODE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- GameID byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- VersionCode Int 游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--ICCID	Text	SIM卡ICCID
	nMBaseMessage:writeString(Common.getICCID());
	--IMEI	Text	手机IMEI和MAC地址
	nMBaseMessage:writeString(Common.getDeviceInfo());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求电信支付方式
--]]
function sendMANAGERID_CT_PAYMENT_MODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_CT_PAYMENT_MODE)
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart()

	-- GameID byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- VersionCode Int 游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--ICCID	Text	SIM卡ICCID
	nMBaseMessage:writeString(Common.getICCID());
	--IMEI	Text	手机IMEI和MAC地址
	nMBaseMessage:writeString(Common.getDeviceInfo());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求找回密码]]
function sendDBID_FIND_PASSWORD(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_FIND_PASSWORD)


	local username = dataTable["username"]
	local phonenum = dataTable["phonenum"]
	local imei = dataTable["imei"]

	nMBaseMessage:writeStart()
	--NickName  用户昵称
	nMBaseMessage:writeString(username)
	--Tel  手机
	nMBaseMessage:writeString(phonenum)
	--IMEI  imei
	--nMBaseMessage:writeString("android_865721010237506_null")
	nMBaseMessage:writeString(imei)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求支付
--]]
function sendMANAGERID_V3_RECHARGE(ProductDetail, PaymentInformation, payChannel, position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_V3_RECHARGE)
	nMBaseMessage:writeStart()

	-- GameID Byte 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- rechargeAmount Int 充值金额（fen）
	nMBaseMessage:writeInt(ProductDetail.price);
	-- ChannelID Int 渠道id
	nMBaseMessage:writeInt(Common.getChannelID());
	-- ScreenSize Text 屏幕尺寸
	nMBaseMessage:writeString("800");
	-- IsDirectExchangeCoin Byte 是否直接兑换成金币 1是0否
	nMBaseMessage:writeByte(PaymentInformation.isChangeCoin);
	-- RechargeWay Byte 1：充值卡，2：支付宝，3：银联

	-- 模拟支付测试
	--nMBaseMessage:writeByte(999);
	nMBaseMessage:writeByte(payChannel);
	-- GiftBagID int 礼包ID 若不为0，则充值后直接购买礼包；
	nMBaseMessage:writeInt(PaymentInformation.giftID);
	-- Position Int 位置编码
	nMBaseMessage:writeInt(position);
	--SerialNumber long 流水号
	nMBaseMessage:writeLong(ProductDetail.SerialNumber);

	if payChannel ==  profilePay.PayChannelData.ALI_PAY then
		-- 支付宝子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.WEIXIN_PAY then
		-- 微信子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.UNION_PAY then
		-- 银联子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.SMS_UNICOM then
		-- 联通沃商店子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.MM_PAY_V2 then
		-- MM子协议
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.HUAJIAN_DIANXIN_PAY then
		-- 电信短代支付
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.SMS_ONLINE then
		-- 移动短代支付
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.HUAJIAN_LIANTONG_PAY then
		-- 联通短代支付
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.RECHARGE_CARD_PAY then
		-- 充值卡子协议
		--ParamCnt	byte	特殊支付方式的参数表	不同支付方式分别定义
		nMBaseMessage:writeByte(4);
		--…ParamValue	Text	参数值
		-- e宝子协议
		-- Pa8_cardNo Text 卡号
		nMBaseMessage:writeString(ProductDetail.Pa8_cardNo);
		-- Pa9_cardPwd Text 密码
		nMBaseMessage:writeString(ProductDetail.Pa9_cardPwd);
		-- Pa7_cardAmt Int 卡面额(分)
		nMBaseMessage:writeString("" ..ProductDetail.price);
		-- Pd_frpId Text 支付渠道编码
		nMBaseMessage:writeString(ProductDetail.Pd_frpId);
	elseif payChannel ==  profilePay.PayChannelData.RECHARGE_91 then
		-- 91
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.HAIMA_PAY then
		-- 海马
		nMBaseMessage:writeByte(0);
	elseif payChannel ==  profilePay.PayChannelData.IAP_PAY then
		-- iap支付
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.NEW_UNION_PAY then
		--新银联支付
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.EPAY then
		--宜支付
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.YINBEIKEPAY_CMCC then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.YINBEIKEPAY_UNI then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.YINBEIKEPAY_CT then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.HONGRUAN_SDK_CMCC then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.HONGRUAN_SDK_UNICOM then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.HONGRUAN_SDK_CT then
		nMBaseMessage:writeByte(0);
	elseif payChannel == profilePay.PayChannelData.RECHARGE_WOJIA then
		nMBaseMessage:writeByte(0);
	end

	--AimUserID	int	代充金币目标用户
	nMBaseMessage:writeInt(GameConfig.giftUserID);
	--	miniGameID	int	小游戏ID
	nMBaseMessage:writeInt(GameLoadModuleConfig.getLoadModuleGameID());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


------------------------------------------------------------------
--[[-------------IM_ID聊天室消息----------------------- ]]
------------------------------------------------------------------

--[[-- 请求进入聊天室]]
function sendIMID_ENTER_CHAT_ROOM(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_ENTER_CHAT_ROOM)
	nMBaseMessage:writeStart()
	--ChatRoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	--NickName  昵称
	nMBaseMessage:writeString(dataTable["NickName"])
	--IsFirstEnter  是否第一次进入
	nMBaseMessage:writeByte(dataTable["IsFirstEnter"])
	--ChatRoomName  聊天室标识（与ChatRoomID共同做Key）
	nMBaseMessage:writeString(dataTable["ChatRoomName"])
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求聊天室发言]]
function sendIMID_CHAT_ROOM_SPEAK(sendChat)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_CHAT_ROOM_SPEAK)
	nMBaseMessage:writeStart()
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	--SpeechText  发言内容
	nMBaseMessage:writeString(sendChat)

	--ChatRoomName  聊天室标识（与ChatRoomID共同做Key）
	--nMBaseMessage:writeString()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求退出聊天室]]
function sendIMID_QUIT_CHAT_ROOM()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_QUIT_CHAT_ROOM)

	nMBaseMessage:writeStart()
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求显示聊天室当前最新消息]]
function sendIMID_GET_LAST_CHAT_ROOM_SPEAK()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_GET_LAST_CHAT_ROOM_SPEAK)

	nMBaseMessage:writeStart()
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--屏蔽举报某玩家聊天--]]
function sendIMID_OPERATE_CHAT_USER_TYPE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + IMID_OPERATE_CHAT_USER_TYPE)

	nMBaseMessage:writeStart()
	--OperateUserID	int	被举报用户ID
	nMBaseMessage:writeInt(dataTable["OperateUserID"])
	Common.log("OperateUserID",dataTable["OperateUserID"])
	--OperateType	byte	操作类别	0：屏蔽  1：举报
	nMBaseMessage:writeByte(dataTable["OperateType"])
	Common.log("OperateType",dataTable["OperateType"])
	--RoomID  聊天室ID（目前填写游戏ID即可）
	nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[--
--获取初始化图片
--]]
function sendMANAGERID_GET_INIT_PIC(TimeStamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_INIT_PIC)

	nMBaseMessage:writeStart()

	--GameID	Byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--TimeStamp	Long	时间戳
	nMBaseMessage:writeLong(TimeStamp)
	--version	Int	版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求绑定用户手机号]]
function sendMANAGERID_BINDING_USER_PHONE_NUMBER()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_BINDING_USER_PHONE_NUMBER)

	nMBaseMessage:writeStart()
	--Phone_number  手机号
	nMBaseMessage:writeString()
	--UserID  用户ID
	nMBaseMessage:writeInt()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖]]
function sendMANAGERID_EXCHANGE_AWARD(goodid,username,phone,youbian,address,orderID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_EXCHANGE_AWARD)

	nMBaseMessage:writeStart()
	--GoodID  物品ID
	nMBaseMessage:writeInt(goodid)
	--Name  姓名
	nMBaseMessage:writeString(username)
	--PhoneNumber  电话
	nMBaseMessage:writeString(phone)
	--PostCode  邮编
	nMBaseMessage:writeString(youbian)
	--Address  地址
	nMBaseMessage:writeString(address)
	--OrderID 订单号
	nMBaseMessage:writeInt(orderID)
	--GameID 游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获得用户充值记录]]
function sendGET_RECHARGE_RECORD(PageStartID,PageSize)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GET_RECHARGE_RECORD)

	nMBaseMessage:writeStart()
	--Start  起始数
	nMBaseMessage:writeInt(PageStartID)
	--Count  每页数
	nMBaseMessage:writeByte(PageSize)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取绑定手机号随机码]]
function sendMANAGERID_GET_BINDING_PHONE_RANDOM()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_BINDING_PHONE_RANDOM)
	Common.log("sendMANAGERID_GET_BINDING_PHONE_RANDOM")
	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取所有奖品]]
function sendMANAGERID_GET_PRESENTS(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_PRESENTS)

	nMBaseMessage:writeStart()
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取游戏基地支付说明数据]]
function sendMANAGERID_MOBILE_PAY_DATA()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MOBILE_PAY_DATA)

	nMBaseMessage:writeStart()
	--GameId  游戏id
	nMBaseMessage:writeByte()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求获取自己兑换的奖品列表]]
function sendMANAGERID_GET_EXCHANGE_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_EXCHANGE_AWARDS)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求支付数据列表
--@param #table PayData 请求的支付列表类型
--]]
function sendPAYMENT_DATA_LIST(PayData)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + PAYMENT_DATA_LIST)
	nMBaseMessage:writeStart()
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(0)
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	--PayChannelSize	byte	需要获取的支付列表类型数
	nMBaseMessage:writeByte(#PayData)
	--…PayChannelType	byte	支付列表类型
	for i = 1, #PayData do
		nMBaseMessage:writeByte(PayData[i])
	end

	Common.log("请求支付数据列表")
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求得到当前手机绑定的用户列表]]
function sendBASEID_GET_IMEIUSERS(imei)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_GET_IMEIUSERS)

	nMBaseMessage:writeStart()
	Common.log("imei"..imei)
	--IMEI  IMEI号和MAC
	--nMBaseMessage:writeString("android_865721010237506_null")
	nMBaseMessage:writeString(imei)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--请求门票]]
function sendTICKET_GET_TICKET_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TICKET_GET_TICKET_LIST)

	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求回话列表]]
function sendDBID_V2_GET_CONVERSATION_LIST(PageStartID,PageSize)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_GET_CONVERSATION_LIST)

	nMBaseMessage:writeStart()
	--PageStartID  本页请求起始ID
	nMBaseMessage:writeInt(PageStartID)
	--PageSize  每页几条数据
	nMBaseMessage:writeByte(PageSize)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求会话详情]]
function sendDBID_V2_GET_CONVERSATION(ConversationID,PageSize,PageStartID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_GET_CONVERSATION)

	nMBaseMessage:writeStart()
	--ConversationID  会话ID
	nMBaseMessage:writeInt(ConversationID)
	--PageStartID  本页请求起始ID
	nMBaseMessage:writeInt(PageStartID)
	--PageSize  每页几条数据
	nMBaseMessage:writeByte(PageSize)
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendDBID_V2_GET_CONVERSATION")
end
--[[-- 请求删除会话]]
function sendDBID_V2_DELETE_CONVERSATION(ConversationID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_DELETE_CONVERSATION)

	nMBaseMessage:writeStart()
	--ConversationID  会话ID
	nMBaseMessage:writeInt(ConversationID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求删除会话]]
function sendDBID_V2_EMPTY_CONVERSITION(ConversationID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_EMPTY_CONVERSITION)

	nMBaseMessage:writeStart()
	--ConversationID  会话ID
	nMBaseMessage:writeInt(ConversationID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求发送会话]]
function sendDBID_V2_SEND_MESSAGE(userID,msg,phonenum,phonetype,imei,connecttype,version)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_SEND_MESSAGE)

	nMBaseMessage:writeStart()
	--ReciverUserID  接收者用户ID
	nMBaseMessage:writeInt(userID)
	--MessageContent  消息内容
	nMBaseMessage:writeString(msg)
	--moblieType  手机型号
	nMBaseMessage:writeString(Common.getModel())
	--moblieNo  手机号码
	nMBaseMessage:writeString(phonenum)
	--Imei  Imei
	nMBaseMessage:writeString(imei)
	--ConnectionType  连接类型
	nMBaseMessage:writeString(connecttype)
	--gameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Version  版本
	nMBaseMessage:writeString(version)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖列表]]
function sendMANAGERID_PRIZE_PIECES_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PRIZE_PIECES_LIST)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖操作]]
function sendMANAGERID_PIECES_COMPOUND_DETAILS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PIECES_COMPOUND_DETAILS)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--PiecesID  碎片ID
	nMBaseMessage:writeInt()

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖操作]]
function sendMANAGERID_GET_PIECES_SHOP_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_PIECES_SHOP_LIST)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求兑奖券碎片兑奖]]
function sendMANAGERID_PIECES_EXCHANGE(goodID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PIECES_EXCHANGE)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GoodID  物品id
	nMBaseMessage:writeInt(goodID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求我的奖品]]
function sendMANAGERID_GET_EXCHANGE_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_EXCHANGE_AWARDS)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求新充值卡备选奖品列表]]
function sendNEW_GET_ALTERNATIVE_PRIZE_LIST(awardID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NEW_GET_ALTERNATIVE_PRIZE_LIST)

	nMBaseMessage:writeStart()
	--PrizeID  奖品ID
	nMBaseMessage:writeInt(awardID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求新充值卡备选奖品列表2]]
function sendNEW_GET_ALTERNATIVE_PRIZE(awardID,type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NEW_GET_ALTERNATIVE_PRIZE)

	nMBaseMessage:writeStart()
	--PrizeID  奖品ID
	nMBaseMessage:writeInt(awardID)
	--ItemType  备选奖品类型
	nMBaseMessage:writeByte(type)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求新获取自己赢得的奖品列表]]
function sendNEW_GET_PRIZE_LIST(time,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NEW_GET_PRIZE_LIST)

	nMBaseMessage:writeStart()
	--AwardTime  最后一个奖品的获奖日期
	nMBaseMessage:writeLong(time)
	--Count  请求数量
	nMBaseMessage:writeByte(num)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


--[[-- 请求碎片合成操作]]
function sendMANAGERID_COMPOUND_V2(PiecesID,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_COMPOUND_V2)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--PiecesID  碎片ID
	nMBaseMessage:writeInt(PiecesID)
	--compoundNum  合成兑奖券的数量
	nMBaseMessage:writeInt(num)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求碎片合成列表]]
function sendMANAGERID_PIECES_COMPOUND_DETAILS_V2()
	if Services:getMessageService():getCutOut() then
		return
	end
	profile.Pack.setPriceCompoundDone(false);
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PIECES_COMPOUND_DETAILS_V2)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--lua脚本版本检测]]
function sendMANAGERID_LUA_SCRIPT_VERSION_V2(AppMd5)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_SCRIPT_VERSION_V2)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--netType byte 网络类型 0未知1 wifi 2 2G 33G
	nMBaseMessage:writeByte(Common.getConnectionType())
	--isFullPackage	byte 是否是完整包  0不是，1是
	nMBaseMessage:writeByte(1)
	--AppMd5 Text 客户端App文件合集的MD5
	nMBaseMessage:writeString(AppMd5)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--lua脚本版本MD5校验]]
function sendMANAGERID_LUA_SCRIPT_MD5(VersionCode, ScriptVerCode, ScriptMD5)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_SCRIPT_MD5)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--VersionCode	Int	游戏版本号	(游戏版本号+渠道号)
	nMBaseMessage:writeInt(VersionCode)
	--ScriptVerCode	Int	脚本版本号
	nMBaseMessage:writeInt(ScriptVerCode)
	--ScriptMD5	Text	脚本MD5	将脚本资源文件MD5拼接所得字符串，再取MD5值后上传。如果为空字符串，则表示本次不校验MD5
	nMBaseMessage:writeString(ScriptMD5)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.100 小游戏列表状态消息(MANAGERID_MINIGAME_LIST_TYPE)
function sendMANAGERID_MINIGAME_LIST_TYPE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LIST_TYPE)
	nMBaseMessage:writeStart()
	--GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求ituns商城验证]]
function sendMANAGERID_VALIDATE_IAP(receipt,goodid,userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VALIDATE_IAP)

	nMBaseMessage:writeStart()
	--加密json信息
	nMBaseMessage:writeString(receipt)
	--支付方式，测试还是支付
	nMBaseMessage:writeString(GameConfig.PayType)
	--订单号
	nMBaseMessage:writeString(goodid)
	--userID
	nMBaseMessage:writeString(userID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求ituns商城验证]]
function sendMANAGERID_VALIDATE_IAP_V2(receipt,goodid,userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VALIDATE_IAP_V2)

	nMBaseMessage:writeStart()
	--加密json信息
	nMBaseMessage:writeString(receipt)
	--支付方式，测试还是支付
	nMBaseMessage:writeString(GameConfig.PayType)
	--订单号
	nMBaseMessage:writeString(goodid)
	--userID
	nMBaseMessage:writeString(userID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------请求删除IMEI下绑定的用户账号-------------------
function sendMANAGERID_DELETE_IMEIUSERS(IMEI,DeleteName)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_DELETE_IMEIUSERS)
	nMBaseMessage:writeStart()
	--IMEI
	nMBaseMessage:writeString(IMEI)
	--DeleteName
	nMBaseMessage:writeString(DeleteName)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求活动列表消息
--]]--
function sendOPERID_GET_OPER_TASK_LIST_V2(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_OPER_TASK_LIST_V2)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--活动数量
	nMBaseMessage:writeByte(#dataTable)
	for i = 1,#dataTable do
		nMBaseMessage:writeInt(dataTable[i].GameID)
		nMBaseMessage:writeInt(dataTable[i].Version)
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求合成信息]]
function sendMANAGERID_COMPOUND_INFO(lastnum,num)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_COMPOUND_INFO)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--LatestItemID  上次取到的最后一
	nMBaseMessage:writeInt(lastnum)
	--Limit  想取多少条，最多200
	nMBaseMessage:writeShort(num)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--根据URL获取web页面源码
function sendCOMMONS_HTTPPROXY(URL, HashCode, Key)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + COMMONS_HTTPPROXY)
	nMBaseMessage:writeStart()
	--URL	Text	请求页面的URL
	nMBaseMessage:writeString(URL)
	--HashCode	Int	请求页面的hash值
	nMBaseMessage:writeInt(HashCode)
	--Key	string	请求存入本地的key
	nMBaseMessage:writeString(Key)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--获取跑马灯内容消息--]]
function sendOPERID_ACTIVITY_MARQUEE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_ACTIVITY_MARQUEE)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	--组织 表明请求位置
	nMBaseMessage:writeInt(dataTable["position"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--请求现金奖品列表 (OPERID_GET_CASH_AWARD_LIST)--]]
function sendOPERID_GET_CASH_AWARD_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_CASH_AWARD_LIST)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[----3.15.19 请求同步现金限量奖品数量 (OPERID_GET_CASH_AWARD_REMAINDER)--]]
function sendOPERID_GET_CASH_AWARD_REMAINDER(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_CASH_AWARD_REMAINDER)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--AwardsCnt int
	nMBaseMessage:writeInt(#dataTable)
	--AwardID int 循环
	for i = 1,#dataTable do
		nMBaseMessage:writeInt(dataTable[i])
	end
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--3.15.20 请求兑换限量奖品 --]]
function sendOPERID_EXCHANGE_LIMITED_AWARD(awardID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_EXCHANGE_LIMITED_AWARD)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(awardID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--3.15.29 请求我的奖品中现金奖品列表 --]]
function sendOPERID_GET_CASH_PRIZE_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_CASH_PRIZE_LIST)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--3.15.30 请求我的奖品中现金奖品列表 --]]
function sendOPERID_PRIZE_EXCHANGE_MOBILE_FARE(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_PRIZE_EXCHANGE_MOBILE_FARE)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(dataTable.PrizeID)
	nMBaseMessage:writeString(dataTable.ContactName)
	nMBaseMessage:writeString(dataTable.TelNumber)
	nMBaseMessage:writeString(dataTable.IDNumber)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--3.15.31 请求我的奖品中现金奖品列表 --]]
function sendOPERID_PRIZE_EXCHANGE_GAME_COIN(PrizeID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_PRIZE_EXCHANGE_GAME_COIN)
	nMBaseMessage:writeStart()
	--GameID Byte
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeInt(PrizeID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
* 添加ios deviceToken
* @param deviceToken串
--]]
function sendADD_DEVICE_TOKEN(deviceToken)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ADD_DEVICE_TOKEN)
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--被踢用户ID
	nMBaseMessage:writeString(deviceToken)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--上传错误信息
--]]
function sendSTATID_COMMIT_EXCEPTION_INFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + STATID_COMMIT_EXCEPTION_INFO)
	nMBaseMessage:writeStart()
	--UserID 用户ID int
	nMBaseMessage:writeInt(dataTable["userId"])
	--ExceptionInfo 错误信息 String
	nMBaseMessage:writeString(dataTable["userId"] .. "-" .. Common.getVersionName() .. "-" .. Common.getChannelID() .. "-" .. dataTable["exceptionInfo"])
	--GameID	int	游戏ID
	nMBaseMessage:writeInt(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendSTATID_COMMIT_EXCEPTION_INFO");
end

--[[--
-- 用户统计消息
--]]
function sendSTAID_COMMIT_ACTIVITY_STAY(stayTime)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + STAID_COMMIT_ACTIVITY_STAY)
	nMBaseMessage:writeStart()

	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--活动数量
	nMBaseMessage:writeByte(1)
	--用户活动ID
	nMBaseMessage:writeShort(GameConfig.STAY_TIME)
	-- ...EnterTime	Long	进入时间戳	毫秒
	nMBaseMessage:writeLong(GameConfig.enterGameTime*1000)
	-- ...StayTime	Short	停留时间	秒
	nMBaseMessage:writeShort(stayTime)
	Common.log("用户停留时间======="..stayTime)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求站内信消息领奖列表]]
function sendMAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4(MessageId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--消息id
	nMBaseMessage:writeInt(MessageId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求站内信消息列表]]
function sendMAIL_SYSTEM_MESSGE_LIST(LastMessageId,Count)
	Common.log("Client2Server")
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAIL_SYSTEM_MESSGE_LIST)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--上条消息id
	nMBaseMessage:writeInt(LastMessageId)
	--列表数量
	nMBaseMessage:writeInt(Count)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("Client2Server1")
end

--站内信消息阅读
function sendMAIL_SYSTEM_MESSAGE_READ(MessageId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAIL_SYSTEM_MESSAGE_READ)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--上条消息id
	nMBaseMessage:writeInt(MessageId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------推送通知消息----------------------- ]]
------------------------------------------------------------------
function sendNOTIFICATION_PUSH_LIST_V2(timeStamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + NOTIFICATION_PUSH_LIST_V2)
	nMBaseMessage:writeStart()

	--AppVersionCode Int 平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() .. Common.getChannelID())

	--平台
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--时间戳
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(timeStamp)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[---------------------备选奖品领奖-------------------------- ]]
function sendGET_ALTERNATIVE_PRIZE_V2(PrizeID, ItemType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GET_ALTERNATIVE_PRIZE_V2)
	nMBaseMessage:writeStart()
	Common.log("备选奖品领奖")
	nMBaseMessage:writeInt(PrizeID)
	Common.log("备选奖品领奖"..PrizeID)
	nMBaseMessage:writeByte(ItemType)
	Common.log("备选奖品领奖"..ItemType)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[---------------------手机卡兑奖-------------------------- ]]
function sendRechargeable_Card_AWARD_V2(PrizeId, Name, PhoneNumber)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + Rechargeable_Card_AWARD_V2)
	nMBaseMessage:writeStart()
	Common.log("手机卡兑奖")
	nMBaseMessage:writeInt(PrizeId)
	Common.log("手机卡兑奖"..PrizeId)
	nMBaseMessage:writeString(Name)
	Common.log("手机卡兑奖"..Name)
	nMBaseMessage:writeString(PhoneNumber)
	Common.log("手机卡兑奖"..PhoneNumber)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--小游戏列表状态消息(支持单个功能的脚本更新)
--]]--
function sendMANAGERID_MINIGAME_LIST_TYPE_V2(MiniGameTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	Common.log("小游戏列表状态消息(支持单个功能的脚本更新)")
	nMBaseMessage:setMessageType(REQ + MANAGERID_MINIGAME_LIST_TYPE_V2)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--小游戏数量
	nMBaseMessage:writeByte(#MiniGameTable)
	for i = 1, #MiniGameTable do
		--小游戏ID
		nMBaseMessage:writeInt(MiniGameTable[i].GameID)
		--小游戏版本 从1开始
		nMBaseMessage:writeInt(MiniGameTable[i].Version)
	end

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.112 获取可兑奖的奖品列表
function sendMANAGERID_GET_EXCHANGBLE_AWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_EXCHANGBLE_AWARDS)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--3.7.139 lua脚本版本资源列表路径MD5上传(MANAGERID_LUA_FILE_PATH_UP)
--@param #String BatchNum 批次号
--@param #String AppMd5 客户端App文件合集的MD5
--@param #number FileListTotalNum 资源文件总条数
--@param #table FileListTable 本次资源文件上传集合
--]]--
function sendMANAGERID_LUA_FILE_PATH_UP(BatchNum, AppMd5, FileListTotalNum, FileListTable)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_LUA_FILE_PATH_UP);
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart();

	--BatchNum	Text	批次号	用户上传唯一批次号
	nMBaseMessage:writeString(BatchNum);
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--ScriptVerCode	Int	脚本版本号	(游戏版本号+渠道号)
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--AppMd5	Text	客户端App文件合集的MD5
	nMBaseMessage:writeString(AppMd5);
	--FileListTotalNum	Int	资源文件总条数
	nMBaseMessage:writeInt(FileListTotalNum)
	--CurrUpNum	Int	本次资源文件上传集合条数
	nMBaseMessage:writeInt(#FileListTable)
	for i = 1, #FileListTable do
		--…FileAbsolutePath	Text	资源文件相对路径
		--Common.log("FileListTable.FileAbsolutePath === "..FileListTable[i].FileAbsolutePath);
		nMBaseMessage:writeString(FileListTable[i].FileAbsolutePath);
		--…FileMd5	Text	资源文件Md5
		--Common.log("FileListTable.FileMd5 === "..FileListTable[i].FileMd5);
		nMBaseMessage:writeString(FileListTable[i].FileMd5);
	end

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.16.30 成就任务列表（COMMONS_LIFETIME_TASKLIST）
--]]--
function sendCOMMONS_LIFETIME_TASKLIST()
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_LIFETIME_TASKLIST);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--	nMBaseMessage:writeByte(1);
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.16.31 领取成就任务奖励（COMMONS_GET_LIFETIME_TASKPRIZE）
@param taskId 任务ID
--]]--
function sendCOMMONS_GET_LIFETIME_TASKPRIZE(TimeStamp,taskId)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_LIFETIME_TASKPRIZE);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--	nMBaseMessage:writeByte(1);
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeLong(TimeStamp)
	nMBaseMessage:writeInt(taskId)

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.16.32 每日任务列表（COMMONS_DAILYTASK）
--]]--
function sendCOMMONS_DAILYTASK()
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_DAILYTASK);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--	nMBaseMessage:writeByte(1);
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.16.33 领取每日任务奖励（COMMONS_GET_DAILYTASK_PRIZE）
@param taskId 任务ID
--]]--
function sendCOMMONS_GET_DAILYTASK_PRIZE(taskId)
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_GET_DAILYTASK_PRIZE);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--	nMBaseMessage:writeByte(1);
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeInt(taskId)

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.16.34 更新IMEI（COMMONS_UPDATE_IMEI）
--]]
function sendCOMMONS_UPDATE_IMEI()
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + COMMONS_UPDATE_IMEI);
	nMBaseMessage:setMsgVer(0) --消息版本号
	nMBaseMessage:writeStart();

	--Imei	Text
	nMBaseMessage:writeString(Common.getNeedUpdateIMEI());

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[
添加android devicetoken    3.7.140
]]
function sendMANAGERID_ADD_ANDROID_DEVICE_TOKEN(strtoken)
	Common.log("sendMANAGERID_ADD_ANDROID_DEVICE_TOKEN token:"..strtoken)

	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_ADD_ANDROID_DEVICE_TOKEN);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeString(strtoken)

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.148上传联网IP (MANAGERID_NETWORK_IP)
--]]--
function sendMANAGERID_NETWORK_IP(networkIP)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_NETWORK_IP);
	nMBaseMessage:writeStart();
	--networkIP	Text	联网使用的IP
	nMBaseMessage:writeString(networkIP);

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--appStore 评价奖励
--]]
function sendAPPSTORE_COMMENT_COIN()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()

	--Common.log("appStore 评价奖励")
	nMBaseMessage:setMessageType(REQ + APPSTORE_COMMENT_COIN)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--AppVersionCode	Int	平台或者游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--3.1.32 第三方渠道登录
--]]
function sendBASEID_THIRD_PART_PLAT_LOGIN(strToken, strThirdPartPlatUID, nThirdPartPlatId, strUsername, strPassword)
	Common.log("sendBASEID_THIRD_PART_PLAT_LOGIN strToken:"..strToken)

	if Services:getMessageService():getCutOut() then
		Common.log("停止发送三方登录")
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BASEID_THIRD_PART_PLAT_LOGIN)
	--nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	--IMIE	text	IMIE号和MAC	以html5/android/ios +’_’开头+IMIE_MAC
	nMBaseMessage:writeString(Common.getDeviceInfo());
	--Token	Text	第三方登录token或Session
	nMBaseMessage:writeString(strToken);
	--AppVersionCode	Int	游戏版本号	版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--LoginChannelID	text	登录渠道号
	nMBaseMessage:writeString(Common.getChannelID());
	--mobile	Text	手机号码
	nMBaseMessage:writeString("");
	--GameID	byte	发起注册的GameId	0平台--1斗地主--2德州--3麻将--4 扎金花
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--OSID	byte	操作系统ID	客户端类型 1- Android 2- Html5 3-IOS（废除）--4-	LUA-安卓--5-	5-LUA-ios
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--thirdPartPlatUID	Text	第三方渠道的用户ID
	nMBaseMessage:writeString(strThirdPartPlatUID);
	--thirdPartPlatId	Int	第三方登录平台的id
	--THIRD_PART_PLAT_DIANJIN = 1
	--THIRD_PART_PLAT_UC = 2 THIRD_PART_PLAT_XIAOMI = 3
	--THIRD_PART_PLAY_ANZHI = 4;
	--THIRD_PART_PLAY_GAME_BASE = 5;
	--THIRD_PART_PLAY_IDREAM_SKY = 6;
	--THIRD_PART_PLAY_LEYOU = 7;
	--THIRD_PART_OURPALM_GAMEBASE = 8;
	--THIRD_PART_PLAT_OPPO = 9;
	--THIRD_PART_PLAT_7K =10;
	--THIRD_PART_PLAT_XY = 11;
	--THIRD_PART_PLAT_HAIMA = 12;
	--THIRD_PART_PLAT_QIHU360 = 13;
	--THIRD_PART_PLAT_WEIXIN = 15;
	nMBaseMessage:writeInt(nThirdPartPlatId);
	--UserName	text	同趣用户名
	nMBaseMessage:writeString(strUsername);
	--Password	text	同趣密码
	nMBaseMessage:writeString(strPassword);
	--PhoneType	String	手机型号
	nMBaseMessage:writeString(Common.getModel());

	nMBaseMessage:writeOver()

	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()

	Common.log("发送三方登录")
end

--[[--
--3.7.142 微信绑定(MANAGERID_WECHAT_BIND)
--]]--
function sendMANAGERID_WECHAT_BIND(strToken)
	if Services:getMessageService():getCutOut() then
		Common.log("停止发送微信绑定")
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_WECHAT_BIND);
	nMBaseMessage:writeStart();
	--Token	Text	第三方登录token或Session
	nMBaseMessage:writeString(strToken);
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.143 是否是微信绑定用户(MANAGERID_IS_BIND_WECHAT)
--]]--
function sendMANAGERID_IS_BIND_WECHAT(NickName)
	if Services:getMessageService():getCutOut() then
		Common.log("停止发送是否是微信绑定用户")
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + MANAGERID_IS_BIND_WECHAT);
	nMBaseMessage:writeStart();
	--NickName  	Text	是否是微信绑定用户
	nMBaseMessage:writeString(NickName);

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.157 获取当前手机用户登录列表信息(MANAGERID_USERLIST_FROM_IMIE)
--]]--
function sendMANAGERID_USERLIST_FROM_IMIE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();

	nMBaseMessage:setMessageType(REQ + MANAGERID_USERLIST_FROM_IMIE);

	nMBaseMessage:writeStart();

	--IMIE	text	IMIE号和MAC	以html5/android/ios +’_’开头IMIE_MAC
	nMBaseMessage:writeString(Common.getDeviceInfo());
	--VersionCode	Int	游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--GameID	byte	发起登录的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.158 获取用户绑定微信信息(MANAGERID_HINT_BIND_WECHAT)
--]]--
function sendMANAGERID_HINT_BIND_WECHAT()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();

	nMBaseMessage:setMessageType(REQ + MANAGERID_HINT_BIND_WECHAT);

	nMBaseMessage:writeStart();

	--IMIE	text	IMIE，动态获取的手机IMEI
	nMBaseMessage:writeString(Common.getImei());
	--VersionCode	Int	游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID());
	--GameID	byte	发起登录的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.165 请求红包信息(MANAGERID_GET_RED_PACKETS_INFO)
--]]--
function sendMANAGERID_GET_RED_PACKETS_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();

	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_RED_PACKETS_INFO);

	nMBaseMessage:writeStart();

	--GameID	byte	发起登录的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
	Common.log("sendMANAGERID_GET_RED_PACKETS_INFO")
end

--[[--
--3.7.166 请求领取红包(MANAGERID_RECEIVE_RED_PACKETS)
--]]--
function sendMANAGERID_RECEIVE_RED_PACKETS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();

	nMBaseMessage:setMessageType(REQ + MANAGERID_RECEIVE_RED_PACKETS);

	nMBaseMessage:writeStart();

	--GameID	byte	发起登录的游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--3.7.185 用户GPS()
--]]--
function sendMANAGERID_USER_GPS(gpsStr)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();

	nMBaseMessage:setMessageType(REQ + MANAGERID_USER_GPS);

	nMBaseMessage:writeStart();

	--Gps	Text	地理位置	21.3213#321.32
	nMBaseMessage:writeString(gpsStr);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end