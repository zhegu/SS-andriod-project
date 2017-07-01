module("CreateRoomConfig", package.seeall)


--[[--
--创建房间
--]]
local function slot_MJ_SC_MGR_CREATE_OPTION()
	mvcEngine.createModule(GUI_CREATEROOM)
end

framework.addSlot2Signal(MJ_SC_MGR_CREATE_OPTION, slot_MJ_SC_MGR_CREATE_OPTION, true)