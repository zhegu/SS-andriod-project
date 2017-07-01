--存放用户信息,位于牌桌第二层
module("MahjongTablePlayerLayer", package.seeall)

local TablePlayerLayer = nil--存放牌桌上展示的牌

local dingQueNode = nil --定缺

--[[--
--创建纸牌层
]]
local function creatTablePlayerLayer()
	TablePlayerLayer = CCLayer:create();
	TablePlayerLayer:setZOrder(1);

	initTablePlayerLayer();
end

--[[--
--获取纸牌层
--]]
function getTablePlayerLayer()
	if TablePlayerLayer == nil then
		creatTablePlayerLayer()
	end
	return TablePlayerLayer;
end

function initTablePlayerLayer()

end

--[[--
--牌桌头像下载回调
--]]
function updatePlayerPhoto(path)
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
	if photoPath ~= nil and photoPath ~= "" and MahjongTableConsole.mPlayers[tonumber(id)] ~= nil then
		Common.log("photoPath === "..photoPath)
		Common.log("id === "..id)
		MahjongTableConsole.mPlayers[tonumber(id)]:setPhoto(photoPath)
	end
end

--[[--
--添加用户
--]]
function addMahjongTablePlayer(SeatID)
	local player = MahjongTableConsole.mPlayers[SeatID + 1];
	if player == nil then
		return;
	end
	--	player:setVip(player.mVipLevel);
	Common.log("addMahjongTablePlayer mNickName == "..player.mNickName)
	player:setPromptLabel(player.mNickName, 253, 243, 207, 19);
	player:setScoreLable(player.mScore);
	player:updatePlayerPos(player.m_nPos + 1);

	Common.log("player.m_nPos ============= "..player.m_nPos)
	player.PlayerSprite:setPosition(MahjongTableConfig.playerPhotoBGXY[player.m_nPos + 1][1], MahjongTableConfig.playerPhotoBGXY[player.m_nPos + 1][2]);
	TablePlayerLayer:addChild(player.PlayerSprite);

end


--[[--
--更新用户数据
--@param #number SeatID 座位号
--]]
function updateTablePlayerInfo(SeatID)
	local player = MahjongTableConsole.mPlayers[SeatID + 1];
	if player ~= nil then
		--筹码数
		player:setScoreLable(player.mScore);
		player:setIsOfflineState(player.mIsOffline);
	end
end

--[[--
--更新用户状态
--@param #number SeatID 座位号
--]]
function updateTablePlayerState(SeatID)
	local player = MahjongTableConsole.mPlayers[SeatID + 1];
	if player ~= nil and SeatID ~= MahjongTableConsole.getSelfSeat() then
		Common.log("updateTablePlayerState SeatID == "..SeatID)
		Common.log("updateTablePlayerState getSelfSeat == "..MahjongTableConsole.getSelfSeat())
		Common.log("updateTablePlayerState m_nPos == "..player.m_nPos)
		MahjongTableArmature.removePlayerXuanPaiAnim(player.m_nPos + 1)
		MahjongTableArmature.removePlayerDingQueAnim(player.m_nPos + 1)
		player:hideGameState()

		if MahjongTableConsole.mTableStatus == MahjongTableConsole.STAT_WAITING_READY then
			if player.mIsReady == 1 then
				--用户是否准备 0否 1是
				player:setGameState("MJ_table_fnt_yizhunbei.png", player.m_nPos + 1)
			end
		end
		if MahjongTableConsole.mTableStatus == MahjongTableConsole.STAT_DING_QUE then
			if player.mDingQueColor == -1 then
				--用户定缺状态 -1没定缺 -2已定缺，不广播 0万，1筒，2条
				MahjongTableArmature.showPlayerDingQueAnim(player.m_nPos + 1)
			elseif player.mDingQueColor == -2 then
				player:setGameState("MJ_table_fnt_yidingque.png", player.m_nPos + 1)
			end
		end
		if MahjongTableConsole.mTableStatus == MahjongTableConsole.STAT_CHANGE_CARD then
			if player.mIsSendChangeCard == 0 then
				--用户上行换三张状态 0否 1是
				MahjongTableArmature.showPlayerXuanPaiAnim(player.m_nPos + 1)
			elseif player.mIsSendChangeCard == 1 then
				player:setGameState("MJ_table_fnt_yixuanpai.png", player.m_nPos + 1)
			end
		end
	end
end

--显示用户定缺标志
function showDingQue(SeatId, QuePaiType)
	if QuePaiType < 0 then
		--没有定缺状态
		return
	end

	if dingQueNode == nil then
		dingQueNode = CCSprite:create(MahjongTableConfig.getResPath("table0.png"))
		dingQueNode:setPosition(ccp(0,0))
		TablePlayerLayer:addChild(dingQueNode)
		dingQueNode:setZOrder(2);
	end

	local PlayerPos = MahjongTableConsole.getPlayerPosBySeat(SeatId);
	local sprite = nil
	if QuePaiType == 0 then
		--0万
		sprite = CCSprite:createWithSpriteFrameName("MJ_use_Table_button_headframe_cover_wan.png");
	elseif QuePaiType == 1 then
		--1桶
		sprite = CCSprite:createWithSpriteFrameName("MJ_use_Table_button_headframe_cover_tong.png");
	elseif QuePaiType == 2 then
		--2条
		sprite = CCSprite:createWithSpriteFrameName("MJ_use_Table_button_headframe_cover_tiao.png");
	end
	sprite:setPosition(MahjongTableConfig.DingQueXY[PlayerPos + 1][1], MahjongTableConfig.DingQueXY[PlayerPos + 1][2])
	dingQueNode:addChild(sprite);
end

-- 玩家聊天消息返回后更新界面
function updateTableAfterPlayerChatServerBack(seatId, nickName, type, message)
	--	if result == 0 then
	--		Common.showToast(message, 2)
	--		return
	--	end
	Common.log("updateTableAfterPlayerChatServerBack msg == "..message.."  type== "..type)
	if seatId ~= nil and seatId > 0 then
	--坐下玩家显示气泡
	end
	if type == MahjongTableConfig.TYPE_CHAT_TEXT then
		--文字
		--		MahjongTableChat.checkAndPlayerChatSound(seatId, message)
		MahjongTableChat.showChatText(seatId, message)
		MahjongTableChat.addHistoryChat(nickName, message)
	elseif type == MahjongTableConfig.TYPE_CHAT_EMOTION then
		--表情
		local index = tonumber(message)
		MahjongTableChat.playChatCommonEmotion(seatId, index)
		--		MahjongTableChat.checkAndPlayCommonSound(index)
	end
end

--[[--
--每局结束，重置用户的牌桌基本信息
--]]--
function resetPlayerTableState()
	for key, player in pairs(MahjongTableConsole.mPlayers) do
		if player ~= nil then
			player.mDingQueColor = -3; --用户定缺状态 -1没定缺 -2已定缺，不广播 0万，1筒，2条
			player.mIsSendChangeCard = -1; --用户上行换三张状态 0否 1是
			player.mIsReady = -1; --用户是否准备 0否 1是

			local seatID = player.mSeatID
			updateTablePlayerInfo(seatID)
			updateTablePlayerState(seatID)
		end
	end

	if dingQueNode ~= nil then
		dingQueNode:removeFromParentAndCleanup(true);
		dingQueNode = nil;
	end
end

--[[--
--根据位置设置牌桌上用户头像是否可点击
--]]
function setPlayerLayerTouchEnabledByPos(pos, isTouchEnabled)
	for key, player in pairs(MahjongTableConsole.mPlayers) do
		if player ~= nil and player.m_nPos == pos then
			player:setPhotoEnabled(isTouchEnabled);
			break;
		end
	end
end

--[[--
--设置牌桌上所有用户头像是否可点击
--]]
function setPlayerLayerTouchEnabled(isTouchEnabled)
	if isTouchEnabled then
		Common.log("setPlayerLayerTouchEnabled true true")
	else
		Common.log("setPlayerLayerTouchEnabled false false")
	end
	for key, player in pairs(MahjongTableConsole.mPlayers) do
		if player ~= nil then
			player:setPhotoEnabled(isTouchEnabled);
		end
	end
end

--[[--
--清空牌桌上的牌
--]]
function removeAllCards()

end

--[[--
--删除层
--]]
function reomveAllTablePlayerLayer()

	TablePlayerLayer:removeFromParentAndCleanup(true);
	TablePlayerLayer = nil
	dingQueNode = nil
end
