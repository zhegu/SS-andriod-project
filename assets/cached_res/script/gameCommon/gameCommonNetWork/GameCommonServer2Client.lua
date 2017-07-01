
--[[--
-- 心跳消息
-- ]]
function read80000000(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = MSG_IDLE;
	dataTable["messageName"] = "MSG_IDLE";
	return dataTable;
end


--[[--推送老虎机限时礼包]]
function read8051000f(nMBaseMessage)
	Common.log("限时礼包响应")

	local dataTable = {}
	dataTable["messageType"] = ACK + GIFTBAGID_PUSH_LIMITED_GIFTBAG
	dataTable["messageName"] = "GIFTBAGID_PUSH_LIMITED_GIFTBAG"

	--礼包类型
	dataTable["GiftType"] = tonumber(nMBaseMessage:readInt());

	--限时礼包剩余时间，如果不是限时礼包则为0
	dataTable["RemainTime"] = tonumber(nMBaseMessage:readLong())

	Common.log("限时礼包响应.类型:"..dataTable["GiftType"].."  剩余时间:"..dataTable["RemainTime"])


	return dataTable
end

--[[--
--获取小游戏发送的消息
--]]
function read8005000a(nMBaseMessage)
	local dataTable = {}
	--	--Common.log("read8005000a----------------")
	dataTable["messageType"] = ACK + IMID_MINI_SEND_MESSAGE
	dataTable["messageName"] = "IMID_MINI_SEND_MESSAGE"
	--SenderNickname	Text	发送者昵称
	dataTable["SenderNickname"] = nMBaseMessage:readString()
	--MessageContent	Text	消息内容
	dataTable["MessageContent"] = nMBaseMessage:readString()
	--Result	Byte	结果	0 失败 1成功
	dataTable["Result"] = nMBaseMessage:readByte()
	--ResultTxt	Text	失败原因
	dataTable["ResultTxt"] = nMBaseMessage:readString()
	Common.log("read8005000a MessageContent = " .. dataTable["MessageContent"])
	return dataTable
end

--[[-----------------------小游戏打赏模块 AWARDS 消息----------------------]]
--[[--
--解析小游戏打赏基本信息(MINI_REWARDS_BASEINFO)
--]]
function read8005000b(nMBaseMessage)
	--	--Common.log("read8005000b----------------")
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_BASEINFO
	dataTable["messageName"] = "IMID_MINI_REWARDS_BASEINFO"

	--	PromptOne Text 打赏第一条提示语
	dataTable["PromptOne"] = nMBaseMessage:readString()
	--	PromptTwo Text 打赏第二条提示语
	dataTable["PromptTwo"] = nMBaseMessage:readString()
	--	RewardLevel	Int	赢多少钱可以打赏
	dataTable["RewardLevel"] = tonumber(nMBaseMessage:readInt());
	--Common.log("dataTable.RewardLevel = "..dataTable.RewardLevel)
	--	RewardMsg	Loop	打赏基本信息
	dataTable["RewardMsg"] = {}

	local RewardMsg = tonumber(nMBaseMessage:readInt());
	for i = 1, RewardMsg do
		dataTable["RewardMsg"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--		…RewardType	Byte	红包类型
		dataTable["RewardMsg"][i].RewardType = nMBaseMessage:readByte()
		--		…RewardInfo	Text	红包提示
		dataTable["RewardMsg"][i].RewardInfo = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--Common.log("dataTable[RewardMsg] = "..#dataTable["RewardMsg"])
	return dataTable
end

--[[--
--解析小游戏打赏(MINI_REWARDS_RESULT)
--]]
function read8005000c(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_RESULT
	dataTable["messageName"] = "IMID_MINI_REWARDS_RESULT"

	--Successed	Byte	打赏结果	0 失败 1成功
	dataTable["Successed"] = nMBaseMessage:readByte()
	return dataTable
end

--[[--
--解析小游戏打赏领奖 (MINI_REWARDS_COLLECT)
--]]
function read8005000d(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_COLLECT
	dataTable["messageName"] = "IMID_MINI_REWARDS_COLLECT"
	-- PromptMsg	Loop	提示信息
	dataTable["PromptMsg"] = {}
	local PromptMsg = tonumber(nMBaseMessage:readInt());
	for i = 1, PromptMsg do
		dataTable["PromptMsg"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--…Name	Text	打赏人姓名
		dataTable["PromptMsg"][i].Name = nMBaseMessage:readString()
		--…Content	Text	领奖信息
		dataTable["PromptMsg"][i].Content = nMBaseMessage:readString()
		--Common.log("dataTable[i].Name = "..dataTable["PromptMsg"][i].Name.."dataTable[i].Content = "..dataTable["PromptMsg"][i].Content)
		--…UserPic	Text	打赏者头像
		dataTable["PromptMsg"][i].UserPic = nMBaseMessage:readString()
		nMBaseMessage:setReadPos(pos + length)
	end
	--	RewardNum	Int	赏金总额
	dataTable["RewardNum"] = tonumber(nMBaseMessage:readInt());
	return dataTable
end

--[[--
--解析小游戏请求打赏(MINI_REWARDS_JUDGE)
--]]
function read8005000e(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_REWARDS_JUDGE
	dataTable["messageName"] = "IMID_MINI_REWARDS_JUDGE"

	--Judge	Byte	服务器含有待请求的领奖信息	1
	dataTable["Judge"] = nMBaseMessage:readByte()

	return dataTable
end

--[[--
--系统发送打赏V3消息(IMID_CHAT_ROOM_SEND_REWARD_V3)
--]]
function read8005000f(nMBaseMessage)
	Common.log("read8005000f=======================")
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_CHAT_ROOM_SEND_REWARD_V3
	dataTable["messageName"] = "IMID_CHAT_ROOM_SEND_REWARD_V3"

	--SpeakerUserID  发言者用户ID
	dataTable["SpeakerUserID"] = tonumber(nMBaseMessage:readInt());
	--SpeakerNickName  发言者昵称
	dataTable["SpeakerNickName"] = nMBaseMessage:readString()
	--SpeechText  发言内容
	dataTable["SpeechText"] = nMBaseMessage:readString()
	--Color  ARGB方式存储。可用4个getByte()分别读取
	dataTable["ARGB0"] = nMBaseMessage:readByte()
	dataTable["ARGB1"] = nMBaseMessage:readByte()
	dataTable["ARGB2"] = nMBaseMessage:readByte()
	dataTable["ARGB3"] = nMBaseMessage:readByte()
	--TextSize  字体大小
	dataTable["TextSize"] = tonumber(nMBaseMessage:readInt());
	--vip等级
	dataTable["VipLevel"] = tonumber(nMBaseMessage:readInt());
	--ActionInT
	dataTable["ActionId"] = tonumber(nMBaseMessage:readInt());
	--ActionString
	dataTable["ActionParam"] = tonumber(nMBaseMessage:readInt());
	--CheckCode
	dataTable["CheckCode"] = tonumber(nMBaseMessage:readInt());
	return dataTable
end

--[[--
--小游戏领取打赏V3 (IMID_MINI_GET_REWARDS_V3）
--]]
function read80050010(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + IMID_MINI_GET_REWARDS_V3
	dataTable["messageName"] = "IMID_MINI_GET_REWARDS_V3"

	--result	Byte	结果(1成功，2失败)
	dataTable["result"] = nMBaseMessage:readByte()
	--Pic	Text	奖励图片
	dataTable["Pic"] = nMBaseMessage:readString()
	--Description	Text	奖励信息
	dataTable["Description"] = nMBaseMessage:readString()
	--Msg	Text	陈述信息
	dataTable["Msg"] = nMBaseMessage:readString()

	return dataTable
end

--------------------小游戏赚金榜----------------------
--
--[[--
--3.16.35 获取小游戏赚金榜（COMMONS_GET_MINI_GAME_EARN_RANK）
--]]--
function read80650023(nMBaseMessage)
	local dataTable = {};
	dataTable["messageType"] = ACK + COMMONS_GET_MINI_GAME_EARN_RANK;
	dataTable["messageName"] = "COMMONS_GET_MINI_GAME_EARN_RANK";
	--玩家自己排名
	dataTable["SelfRank"] = tonumber(nMBaseMessage:readInt());
	dataTable["Rewards"] = {}
	local RewardsCnt = tonumber(nMBaseMessage:readInt());
	--	Common.log("read80650023 RewardsCnt = "..RewardsCnt);
	for i = 1,RewardsCnt do
		dataTable["Rewards"][i] = {};
		local length = nMBaseMessage:readShort();
		local pos = nMBaseMessage:getReadPos();
		--名次
		dataTable["Rewards"][i]["rank"] = tonumber(nMBaseMessage:readInt());
		--		dataTable["Rewards"][i]["rank"] = i;
		--昵称
		dataTable["Rewards"][i]["nickName"] = nMBaseMessage:readString();
		--		Common.log("read80650023 nickName = "..dataTable["Rewards"][i]["nickName"]);
		--头像
		dataTable["Rewards"][i]["photoUrl"] = nMBaseMessage:readString();
		--		Common.log("read80650023 photoUrl == "..dataTable["Rewards"][i]["photoUrl"])
		--赚金
		dataTable["Rewards"][i]["earnCoins"] = tonumber(nMBaseMessage:readLong());
		--		Common.log("read80650023 earnCoins = "..dataTable["Rewards"][i]["earnCoins"]);
		--奖金
		dataTable["Rewards"][i]["rewardCoins"] = nMBaseMessage:readString();
		--		dataTable["Rewards"][i]["rewardCoins"] = i;
		nMBaseMessage:setReadPos(length + pos);
	end
	--1今天2昨天
	dataTable["Day"] = nMBaseMessage:readByte();
	--	Common.log("read80650023 Day = "..dataTable["Day"]);
	--时间戳
	dataTable["TimeStamp"] = nMBaseMessage:readString();
	--	Common.log("read80650023 TimeStamp = "..dataTable["TimeStamp"]);
	--当前小游戏id
	dataTable["miniGameID"] = tonumber(nMBaseMessage:readInt());
	--	Common.log("read80650023 miniGameID = "..dataTable["miniGameID"]);
	return dataTable;
end

--3.15.97扎金花发送大喇叭(OPERID_MGR_SEND_BUGLE）
function read80610061(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_MGR_SEND_BUGLE
	dataTable["messageName"] = "OPERID_MGR_SEND_BUGLE"
	--Result	Byte	1成功2失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read80610061 Result " .. dataTable["Result"])
	--Message	Text	提示文字
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read80610061 Message " .. dataTable["Message"])
	return dataTable
end

--3.15.98推送大喇叭消息(OPERID_SEND_ALL_BUGLE)
function read80610062(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + OPERID_SEND_ALL_BUGLE
	dataTable["messageName"] = "OPERID_SEND_ALL_BUGLE"
	--NickName	Text	发话人昵称
	dataTable["NickName"] = nMBaseMessage:readString()
	Common.log("read80610062 NickName " .. dataTable["NickName"])
	--Message	Text	提示文字
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read80610062 Message " .. dataTable["Message"])
	return dataTable
end

--3.7.149保险箱info (MANAGERID_STRONG_BOX_INFO)
function read80070095(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_STRONG_BOX_INFO
	dataTable["messageName"] = "MANAGERID_STRONG_BOX_INFO"
	--strongBoxCoin	Long	保险箱中的金币
	dataTable["strongBoxCoin"] = tonumber(nMBaseMessage:readLong())
	Common.log("read80070095 strongBoxCoin " .. dataTable["strongBoxCoin"])
	return dataTable
end

--3.7.150保险箱存钱 (MANAGERID_SAVE_TAKE_STRONG_BOX_COIN)
function read80070096(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_SAVE_TAKE_STRONG_BOX_COIN
	dataTable["messageName"] = "MANAGERID_SAVE_TAKE_STRONG_BOX_COIN"
	--Result	Byte	操作结果	1成功，0失败
	dataTable["Result"] = nMBaseMessage:readByte()
	Common.log("read80070096 Result " .. dataTable["Result"])
	--Message	Text	操作结果提示
	dataTable["Message"] = nMBaseMessage:readString()
	Common.log("read80070096 Message " .. dataTable["Message"])
	--coin	Long	玩家手头金币数
	dataTable["coin"] = tonumber(nMBaseMessage:readLong())
	Common.log("read80070096 coin " .. dataTable["coin"])
	--strongBoxCoin	long	玩家保险箱内金币数
	dataTable["strongBoxCoin"] = tonumber(nMBaseMessage:readLong())
	Common.log("read80070096 strongBoxCoin " .. dataTable["strongBoxCoin"])
	return dataTable
end

--[[--
--3.7.164 小游戏列表V3(MANAGERID_MINIGAME_LIST_TYPE_V3)
--]]
function read800700a4(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + MANAGERID_MINIGAME_LIST_TYPE_V3
	dataTable["messageName"] = "MANAGERID_MINIGAME_LIST_TYPE_V3"

	--miniGameTimeStamp	Long	时间戳
	dataTable["miniGameTimeStamp"] = tonumber(nMBaseMessage:readLong());
	--Common.log("read800700a4 miniGameTimeStamp == " .. dataTable["miniGameTimeStamp"])

	--miniGameList	Loop		Loop	int	昵称数量	loop
	local miniGameCnt = tonumber(nMBaseMessage:readInt())
	dataTable["miniGameList"] = {}
	--Common.log("read800700a4 miniGameCnt == " .. miniGameCnt)
	for i = 1, miniGameCnt do
		dataTable["miniGameList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()
		--……MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["miniGameList"][i].MiniGameID = tonumber(nMBaseMessage:readInt());
		--Common.log("read800700a4 dataTable[miniGameList][i].MiniGameID ===== "..dataTable["miniGameList"][i].MiniGameID);
		--…MiniGameIconUrl	Text	小游戏的图标
		dataTable["miniGameList"][i].MiniGameIconUrl = nMBaseMessage:readString();
		--Common.log("read800700a4 dataTable[miniGameList][i].MiniGameIconUrl ===== "..dataTable["miniGameList"][i].MiniGameIconUrl);
		--…MiniGamePackage	Text	小游戏的包名
		dataTable["miniGameList"][i].MiniGamePackage = nMBaseMessage:readString();
		--Common.log("小游戏的包名 MiniGamePackage ======= "..dataTable["miniGameList"][i].MiniGamePackage);
		nMBaseMessage:setReadPos(pos + length)
	end
	--typeList	Loop		Loop
	local typeCnt = tonumber(nMBaseMessage:readInt())
	dataTable["typeList"] = {}
	--Common.log("read800700a4 typeCnt == " .. typeCnt)
	for i = 1, typeCnt do
		dataTable["typeList"][i] = {}
		local length = nMBaseMessage:readShort()
		local pos = nMBaseMessage:getReadPos()

		--…MiniGameID	Int		转盘ID：101 老虎机ID：102 金皇冠ID：103
		dataTable["typeList"][i].MiniGameID = tonumber(nMBaseMessage:readInt());
		--Common.log("read800700a4 dataTable[typeList][i].MiniGameID ===== "..dataTable["typeList"][i].MiniGameID);
		--…MiniGameState	byte	小游戏显示状态	不显示：0 显示不带锁：1 显示带锁：2
		dataTable["typeList"][i].MiniGameState = nMBaseMessage:readByte();
		--Common.log("read800700a4 dataTable[typeList][i].MiniGameState ===== "..dataTable["typeList"][i].MiniGameState);
		--…StateMsgTxt	text	用户点击后的toast	带锁时有意义
		dataTable["typeList"][i].StateMsgTxt = nMBaseMessage:readString();
		--Common.log("read800700a4 dataTable[typeList][i].StateMsgTxt ===== "..dataTable["typeList"][i].StateMsgTxt);

		nMBaseMessage:setReadPos(pos + length)
	end

	return dataTable
end

--[[--
--3.4.9推送断线续玩通知(GAMEID_SYNC_TABLE)
--]]
function read80040009(nMBaseMessage)
	local dataTable = {}
	dataTable["messageType"] = ACK + GAMEID_SYNC_TABLE;
	dataTable["messageName"] = "GAMEID_SYNC_TABLE";

	--miniGameID	Int	小游戏游戏id
	dataTable["miniGameID"] = tonumber(nMBaseMessage:readInt());
	--miniGamePackage	String	小游戏包名	miniGamePackage
	dataTable["miniGamePackage"] = nMBaseMessage:readString();

	return dataTable
end