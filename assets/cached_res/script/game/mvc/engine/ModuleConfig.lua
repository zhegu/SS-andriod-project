DESTORY_TYPE_CLEAN = 0
DESTORY_TYPE_EFFECT = 1

Layer = {
	["base_layer"] = 1,
	["second_layer"] = 2,
	["third_layer"] = 3,
	["fourth_layer"] = 4,
	["fifth_layer"] = 5,
	["sixth_layer"] = 6,
	["seventh_layer"] = 7,
	["eighth_layer"] = 8,
	["ninth_layer"] = 9
}

ModuleTable = {}

--appstore评价界面
ModuleTable["AppstoreRatings"] = {}
ModuleTable["AppstoreRatings"]["ControllerPath"] = "script/module/appstoreratings/controller/AppstoreRatingsController"
ModuleTable["AppstoreRatings"]["layer"] = "third_layer"

--登录界面
ModuleTable["Login"] = {}
ModuleTable["Login"]["ControllerPath"] = "script/module/login/controller/LoginController"
ModuleTable["Login"]["layer"] = "base_layer"

--大厅、房间比赛列表界面
ModuleTable["Hall"] = {}
ModuleTable["Hall"]["ControllerPath"] = "script/module/hall/controller/HallController"
ModuleTable["Hall"]["layer"] = "base_layer"

--更多用户界面
ModuleTable["More"] = {}
ModuleTable["More"]["ControllerPath"] = "script/module/login/controller/MoreController"
ModuleTable["More"]["layer"] = "third_layer"

--重置密码界面
ModuleTable["ResetPassword"] = {}
ModuleTable["ResetPassword"]["ControllerPath"] = "script/module/login/controller/ResetPasswordController"
ModuleTable["ResetPassword"]["layer"] = "second_layer"

--支付界面
ModuleTable["RechargeCenter"] = {}
ModuleTable["RechargeCenter"]["ControllerPath"] = "script/module/recharge/controller/RechargeCenterController"
ModuleTable["RechargeCenter"]["layer"] = "second_layer"

--月卡弹框
ModuleTable["MonthCard"] = {}
ModuleTable["MonthCard"]["ControllerPath"] = "script/module/recharge/controller/MonthCardController"
ModuleTable["MonthCard"]["layer"] = "second_layer"

--兑换金币list界面
ModuleTable["ConvertList"] = {}
ModuleTable["ConvertList"]["ControllerPath"] = "script/module/shop/controller/ConvertListController"
ModuleTable["ConvertList"]["layer"] = "base_layer"

--站内信
ModuleTable["MessageList"] = {}
ModuleTable["MessageList"]["ControllerPath"] = "script/module/message/controller/MessageListController"
ModuleTable["MessageList"]["layer"] = "second_layer"
ModuleTable["MessageServer"] = {}
ModuleTable["MessageServer"]["ControllerPath"] = "script/module/message/controller/MessageServerController"
ModuleTable["MessageServer"]["layer"] = "second_layer"

--用户协议
ModuleTable["UserAgreement"] = {}
ModuleTable["UserAgreement"]["ControllerPath"] = "script/module/login/controller/UserAgreementController"
ModuleTable["UserAgreement"]["layer"] = "second_layer"

--脚本更新提示框
ModuleTable["ScriptUpdata"] = {}
ModuleTable["ScriptUpdata"]["ControllerPath"] = "script/module/commondialog/controller/ScriptUpdataController"
ModuleTable["ScriptUpdata"]["layer"] = "third_layer"

--loading界面
ModuleTable["Loading"] = {}
ModuleTable["Loading"]["ControllerPath"] = "script/module/login/controller/LoadingController"
ModuleTable["Loading"]["layer"] = "base_layer"

--绑定手机界面
--ModuleTable["BindPhone"] = {}
--ModuleTable["BindPhone"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneController"
--ModuleTable["BindPhone"]["layer"] = "third_layer"
--
--ModuleTable["BindPhoneMsg"] = {}
--ModuleTable["BindPhoneMsg"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneMsgController"
--ModuleTable["BindPhoneMsg"]["layer"] = "third_layer"
ModuleTable["BindPhoneTip"] = {}
ModuleTable["BindPhoneTip"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneTipController"
ModuleTable["BindPhoneTip"]["layer"] = "third_layer"
ModuleTable["BindNotPhoneMsg"] = {}
ModuleTable["BindNotPhoneMsg"]["ControllerPath"] = "script/module/userinfo/controller/BindNotPhoneMsgController"
ModuleTable["BindNotPhoneMsg"]["layer"] = "third_layer"

--脚本更新
ModuleTable["LuaUpdate"] = {}
ModuleTable["LuaUpdate"]["ControllerPath"] = "script/module/scriptUpdate/controller/LuaUpdateController"
ModuleTable["LuaUpdate"]["layer"] = "third_layer"

--个人信息
ModuleTable["SelfUserInfo"] = {}
ModuleTable["SelfUserInfo"]["ControllerPath"] = "script/module/userinfo/controller/SelfUserInfoController"
ModuleTable["SelfUserInfo"]["layer"] = "second_layer"

--绑定手机
ModuleTable["BindPhone"] = {}
ModuleTable["BindPhone"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneController"
ModuleTable["BindPhone"]["layer"] = "third_layer"
ModuleTable["BindPhoneMsg"] = {}
ModuleTable["BindPhoneMsg"]["ControllerPath"] = "script/module/userinfo/controller/BindPhoneMsgController"
ModuleTable["BindPhoneMsg"]["layer"] = "third_layer"

--设置
ModuleTable["Setting"] = {}
ModuleTable["Setting"]["ControllerPath"] = "script/module/hall/controller/SettingController"
ModuleTable["Setting"]["layer"] = "second_layer"

--客服中心
ModuleTable["CustomService"] = {}
ModuleTable["CustomService"]["ControllerPath"] = "script/module/customservice/controller/CustomServiceController"
ModuleTable["CustomService"]["layer"] = "second_layer"

--游戏帮助
ModuleTable["GameHelp"] = {}
ModuleTable["GameHelp"]["ControllerPath"] = "script/module/customservice/controller/GameHelpController"
ModuleTable["GameHelp"]["layer"] = "second_layer"

--退出/切换账号
ModuleTable["AndroidExit"] = {}
ModuleTable["AndroidExit"]["ControllerPath"] = "script/module/hall/controller/AndroidExitController"
ModuleTable["AndroidExit"]["layer"] = "second_layer"

--微信绑定
ModuleTable["BindWechat"] = {}
ModuleTable["BindWechat"]["ControllerPath"] = "script/module/userinfo/controller/BindWechatController"
ModuleTable["BindWechat"]["layer"] = "second_layer"

--自建房间
ModuleTable["CreateRoomRuleSetting"] = {}
ModuleTable["CreateRoomRuleSetting"]["ControllerPath"] = "script/module/createRoom/controller/CreateRoomRuleSettingController"
ModuleTable["CreateRoomRuleSetting"]["layer"] = "second_layer"

ModuleTable["EnterRoom"] = {}
ModuleTable["EnterRoom"]["ControllerPath"] = "script/module/createRoom/controller/EnterRoomController"
ModuleTable["EnterRoom"]["layer"] = "second_layer"

ModuleTable["ContinueRoom"] = {}
ModuleTable["ContinueRoom"]["ControllerPath"] = "script/module/createRoom/controller/ContinueRoomController"
ModuleTable["ContinueRoom"]["layer"] = "second_layer"

ModuleTable["InvitationRoom"] = {}
ModuleTable["InvitationRoom"]["ControllerPath"] = "script/module/createRoom/controller/InvitationRoomController"
ModuleTable["InvitationRoom"]["layer"] = "second_layer"

ModuleTable["FriendRoom"] = {}
ModuleTable["FriendRoom"]["ControllerPath"] = "script/module/createRoom/controller/FriendRoomController"
ModuleTable["FriendRoom"]["layer"] = "second_layer"


--[[---------------------------------麻将------------------------------]]

--购买房卡
ModuleTable["BuyCard"] = {}
ModuleTable["BuyCard"]["ControllerPath"] = "script/module/buycard/controller/BuyCardController"
ModuleTable["BuyCard"]["layer"] = "second_layer"
--兑换房卡
ModuleTable["ExchangeRoomCard"] = {}
ModuleTable["ExchangeRoomCard"]["ControllerPath"] = "script/module/buycard/controller/ExchangeRoomCardController"
ModuleTable["ExchangeRoomCard"]["layer"] = "second_layer"

ModuleTable["InviteCode"] = {}
ModuleTable["InviteCode"]["ControllerPath"] = "script/module/recommend/controller/InviteCodeController"
ModuleTable["InviteCode"]["layer"] = "second_layer"
--邀请好友界面
ModuleTable["Recommend"] = {}
ModuleTable["Recommend"]["ControllerPath"] = "script/module/recommend/controller/RecommendController"
ModuleTable["Recommend"]["layer"] = "second_layer"

--战绩
ModuleTable["RoomRecordList"] = {}
ModuleTable["RoomRecordList"]["ControllerPath"] = "script/module/record/controller/RoomRecordListController"
ModuleTable["RoomRecordList"]["layer"] = "second_layer"

ModuleTable["TableRecordList"] = {}
ModuleTable["TableRecordList"]["ControllerPath"] = "script/module/record/controller/TableRecordListController"
ModuleTable["TableRecordList"]["layer"] = "second_layer"
