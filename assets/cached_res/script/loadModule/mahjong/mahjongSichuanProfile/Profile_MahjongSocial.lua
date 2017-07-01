module(..., package.seeall)


local TableChat = {}--牌桌聊天


--[[--
--牌桌聊天
--]]
local function readMJ_SC_ROOM_CHAT(dataTable)
	TableChat = dataTable;
	framework.emit(MJ_SC_ROOM_CHAT);
end

--[[--
--获取牌桌聊天数据
--]]
function getTableChat()
	return TableChat;
end


registerMessage(MJ_SC_ROOM_CHAT, readMJ_SC_ROOM_CHAT) --聊天