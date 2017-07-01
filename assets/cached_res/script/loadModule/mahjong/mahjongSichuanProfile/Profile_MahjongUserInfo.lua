module(..., package.seeall)

local userInfoTable = {}--个人信息消息
local sendMagicEmotionTable = {}--赠送魔法表情

local flyGiftBroadcastTable = {}--斗牛牌桌飞礼物消息

--互动表情动画集
--普通
Tpye_Flower = 1--1鲜花
Tpye_Kiss = 2--2亲吻
Tpye_Tomato = 3--3西红柿
Tpye_Bomb = 4--4炸弹
Tpye_Shit = 5--5大便
Tpye_Gun = 6--6机枪

GIFT_TYPE_FLOWER = 1
GIFT_TYPE_CAR = 2
GIFT_TYPE_HOUSE = 3
GIFT_TYPE_YACHT = 4

SEND_GIFT = 1 --送礼物
INTERACTION = 2 --互动表情
KICK_OUT = 3 --踢人

--0=未知，1=男，2=女
SECRECY = 0 --保密
MALE = 1 -- 男
FEMALE = 2 -- 女

function getUserID()
	local UserID = userInfoTable["UserID"]
	if UserID ~= nil then
		return UserID
	end
	return ""
end

function getUserCoin()
	local Coin = userInfoTable["Coin"]
	if Coin == nil then
		return ""
	end
	return Coin
end

--[[--
--查看个人信息消息
--]]
local function readMJ_SC_MGR_PLAYER_INFO_IN_TABLE(dataTable)
	userInfoTable = dataTable

	framework.emit(MJ_SC_MGR_PLAYER_INFO_IN_TABLE)
end
--[[--
--获取查看个人信息消息
--]]
function getUserInfoTable()
	return userInfoTable
end

--[[--
--赠送魔法表情
--]]
local function readMJ_SC_SEND_MAGIC(dataTable)
	sendMagicEmotionTable = dataTable
	framework.emit(MJ_SC_SEND_MAGIC)
end
--[[--
--获取赠送魔法表情
--]]
function getSendMagicEmotionTable()
	return sendMagicEmotionTable
end


--[[--
--牌桌飞礼物消息
--]]
local function readMJ_SC_BROADCAST_FLY_GIFT(dataTable)
	flyGiftBroadcastTable = dataTable
	framework.emit(MJ_SC_BROADCAST_FLY_GIFT)
end
--[[--
--获取牌桌飞礼物消息
--]]
function getFlyGiftBroadcastTable()
	return flyGiftBroadcastTable
end



registerMessage(MJ_SC_MGR_PLAYER_INFO_IN_TABLE, readMJ_SC_MGR_PLAYER_INFO_IN_TABLE) --查看个人信息
registerMessage(MJ_SC_SEND_MAGIC, readMJ_SC_SEND_MAGIC) --赠送魔法表情
registerMessage(MJ_SC_BROADCAST_FLY_GIFT, readMJ_SC_BROADCAST_FLY_GIFT) --牌桌飞礼物消息
