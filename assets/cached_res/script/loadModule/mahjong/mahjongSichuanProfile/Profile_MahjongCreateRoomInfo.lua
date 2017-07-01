module(..., package.seeall)

local createRoomInfoTable = {}
local createRoomResultTable = {}
local enterRoomTable = {}

local dismissRoomReq = {}--申请解散房间数据
local dismissRoomVote = {}--申请解散房间投票数据
local DistanceWarningData = {}--距离警报

--[[--
--创建房间界面信息
--]]
local function readMJ_SC_MGR_CREATE_OPTION(dataTable)
	createRoomInfoTable = dataTable
	framework.emit(MJ_SC_MGR_CREATE_OPTION)
end

function getCreateRoomInfoTable()
	return createRoomInfoTable
end

--[[--
--创建房间消息确认
--]]
local function readMJ_SC_MGR_CREATE_ROOM(dataTable)
	createRoomResultTable = dataTable
	framework.emit(MJ_SC_MGR_CREATE_ROOM)
end

function getCreateRoomResultTable()
	return createRoomResultTable
end

--[[--
--创建房间消息确认
--]]
local function readMJ_SC_MGR_ENTER_ROOM(dataTable)
	enterRoomTable = dataTable
	framework.emit(MJ_SC_MGR_ENTER_ROOM)
end

function getEnterRoomTable()
	return enterRoomTable
end



--[[--
--解散房间申请
--]]
local function readMJ_SC_GAME_DISMISS_ROOM(dataTable)
	dismissRoomReq = dataTable;
	framework.emit(MJ_SC_GAME_DISMISS_ROOM);
end

--[[--
--获取解散房间申请数据
--]]
function getDismissRoomReqTable()
	return dismissRoomReq
end

--[[--
--解散房间投票
--]]
local function readMJ_SC_GAME_DISMISS_VOTE(dataTable)
	dismissRoomVote = dataTable;
	framework.emit(MJ_SC_GAME_DISMISS_VOTE);
end

--[[--
--获取解散房间投票数据
--]]
function getDismissRoomVoteTable()
	return dismissRoomVote
end


--[[--
--距离警报
--]]
local function readMJ_SC_DISTANCE_ALERT(dataTable)
	DistanceWarningData = dataTable;
	framework.emit(MJ_SC_DISTANCE_ALERT);
end

--[[--
--获取距离警报数据
--]]
function getDistanceWarningData()
	return DistanceWarningData;
end

registerMessage(MJ_SC_MGR_CREATE_ROOM , readMJ_SC_MGR_CREATE_ROOM);  --创建房间
registerMessage(MJ_SC_MGR_ENTER_ROOM , readMJ_SC_MGR_ENTER_ROOM); --进入房间
registerMessage(MJ_SC_MGR_CREATE_OPTION , readMJ_SC_MGR_CREATE_OPTION); --房间选项

registerMessage(MJ_SC_GAME_DISMISS_ROOM, readMJ_SC_GAME_DISMISS_ROOM) --解散房间申请
registerMessage(MJ_SC_GAME_DISMISS_VOTE, readMJ_SC_GAME_DISMISS_VOTE) --解散房间投票
registerMessage(MJ_SC_DISTANCE_ALERT, readMJ_SC_DISTANCE_ALERT) --距离警报