------------------------------------------------------------------
--[[------------------------本地重连消息----------------------- ]]
------------------------------------------------------------------

function read3e9(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = NETERR_CONN_FAILED
	dataTable["messageName"] = "NETERR_CONN_FAILED"
	return dataTable
end

function read3ea(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = NETERR_NET_BROKEN
	dataTable["messageName"] = "NETERR_NET_BROKEN"
	return dataTable
end

function read3eb(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = NETERR_CONN_SUCC
	dataTable["messageName"] = "NETERR_CONN_SUCC"
	return dataTable
end

--切出游戏
function read3ed(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = GAME_ENTER_BACKGROUND
	dataTable["messageName"] = "GAME_ENTER_BACKGROUND"
	return dataTable
end

--进入游戏
function read3ee(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = GAME_ENTER_FOREGROUND
	dataTable["messageName"] = "GAME_ENTER_FOREGROUND"
	return dataTable
end


--[[--解析服务器通知 ]]
function read40002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = REQ + GAMEID_SERVER_MSG
	dataTable["messageName"] = "GAMEID_SERVER_MSG"
	--Common.log("================== 解析服务器通知 ===============")

	-- Type Byte 类型 1:充值弹窗 2:飘字 3:比赛播报 4.系统公告 5.强制退出 6.Toast,7.冲榜飘字,8.普通弹框
	dataTable["nType"] = nMBaseMessage:readByte();
	-- Msg text 比赛状态的客户端提示语
	dataTable["sMsg"] = nMBaseMessage:readString();
	-- 充值是否成功（充值特有）1成功，0失败
	dataTable["isSucceed"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
-- 解析用户属性变更
-- @param helper
]]
function read80040006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GAMEID_USER_ATTR
	dataTable["messageName"] = "GAMEID_USER_ATTR"
	local UserAttrCN =  tonumber(nMBaseMessage:readInt());
	--Common.log("UserAttrCN ============== "..UserAttrCN)
	-- UserAttrCN byte 用户属性变化列表 Loop
	dataTable["UserAttr"] = {}
	for i = 1, UserAttrCN do
		dataTable["UserAttr"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …name Text 属性名
		-- 金币：coin元宝：yuanbao荣誉值：honor兑奖券：duijiang VIP等级：viplevel
		dataTable["UserAttr"][i].name = nMBaseMessage:readString();
		--Common.log("name ============== "..dataTable["UserAttr"][i].name)
		-- …value Text 属性值
		dataTable["UserAttr"][i].value = nMBaseMessage:readString();
		--Common.log("value ============== "..dataTable["UserAttr"][i].value)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
-- 图文Toast
]]
function read80040008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GAMEID_IMAGE_TOAST
	dataTable["messageName"] = "GAMEID_IMAGE_TOAST"
	--toastMsg	Text	提示文字
	dataTable["ToastMsg"] = nMBaseMessage:readString();
	--imageUrl	Text	图片地址
	dataTable["ImageUrl"] = nMBaseMessage:readString();
	return dataTable
end

--[[--
--接收注册消息
]]
function read80010001(nMBaseMessage)
	--Common.log("read80010001")
	local dataTable = {}
	dataTable["messageType"] = (ACK + BASEID_REGISTER)
	dataTable["messageName"] = "BASEID_REGISTER"

	--Result  注册结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("注册结果 = " .. dataTable["Result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--UserID  用户ID
	dataTable["UserID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("用户ID = " .. dataTable["UserID"])
	--NickName  昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("昵称 = " .. dataTable["NickName"])
	--Password  密码
	dataTable["Password"] = nMBaseMessage:readString()
	--Common.log("密码 = " .. dataTable["Password"])
	--YuanBao  元宝
	dataTable["YuanBao"] = tonumber(nMBaseMessage:readInt());
	--Common.log("元宝 = " .. dataTable["YuanBao"])
	--Coin  金币
	dataTable["Coin"] = tonumber(nMBaseMessage:readLong())
	--Common.log("金币 = " .. dataTable["Coin"])
	--honor  荣誉值
	dataTable["honor"] = tonumber(nMBaseMessage:readInt());
	--Common.log("荣誉值 = " .. dataTable["honor"])
	--PhotoUrl  头像URL
	dataTable["PhotoUrl"] = nMBaseMessage:readString()
	--Common.log("头像URL = " .. dataTable["PhotoUrl"])
	--SessionID  当前Socket连接的SessionID
	dataTable["SessionID"] = tonumber(nMBaseMessage:readLong())
	--Common.log("当前Socket连接的SessionID = " .. dataTable["SessionID"])

	return dataTable
end

--[[--
--接收登录消息
]]
function read80010002(nMBaseMessage)
	--Common.log("read80010002 == " .. nMBaseMessage:getLength())
	local dataTable = {}
	dataTable["messageType"] = (ACK + BASEID_LOGIN)
	dataTable["messageName"] = "BASEID_LOGIN"

	--UserID  用户ID
	dataTable["UserID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("用户ID = " .. dataTable["UserID"])
	--result  是否成功
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("是否成功 = " .. dataTable["result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--InitLoginInfoChanged  是否修改过原始登录信息
	dataTable["InitLoginInfoChanged"] = nMBaseMessage:readByte()
	--Common.log("是否修改过原始登录信息 = " .. dataTable["InitLoginInfoChanged"])
	--NickName  昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("昵称 = " .. dataTable["NickName"])
	--PhotoUrl  头像URL
	dataTable["PhotoUrl"] = nMBaseMessage:readString()
	--Common.log("头像URL = " .. dataTable["PhotoUrl"])
	--Coin  金币
	dataTable["Coin"] = tonumber(nMBaseMessage:readLong())
	--Common.log("金币 = " .. dataTable["Coin"])
	--UnreadMsgCnt  未读消息数量
	dataTable["UnreadMsgCnt"] = tonumber(nMBaseMessage:readInt());
	--Common.log("未读消息数量 = " .. dataTable["UnreadMsgCnt"])
	--SessionID  当前Socket连接的SessionID
	dataTable["SessionID"] = tonumber(nMBaseMessage:readLong())
	--Common.log("当前Socket连接的SessionID = " .. dataTable["SessionID"])
	--VipLevel  VIP等级
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	--Common.log("VIP等级 = " .. dataTable["VipLevel"])
	--yuanbao  元宝
	dataTable["yuanbao"] = tonumber(nMBaseMessage:readInt());
	--Common.log("元宝 = " .. dataTable["yuanbao"])
	--UserExtData  用户信息数据
	--byte数组
	--    byte[] data = getBytes();
	local length = nMBaseMessage:readShort();
	local pos = nMBaseMessage:getReadPos();

	-----------------------
	----- 接收游戏相关数据
	------------------------
	nMBaseMessage:setReadPos(pos + length)

	--ThirdPartPlatId	Int	第三方登录平台的id	0自有渠道登录 15 wechat登录 16 Facebook 登录
	dataTable["thirdPartPlatId"] = tonumber(nMBaseMessage:readInt());

	return dataTable
end

--[[-- 解析取出基本信息]]
function read80010003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_GET_BASEINFO
	dataTable["messageName"] = "BASEID_GET_BASEINFO"

	--UserID  用户ID
	dataTable["UserID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80010003 == 用户ID = " .. dataTable["UserID"])
	--NickName  昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	--Common.log("昵称 = " .. dataTable["NickName"])
	--Sex  性别
	dataTable["Sex"] = nMBaseMessage:readByte()
	--Common.log("性别 = " .. dataTable["Sex"])
	--Age  年龄
	dataTable["Age"] = nMBaseMessage:readByte()
	--Common.log("年龄 = " .. dataTable["Age"])
	--City  城市
	dataTable["City"] = nMBaseMessage:readString()
	--Common.log("城市 = " .. dataTable["City"])
	--PhotoUrl  头像URL
	dataTable["PhotoUrl"] = nMBaseMessage:readString()

	--Common.log("头像URL = " .. dataTable["PhotoUrl"])
	--sign  个性签名
	dataTable["sign"] = nMBaseMessage:readString()
	--Common.log("个性签名 = " .. dataTable["sign"])
	--Coin  金币
	dataTable["Coin"] = tonumber(nMBaseMessage:readLong())
	--Common.log("read80010003 金币 = " .. dataTable["Coin"])
	--yuanBao  元宝
	dataTable["yuanBao"] = tonumber(nMBaseMessage:readInt());
	--Common.log("元宝 = " .. dataTable["yuanBao"])
	--Honor  荣誉值
	dataTable["Honor"] = tonumber(nMBaseMessage:readInt());
	--Common.log("荣誉值 = " .. dataTable["Honor"])
	--DuiJiangQuan  兑奖券
	dataTable["DuiJiangQuan"] = tonumber(nMBaseMessage:readInt());
	--Common.log("兑奖券 = " .. dataTable["DuiJiangQuan"])
	--commendationCnt  奖状数
	dataTable["commendationCnt"] = tonumber(nMBaseMessage:readInt());
	--Common.log("奖状数 = " .. dataTable["commendationCnt"])
	--VipLevel  VIP等级
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	--Common.log("VIP等级 = " .. dataTable["VipLevel"])
	--djqPieces  兑奖券碎片
	dataTable["djqPieces"] = tonumber(nMBaseMessage:readInt());
	--Common.log("兑奖券碎片 = " .. dataTable["djqPieces"])
	--BirthDay	text	出生日期
	dataTable["BirthDay"] = tonumber(nMBaseMessage:readInt());
	--Common.log("出生日期  = " .. dataTable["BirthDay"])
	--魅力值，现在通用了，但还叫jhCharm
--	dataTable["Charm"] = tonumber(nMBaseMessage:readInt());
--	Common.log("魅力值 = " .. dataTable["JhCharm"])

	return dataTable
end

--[[-- 解析修改基本信息]]
function read80010004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_EDIT_BASEINFO
	dataTable["messageName"] = "BASEID_EDIT_BASEINFO"

	--Result  修改结果
	dataTable["Result"] = nMBaseMessage:readByte()
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("修改个人信息返回 = " .. dataTable["ResultTxt"])
	return dataTable
end
--[[-- 解析取出兑奖信息]]
function read80010006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_GET_AWARD
	dataTable["messageName"] = "BASEID_GET_AWARD"

	--result  请求结果
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("请求结果 = " .. dataTable["result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--RealName  真实姓名
	dataTable["RealName"] = nMBaseMessage:readString()
	--Common.log("真实姓名 = " .. dataTable["RealName"])
	--Tel  手机
	dataTable["Tel"] = nMBaseMessage:readString()
	--Common.log("手机 = " .. dataTable["Tel"])
	--Address  地址
	dataTable["Address"] = nMBaseMessage:readString()
	--Common.log("地址 = " .. dataTable["Address"])
	--PostCode  邮编
	dataTable["PostCode"] = nMBaseMessage:readString()
	--Common.log("邮编 = " .. dataTable["PostCode"])
	--IDCard  身份证
	dataTable["IDCard"] = nMBaseMessage:readString()
	--Common.log("身份证 = " .. dataTable["IDCard"])
	return dataTable
end

--[[-- 解析同步客户端时间]]
function read8001000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_TIMESTAMP_SYNC
	dataTable["messageName"] = "BASEID_TIMESTAMP_SYNC"

	--TimeStamp  服务器当前时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	return dataTable
end

--[[-- 解析版本检测]]
function read8001000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_PLAT_VERSION
	dataTable["messageName"] = "BASEID_PLAT_VERSION"

	CommDialogConfig.closeProgressDialog();
	dataTable["VersionData"] = {}

	-- apkVerCnt byte APK数量
	local apkCnt = tonumber(nMBaseMessage:readInt());
	for i = 1, apkCnt do
		dataTable["VersionData"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- …apkName Text APK包名 例如package="com.shuashuaent.client.platform"
		dataTable["VersionData"][i].gameName = nMBaseMessage:readString()
		-- …apkVerCode Int APK版本号
		dataTable["VersionData"][i].packageVerCode = tonumber(nMBaseMessage:readInt());
		-- …updateType byte 升级方案0不升级1建议升级2强制升级3需要安装
		dataTable["VersionData"][i].updateType = nMBaseMessage:readByte()
		-- …updataTxt Text 升级提示
		dataTable["VersionData"][i].updateTxt = nMBaseMessage:readString()
		-- …apkUpdateUrl Text 升级Url地址
		dataTable["VersionData"][i].updateUrl = nMBaseMessage:readString()
		-- …notificationTxt Text 通知栏文字
		dataTable["VersionData"][i].NotificationTxt = nMBaseMessage:readString()
		-- …updataAwardTxt Text 升级奖励文字 HTML
		dataTable["VersionData"][i].updataAwardTxt = nMBaseMessage:readString()
		-- …updataAppSizeTxt Text 升级包版本大小说明 HTML
		dataTable["VersionData"][i].updateAppSizeTxt = nMBaseMessage:readString()

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--解析获取用户充值信息
--]]
function read80510001(nMBaseMessage)
	--Common.log("read80510001")
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_USER_ENCHARGE_INFO
	dataTable["messageName"] = "GIFTBAGID_USER_ENCHARGE_INFO"
	--EnchargeAmount int 充值总金额
	dataTable["EnchargeAmount"] = tonumber(nMBaseMessage:readInt());

	return dataTable
end

--[[--
--解析通用礼包请求消息
--]]
function read80510003(nMBaseMessage)
	--    Pub.closeProgressDialog();
	--此协议只有在所请求的礼包不可购买的时候才会回复/可购买时返回3.8.4或3.8.5
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_REQUIRE_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_REQUIRE_GIFTBAG"
	-- GiftBagType int 礼包类别ID，此礼包不可购买
	dataTable["giftBagType"] = tonumber(nMBaseMessage:readInt());
	--Common.log("giftBagType = "..dataTable["giftBagType"])
	return dataTable
end

--[[--
-- 解析推送双核礼包
]]
function read80510005(nMBaseMessage)
	--Common.log("解析推送双核礼包********************")
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_PUSH_DUAL_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_PUSH_DUAL_GIFTBAG"

	-- GiftBagType int 礼 包 类 别 ID
	dataTable["mGiftBagType"] = tonumber(nMBaseMessage:readInt());
	-- BannerUrl Text banner 图 片 地 址
	dataTable["BannerUrl"] = nMBaseMessage:readString();
	-- TitleText Text 标 题 文 本
	dataTable["TitleText"] = nMBaseMessage:readString();
	-- GiftAwardNum Byte 礼 包 中 物 品 个 数
	local mnGiftAwardNum = tonumber(nMBaseMessage:readInt());

	dataTable["GiftBagData"] = {}
	for i = 1, mnGiftAwardNum do
		dataTable["GiftBagData"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- … GiftBagType int 礼 包 类 别 ID
		dataTable["GiftBagData"][i].mnGiftBagType = dataTable["mGiftBagType"];
		-- … GiftID int 礼 包 ID
		dataTable["GiftBagData"][i].mnGiftID = tonumber(nMBaseMessage:readInt());
		-- … GiftName Text 礼 包 名 称
		dataTable["GiftBagData"][i].msGiftName = nMBaseMessage:readString();

		--Common.log("限时礼包名字"..dataTable["GiftBagData"][i].msGiftName)

		-- … GiftPrice int 礼 包 价 格 ( 元)
		dataTable["GiftBagData"][i].mnGiftPriceRMB = tonumber(nMBaseMessage:readInt());
		-- … GiftPrice int 礼 包 价 格 ( 元)
		dataTable["GiftBagData"][i].mnGiftPriceYuanBao = tonumber(nMBaseMessage:readInt());
		-- … GiftImageUrl Text 礼 包 banner 图 片 地 址
		dataTable["GiftBagData"][i].msGiftImageUrl = nMBaseMessage:readString();
		-- … ButtonText Text 按 钮 文 本
		dataTable["GiftBagData"][i].msTitleMsg = nMBaseMessage:readString();
		-- … BuyCount int 购 买 次 数
		dataTable["GiftBagData"][i].mnBuyCount = tonumber(nMBaseMessage:readInt());

		nMBaseMessage:setReadPos(pos + length)
	end
	-- AllowTableShow byte 是 否 允 许 在 牌 桌 弹 出 1 :允 许 ， 0 :不 允 许
	dataTable["mnAllowTableShow"] = nMBaseMessage:readByte();
	-- PaymentType byte 支 付 类 型 1 :RMB ， 0 :元 宝
	dataTable["mnPaymentType"] = nMBaseMessage:readByte();
	-- RechargeMode	Byte	支付方式	0双按钮 1短代
	dataTable["RechargeMode"] = nMBaseMessage:readByte();
	--Common.log("dataTable[RechargeMode] === "..dataTable["RechargeMode"])

	--限时礼包剩余时间，如果不是限时礼包则为0
	dataTable["RemainTime"] = tonumber(nMBaseMessage:readLong());
	--Common.log("限时礼包剩余时间 === "..dataTable["RemainTime"])

	return dataTable
end

--[[-- 解析使用元宝购买礼包]]
function read80510006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_BUY_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_BUY_GIFTBAG"

	--result  是否成功1是0否
	dataTable["result"] = nMBaseMessage:readByte()
	--GiftBagType  礼包类别ID
	dataTable["GiftBagType"] = tonumber(nMBaseMessage:readInt());
	--GiftID  礼包ID
	dataTable["GiftID"] = tonumber(nMBaseMessage:readInt());
	--resultMsg
	dataTable["resultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析用户背包中新礼包状态]]
function read8051000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_NEWGIFT_TYPE
	dataTable["messageName"] = "GIFTBAGID_NEWGIFT_TYPE"

	--result  是否有新礼包1是0否
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("是否有新礼包1是0否 = " .. dataTable["result"])
	return dataTable
end

--[[-- 解析用户可购买礼包列表]]
function read80510009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_GIFTBAG_LIST
	dataTable["messageName"] = "GIFTBAGID_GIFTBAG_LIST"

	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = tonumber(nMBaseMessage:readInt());
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("GiftBagData---length = " .. length)
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = tonumber(nMBaseMessage:readInt());
		--Common.log("GiftBagData---礼包类别ID = " .. dataTable["GiftBagData"][i].GiftBagType)
		--…Name  名称
		dataTable["GiftBagData"][i].Name = nMBaseMessage:readString()
		--Common.log("GiftBagData---名称 = " .. dataTable["GiftBagData"][i].Name)
		--…goodsType  商品类型
		dataTable["GiftBagData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("GiftBagData---商品类型 = " .. dataTable["GiftBagData"][i].goodsType)
		--…IconURL  图标url
		dataTable["GiftBagData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("GiftBagData---图标url = " .. dataTable["GiftBagData"][i].IconURL)
		--…Description  描述
		dataTable["GiftBagData"][i].Description = nMBaseMessage:readString()
		--Common.log("GiftBagData---描述 = " .. dataTable["GiftBagData"][i].Description)
		nMBaseMessage:setReadPos(pos + length)
	end
	--VipGiftNum
	dataTable["VipGiftData"] = {}
	local VipGiftNum = tonumber(nMBaseMessage:readInt());
	--Common.log("VipGiftData---VipGiftNum = " .. VipGiftNum)
	for i = 1, VipGiftNum do
		dataTable["VipGiftData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("VipGiftData---length = " .. length)
		--…VipGiftID  Vip礼包ID
		dataTable["VipGiftData"][i].VipGiftID = tonumber(nMBaseMessage:readInt());
		--Common.log("VipGiftData---Vip礼包ID = " .. dataTable["VipGiftData"][i].VipGiftID)
		--…backpackName  背包显示名称
		dataTable["VipGiftData"][i].backpackName = nMBaseMessage:readString()
		--Common.log("VipGiftData---背包显示名称 = " .. dataTable["VipGiftData"][i].backpackName)
		--…Name  名称
		dataTable["VipGiftData"][i].Name = nMBaseMessage:readString()
		--Common.log("VipGiftData---名称 = " .. dataTable["VipGiftData"][i].Name)
		--…goodsType  商品类型
		dataTable["VipGiftData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("VipGiftData---商品类型 = " .. dataTable["VipGiftData"][i].goodsType)
		--…IconURL  图标url
		dataTable["VipGiftData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("VipGiftData---图标url = " .. dataTable["VipGiftData"][i].IconURL)
		--…Title  标题
		dataTable["VipGiftData"][i].Title = nMBaseMessage:readString()
		--Common.log("VipGiftData---标题 = " .. dataTable["VipGiftData"][i].Title)
		--…Description  描述
		dataTable["VipGiftData"][i].Description = nMBaseMessage:readString()
		--Common.log("VipGiftData---描述 = " .. dataTable["VipGiftData"][i].Description)
		--…ConsumeType  消耗类型
		dataTable["VipGiftData"][i].ConsumeType = nMBaseMessage:readByte()
		--Common.log("VipGiftData---消耗类型 = " .. dataTable["VipGiftData"][i].ConsumeType)
		--…Consume  单价
		dataTable["VipGiftData"][i].Consume = tonumber(nMBaseMessage:readInt());
		--Common.log("VipGiftData---单价 = " .. dataTable["VipGiftData"][i].Consume)
		--…statusTagUrl  状态标签url
		dataTable["VipGiftData"][i].statusTagUrl = nMBaseMessage:readString()
		--Common.log("VipGiftData---状态标签url = " .. dataTable["VipGiftData"][i].statusTagUrl)
		--…needVipMinLevel  购买所需的最小VIP等级
		dataTable["VipGiftData"][i].needVipMinLevel = tonumber(nMBaseMessage:readInt());
		--Common.log("VipGiftData---购买所需的最小VIP等级 = " .. dataTable["VipGiftData"][i].needVipMinLevel)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析用户礼包状态]]
function read80510008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_GET_GIFTBAG_MSG
	dataTable["messageName"] = "GIFTBAGID_GET_GIFTBAG_MSG"

	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = tonumber(nMBaseMessage:readInt());
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = tonumber(nMBaseMessage:readInt());
		--…IsPayGift  是否可以购买此类礼包
		dataTable["GiftBagData"][i].IsPayGift = tonumber(nMBaseMessage:readInt());
		nMBaseMessage:setReadPos(pos + length)
	end
	--RemainCount  当天剩余破产送金次数
	dataTable["RemainCount"] = nMBaseMessage:readByte()
	--Common.log("read80510008 RemainCount " .. dataTable["RemainCount"])
	return dataTable
end

--[[-- 解析用户删除背包礼包列表]]
function read8051000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_PUSH_DELBACKLIST
	dataTable["messageName"] = "GIFTBAGID_PUSH_DELBACKLIST"

	--GameID  游戏ID
	dataTable["GameID"] = nMBaseMessage:readByte()
	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = tonumber(nMBaseMessage:readInt());
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = tonumber(nMBaseMessage:readInt());
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析首充礼包图标是否显示]]
function read8051000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_SHOW_FIRSTPAY_ICON
	dataTable["messageName"] = "GIFTBAGID_SHOW_FIRSTPAY_ICON"

	--Visible	byte	是否可见	1是 0否
	dataTable["Visible"] = nMBaseMessage:readByte()
	return dataTable
end

--[[-- 解析背包物品列表]]
function read80060045(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_BACKPACK_LIST
	dataTable["messageName"] = "DBID_BACKPACK_LIST"

	--Num  背包中物品数量
	dataTable["BackPackData"] = {}
	local Num = tonumber(nMBaseMessage:readInt());
	for i = 1, Num do
		dataTable["BackPackData"][i] = {}
		--…ID  物品ID
		dataTable["BackPackData"][i].ID = tonumber(nMBaseMessage:readInt());
		--Common.log("ID = "..dataTable["BackPackData"][i].ID)

		--…itemNum  物品数量
		dataTable["BackPackData"][i].itemNum = tonumber(nMBaseMessage:readInt());
		--Common.log("itemNum = "..dataTable["BackPackData"][i].itemNum)

		--…backpackName  背包显示名称
		dataTable["BackPackData"][i].backpackName = nMBaseMessage:readString()
		--Common.log("backpackName = "..dataTable["BackPackData"][i].backpackName)

		--…Name  名称
		dataTable["BackPackData"][i].Name = nMBaseMessage:readString()
		--Common.log("read80060045 == Name=== " .. dataTable["BackPackData"][i].Name);
		--…goodsType  商品类型
		dataTable["BackPackData"][i].goodsType = nMBaseMessage:readByte()
		--…goodsProperty  属性 0时效行，1数量型
		dataTable["BackPackData"][i].goodsProperty = nMBaseMessage:readByte()
		--…IconURL  图标url
		dataTable["BackPackData"][i].IconURL = nMBaseMessage:readString()
		--…Title  标题
		dataTable["BackPackData"][i].Title = nMBaseMessage:readString()
		--…Description  描述
		dataTable["BackPackData"][i].Description = nMBaseMessage:readString()
		--Common.log("read80060045 == Description=== " .. dataTable["BackPackData"][i].Description);
		--…PurchaseLowerLimit  购买数量下限
		dataTable["BackPackData"][i].PurchaseLowerLimit = tonumber(nMBaseMessage:readInt());
		--…PurchaseUpperLimit  购买数量上限
		dataTable["BackPackData"][i].PurchaseUpperLimit = tonumber(nMBaseMessage:readInt());
		--…ConsumeType  消耗类型
		dataTable["BackPackData"][i].ConsumeType = nMBaseMessage:readByte()
		--…Consume  单价
		dataTable["BackPackData"][i].Consume = tonumber(nMBaseMessage:readInt());
		--…VipConsume  Vip单价
		dataTable["BackPackData"][i].VipConsume = tonumber(nMBaseMessage:readInt());
		--…statusTagUrl  状态标签url
		dataTable["BackPackData"][i].statusTagUrl = nMBaseMessage:readString()
		--…VipUpperLimit  Vip时效上限
		dataTable["BackPackData"][i].VipUpperLimit = tonumber(nMBaseMessage:readInt());
		--Common.log("VipUpperLimit = "..dataTable["BackPackData"][i].VipUpperLimit)

		--…backpackUpperLimit  背包存储上限
		dataTable["BackPackData"][i].backpackUpperLimit = tonumber(nMBaseMessage:readInt());
	end
	--VipNum  Vip数量
	dataTable["VipDiscountData"] = {}
	local VipNum = tonumber(nMBaseMessage:readInt());
	for i = 1, VipNum do
		dataTable["VipDiscountData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("VipDiscountData---length = " .. length)
		--…vipLevel  Vip等级
		dataTable["VipDiscountData"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		--Common.log("VipDiscountData---Vip等级 = " .. dataTable["VipDiscountData"][i].vipLevel)
		--…vipDiscount  Vip折扣
		dataTable["VipDiscountData"][i].vipDiscount = tonumber(nMBaseMessage:readInt());
		--Common.log("VipDiscountData---Vip折扣 = " .. dataTable["VipDiscountData"][i].vipDiscount)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 用户可购买礼包列表(精简)]]
function read80510010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_GIFTBAG_LIST_SIMPLE
	dataTable["messageName"] = "GIFTBAGID_GIFTBAG_LIST_SIMPLE"

	--GiftBagCnt  礼包数量
	dataTable["GiftBagData"] = {}
	local GiftBagCnt = tonumber(nMBaseMessage:readInt());
	--Common.log("read80510010  GiftBagCnt= " .. GiftBagCnt)
	for i = 1, GiftBagCnt do
		dataTable["GiftBagData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GiftBagType  礼包类别ID
		dataTable["GiftBagData"][i].GiftBagType = tonumber(nMBaseMessage:readInt());
		--Common.log("read80510010  GiftBagData---礼包类别ID = " .. dataTable["GiftBagData"][i].GiftBagType)
		nMBaseMessage:setReadPos(pos + length)
	end
	--礼包列表中第一个礼包的结束时间OverTime
	dataTable["OverTime"] = tonumber(nMBaseMessage:readLong())
	--Common.log("read80510010  OverTime = " .. dataTable["OverTime"])

	return dataTable
end

--[[-- 解析背包商品数量]]
function read80060049(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_BACKPACK_GOODS_COUNT
	dataTable["messageName"] = "DBID_BACKPACK_GOODS_COUNT"

	--Type  0时效型 1数量型
	dataTable["Type"] = nMBaseMessage:readByte()
	--Common.log("0时效型 1数量型 = " .. dataTable["Type"])
	--Num  时效型单位（秒）,数量型单位（个）
	dataTable["Num"] = tonumber(nMBaseMessage:readLong())
	--Common.log("时效型单位（秒）,数量型单位（个） = " .. dataTable["Num"])
	--ItemID  商品类型ID
	dataTable["ItemID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("商品类型ID = " .. dataTable["ItemID"])
	return dataTable
end

--[[-- 解析得到短信通道号码]]
function read80060031(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_GET_SMS_NUMBER
	dataTable["messageName"] = "DBID_GET_SMS_NUMBER"

	--NumberCnt  上行目标号码数量
	dataTable["NumberTable"] = {}
	local NumberCnt = nMBaseMessage:readByte()
	for i = 1, NumberCnt do
		dataTable["NumberTable"][i] = {}
		--…SmsNumber
		dataTable["NumberTable"][i].SmsNumber = nMBaseMessage:readString()
		--Common.log("NumberTable--- = " .. dataTable["NumberTable"][i].SmsNumber)
	end
	--MoblieNumber  绑定的手机号
	dataTable["MoblieNumber"] = nMBaseMessage:readString()
	--Common.log("绑定的手机号 = " .. dataTable["MoblieNumber"])
	return dataTable
end

--[[-- 解析兑换列表]]
function read80060046(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_EXCHANGE_LIST
	dataTable["messageName"] = "DBID_EXCHANGE_LIST"
	--Timestamp
	dataTable["Timestamp"] = tonumber(nMBaseMessage:readLong())
	--Common.log(" = " .. dataTable["Timestamp"])
	--Num
	dataTable["GoodsData"] = {}
	local Num = tonumber(nMBaseMessage:readInt());
	for i = 1, Num do
		dataTable["GoodsData"][i] = {}
		--…ID
		dataTable["GoodsData"][i].ID = tonumber(nMBaseMessage:readInt());
		--Common.log("GoodsData---ID= " .. dataTable["GoodsData"][i].ID)
		--…Name  名称
		dataTable["GoodsData"][i].Name = nMBaseMessage:readString()
		--Common.log("GoodsData---名称 = " .. dataTable["GoodsData"][i].Name)
		--…goodsType  商品类型
		dataTable["GoodsData"][i].goodsType = nMBaseMessage:readByte()
		--Common.log("GoodsData---商品类型 = " .. dataTable["GoodsData"][i].goodsType)
		--…IconURL  图标url
		dataTable["GoodsData"][i].IconURL = nMBaseMessage:readString()
		--Common.log("GoodsData---图标url = " .. dataTable["GoodsData"][i].IconURL)
		--…Title  标题
		dataTable["GoodsData"][i].Title = nMBaseMessage:readString()
		--Common.log("GoodsData---标题 = " .. dataTable["GoodsData"][i].Title)
		--…Description  描述
		dataTable["GoodsData"][i].Description = nMBaseMessage:readString()
		--Common.log("GoodsData---描述 = " .. dataTable["GoodsData"][i].Description)
		--…PurchaseLowerLimit  购买数量下限
		dataTable["GoodsData"][i].PurchaseLowerLimit = tonumber(nMBaseMessage:readInt());
		--Common.log("GoodsData---购买数量下限 = " .. dataTable["GoodsData"][i].PurchaseLowerLimit)
		--…PurchaseUpperLimit  购买数量上限
		dataTable["GoodsData"][i].PurchaseUpperLimit = tonumber(nMBaseMessage:readInt());
		--Common.log("GoodsData---购买数量上限 = " .. dataTable["GoodsData"][i].PurchaseUpperLimit)
		--…ConsumeType  消耗类型
		dataTable["GoodsData"][i].ConsumeType = nMBaseMessage:readByte()
		--Common.log("GoodsData---消耗类型 = " .. dataTable["GoodsData"][i].ConsumeType)
		--…Consume  单价
		dataTable["GoodsData"][i].Consume = tonumber(nMBaseMessage:readInt());
		--Common.log("GoodsData---单价 = " .. dataTable["GoodsData"][i].Consume)
		--…VipConsume  Vip单价
		dataTable["GoodsData"][i].VipConsume = tonumber(nMBaseMessage:readInt());
		--Common.log("GoodsData---Vip单价 = " .. dataTable["GoodsData"][i].VipConsume)
		--…operationTagUrl  运营标签url
		dataTable["GoodsData"][i].operationTagUrl = nMBaseMessage:readString()
		--Common.log("GoodsData---运营标签url = " .. dataTable["GoodsData"][i].operationTagUrl)
		--…exchangeCoin  兑换金币数
		dataTable["GoodsData"][i].exchangeCoin = tonumber(nMBaseMessage:readInt());
		--Common.log("GoodsData---兑换金币数 = " .. dataTable["GoodsData"][i].exchangeCoin)
	end
	return dataTable
end
--[[-- 解析服务器列表]]
function read80070093(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_SERVER_LIST
	dataTable["messageName"] = "MANAGERID_SERVER_LIST"

	--EnableServerCnt  可用的服务器数量
	dataTable["EnableServerTable"] = {}
	local EnableServerCnt = nMBaseMessage:readShort()
	for i = 1, EnableServerCnt do
		dataTable["EnableServerTable"][i] = {}
		--…EnableServerIP  可用的服务器地址
		dataTable["EnableServerTable"][i].EnableServerIP = nMBaseMessage:readString()
	end
	--EnableDomainCnt short 可用的域名
	dataTable["EnableDomainTable"] = {}
	local EnableDomainCnt = nMBaseMessage:readShort()
	for i = 1, EnableDomainCnt do
		dataTable["EnableDomainTable"][i] = {}
		--…EnableDomain	Text 可用的域名
		dataTable["EnableDomainTable"][i].EnableServerIP = nMBaseMessage:readString()
	end
	--DisableServerCnt  停用的服务器数量
	dataTable["DisableServerTable"] = {}
	local DisableServerCnt = nMBaseMessage:readShort()
	for i = 1, DisableServerCnt do
		dataTable["DisableServerTable"][i] = {}
		--…DisableServerIP  停用的服务器地址
		dataTable["DisableServerTable"][i].DisableServerIP = nMBaseMessage:readString()
	end
	return dataTable
end

--[[-- 解析购买商品]]
function read80060047(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_PAY_GOODS
	dataTable["messageName"] = "DBID_PAY_GOODS"

	--isVIp  1是0否
	dataTable["isVIp"] = nMBaseMessage:readByte()
	--Common.log("read80060047 1是0否 = " .. dataTable["isVIp"])
	--result  是否成功1是0否
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("read80060047 是否成功1是0否 = " .. dataTable["result"])
	--resultMsg
	dataTable["resultMsg"] = nMBaseMessage:readString()
	--Common.log("read80060047 是否成功1是0否 =消息 " .. dataTable["resultMsg"])
	--ItemID
	dataTable["ItemID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80060047 = ItemID " .. dataTable["ItemID"])
	return dataTable
end

--[[-- 解析获取服务器通用配置]]
function read8007009a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_SERVER_CONFIG_V2
	dataTable["messageName"] = "MANAGERID_GET_SERVER_CONFIG_V2"

	--VarCnt  变量数目
	dataTable["ConfigValueData"] = {}
	local VarCnt = tonumber(nMBaseMessage:readInt());
	Common.log("变量数目 = "..VarCnt)
	for i = 1, VarCnt do
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		dataTable["ConfigValueData"][i] = {}
		--…VarName	text	变量名
		dataTable["ConfigValueData"][i].VarName = nMBaseMessage:readString();
		Common.log("read8007009a VarName = "..dataTable["ConfigValueData"][i].VarName)
		--…VarValue  变量值
		dataTable["ConfigValueData"][i].VarValue = nMBaseMessage:readString();
		Common.log("read8007009a VarValue = "..dataTable["ConfigValueData"][i].VarValue)
		nMBaseMessage:setReadPos(pos + length);
	end
	return dataTable
end

--[[-- 解析获取修改昵称的次数]]
function read80060050(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_GET_NICKNAME_MODIFY_TIMES
	dataTable["messageName"] = "DBID_GET_NICKNAME_MODIFY_TIMES"

	--ModifyTimes  修改昵称的次数
	dataTable["ModifyTimes"] = tonumber(nMBaseMessage:readInt());
	--Common.log("修改昵称的次数 = " .. dataTable["ModifyTimes"])
	return dataTable
end

--[[-- 解析获取指定商品详情（可多个）]]
function read80060052(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_MALL_GOODS_DETAIL
	dataTable["messageName"] = "DBID_MALL_GOODS_DETAIL"

	--Num
	dataTable["GoodsData"] = {}
	local Num = tonumber(nMBaseMessage:readInt());
	for i = 1, Num do
		dataTable["GoodsData"][i] = {}
		--…ID
		dataTable["GoodsData"][i].ID = tonumber(nMBaseMessage:readInt());
		--…Name  名称
		dataTable["GoodsData"][i].Name = nMBaseMessage:readString()
		--…gameType  所属游戏
		dataTable["GoodsData"][i].gameType = nMBaseMessage:readByte()
		--…goodsType  商品类型
		dataTable["GoodsData"][i].goodsType = nMBaseMessage:readByte()
		--…IconURL  图标url
		dataTable["GoodsData"][i].IconURL = nMBaseMessage:readString()
		--…Title  标题
		dataTable["GoodsData"][i].Title = nMBaseMessage:readString()
		--…Description  描述
		dataTable["GoodsData"][i].Description = nMBaseMessage:readString()
		--…PurchaseLowerLimit  购买数量下限
		dataTable["GoodsData"][i].PurchaseLowerLimit = tonumber(nMBaseMessage:readInt());
		--…PurchaseUpperLimit  购买数量上限
		dataTable["GoodsData"][i].PurchaseUpperLimit = tonumber(nMBaseMessage:readInt());
		--…ConsumeType  消耗类型
		dataTable["GoodsData"][i].ConsumeType = nMBaseMessage:readByte()
		--…Consume  单价
		dataTable["GoodsData"][i].Consume = tonumber(nMBaseMessage:readInt());
		--…VipConsume  Vip单价
		dataTable["GoodsData"][i].VipConsume = tonumber(nMBaseMessage:readInt());
		--…operationTagUrl  运营标签url
		dataTable["GoodsData"][i].operationTagUrl = nMBaseMessage:readString()
	end
	return dataTable
end


--[[--充值结果通知]]
function read8006005b(nMBaseMessage)

	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_RECHARGE_RESULT_NOTIFICATION
	dataTable["messageName"] = "DBID_RECHARGE_RESULT_NOTIFICATION"
	--充值结果类型0：失败 1：购买金币成功2：购买元宝成功3：购买礼包成功
	dataTable["result"] = nMBaseMessage:readByte()
	--本次充值元宝数量
	dataTable["yuanbaoCount"] = tonumber(nMBaseMessage:readInt());
	--充值结果提示语
	dataTable["resultMsg"] = nMBaseMessage:readString()
	--是否短代充值  0：非短代 1：短代
	dataTable["isSmsRecharge"] = nMBaseMessage:readByte()
	--当前VIP等级
	dataTable["newVipLevel"] = tonumber(nMBaseMessage:readInt());
	--充值引导ID
	dataTable["rechargeID"] = tonumber(nMBaseMessage:readInt());
	--Giftype	Int	礼包类型
	dataTable["Giftype"] = tonumber(nMBaseMessage:readInt());
	--price	int	人民币价格（分）	单位：分
	dataTable["price"] = tonumber(nMBaseMessage:readInt());
	--IsGift	byte	是否为礼包	0不是，1是礼包
	dataTable["IsGift"] = nMBaseMessage:readByte()
	--IsExchange	byte	是否兑换金币
	dataTable["IsExchange"] = nMBaseMessage:readByte()

	return dataTable
end

--[[-- 解析通过昵称发送消息]]
function read80060017(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_SEND_MSG_NICKNAME
	dataTable["messageName"] = "DBID_V2_SEND_MSG_NICKNAME"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("ResultTxt============"..dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析找回密码]]
function read8006000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_FIND_PASSWORD
	dataTable["messageName"] = "DBID_FIND_PASSWORD"

	--Result  是否成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultTxt  结果提示语
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--NewPassword  新密码
	dataTable["NewPassword"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析进入聊天室]]
function read80050001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_ENTER_CHAT_ROOM
	dataTable["messageName"] = "IMID_ENTER_CHAT_ROOM"

	--ResultID   结果。 0成功 1失败
	dataTable["ResultID"] = nMBaseMessage:readByte()
	--ResultText  结果文本内容
	dataTable["ResultText"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析聊天室发言]]
function read80050003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_CHAT_ROOM_SPEAK
	dataTable["messageName"] = "IMID_CHAT_ROOM_SPEAK"
	--SpeakerUserID  发言者用户ID
	dataTable["SpeakerUserID"] = tonumber(nMBaseMessage:readInt());
	--SpeakerNickName  发言者昵称
	dataTable["SpeakerNickName"] = nMBaseMessage:readString()
	--SpeechText  发言内容
	dataTable["SpeechText"] = nMBaseMessage:readString()
	Common.log("read80050003 SpeechText == "..dataTable["SpeechText"])
	--Color  ARGB方式存储。可用4个getByte()分别读取
	dataTable["ARGB0"] = nMBaseMessage:readByte()
	dataTable["ARGB1"] = nMBaseMessage:readByte()
	dataTable["ARGB2"] = nMBaseMessage:readByte()
	dataTable["ARGB3"] = nMBaseMessage:readByte()
	--TextSize  字体大小
	dataTable["TextSize"] = tonumber(nMBaseMessage:readInt());
	--vip等级
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80050003 VipLevel is " .. dataTable["VipLevel"])
	--ActionInT
	dataTable["ActionId"] = tonumber(nMBaseMessage:readInt());
	--ActionString
	dataTable["ActionParam"] = tonumber(nMBaseMessage:readInt());
	return dataTable
end

--[[-- 解析显示聊天室当前最新消息]]
function read80050005(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_GET_LAST_CHAT_ROOM_SPEAK
	dataTable["messageName"] = "IMID_GET_LAST_CHAT_ROOM_SPEAK"

	--SpeechText  当前最新的发言内容
	dataTable["SpeechText"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 屏蔽举报某玩家聊天]]
function read80050007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_OPERATE_CHAT_USER_TYPE
	dataTable["messageName"] = "IMID_OPERATE_CHAT_USER_TYPE"

	--result	byte	操作结果	0：成功  1：失败
	dataTable["byte"] = nMBaseMessage:readByte()
	--resultMsg	text	结果提示语
	dataTable["resultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--获取初始化图片
--]]
function read8007001c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_INIT_PIC
	dataTable["messageName"] = "MANAGERID_GET_INIT_PIC"

	--TimeStamp	Long	时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	--picList	Int	图片列表	Loop
	dataTable["picList"] = {}
	local picList = tonumber(nMBaseMessage:readInt());
	--Common.log("read8007001c picList " .. picList)
	for i = 1, picList do
		dataTable["picList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--…picUrl	Text	图片url
		dataTable["picList"][i].picUrl = nMBaseMessage:readString()
		--Common.log("picUrl ====== "..dataTable["picList"][i].picUrl)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析绑定用户手机号]]
function read8007001d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_BINDING_USER_PHONE_NUMBER
	dataTable["messageName"] = "MANAGERID_BINDING_USER_PHONE_NUMBER"

	--Result
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultMsg  提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析兑奖]]
function read80070019(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_EXCHANGE_AWARD
	dataTable["messageName"] = "MANAGERID_EXCHANGE_AWARD"

	--Result  0-成功 1-失败
	dataTable["Result"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80070019 == "..dataTable["Result"])
	--Message  Toast的信息
	dataTable["Message"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析获得用户充值记录]]
function read80070023(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GET_RECHARGE_RECORD
	dataTable["messageName"] = "GET_RECHARGE_RECORD"

	--RechargeRecords  充值记录
	dataTable["RechargeRecordData"] = {}
	local RechargeRecords = tonumber(nMBaseMessage:readInt());
	for i = 1, RechargeRecords do
		dataTable["RechargeRecordData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…rechargeValue  充值金额
		dataTable["RechargeRecordData"][i].rechargeValue = tonumber(nMBaseMessage:readInt());
		--…rechargeChannel  充值渠道
		dataTable["RechargeRecordData"][i].rechargeChannel = nMBaseMessage:readString()
		--…rechargeTime  充值时间
		dataTable["RechargeRecordData"][i].rechargeTime = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析获取绑定手机号随机码]]
function read80070029(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_BINDING_PHONE_RANDOM
	dataTable["messageName"] = "MANAGERID_GET_BINDING_PHONE_RANDOM"

	--ResultMsg  随机码
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("随机码 = " .. dataTable["ResultMsg"])
	return dataTable
end

--[[-- 解析获取所有奖品]]
function read80070018(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_PRESENTS
	dataTable["messageName"] = "MANAGERID_GET_PRESENTS"

	--TimeStamp  时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	--Count  数量
	dataTable["PrizeData"] = {}
	local Count = tonumber(nMBaseMessage:readInt());
	for i = 1, Count do
		dataTable["PrizeData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…GoodID  物品id
		dataTable["PrizeData"][i].GoodID = tonumber(nMBaseMessage:readInt());
		--…ShortName  短名称
		dataTable["PrizeData"][i].ShortName = nMBaseMessage:readString()
		--…Name  名称
		dataTable["PrizeData"][i].Name = nMBaseMessage:readString()
		--…Prize  需要兑奖券价格
		dataTable["PrizeData"][i].Prize = tonumber(nMBaseMessage:readInt());
		--…Picture  列表界面大图
		dataTable["PrizeData"][i].Picture = nMBaseMessage:readString()
		--…Description  明细界面的说明
		dataTable["PrizeData"][i].Description = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析获取游戏基地支付说明数据]]
function read8007002b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MOBILE_PAY_DATA
	dataTable["messageName"] = "MANAGERID_MOBILE_PAY_DATA"

	--GoalPhone  目标手机号
	dataTable["GoalPhone"] = nMBaseMessage:readString()
	--Common.log("目标手机号 = " .. dataTable["GoalPhone"])
	--FeeType  默认填写12
	dataTable["FeeType"] = nMBaseMessage:readString()
	--Common.log("默认填写12 = " .. dataTable["FeeType"])
	--CPID  合作方业务代码
	dataTable["CPID"] = nMBaseMessage:readString()
	--Common.log("合作方业务代码 = " .. dataTable["CPID"])
	--CPServiceID  网游业务代码
	dataTable["CPServiceID"] = nMBaseMessage:readString()
	--Common.log("网游业务代码 = " .. dataTable["CPServiceID"])
	--FID  默认填写1000
	dataTable["FID"] = nMBaseMessage:readString()
	--Common.log("默认填写1000 = " .. dataTable["FID"])
	--PackageID  默认填写000000000000
	dataTable["PackageID"] = nMBaseMessage:readString()
	--Common.log("默认填写000000000000 = " .. dataTable["PackageID"])
	--CPSign  默认填写000000
	dataTable["CPSign"] = nMBaseMessage:readString()
	--Common.log("默认填写000000 = " .. dataTable["CPSign"])
	--GameName  游戏名称
	dataTable["GameName"] = nMBaseMessage:readString()
	--Common.log("游戏名称 = " .. dataTable["GameName"])
	--payData  商品说明数据
	dataTable["payData"] = {}
	local payData = tonumber(nMBaseMessage:readInt());
	for i = 1, payData do
		dataTable["payData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…payCode  计费代码
		dataTable["payData"][i].payCode = nMBaseMessage:readString()
		--…name  商品名称
		dataTable["payData"][i].name = nMBaseMessage:readString()
		--…describe  商品描述
		dataTable["payData"][i].describe = nMBaseMessage:readString()
		--…price  资费说明
		dataTable["payData"][i].price = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析获取自己兑换的奖品列表]]
function read8007001a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_EXCHANGE_AWARDS
	dataTable["messageName"] = "MANAGERID_GET_EXCHANGE_AWARDS"

	--Count  奖品数量
	dataTable["AwardData"] = {}
	local Count = tonumber(nMBaseMessage:readInt());
	for i = 1, Count do
		dataTable["AwardData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…AwardID  奖品ID
		dataTable["AwardData"][i].AwardID = tonumber(nMBaseMessage:readInt());
		--…Name  名称
		dataTable["AwardData"][i].Name = nMBaseMessage:readString()
		--…Status  状态
		dataTable["AwardData"][i].Status = nMBaseMessage:readByte()
		--Common.log("xwh excharge Status is " .. dataTable["AwardData"][i].Status)
		--…Date  购买日期
		dataTable["AwardData"][i].Date = tonumber(nMBaseMessage:readLong())
		--…PictureUrl  图片路径
		dataTable["AwardData"][i].PictureUrl = nMBaseMessage:readString()
		--…Description  商品介绍
		dataTable["AwardData"][i].Description = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析支付数据列表]]
function read80070015(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + PAYMENT_DATA_LIST
	dataTable["messageName"] = "PAYMENT_DATA_LIST"
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	--PayQuickNum  快捷支付数量
	dataTable["PayQuickData"] = {}
	local PayQuickNum = tonumber(nMBaseMessage:readInt());
	for i = 1, PayQuickNum do
		dataTable["PayQuickData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…PayTypeID  支付渠道ID
		dataTable["PayQuickData"][i].PayTypeID = nMBaseMessage:readByte()
		--…QuickName  快捷支付标题
		dataTable["PayQuickData"][i].QuickName = nMBaseMessage:readString()
		--…QuickDescription  快捷支付描述
		dataTable["PayQuickData"][i].QuickDescription = nMBaseMessage:readString()
		--…QuickPrice  快捷支付价格(RMB)
		dataTable["PayQuickData"][i].QuickPrice = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--PayChannelDataNum  所有支付渠道数据的数量
	dataTable["PayChannelData"] = {}
	local PayChannelDataNum = tonumber(nMBaseMessage:readInt());
	--Common.log("支付数据列表 --- =PayChannelDataNum " .. PayChannelDataNum)
	for i = 1, PayChannelDataNum do
		dataTable["PayChannelData"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("支付数据列表   PayChannelData---length = " .. length)
		--…PayTypeID  支付渠道ID
		dataTable["PayChannelData"][i].PayTypeID = nMBaseMessage:readByte()
		--…GoodsID  商品编号
		dataTable["PayChannelData"][i].GoodsID = nMBaseMessage:readByte()
		--        --Common.log("PayChannelData---商品编号 = " .. dataTable["PayChannelData"][i].GoodsID)
		--…GoodsName  商品名称
		dataTable["PayChannelData"][i].GoodsName = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---商品名称 = " .. dataTable["PayChannelData"][i].GoodsName)
		--…GoodsDescription  商品描述
		dataTable["PayChannelData"][i].GoodsDescription = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---商品描述 = " .. dataTable["PayChannelData"][i].GoodsDescription)
		--…GoodsPrice  商品价格
		dataTable["PayChannelData"][i].GoodsPrice = nMBaseMessage:readString()
		--		  --Common.log("PayChannelData---商品价格 = " .. dataTable["PayChannelData"][i].GoodsPrice)
		--…GoodsNum  一次购买商品数量
		dataTable["PayChannelData"][i].GoodsNum = nMBaseMessage:readByte()
		--   --Common.log("PayChannelData---一次购买商品数量 = " .. dataTable["PayChannelData"][i].GoodsNum)
		--…MMPayCode  短信支付代码
		dataTable["PayChannelData"][i].MMPayCode = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---短信支付代码 = " .. dataTable["PayChannelData"][i].MMPayCode)
		--…Messageformat  发送短信格式
		dataTable["PayChannelData"][i].Messageformat = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---发送短信格式 = " .. dataTable["PayChannelData"][i].Messageformat)
		--…Discount  优惠百分比(%)
		dataTable["PayChannelData"][i].Discount = tonumber(nMBaseMessage:readInt());
		--  --Common.log("PayChannelData---优惠百分比(%) = " .. dataTable["PayChannelData"][i].Discount)
		--…Status  是否可用
		dataTable["PayChannelData"][i].Status = nMBaseMessage:readByte()
		--  --Common.log("PayChannelData---是否可用 = " .. dataTable["PayChannelData"][i].Status)
		--…Subtype  支付子类型
		dataTable["PayChannelData"][i].Subtype = nMBaseMessage:readByte()
		--  --Common.log("PayChannelData---支付子类型 = " .. dataTable["PayChannelData"][i].Subtype)
		--…coinUrl  购买物品图标
		dataTable["PayChannelData"][i].coinUrl = nMBaseMessage:readString()
		--  --Common.log("PayChannelData---购买物品图标 = " .. dataTable["PayChannelData"][i].coinUrl)
		--…tagUrl  物品标签
		dataTable["PayChannelData"][i].tagUrl = nMBaseMessage:readString()
		-- --Common.log("PayChannelData---物品标签 = " .. dataTable["PayChannelData"][i].tagUrl)
		--…addYuanbao  额外赠送的元宝数
		dataTable["PayChannelData"][i].addYuanbao = tonumber(nMBaseMessage:readInt());
		--  --Common.log("PayChannelData---额外赠送的元宝数 = " .. dataTable["PayChannelData"][i].addYuanbao)
		--…NewName  商品名称
		dataTable["PayChannelData"][i].NewName = nMBaseMessage:readString()
		--  --Common.log("PayChannelData---商品名称 = " .. dataTable["PayChannelData"][i].NewName)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--解析移动支付方式
--]]
function read8007005e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MOBILE_PAYMENT_MODE
	dataTable["messageName"] = "MANAGERID_MOBILE_PAYMENT_MODE"
	--PaymentMode int 移动支付方式 0：不显示移动支付1：显示MM支付2：显示短代支付3：带验证码的短代（已废弃）
	dataTable["PaymentMode"] = tonumber(nMBaseMessage:readInt());
	--Common.log("移动支付方式PaymentMode ====== " .. dataTable["PaymentMode"]);
	return dataTable
end

--[[--
--解析联通支付方式
--]]
function read80070071(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_CU_PAYMENT_MODE
	dataTable["messageName"] = "MANAGERID_CU_PAYMENT_MODE"
	--PaymentMode int 联通支付方式 0：不显示联通支付1：显示联通短代支付2：显示沃商店支付
	dataTable["PaymentMode"] = tonumber(nMBaseMessage:readInt());
	--Common.log("联通支付方式PaymentMode ====== " .. dataTable["PaymentMode"]);
	return dataTable
end

--[[--
--解析电信支付方式
--]]
function read8007005f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_CT_PAYMENT_MODE
	dataTable["messageName"] = "MANAGERID_CT_PAYMENT_MODE"
	--PaymentMode int 电信支付方式 0：不显示电信支付1：显示华建支付2：显示天翼空间支付
	dataTable["PaymentMode"] = tonumber(nMBaseMessage:readInt());
	--Common.log("电信支付方式PaymentMode ====== " .. dataTable["PaymentMode"]);
	return dataTable
end

--[[--
--解析支付
--]]
function read80070079(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_V3_RECHARGE
	dataTable["messageName"] = "MANAGERID_V3_RECHARGE"
	--Common.log("解析支付***************");
	-- result byte 兑换结果 0失败 1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--Common.log("result = "..dataTable["result"])

	-- msg text 信息
	dataTable["payMsg"] = nMBaseMessage:readString()
	--Common.log("msg ===================== " .. dataTable["payMsg"])

	--OrderId text 订单号/银联签名
	dataTable["OrderId"] = nMBaseMessage:readString()
	--Common.log("OrderId ===================== " .. dataTable["OrderId"])
	-- 支付渠道
	dataTable["payChannel"] = nMBaseMessage:readByte()
	--Common.log("payChannel ===================== " .. dataTable["payChannel"])
	--KvLoop loop KeyValue循环 用于微信支付或其他扩展信息
	dataTable["KvLoop"] = {}
	local KvLoopNum = tonumber(nMBaseMessage:readInt());
	--Common.log("支付数据列表 --- KvLoopNum " .. KvLoopNum)
	for i = 1, KvLoopNum do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …Key Text
		local key = nMBaseMessage:readString();
		-- …Value Text
		dataTable["KvLoop"][key] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["smsList"] = {}
	--SmsData loop 多条短信指令和目标号码循环
	local smsCount = tonumber(nMBaseMessage:readInt());
	--Common.log("支付数据列表 --- smsCount " .. smsCount)
	for i = 1, smsCount do
		dataTable["smsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…TelephoneNumber text 目标号码
		dataTable["smsList"][i].number = nMBaseMessage:readString()
		--Common.log("解析number: " .. dataTable["smsList"][i].number)
		--…SmsMsg text 短信内容
		dataTable["smsList"][i].smsContent = nMBaseMessage:readString()
		--Common.log("解析smsContent: " .. dataTable["smsList"][i].smsContent)
		--…IsDataSms byte 是否二进制短信	0文本短信 1二进制短信
		dataTable["smsList"][i].IsDataSms = nMBaseMessage:readByte()
		--…DestinationPort	short	二进制短信目标端口
		dataTable["smsList"][i].DestinationPort = nMBaseMessage:readShort()

		nMBaseMessage:setReadPos(pos + length)
	end
	--SmsHint text 短信发出后的弹框提示
	dataTable["SmsHint"] = nMBaseMessage:readString()
	--SerialNumber long 流水号
	dataTable["SerialNumber"] = tonumber(nMBaseMessage:readLong())
	--Position Int	位置编码	默认为0
	dataTable["Position"] = tonumber(nMBaseMessage:readInt());
	--Common.log("Position ===================== " .. dataTable["Position"])

	return dataTable
end

--[[--
--服务器推送发短信任务
--]]
function read80070083(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_SEND_SMS_TASK
	dataTable["messageName"] = "MANAGERID_SEND_SMS_TASK"
	-- Telephone	Text	电话号码
	dataTable["Telephone"] = nMBaseMessage:readString()
	-- SMS	text	短信
	dataTable["SMS"] = nMBaseMessage:readString()
	--Common.log("read80070083====="..dataTable.Telephone.."=="..dataTable.SMS)
	--IsDataSms	byte	是否二进制短信	0文本短信 1二进制短信
	dataTable["IsDataSms"] = nMBaseMessage:readByte()
	--DestinationPort	short	二进制短信目标端口
	dataTable["DestinationPort"] = nMBaseMessage:readShort()

	return dataTable
end

--[[-- 解析得到当前手机绑定的用户列表]]
function read80010008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_GET_IMEIUSERS
	dataTable["messageName"] = "BASEID_GET_IMEIUSERS"

	--Result  查询结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("查询结果 = " .. dataTable["Result"])
	--ResultTxt  提示语内容
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("提示语内容 = " .. dataTable["ResultTxt"])
	--TotalBindCnt  当前手机总共绑定次数
	dataTable["TotalBindCnt"] = nMBaseMessage:readByte()
	--Common.log("当前手机总共绑定次数 = " .. dataTable["TotalBindCnt"])
	--NickCnt  昵称数量
	dataTable["NickTable"] = {}
	local NickCnt = nMBaseMessage:readByte()
	for i = 1, NickCnt do
		dataTable["NickTable"][i] = {}
		--…NickName  昵称
		dataTable["NickTable"][i].NickName = nMBaseMessage:readString()
		--Common.log("NickTable---昵称 = " .. dataTable["NickTable"][i].NickName)
	end
	--BindingMobile  绑定的手机号
	dataTable["BindingMobile"] = nMBaseMessage:readString()
	--Common.log("绑定的手机号 = " .. dataTable["BindingMobile"])
	--头像
	local NickCnt2 = nMBaseMessage:readByte()
	for i = 1, NickCnt2 do
		--…NickName  昵称
		local useravator  = nMBaseMessage:readString()
		dataTable["NickTable"][i].UserAvator = useravator
		--Common.log("绑定的手机号 头像= " .. dataTable["NickTable"][i].UserAvator)
	end
	return dataTable
end

--[[-- 解析门票]]
function read8007003a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + TICKET_GET_TICKET_LIST
	dataTable["messageName"] = "TICKET_GET_TICKET_LIST"
	--TicketLoop	Loop	门票循环
	local TicketLoopCnt = tonumber(nMBaseMessage:readInt());
	--Common.log("收到门票消息",TicketLoopCnt)
	dataTable["TicketLoop"] = {}
	for i = 1,TicketLoopCnt do
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable["TicketLoop"][i] = {}
		--…TicketId	Int	门票id
		dataTable["TicketLoop"][i].TicketId = tonumber(nMBaseMessage:readInt());
		--Common.log("门票ID",dataTable["TicketLoop"][i].TicketId)
		--…TicketName	Text	门票名称
		dataTable["TicketLoop"][i].TicketName = nMBaseMessage:readString()
		--Common.log("门票名字",dataTable["TicketLoop"][i].TicketName)
		--…TicketGameNamePic	Text	游戏名称角标url
		dataTable["TicketLoop"][i].TicketGameNamePic = nMBaseMessage:readString()
		--…TicketIcon	Text	门票图标url
		dataTable["TicketLoop"][i].TicketIcon = nMBaseMessage:readString()
		--…TicketStatus	Byte	门票状态	1已使用0未使用
		dataTable["TicketLoop"][i].TicketStatus = nMBaseMessage:readByte()
		--…TicketRemainMillions	Long	门票过期时间（秒）
		dataTable["TicketLoop"][i].TicketRemainMillions = tonumber(nMBaseMessage:readLong())
		--…GameID	byte	游戏ID
		dataTable["TicketLoop"][i].GameID = nMBaseMessage:readByte()
		--…MatchID	int	比赛ID
		dataTable["TicketLoop"][i].MatchID = tonumber(nMBaseMessage:readInt());
		--…MatchDetailUrl	text	比赛详情WebView的URL
		dataTable["TicketLoop"][i].MatchDetailUrl = nMBaseMessage:readString()
		--…PackageName	Text	游戏安卓包名
		dataTable["TicketLoop"][i].PackageName = nMBaseMessage:readString()
		--…MinVersion	Int	游戏最低版本
		dataTable["TicketLoop"][i].MinVersion = tonumber(nMBaseMessage:readInt());
		--…TicketExpirationTime	Text	门票过期时间
		dataTable["TicketLoop"][i].TicketExpirationTime = nMBaseMessage:readString()
		--…MatchStartTime	Text	比赛开始时间
		dataTable["TicketLoop"][i].MatchStartTime = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析回话列表]]
function read80060011(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_GET_CONVERSATION_LIST
	dataTable["messageName"] = "DBID_V2_GET_CONVERSATION_LIST"

	--ConversationCnt  会话数量
	dataTable["MessageData"] = {}
	local ConversationCnt = nMBaseMessage:readByte()
	--Common.log("消息数量 = " .. ConversationCnt)
	for i = 1, ConversationCnt do
		dataTable["MessageData"][i] = {}
		--…ConversationID
		dataTable["MessageData"][i].ConversationID = tonumber(nMBaseMessage:readInt());
		--Common.log("--- = " .. dataTable["MessageData"][i].ConversationID)
		--…UserID  用户ID
		dataTable["MessageData"][i].UserID = tonumber(nMBaseMessage:readInt());
		--Common.log("---用户ID = " .. dataTable["MessageData"][i].UserID)
		--…IsSysMsg  是否为系统消息
		dataTable["MessageData"][i].IsSysMsg = nMBaseMessage:readByte()
		--Common.log("---是否为系统消息 = " .. dataTable["MessageData"][i].IsSysMsg)
		--...SenderNickName  发信人昵称
		dataTable["MessageData"][i].SenderNickName = nMBaseMessage:readString()
		--Common.log("发信人昵称 = " .. dataTable["MessageData"][i].SenderNickName)
		--…PhotoUrl  头像url
		dataTable["MessageData"][i].PhotoUrl = nMBaseMessage:readString()
		--Common.log("---头像url = " .. dataTable["MessageData"][i].PhotoUrl)
		--...LastMsgContent  最后一条信息的内容
		dataTable["MessageData"][i].LastMsgContent = nMBaseMessage:readString()
		--Common.log("最后一条信息的内容 = " .. dataTable["MessageData"][i].LastMsgContent)
		--...LastMsgTime  最新消息的时间
		dataTable["MessageData"][i].LastMsgTime = nMBaseMessage:readString()
		--Common.log("最新消息的时间 = " .. dataTable["MessageData"][i].LastMsgTime)
		--…TotalMsgCnt  总消息数量
		dataTable["MessageData"][i].TotalMsgCnt = nMBaseMessage:readShort()
		--Common.log("---总消息数量 = " .. dataTable["MessageData"][i].TotalMsgCnt)
		--…UnreadMessageCnt  未读信息数量
		dataTable["MessageData"][i].UnreadMessageCnt = nMBaseMessage:readShort()
		--Common.log("---未读信息数量 = " .. dataTable["MessageData"][i].UnreadMessageCnt)
	end
	return dataTable
end

--[[-- 解析会话详情]]
function read80060012(nMBaseMessage)
	--Common.log("read80060012 = client ")
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_GET_CONVERSATION
	dataTable["messageName"] = "DBID_V2_GET_CONVERSATION"

	--ConversationID  会话ID
	dataTable["ConversationID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("会话ID = " .. dataTable["ConversationID"])
	--UserInfo  用户信息
	dataTable["UserInfo"] = nMBaseMessage:readString()
	--Common.log("用户信息 = " .. dataTable["UserInfo"])
	--MessageCnt  消息数量
	dataTable["MessageTable"] = {}
	local MessageCnt = nMBaseMessage:readByte()
	for i = 1, MessageCnt do
		dataTable["MessageTable"][i] = {}
		--…MessageID
		dataTable["MessageTable"][i].MessageID = tonumber(nMBaseMessage:readInt());
		--Common.log("MessageTable--- = " .. dataTable["MessageTable"][i].MessageID)
		--...Content  内容
		dataTable["MessageTable"][i].Content = nMBaseMessage:readString()
		--Common.log("内容 = " .. dataTable["MessageTable"][i].Content)
		--...CreateTime  消息时间
		dataTable["MessageTable"][i].CreateTime = nMBaseMessage:readString()
		--Common.log("消息时间 = " .. dataTable["MessageTable"][i].CreateTime)
		--…Sender  发消息的人
		dataTable["MessageTable"][i].Sender = nMBaseMessage:readByte()
		--Common.log("MessageTable---发消息的人 = " .. dataTable["MessageTable"][i].Sender)
	end
	dataTable["IsShield"] = nMBaseMessage:readByte()
	--Common.log("aab................IsShield=" .. dataTable["IsShield"])
	dataTable["IsJHHVip"] = nMBaseMessage:readByte()
	--Common.log("aab................IsJHHVip=" .. dataTable["IsJHHVip"])
	return dataTable
end

--[[-- 解析删除会话]]
function read80060014(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_DELETE_CONVERSATION
	dataTable["messageName"] = "DBID_V2_DELETE_CONVERSATION"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("结果 = " .. dataTable["Result"])
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("失败原因 = " .. dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析清空会话]]
function read80060013(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_EMPTY_CONVERSITION
	dataTable["messageName"] = "DBID_V2_EMPTY_CONVERSITION"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("结果 = " .. dataTable["Result"])
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("失败原因 = " .. dataTable["ResultTxt"])
	return dataTable
end

--[[-- 解析发送会话]]
function read80060015(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_SEND_MESSAGE
	dataTable["messageName"] = "DBID_V2_SEND_MESSAGE"

	--Result  结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("解析发送会话结果 = " .. dataTable["Result"])
	--ResultTxt  失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	--Common.log("解析发送会话失败原因 = " .. dataTable["ResultTxt"])
	return dataTable
end

-- 3.6.22 消息推送(DBID_V2_REICIVE_MESSAGE)
function read80060016(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_REICIVE_MESSAGE
	dataTable["messageName"] = "DBID_V2_REICIVE_MESSAGE"

	Common.log("消息推送 read80060016 read80060016 = DBID_V2_REICIVE_MESSAGE")

	-- SenderUserID	Int	发送者用户ID
	dataTable["SenderUserID"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80060016 SenderUserID = "..dataTable["SenderUserID"])
	-- Sender	byte	发送者 	0是自己1是对方
	dataTable["Sender"] = nMBaseMessage:readByte()
	Common.log("read80060016 Sender = "..dataTable["Sender"])
	-- PhotoUrl	Text	发送者头像url
	dataTable["PhotoUrl"] = nMBaseMessage:readString()
	Common.log("read80060016 PhotoUrl = "..dataTable["PhotoUrl"])
	-- UserInfo	Text	用户信息
	dataTable["UserInfo"] = nMBaseMessage:readString()
	Common.log("read80060016 UserInfo = "..dataTable["UserInfo"])
	-- SenderNickname	Text	发送者昵称
	dataTable["SenderNickname"] = nMBaseMessage:readString()
	Common.log("read80060016 SenderNickname = "..dataTable["SenderNickname"])
	-- CreateTime	Text	消息时间
	dataTable["CreateTime"] = nMBaseMessage:readString()
	Common.log("read80060016 CreateTime = "..dataTable["CreateTime"])
	-- MessageContent	Text	消息内容
	dataTable["MessageContent"] = nMBaseMessage:readString()
	Common.log("read80060016 MessageContent = "..dataTable["MessageContent"])
	-- ConversationID	Int	会话ID
	dataTable["ConversationID"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80060016 ConversationID = "..dataTable["ConversationID"])
	-- MessageID	Int	消息ID
	dataTable["MessageID"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80060016 MessageID = "..dataTable["MessageID"])
	-- IsSystemMSg	Byte	是否是系统消息	1是0否
	dataTable["IsSystemMSg"] = nMBaseMessage:readByte()
	Common.log("read80060016 IsSystemMSg = "..dataTable["IsSystemMSg"])

	return dataTable
end

--[[-- 解析兑奖列表]]
function read8007004f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PRIZE_PIECES_LIST
	dataTable["messageName"] = "MANAGERID_PRIZE_PIECES_LIST"

	--PiecesNum  碎片数量
	dataTable["AwardTable"] = {}
	local PiecesNum = tonumber(nMBaseMessage:readInt());
	--Common.log("AwardTable---PiecesNum = " .. PiecesNum)
	for i = 1, PiecesNum do
		dataTable["AwardTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…PiecesID  碎片ID
		dataTable["AwardTable"][i].PiecesID = tonumber(nMBaseMessage:readInt());
		--…Name  名称
		dataTable["AwardTable"][i].Name = nMBaseMessage:readString()
		--…IconURL  图标url
		dataTable["AwardTable"][i].IconURL = nMBaseMessage:readString()
		--…NeedNum  所需的碎片
		dataTable["AwardTable"][i].NeedNum = tonumber(nMBaseMessage:readInt());
		--…ExistingNum  已有的碎片
		dataTable["AwardTable"][i].ExistingNum = tonumber(nMBaseMessage:readInt());
		nMBaseMessage:setReadPos(pos + length)
	end
	--ExchangeNum  兑换券数量
	dataTable["AwardIDTable"] = {}
	local ExchangeNum = tonumber(nMBaseMessage:readInt());
	for i = 1, ExchangeNum do
		dataTable["AwardIDTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…ExchangeID  兑换券ID
		dataTable["AwardIDTable"][i].ExchangeID = tonumber(nMBaseMessage:readInt());
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end
--[[-- 解析兑奖操作]]
function read80070050(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PIECES_COMPOUND_DETAILS
	dataTable["messageName"] = "MANAGERID_PIECES_COMPOUND_DETAILS"

	--PiecesID  碎片ID
	dataTable["PiecesID"] = tonumber(nMBaseMessage:readInt());
	--Name  名称
	dataTable["Name"] = nMBaseMessage:readString()
	--IconURL  图标url
	dataTable["IconURL"] = nMBaseMessage:readString()
	--NeedNum  所需的碎片
	dataTable["NeedNum"] = tonumber(nMBaseMessage:readInt());
	--ExistingNum  已有的碎片
	dataTable["ExistingNum"] = tonumber(nMBaseMessage:readInt());
	--PiecesDetails  碎片详情
	dataTable["PiecesDetails"] = nMBaseMessage:readString()
	--CompoundRate  默认合成成功率
	dataTable["CompoundRate"] = tonumber(nMBaseMessage:readInt());
	--AddSuccessRate  增加合成成功率阶梯
	dataTable["AwardTable"] = {}
	local AddSuccessRate = tonumber(nMBaseMessage:readInt());
	for i = 1, AddSuccessRate do
		dataTable["AwardTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("AwardTable---length = " .. length)
		--…AddRate  增加的成功率
		dataTable["AwardTable"][i].AddRate = tonumber(nMBaseMessage:readInt());
		--Common.log("AwardTable---增加的成功率 = ".. dataTable["AwardTable"][i].AddRate)
		--…NeedYuanBao  需要的元宝数
		dataTable["AwardTable"][i].NeedYuanBao = tonumber(nMBaseMessage:readInt());
		--Common.log("AwardTable---需要的元宝数 = ".. dataTable["AwardTable"][i].NeedYuanBao)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析兑奖操作]]
function read80070059(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_PIECES_SHOP_LIST
	dataTable["messageName"] = "MANAGERID_GET_PIECES_SHOP_LIST"

	--ChipNum  拥有的兑奖券碎片数量
	dataTable["ChipNum"] = tonumber(nMBaseMessage:readInt());
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	--Count  数量
	dataTable["AwardTable"] = {}
	local Count = tonumber(nMBaseMessage:readInt());
	--Common.log("AwardTablesuipian---Count = " .. Count)
	for i = 1, Count do
		dataTable["AwardTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--…GoodID  物品id
		dataTable["AwardTable"][i].GoodID = tonumber(nMBaseMessage:readInt());
		--…ShortName  短名称
		dataTable["AwardTable"][i].ShortName = nMBaseMessage:readString()
		--…Name  名称
		dataTable["AwardTable"][i].Name = nMBaseMessage:readString()
		--…Prize  兑换需要的碎片数量
		dataTable["AwardTable"][i].Prize = tonumber(nMBaseMessage:readInt());
		--…Picture  列表界面大图
		dataTable["AwardTable"][i].Picture = nMBaseMessage:readString()
		--…Description  明细界面的说明
		dataTable["AwardTable"][i].Description = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析兑奖券碎片兑奖]]
function read8007005a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PIECES_EXCHANGE
	dataTable["messageName"] = "MANAGERID_PIECES_EXCHANGE"

	--GoodID  物品id
	dataTable["GoodID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("物品id = " .. dataTable["GoodID"])
	--Result  合成是否成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("合成是否成功 = " .. dataTable["Result"])
	--ResultMsg  提示信息
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("提示信息 = " .. dataTable["ResultMsg"])
	return dataTable
end

--[[-- 解析新充值卡备选奖品列表]]
function read80070035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + NEW_GET_ALTERNATIVE_PRIZE_LIST
	dataTable["messageName"] = "NEW_GET_ALTERNATIVE_PRIZE_LIST"

	--PrizeID  奖品ID
	dataTable["PrizeID"] = tonumber(nMBaseMessage:readInt());
	--Count  备选奖品数量
	dataTable["AwardChange"] = {}
	local Count = tonumber(nMBaseMessage:readInt());
	for i = 1, Count do
		dataTable["AwardChange"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…itemType  备选奖品类型
		dataTable["AwardChange"][i].itemType = nMBaseMessage:readByte()
		--…itemName  备选奖品名称
		dataTable["AwardChange"][i].itemName = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析新充值卡备选奖品列表2]]
function read80070036(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + NEW_GET_ALTERNATIVE_PRIZE
	dataTable["messageName"] = "NEW_GET_ALTERNATIVE_PRIZE"

	--Result  1 成功 0 失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--exchargeFlag  领奖类型
	dataTable["exchargeFlag"] = nMBaseMessage:readByte()
	--PrizeTip  提示信息
	dataTable["PrizeTip"] = nMBaseMessage:readString()
	--CardNO  卡号
	dataTable["CardNO"] = nMBaseMessage:readString()
	--Password  密码
	dataTable["Password"] = nMBaseMessage:readString()
	--PrizeID  奖品ID
	dataTable["PrizeID"] = tonumber(nMBaseMessage:readInt());
	--PrizeName  奖品名称
	dataTable["PrizeName"] = nMBaseMessage:readString()
	return dataTable
end

--[[-- 解析新获取自己赢得的奖品列表]]
function read80070034(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + NEW_GET_PRIZE_LIST
	dataTable["messageName"] = "NEW_GET_PRIZE_LIST"

	--PrizeCnt  奖品数量
	dataTable["MyPrize"] = {}
	local PrizeCnt = tonumber(nMBaseMessage:readInt());
	--Common.log(PrizeCnt.."macmyid")
	for i = 1, PrizeCnt do
		dataTable["MyPrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--...PrizeID  奖品ID
		dataTable["MyPrize"][i].PrizeID = tonumber(nMBaseMessage:readInt());
		--Common.log(dataTable["MyPrize"][i].PrizeID.."macmyid")
		--...PrizeName  实物奖名称
		dataTable["MyPrize"][i].PrizeName = nMBaseMessage:readString()
		--...PrizeStatus  奖品状态
		dataTable["MyPrize"][i].PrizeStatus = nMBaseMessage:readByte()
		--Common.log("xwh excharge Status is " .. dataTable["MyPrize"][i].PrizeStatus)
		--...AwardTime  获奖日期
		dataTable["MyPrize"][i].AwardTime = tonumber(nMBaseMessage:readLong())
		--...PictureUrl  图片路径
		dataTable["MyPrize"][i].PictureUrl = nMBaseMessage:readString()
		--...ValidDate  有效期
		dataTable["MyPrize"][i].ValidDate = tonumber(nMBaseMessage:readLong())
		--...Category  奖品类型
		dataTable["MyPrize"][i].Category = nMBaseMessage:readByte()
		--Common.log("xwh excharge Category is " .. dataTable["MyPrize"][i].Category)
		--…prizeMatch  获奖比赛
		dataTable["MyPrize"][i].prizeMatch = nMBaseMessage:readString()
		--…isExpired  是否过期
		dataTable["MyPrize"][i].isExpired = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析碎片合成操作]]
function read80070056(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_COMPOUND_V2
	dataTable["messageName"] = "MANAGERID_COMPOUND_V2"

	--PiecesID  碎片ID
	dataTable["PiecesID"] = tonumber(nMBaseMessage:readInt());
	--Common.log("碎片ID = " .. dataTable["PiecesID"])
	--Result  合成是否成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("合成是否成功 = " .. dataTable["Result"])
	--ResultMsg  提示信息
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	--Common.log("提示信息 = " .. dataTable["ResultMsg"])
	return dataTable
end

--[[-- 解析碎片合成列表]]
function read80070055(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PIECES_COMPOUND_DETAILS_V2
	dataTable["messageName"] = "MANAGERID_PIECES_COMPOUND_DETAILS_V2"

	--PiecesID  碎片ID
	dataTable["PiecesID"] = tonumber(nMBaseMessage:readInt());
	--Name  名称
	dataTable["Name"] = nMBaseMessage:readString()
	--Common.log("read80070055 Name==" .. dataTable["Name"]);
	--IconURL  图标url
	dataTable["IconURL"] = nMBaseMessage:readString()
	--ExistingNum  已有的碎片
	dataTable["ExistingNum"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80070055 ExistingNum==" .. dataTable["ExistingNum"]);
	--NeedNum  合成一张兑奖券需要的碎片数
	dataTable["NeedNum"] = tonumber(nMBaseMessage:readInt());
	--NeedYuanBao  合成一张兑奖券需要的元宝数
	dataTable["NeedYuanBao"] = tonumber(nMBaseMessage:readInt());
	--PiecesIntro  碎片简介
	dataTable["PiecesIntro"] = nMBaseMessage:readString()
	--PiecesDetails  碎片详情
	dataTable["PiecesDetails"] = nMBaseMessage:readString()
	--CompoundSympolDetails  合成符详情
	dataTable["CompoundSympolDetails"] = nMBaseMessage:readString()
	return dataTable
end

--3.7.100 小游戏列表状态消息(MANAGERID_MINIGAME_LIST_TYPE)
function read80070064(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MINIGAME_LIST_TYPE
	dataTable["messageName"] = "MANAGERID_MINIGAME_LIST_TYPE"
	--typeList	Loop		Loop
	dataTable["typeList"] = {}
	local typeListCnt = tonumber(nMBaseMessage:readInt());
	--Common.log("typeListCnt === "..typeListCnt)
	for i = 1, typeListCnt do
		dataTable["typeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……MiniGameID			转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["typeList"][i].MiniGameID = tonumber(nMBaseMessage:readInt());
		--Common.log("MiniGameID === "..dataTable["typeList"][i].MiniGameID)
		--…MiniGameState	byte	小游戏显示状态	不显示：0 显示不带锁：1 显示带锁：2
		dataTable["typeList"][i].MiniGameState = nMBaseMessage:readByte()
		--Common.log("MiniGameID MiniGameState === "..dataTable["typeList"][i].MiniGameState)
		--Common.log("小游戏状态 === ",dataTable["typeList"][i].MiniGameID,dataTable["typeList"][i].MiniGameState)
		--…StateMsgTxt	text	用户点击后的toast	带锁时有意义
		dataTable["typeList"][i].StateMsgTxt =nMBaseMessage:readString()
		--…MiniGameIconUrl	text
		dataTable["typeList"][i].MiniGameIconUrl = nMBaseMessage:readString()
		--		--Common.log("sdf.....MiniGameID = " .. dataTable["typeList"][i].MiniGameID .."                      MiniGameIconUrl" .. dataTable["typeList"][i].MiniGameIconUrl)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


--[[-- 解析ituns商城验证]]
function read8007001f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VALIDATE_IAP
	dataTable["messageName"] = "MANAGERID_VALIDATE_IAP"

	--Result  验证结果
	dataTable["Result"] = nMBaseMessage:readString()
	--Common.log("验证结果 = " .. dataTable["Result"])
	--Msg  原因
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("原因 = " .. dataTable["Msg"])
	return dataTable
end

--[[-- 解析ituns商城验证]]
function read80070074(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VALIDATE_IAP_V2
	dataTable["messageName"] = "MANAGERID_VALIDATE_IAP_V2"

	--Result  验证结果
	dataTable["Result"] = nMBaseMessage:readString()
	--Common.log("验证结果 = " .. dataTable["Result"])
	--Msg  原因
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("原因 = " .. dataTable["Msg"])
	--orderID	Text	订单号	支付的订单号（透传）
	dataTable["orderID"] = nMBaseMessage:readString()
	--Common.log("订单号 = " .. dataTable["orderID"])
	return dataTable
end

--[[-- lua脚本版本检测]]
function read8007008a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_LUA_SCRIPT_VERSION_V2
	dataTable["messageName"] = "MANAGERID_LUA_SCRIPT_VERSION_V2"
	--ScriptVerCode	Text 脚本版本号
	dataTable["ScriptVerCode"] = nMBaseMessage:readString()
	--updateType	byte	升级方案	0、不升级--1、提示升级--2、强制升级--3、有新版本，不提升(wifi下后台升级)--4、后台升级(wifi、2G下均后台升级)
	dataTable["updateType"] = nMBaseMessage:readByte()
	--updataTxt	Text	升级提示	HTML
	dataTable["updataTxt"] = nMBaseMessage:readString()
	--Common.log("lua脚本版本检测 read " .. dataTable["updataTxt"] .. ";" .. dataTable["updateType"])
	--ScriptUpdateUrl	Text	脚本升级Url地址
	dataTable["ScriptUpdateUrl"] = nMBaseMessage:readString()
	--fileDelListTxtUrl	Text	删除文件列表
	dataTable["fileDelListTxtUrl"] = nMBaseMessage:readString()

	return dataTable
end

--[[-- lua脚本版本MD5校验]]
function read80070062(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_LUA_SCRIPT_MD5
	dataTable["messageName"] = "MANAGERID_LUA_SCRIPT_MD5"

	--isFailure	byte	脚本是否有损坏	0没有损坏1有损坏--如果没有损坏，后面的字段可以不发
	dataTable["isFailure"] = nMBaseMessage:readByte()
	--ScriptVerCode	Text 脚本版本号
	dataTable["ScriptVerCode"] = nMBaseMessage:readString()
	--updataTxt	Text	修复脚本提示	HTML
	dataTable["updataTxt"] = nMBaseMessage:readString()
	--ScriptUpdateUrl	Text	脚本修复Url地址
	dataTable["ScriptUpdateUrl"] = nMBaseMessage:readString()

	return dataTable
end

--[[--
--解析OPERID_GET_OPER_TASK_LIST_V2
--]]
function read80610036(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_OPER_TASK_LIST_V2
	dataTable["messageName"] = "OPERID_GET_OPER_TASK_LIST_V2"

	local arrayTable0 = {}
	dataTable["operTaskList"] = {}
	local Cnt = tonumber(nMBaseMessage:readInt());
	--Common.log("huodong...cnt = " .. Cnt)
	--	dataTable["typeList"] = {};
	for i = 1, Cnt do
		--		dataTable["typeList"][i] = {};
		arrayTable0[i] = {}
		local beanTable1 = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--TaskID
		beanTable1.taskId= tonumber(nMBaseMessage:readInt());
		--Common.log("huodong...TaskId = " .. beanTable1.taskId)
		--活动图片URL
		beanTable1.taskPhotoUrl = nMBaseMessage:readString();
		--Common.log("huodong...TaskPhotoUrl = " .. beanTable1.taskPhotoUrl)
		--活动名称
		beanTable1.taskTitle = nMBaseMessage:readString();
		--Common.log("huodong...TaskTitle = " .. beanTable1.taskTitle)
		--活动时间提示
		beanTable1.taskTimePrompt = nMBaseMessage:readString();
		--Common.log("huodong...TaskTimePrompt = " .. beanTable1.taskTimePrompt)
		--是否需要更新
		beanTable1.isUpdate = nMBaseMessage:readByte();
		--Common.log("huodong...isUpdate = " .. beanTable1.isUpdate)
		--脚本升级Url地址
		beanTable1.ScriptUpdateUrl = nMBaseMessage:readString()
		--Common.log("huodong...ScriptUpdateUrl = " .. beanTable1.ScriptUpdateUrl)
		--删除文件列表
		beanTable1.fileDelListTxtUrl = nMBaseMessage:readString();
		--Common.log("huodong...fileDelListTxtUrl = " .. beanTable1.fileDelListTxtUrl)
		nMBaseMessage:setReadPos(pos + length);
		arrayTable0[i] = beanTable1
	end
	dataTable["operTaskList"] = arrayTable0
	return dataTable
end

--[[-- 解析合成信息]]
function read80070051(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_COMPOUND_INFO
	dataTable["messageName"] = "MANAGERID_COMPOUND_INFO"

	--CompoundNum  合成信息数量
	dataTable["ComTable"] = {}
	local CompoundNum = tonumber(nMBaseMessage:readInt());
	--Common.log("ComTable---合成信息 = ".. CompoundNum)
	for i = 1, CompoundNum do
		dataTable["ComTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("ComTable---length = " .. length)
		--…ItemID  信息的ID
		dataTable["ComTable"][i].ItemID = tonumber(nMBaseMessage:readInt());
		--Common.log("ComTable---信息的ID = ".. dataTable["ComTable"][i].ItemID)
		--…CompoundText  合成信息
		dataTable["ComTable"][i].CompoundText = nMBaseMessage:readString()
		--Common.log("ComTable---合成信息 = ".. dataTable["ComTable"][i].CompoundText)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


--根据URL获取web页面源码
function read80650014(nMBaseMessage)
	--Common.log("read80650014-------------------------")
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_HTTPPROXY
	dataTable["messageType"] = "COMMONS_HTTPPROXY"
	--是否进行过公共模块新手引导，1是，0否
	dataTable["HashCode"] = tonumber(nMBaseMessage:readInt());
	dataTable["Html"] = nMBaseMessage:readString()
	dataTable["Key"] = nMBaseMessage:readString()
	Common.log("read80650014 Html == " .. dataTable.Html)
	return dataTable
end

--获取未使用门票数量
function read8007003f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_UNUSED_TICKET_CNT
	dataTable["messageName"] = "MANAGERID_GET_UNUSED_TICKET_CNT"
	dataTable["number"] = nMBaseMessage:readShort()
	return dataTable
end

--[[----------获取活动走马灯信息----------]]
function read8061000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_ACTIVITY_MARQUEE
	dataTable["messageName"] = "OPERID_ACTIVITY_MARQUEE"
	--firstStrNum是游戏产生的走马灯消息数
	dataTable["firstStrNum"] = nMBaseMessage:readByte()
	--Common.log("read8061000b firstStrNum == " .. dataTable["firstStrNum"])
	--firstStrTable是游戏产生的走马灯消息Table
	dataTable["firstStrTable"] = {}
	for i=1, dataTable["firstStrNum"] do
		dataTable["firstStrTable"][i] = nMBaseMessage:readUTF()
		--Common.log("read8061000b firstStrTable == " .. dataTable["firstStrTable"][i])
	end
	--secStrNum是游戏策划想让玩家看到的走马灯消息数
	dataTable["secStrNum"] = nMBaseMessage:readByte()
	--Common.log("read8061000b secStrNum == " .. dataTable["secStrNum"])
	--secStrTable是游戏策划想让玩家看到的走马灯消息Table
	dataTable["secStrTable"] = {}
	for i=1, dataTable["secStrNum"] do
		dataTable["secStrTable"][i] = nMBaseMessage:readUTF()
		--Common.log("read8061000b secStrTable == " .. dataTable["secStrTable"][i])
	end
	return dataTable
end

--[[-------------请求现金奖品列表 (OPERID_GET_CASH_AWARD_LIST)------------]]
function read80610012(nMBaseMessage)
	--Common.log("read80610012 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_CASH_AWARD_LIST
	dataTable["messageName"] = "OPERID_GET_CASH_AWARD_LIST"
	local AwardsListCnt = tonumber(nMBaseMessage:readInt());
	dataTable["AwardsList"] = {}
	for i = 1, AwardsListCnt do
		dataTable["AwardsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …awardID int 物品id
		dataTable["AwardsList"][i].GoodID = tonumber(nMBaseMessage:readInt()) + 10000;
		--Common.log("read80610012 Loop " .. i .. " awardID == " .. dataTable["AwardsList"][i].GoodID)
		-- …shortName String 短名称
		dataTable["AwardsList"][i].ShortName = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " shortName == " .. dataTable["AwardsList"][i].ShortName)
		-- …name String 名称
		dataTable["AwardsList"][i].Name = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " name == " .. dataTable["AwardsList"][i].Name)
		-- …prize int 需要兑奖券价格
		dataTable["AwardsList"][i].Prize = tonumber(nMBaseMessage:readInt());
		--Common.log("read80610012 Loop " .. i .. " prize == " .. dataTable["AwardsList"][i].Prize)
		-- …picture String 列表界面大图
		dataTable["AwardsList"][i].Picture = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " picture == " .. dataTable["AwardsList"][i].Picture)
		-- …description String 明细界面的说明
		dataTable["AwardsList"][i].Description = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " description == " .. dataTable["AwardsList"][i].Description)
		-- …AwardStatus Int 是否可兑奖
		dataTable["AwardsList"][i].AwardStatus = tonumber(nMBaseMessage:readInt());
		--Common.log("read80610012 Loop " .. i .. " AwardStatus == " .. dataTable["AwardsList"][i].AwardStatus)
		-- …AwardMsg String 可合成兑奖提示信息
		dataTable["AwardsList"][i].AwardMsg = nMBaseMessage:readString();
		--Common.log("read80610012 Loop " .. i .. " AwardMsg == " .. dataTable["AwardsList"][i].AwardMsg)
		-- …AwardNeedYuanBao	Int	充值引导所需要的元宝数	只有需要充值引导才可合成兑奖才返回,否则返回0
		dataTable["AwardsList"][i].AwardNeedYuanBao = tonumber(nMBaseMessage:readInt());
		--Common.log("read80610012 Loop " .. i .. " AwardNeedYuanBao == " .. dataTable["AwardsList"][i].AwardNeedYuanBao)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------请求同步现金限量奖品数量 (OPERID_GET_CASH_AWARD_REMAINDER)------------]]
function read80610013(nMBaseMessage)
	--Common.log("read80610013 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_CASH_AWARD_REMAINDER
	dataTable["messageName"] = "OPERID_GET_CASH_AWARD_REMAINDER"
	local RemainderListCnt = tonumber(nMBaseMessage:readInt());
	dataTable["RemainderList"] = {}
	for i = 1, RemainderListCnt do
		dataTable["RemainderList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …awardID int 物品id
		dataTable["RemainderList"][i].awardID = tonumber(nMBaseMessage:readInt()) + 10000;
		--Common.log("read80610013 Loop " .. i .. " awardID == " .. dataTable["RemainderList"][i].awardID)
		-- …remainder int 剩余数目
		dataTable["RemainderList"][i].remainder = tonumber(nMBaseMessage:readInt());
		--Common.log("read80610013 Loop " .. i .. " remainder == " .. dataTable["RemainderList"][i].remainder)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------请求兑换限量奖品 (OPERID_EXCHANGE_LIMITED_AWARD)------------]]
function read80610014(nMBaseMessage)
	--Common.log("read80610014 Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_EXCHANGE_LIMITED_AWARD
	dataTable["messageName"] = "OPERID_EXCHANGE_LIMITED_AWARD"
	--Result	Int	0-成功 1-失败
	dataTable["result"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80610014 result " .. dataTable["result"])
	--Message	Text	Toast的信息
	dataTable["message"] = nMBaseMessage:readString()
	--Common.log("read80610014 message " .. dataTable["message"])
	--PicUrl	Text	奖品图片url	兑换成功后返回
	dataTable["picUrl"] = nMBaseMessage:readString()
	--Common.log("read80610014 picUrl " .. dataTable["picUrl"])
	return dataTable
end

--[[-------------请求我的奖品中现金奖品列表 (OPERID_GET_CASH_PRIZE_LIST)------------]]
function read8061001d(nMBaseMessage)
	--Common.log("read8061001d Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_CASH_PRIZE_LIST
	dataTable["messageName"] = "OPERID_GET_CASH_PRIZE_LIST"
	local CashPrizeListCnt = tonumber(nMBaseMessage:readInt());
	--Common.log("read8061001d CashPrizeListCnt is " .. CashPrizeListCnt)
	dataTable["CashPrizeList"] = {}
	for i = 1, CashPrizeListCnt do
		dataTable["CashPrizeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …PrizeID int 奖品id
		dataTable["CashPrizeList"][i].id = tonumber(nMBaseMessage:readInt()) + 10000;
		--Common.log("read8061001d Loop " .. i .. " PrizeID == " .. dataTable["CashPrizeList"][i].id)
		-- …PrizeName String 短名称
		dataTable["CashPrizeList"][i].name = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " PrizeName == " .. dataTable["CashPrizeList"][i].name)
		-- …PictureUrl String 图片地址
		dataTable["CashPrizeList"][i].url = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " url == " .. dataTable["CashPrizeList"][i].url)
		-- …ExchangbleAmount int 兑换所需奖品个数
		dataTable["CashPrizeList"][i].ExchangbleAmount = tonumber(nMBaseMessage:readInt());
		--Common.log("read8061001d Loop " .. i .. " ExchangbleAmount == " .. dataTable["CashPrizeList"][i].ExchangbleAmount)
		-- …TotalityAmount int 拥有的奖品个数综合
		dataTable["CashPrizeList"][i].TotalityAmount = tonumber(nMBaseMessage:readInt());
		--Common.log("read8061001d Loop " .. i .. " TotalityAmount == " .. dataTable["CashPrizeList"][i].TotalityAmount)
		dataTable["CashPrizeList"][i].HistoryAmount = tonumber(nMBaseMessage:readInt());
		--Common.log("read8061001d Loop " .. i .. " HistoryAmount == " .. dataTable["CashPrizeList"][i].HistoryAmount)
		dataTable["CashPrizeList"][i].Description = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " Description == " .. dataTable["CashPrizeList"][i].Description)
		dataTable["CashPrizeList"][i].type = 3;
		dataTable["CashPrizeList"][i].status = 0;
		dataTable["CashPrizeList"][i].date = 0;
		dataTable["CashPrizeList"][i].Category = 0;
		dataTable["CashPrizeList"][i].isExpired = 0;
		nMBaseMessage:setReadPos(pos + length)
	end

	local CashPrizeExchangedListCnt = tonumber(nMBaseMessage:readInt());
	dataTable["CashPrizeExchangedList"] = {}
	--Common.log("read8061001d CashPrizeExchangedListCnt is " .. CashPrizeExchangedListCnt)
	for i = 1, CashPrizeExchangedListCnt do
		dataTable["CashPrizeExchangedList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …PrizeID int 奖品id
		dataTable["CashPrizeExchangedList"][i].id = tonumber(nMBaseMessage:readInt()) + 10000;
		--Common.log("read8061001d Loop " .. i .. " PrizeID == " .. dataTable["CashPrizeExchangedList"][i].id)
		-- …PrizeName String 短名称
		dataTable["CashPrizeExchangedList"][i].name = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " PrizeName == " .. dataTable["CashPrizeExchangedList"][i].name)
		-- …PrizeStatus Byte 奖品状态
		dataTable["CashPrizeExchangedList"][i].status = nMBaseMessage:readByte();
		--Common.log("read8061001d Loop " .. i .. " status == " .. dataTable["CashPrizeExchangedList"][i].status)
		-- …PrizeTime Long 获奖时间
		dataTable["CashPrizeExchangedList"][i].date = tonumber(nMBaseMessage:readLong());
		--Common.log("read8061001d Loop " .. i .. " date == " .. dataTable["CashPrizeExchangedList"][i].date)
		-- …PictureUrl String 图片地址
		dataTable["CashPrizeExchangedList"][i].url = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " url == " .. dataTable["CashPrizeExchangedList"][i].url)
		dataTable["CashPrizeExchangedList"][i].Description = nMBaseMessage:readString();
		--Common.log("read8061001d Loop " .. i .. " Description == " .. dataTable["CashPrizeExchangedList"][i].Description)
		dataTable["CashPrizeExchangedList"][i].type = 3;
		dataTable["CashPrizeExchangedList"][i].Category = 0;
		dataTable["CashPrizeExchangedList"][i].isExpired = 0;
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-------------请求现金奖品兑现成话费 (OPERID_PRIZE_EXCHANGE_MOBILE_FARE)------------]]
function read8061001e(nMBaseMessage)
	--Common.log("read8061001e Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_PRIZE_EXCHANGE_MOBILE_FARE
	dataTable["messageName"] = "OPERID_PRIZE_EXCHANGE_MOBILE_FARE"
	dataTable["result"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read8061001e result " .. dataTable["result"])
	dataTable["message"] = nMBaseMessage:readString()
	--Common.log("read8061001e message " .. dataTable["message"])
	return dataTable
end

--[[-------------31请求现金奖品兑现成金币 (OPERID_PRIZE_EXCHANGE_GAME_COIN)------------]]
function read8061001f(nMBaseMessage)
	--Common.log("read8061001f Comming")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_PRIZE_EXCHANGE_GAME_COIN
	dataTable["messageName"] = "OPERID_PRIZE_EXCHANGE_GAME_COIN"
	dataTable["result"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read8061001f result " .. dataTable["result"])
	dataTable["message"] = nMBaseMessage:readString()
	--Common.log("read8061001f message " .. dataTable["message"])
	return dataTable
end

--解析站内信消息列表
function read80670001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAIL_SYSTEM_MESSGE_LIST
	dataTable["messageName"] = "MAIL_SYSTEM_MESSGE_LIST"
	dataTable["MessageListTable"] = {}
	--消息列表数量
	local messageList_Count = tonumber(nMBaseMessage:readInt());
	dataTable["messageList_Count"] = messageList_Count
	for i = 1 , messageList_Count do
		dataTable["MessageListTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--消息id
		dataTable["MessageListTable"][i].MessageId = tonumber(nMBaseMessage:readInt());
		--消息标题
		dataTable["MessageListTable"][i].MessageTitle = nMBaseMessage:readString()
		--消息内容  Html
		dataTable["MessageListTable"][i].MessageContent = nMBaseMessage:readString()
		--消息类型  0 普通消息  1 领奖消息  2 执行Action
		dataTable["MessageListTable"][i].MessageType = nMBaseMessage:readByte()
		--消息状态 0 未读 ，1 已读 ， 2 已领奖
		dataTable["MessageListTable"][i].MessageFlag = nMBaseMessage:readByte()
		--Action类型
		dataTable["MessageListTable"][i].Action = tonumber(nMBaseMessage:readInt());
		--Action参数
		dataTable["MessageListTable"][i].ActionParam = nMBaseMessage:readString()
		--CreateTime时间
		dataTable["MessageListTable"][i].CreateTime = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable;
end

-- 解析站内信消息领奖列表
function read80670008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4
	dataTable["messageName"] = "MAIL_SYSTEM_MESSAGE_RECEIVE_AWARD_V4"
	--消息id
	dataTable["MessageId"] = tonumber(nMBaseMessage:readInt());
	--领奖是否成功
	dataTable["Success"] = nMBaseMessage:readByte()
	--领奖消息内容
	dataTable["Message"] = nMBaseMessage:readString()
	dataTable["MessageReceiveListTable"] = {}
	--领奖消息列表数量
	local awardList_count = tonumber(nMBaseMessage:readInt());
	for i = 1 , awardList_count do
		dataTable["MessageReceiveListTable"][i] = {}
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--图片地址
		dataTable["MessageReceiveListTable"][i].PicUrl = nMBaseMessage:readString()
		--图片描述
		dataTable["MessageReceiveListTable"][i].PciDescription = nMBaseMessage:readString()
		--奖品数量
		dataTable["MessageReceiveListTable"][i].Count = tonumber(nMBaseMessage:readLong());
		nMBaseMessage:setReadPos(length + pos)
	end
	return dataTable;
end

--[[--站内信消息阅读]]
--站内信消息阅读
function read80670003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAIL_SYSTEM_MESSAGE_READ
	dataTable["messageName"] = "MAIL_SYSTEM_MESSAGE_READ"
	--消息id
	dataTable["MessageId"] = tonumber(nMBaseMessage:readInt());
	--领奖是否成功
	dataTable["Success"] = nMBaseMessage:readByte()
	return dataTable;
end

--[[--
--接收屏蔽某玩家站内信
--]]
function read8006005a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_SHIELD_MAIL_USERID
	dataTable["messageName"] = "DBID_SHIELD_MAIL_USERID"
	--	操作结果
	dataTable["result"] = nMBaseMessage:readByte()
	--	结果提示语
	dataTable["resultMsg"] = nMBaseMessage:readString()
	return dataTable
end

--[[--
--获取站内信
--]]
function  read80670006(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MAIL_UNREAD_SEND;
	dataTable["messageName"] = "MAIL_UNREAD_SEND";
	--消息体长度
	dataTable[1] =  nMBaseMessage:readByte();
	return dataTable
end

--[[--
--小游戏列表状态消息(支持单个功能的脚本更新)
--]]
function read80070081(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_MINIGAME_LIST_TYPE_V2
	dataTable["messageName"] = "MANAGERID_MINIGAME_LIST_TYPE_V2"
	--typeList	Loop		Loop
	dataTable["typeList"] = {}
	local typeListCnt = tonumber(nMBaseMessage:readInt());
	--Common.log("read80070081 == typeListCnt === "..typeListCnt)
	for i = 1, typeListCnt do
		dataTable["typeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……MiniGameID			转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["typeList"][i].MiniGameID = tonumber(nMBaseMessage:readInt());
		--Common.log("read80070081 ==MiniGameID === "..dataTable["typeList"][i].MiniGameID)
		--…MiniGameState	byte	小游戏显示状态	不显示：0 显示不带锁：1 显示带锁：2

		dataTable["typeList"][i].MiniGameState = nMBaseMessage:readByte()
		--Common.log("read80070081 == MiniGameState === "..dataTable["typeList"][i].MiniGameState)

		--…StateMsgTxt	text	用户点击后的toast	带锁时有意义
		dataTable["typeList"][i].StateMsgTxt =nMBaseMessage:readString()
		--Common.log("read80610081 == StateMsgTxt === "..dataTable["typeList"][i].StateMsgTxt)
		--…icon
		dataTable["typeList"][i].MiniGameIconUrl = nMBaseMessage:readString()
		--Common.log("read80610081 == MiniGameIconUrl === "..dataTable["typeList"][i].MiniGameIconUrl)
		--是否需要更新  0不更新 1更新
		dataTable["typeList"][i].isUpdate = nMBaseMessage:readByte()
		--Common.log("read80610081 == isUpdate === "..dataTable["typeList"][i].isUpdate)
		--脚本升级Url地址
		dataTable["typeList"][i].ScriptUpdateUrl = nMBaseMessage:readString()
		--Common.log("read80610081 == ScriptUpdateUrl === "..dataTable["typeList"][i].ScriptUpdateUrl)
		--删除文件列表
		dataTable["typeList"][i].fileDelListTxtUrl = nMBaseMessage:readString()
		--Common.log("read80610081 == fileDelListTxtUrl === "..dataTable["typeList"][i].fileDelListTxtUrl)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end


--[[--
--3.16.34 更新IMEI（COMMONS_UPDATE_IMEI）
--]]
function read80650022(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + COMMONS_UPDATE_IMEI
	dataTable["messageName"] = "COMMONS_UPDATE_IMEI"
	--IsSuccess	Byte	是否成功	0：失败 1:成功
	dataTable["IsSuccess"] = nMBaseMessage:readByte();

	return dataTable
end

--[[--
--3.16.30 成就任务列表（COMMONS_LIFETIME_TASKLIST）
--]]--
function read8065001e(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_LIFETIME_TASKLIST;
	dataTable["messageName"] = "COMMONS_LIFETIME_TASKLIST";
	--任务列表
	dataTable["taskNum"] = tonumber(nMBaseMessage:readInt());
	dataTable["TaskListLoop"] = {}
	for i = 1,dataTable["taskNum"] do
		dataTable["TaskListLoop"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--任务ID
		dataTable["TaskListLoop"][i]["ID"] = tonumber(nMBaseMessage:readInt());
		--Common.log("read8065001e ID = " .. dataTable["TaskListLoop"][i]["ID"])
		--任务名称
		dataTable["TaskListLoop"][i]["Name"] = nMBaseMessage:readString();
		--Common.log("read8065001e Name = " .. dataTable["TaskListLoop"][i]["Name"])
		--任务描述
		dataTable["TaskListLoop"][i]["Desc"] = nMBaseMessage:readString();
		--Common.log("read8065001e Desc = " .. dataTable["TaskListLoop"][i]["Desc"])
		--任务进度
		dataTable["TaskListLoop"][i]["Process"] = nMBaseMessage:readString();
		--Common.log("read8065001e Process = " .. dataTable["TaskListLoop"][i]["Process"])
		--奖励名称
		dataTable["TaskListLoop"][i]["PrizeName"] = nMBaseMessage:readString();
		--Common.log("read8065001e PrizeName = " .. dataTable["TaskListLoop"][i]["PrizeName"])
		--ActionID
		dataTable["TaskListLoop"][i]["ActionId"] = tonumber(nMBaseMessage:readInt());
		--Common.log("read8065001e ActionId = " .. dataTable["TaskListLoop"][i]["ActionId"])
		--按钮状态
		dataTable["TaskListLoop"][i]["Status"] = nMBaseMessage:readByte();
		--Common.log("read8065001e Status = " .. dataTable["TaskListLoop"][i]["Status"])
		--Progress 进度
		dataTable["TaskListLoop"][i]["Progress"] = nMBaseMessage:readByte();
		--Common.log("read8065001e Progress = " .. dataTable["TaskListLoop"][i]["Progress"])
		nMBaseMessage:setReadPos(length + pos);
	end
	return dataTable;
end

--[[--
--3.16.31 领取成就任务奖励（COMMONS_GET_LIFETIME_TASKPRIZE）
--]]--
function read8065001f(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_GET_LIFETIME_TASKPRIZE;
	dataTable["messageName"] = "COMMONS_GET_LIFETIME_TASKPRIZE";
	--是否成功
	dataTable["IsSuccess"] = nMBaseMessage:readByte();
	--提示语
	dataTable["Msg"] = nMBaseMessage:readString();
	--奖品列表
	dataTable["Loop"] = tonumber(nMBaseMessage:readInt());
	dataTable["PrizesLoop"] = {}
	for i = 1,dataTable["Loop"] do
		dataTable["PrizesLoop"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--奖品图片
		dataTable["PrizesLoop"][i]["PicUrl"] = nMBaseMessage:readString();
		--奖品描述
		dataTable["PrizesLoop"][i]["PrizeMsg"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(length + pos);
	end
	dataTable["Timestamp"] = tonumber(nMBaseMessage:readInt());

	return dataTable;
end

--[[--
--3.16.32 每日任务列表（COMMONS_DAILYTASK）
--]]--
function read80650020(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_DAILYTASK;
	dataTable["messageName"] = "COMMONS_DAILYTASK";
	--任务列表
	dataTable["taskNum"] = tonumber(nMBaseMessage:readInt());
	dataTable["TaskListLoop"] = {}
	for i = 1,dataTable["taskNum"] do
		dataTable["TaskListLoop"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--任务ID
		dataTable["TaskListLoop"][i]["ID"] = tonumber(nMBaseMessage:readInt());
		--Common.log("read80650020 ID = " .. dataTable["TaskListLoop"][i]["ID"])
		--任务名称
		dataTable["TaskListLoop"][i]["Name"] = nMBaseMessage:readString();
		--Common.log("read80650020 Name = " .. dataTable["TaskListLoop"][i]["Name"])
		--任务描述
		dataTable["TaskListLoop"][i]["Desc"] = nMBaseMessage:readString();
		--Common.log("read80650020 Desc = " .. dataTable["TaskListLoop"][i]["Desc"])
		--任务进度
		dataTable["TaskListLoop"][i]["Process"] = nMBaseMessage:readString();
		--Common.log("read80650020 Process = " .. dataTable["TaskListLoop"][i]["Process"])
		--奖励名称
		dataTable["TaskListLoop"][i]["PrizeName"] = nMBaseMessage:readString();
		--Common.log("read80650020 PrizeName = " .. dataTable["TaskListLoop"][i]["PrizeName"])
		--ActionID
		dataTable["TaskListLoop"][i]["ActionId"] = tonumber(nMBaseMessage:readInt());
		--Common.log("read80650020 ActionId = " .. dataTable["TaskListLoop"][i]["ActionId"])
		--按钮状态
		dataTable["TaskListLoop"][i]["Status"] = nMBaseMessage:readByte();
		--Common.log("read80650020 Status = " .. dataTable["TaskListLoop"][i]["Status"])
		--Progress 进度
		dataTable["TaskListLoop"][i]["Progress"] = nMBaseMessage:readByte();
		--Common.log("read8065001e Progress = " .. dataTable["TaskListLoop"][i]["Progress"])
		nMBaseMessage:setReadPos(length + pos);
	end
	return dataTable;
end

--[[--
--3.16.33 领取每日任务奖励（COMMONS_GET_DAILYTASK_PRIZE）
--]]--
function read80650021(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_GET_DAILYTASK_PRIZE;
	dataTable["messageName"] = "COMMONS_GET_DAILYTASK_PRIZE";
	--是否成功
	dataTable["IsSuccess"] = nMBaseMessage:readByte();
	--提示语
	dataTable["Msg"] = nMBaseMessage:readString();
	--奖品列表
	dataTable["Loop"] = tonumber(nMBaseMessage:readInt());
	dataTable["PrizesLoop"] = {}
	for i = 1,dataTable["Loop"] do
		dataTable["PrizesLoop"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--奖品图片
		dataTable["PrizesLoop"][i]["PicUrl"] = nMBaseMessage:readString();
		--奖品描述
		dataTable["PrizesLoop"][i]["PrizeMsg"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(length + pos);
	end

	return dataTable;
end

--[[--
--3.1.32第三方渠道登录(THIRD_PART_PLAT_LOGIN)
--]]--
function read80010020(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BASEID_THIRD_PART_PLAT_LOGIN
	dataTable["messageName"] = "BASEID_THIRD_PART_PLAT_LOGIN"

	dataTable["Password"] = nMBaseMessage:readString()
	--Common.log("read80010020 Password = "..dataTable["Password"])

	--1为新注册用户;0为老用户
	dataTable["IsRegister"] = nMBaseMessage:readByte()
	--Common.log("read80010020 IsRegister = "..dataTable["IsRegister"])

	return dataTable
end

--[[--
--3.7.142 微信绑定(MANAGERID_WECHAT_BIND)
--]]--
function read8007008e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_WECHAT_BIND
	dataTable["messageName"] = "MANAGERID_WECHAT_BIND"

	--是否成功  1成功;0不成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read8007008e Result = "..dataTable["Result"])
	--绑定后的登录名  --修改登录名则返回  否则返回""
	dataTable["LoginName"] = nMBaseMessage:readString()
	--Common.log("read8007008e LoginName = "..dataTable["LoginName"])
	return dataTable
end

--[[--
--获取当前手机用户登录列表信息
--]]
function read8007009d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_USERLIST_FROM_IMIE
	dataTable["messageName"] = "MANAGERID_USERLIST_FROM_IMIE"

	--NickCnt	int	昵称数量	loop
	local NickCnt = tonumber(nMBaseMessage:readInt())
	dataTable["NickList"] = {}
	--Common.log("read8007009a == NickCnt === "..NickCnt)
	for i = 1, NickCnt do
		dataTable["NickList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--…NickName	text	登陆过此手机的昵称
		dataTable["NickList"][i].NickName = nMBaseMessage:readString();
		Common.log("dataTable[NickList][i].NickName ===== "..dataTable["NickList"][i].NickName);
		--…IsBindWeChat	byte	此账号是否绑定微信	0：没有；1：有
		dataTable["NickList"][i].IsBindWeChat = nMBaseMessage:readByte();

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--
--获取用户绑定微信信息
--]]
function read8007009e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_HINT_BIND_WECHAT
	dataTable["messageName"] = "MANAGERID_HINT_BIND_WECHAT"

	--isHint	byte	是否需要提示用户绑定微信
	dataTable["isHint"] = nMBaseMessage:readByte();
	--AwardCoin	text	绑定微信提示信息
	dataTable["AwardCoin"] = nMBaseMessage:readString();
	Common.log("read8007009e AwardCoin = "..dataTable["AwardCoin"])

	return dataTable
end

--[[--
--3.7.143 是否是微信绑定用户(MANAGERID_IS_BIND_WECHAT)
--]]--
function read8007008f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_IS_BIND_WECHAT
	dataTable["messageName"] = "MANAGERID_IS_BIND_WECHAT"

	--是否是微信绑定用户  1是;0否
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read8007008f Result = "..dataTable["Result"])

	return dataTable
end

--[[--
--3.7.165 请求红包信息(MANAGERID_GET_RED_PACKETS_INFO)
--]]--
function read800700a5(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_RED_PACKETS_INFO
	dataTable["messageName"] = "MANAGERID_GET_RED_PACKETS_INFO"

	--GiveCoin	Long	红包送金数,0:没有红包送金
	dataTable["GiveCoin"] = nMBaseMessage:readLong()
	Common.log("read800700a5 GiveCoin = "..dataTable["GiveCoin"])

	return dataTable
end

--[[--
--3.7.166 请求领取红包(MANAGERID_RECEIVE_RED_PACKETS)
--]]--
function read800700a6(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_RECEIVE_RED_PACKETS
	dataTable["messageName"] = "MANAGERID_RECEIVE_RED_PACKETS"

	--IsSuccess	byte	是否成功1成功0失败
	dataTable["IsSuccess"] = nMBaseMessage:readByte()
	Common.log("read800700a6 IsSuccess = "..dataTable["IsSuccess"])

	return dataTable
end