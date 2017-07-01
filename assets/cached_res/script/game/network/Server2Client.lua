------------------------------------------------------------------
--[[-----------------------DBID数据库消息-------------------------]]
------------------------------------------------------------------

--[[--
--
-- 解析自己或他人的详细信息
--
-- ]]
function read80060002(nMBaseMessage)
	Common.log("read80060002解析自己或他人的详细信息")
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_USER_INFO
	dataTable["messageName"] = "DBID_USER_INFO"
	-- UserID Int 用户ID
	dataTable["UserID"] = tonumber(nMBaseMessage:readInt());
	Common.log("用户ID：" .. dataTable["UserID"]);
	-- NickName text 昵称
	dataTable["NickName"] = nMBaseMessage:readString();
	Common.log("昵称：" .. dataTable["NickName"]);
	-- Sex byte 性别 1男 2女
	dataTable["Sex"] = nMBaseMessage:readByte();
	-- Age byte 年龄
	dataTable["age"] = nMBaseMessage:readByte();
	-- City text 城市 如 :北京-海淀
	dataTable["city"] = nMBaseMessage:readString();
	-- PhotoUrl text 头像URL
	dataTable["photourl"] = nMBaseMessage:readString();
	Common.log("read80060002 photourl " .. dataTable["photourl"])
	-- Sign text 个性签名
	dataTable["sign"] = nMBaseMessage:readString();
	-- Coin long 金币
	dataTable["coin"] = tonumber(nMBaseMessage:readLong());
	-- YuanBao int 元宝
	dataTable["yuanbao"] = tonumber(nMBaseMessage:readInt());
	-- TaoJin int 荣誉值
	dataTable["honor"] = tonumber(nMBaseMessage:readInt());
	-- GameID byte 游戏ID
	dataTable["gameid"] = nMBaseMessage:readByte();
	-- DuiJiangQuan int 兑奖券 MsgVer >= 1时发送
	dataTable["duijiang"] = tonumber(nMBaseMessage:readInt());
	-- commendationCnt int 奖状数 MsgVer >= 1时发送
	dataTable["commendationCnt"] = tonumber(nMBaseMessage:readInt());

	--byte数组
	--    byte[] data = readBytes();
	local length = nMBaseMessage:readShort();
	local pos = nMBaseMessage:getReadPos();

	-----------------------
	----- 接收游戏相关数据
	------------------------
	dataTable["WinGameNum"] = tonumber(nMBaseMessage:readInt());
	dataTable["LoseGameNum"]= tonumber(nMBaseMessage:readInt());
	dataTable["MaxShoupai"] = nMBaseMessage:readString();


	nMBaseMessage:setReadPos(pos + length)

	--VipLevel int VIP等级
	dataTable["mnVipLevel"] = tonumber(nMBaseMessage:readInt());
	Common.log("DBID_USER_INFO mnVipLevel " .. dataTable["mnVipLevel"])
	--LawLimitRemind text 法律风险相关提示语 亲，您今天已经累计输掉3000万金币了，达到单日上限，无法继续游戏了。
	dataTable["lawLimitRemind"] = nMBaseMessage:readString();
	--DjqPieces int 兑奖券碎片数量
	dataTable["djqPieces"] = tonumber(nMBaseMessage:readInt());
	--HistoryMaxCoin long 历史最高金币数
	dataTable["historyMaxCoin"] = tonumber(nMBaseMessage:readLong());

	return dataTable
end

--[[-- 解析商城商品列表]]
function read80060044(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_MALL_GOODS_LIST
	dataTable["messageName"] = "DBID_MALL_GOODS_LIST"

	--Timestamp
	dataTable["Timestamp"] = tonumber(nMBaseMessage:readLong())
	--Num
	dataTable["GoodsTable"] = {}
	local Num = tonumber(nMBaseMessage:readInt());
	Common.log("GoodsTable---- = Num" .. Num)
	for i = 1, Num do
		dataTable["GoodsTable"][i] = {}
		--…ID
		dataTable["GoodsTable"][i].ID = tonumber(nMBaseMessage:readInt());
		Common.log("GoodsTable--- = " .. dataTable["GoodsTable"][i].ID)
		--…Name  名称
		dataTable["GoodsTable"][i].Name = nMBaseMessage:readString()
		Common.log("GoodsTable---名称 = " .. dataTable["GoodsTable"][i].Name)
		--…gameType  所属游戏
		dataTable["GoodsTable"][i].gameType = nMBaseMessage:readByte()
		Common.log("GoodsTable---所属游戏 = " .. dataTable["GoodsTable"][i].gameType)
		--…goodsType  商品类型
		dataTable["GoodsTable"][i].goodsType = nMBaseMessage:readByte()
		Common.log("GoodsTable---商品类型 = " .. dataTable["GoodsTable"][i].goodsType)
		--…IconURL  图标url
		dataTable["GoodsTable"][i].IconURL = nMBaseMessage:readString()
		Common.log("GoodsTable---图标url = " .. dataTable["GoodsTable"][i].IconURL)
		--…Title  标题
		dataTable["GoodsTable"][i].Title = nMBaseMessage:readString()
		Common.log("GoodsTable---标题 = " .. dataTable["GoodsTable"][i].Title)
		--…Description  描述
		dataTable["GoodsTable"][i].Description = nMBaseMessage:readString()
		Common.log("GoodsTable---描述 = " .. dataTable["GoodsTable"][i].Description)
		--…PurchaseLowerLimit  购买数量下限
		dataTable["GoodsTable"][i].PurchaseLowerLimit = tonumber(nMBaseMessage:readInt());
		Common.log("GoodsTable---购买数量下限 = " .. dataTable["GoodsTable"][i].PurchaseLowerLimit)
		--…PurchaseUpperLimit  购买数量上限
		dataTable["GoodsTable"][i].PurchaseUpperLimit = tonumber(nMBaseMessage:readInt());
		Common.log("GoodsTable---购买数量上限 = " .. dataTable["GoodsTable"][i].PurchaseUpperLimit)
		--…ConsumeType  消耗类型
		dataTable["GoodsTable"][i].ConsumeType = nMBaseMessage:readByte()
		Common.log("GoodsTable---消耗类型 = " .. dataTable["GoodsTable"][i].ConsumeType)
		--…Consume  单价
		dataTable["GoodsTable"][i].Consume = tonumber(nMBaseMessage:readInt());
		Common.log("GoodsTable---单价 = " .. dataTable["GoodsTable"][i].Consume)
		--…VipConsume  Vip单价
		dataTable["GoodsTable"][i].VipConsume = tonumber(nMBaseMessage:readInt());
		Common.log("GoodsTable---Vip单价 = " .. dataTable["GoodsTable"][i].VipConsume)
		--…operationTagUrl  运营标签url
		dataTable["GoodsTable"][i].operationTagUrl = nMBaseMessage:readString()
		Common.log("GoodsTable---运营标签url = " .. dataTable["GoodsTable"][i].operationTagUrl)
	end
	--VipNum  Vip数量
	dataTable["VipDiscountTable"] = {}
	local VipNum = tonumber(nMBaseMessage:readInt());
	for i = 1, VipNum do
		dataTable["VipDiscountTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		Common.log("VipDiscountTable---length = " .. length)
		--…vipLevel  Vip等级
		dataTable["VipDiscountTable"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		Common.log("VipDiscountTable---Vip等级 = " .. dataTable["VipDiscountTable"][i].vipLevel)
		--…vipDiscount  Vip折扣
		dataTable["VipDiscountTable"][i].vipDiscount = tonumber(nMBaseMessage:readInt());
		Common.log("VipDiscountTable---Vip折扣 = " .. dataTable["VipDiscountTable"][i].vipDiscount)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 解析破产送金]]
function read8007004e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GIVE_AWAY_GOLD
	dataTable["messageName"] = "MANAGERID_GIVE_AWAY_GOLD"

	-- RemainCount byte 当天剩余破产送金次数
	dataTable["mnRemainCount"] = nMBaseMessage:readByte()
	Common.log("read8007004e mnRemainCount " .. dataTable["mnRemainCount"])
	--ResultMsg  提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	Common.log("read8007004e ResultMsg " .. dataTable["ResultMsg"])
	--IsSuccess byte 是否成功1成功0不成功
	dataTable["isSuccess"] = nMBaseMessage:readByte()
	Common.log("read8007004e isSuccess " .. dataTable["isSuccess"])

	return dataTable
end

-----------------解析RankListGetRankDataBean--------------------
function read80650002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + RankListGetRankDataBean
	dataTable["messageName"] = "RankListGetRankDataBean"
	Common.log("收到排行榜信息")
	--解析List< RankListItem 列表>
	local arrayTable0 = {}
	local cnt = nMBaseMessage:readByte()
	Common.log("收到排行榜信息cnt",cnt)
	for i0=1,cnt do
		--解析Bean  RankListItem 列表
		beanTable1 = {}
		local length = nMBaseMessage:readShort()
		if length ~= 0 then
			local pos = nMBaseMessage:getReadPos()
			--解析 名次
			beanTable1.rankNum = tonumber(nMBaseMessage:readInt());
			--解析 头像url
			beanTable1.photoUrl = nMBaseMessage:readUTF()
			--解析 用户昵称
			beanTable1.nickName = nMBaseMessage:readUTF()
			--解析 vip级别
			beanTable1.vipLevel = tonumber(nMBaseMessage:readInt());
			Common.log("vip等级别"..beanTable1.vipLevel)
			--解析 在每日金币榜中:代表金币总值 在每日充值榜中:代表当天充值了多少 在每日赢取榜中:代表当天赢取了多少
			beanTable1.rankingData = tonumber(nMBaseMessage:readLong())
			nMBaseMessage:setReadPos(pos + length)
		end


		arrayTable0[i0] = beanTable1
	end
	dataTable["RankList"] = arrayTable0
	--解析 颁奖规则
	dataTable["prizeGivingRule"] = nMBaseMessage:readUTF()
	Common.log("prizeGivingRule is " ..  dataTable["prizeGivingRule"])
	--解析 我的排名
	dataTable["selfRankingNum"] = tonumber(nMBaseMessage:readInt());
	--解析 更新时间
	dataTable["updateRankingTime"] = tonumber(nMBaseMessage:readLong())
	--解析 显示哪一个排行榜1每日赚金榜2今日充值榜3土豪榜4昨日充值榜
	dataTable["witchRankingList"] = nMBaseMessage:readByte()
	return dataTable
end

-----------------解析打招呼消息--------------------
function read80060025(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_SAY_HELLO
	dataTable["messageName"] = "DBID_V2_SAY_HELLO"

	--解析     0成功1失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--解析 提示语
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

-----------------第二版VIP信息同步-------------------
function read8007004a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_VIP_MSG
	dataTable["messageName"] = "MANAGERID_GET_VIP_MSG"

	--VipLevel	Int	当前vip等级
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	--VipExpirationDate	Long	Vip到期时间
	dataTable["VipExpirationDate"] = tonumber(nMBaseMessage:readLong());
	--Amount	Int	当月累计充值金额
	dataTable["Amount"] = tonumber(nMBaseMessage:readInt());
	--Balance	Int	到达下一级vip的差额
	dataTable["Balance"] = tonumber(nMBaseMessage:readInt());
	Common.log("vip22222"..dataTable["VipLevel"]..dataTable["Amount"]..dataTable["Balance"])

	return dataTable
end

--[[-- 解析VIP列表_V3(MANAGERID_VIP_LIST_V3)]]
function read8007004c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VIP_LIST_V3
	dataTable["messageName"] = "MANAGERID_VIP_LIST_V3"

	--timestamp  时间戳
	dataTable["timestamp"] = tonumber(nMBaseMessage:readLong())
	Common.log("时间戳 = " .. dataTable["timestamp"])
	--VipInfo  VIP说明界面信息
	dataTable["VipInfo"] = nMBaseMessage:readString()
	Common.log("VIP说明界面信息 = " .. dataTable["VipInfo"])
	--VipLooper  VIP信息
	dataTable["vipTable"] = {}
	local VipLooper = tonumber(nMBaseMessage:readInt());
	for i = 1, VipLooper do
		dataTable["vipTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Common.log("vipTable---length = " .. length)
		--…vipLevel  VIP 等级
		dataTable["vipTable"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		--Common.log("vipTable---VIP 等级 = ".. dataTable["vipTable"][i].vipLevel)
		--…vipQualification  VIP 获得条件
		dataTable["vipTable"][i].vipQualification = nMBaseMessage:readString()
		--Common.log("vipTable---VIP 获得条件 = ".. dataTable["vipTable"][i].vipQualification)
		--…vipPrivilege  VIP 特权
		dataTable["vipTable"][i].vipPrivilege = nMBaseMessage:readString()
		--Common.log("vipTable---VIP 特权 = ".. dataTable["vipTable"][i].vipPrivilege)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[--解析VIP列表_V3(MANAGERID_VIP_LEVEL_LIST)]]
function read8007004d(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_VIP_LEVEL_LIST;
	dataTable["messageName"] = "MANAGERID_VIP_LEVEL_LIST";
	dataTable["VipLevelListTable"] = {};
	local vipLevellist_Count = tonumber(nMBaseMessage:readInt());
	for i = 1 , vipLevellist_Count do
		dataTable["VipLevelListTable"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		dataTable["VipLevelListTable"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		dataTable["VipLevelListTable"][i].needMoney = tonumber(nMBaseMessage:readInt());
		nMBaseMessage:setReadPos(length + pos)
	end
	dataTable["VipMaxLevel"] = tonumber(nMBaseMessage:readInt());
	return dataTable
end

--[[--接受是否有新的公告]]
function read8007006c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_HAVE_NEW_GONGGAO
	dataTable["messageName"] = "MANAGERID_GET_HAVE_NEW_GONGGAO"
	--Result	byte	结果	0：没有新公告;1：有新公告
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read8007006c Result " .. dataTable["Result"])
	return dataTable
end

function read8007006d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_V3_GET_ACTIVITY_LIST
	dataTable["messageName"] = "MANAGERID_V3_GET_ACTIVITY_LIST"
	--UrlCnt	活动数量
	dataTable["UrlCnt"] = tonumber(nMBaseMessage:readInt());
	Common.log("活动数 = " .. dataTable["UrlCnt"])
	dataTable["UrlList"] = {}
	for i = 1, dataTable["UrlCnt"] do
		dataTable["UrlList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--Url Text 图片地址
		dataTable["UrlList"][i].Url = nMBaseMessage:readString()
		Common.log("read8007006d Url " .. dataTable["UrlList"][i].Url)
		--Title Text 活动标题
		dataTable["UrlList"][i].Title = nMBaseMessage:readString()
		Common.log("read8007006d Title " .. dataTable["UrlList"][i].Title)
		--Date Text 活动日期
		dataTable["UrlList"][i].Date = nMBaseMessage:readString()
		Common.log("read8007006d Date " .. dataTable["UrlList"][i].Date)
		--ActionID Byte 动作类型
		dataTable["UrlList"][i].ActionID = nMBaseMessage:readByte()
		Common.log("read8007006d ActionID " .. dataTable["UrlList"][i].ActionID)
		--ParamCnt Byte 参数数量
		dataTable["UrlList"][i].ParamCnt = nMBaseMessage:readByte()
		Common.log("read8007006d ParamCnt " .. dataTable["UrlList"][i].ParamCnt)
		dataTable["UrlList"][i]["ParamVal"] = {}
		for j = 1,dataTable["UrlList"][i]["ParamCnt"] do
			dataTable["UrlList"][i]["ParamVal"][j] = nMBaseMessage:readString()
			Common.log("read8007006d ParamVal " .. dataTable["UrlList"][i]["ParamVal"][j])
		end
		nMBaseMessage:setReadPos(pos + length)
	end
	dataTable["time"] = tonumber(nMBaseMessage:readLong())
	Common.log("read8007006d time " .. dataTable["time"])
	return dataTable
end

--是否有新活动
function read8007006f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_HAVE_NEW_HUODONG
	dataTable["messageName"] = "MANAGERID_GET_HAVE_NEW_HUODONG"
	--Result	byte	结果	0：没有新活动;1：有新活动
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read8007006f result " .. dataTable["Result"])
	return dataTable
end

--获取可兑奖的奖品列表
function read80070070(nMBaseMessage)
	Common.log("read80070070 ")
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_EXCHANGBLE_AWARDS
	dataTable["messageName"] = "MANAGERID_GET_EXCHANGBLE_AWARDS"
	dataTable["ExchangableAwardsList"] = {}
	local ExchangableAwardsListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80070070 Cnt " .. ExchangableAwardsListCnt)
	for i = 1, ExchangableAwardsListCnt do
		dataTable["ExchangableAwardsList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- …AwardID Int 奖品id
		dataTable["ExchangableAwardsList"][i].awardID = tonumber(nMBaseMessage:readInt());
		Common.log("read80070070 awardID " .. dataTable["ExchangableAwardsList"][i].awardID)
		-- …AwardStatus Int 奖品状态
		dataTable["ExchangableAwardsList"][i].awardStatus = tonumber(nMBaseMessage:readInt());
		Common.log("read80070070 awardStatus " .. dataTable["ExchangableAwardsList"][i].awardStatus)
		-- …AwardMsg Text 可合成兑奖提示信息
		dataTable["ExchangableAwardsList"][i].awardMsg = nMBaseMessage:readString();
		Common.log("read80070070 awardMsg " .. dataTable["ExchangableAwardsList"][i].awardMsg)
		-- …AwardNeedYuanBao	Int	充值引导所需要的元宝数	只有需要充值引导才可合成兑奖时才返回,否则返回0
		dataTable["ExchangableAwardsList"][i].awardNeedYuanBao = tonumber(nMBaseMessage:readInt());
		Common.log("read80070070 awardNeedYuanBao " .. dataTable["ExchangableAwardsList"][i].awardNeedYuanBao)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--------------------活动解析---------------------

--[[--
---解析宝盒V3：获取宝盒进度(BAOHE_V4_GET_PRO)
--]]
function read8061001a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_V4_GET_PRO
	dataTable["messageName"] = "BAOHE_V4_GET_PRO"
	--RoomLevel	Byte	房间等级	0,1,2,3
	dataTable["RoomLevel"] = nMBaseMessage:readByte()
	--Progress  已完成局数
	dataTable["Progress"] = nMBaseMessage:readShort()
	Common.log("已完成局数 = " .. dataTable["Progress"])
	--Max  总局数
	dataTable["Max"] = nMBaseMessage:readShort()
	Common.log("总局数 = " .. dataTable["Max"])
	return dataTable
end
--[[--
---解析宝盒V3：获取宝盒列表(BAOHE_V4_GET_LIST)
--]]
function read8061001b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_V4_GET_LIST
	dataTable["messageName"] = "BAOHE_V4_GET_LIST"

	dataTable["TreasureBoxList"] = {}
	--	TreasureBoxList	loop	宝盒列表
	local BoxNum = tonumber(nMBaseMessage:readInt());
	for i = 1, BoxNum do
		dataTable["TreasureBoxList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Position	byte	宝盒编号（从左至右0，1，2）
		dataTable["TreasureBoxList"][i].Position = nMBaseMessage:readByte()
		--…state	byte		0：未打开 1：已打开
		dataTable["TreasureBoxList"][i].state = nMBaseMessage:readByte()
		--…description	Text	宝盒奖品描述	未打开的宝盒数据传空字符串
		dataTable["TreasureBoxList"][i].description = nMBaseMessage:readString()
		--…PrizeUrl	Text	宝盒奖品图片	未打开的宝盒数据传空字符串
		dataTable["TreasureBoxList"][i].PrizeUrl = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--最多开几次宝盒
	dataTable["openCountMax"] = tonumber(nMBaseMessage:readInt());
	return dataTable
end
--[[--
---解析宝盒V3：宝盒领奖(BAOHE_V4_GET_PRIZE)
--]]
function read8061001c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + BAOHE_V4_GET_PRIZE
	dataTable["messageName"] = "BAOHE_V4_GET_PRIZE"
	--Result	Byte	1 成功 0 失败
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultMsg	Text	提示语
	dataTable["ResultMsg"] = nMBaseMessage:readString()
	dataTable["TreasurePrizeList"] = {}
	--TreasureCnt	Loop	奖励物品个数
	local PrizeNum = tonumber(nMBaseMessage:readInt());
	for i = 1, PrizeNum do
		dataTable["TreasurePrizeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…TreasurePicUrl	Text	物品图片url
		dataTable["TreasurePrizeList"][i].TreasurePicUrl = nMBaseMessage:readString()
		--…TreasureDiscription	Text	物品描述
		dataTable["TreasurePrizeList"][i].TreasureDiscription = nMBaseMessage:readString()
		--…Multiple	int	奖品倍数
		dataTable["TreasurePrizeList"][i].Multiple = tonumber(nMBaseMessage:readInt());
		--…lastTreasureCount	int	最终奖品数目
		dataTable["TreasurePrizeList"][i].lastTreasureCount = tonumber(nMBaseMessage:readInt());
		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["TreasureBoxList"] = {}
	--	TreasureBoxList	loop	宝盒列表
	local BoxNum = tonumber(nMBaseMessage:readInt());
	for i = 1, BoxNum do
		dataTable["TreasureBoxList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Position	byte	宝盒编号（从左至右0，1，2）
		dataTable["TreasureBoxList"][i].Position = nMBaseMessage:readByte()
		--…state	byte		0：未打开 1：已打开
		dataTable["TreasureBoxList"][i].state = nMBaseMessage:readByte()
		--…description	Text	宝盒奖品描述
		dataTable["TreasureBoxList"][i].description = nMBaseMessage:readString()
		--…PrizeUrl	Text	宝盒奖品图片
		dataTable["TreasureBoxList"][i].PrizeUrl = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--Progress	Short	已完成局数
	dataTable["Progress"] = nMBaseMessage:readShort()
	--Max  总局数
	dataTable["Max"] = nMBaseMessage:readShort()
	--Position	byte	宝盒编号（从左至右0，1，2）
	dataTable["Position"] = nMBaseMessage:readByte()
	return dataTable
end

--[[--
--解析OPERID_GET_DAILY_NOTIFY_INFO
--]]
function read80610037(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_GET_DAILY_NOTIFY_INFO
	dataTable["messageName"] = "OPERID_GET_DAILY_NOTIFY_INFO"

	--StarNickName	String	本期之星昵称
	dataTable["StarNickName"] = nMBaseMessage:readString()
	Common.log("read80610037 StarNickName is " .. dataTable["StarNickName"])
	--StarAwardPic	String	本期之星获奖图片
	dataTable["StarAwardPic"] = nMBaseMessage:readString()
	Common.log("read80610037 StarAwardPic is " .. dataTable["StarAwardPic"])
	--StarAwardTimeStamp	Long	本期之星时间戳
	dataTable["StarAwardTimeStamp"] = tonumber(nMBaseMessage:readLong())
	Common.log("read80610037 StarAwardTimeStamp is " .. dataTable["StarAwardTimeStamp"])
	--StarAwardDesc	String	本期之星获奖详细文本
	dataTable["StarAwardDesc"] = nMBaseMessage:readString()
	Common.log("read80610037 StarAwardDesc is " .. dataTable["StarAwardDesc"])

	--NotifyInfoList	Loop	公告与活动的列表	Loop
	local NotifyInfoListCnt = tonumber(nMBaseMessage:readInt());
	dataTable["NotifyInfoListCnt"] = NotifyInfoListCnt
	Common.log("read80610037 NotifyInfoListCnt is " .. NotifyInfoListCnt)
	dataTable["NotifyInfoList"] = {}
	for i = 1, NotifyInfoListCnt do
		dataTable["NotifyInfoList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--NotifyName	String	公告或者活动的名字
		dataTable["NotifyInfoList"][i]["NotifyName"] = nMBaseMessage:readString()
		Common.log("read80610037 NotifyName is " .. dataTable["NotifyInfoList"][i]["NotifyName"])
		--NofityType	Int	        类型:用于标示是公告还是活动	    0:公告 1:活动
		dataTable["NotifyInfoList"][i]["NofityType"] = tonumber(nMBaseMessage:readInt());
		Common.log("read80610037 NofityType is " .. dataTable["NotifyInfoList"][i]["NofityType"])
		--NotifyDes	String	所要展示的内容	当是活动时:此处为活动的图片地址  当是公告时:此处为公告的具体内容
		dataTable["NotifyInfoList"][i]["NotifyDes"] = nMBaseMessage:readString()
		Common.log("read80610037 NotifyDes is " .. dataTable["NotifyInfoList"][i]["NotifyDes"])
		--NotifyParamID	String	活动参数ID	标示是哪个活动,用于触发事件
		dataTable["NotifyInfoList"][i]["NotifyParamID"] = nMBaseMessage:readString()
		Common.log("read80610037 NotifyParamID is " .. dataTable["NotifyInfoList"][i]["NotifyParamID"])

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end


--9.1.1获取当前每日任务(DAILYTASKID_CURRENT_TASK)
function read80090001(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DAILYTASKID_CURRENT_TASK
	dataTable["messageName"] = "DAILYTASKID_CURRENT_TASK"
	--TaskID	int	任务ID
	dataTable["TaskID"] = tonumber(nMBaseMessage:readInt());
	Common.log("TaskID",dataTable["TaskID"])

	--TaskTitle	Text	任务标题
	dataTable["Title"] = nMBaseMessage:readString()
	Common.log("Title",dataTable["Title"])

	--StarLevel	Int	星级
	dataTable["StarLevel"] = tonumber(nMBaseMessage:readInt());
	Common.log("StarLevel",dataTable["StarLevel"])

	--Description	Text	描述
	dataTable["Description"] = nMBaseMessage:readString()
	Common.log("Description",dataTable["Description"])

	--Proceeding	Byte	进度
	dataTable["Proceeding"] = nMBaseMessage:readByte()
	Common.log("Proceeding",dataTable["Proceeding"])

	--AllProceeding	Byte	总进度数
	dataTable["AllProceeding"] = nMBaseMessage:readByte()
	Common.log("AllProceeding",dataTable["AllProceeding"])

	--Award	Text	奖励
	dataTable["Award"] = nMBaseMessage:readString()
	Common.log("Award",dataTable["Award"])

	--RefreshTime	Int	刷新次数
	dataTable["RefreshTime"] = tonumber(nMBaseMessage:readInt());
	Common.log("RefreshTime",dataTable["SelfRefreshTimeRank"])

	--RefreshPrice	Int	刷新价格
	dataTable["RefreshPrice"] = tonumber(nMBaseMessage:readInt());
	Common.log("RefreshPrice",dataTable["RefreshPrice"])

	--CompletePrice	Int	直接完成价格
	dataTable["CompletePrice"] = tonumber(nMBaseMessage:readInt());
	Common.log("CompletePrice",dataTable["CompletePrice"])


	--CurrentStarLevel	Int	当前星级
	dataTable["CurrentStarLevel"] = tonumber(nMBaseMessage:readInt());
	Common.log("CurrentStarLevel",dataTable["CurrentStarLevel"])

	return dataTable
end

--[[-- 解析牌桌等待提示]]
function read80060035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DBID_V2_WATING_TIPS
	dataTable["messageName"] = "DBID_V2_WATING_TIPS"

	--AddCnt  添加数量
	local addCnt = nMBaseMessage:readByte()
	Common.log("---提示num = ".. addCnt)
	dataTable["AddMsg"] = {}
	for i=1,addCnt do
		dataTable["AddMsg"][i] = {}
		--…tipID  提示ID
		dataTable["AddMsg"][i].tipID = tonumber(nMBaseMessage:readInt());
		Common.log("---提示ID = ".. dataTable["AddMsg"][i].tipID)
		--…CategoryURL  类别URL
		dataTable["AddMsg"][i].CategoryURL = nMBaseMessage:readString()
		Common.log("---类别URL = ".. dataTable["AddMsg"][i].CategoryURL)
		--…Title  标题
		dataTable["AddMsg"][i].Title = nMBaseMessage:readString()
		Common.log("---标题 = ".. dataTable["AddMsg"][i].Title)
		--…Tip  提示内容
		dataTable["AddMsg"][i].Tip = nMBaseMessage:readString()
		Common.log("---提示内容 = ".. dataTable["AddMsg"][i].Tip)
	end
	--DeleteCnt  删除数量
	dataTable["DeleteMsg"] = {}
	local DeleteCnt = nMBaseMessage:readByte()
	for i = 1, DeleteCnt do
		dataTable["DeleteMsg"][i] = {}
		--…TipID  提示ID
		dataTable["DeleteMsg"][i].TipID = tonumber(nMBaseMessage:readInt());
		Common.log("DeleteMsg---提示ID = ".. dataTable["DeleteMsg"][i].TipID)
	end
	--TimeStamp  时间戳
	dataTable["TimeStamp"] = tonumber(nMBaseMessage:readLong())
	Common.log("时间戳 = " .. dataTable["TimeStamp"])
	--isDisplayAlone  是否单独显示1是0否
	dataTable["isDisplayAlone"] = nMBaseMessage:readByte()
	Common.log("是否单独显示1是0否 = " .. dataTable["isDisplayAlone"])
	return dataTable
end

--[[--解析牌桌举报消息]]
function read80070065(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_PLAYER_REPORT
	dataTable["messageName"] = "MANAGERID_PLAYER_REPORT"
	--举报结果
	dataTable["result"] = nMBaseMessage:readByte()
	--结果提示语
	dataTable["resultText"] = nMBaseMessage:readString()
	return dataTable
end

---------[[-- 月签  ---]]-------
-----------------月签[25天版]月签基本信息MONTH_SIGN_REWARD_LIST--------------------
function read80610017(nMBaseMessage)
	Common.log("read80610017 应答月签基本信息");
	local dataTable = {}
	dataTable["messageType"] = ACK + MONTH_SIGN_REWARD_LIST
	dataTable["messageName"] = "MONTH_SIGN_REWARD_LIST"

	--时间戳
	dataTable["timeStamp"] = tonumber(nMBaseMessage:readLong())
	--月签活动介绍
	dataTable["monthSignIntroduction"] = nMBaseMessage:readString()
	--月签奖品
	dataTable["monthSignPrize"] = {}
	--月签奖品种类数量
	local cnt = tonumber(nMBaseMessage:readInt());
	for i = 1 , cnt do
		dataTable["monthSignPrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品类型 0金币 1道具 2碎片 3 转盘
		dataTable["monthSignPrize"][i]["prizeType"] = nMBaseMessage:readByte()
		--奖品标题图片地址(PrizeType=3 传空)
		dataTable["monthSignPrize"][i]["prizeTitleUrl"] = nMBaseMessage:readString()
		Common.log("zblbt.......标题 == " .. dataTable["monthSignPrize"][i]["prizeTitleUrl"])
		--奖品图片地址(PrizeType=3 传空)
		dataTable["monthSignPrize"][i]["prizePicUrl"] = nMBaseMessage:readString()
		--奖品数量描述
		dataTable["monthSignPrize"][i]["thisPrizeNumInfo"] = nMBaseMessage:readString()
		--领取奖品提示语
		dataTable["monthSignPrize"][i]["thisPrizeTips1"] = nMBaseMessage:readString()
		--领取奖品提示语(PrizeType=3 传空)
		dataTable["monthSignPrize"][i]["thisPrizeTips2"] = nMBaseMessage:readString()
		--奖品标题
		dataTable["monthSignPrize"][i]["awardTitle"] = nMBaseMessage:readString()
		Common.log("zbl奖品: =   " .. dataTable["monthSignPrize"][i]["awardTitle"])
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

-----------------用户月签基本信息USERS_MONTH_SIGN_BASIC_INFO--------------------
function read80610018(nMBaseMessage)
	Common.log("read80610018 应答用户月签基本信息");
	local dataTable = {}
	dataTable["messageType"] = ACK + USERS_MONTH_SIGN_BASIC_INFO
	dataTable["messageName"] = "USERS_MONTH_SIGN_BASIC_INFO"

	--用户当前Vip等级所对应的领取转盘机会
	dataTable["VIPLevelTurnTable"] = {}
	--用户当前Vip等级所对应的领取转盘机会的次数
	local cnt = tonumber(nMBaseMessage:readInt());
	for i = 1 , cnt do
		dataTable["VIPLevelTurnTable"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--第N天
		dataTable["VIPLevelTurnTable"][i]["day"] = tonumber(nMBaseMessage:readInt());
		--用户当前Vip转盘次数
		dataTable["VIPLevelTurnTable"][i]["times"] = tonumber(nMBaseMessage:readInt());
		--下一VIP等级比当前VIP多转盘次数
		dataTable["VIPLevelTurnTable"][i]["nextVipMultiTimes"] = tonumber(nMBaseMessage:readInt());
		--领取奖品提示语
		dataTable["VIPLevelTurnTable"][i]["thisPrizeTips1"] = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--签到日期
	dataTable["isSignDate"] = {}
	--从1号到当前日期的签到次数(包括今天)
	local cnt = tonumber(nMBaseMessage:readInt());
	for i = 1, cnt do
		dataTable["isSignDate"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--日期
		dataTable["isSignDate"][i]["date"] = tonumber(nMBaseMessage:readInt());
		--签到状态 0 未签到(没有游戏签到) 1签到 2 缺签到(一个游戏签一个没签)
		dataTable["isSignDate"][i]["status"] = nMBaseMessage:readByte()
		nMBaseMessage:setReadPos(pos + length)
	end

	--领取奖品的类型 0金币 1道具 2碎片 3 转盘
	dataTable["TodayReceivePrizeType"] = nMBaseMessage:readByte();
	--Common.log("read80610018  TodayReceivePrizeType ==" .. dataTable["TodayReceivePrizeType"]);
	--今天签到奖品详情
	dataTable["TodayPrizeDetails"] = nMBaseMessage:readString();
	--Common.log("read80610018  TodayPrizeDetails ==" .. dataTable["TodayPrizeDetails"]);

	return dataTable
end

-----------------月签签到SIGN_TO_MONTH_SIGN--------------------
function read80610019(nMBaseMessage)
	Common.log("read80610019 应答月签签到");
	local dataTable = {}
	dataTable["messageType"] = ACK + SIGN_TO_MONTH_SIGN
	dataTable["messageName"] = "SIGN_TO_MONTH_SIGN"

	--是否成功签到 0 否 1是
	dataTable["result"] = nMBaseMessage:readByte()
	--成功或失败提示语
	dataTable["msg"] = nMBaseMessage:readString()
	--领取奖品的类型 0金币 1道具 2碎片 3 转盘
	dataTable["receivePrizeType"] = nMBaseMessage:readByte()
	--奖品的详情
	dataTable["PrizeDetails"] = nMBaseMessage:readString()

	return dataTable
end

---幸运转盘-----
-----------------转盘基本信息(TURNTABLE_BASIC_INFO)[00610015]--------------------
function read80610015(nMBaseMessage)
	Common.log("read80610015 应答转盘基本信息 ")
	local dataTable = {}
	dataTable["messageType"] = ACK + TURNTABLE_BASIC_INFO
	dataTable["messageName"] = "TURNTABLE_BASIC_INFO"

	--抽奖类型 0免费抽奖 1消耗金币 2消耗元宝
	dataTable["lotteryType"] = nMBaseMessage:readByte()
	--抽奖次数
	dataTable["lotteryCnt"] = tonumber(nMBaseMessage:readInt());
	--时间戳
	dataTable["timeStamp"] = tonumber(nMBaseMessage:readLong())
	--转盘玩法详情
	dataTable["turnTablePlayIntroduction"] = nMBaseMessage:readString()
	--转盘奖品数量
	local cnt = tonumber(nMBaseMessage:readInt());
	dataTable["turnTablePrize"] = {}
	for i=1 , cnt do
		dataTable["turnTablePrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品ID
		dataTable["turnTablePrize"][i]["prizeID"] = tonumber(nMBaseMessage:readInt());
		--奖品标题图片地址
		dataTable["turnTablePrize"][i]["prizeTitleUrl"] = nMBaseMessage:readString()
		--奖品图片地址
		dataTable["turnTablePrize"][i]["prizePicUrl"] = nMBaseMessage:readString()
		--奖品描述
		dataTable["turnTablePrize"][i]["thisPrizeInfo"] = nMBaseMessage:readString()
		--奖品描述URL(3.15添加)
		dataTable["turnTablePrize"][i]["PrizeDesUrl"] = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

-----------------转盘抽奖信息(TURNTABLE_LOTTERY_INFO)[00610016]--------------------
function read80610016(nMBaseMessage)
	Common.log("read80610016 应答转盘抽奖信息 ")
	local dataTable = {}
	dataTable["messageType"] = ACK + TURNTABLE_LOTTERY_INFO
	dataTable["messageName"] = "TURNTABLE_LOTTERY_INFO"

	--抽奖结果 0抽奖失败(成本不够、次数不够等) 1中奖
	dataTable["result"] = nMBaseMessage:readByte()
	--抽奖结果提示语
	dataTable["msg"] = nMBaseMessage:readString()
	--抽中的奖品ID
	dataTable["prizeID"] = tonumber(nMBaseMessage:readInt());
	--剩余抽奖次数
	dataTable["lotteryCnt"] = tonumber(nMBaseMessage:readInt());
	--奖品详情
	dataTable["PrizeDetails"] = nMBaseMessage:readString()

	return dataTable
end

-----------------获取大厅公告(MANAGERID_GET_SYSTEM_LIST_NOTICE)[0070072]--------------------
function read80070072(nMBaseMessage)
	Common.log("read80070072 应答获取大厅公告");
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_SYSTEM_LIST_NOTICE
	dataTable["messageName"] = "MANAGERID_GET_SYSTEM_LIST_NOTICE"

	--公告数量(服务器一般会给最新10条)
	local cnt = tonumber(nMBaseMessage:readInt());
	dataTable["SystemListNotice"] = {}
	for i=1 , cnt do
		dataTable["SystemListNotice"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--公告ID
		dataTable["SystemListNotice"][i]["NoticeID"] = nMBaseMessage:readByte()
		--公告内容
		dataTable["SystemListNotice"][i]["NoticeMsg"] = nMBaseMessage:readString()

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

-----------------获取大厅按钮状态(MANAGERID_GET_BUTTONS_STATUS)[0070073]--------------------
function read80070073(nMBaseMessage)
	Common.log("read80070073 应答获取大厅按钮状态");
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_BUTTONS_STATUS
	dataTable["messageName"] = "MANAGERID_GET_BUTTONS_STATUS"

	--大厅按钮列表
	local cnt = tonumber(nMBaseMessage:readInt());
	dataTable["HallButton"] = {}
	for i=1 , cnt do
		dataTable["HallButton"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--按钮ID
		dataTable["HallButton"][i]["ButtonID"] = tonumber(nMBaseMessage:readInt());
		--按钮状态   0 普通(开启) 1 变灰 2 隐藏
		dataTable["HallButton"][i]["ButtonStatus"] = nMBaseMessage:readByte()
		--开启提示语  (只有变灰的按钮才会有提示语)
		dataTable["HallButton"][i]["OpenConditionMsg"] = nMBaseMessage:readString()

		--Common.log("按钮ID：" .. dataTable["HallButton"][i]["ButtonID"] .. " 按钮状态(0 普通1 变灰 2 隐藏)：" .. dataTable["HallButton"][i]["ButtonStatus"]);
		--Common.log("按钮ID：" .. dataTable["HallButton"][i]["ButtonID"] .. " 开启提示语：" .. dataTable["HallButton"][i]["OpenConditionMsg"]);
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--踢人
function read80200015(nMBaseMessage)
	Common.log("read80200015")
	local dataTable = {}
	dataTable["messageType"] = ACK + JHGAMEID_KICK_OUT
	dataTable["messageName"] = "JHGAMEID_KICK_OUT"
	--ErrorCode	byte	踢人失败原因代码	0成功 1vip等级不足
	dataTable["ErrorCode"] = nMBaseMessage:readByte()
	--ErrorStr	Text	提示语
	dataTable["ErrorStr"] = nMBaseMessage:readUTF()
	Common.log("read80200015 ErrorStr is " .. dataTable["ErrorStr"])
	return dataTable
end


--获取退出弹框引导消息
function read80070075(nMBaseMessage)
	local dataTable = {}
	Common.log("应答read80070075");
	dataTable["messageType"] = ACK + MANAGERID_QUIT_GUIDE
	dataTable["messageName"] = "MANAGERID_QUIT_GUIDE"
	--左侧图片网络路径
	dataTable["PicUrlLeft"] = nMBaseMessage:readString()
	--Common.log("read80070075 === PicUrlLeft ==" .. dataTable["PicUrlLeft"]);
	--右侧标签
	dataTable["LabelRightTaskPrize"] = nMBaseMessage:readString()
	--Common.log("read80070075 === LabelRightTaskPrize ==" .. dataTable["LabelRightTaskPrize"]);
	--底部标签(3.09版本这个字段无用)
	dataTable["LabelMonthSignPrize"] = nMBaseMessage:readString()
	--Common.log("read80070075 === LabelMonthSignPrize ==" .. dataTable["LabelMonthSignPrize"]);
	--左侧按钮的回调事件1．打开新手任务 2．打开签到界面 3．直接进入房间宝盒牌桌 4．打开分享页面 5．跳转到福利 6.  推荐下载的游戏 7.  礼包推荐
	dataTable["TaskEventLeft"] = nMBaseMessage:readByte()
	--Common.log("read80070075 === TaskEventLeft ==" .. dataTable["TaskEventLeft"]);
	-- 缺省参数1 TaskEventLeft == 3 传roomId; TaskEventLeft == 6 传下载游戏的URL; TaskEventLeft == 7 传礼包ID
	dataTable["Param1"] = nMBaseMessage:readString();
	--Common.log("read80070075 === Param1 ==" .. dataTable["Param1"]);
	--缺省参数2 TaskEventLeft == 7 购买礼包消费的金币
	dataTable["Param2"] = nMBaseMessage:readString();
	--Common.log("read80070075 === Param2 ==" .. dataTable["Param2"]);

	return dataTable
end

-- [[免费金币]]--
function read80610029(nMBaseMessage)
	Common.log("read80610029 应答免费金币")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_FREE_COIN;
	dataTable["messageName"] = "OPERID_FREE_COIN";

	--可以免费领取金币的列表
	local cnt = tonumber(nMBaseMessage:readInt());
	--	--Common.log(" 免费领取金币的列表[列表数量] ==== "  .. cnt);
	for i=1 , cnt do
		dataTable[i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--模块ID  1001:月签,1002:每日任务,1003:分享,1004:开启房间宝盒
		dataTable[i]["ModuleID"] = tonumber(nMBaseMessage:readInt());
		--模块图标
		dataTable[i]["ModuleIcon"] = nMBaseMessage:readString();
		--模块标题
		dataTable[i]["ModuleTitle"] = nMBaseMessage:readString();
		Common.log("read80610029 == ModuleTitle ==" .. dataTable[i]["ModuleTitle"]);
		--模块简介
		dataTable[i]["ModuleIntro"] = nMBaseMessage:readString();
		--模块按钮状态 1001[0:未签1:已签] 1002[0:没红点1:有红点] 1003[0:未分享1:已领奖] 1004[-1:无任何状态]
		dataTable[i]["ModuleBtnStatus"] = nMBaseMessage:readByte();
		--模块按钮上要显示的文字
		dataTable[i]["ModuleBtnTxt"] = nMBaseMessage:readString();
		--参数值
		dataTable[i]["ParamVal"] = nMBaseMessage:readString();

		--Common.log(" 免费领取金币的列表 [ModuleID] == "  .. dataTable[i]["ModuleID"] .. " [ModuleBtnStatus] ==" .. dataTable[i]["ModuleBtnStatus"]);
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

-- [[领取游戏分享奖励]]--
function read8061002b(nMBaseMessage)
	Common.log("read8061002b 领取游戏分享奖励")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_REQUEST_GAME_SHARING_REWARD;
	dataTable["messageName"] = "OPERID_REQUEST_GAME_SHARING_REWARD";
	--result	Int	返回结果	失败返回 0,成功返回金币数
	dataTable["result"] = tonumber(nMBaseMessage:readInt());
	Common.log("read8061002b result " .. dataTable["result"])
	return dataTable
end

-- [[请求游戏分享累计奖励]]--
function read8061002c(nMBaseMessage)
	Common.log("read8061002c 请求游戏分享累计奖励")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_GAME_SHARING_ALL_REWARD;
	dataTable["messageName"] = "OPERID_GAME_SHARING_ALL_REWARD";

	--UsserCount	Int	邀请成功的玩家人数
	dataTable["UserCount"] = tonumber(nMBaseMessage:readInt());
	Common.log("read8061002c UserCount " .. dataTable["UserCount"])
	--Coins	Long	游戏分享累计获得金币总量
	dataTable["Coins"] = tonumber(nMBaseMessage:readLong());
	Common.log("read8061002c Coins " .. dataTable["Coins"])
	return dataTable
end

-- [[宝盒V4新手预读奖励]]--
function read8061002d(nMBaseMessage)
	Common.log("read8061002d 应答宝盒V4新手预读奖励")
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD;
	dataTable["messageName"] = "OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD";

	--可领奖个数
	dataTable["count"]  = nMBaseMessage:readShort();
	Common.log("宝盒V4新手预读奖励 可领奖个数 ==" .. dataTable["count"]);
	--奖励物品的列表
	dataTable["Treasure"] = {};
	--奖励物品个数
	local cnt = tonumber(nMBaseMessage:readInt());
	for i=1 , cnt do
		dataTable["Treasure"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();

		--物品图片url
		dataTable["Treasure"][i]["TreasurePicUrl"] = nMBaseMessage:readString();
		--物品描述
		dataTable["Treasure"][i]["TreasureDiscription"] = nMBaseMessage:readString();
		--奖品倍数
		dataTable["Treasure"][i]["Multiple"] = tonumber(nMBaseMessage:readInt());
		--最终奖品数目
		dataTable["Treasure"][i]["LastTreasureCount"] = tonumber(nMBaseMessage:readInt());

		--Common.log("宝盒V4新手预读奖励 物品图片url ==" .. dataTable["Treasure"][i]["TreasurePicUrl"]);
		--Common.log("宝盒V4新手预读奖励 物品描述 ==" .. dataTable["Treasure"][i]["TreasureDiscription"]);
		--Common.log("宝盒V4新手预读奖励 奖品倍数 ==" .. dataTable["Treasure"][i]["Multiple"]);
		--Common.log("宝盒V4新手预读奖励 最终奖品数目 ==" .. dataTable["Treasure"][i]["LastTreasureCount"]);
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--[[-- 大厅红点]]
function read80070076(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_REQUEST_REDP;
	dataTable["messageName"] = "MANAGERID_REQUEST_REDP";
	--消息体长度
	local count =  tonumber(nMBaseMessage:readInt());
	Common.log(count.."STC COUNT")
	dataTable["count"] = count
	for i = 1, count do
		dataTable[i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		dataTable[i]["RedPointId"]= tonumber(nMBaseMessage:readInt());
		Common.log("read80070076  RedPointId = " .. dataTable[i]["RedPointId"])
		dataTable[i]["isRed"] = nMBaseMessage:readString()
		Common.log("read80070076  isRed = " .. dataTable[i]["isRed"])
		nMBaseMessage:setReadPos(pos + length)
	end
	Common.log("read80070076countmac")
	return dataTable
end

--[[-- 大厅红点]]
function read80070078(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_PUSH_REDP;
	dataTable["messageName"] = "MANAGERID_PUSH_REDP";
	--小红点ID	公共模块
	dataTable["RedPointId"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80070078 RedPointId ==" .. dataTable["RedPointId"]);
	--新增小红点子项ID	例如活动ID，礼包ID，等
	dataTable["RedPointItemId"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80070078 RedPointItemId ==" .. dataTable["RedPointItemId"]);

	return dataTable
end

--[[--
--VIP(大厅)提示信息
--]]
function read8007007a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VIPV2_TIP_INFO
	dataTable["messageName"] = "MANAGERID_VIPV2_TIP_INFO"
	--	VipLevel	Int	vip等级	当用户由vipn(n>0)变为vip0时，此数值传负数，相应的数值为变为vip0时上一级vip
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	Common.log("qaz...read8007007a VipLevel ==" .. dataTable["VipLevel"]);
	--Status	Byte	状态信息	1：开通2：优惠 3：续费 4:空白
	dataTable["Status"] = nMBaseMessage:readByte()
	--RMB	Int	充值引导金额	当Status为2或1时此数值为礼包金额，当Status为3时传相应的充值引导金额，当Status为4时为0
	dataTable["RMB"] = tonumber(nMBaseMessage:readInt());
	Common.log("qaz...接收回来")
	return dataTable
end

--[[--
--VIP(大厅)获取vip开通礼包
--]]
function read8007007b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_VIPV2_GET_GIFTBAG
	dataTable["messageName"] = "MANAGERID_VIPV2_GET_GIFTBAG"
	--	请求结果
	dataTable["Result"] = nMBaseMessage:readByte()
	--	请求结果失败说明
	dataTable["ResultText"] = nMBaseMessage:readString()
	return dataTable
end
function read80070077(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + MANAGERID_REMOVE_REDP;
	dataTable["messageName"] = "MANAGERID_REMOVE_REDP";
	--消息体长度

	return dataTable

end

--[[--
--应答分享V2分享下载地址预读
--]]
function read8061002f(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL;
	dataTable["messageName"] = "OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL";
	--游戏分享地址
	dataTable["DownLoadURL"] = nMBaseMessage:readString();
	--Common.log("read8061002f DownLoadURL === " .. dataTable["DownLoadURL"]);

	return dataTable;
end

--[[--
--应答分享V2 IOS是否可以填写好友ID
--]]
function read80610030(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND;
	dataTable["messageName"] = "OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND";
	--状态码 1显示可用 2显示不可用 3不显示
	dataTable["State"] = nMBaseMessage:readByte();
	--Common.log("read80610030 State === " .. dataTable["State"]);
	--Msg 当为不可用时的原因
	dataTable["Msg"] = nMBaseMessage:readString();
	--Common.log("read80610030 Msg === " .. dataTable["Msg"]);

	return dataTable;
end

--[[--
--应答分享V2 IOS绑定好友关系
--]]
function read80610031(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND;
	dataTable["messageName"] = "OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND";
	--状态码 1成功 2失败
	dataTable["State"] = nMBaseMessage:readByte();
	--Common.log("read80610031 State === " .. dataTable["State"]);
	--Msg 失败或成功的提示语
	dataTable["Msg"] = nMBaseMessage:readString();
	--Common.log("read80610031 Msg === " .. dataTable["Msg"]);
	--奖品数量
	local cnt = tonumber(nMBaseMessage:readInt());
	--Common.log("read80610031 cnt === " .. cnt);
	dataTable["Prize"] = {};
	for i = 1, cnt do
		dataTable["Prize"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--奖品URL
		dataTable["Prize"][i]["PrizeUrl"] = nMBaseMessage:readString();
		--Common.log("read80610031 PrizeUrl ==".. i ..  "= " .. dataTable["Prize"][i]["PrizeUrl"]);
		--奖品描述
		dataTable["Prize"][i]["PrizeDes"] = nMBaseMessage:readString();
		--Common.log("read80610031 PrizeUrl ==".. i ..  "= " .. dataTable["Prize"][i]["PrizeDes"]);
		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable;
end

--[[--
--XY平台新用户礼包兑换
--]]
function read8061002e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_XYPLATFORM_GIFTBAG_EXCHANGE;
	dataTable["messageName"] = "OPERID_XYPLATFORM_GIFTBAG_EXCHANGE";
	--	兑换结果 1 成功 2 失败
	dataTable["Result"] = nMBaseMessage:readByte();
	--	成功或失败的提示语
	dataTable["Msg"] = nMBaseMessage:readString();
	--	奖品数量 失败时为0
	local Cnt = tonumber(nMBaseMessage:readInt());
	dataTable["Prize"] = {};
	for i = 1, Cnt do
		dataTable["Prize"][i] = {};
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品图片URL
		dataTable["Prize"][i]["PrizeUrl"]= nMBaseMessage:readString();
		--奖品描述
		dataTable["Prize"][i]["PrizeDes"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length);
	end

	return dataTable
end

--[[--
--分享奖励说明
--]]
function read80610032(nMBaseMessage)
	Common.log("read80610032 应答分享奖励说明");
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_REWARD_DESCRIPTION;
	dataTable["messageName"] = "OPERID_SHARING_REWARD_DESCRIPTION";
	--	分享给好友可得的金币数
	dataTable["SharingReceivedCoin"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80610032 == SharingReceivedCoin == "..dataTable["SharingReceivedCoin"]);
	--成功邀请好友，玩家得到的金币数
	dataTable["InviteSuccesCoin"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80610032 == InviteSuccesCoin == "..dataTable["InviteSuccesCoin"]);
	--好友充值，玩家所得的佣金比例
	dataTable["CommissionRate"] = tonumber(nMBaseMessage:readInt());
	--Common.log("read80610032 == CommissionRate == "..dataTable["CommissionRate"]);

	return dataTable
end

------------------------------------------------------------------
--[[---------------------病毒传播-------------------------- ]]
------------------------------------------------------------------

--[[--
--请求红包分享V3基本信息
--]]
function read80610033(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_V3_BASE_INFO
	dataTable["messageName"] = "OPERID_SHARING_V3_BASE_INFO"

	--minLimitCoin Int 最少金币数 少于最小金币时，返回首页弹红包
	dataTable["MinLimitCoin"] =  tonumber(nMBaseMessage:readInt());
	--RedPackageOpenFlag  Byte  1是红包功能打开，2是不打开
	dataTable["RedPackageOpenFlag"] =  nMBaseMessage:readByte();
	--OldRewardText  Text  老玩家分享奖励文本
	dataTable["OldRewardText"] =  nMBaseMessage:readString();
	--OldRewardQuitText  Text  老玩家分享奖励退出文本
	dataTable["OldRewardQuitText"] =  nMBaseMessage:readString();
	--NewRewardText  Text  新玩家分享奖励文本
	dataTable["NewRewardText"] =  nMBaseMessage:readString();
	--BindOpenFlag  Byte  1是能打开，2是不打开
	dataTable["BindOpenFlag"] =  nMBaseMessage:readByte();
	return dataTable
end

--[[--
--新玩家首次领取红包V3奖励
--]]
function read80610034(nMBaseMessage)
	Common.log("fly============B用户首次领奖2")
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD
	dataTable["messageName"] = "OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD"
	--Result  byte  1是可以，2不可以
	dataTable["Result"] =  nMBaseMessage:readByte();
	local Cnt = tonumber(nMBaseMessage:readInt());
	dataTable["RewardLoop"] = {};
	for i = 1, Cnt do
		dataTable["RewardLoop"][i] = {};
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品图片URL
		dataTable["RewardLoop"][i]["PrizeUrl"]= nMBaseMessage:readString();
		--奖品描述
		dataTable["RewardLoop"][i]["PrizeDes"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length);
	end
	return dataTable
end

--[[--
--红包V3新玩家首次分享
--]]
function read80610035(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD
	dataTable["messageName"] = "OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD"
	--Result byte  1是可以，2不可以 确保不会多次发奖
	dataTable["Result"] =  nMBaseMessage:readByte();
	local Cnt = tonumber(nMBaseMessage:readInt());
	dataTable["RewardLoop"] = {};
	for i = 1, Cnt do
		dataTable["RewardLoop"][i] = {};
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--奖品图片URL
		dataTable["RewardLoop"][i]["PrizeUrl"]= nMBaseMessage:readString();
		--奖品描述
		dataTable["RewardLoop"][i]["PrizeDes"] = nMBaseMessage:readString();
		nMBaseMessage:setReadPos(pos + length);
	end
	return dataTable
end

-- [[新手引导开关]]--
function read80650015(nMBaseMessage)
	--ModuleList 模块table
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_GET_NEWUSERGUIDE_IS_OPEN;
	dataTable["messageName"] = "COMMONS_GET_NEWUSERGUIDE_IS_OPEN";
	dataTable["isOpen"] = nMBaseMessage:readByte();
	Common.log("read80650015"..dataTable["isOpen"])
	return dataTable
end

--  扎金花新手引导详情消息
function read8007006a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_JINHUA_USER_GUIDE_INFO
	dataTable["messageName"] = "MANAGERID_GET_JINHUA_USER_GUIDE_INFO"

	dataTable["Complete"] = nMBaseMessage:readByte()
	Common.log("Complete==="..dataTable["Complete"])
	return dataTable
end

--  扎金花领取新手引导奖励(MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE)
function read8007006b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE
	dataTable["messageName"] = "MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE"

	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("Result==="..dataTable["Result"])
	dataTable["ResultText"] = nMBaseMessage:readString()
	Common.log("ResultText==="..dataTable["ResultText"])
	dataTable["UserPrize"] = {}
	local PrizeCnt = tonumber(nMBaseMessage:readInt());
	Common.log("PrizeCnt==============="..PrizeCnt)
	for i = 1, PrizeCnt do
		dataTable["UserPrize"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…PrizeUrl Text    奖品图片url
		dataTable["UserPrize"][i].PrizeUrl = nMBaseMessage:readString()
		Common.log("dataTable.PrizeUrl==="..dataTable["UserPrize"][i].PrizeUrl)
		--…PrizeDesc    Text    奖品描述
		dataTable["UserPrize"][i].PrizeDesc = nMBaseMessage:readString()
		Common.log("dataTable.PrizeDesc==="..dataTable["UserPrize"][i].PrizeDesc)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end


--3.20扎金花签到新版 (JINHUA_MGR_SIGN_V2）
function read80680014(nMBaseMessage)
	Common.log("read80680014 3.20扎金花签到新版")
	local dataTable = {}
	dataTable["messageType"] = ACK + JINHUA_MGR_SIGN_V2
	dataTable["messageName"] = "JINHUA_MGR_SIGN_V2"

	--RecordList	LoopMsg		Loop中第一条数据为今日签到，
	dataTable["RecordList"] = {}
	local RecordListCnt = tonumber(nMBaseMessage:readInt());
	--  Common.log("read80680014 RecordListCnt==============="..RecordListCnt)
	for i = 1, RecordListCnt do
		dataTable["RecordList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…day	Int	第几天
		dataTable["RecordList"][i].days = tonumber(nMBaseMessage:readInt());
		--    Common.log("read80680014 days ==="..dataTable["RecordList"][i].days)
		--…baseCoin	Int	奖励金币数
		dataTable["RecordList"][i].rewardCoin = tonumber(nMBaseMessage:readInt());
		--    Common.log("read80680014 rewardCoin ==="..dataTable["RecordList"][i].rewardCoin)
		nMBaseMessage:setReadPos(pos + length)
	end
	--userDay	Int	用户当前第几天
	dataTable["userDay"] = tonumber(nMBaseMessage:readInt());
	--  Common.log("read80680014 userDay ==="..dataTable["userDay"])
	--IsFirstRecharge	Byte	是否弹首充礼包
	dataTable["IsFirstRecharge"] = nMBaseMessage:readByte()
	--  Common.log("read80680014 IsFirstRecharge ==="..dataTable["IsFirstRecharge"])
	return dataTable
end

--3.11购买金花VIP (JINHUA_MGR_BUY_VIP)
function read8068000b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + JINHUA_MGR_BUY_VIP
	dataTable["messageName"] = "JINHUA_MGR_BUY_VIP"
	--result	Byte	是否成功	1是，0不是
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read8007000b Result==============="..dataTable["Result"])
	--Message	String	消息
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read8007000b Message==============="..dataTable["Message"])
	return dataTable
end

-- 4.2斗牛签到面板
function read806e0002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_OPEN_SIGN
	dataTable["messageName"] = "DOUNIU_MGR_OPEN_SIGN"

	--Day	Int	第几天签到
	dataTable["Day"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0002 Day==============="..dataTable["Day"])
	-- DayCoin	Int	连续签到可领取的金币
	dataTable["DayCoin"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0002 连续签到可领取的金币 DayCoin==============="..dataTable["DayCoin"])
	--level	int	斗牛级别
	dataTable["level"] = tonumber(nMBaseMessage:readInt());
	--LevelCoin	int	斗牛级别可以领取的金币
	dataTable["LevelCoin"] = tonumber(nMBaseMessage:readInt());
	--vipLevel	int	斗牛Vip级别
	dataTable["vipLevel"] = tonumber(nMBaseMessage:readInt());
	--vipLevelCoin	int	斗牛Vip级别可以领取的金币
	dataTable["vipLevelCoin"] = tonumber(nMBaseMessage:readInt());
	--sumCoin	int	一共可以领取的金币
	dataTable["sumCoin"] = tonumber(nMBaseMessage:readInt());
	--tomorrowCoin	int	明天一共可以领取的金币
	dataTable["tomorrowCoin"] = tonumber(nMBaseMessage:readInt());
	--arenaRank	int	竞技场排名
	dataTable["arenaRank"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0002 竞技场排名 arenaRank==============="..dataTable["arenaRank"])
	--arenaRankCoin	Int	竞技场排名可以领取的金币
	dataTable["arenaRankCoin"] = tonumber(nMBaseMessage:readInt());
	--monthCardType	Int	月卡奖励是否已领取	-1=没有卡，1=周卡，2=月卡，3=年卡
	dataTable["monthCardType"] = tonumber(nMBaseMessage:readInt());
	--monthCardCoin	int	月卡每日可以领取的金币
	dataTable["monthCardCoin"] = tonumber(nMBaseMessage:readInt());
	--monthCardCoinIsGet	Byte	月卡奖励是否已领取	0=未领取，1=已领取
	dataTable["monthCardCoinIsGet"] = nMBaseMessage:readByte();
	--monthCardExpire	Byte	月卡到期提醒	0=不提醒，1=提醒
	dataTable["monthCardExpire"] = nMBaseMessage:readByte();

	return dataTable
end

-- 4.3斗牛签到
function read806e0003(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_SIGN
	dataTable["messageName"] = "DOUNIU_MGR_SIGN"

	--result	Byte	是否成功	0失败1成功
	dataTable["result"] = nMBaseMessage:readByte()
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()

	return dataTable
end

--4.6 请求破产送金信息(DOUNIU_MGR_REVIVE_INFO)
function read806e0006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_REVIVE_INFO
	dataTable["messageName"] = "DOUNIU_MGR_REVIVE_INFO"

	--hasRelive	Byte	是否有破产礼包
	dataTable["hasRelive"] = nMBaseMessage:readByte()
	Common.log("read806e0006 hasRelive==="..dataTable["hasRelive"])
	--Time	Long	礼包领取剩余时间	如果为0则可以马上领取
	dataTable["Time"] = tonumber(nMBaseMessage:readLong())
	Common.log("read806e0006 Time==="..dataTable["Time"])
	return dataTable
end

--4.7 领取破产送金 (DOUNIU_MGR_REVIVE)
function read806e0007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_REVIVE
	dataTable["messageName"] = "DOUNIU_MGR_REVIVE"

	--hasRelive	Byte	是否有破产礼包
	dataTable["Coin"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0007 Coin==="..dataTable["Coin"])
	return dataTable
end

--4.8背包(DOUNIU_MGR_BACKPACK_ITEMS）
function read806e0008(nMBaseMessage)
	Common.log("read806e0008 背包")
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BACKPACK_ITEMS
	dataTable["messageName"] = "DOUNIU_MGR_BACKPACK_ITEMS"

	dataTable["BackpackList"] = {}
	--backpackList	Loop	背包列表
	local BackpackListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0008 BackpackListCnt==============="..BackpackListCnt)
	for i = 1, BackpackListCnt do
		dataTable["BackpackList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…itemId	Int	Id
		dataTable["BackpackList"][i].itemId = tonumber(nMBaseMessage:readInt());
		Common.log("read806e0008 dataTable.BackpackList itemId ==="..dataTable["BackpackList"][i].itemId)
		--…title	Text	标题
		dataTable["BackpackList"][i].title = nMBaseMessage:readString()
		Common.log("read806e0008 dataTable.BackpackList title ==="..dataTable["BackpackList"][i].title)
		--…picUrl	Text	图片路径
		dataTable["BackpackList"][i].picUrl = nMBaseMessage:readString()
		Common.log("read806e0008 dataTable.BackpackList picUrl ==="..dataTable["BackpackList"][i].picUrl)
		--…desc	Text	描述文字
		dataTable["BackpackList"][i].desc = nMBaseMessage:readString()
		Common.log("read806e0008 dataTable.BackpackList desc ==="..dataTable["BackpackList"][i].desc)
		--…count	Int	用户拥有数量
		dataTable["BackpackList"][i].count = tonumber(nMBaseMessage:readInt());
		Common.log("read806e0008 dataTable.BackpackList count ==="..dataTable["BackpackList"][i].count)
		--isuse	Byte	是否可以使用	0不可使用1可以使用
		dataTable["BackpackList"][i].isuse = nMBaseMessage:readByte();
		Common.log("read806e0008 dataTable.BackpackList isuse ==="..dataTable["BackpackList"][i].isuse)
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--4.9使用背包物品(DOUNIU_USE_GIFT）
function read806e0009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_USE_GIFT
	dataTable["messageName"] = "DOUNIU_USE_GIFT"
	--Result	Byte	结果	1成功2不成功
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e0009 Result==============="..dataTable["Result"])
	--Giftid	byte	Giftid
	dataTable["Giftid"] = nMBaseMessage:readByte()
	Common.log("read806e0009 Giftid==============="..dataTable["Giftid"])
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()
	Common.log("read806e0009 Msg==============="..dataTable["Msg"])

	return dataTable
end

--4.10斗牛排行榜（DOUNIU_RANKLIST）
function read806e000a(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + DOUNIU_RANKLIST
	dataTable["messageName"] = "DOUNIU_RANKLIST"

	--Type	Byte	排行榜类型	1=每日赚金榜，2=财富总榜，3=每日充值榜
	dataTable["Type"] = nMBaseMessage:readByte()
	Common.log("read806e000a Type ==== " .. dataTable["Type"])
	--rankNum	Int	我的名次
	dataTable["rankNum"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000a rankNum ==== " .. dataTable["rankNum"])
	--photoUrl	Text	我的头像Url
	dataTable["photoUrl"] = nMBaseMessage:readString()
	Common.log("read806e000a photoUrl ==== " .. dataTable["photoUrl"])
	--nickName	Text	我的昵称
	dataTable["nickName"] = nMBaseMessage:readString()
	Common.log("read806e000a nickName ==== " .. dataTable["nickName"])
	--vipLevel	Int	我的vip等级
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000a VipLevel ==== " .. dataTable["VipLevel"])
	--rankingData	Text	我的排行榜类型值
	dataTable["rankingData"] = nMBaseMessage:readString()
	--rankChange	Byte	我的排名变化	下降0 不变1 上升2
	dataTable["rankChange"] = nMBaseMessage:readByte()
	Common.log("read806e000a rankChange ==== " .. dataTable["rankChange"])

	--RankList	Loop	列表	前100名
	dataTable["RankList"] = {}
	local RankListSize = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000a == RankListSize === "..RankListSize)
	for i = 1, RankListSize do
		dataTable["RankList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……userId	Int	用户ID
		dataTable["RankList"][i].userId = tonumber(nMBaseMessage:readInt());
		Common.log("read806e000a ==RankList userId=== "..dataTable["RankList"][i].userId)
		--…rankNum	Int	名次
		dataTable["RankList"][i].rankNum = tonumber(nMBaseMessage:readInt());
		--		Common.log("read806e000a ==RankList rankNum=== "..dataTable["RankList"][i].rankNum)
		--…photoUrl	Text	头像URL
		dataTable["RankList"][i].photoUrl = nMBaseMessage:readString()
		--		Common.log("read806e000a ==RankList photoUrl=== "..dataTable["RankList"][i].photoUrl)
		--…nickName	Text	用户昵称
		dataTable["RankList"][i].nickName = nMBaseMessage:readString()
		--		Common.log("read806e000a ==RankList nickName=== "..dataTable["RankList"][i].nickName)
		--…vipLevel	Int	Vip级别
		dataTable["RankList"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		--		Common.log("read806e000a ==RankList vipLevel=== "..dataTable["RankList"][i].vipLevel)
		--…rankingData	Text	排行榜类型值
		dataTable["RankList"][i].rankingData = nMBaseMessage:readString()
		Common.log("read806e000a ==RankList rankingData=== "..dataTable["RankList"][i].rankingData)
		--…rankChangeFlag	Byte	排名变化	下降0 不变1 上升2
		dataTable["RankList"][i].rankChangeFlag = nMBaseMessage:readByte()
		--		Common.log("read806e000a ==RankList rankChangeFlag=== "..dataTable["RankList"][i].rankChangeFlag)

		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--4.35月卡面板（DOUNIU_MONTH_CARD_V2）
function read806e0023(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + DOUNIU_MONTH_CARD_V2
	dataTable["messageName"] = "DOUNIU_MONTH_CARD_V2"

	--Day	Int	月卡还有几天
	dataTable["Day"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0023 Day == "..dataTable["Day"])
	--SelfCardType	Int	自己已购买的卡类型	-1=没有卡，1=周卡，2=月卡，3=年卡
	dataTable["SelfCardType"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0023 SelfCardType == "..dataTable["SelfCardType"])

	--CardList	Loop	所有类型的卡
	dataTable["CardList"] = {}
	local CardListSize = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0023 == CardListSize === "..CardListSize)
	for i = 1, CardListSize do
		dataTable["CardList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……CardType	Int	卡类型	-1=没有卡，1=周卡，2=月卡，3=年卡
		dataTable["CardList"][i].CardType = tonumber(nMBaseMessage:readInt());
		Common.log("read806e0023 ==CardList CardType=== "..dataTable["CardList"][i].CardType)
		--…CardGiftPrice	Int	礼包价格	元
		dataTable["CardList"][i].CardGiftPrice = tonumber(nMBaseMessage:readInt());
		--		Common.log("read806e0023 ==CardList CardGiftPrice=== "..dataTable["CardList"][i].CardGiftPrice)
		--…ImmediatelyCoin	Text	购买后立即获得的金币
		dataTable["CardList"][i].ImmediatelyCoin = nMBaseMessage:readString()
		--		Common.log("read806e0023 ==CardList ImmediatelyCoin=== "..dataTable["CardList"][i].ImmediatelyCoin)
		--…DayCoin	Text	购买后每天获得的金币
		dataTable["CardList"][i].DayCoin = nMBaseMessage:readString()
		--		Common.log("read806e0023 ==CardList DayCoin=== "..dataTable["CardList"][i].DayCoin)
		--…GiveCoin	Text	加赠的金币
		dataTable["CardList"][i].GiveCoin = nMBaseMessage:readString();
		--		Common.log("read806e0023 ==CardList GiveCoin=== "..dataTable["CardList"][i].GiveCoin)
		--…DiscountPicUrl	Text	折扣图片url
		dataTable["CardList"][i].DiscountPicUrl = nMBaseMessage:readString()
		Common.log("read806e0023 ==CardList DiscountPicUrl=== "..dataTable["CardList"][i].DiscountPicUrl)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--4.12 VIP特权（DOUNIU_VIPINFO）
function read806e000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_VIPINFO
	dataTable["messageName"] = "DOUNIU_VIPINFO"

	--CurrentRecharge	int	已充值金额
	dataTable["CurrentRecharge"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000c CurrentRecharge==============="..dataTable["CurrentRecharge"])
	--nextLevelRecharge	int	升到下一级所需金额
	dataTable["nextLevelRecharge"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000c nextLevelRecharge==============="..dataTable["nextLevelRecharge"])
	--CurrentDesc	int	当前vip级别特权介绍
	dataTable["CurrentDesc"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000c CurrentDesc==============="..dataTable["CurrentDesc"])

	--Descs 	Loop	总共有多少vip级别特权介绍	一共有多少级特权
	dataTable["Descs"] = {}
	local DescsSize = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000c == DescsSize === "..DescsSize)
	for i = 1, DescsSize do
		dataTable["Descs"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…desUrl	Text	vip级别特权介绍URL	全url
		dataTable["Descs"][i].desUrl = nMBaseMessage:readString();
		Common.log("read806e000c ==Descs desUrl=== "..dataTable["Descs"][i].desUrl)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--4.13斗牛充值返利相关信息  (RECHARGE_REBATE_INFO）
function read806e000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + RECHARGE_REBATE_INFO
	dataTable["messageName"] = "RECHARGE_REBATE_INFO"

	--IsFirstRecharge	Byte	是否为首充翻倍	1:是 0不是
	dataTable["IsFirstRecharge"] = nMBaseMessage:readByte()
	Common.log("read806e000d IsFirstRecharge==============="..dataTable["IsFirstRecharge"])
	--VipAddingPercent	int	玩家当前VIP的加送百分比
	dataTable["VipAddingPercent"] = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000d VipAddingPercent==============="..dataTable["VipAddingPercent"])
	return dataTable
end


--4.15好友列表 (DOUNIU_MGR_FRIEND_LIST）
function read806e000f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_FRIEND_LIST
	dataTable["messageName"] = "DOUNIU_MGR_FRIEND_LIST"

	--UpLimit	Int	好友上限
	dataTable["UpLimit"] = tonumber(nMBaseMessage:readInt());
	--FriendList	LoopMsg		游戏内加好友列表
	dataTable["FriendList"] = {}
	local FriendListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e000f FriendListCnt==============="..FriendListCnt)
	for i = 1, FriendListCnt do
		dataTable["FriendList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…userID	Int
		dataTable["FriendList"][i].userID = tonumber(nMBaseMessage:readInt());
		Common.log("read806e000f dataTable.FriendList userID ==="..dataTable["FriendList"][i].userID)
		--…isZS	Byte	是否是正式好友	0=否（待同意），1=是
		dataTable["FriendList"][i].isZS = nMBaseMessage:readByte();
		--…name	String	昵称
		dataTable["FriendList"][i].name = nMBaseMessage:readString()
		Common.log("read806e000f dataTable.FriendList name ==="..dataTable["FriendList"][i].name)
		--…coin	long	用户金币
		dataTable["FriendList"][i].coin = tonumber(nMBaseMessage:readLong());
		Common.log("read806e000f dataTable.FriendList coin ==="..dataTable["FriendList"][i].coin)
		--…vipLevel	Int	好友VIP等级
		dataTable["FriendList"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		--…level	Int	好友等级
		dataTable["FriendList"][i].level = tonumber(nMBaseMessage:readInt());
		Common.log("read806e000f dataTable.FriendList level ==="..dataTable["FriendList"][i].level)
		--…photoUrl	String	头像
		dataTable["FriendList"][i].photoUrl = nMBaseMessage:readString()
		--Common.log("read806e000f dataTable.FriendList photoUrl ==="..dataTable["FriendList"][i].photoUrl)
		--meetGift	String	送的见面礼	图片url
		dataTable["FriendList"][i].meetGift = nMBaseMessage:readString()
		Common.log("read806e000f dataTable.FriendList meetGift ==="..dataTable["FriendList"][i].meetGift)
		--daySendCoin	Long	每日送给我的金币
		dataTable["FriendList"][i].daySendCoin = tonumber(nMBaseMessage:readLong());
		Common.log("read806e000f dataTable.FriendList daySendCoin ==="..dataTable["FriendList"][i].daySendCoin)
		--isGetDayCoin	Byte	我是否领取了每日送给我的金币	0=否，1=是
		dataTable["FriendList"][i].isGetDayCoin = nMBaseMessage:readByte();
		Common.log("read806e000f dataTable.FriendList isGetDayCoin ==="..dataTable["FriendList"][i].isGetDayCoin)
		--…conversationID	Int	回话ID
		dataTable["FriendList"][i].conversationID = tonumber(nMBaseMessage:readInt());
		Common.log("read806e000f dataTable.FriendList conversationID ==="..dataTable["FriendList"][i].conversationID)
		--…unreadcnt	Int	会话中未读邮件数量
		dataTable["FriendList"][i].unreadcnt = tonumber(nMBaseMessage:readInt());
		Common.log("read806e000f dataTable.FriendList unreadcnt ==="..dataTable["FriendList"][i].unreadcnt)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--4.16好友领取每日送金 (DOUNIU_MGR_GET_FRIEND_COIN）
function read806e0010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_GET_FRIEND_COIN
	dataTable["messageName"] = "DOUNIU_MGR_GET_FRIEND_COIN"
	--Result	Byte	结果	1成功2不成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString();

	return dataTable
end


--2.122添加好友 (DOUNIU_ADD_FRIEND）
function read8022007a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_ADD_FRIEND
	dataTable["messageName"] = "DOUNIU_ADD_FRIEND"

	--Result	Byte	结果	0失败，1成功，2好友达到上限,3已经是好友
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read8022007a Result==="..dataTable["Result"])
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

--4.17添加好友
function read806e0011(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_ADD_FRIEND
	dataTable["messageName"] = "DOUNIU_MGR_ADD_FRIEND"

	--Result	Byte	结果	0失败，1成功，2好友达到上限,3已经是好友
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read8022007a Result==="..dataTable["Result"])
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

--4.18删除好友 (DOUNIU_MGR_DEL_FRIEND）
function read806e0012(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_DEL_FRIEND
	dataTable["messageName"] = "DOUNIU_MGR_DEL_FRIEND"

	--Result	Byte	0失败，1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e0012 Result==="..dataTable["Result"])
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

--4.19添加追踪 (DOUNIU_MGR_ADD_TRACE）
function read806e0013(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_ADD_TRACE
	dataTable["messageName"] = "DOUNIU_MGR_ADD_TRACE"

	--Result	Byte	0失败，1成功，2追踪达到上限,3已经是在列表
	dataTable["Result"] = nMBaseMessage:readByte()
	--Common.log("read806e0013 Result==============="..dataTable["Result"])
	--Msg	Text	提示文字
	dataTable["Msg"] = nMBaseMessage:readString()
	--Common.log("read806e0013 Msg==============="..dataTable["Msg"])

	return dataTable
end

--4.20删除追踪 (DOUNIU_MGR_DEL_TRACE）
function read806e0014(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_DEL_TRACE
	dataTable["messageName"] = "DOUNIU_MGR_DEL_TRACE"

	--Result	Byte	1成功，2失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e0014 Result==============="..dataTable["Result"])
	--Msg	Text	提示文字
	dataTable["Msg"] = nMBaseMessage:readString()
	Common.log("read806e0014 Msg==============="..dataTable["Msg"])

	return dataTable
end

--4.22追踪列表 (DOUNIU_MGR_TRACE_LIST）
function read806e0016(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_TRACE_LIST
	dataTable["messageName"] = "DOUNIU_MGR_TRACE_LIST"

	--TraceList	LoopMsg		追踪好友列表
	dataTable["TraceList"] = {}
	local TraceListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0016 TraceListCnt==============="..TraceListCnt)
	for i = 1, TraceListCnt do
		dataTable["TraceList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…userID	Int
		dataTable["TraceList"][i].userID = tonumber(nMBaseMessage:readInt());
		--Common.log("read806e0016 dataTable.TraceList userID ==="..dataTable["TraceList"][i].userID)
		--…name	Text	昵称
		dataTable["TraceList"][i].name = nMBaseMessage:readString()
		--Common.log("read806e0016 dataTable.TraceList name ==="..dataTable["TraceList"][i].name)
		--…coin	long	用户金币
		dataTable["TraceList"][i].coin = tonumber(nMBaseMessage:readLong());
		--Common.log("read806e0016 dataTable.TraceList coin ==="..dataTable["TraceList"][i].coin)
		--…level	Int	好友等级
		dataTable["TraceList"][i].level = tonumber(nMBaseMessage:readInt());
		--Common.log("read806e0016 dataTable.TraceList level ==="..dataTable["TraceList"][i].level)
		--…photoUrl	String	头像
		dataTable["TraceList"][i].photoUrl = nMBaseMessage:readString()
		--Common.log("read806e0016 dataTable.TraceList photoUrl ==="..dataTable["TraceList"][i].photoUrl)
		--…vipLevel	Int	好友VIP等级
		dataTable["TraceList"][i].vipLevel = tonumber(nMBaseMessage:readInt());
		--loginState	Text	登录状态	在线，离线N小时，离线N天等
		dataTable["TraceList"][i].loginState = nMBaseMessage:readString()
		--Common.log("read806e0016 dataTable.TraceList meetGift ==="..dataTable["TraceList"][i].meetGift)
		--location	Text	位置，如果在线，显示在哪个场次	100=闲逛，2XX=斗牛，3XX=百牛,XX代表是哪个场次
		dataTable["TraceList"][i].location = nMBaseMessage:readString();
		--Common.log("read806e0016 dataTable.TraceList daySendCoin ==="..dataTable["TraceList"][i].daySendCoin)
		--isTrace.	Byte	是否可以追踪	1可以0不可以
		dataTable["TraceList"][i].isTrace = nMBaseMessage:readByte();
		--小游戏id	5=斗牛，8=百牛，10=金牛
		dataTable["TraceList"][i].miniGameId = tonumber(nMBaseMessage:readInt())
		--Common.log("read806e0016 dataTable.TraceList miniGameId ==="..dataTable["TraceList"][i].miniGameId)

		nMBaseMessage:setReadPos(pos + length)
	end
	--TraceMax	Int	追踪列表上限
	dataTable["TraceMax"] = tonumber(nMBaseMessage:readInt());

	return dataTable
end

--4.23同意加好友 (DOUNIU_MGR_FRIEND_AGREE）
function read806e0017(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_FRIEND_AGREE
	dataTable["messageName"] = "DOUNIU_MGR_FRIEND_AGREE"

	--Result	Byte	1成功，2失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e0017 Result==="..dataTable["Result"])
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

--4.24拒绝加好友 (DOUNIU_MGR_FRIEND_REFUSE）
function read806e0018(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_FRIEND_REFUSE
	dataTable["messageName"] = "DOUNIU_MGR_FRIEND_REFUSE"

	--Result	Byte	1成功，2失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e0018 Result==="..dataTable["Result"])
	--Msg	Text	结果文字提示
	dataTable["Msg"] = nMBaseMessage:readString()
	return dataTable
end

--4.25斗牛好友是否有红点  (DOUNIU_MGR_FRIEND_HAVE_REDP ）
function read806e0019(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_FRIEND_HAVE_REDP
	dataTable["messageName"] = "DOUNIU_MGR_FRIEND_HAVE_REDP"

	--Result	Byte	1有红点0没有红点
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e0019 Result==============="..dataTable["Result"])

	return dataTable
end

--4.26斗牛绑定手机的金币奖励
function read806e001a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BINDPHONE_REWARDS
	dataTable["messageName"] = "DOUNIU_MGR_BINDPHONE_REWARDS"

	--rewards	Long	斗牛绑定手机的金币奖励
	dataTable["rewards"] = tonumber(nMBaseMessage:readLong());
	--	Common.log("read806e001a 斗牛绑定手机的金币奖励==============="..dataTable["rewards"])

	return dataTable
end

--自建房间数据
function read806e001b(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BUILD_TABLE_INFO
	dataTable["messageName"] = "DOUNIU_MGR_BUILD_TABLE_INFO"

	--DouNiuBetList	Loop	斗牛底注设定列表
	dataTable["DouNiuBetList"] = {}
	local DouNiuBetListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e001b DouNiuBetListCnt==============="..DouNiuBetListCnt)
	for i = 1, DouNiuBetListCnt do
		dataTable["DouNiuBetList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--minCoin	Long	最小带入金币
		dataTable["DouNiuBetList"][i].minCoin = tonumber(nMBaseMessage:readLong());
		Common.log("read806e001b 最小带入金币 minCoin ==="..dataTable["DouNiuBetList"][i].minCoin)
		--...baseCoin	Long	底注
		dataTable["DouNiuBetList"][i].baseCoin = tonumber(nMBaseMessage:readLong());
		Common.log("read806e001b 底注 baseCoin ==="..dataTable["DouNiuBetList"][i].baseCoin)

		nMBaseMessage:setReadPos(pos + length)
	end
	--DouNiuTableTimeList	Loop	斗牛底注设定列表
	dataTable["DouNiuTableTimeList"] = {}
	local DouNiuTableTimeListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e001b DouNiuTableTimeListCnt==============="..DouNiuTableTimeListCnt)
	for i = 1, DouNiuTableTimeListCnt do
		dataTable["DouNiuTableTimeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--TableTime	Int	牌局时长	最小单位:分钟
		dataTable["DouNiuTableTimeList"][i].TableTime = tonumber(nMBaseMessage:readInt());
		Common.log("read806e001b 牌局时长 TableTime ==="..dataTable["DouNiuTableTimeList"][i].TableTime)

		nMBaseMessage:setReadPos(pos + length)
	end
	--DouNiuTableCost	Int	斗牛组桌费系数	公式为：底注*时长*2
	dataTable["DouNiuTableCost"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001b 斗牛组桌费系数==============="..dataTable["DouNiuTableCost"])

	--JinNiuBetList	Loop	斗牛底注设定列表
	dataTable["JinNiuBetList"] = {}
	local JinNiuBetListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e001b JinNiuBetListCnt==============="..JinNiuBetListCnt)
	for i = 1, JinNiuBetListCnt do
		dataTable["JinNiuBetList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--minCoin	Long	最小带入金币
		dataTable["JinNiuBetList"][i].minCoin = tonumber(nMBaseMessage:readLong());
		Common.log("read806e001b 最小带入金币 minCoin ==="..dataTable["JinNiuBetList"][i].minCoin)
		--...baseCoin	Long	底注
		dataTable["JinNiuBetList"][i].baseCoin = tonumber(nMBaseMessage:readLong());
		Common.log("read806e001b 底注 baseCoin ==="..dataTable["JinNiuBetList"][i].baseCoin)

		nMBaseMessage:setReadPos(pos + length)
	end
	--JinNiuTableTimeList	Loop	斗牛底注设定列表
	dataTable["JinNiuTableTimeList"] = {}
	local JinNiuTableTimeListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e001b JinNiuTableTimeListCnt==============="..JinNiuTableTimeListCnt)
	for i = 1, JinNiuTableTimeListCnt do
		dataTable["JinNiuTableTimeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--TableTime	Int	牌局时长	最小单位:分钟
		dataTable["JinNiuTableTimeList"][i].TableTime = tonumber(nMBaseMessage:readInt());
		Common.log("read806e001b 牌局时长 TableTime ==="..dataTable["JinNiuTableTimeList"][i].TableTime)

		nMBaseMessage:setReadPos(pos + length)
	end
	--JinNiuTableCost	Int	金牛组桌费系数	公式为：底注*时长*2
	dataTable["JinNiuTableCost"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001b 金牛组桌费系数==============="..dataTable["JinNiuTableCost"])

	--SelfCharm	Int	我的魅力值
	dataTable["SelfCharm"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001b 我的魅力值==============="..dataTable["SelfCharm"])
	--CountDownTimeStamp	Long	续桌结束的时间戳	非续桌传-1
	dataTable["CountDownTimeStamp"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001b 续桌结束的时间戳==============="..dataTable["CountDownTimeStamp"])

	return dataTable
end

--创建房间
function read806e001c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BUILD_TABLE
	dataTable["messageName"] = "DOUNIU_MGR_BUILD_TABLE"

	--Result	Byte	是否成功	0失败1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e001c 是否成功	0失败1成功==============="..dataTable["Result"])
	--RoomCode	Int	房间邀请码
	dataTable["RoomCode"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001c 房间邀请码==============="..dataTable["RoomCode"])
	--ResultTxt	Text	回复消息	String
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	Common.log("read806e001c 回复消息==============="..dataTable["ResultTxt"])

	return dataTable
end

--进入自建房
function read806e001d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_ENTER_BUILD_TABLE
	dataTable["messageName"] = "DOUNIU_MGR_ENTER_BUILD_TABLE"

	--Result	Byte	1成功2失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read806e001d 1成功2失败 ==============="..dataTable["Result"])
	--Message	Text	提示语
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read806e001d 回复消息==============="..dataTable["Message"])

	return dataTable
end

--自建房倒计时广播
function read806e001e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BUILD_TABLE_COUNTDOWN_BROADCAST
	dataTable["messageName"] = "DOUNIU_MGR_BUILD_TABLE_COUNTDOWN_BROADCAST"

	--TableOverTime	Int	牌桌剩余时间
	dataTable["TableOverTime"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001e 牌桌剩余时间==============="..dataTable["TableOverTime"])
	--IsRoomBuilder	Byte	是否是房主	0不是 1是
	dataTable["IsRoomBuilder"] = nMBaseMessage:readByte()
	Common.log("read806e001e 是否是房主	0不是 1是==============="..dataTable["IsRoomBuilder"])

	return dataTable
end

--自建房续桌广播
function read806e001f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BUILD_TABLE_CONTINUE_BROADCAST
	dataTable["messageName"] = "DOUNIU_MGR_BUILD_TABLE_CONTINUE_BROADCAST"

	--minCoin	Long	最小带入金币
	dataTable["minCoin"] = tonumber(nMBaseMessage:readLong());
	Common.log("read806e001f 最小带入金币==============="..dataTable["minCoin"])
	--baseCoin	Long	底注
	dataTable["baseCoin"] = tonumber(nMBaseMessage:readLong());
	Common.log("read806e001f 底注==============="..dataTable["baseCoin"])
	--TableTime	Int	牌局时长	最小单位:分钟
	dataTable["TableTime"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001f 牌局时长==============="..dataTable["TableTime"])
	--RoomCode	Int	房间邀请码
	dataTable["RoomCode"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001f 房间邀请码==============="..dataTable["RoomCode"])
	--CountDownTimeStamp	Int	续桌结束的时间戳
	dataTable["CountDownTime"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e001f 续桌结束的时间戳==============="..dataTable["CountDownTime"])

	return dataTable
end

--请求有效自建房邀请码
function read806e0020(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_BUILD_TABLE_ROOMCODE
	dataTable["messageName"] = "DOUNIU_MGR_BUILD_TABLE_ROOMCODE"

	--RoomCode	Int	房间邀请码	没有传-1
	dataTable["RoomCode"] = tonumber(nMBaseMessage:readInt())
	Common.log("read806e0020 房间邀请码==============="..dataTable["RoomCode"])

	return dataTable
end

--斗牛主页活动
function read806e0022(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + DOUNIU_MGR_INDEX_ACTIVITY
	dataTable["messageName"] = "DOUNIU_MGR_INDEX_ACTIVITY"

	-- ShopList	LoopMsg
	dataTable["ActivityList"] = {}
	local ActivityListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read806e0022 ActivityListCnt==============="..ActivityListCnt)
	for i = 1, ActivityListCnt do
		dataTable["ActivityList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...type	Byte	类型	1活动，2礼包
		dataTable["ActivityList"][i].type = nMBaseMessage:readByte();
		Common.log("read806e0022 dataTable.ActivityList type ==="..dataTable["ActivityList"][i].type)
		-- ...activityId	Int	活动ID或者礼包ID	跟上面类型相关
		dataTable["ActivityList"][i].activityId = tonumber(nMBaseMessage:readInt());
		Common.log("read806e0022 dataTable.ActivityList activityId ==="..dataTable["ActivityList"][i].activityId)
		-- ...imgURL	Text	图片
		dataTable["ActivityList"][i].imgURL = nMBaseMessage:readString();
		Common.log("read806e0022 dataTable.ActivityList imgURL ==="..dataTable["ActivityList"][i].imgURL)
		-- ...otherParm	Text	其他参数	Type=3,此参数为网址url
		dataTable["ActivityList"][i].otherParm = nMBaseMessage:readString();
		Common.log("read806e0022 dataTable.ActivityList otherParm ==="..dataTable["ActivityList"][i].otherParm)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end















---------------------------------------------------
--1.4个人信息
function read80740004(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_PLAYER_INFO
	dataTable["messageName"] = "MJ_SC_MGR_PLAYER_INFO"

	-- userID	Int	用户ID
	dataTable["userID"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80740004 userID =========== "..dataTable["userID"] )
	-- nickName	Text	昵称
	dataTable["nickName"] = nMBaseMessage:readString()
	Common.log("read80740004 nickName =========== "..dataTable["nickName"] )
	-- sex	Byte	性别	1男 2女
	dataTable["sex"] = nMBaseMessage:readByte()
	Common.log("read80740004 sex =========== "..dataTable["sex"] )
	-- ip	Text	IP地址
	dataTable["ip"] = nMBaseMessage:readString()
	Common.log("read80740004 ip =========== "..dataTable["ip"] )
	-- photoUrl	Text	头像
	dataTable["photoUrl"] = nMBaseMessage:readString()
	Common.log("read80740004 photoUrl =========== "..dataTable["photoUrl"] )
	-- fangkaCnt	Int	房卡数
	dataTable["fangkaCnt"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80740004 fangkaCnt =========== "..dataTable["fangkaCnt"] )

	return dataTable
end

--1.6大厅消息—大厅广播
function read80740006(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_NOTICE
	dataTable["messageName"] = "MJ_SC_NOTICE"

	dataTable["Timestamp"] = tonumber(nMBaseMessage:readLong())
	Common.log("read80740006 Timestamp==============="..dataTable["Timestamp"])
	--RecordList	LoopMsg		Loop中第一条数据为今日签到，总领取金币=基础金币+互助金币
	dataTable["RecordList"] = {}
	local RecordListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80740006 RecordListCnt==============="..RecordListCnt)
	for i = 1, RecordListCnt do
		dataTable["RecordList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…content	Text	提示
		dataTable["RecordList"][i].content = nMBaseMessage:readString()
		Common.log("read80740006 content ==="..dataTable["RecordList"][i].content)
		--…actionId	Int	actionId（小游戏id）	如果为0，则是普通公告
		dataTable["RecordList"][i].actionId = tonumber(nMBaseMessage:readInt());
		Common.log("read80740006 actionId ==="..dataTable["RecordList"][i].actionId)
		--…status	Int	小游戏状态	1能进去，2加锁，3是金币不足
		dataTable["RecordList"][i].status = tonumber(nMBaseMessage:readInt());
		Common.log("read80740006 status ==="..dataTable["RecordList"][i].status)
		--…colorR	Int	字体色值R
		dataTable["RecordList"][i].colorR = tonumber(nMBaseMessage:readInt());
		Common.log("read80740006 colorR ==="..dataTable["RecordList"][i].colorR)
		--…colorG	Int	字体色值G
		dataTable["RecordList"][i].colorG = tonumber(nMBaseMessage:readInt());
		Common.log("read80740006 colorG ==="..dataTable["RecordList"][i].colorG)
		--…colorB	Int	字体色值B
		dataTable["RecordList"][i].colorB = tonumber(nMBaseMessage:readInt());
		Common.log("read80740006 colorB ==="..dataTable["RecordList"][i].colorB)
		nMBaseMessage:setReadPos(pos + length)
	end
	return dataTable
end

--1.7大厅消息—微信分享
function read80740007(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_SHARE_INFO
	dataTable["messageName"] = "MJ_SC_SHARE_INFO"


	-- Cdkey	Long	自己的邀请码
	dataTable["Cdkey"] = tonumber(nMBaseMessage:readLong())
	Common.log("read80740007 Cdkey ==="..dataTable["Cdkey"])
	-- sharingURL	Text	分享路径	分享路径+CDKEY是完整路径，CDKEY可以做二维码用
	dataTable["sharingURL"] = nMBaseMessage:readString()
	Common.log("read80740007 sharingURL ==="..dataTable["sharingURL"])
	-- openInputCdKey	Byte	1允许输入邀请码，2不允许输入邀请码
	dataTable["openInputCdKey"] = nMBaseMessage:readByte()
	Common.log("read80740007 openInputCdKey==============="..dataTable["openInputCdKey"])

	return dataTable
end

-- 1.8大厅基础信息
function read80740008(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_HALL_INFO
	dataTable["messageName"] = "MJ_SC_HALL_INFO"

	-- DaiLiWeiXin	Text	代理微信号
	dataTable["DaiLiWeiXin"] = nMBaseMessage:readString()
	Common.log("read80740008 DaiLiWeiXin ==="..dataTable["DaiLiWeiXin"])

	-- ShopList	LoopMsg
	dataTable["CommonWeiXinList"] = {}
	local CommonWeiXinListCnt = tonumber(nMBaseMessage:readInt());
	Common.log("read80740008 CommonWeiXinListCnt==============="..CommonWeiXinListCnt)
	for i = 1, CommonWeiXinListCnt do
		dataTable["CommonWeiXinList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...type	Byte	类型	1=微信
		dataTable["CommonWeiXinList"][i].type = nMBaseMessage:readByte();
		Common.log("read80740008 dataTable.CommonWeiXinList type ==="..dataTable["CommonWeiXinList"][i].type)
		-- ...value	Text
		dataTable["CommonWeiXinList"][i].value = nMBaseMessage:readString()
		Common.log("read80740008 dataTable.CommonWeiXinList value ==="..dataTable["CommonWeiXinList"][i].value)

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--1.9推荐好友界面
function read80740009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_RECOMMEND_INFO
	dataTable["messageName"] = "MJ_SC_RECOMMEND_INFO"


	-- friendCntMax	int	好友上限
	dataTable["friendCntMax"] = tonumber(nMBaseMessage:readInt())
	Common.log("read80740009 friendCntMax ==="..dataTable["friendCntMax"])


	dataTable["friendList"] = {}
	-- friendList	int	邀请到的好友列表
	local friendListCnt = tonumber(nMBaseMessage:readInt())
	Common.log("read80740009 friendListCnt ==="..friendListCnt)

	for i = 1, friendListCnt do
		dataTable["friendList"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()


		-- ...userID	int	好友id
		dataTable["friendList"][i].userID = tonumber(nMBaseMessage:readInt())
		Common.log("read80740009 userID ==="..dataTable["friendList"][i].userID)
		-- ...curGames	int	当前局数
		dataTable["friendList"][i].curGames = tonumber(nMBaseMessage:readInt())
		Common.log("read80740009 curGames ==="..dataTable["friendList"][i].curGames)
		-- ...tarGames	int	目标局数
		dataTable["friendList"][i].tarGames = tonumber(nMBaseMessage:readInt())
		Common.log("read80740009 tarGames ==="..dataTable["friendList"][i].tarGames)
		-- ...isReceive	Byte	是否已领取
		dataTable["friendList"][i].isReceive = nMBaseMessage:readByte()
		Common.log("read80740009 isReceive ==="..dataTable["friendList"][i].isReceive)
		-- ...photoUrl	string
		dataTable["friendList"][i].photoUrl = nMBaseMessage:readString()
		Common.log("read80740009 photoUrl ==="..dataTable["friendList"][i].photoUrl)
		-- ...nickName	string
		dataTable["friendList"][i].nickName = nMBaseMessage:readString()
		Common.log("read80740009 nickName ==="..dataTable["friendList"][i].nickName)

		nMBaseMessage:setReadPos(pos + length)
	end


	dataTable["giftList"] = {}
	-- giftList	Int	礼包列表
	local giftListCnt = tonumber(nMBaseMessage:readInt())
	Common.log("read80740009 giftListCnt ==="..giftListCnt)

	for i = 1, giftListCnt do
		dataTable["giftList"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...tarNum	Int	触发领取的人数
		dataTable["giftList"][i].tarNum = tonumber(nMBaseMessage:readInt())
		Common.log("read80740009 tarNum ==="..dataTable["giftList"][i].tarNum)
		-- ...isReceive	Byte	是否已领取
		dataTable["giftList"][i].isReceive = nMBaseMessage:readByte()
		Common.log("read80740009 isReceive ==="..dataTable["giftList"][i].isReceive)


		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--1.10推荐好友领奖界面
function read8074000a(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_RECEIVE_REWARD
	dataTable["messageName"] = "MJ_SC_RECEIVE_REWARD"

	-- Result	Byte	0失败1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read8074000a Result ==="..dataTable["Result"])
	-- Message	String
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read8074000a Message ==="..dataTable["Message"])
	-- curRoomCardNum	int	领取后房卡的数量
	dataTable["curRoomCardNum"] = tonumber(nMBaseMessage:readInt())
	Common.log("read8074000a curRoomCardNum ==="..dataTable["curRoomCardNum"])
	-- receiveType	byte	透传
	dataTable["receiveType"] = nMBaseMessage:readByte()
	Common.log("read8074000a receiveType ==="..dataTable["receiveType"])
	-- receiveCode	Long	透传
	dataTable["receiveCode"] = tonumber(nMBaseMessage:readLong())
	Common.log("read8074000a receiveCode ==="..dataTable["receiveCode"])

	return dataTable
end

--1.12房间记录
function read8074000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_ROOM_RECORD
	dataTable["messageName"] = "MJ_SC_MGR_ROOM_RECORD"

	dataTable["infoList"] = {}
	-- infoList	Int
	local infoListCnt = tonumber(nMBaseMessage:readInt())
	Common.log("read8074000c infoListCnt ==="..infoListCnt)

	for i = 1, infoListCnt do
		dataTable["infoList"][i] = {}

		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		-- ...…RecordID	Int	房间录像记录ID	(透传)
		dataTable["infoList"][i].RecordID = tonumber(nMBaseMessage:readInt())
		Common.log("read8074000c RecordID ==="..dataTable["infoList"][i].RecordID)
		-- ...roomCode	int	房间号
		dataTable["infoList"][i].roomCode = tonumber(nMBaseMessage:readInt())
		Common.log("read8074000c roomCode ==="..dataTable["infoList"][i].roomCode)
		-- ...time	Text	时间	1999-12-22 22:32:22
		dataTable["infoList"][i].time = nMBaseMessage:readString()

		local UserCnt = tonumber(nMBaseMessage:readInt());
		Common.log("read8074000c UserCnt ==="..UserCnt)
		dataTable["infoList"][i]["userList"] = {};
		for j = 1, UserCnt do
			local length = nMBaseMessage:readShort();
			local pos = nMBaseMessage:getReadPos();

			dataTable["infoList"][i]["userList"][j] = {}
			--    ……userId	int	id
			dataTable["infoList"][i]["userList"][j].userId = tonumber(nMBaseMessage:readInt());
			--    ……nickname	Text	昵称
			dataTable["infoList"][i]["userList"][j].nickname = nMBaseMessage:readString();
			Common.log("read8074000c nickname ==="..dataTable["infoList"][i]["userList"][j].nickname)
			--    ……score	int	分数
			dataTable["infoList"][i]["userList"][j].score = tonumber(nMBaseMessage:readInt());
			Common.log("read8074000c score ==="..dataTable["infoList"][i]["userList"][j].score)

			nMBaseMessage:setReadPos(pos + length);
		end


		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--1.13牌局记录
function read8074000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_INNING_RECORD
	dataTable["messageName"] = "MJ_SC_MGR_INNING_RECORD"

	-- miniGameID	Int
	dataTable["miniGameID"] = tonumber(nMBaseMessage:readInt());
	Common.log("read8074000d miniGameID ==="..dataTable["miniGameID"])
	-- miniGamePackage	Text
	dataTable["miniGamePackage"] = nMBaseMessage:readString()
	Common.log("read8074000d miniGamePackage ==="..dataTable["miniGamePackage"])

	dataTable["userInfoList"] = {}
	-- userInfoList	Int	玩家列表
	local userInfoListCnt = tonumber(nMBaseMessage:readInt())
	Common.log("read8074000d userInfoListCnt ==="..userInfoListCnt)

	for i = 1, userInfoListCnt do
		dataTable["userInfoList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- ...userId	int	userId
		dataTable["userInfoList"][i].userId = tonumber(nMBaseMessage:readInt())
		Common.log("read8074000d userId ==="..dataTable["userInfoList"][i].userId)
		-- ...nickname	Text	昵称
		dataTable["userInfoList"][i].nickname = nMBaseMessage:readString();
		Common.log("read8074000d nickname ==="..dataTable["userInfoList"][i].nickname)

		nMBaseMessage:setReadPos(pos + length)
	end

	dataTable["infoList"] = {}
	-- infoList	Int
	local infoListCnt = tonumber(nMBaseMessage:readInt())
	Common.log("read8074000d infoListCnt ==="..infoListCnt)
	for i = 1, infoListCnt do
		dataTable["infoList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		-- ...time	Text	时间	1999-12-22 22:32:22
		dataTable["infoList"][i].time = nMBaseMessage:readString();
		Common.log("read8074000d time ==="..dataTable["infoList"][i].time)
		-- ...…videoID	Text	唯一标识
		dataTable["infoList"][i].videoID = nMBaseMessage:readString();
		Common.log("read8074000d videoID ==="..dataTable["infoList"][i].videoID)
		-- ...videoUrl	Text	录像url
		dataTable["infoList"][i].videoUrl = nMBaseMessage:readString();
		Common.log("read8074000d videoUrl ==="..dataTable["infoList"][i].videoUrl)

		local UserCnt = tonumber(nMBaseMessage:readInt());
		Common.log("read8074000d UserCnt ==="..UserCnt)
		dataTable["infoList"][i]["userList"] = {};
		for j = 1, UserCnt do
			local length = nMBaseMessage:readShort();
			local pos = nMBaseMessage:getReadPos();
			dataTable["infoList"][i]["userList"][j] = {}
			--    ……userId	int	id
			dataTable["infoList"][i]["userList"][j].userId = tonumber(nMBaseMessage:readInt());
			Common.log("read8074000d userId ==="..dataTable["infoList"][i]["userList"][j].userId)
			--    ……score	int	分数
			dataTable["infoList"][i]["userList"][j].score = tonumber(nMBaseMessage:readInt());
			Common.log("read8074000d score ==="..dataTable["infoList"][i]["userList"][j].score)

			nMBaseMessage:setReadPos(pos + length);
		end
		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--1.14获取牌局录像
function read8074000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_GET_ROOM_RECORD
	dataTable["messageName"] = "MJ_SC_MGR_GET_ROOM_RECORD"

	-- miniGameID	Int
	dataTable["miniGameID"] = tonumber(nMBaseMessage:readInt());
	Common.log("read8074000e miniGameID ==="..dataTable["miniGameID"])
	-- miniGamePackage	Text
	dataTable["miniGamePackage"] = nMBaseMessage:readString()
	Common.log("read8074000e miniGamePackage ==="..dataTable["miniGamePackage"])
	--videoUrl	Text	录像url
	dataTable["videoUrl"] = nMBaseMessage:readString()
	Common.log("read8074000e videoUrl ==="..dataTable["videoUrl"])

	return dataTable
end

--1.15兑换码
function read8074000f(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_EXCHANGE_CODE
	dataTable["messageName"] = "MJ_SC_MGR_EXCHANGE_CODE"

	--Result	Byte	是否成功	1成功2失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read8074000f 是否成功	1成功2失败==============="..dataTable["Result"])
	--Message	Text	操作提示
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read8074000f Message==============="..dataTable["Message"])

	return dataTable
end

--1.16更新房卡
function read80740010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MJ_SC_MGR_UPDATE_FANGKA
	dataTable["messageName"] = "MJ_SC_MGR_UPDATE_FANGKA"

	--targetUserId	Int
	dataTable["targetUserId"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80740010 targetUserId ==============="..dataTable["targetUserId"])
	--GameId	Int	游戏id
	dataTable["GameId"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80740010 GameId ==============="..dataTable["GameId"])
	--FangkaCount	Int	拥有的房卡数量
	dataTable["fangkaCnt"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80740010 FangkaCount==============="..dataTable["fangkaCnt"])

	return dataTable
end

----------------------------------------------------

--3.1.2登录(MAHJONG_LOGIN)
function read80030002(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MAHJONG_LOGIN
	dataTable["messageName"] = "MAHJONG_LOGIN"

	--UserID	int	用户ID	
	dataTable["UserID"] = tonumber(nMBaseMessage:readInt());
	Common.log("read80030002 UserID ==============="..dataTable["UserID"])
	--Result	byte	是否成功	0成功 1失败 
	dataTable["Result"] = nMBaseMessage:readByte();
	Common.log("read80030002 Result ==============="..dataTable["Result"])
	--ResultTxt	text	提示语内容	
	dataTable["ResultTxt"] = nMBaseMessage:readString();
	Common.log("read80030002 ResultTxt==============="..dataTable["ResultTxt"])
	--NickName	text	昵称	
	dataTable["NickName"] = nMBaseMessage:readString();
	Common.log("read80030002 NickName==============="..dataTable["NickName"])
	--PhotoUrl	text	头像URL	
	dataTable["PhotoUrl"] = nMBaseMessage:readString();
	Common.log("read80030002 PhotoUrl==============="..dataTable["PhotoUrl"])
	--CardNum	long	房卡数量
	dataTable["CardNum"] = tonumber(nMBaseMessage:readLong());
	Common.log("read80030002 CardNum==============="..dataTable["CardNum"])
	
	return dataTable
end
