--麻将扑克配置文件
module("MahjongConfig",package.seeall)

--层级管理
--牌桌界面
ModuleTable["MahjongTable"] = {}
ModuleTable["MahjongTable"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/table/controller/MahjongTableController"
ModuleTable["MahjongTable"]["layer"] = "base_layer"
--牌桌结算
ModuleTable["MahjongGameResult"] = {}
ModuleTable["MahjongGameResult"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongGameResultController"
ModuleTable["MahjongGameResult"]["layer"] = "second_layer"

--tableDialog
--公共弹框
ModuleTable["CommonDialog"] = {}
ModuleTable["CommonDialog"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/CommonDialogController"
ModuleTable["CommonDialog"]["layer"] = "third_layer"
--房间总结算
ModuleTable["MahjongRoomTotalResult"] = {}
ModuleTable["MahjongRoomTotalResult"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongRoomTotalResultController"
ModuleTable["MahjongRoomTotalResult"]["layer"] = "second_layer"
--解散房间申请
ModuleTable["MahjongDismissRoomRequest"] = {}
ModuleTable["MahjongDismissRoomRequest"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongDismissRoomRequestController"
ModuleTable["MahjongDismissRoomRequest"]["layer"] = "second_layer"
--解散房间被拒
ModuleTable["MahjongRefuseDismissRoom"] = {}
ModuleTable["MahjongRefuseDismissRoom"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongRefuseDismissRoomController"
ModuleTable["MahjongRefuseDismissRoom"]["layer"] = "second_layer"
--牌桌外个人信息
ModuleTable["MahjongTableUserInfo"] = {}
ModuleTable["MahjongTableUserInfo"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongTableUserInfoController"
ModuleTable["MahjongTableUserInfo"]["layer"] = "second_layer"
--聊天
ModuleTable["MahjongChatPop"] = {}
ModuleTable["MahjongChatPop"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongChatPopController"
ModuleTable["MahjongChatPop"]["layer"] = "second_layer"
--游戏内设置
ModuleTable["MahjongTableSetting"] = {}
ModuleTable["MahjongTableSetting"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/tableDialog/controller/MahjongTableSettingController"
ModuleTable["MahjongTableSetting"]["layer"] = "second_layer"

--创建房间
ModuleTable["CreateRoom"] = {}
ModuleTable["CreateRoom"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/createroom/controller/CreateRoomController"
ModuleTable["CreateRoom"]["layer"] = "second_layer"

ModuleTable["JoinRoom"] = {}
ModuleTable["JoinRoom"]["ControllerPath"] = "script/loadModule/mahjongSichuan/mahjongSichuanModule/createroom/controller/JoinRoomController"
ModuleTable["JoinRoom"]["layer"] = "second_layer"

local path = "script.loadModule.mahjongSichuan."

Load.LuaRequire(path .. "mahjongSichuanNetwork.MahjongLoadNetworkRequire");
Load.LuaRequire(path .. "mahjongSichuanProfile.MahjongLoadProfileRequire");
Load.LuaRequire(path .. "mahjongSichuanModule.MahjongModuleRequire");
Load.LuaRequire(path .. "LaunchMahjongSichuan");

MahjongSichuanGameID = 109;
MahjongSichuanPackage = "mahjongSichuan";
MahjongGameVersion = "1.00" --Common.getScriptVerCode()

local unpauseMessageList = {
		0x80570015,--麻将解散房间申请
		0x80570016,--麻将解散房间投票
    }

--[[--
--获取麻将牌桌不暂停消息
--]]
function getMahjongUnpauseMessageList()
	return unpauseMessageList;
end


--添加麻将不暂停的消息
GameCommonProfile.ServerList.addUnpauseServerList(getMahjongUnpauseMessageList());

function addCommonSpriteFrames()
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_co.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_ninepai.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("ingame_infomation.plist"));
end

--[[--
--删除公共资源的plist、碎图
--]]
local function removeCommonSpriteFrames()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_co.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_ninepai.plist"));
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("ingame_infomation.plist"));
end

--[[--
--删除所有的plist大图
--]]
local function removeUITextureCache()
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getCardResPath("MJ_HandCardsTPlist.pvr.ccz"))

	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_co.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_ninepai.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("mj_table.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_prepare.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_tanchuang.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_video.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("mj_element.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_infomation.pvr.ccz"))

	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("create.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("MJ_join.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_talk.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_result.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(MahjongTableConfig.getResPath("ingame_setting.pvr.ccz"))
end

--[[--
--删除所有资源
--]]
function removeAllMahjongTextureCache()
	removeCommonSpriteFrames();

	removeUITextureCache();
	--清除动画缓存
	MahjongTableArmature.clearTableAnim();
end

removeAllMahjongTextureCache();