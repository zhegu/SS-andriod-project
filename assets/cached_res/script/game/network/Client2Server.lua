--[[-------------------------DBID数据库消息----------------------------]]
--[[--
--请求破产送金
]]
function sendMANAGERID_GIVE_AWAY_GOLD(type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GIVE_AWAY_GOLD)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	-- RoomType byte 房间类型 0普通 1欢乐 2癞子
	nMBaseMessage:writeByte(type);

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendMANAGERID_GIVE_AWAY_GOLD")
end

--[[--
--取自己或他人的详细信息
--@param #number userid 用户ID
]]
function sendDBID_USER_INFO(userid)
	Common.log("请求自己或他人的详细信息********************* userid = " .. userid)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_USER_INFO)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	nMBaseMessage:writeInt(userid)
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求背包物品列表]]
function sendDBID_BACKPACK_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	profile.Pack.setPackTableDone(false);
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_BACKPACK_LIST)
	nMBaseMessage:setMsgVer(6) --消息版本号
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

--[[-- 请求背包商品数量]]
function sendDBID_BACKPACK_GOODS_COUNT(itemID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_BACKPACK_GOODS_COUNT)

	nMBaseMessage:writeStart()
	--ItemID
	nMBaseMessage:writeInt(itemID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求商城商品列表]]
function sendDBID_MALL_GOODS_LIST(Timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_MALL_GOODS_LIST)
	nMBaseMessage:setMsgVer(7) --消息版本号

	nMBaseMessage:writeStart()
	--Timestamp
	nMBaseMessage:writeLong(Timestamp)
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode  游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-----------------------排行榜 消息----------------------]]
-----------------组织RankListGetRankDataBean [00650002]--------------------
function sendRankListGetRankDataBean(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + RankListGetRankDataBean)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 请求的起始位置
	nMBaseMessage:writeInt(dataTable["startCount"])
	--组织 每页显示数目
	nMBaseMessage:writeInt(dataTable["pageSize"])
	--组织 最后一次显示的排名榜，1每日赚金榜2今日充值榜3土豪榜4昨日充值榜，0无
	nMBaseMessage:writeByte(dataTable["lastShowRanking"])
	--组织 请求显示哪一个排名榜，1每日赚金榜2今日充值榜3土豪榜4昨日充值榜，0无
	nMBaseMessage:writeByte(dataTable["requestShowRanking"])
	--组织 上次更新时间
	nMBaseMessage:writeLong(dataTable["lastUpdateTime"])
	--组织 游戏ID
--	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("xwh sendRankListGetRankDataBean")
end


-----------------打招呼消息-------------------
function sendDBID_V2_SAY_HELLO(userID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_SAY_HELLO)
	nMBaseMessage:writeStart()
	--userid
	nMBaseMessage:writeInt(userID)
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------第二版VIP信息同步-------------------
function sendMANAGERID_GET_VIP_MSG()
    --[[
        斗地主消息协议 金花游戏中屏蔽
    ]]
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_VIP_MSG)
	nMBaseMessage:writeStart()
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
--[[-- 请求VIP列表_V3(MANAGERID_VIP_LIST_V3)]]
function sendMANAGERID_VIP_LIST_V3(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIP_LIST_V3)
	nMBaseMessage:setMsgVer(4)

	nMBaseMessage:writeStart()
	--timestamp  时间戳
	nMBaseMessage:writeLong(time)
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求VIP等级列表(MANAGERID_VIP_LEVEL_LIST)]]
function sendMANAGERID_VIP_LEVEL_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIP_LEVEL_LIST)
	nMBaseMessage:writeStart()
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()

	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[----------------活动------------------------]]

--[[--
--请求宝盒V3：获取宝盒进度(BAOHE_V4_GET_PRO)
--]]
function sendBAOHE_V4_GET_PRO(RoomID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_V4_GET_PRO)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()

	--GameId	Byte	游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomID	int	房间ID
	nMBaseMessage:writeInt(RoomID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求宝盒V3：获取宝盒列表(BAOHE_V4_GET_LIST)
--]]
function sendBAOHE_V4_GET_LIST(RoomID)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_V4_GET_LIST)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()

	--GameId	Byte	游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomID	int	房间ID
	nMBaseMessage:writeInt(RoomID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求宝盒V3：宝盒领奖(BAOHE_V4_GET_PRIZE)
--]]
function sendBAOHE_V4_GET_PRIZE(RoomID, Position)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + BAOHE_V4_GET_PRIZE)
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()

	--GameId	Byte	游戏id
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--RoomID	int	房间ID
	nMBaseMessage:writeInt(RoomID)
	--Position	byte	宝盒编号（从左至右0，1，2）
	nMBaseMessage:writeByte(Position)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode());

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--请求每日登陆公告消息
__]]--
function sendOPERID_GET_DAILY_NOTIFY_INFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_DAILY_NOTIFY_INFO)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-----------------组织GetOperTaskList [00610005]--------------------
function sendOPERID_GET_OPER_TASK_LIST(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GET_OPER_TASK_LIST)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-----------------组织OPERID_GODDESS_GET_INFO [00610006]--------------------
function sendOPERID_GODDESS_GET_INFO(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GODDESS_GET_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------组织OPERID_GODDESS_RESET [00610007]--------------------
function sendOPERID_GODDESS_RESET(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GODDESS_RESET)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------组织OPERID_GODDESS_GET_GIFT [00610008]--------------------
function sendOPERID_GODDESS_GET_GIFT(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_GODDESS_GET_GIFT)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	--组织 礼包ID。从1到4。
	nMBaseMessage:writeInt(dataTable["GiftID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

---------------------福星高照-----------------
-----------------组织OPERID_FXGZ_GET_INFO [00610009]--------------------
function sendOPERID_FXGZ_GET_INFO(dataTable)
	Common.log("发送福星高照信息请求")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_FXGZ_GET_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end



-----------------组织OPERID_FXGZ_PLAY [0061000a]--------------------
function sendOPERID_FXGZ_PLAY(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_FXGZ_PLAY)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()
	--组织 游戏ID
	nMBaseMessage:writeInt(dataTable["gameID"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.108 查看是否有新公告
function sendMANAGERID_GET_HAVE_NEW_GONGGAO(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_HAVE_NEW_GONGGAO)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode	int	游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--time Long 时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.109 获取活动网址【V3客户端】
function sendMANAGERID_V3_GET_ACTIVITY_LIST(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_V3_GET_ACTIVITY_LIST)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode	int	游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--time Long 时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.7.111 获取是否有新活动【Lua客户端】
function sendMANAGERID_GET_HAVE_NEW_HUODONG(time)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_HAVE_NEW_HUODONG)
	nMBaseMessage:writeStart()
	--GameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GameVersionCode	int	游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--time Long 时间戳
	nMBaseMessage:writeLong(time)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
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


--获取未使用门票数量
function sendMANAGERID_GET_UNUSED_TICKET_CNT()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_UNUSED_TICKET_CNT)
	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求牌桌等待提示]]
function sendDBID_V2_WATING_TIPS(time,matchid)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DBID_V2_WATING_TIPS)

	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--TimeStamp  时间戳
	nMBaseMessage:writeLong(time)
	--MatchID  比赛ID
	nMBaseMessage:writeInt(matchid)
	Common.log("---提示num = ".. matchid..time)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求牌桌举报]]
function sendMANAGERID_PLAYER_REPORT(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_PLAYER_REPORT)
	nMBaseMessage:writeStart()
	--被举报用户ID
	nMBaseMessage:writeInt(dataTable["playerID"])
	--被举报用户昵称
	nMBaseMessage:writeString(dataTable["userName"])
	--比赛实例ID
	nMBaseMessage:writeString(dataTable["matchInstanceID"])
	--举报理由:1：色情头像;2：玩家作弊;3：聊天内容
	nMBaseMessage:writeString(dataTable["reportReason"])
	--举报时间
	nMBaseMessage:writeLong(dataTable["time"])
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

---------[[-- 月签  ---]]-------
-----------------月签[25天版]MONTH_SIGN_REWARD_LIST [00610017]--------------------
function sendMONTH_SIGN_REWARD_LIST(timeStamp)
	Common.log("发送月签[25天版]消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MONTH_SIGN_REWARD_LIST)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--时间戳 timeStamp
	nMBaseMessage:writeLong(timeStamp)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------用户月签基本信息USERS_MONTH_SIGN_BASIC_INFO [00610018]--------------------
function sendUSERS_MONTH_SIGN_BASIC_INFO(userId)
	Common.log("发送用户月签基本信息消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + USERS_MONTH_SIGN_BASIC_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--UserID
	nMBaseMessage:writeInt(userId)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------月签签到SIGN_TO_MONTH_SIGN [00610019]--------------------
function sendSIGN_TO_MONTH_SIGN()
	Common.log("发送月签签到消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + SIGN_TO_MONTH_SIGN)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

----幸运转盘-----
-----------------转盘基本信息(TURNTABLE_BASIC_INFO)[00610015]--------------------
function sendTURNTABLE_BASIC_INFO(timeStamp)
	Common.log("发送幸运转盘消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TURNTABLE_BASIC_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--时间戳 timeStamp
	nMBaseMessage:writeLong(timeStamp)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-----------------转盘抽奖信息(TURNTABLE_LOTTERY_INFO)[00610016]--------------------
function sendTURNTABLE_LOTTERY_INFO(lotteryType)
	Common.log("发送幸运转盘抽奖消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + TURNTABLE_LOTTERY_INFO)
	nMBaseMessage:setExtData(2)
	nMBaseMessage:setMsgVer(1) --消息版本号
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--抽奖类型 0免费抽奖 1消耗金币 2消耗元宝
	nMBaseMessage:writeByte(lotteryType)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--获取大厅公告
--]]
function sendMANAGERID_GET_SYSTEM_LIST_NOTICE()
	Common.log("发送获取大厅公告消息");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_SYSTEM_LIST_NOTICE)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--获取大厅按钮状态
--]]
function sendMANAGERID_GET_BUTTONS_STATUS()
	Common.log("发送获取大厅按钮状态");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_BUTTONS_STATUS)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------[[----小游戏----万人金花--------]]-------------

--【扎金花牌桌消息】--


--[[--
--退出弹框引导
--@param #String ClientInstallGameList 已经安装的游戏ID的拼接字符串,英文逗号隔开
--]]
function sendMANAGERID_QUIT_GUIDE(ClientInstallGameList)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_QUIT_GUIDE)
	nMBaseMessage:writeStart()

	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--玩家手机已经安装的同趣游戏ID列表,英文逗号隔开
	nMBaseMessage:writeString(ClientInstallGameList);


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("发送 sendMANAGERID_QUIT_GUIDE");
end

--[[免费金币]]--
function sendOPERID_FREE_COIN()
	Common.log("发送免费金币消息");

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_FREE_COIN);
	nMBaseMessage:setExtData(3);
	nMBaseMessage:writeStart();

	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[领取游戏分享奖励]]--
function sendOPERID_REQUEST_GAME_SHARING_REWARD()
	Common.log("领取游戏分享奖励");
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_REQUEST_GAME_SHARING_REWARD);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[请求游戏分享累计奖励]]--
function sendOPERID_GAME_SHARING_ALL_REWARD()
	Common.log("请求游戏分享累计奖励");
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_GAME_SHARING_ALL_REWARD);
	nMBaseMessage:writeStart();

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[宝盒V4新手预读奖励]]--
function sendOPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD()
	Common.log("发送宝盒V4新手预读奖励");

	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD);
	nMBaseMessage:setExtData(3);
	nMBaseMessage:writeStart();

	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver();
	local messageService=Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

-----------------万人水果机(WRSGJ_INFO)[80530014]--------------------
function sendWRSGJ_INFO(timeStamp)
	--	Common.log("zbl___发送水果机基本消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_INFO)
	--消息版本号
	nMBaseMessage:setMsgVer(0)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--时间戳 timeStamp
	nMBaseMessage:writeLong(timeStamp)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


-------------------万人水果机同步消息(WRSGJ_SYNC_MESSAGE)----------------------------
function sendWRSGJ_SYNC_MESSAGE(hasSendResult,timestamp)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_SYNC_MESSAGE)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--是否推送过 0 , 1
	nMBaseMessage:writeByte(hasSendResult)
	--上一局前三名下注的时间戳
	nMBaseMessage:writeLong(timestamp)
	nMBaseMessage:writeLong(os.time())
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------万人水果机公告(WRSGJ_NOTICE）----------------------------------------
function sendWRSGJ_NOTICE(num )
	--	Common.log("zbl___发送水果机公告")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_NOTICE)
	nMBaseMessage:writeStart()
	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Limit  想取多少条，最多200
	nMBaseMessage:writeShort(num)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-------------------万人水果机押注( WRSGJ_BET ）----------------------------
function sendWRSGJ_BET( index,num )
	--	Common.log("zbl___发送水果机押注消息")
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + WRSGJ_BET)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--类型
	nMBaseMessage:writeByte(index)
	--押注金额
	nMBaseMessage:writeInt(num)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-------------VIP(大厅)提示信息-------------
function sendMANAGERID_VIPV2_TIP_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIPV2_TIP_INFO)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("qaz...发送出去")
end

-------------VIP(大厅)获取vip开通礼包-------------
function sendMANAGERID_VIPV2_GET_GIFTBAG(type,price)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_VIPV2_GET_GIFTBAG)
	nMBaseMessage:writeStart()
	--游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--礼包类型
	nMBaseMessage:writeByte(type)
	--请求礼包金额
	nMBaseMessage:writeInt(price)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
------------------------------------------------------------------
--[[------------------------斗地主大厅请求红点消息----------------------- ]]
------------------------------------------------------------------
function sendMANAGERID_REQUEST_REDP(dataTable)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_REQUEST_REDP)
	nMBaseMessage:writeStart()
	--GAME ID
	--Common.log("sendMANAGERID_REQUEST_REDP ")
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GAME VersionCode
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Loop
	nMBaseMessage:writeInt(#dataTable)
	for i = 1,#dataTable do
		--Common.log("sendMANAGERID_REQUEST_REDP i = " .. i)
		nMBaseMessage:writeInt(dataTable[i])
	end
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[------------------------斗地主大厅删除红点消息----------------------- ]]
------------------------------------------------------------------
function sendMANAGERID_REMOVE_REDP(ModuleId, taskId)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_REMOVE_REDP)
	nMBaseMessage:writeStart()
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--GAME VersionCode
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	Common.log(ModuleId.."sendMANAGERID_REMOVE_REDP")
	Common.log(taskId.."sendMANAGERID_REMOVE_REDP")
	--loop
	nMBaseMessage:writeInt(ModuleId)
	nMBaseMessage:writeInt(taskId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--分享V2分享下载地址预读
--]]
function sendOPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL()
	if Services:getMessageService():getCutOut() then
		return;
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL);
	nMBaseMessage:writeStart();
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode());
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--分享V2 IOS是否可以填写好友ID
--]]
function sendOPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND()
	if Services:getMessageService():getCutOut() then
		return;
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_SHARINGV2_IOS_IS_ADD_OLD_FRIEND);
	nMBaseMessage:writeStart();
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode());
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--分享V2 IOS绑定好友关系
--@param #String OldFriendID 邀请人用户ID
--]]
function sendOPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND(OldFriendID)
	if Services:getMessageService():getCutOut() then
		return;
	end
	local nMBaseMessage = NMBaseMessage:new();
	nMBaseMessage:setMessageType(REQ + OPERID_SHARINGV2_IOS_BINDING_OLD_FRIEND);
	nMBaseMessage:writeStart();
	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID);
	--版本号
	nMBaseMessage:writeInt(Common.getVersionCode());
	--渠道号
	nMBaseMessage:writeString("" .. Common.getChannelID());
	--邀请人用户ID
	nMBaseMessage:writeInt(OldFriendID);

	nMBaseMessage:writeOver();
	local messageService = Services:getMessageService();
	messageService:sendMessage(nMBaseMessage);
	nMBaseMessage:delete();
end

--[[--
--XY平台新用户礼包兑换
--@param #String CDKEY 礼包兑换码
--]]
function sendOPERID_XYPLATFORM_GIFTBAG_EXCHANGE(CDKEY)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_XYPLATFORM_GIFTBAG_EXCHANGE)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--礼包兑换码
	nMBaseMessage:writeString(CDKEY)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[--
--分享奖励说明
--]]
function sendOPERID_SHARING_REWARD_DESCRIPTION()
	Common.log("sendOPERID_SHARING_REWARD_DESCRIPTION 请求分享奖励说明");
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_REWARD_DESCRIPTION)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

------------------------------------------------------------------
--[[---------------------病毒传播-------------------------- ]]
------------------------------------------------------------------

--请求红包分享V3基本信息
function sendOPERID_SHARING_V3_BASE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_V3_BASE_INFO)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--verCode Int 版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	--RegChannelID text  注册渠道号
	nMBaseMessage:writeString(""..Common.getChannelID())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--新玩家首次领取红包V3奖励
function sendOPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_V3_NEW_PLAYER_GET_RP_REWARD)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--verCode Int 版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--红包V3新玩家首次分享
function sendOPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + OPERID_SHARING_V3_GET_NEW_PLAYER_FIRST_SHARING_REWARD)
	nMBaseMessage:writeStart()

	--GAME ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--verCode Int 版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end



-- 扎金花新手引导详情消息
function sendMANAGERID_GET_JINHUA_USER_GUIDE_INFO()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_JINHUA_USER_GUIDE_INFO)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 扎金花领取新手引导奖励(MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE)
function sendMANAGERID_GET_JINHUA_USER_GUIDE_PRIZE(prizeType)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MANAGERID_GET_JINHUA_USER_GUIDE_PRIZE)
	nMBaseMessage:writeStart()
	-- ResultType   Byte    结果类型    0跳过 1完成
	nMBaseMessage:writeByte(prizeType)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end


----3.05扎金花相关配置请求(JINHUA_MGR_SETTING）
--function sendJINHUA_MGR_SETTING(Timestamp)
--	local nMBaseMessage = NMBaseMessage:new()
--	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_SETTING)
--	nMBaseMessage:writeStart()
--	-- GameID	byte	ID
--	nMBaseMessage:writeByte(GameConfig.GAME_ID)
--	-- Timestamp	Long	时间戳
--	nMBaseMessage:writeLong(Timestamp)
--	nMBaseMessage:writeOver()
--	local messageService=Services:getMessageService()
--	messageService:sendMessage(nMBaseMessage)
--	nMBaseMessage:delete()
--end
--

----3.09扎金花送礼物 (JINHUA_MGR_SEND_GIFT)
--function sendJINHUA_MGR_SEND_GIFT(userId,type)
--	local nMBaseMessage = NMBaseMessage:new()
--	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_SEND_GIFT)
--	nMBaseMessage:writeStart()
--	-- GameID	byte	ID
--	nMBaseMessage:writeByte(GameConfig.GAME_ID)
--	--UserId	Int	被送人id
--	nMBaseMessage:writeInt(userId)
--	--GiftType	Byte	礼物类型
--	nMBaseMessage:writeByte(type)
--	nMBaseMessage:writeOver()
--	local messageService=Services:getMessageService()
--	messageService:sendMessage(nMBaseMessage)
--	nMBaseMessage:delete()
--end


--3.11购买金花VIP (JINHUA_MGR_BUY_VIP)
function sendJINHUA_MGR_BUY_VIP()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_BUY_VIP)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--3.18金花ios玩家添加推荐人好友 (JINHUA_MGR_JH_ADD_REFERRER)
function sendJINHUA_MGR_JH_ADD_REFERRER(dataTable)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_JH_ADD_REFERRER)
	nMBaseMessage:writeStart()
	--gameID	Int	游戏id
	nMBaseMessage:writeInt(GameConfig.GAME_ID);
	--ReferrerID	Int	推荐人id
	nMBaseMessage:writeInt(dataTable.ReferrerID);
	--Mailed	Int	要删除邮件id
	nMBaseMessage:writeInt(dataTable.Mailed);
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("JINHUA_MGR_JH_ADD_REFERRER")
end

--[[
--3.25扎金花陌生人列表 (JINHUA_MGR_STRANGER_LIST ）
--]]
function sendJINHUA_MGR_STRANGER_LIST()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_STRANGER_LIST)

	nMBaseMessage:writeStart()

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--3.26扎金花陌生人列表 (JINHUA_MGR_DAILY_SALARY ）
--]]
function sendJINHUA_MGR_DAILY_SALARY()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_DAILY_SALARY)

	nMBaseMessage:writeStart()

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--3.27扎金花领取每日工资 (JINHUA_MGR_GET_SALARY）
--]]
function sendJINHUA_MGR_GET_SALARY()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + JINHUA_MGR_GET_SALARY)

	nMBaseMessage:writeStart()

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[-- 请求循环礼包]]
function sendGIFTBAGID_GET_LOOP_GIFT(Position)
	if Services:getMessageService():getCutOut() then
		return
	end

	if DelayShowGiftConfig.setShowGiftAtMiniGame ~= nil then
		DelayShowGiftConfig.setShowGiftAtMiniGame();
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + GIFTBAGID_GET_LOOP_GIFT)

	nMBaseMessage:writeStart()

	--GameID  游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--客户端版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--Position	byte	图标位置	1主界面；2牌桌上；3充值界面；102水果机；103金皇冠；104万人金花；105万人水果派
	nMBaseMessage:writeByte(Position)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end




-- 4.2斗牛签到面板
function sendDOUNIU_MGR_OPEN_SIGN()
	if Services:getMessageService():getCutOut() then
		return
	end
	Common.log("请求 斗牛签到面板")

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_OPEN_SIGN)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 4.3斗牛签到
function sendDOUNIU_MGR_SIGN()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_SIGN)

	nMBaseMessage:writeStart()

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.6 请求破产送金信息(DOUNIU_MGR_REVIVE_INFO)
function sendDOUNIU_MGR_REVIVE_INFO()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_REVIVE_INFO)
	nMBaseMessage:writeStart()
	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.7 领取破产送金 (DOUNIU_MGR_REVIVE)
function sendDOUNIU_MGR_REVIVE()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_REVIVE)
	nMBaseMessage:writeStart()
	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.8背包(DOUNIU_MGR_BACKPACK_ITEMS）
function sendDOUNIU_MGR_BACKPACK_ITEMS()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_BACKPACK_ITEMS)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.9使用背包物品(DOUNIU_USE_GIFT）
function sendDOUNIU_USE_GIFT(giftId)
	Common.log("发送使用背包物品 giftId = "..giftId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_USE_GIFT)
	nMBaseMessage:writeStart()
	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--giftId	礼物Id
	nMBaseMessage:writeByte(giftId);
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.10斗牛排行榜（DOUNIU_RANKLIST）
function sendDOUNIU_RANKLIST(type)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_RANKLIST)
	nMBaseMessage:writeStart()
	--Type	Byte	排行榜类型	1=每日赚金榜，2=财富总榜，3=每日充值榜
	nMBaseMessage:writeByte(type)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.11月卡面板（DOUNIU_MONTH_CARD_V2）
function sendDOUNIU_MONTH_CARD_V2()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MONTH_CARD_V2)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.12 VIP特权（DOUNIU_VIPINFO）
function sendDOUNIU_VIPINFO()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_VIPINFO)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--4.13斗牛充值返利相关信息
--]]
function sendRECHARGE_REBATE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + RECHARGE_REBATE_INFO)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.15好友列表
function sendDOUNIU_MGR_FRIEND_LIST()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_FRIEND_LIST)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.16好友领取每日送金
function sendDOUNIU_MGR_GET_FRIEND_COIN(userId)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_GET_FRIEND_COIN)
	nMBaseMessage:writeStart()
	--userId	好友id
	nMBaseMessage:writeInt(userId);
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--2.122添加好友 (DOUNIU_ADD_FRIEND）
function sendDOUNIU_ADD_FRIEND(userID, giftID)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_ADD_FRIEND)
	nMBaseMessage:writeStart()
	--UserId	Int	添加的好友id
	nMBaseMessage:writeInt(userID)
	--GiftId	Int	送的礼物
	nMBaseMessage:writeInt(giftID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.17添加好友
function sendDOUNIU_MGR_ADD_FRIEND(userID, giftID)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_ADD_FRIEND)
	nMBaseMessage:writeStart()
	--UserId	Int	添加的好友id
	nMBaseMessage:writeInt(userID)
	--GiftId	Int	送的礼物
	nMBaseMessage:writeInt(giftID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.18删除好友 (DOUNIU_MGR_DEL_FRIEND）
function sendDOUNIU_MGR_DEL_FRIEND(userID)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_DEL_FRIEND)
	nMBaseMessage:writeStart()
	--UserId	Int	删除的好友id
	nMBaseMessage:writeInt(userID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--4.19添加追踪 (DOUNIU_MGR_ADD_TRACE）
--]]
function sendDOUNIU_MGR_ADD_TRACE(targerId)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_ADD_TRACE)

	nMBaseMessage:writeStart()

	--targerId	Int	被追踪的玩家
	nMBaseMessage:writeInt(targerId)
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--4.20删除追踪 (DOUNIU_MGR_DEL_TRACE）
--]]
function sendDOUNIU_MGR_DEL_TRACE(targerId)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_DEL_TRACE)

	nMBaseMessage:writeStart()

	--targerId	Int	被追踪的玩家
	nMBaseMessage:writeInt(targerId)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--[[
--4.21执行追踪 (DOUNIU_MGR_DO_TRACE）
--]]
function sendDOUNIU_MGR_DO_TRACE(targerId, minigameVersion)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_DO_TRACE)

	nMBaseMessage:writeStart()

	--targerId	Int	被追踪的玩家
	nMBaseMessage:writeInt(targerId)
	--miniGameVer	Int	我自己的小游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode(minigameVersion))

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.22追踪列表
function sendDOUNIU_MGR_TRACE_LIST()
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_TRACE_LIST)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.23同意加好友
function sendDOUNIU_MGR_FRIEND_AGREE(userID)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_FRIEND_AGREE)
	nMBaseMessage:writeStart()
	--targerId	Int	同意玩家的id
	nMBaseMessage:writeInt(userID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.24拒绝加好友
function sendDOUNIU_MGR_FRIEND_REFUSE(userID)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_FRIEND_REFUSE)
	nMBaseMessage:writeStart()
	--targerId	Int	拒绝玩家的id
	nMBaseMessage:writeInt(userID)
	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.25斗牛好友是否有红点  (DOUNIU_MGR_FRIEND_HAVE_REDP ）
function sendDOUNIU_MGR_FRIEND_HAVE_REDP()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_FRIEND_HAVE_REDP)

	nMBaseMessage:writeStart()


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--4.26斗牛绑定手机的金币奖励 (DOUNIU_MGR_BINDPHONE_REWARDS）
function sendDOUNIU_MGR_BINDPHONE_REWARDS()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_BINDPHONE_REWARDS)

	nMBaseMessage:writeStart()


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--自建房间数据
function sendDOUNIU_MGR_BUILD_TABLE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_BUILD_TABLE_INFO)

	nMBaseMessage:writeStart()


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--创建房间
function sendDOUNIU_MGR_BUILD_TABLE(minCoin, selectTime, nowType, buildType)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_BUILD_TABLE)
	nMBaseMessage:writeStart()
	--MinCoin	Long	最小金币数
	nMBaseMessage:writeLong(minCoin)
	--TableTime	Int	牌局时长
	nMBaseMessage:writeInt(selectTime)
	--TableType	Byte	房间类型	1看牌抢庄2炸金牛
	nMBaseMessage:writeByte(nowType)
	--buildType	Byte	操作类型	1创建2续桌
	nMBaseMessage:writeByte(buildType)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--进入自建房
function sendDOUNIU_MGR_ENTER_BUILD_TABLE(roomCode)
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_ENTER_BUILD_TABLE)
	nMBaseMessage:writeStart()
	--RoomCode	Int	房间邀请码
	nMBaseMessage:writeInt(roomCode)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--请求有效自建房邀请码
function sendDOUNIU_MGR_BUILD_TABLE_ROOMCODE()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_BUILD_TABLE_ROOMCODE)
	nMBaseMessage:writeStart()
	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--斗牛主页活动
function sendDOUNIU_MGR_INDEX_ACTIVITY()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + DOUNIU_MGR_INDEX_ACTIVITY)
	nMBaseMessage:writeStart()
	--gameid
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--游戏版本号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end





---------------------------------------------------------
--1.4个人信息
function sendMJ_SC_MGR_PLAYER_INFO(userID)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_PLAYER_INFO)

	nMBaseMessage:writeStart()

	--UserId Int	id
	nMBaseMessage:writeInt(userID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.6大厅消息—大厅广播
function sendMJ_SC_NOTICE(Timestamp)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_NOTICE)
	nMBaseMessage:writeStart()

	-- GameID	byte	ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--Timestamp	Long	最后的时间
	Common.log("Timestamp ====== "..Timestamp)
	nMBaseMessage:writeLong(Timestamp)

	nMBaseMessage:writeOver()
	local messageService=Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.7大厅消息—微信分享
function sendMJ_SC_SHARE_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_SHARE_INFO)

	nMBaseMessage:writeStart()

	--gameVersion	Int	扎金花游戏主版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	Common.log("gameVersion =========== "..Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

-- 1.8大厅基础信息
function sendMJ_SC_HALL_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_HALL_INFO)

	nMBaseMessage:writeStart()

	--gameVersion	Int	炸金花游戏主版本号
	nMBaseMessage:writeInt(Common.getVersionCode())
	Common.log("gameVersion =========== "..Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.9推荐好友界面
function sendMJ_SC_RECOMMEND_INFO()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_RECOMMEND_INFO)

	nMBaseMessage:writeStart()

	-- gameID	byte	游戏ID
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--gameVersion	Int	游戏主版本号
	nMBaseMessage:writeInt(Common.getVersionCode())

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.10推荐好友领奖界面
function sendMJ_SC_RECEIVE_REWARD(receiveType,receiveCode)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_RECEIVE_REWARD)

	nMBaseMessage:writeStart()

	-- receiveType	byte	领奖类型	1验证码输入
	-- 2好友数量礼包
	-- 3好友局数满足礼包
	nMBaseMessage:writeByte(receiveType)
	-- receiveCode	int	游戏版本号	这个字段根据receiveType意义不同
	-- 1验证码
	-- 2满足礼包的好友数量
	-- 3满足领取条件的好友userid
	nMBaseMessage:writeLong(receiveCode)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
-- ZIPAI_SHARING

function sendZIPAI_SHARING()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + ZIPAI_SHARING)

	nMBaseMessage:writeStart()


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.12 房间记录
function sendMJ_SC_MGR_ROOM_RECORD()
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_ROOM_RECORD)

	nMBaseMessage:writeStart()


	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.13牌局记录
function sendMJ_SC_MGR_INNING_RECORD(RecordID)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_INNING_RECORD)

	nMBaseMessage:writeStart()

	--RecordID	Int	房间录像记录ID
	nMBaseMessage:writeInt(RecordID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.14获取牌局录像()
function sendMJ_SC_MGR_GET_ROOM_RECORD(videoID)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_GET_ROOM_RECORD)

	nMBaseMessage:writeStart()

	--videoID	Text	唯一标识
	nMBaseMessage:writeString(videoID)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

--1.15兑换码
function sendMJ_SC_MGR_EXCHANGE_CODE(exchangeCode)
	if Services:getMessageService():getCutOut() then
		return
	end

	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MJ_SC_MGR_EXCHANGE_CODE)

	nMBaseMessage:writeStart()

	--exchangeCode	Text	兑换码
	nMBaseMessage:writeString(exchangeCode)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end

----------------------------------------------------------

--3.1.2登录(MAHJONG_LOGIN)
function sendMAHJONG_LOGIN()
	if Services:getMessageService():getCutOut() then
		return
	end
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAHJONG_LOGIN)

	nMBaseMessage:writeStart()

	--AppVersionCode	Int	游戏版本号	版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--GameID	Byte	发起注册的GameId	0 麻将
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--ThirdPartPlatUID	Text	第三方渠道的用户ID	
	nMBaseMessage:writeByte("")
	--ThirdPartPlatId	Int	第三方登录平台的id	THIRD_PART_PLAT_MICROCHAT = 1 微信
	nMBaseMessage:writeByte(1)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
	Common.log("sendMAHJONG_LOGIN")
end

--3.1.3第三方渠道登录(MAHJONG_THIRD_PART_PLAT_LOGIN)
function sendMAHJONG_THIRD_PART_PLAT_LOGIN(Token)
	if Services:getMessageService():getCutOut() then
		return
	end
	Common.log("sendMAHJONG_THIRD_PART_PLAT_LOGIN token:"..Token)
	local nMBaseMessage = NMBaseMessage:new()
	nMBaseMessage:setMessageType(REQ + MAHJONG_THIRD_PART_PLAT_LOGIN)

	nMBaseMessage:writeStart()

	--Token	Text	第三方登录token或Session	
	nMBaseMessage:writeString(Token)
	--AppVersionCode	Int	游戏版本号	版本号+渠道号
	nMBaseMessage:writeInt(Common.getVersionCode() + Common.getChannelID())
	--GameID	Byte	发起注册的GameId	0 麻将
	nMBaseMessage:writeByte(GameConfig.GAME_ID)
	--OSID	Byte	操作系统ID	客户端类型 1- Android 2- Html5 3-IOS（废除）0-	LUA-安卓  1-	5-LUA-ios
	if Common.platform == Common.TargetIos then
		-- iOS平台
		nMBaseMessage:writeByte(5)
	elseif Common.platform == Common.TargetAndroid then
		--Android
		nMBaseMessage:writeByte(4)
	else
		nMBaseMessage:writeByte(4)
	end
	--ThirdPartPlatUID	Text	第三方渠道的用户ID	
	nMBaseMessage:writeByte("")
	--ThirdPartPlatId	Int	第三方登录平台的id	THIRD_PART_PLAT_MICROCHAT = 1 微信
	nMBaseMessage:writeByte(1)

	nMBaseMessage:writeOver()
	local messageService = Services:getMessageService()
	messageService:sendMessage(nMBaseMessage)
	nMBaseMessage:delete()
end
