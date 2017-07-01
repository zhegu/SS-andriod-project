module("RecordConfig",package.seeall)

local AllRecordList = {}--牌局记录列表
local RecordListMax = 300--最多的记录局数

local RecordFileName = nil;

--牌局记录数据
RecordInfo = {
	RecordInfoName = "",--记录文件名(以时间为文件名)

	actions = {},--动作序列
}

--[[--
--获取录像文件名(录像ID)
--]]
function getRecordFileName()
	return RecordFileName;
end

--[[--
--重置牌局记录
--]]
function resetRecordInfo()

	Common.log("resetRecordInfo ============ 重置牌局记录")
	RecordFileName = nil;

	RecordInfo = {
		RecordInfoName = "",--记录文件名(以时间为文件名)

		actions = {},--动作序列
	}
end

--[[--
--读取牌局记录数据
--]]
function loadRecordInfo(RecordInfoName)
	local Info = Common.LoadCommonStoreTable(RecordInfoName, RecordConsole.getRecordFileDir());
	if Info ~= nil then
		RecordFileName = RecordInfoName;
		RecordInfo = Info;
		Common.log("RecordInfo.MiniGameID ======== "..RecordInfo.MiniGameID);
		Common.log("RecordInfo.MiniGamePackage ======== "..RecordInfo.MiniGamePackage);
		return true;
	else
		Common.log("loadRecordInfo 读取牌局记录数据 Info ==== nil");
	end
	return false;
end

--[[--
--加载用户牌局记录列表
--]]
function loadUserAllRecordList()
--清除录像列表数据
--	cleanAllRecordList()
--
--	if AllRecordList ~= nil and #AllRecordList > 0 then
--		return;
--	end
--
--	local list = Common.LoadCommonStoreTable(UserRecordName .. profile.User.getSelfUserID(), RecordDir);
--	if list ~= nil then
--		AllRecordList = list;
--	end
end

function getAllRecordList()
	return AllRecordList;
end

function cleanAllRecordList()
	AllRecordList = {};
end
