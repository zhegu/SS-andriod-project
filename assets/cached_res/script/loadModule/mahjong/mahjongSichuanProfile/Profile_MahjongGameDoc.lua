module(..., package.seeall)

local TableEnterRoom = {}--进房间数据
local TableReadData = {}--准备数据
local TableChange = {}--牌桌变化数据
local TableInitCard = {}--发牌数据
local TableDisCard = {}--出牌数据
local TableSendActionOptiond = {}--操作询问数据
local TableSelectActionOptiond = {}--操作碰/杠/胡/过牌数据
local TableDealCard = {}--推送发一张牌【摸牌】数据
local TableActionBroadcast = {}--广播操作结果数据
local TableSendChangeCard = {}--提示玩家选择换三张数据
local TableSelectChangeCard = {}--换三张数据
local TableChangeCardBrodcast = {}--换三张结果数据
local TableSendDingQue = {}--提示玩家选择定缺数据
local TableSelectDingQue = {}--玩家定缺数据
local TableDingQueBroadcast = {}--广播定缺结果数据
local TableTingSolutions = {}--听牌方案列表数据
local TableStatusChange = {}--听牌状态变更数据
local GameResult = {}--游戏结果数据
local TableReconnectNotify = {}--续玩通知数据
local GameSync = {};--牌桌同步数据
local TableHuResultBroadcast = {}--胡牌广播数据
local TableSyncHandCards = {};--同步手牌数据
local RoomTotalResult = {}--房间总结果数据
local PushPlayerState = {}--推送用户状态数据

local QuitRoomTable = {}--退牌桌数据

local isGameSync = false;--是否已经断线续玩

--[[--
--获取是否已经断线续玩
--]]
function getIsGameSync()
	return isGameSync;
end

--[[--
--设置是否已经断线续玩
--]]
function setIsGameSync(isSync)
	isGameSync = isSync;
end

--[[--
--获取进房间数据
--]]
function getEnterRoomTable()
	return TableEnterRoom;
end

--[[--
--获取牌桌变化数据
--]]
function getTableChangeTable()
	return TableChange;
end

--[[--
--获取准备数据
--]]
function getReadDataTable()
	return TableReadData;
end

--[[--
--获取发牌数据
--]]
function getInitCardTable()
	return TableInitCard
end

--[[--
--获取出牌数据
--]]
function getDisCardTable()
	return TableDisCard;
end

--[[--
--获取操作询问数据
--]]
function getSendActionOptiondTable()
	return TableSendActionOptiond;
end

--[[--
--获取操作碰/杠/胡/过牌数据
--]]
function getSelectActionOptiondTable()
	return TableSelectActionOptiond;
end

--[[--
--获取发一张牌【摸牌】数据
--]]
function getDealCardTable()
	return TableDealCard;
end

--[[--
--获取广播操作结果数据
--]]
function getActionBroadcastTable()
	return TableActionBroadcast;
end

--[[--
--获取提示玩家选择换三张数据
--]]
function getSendChangeCardTable()
	return TableSendChangeCard;
end

--[[--
--获取换三张数据
--]]
function getSelectChangeCardTable()
	return TableSelectChangeCard;
end

--[[--
--获取换三张结果数据
--]]
function getChangeCardBrodcastTable()
	return TableChangeCardBrodcast;
end

--[[--
--获取提示玩家选择定缺数据
--]]
function getSendDingQueTable()
	return TableSendDingQue;
end

--[[--
--获取玩家定缺数据
--]]
function getSelectDingQueTable()
	return TableSelectDingQue;
end

--[[--
--获取广播定缺结果数据
--]]
function getDingQueBroadcastTable()
	return TableDingQueBroadcast;
end

--[[--
--获取听牌方案列表数据
--]]
function getTingSolutionsTable()
	return TableTingSolutions;
end

--[[--
--获取听牌状态变更数据
--]]
function getStatusChangeTable()
	return TableStatusChange;
end

--[[--
--获取游戏结果数据
--]]
function getGameResultTable()
	return GameResult
end

--[[--
--获取续玩通知数据
--]]
function getReconnectNotifyTable()
	return TableReconnectNotify;
end

--[[--
--获取牌桌同步数据
--]]
function getGameSyncTable()
	return GameSync;
end

--[[--
--获取同步手牌数据
--]]
function getSyncHandCardsTable()
	return TableSyncHandCards;
end

--[[--
--获取胡牌结束广播数据
--]]
function getHuResultBroadcastTable()
	return TableHuResultBroadcast;
end

--[[--
--获取房间总结果数据
--]]
function getRoomTotalResultTable()
	return RoomTotalResult;
end

--[[--
--获取推送用户状态数据
--]]
function getPushPlayerStateTable()
	return PushPlayerState;
end

--[[--
--获取退出房间数据
--]]
function getQuitRoomTable()
	return QuitRoomTable
end

--local function readMJ_SC_ROOM_ENTER_ROOM(dataTable)
--	TableEnterRoom = dataTable;
--	framework.emit(MJ_SC_ROOM_ENTER_ROOM);
--end

--[[--
--麻将牌桌变化
--]]
local function readMJ_SC_GAME_TABLE_CHANGE(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	setIsGameSync(true);
	TableChange = dataTable;
	Common.log("framework.emit(MJ_SC_GAME_TABLE_CHANGE) ================== ")
	framework.emit(MJ_SC_GAME_TABLE_CHANGE);
end

--[[--
--准备
--]]
local function readMJ_SC_GAME_READY(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableReadData = dataTable;
	framework.emit(MJ_SC_GAME_READY);
end

--[[--
--发牌
--]]
local function readMJ_SC_GAME_SEND_CARD(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableInitCard = dataTable;
	framework.emit(MJ_SC_GAME_SEND_CARD);
end

--[[--
--出牌
--]]
local function readMJ_SC_GAME_DISCARD(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableDisCard = dataTable;

	framework.emit(MJ_SC_GAME_DISCARD);
end

--[[--
--操作询问
--]]
local function readMJ_SC_GAME_SEND_ACTION_OPTION(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSendActionOptiond = dataTable;
	framework.emit(MJ_SC_GAME_SEND_ACTION_OPTION);
end

--[[--
--操作碰/杠/胡/过牌
--]]
local function readMJ_SC_GAME_SELECT_ACTION_OPTION(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSelectActionOptiond = dataTable;
	framework.emit(MJ_SC_GAME_SELECT_ACTION_OPTION);
end

--[[--
--发一张牌【摸牌】
--]]
local function readMJ_SC_GAME_DEAL_CARD(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableDealCard = dataTable;

	framework.emit(MJ_SC_GAME_DEAL_CARD);
end

--[[--
--广播操作结果
--]]
local function readMJ_SC_GAME_ACTION_BROADCAST(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableActionBroadcast = dataTable;

	framework.emit(MJ_SC_GAME_ACTION_BROADCAST);
end

--[[--
--提示玩家选择换三张
--]]
local function readMJ_SC_GAME_SEND_CHANGE_CARD(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSendChangeCard = dataTable;
	framework.emit(MJ_SC_GAME_SEND_CHANGE_CARD);
end

--[[--
--选择换三张
--]]
local function readMJ_SC_GAME_SELECT_CHANGE_CARD(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSelectChangeCard = dataTable;
	framework.emit(MJ_SC_GAME_SELECT_CHANGE_CARD);
end

--[[--
--换三张结果
--]]
local function readMJ_SC_GAME_CHANGE_CARD_BROADCAST(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableChangeCardBrodcast = dataTable;
	framework.emit(MJ_SC_GAME_CHANGE_CARD_BROADCAST);
end

--[[--
--提示玩家选择定缺
--]]
local function readMJ_SC_GAME_SEND_DING_QUE(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSendDingQue = dataTable;
	framework.emit(MJ_SC_GAME_SEND_DING_QUE);
end

--[[--
--玩家定缺
--]]
local function readMJ_SC_GAME_SELECT_DING_QUE(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSelectDingQue = dataTable;
	framework.emit(MJ_SC_GAME_SELECT_DING_QUE);
end

--[[--
--广播定缺结果
--]]
local function readMJ_SC_GAME_DINGQUE_BROADCAST(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableDingQueBroadcast = dataTable;
	framework.emit(MJ_SC_GAME_DINGQUE_BROADCAST);
end

--[[--
--听牌方案列表
--]]
local function readMJ_SC_GAME_TING_SOLUTIONS(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableTingSolutions = dataTable;
	framework.emit(MJ_SC_GAME_TING_SOLUTIONS);
end

--[[--
--听牌状态变更
--]]
local function readMJ_SC_GAME_TING_STATUS_CHANGED(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableStatusChange = dataTable;
	framework.emit(MJ_SC_GAME_TING_STATUS_CHANGED);
end

--[[--
--游戏结果
--]]
local function readMJ_SC_GAME_GAME_RESULT(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	GameResult = dataTable;
	--	Common.SaveShareTable("GameResult"..Common.getTimeStamp(), GameResult, "record");
	framework.emit(MJ_SC_GAME_GAME_RESULT);
end

--[[--
--牌桌同步
--]]
local function readMJ_SC_GAME_SYNC_TABLE(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	setIsGameSync(true);
	GameSync = dataTable;
	framework.emit(MJ_SC_GAME_SYNC_TABLE);
end

--[[--
--同步自己的手牌
--]]
local function readMJ_SC_GAME_SYNC_HAND_CARDS(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableSyncHandCards = dataTable;
	framework.emit(MJ_SC_GAME_SYNC_HAND_CARDS);
end

--[[--
--胡牌结果广播
--]]
local function readMJ_SC_GAME_HU_RESULT_BROADCAST(dataTable)
	local gameTimeStamp = dataTable["TimeStamp"] --进入牌桌或本局开始的时间
	local messageName = dataTable["messageName"];
	if not MahjongMessageVerify.messageIsLegal(gameTimeStamp, messageName) then
		return;
	end
	TableHuResultBroadcast = dataTable;
	framework.emit(MJ_SC_GAME_HU_RESULT_BROADCAST);
end

--[[--
--游戏总结果
--]]
local function readMJ_SC_GAME_ROOM_RESULT(dataTable)
	RoomTotalResult = dataTable;
	framework.emit(MJ_SC_GAME_ROOM_RESULT);
end

--[[--
--推送用户游戏状态
--]]
local function readMJ_SC_GAME_PUSH_PLAYER_STATE(dataTable)
	PushPlayerState = dataTable;
	framework.emit(MJ_SC_GAME_PUSH_PLAYER_STATE);
end


--[[--
--退出房间
--]]
local function readMJ_SC_MGR_QUIT_ROOM(dataTable)
	QuitRoomTable = dataTable;
	framework.emit(MJ_SC_MGR_QUIT_ROOM);
end

--registerMessage(MJ_SC_ROOM_ENTER_ROOM, readMJ_SC_ROOM_ENTER_ROOM)
registerMessage(MJ_SC_MGR_QUIT_ROOM, readMJ_SC_MGR_QUIT_ROOM)
registerMessage(MJ_SC_GAME_TABLE_CHANGE, readMJ_SC_GAME_TABLE_CHANGE)
registerMessage(MJ_SC_GAME_READY, readMJ_SC_GAME_READY)
registerMessage(MJ_SC_GAME_SEND_CARD, readMJ_SC_GAME_SEND_CARD)
registerMessage(MJ_SC_GAME_DISCARD, readMJ_SC_GAME_DISCARD)
registerMessage(MJ_SC_GAME_SEND_ACTION_OPTION, readMJ_SC_GAME_SEND_ACTION_OPTION)
registerMessage(MJ_SC_GAME_SELECT_ACTION_OPTION, readMJ_SC_GAME_SELECT_ACTION_OPTION)
registerMessage(MJ_SC_GAME_DEAL_CARD, readMJ_SC_GAME_DEAL_CARD)
registerMessage(MJ_SC_GAME_ACTION_BROADCAST, readMJ_SC_GAME_ACTION_BROADCAST)
registerMessage(MJ_SC_GAME_SEND_CHANGE_CARD, readMJ_SC_GAME_SEND_CHANGE_CARD)
registerMessage(MJ_SC_GAME_SELECT_CHANGE_CARD, readMJ_SC_GAME_SELECT_CHANGE_CARD)
registerMessage(MJ_SC_GAME_CHANGE_CARD_BROADCAST, readMJ_SC_GAME_CHANGE_CARD_BROADCAST)
registerMessage(MJ_SC_GAME_SEND_DING_QUE, readMJ_SC_GAME_SEND_DING_QUE)
registerMessage(MJ_SC_GAME_SELECT_DING_QUE, readMJ_SC_GAME_SELECT_DING_QUE)
registerMessage(MJ_SC_GAME_DINGQUE_BROADCAST, readMJ_SC_GAME_DINGQUE_BROADCAST)
registerMessage(MJ_SC_GAME_TING_SOLUTIONS, readMJ_SC_GAME_TING_SOLUTIONS)
registerMessage(MJ_SC_GAME_TING_STATUS_CHANGED, readMJ_SC_GAME_TING_STATUS_CHANGED)
registerMessage(MJ_SC_GAME_GAME_RESULT, readMJ_SC_GAME_GAME_RESULT)
registerMessage(MJ_SC_GAME_SYNC_TABLE, readMJ_SC_GAME_SYNC_TABLE)
registerMessage(MJ_SC_GAME_HU_RESULT_BROADCAST, readMJ_SC_GAME_HU_RESULT_BROADCAST)
registerMessage(MJ_SC_GAME_SYNC_HAND_CARDS, readMJ_SC_GAME_SYNC_HAND_CARDS)
registerMessage(MJ_SC_GAME_ROOM_RESULT, readMJ_SC_GAME_ROOM_RESULT) --房间总结算
registerMessage(MJ_SC_GAME_PUSH_PLAYER_STATE, readMJ_SC_GAME_PUSH_PLAYER_STATE) --推送用户状态

