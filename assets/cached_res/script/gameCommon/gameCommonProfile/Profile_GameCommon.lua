module(..., package.seeall)


local ReTimeLimit_INFO_Table = {} --限时礼包信息
local SendBugleTable = {} --发送大喇叭
local BugleTable = {} --大喇叭table
local StrongBoxInfoTable = {} --保险箱info
local SaveCoinTable = {} --存取钱table
--[[--
--读取限时礼包消息
--]]
function readGIFTBAGID_PUSH_LIMITED_GIFTBAG(dataTable)
	ReTimeLimit_INFO_Table = dataTable
	framework.emit(GIFTBAGID_PUSH_LIMITED_GIFTBAG)
end

--获取限时礼包倒计时时间--
function getReTimeLimitValue()
	return ReTimeLimit_INFO_Table["RemainTime"]
end

--限时礼包类型--
function getGiftType()
	return ReTimeLimit_INFO_Table["GiftType"]
end

--发送大喇叭消息
function readOPERID_MGR_SEND_BUGLE(dataTable)
	SendBugleTable = dataTable
	framework.emit(OPERID_MGR_SEND_BUGLE)
end

--获取发送大喇叭结果
function getSendBugleTable()
	return SendBugleTable
end

function readOPERID_SEND_ALL_BUGLE(dataTable)
	Common.log("readOPERID_SEND_ALL_BUGLE 1")
	local bugle = dataTable
	Common.log("readOPERID_SEND_ALL_BUGLE 2")
	if bugle ~= nil and bugle.NickName ~= nil and bugle.Message ~= nil then
		Common.log("readOPERID_SEND_ALL_BUGLE 3")
		table.insert(BugleTable,dataTable)
	end
	Common.log("readOPERID_SEND_ALL_BUGLE 4")
	framework.emit(OPERID_SEND_ALL_BUGLE)
	Common.log("readOPERID_SEND_ALL_BUGLE 5")
end

function getBugleTable()
	return BugleTable
end

function getOneBugle()
	local bugle = nil
	if BugleTable ~= nil and #BugleTable > 0 then
		bugle = BugleTable[1]
--		table.remove(BugleTable, 1);
	end
	return bugle
end

function removeOneBugle()
	if BugleTable ~= nil and #BugleTable > 0 then
		table.remove(BugleTable, 1);
	end
end

--保险箱info
function readMANAGERID_STRONG_BOX_INFO(dataTable)
	StrongBoxInfoTable = dataTable
	framework.emit(MANAGERID_STRONG_BOX_INFO)
end

--获取保险箱info
function getStrongBoxInfoTable()
	return StrongBoxInfoTable
end

--保险箱存取款
function readMANAGERID_SAVE_TAKE_STRONG_BOX_COIN(dataTable)
	SaveCoinTable = dataTable
	framework.emit(MANAGERID_SAVE_TAKE_STRONG_BOX_COIN)
end

--获取保险箱存取款table
function getSaveCoinTable()
	return SaveCoinTable
end


registerMessage(GIFTBAGID_PUSH_LIMITED_GIFTBAG, readGIFTBAGID_PUSH_LIMITED_GIFTBAG)--限时礼包
registerMessage(OPERID_MGR_SEND_BUGLE, readOPERID_MGR_SEND_BUGLE)--发送大喇叭
registerMessage(OPERID_SEND_ALL_BUGLE, readOPERID_SEND_ALL_BUGLE)--大喇叭推送
registerMessage(MANAGERID_STRONG_BOX_INFO, readMANAGERID_STRONG_BOX_INFO)--保险箱数据
registerMessage(MANAGERID_SAVE_TAKE_STRONG_BOX_COIN, readMANAGERID_SAVE_TAKE_STRONG_BOX_COIN)--保险箱数据