module("HallModeConfig",package.seeall)

local hallShowMode = 0 --当前大厅显示模式
local JinHuaHallShowMode = 0 --当前金花大厅显示模式

--[[--
-- 获取当前大厅显示模式
]]
function getHallShowMode()
	return hallShowMode
end

--[[--
-- 设置当前大厅显示模式
]]
function setHallShowMode(ShowMode)
	hallShowMode = ShowMode
end

--[[--
-- 获取金花大厅显示模式
]]
function getJinHuaHallShowMode()
	return JinHuaHallShowMode
end

--[[--
-- 设置金花大厅显示模式
]]
function setJinHuaHallShowMode(ShowMode)
	JinHuaHallShowMode = ShowMode
end

local hallTableState = 1 --显示当前的选择状态

--[[--
-- 获取当前的选择状态
]]
function getHallTableState()
	Common.log("获取当前的选择状态hallTableState ==========  "..hallTableState)
	return hallTableState
end

--[[--
-- 设置当前的选择状态
]]
function setHallTableState(TableState)
	hallTableState = TableState
end

local hallRoomItem = 0 --房间类型

--[[--
-- 获取房间类型
]]
function getHallRoomItem()
	return hallRoomItem
end

--[[--
--设置房间类型
]]
function setHallRoomItem(RoomItem)
	hallRoomItem = RoomItem
end
