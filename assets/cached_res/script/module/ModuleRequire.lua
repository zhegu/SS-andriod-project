local path = "script.module."

ccs = require"script.framework.mvc.view.ccs"

----------------------------登录--------------------------------
Load.LuaRequire(path .. "login.LoginRequire")

----------------------------大厅-------------------------------
Load.LuaRequire(path .. "hall.HallRequire")

-----------------------------站内信----------------------
Load.LuaRequire(path .. "message.logic.MessageServerLogic")
Load.LuaRequire(path .. "message.logic.MessageListLogic")

---------------------------------- 充值模块   -------------
Load.LuaRequire(path .. "recharge.logic.RechargeCenterLogic")
Load.LuaRequire(path .. "recharge.logic.MonthCardLogic")
--客服
Load.LuaRequire(path .. "customservice.logic.CustomServiceLogic")
Load.LuaRequire(path .. "customservice.logic.GameHelpLogic")

---------------------红点------------------------------
Load.LuaRequire(path .. "hongdian.logic.HallRedPointManager")
Load.LuaRequire(path .. "hongdian.logic.HongDianConfig")

---------------------礼包、引导------------------------------
Load.LuaRequire(path .. "giftGuide.GiftGuideRequire")

-------------------------游戏公共方法-------------------------
Load.LuaRequire(path .. "gameUtil.GameUtilRequire")

-------------------------与游戏逻辑相关的弹出框----------------------------
Load.LuaRequire(path .. "gameDialog.GameDialogRequire")

-------------------------支付相关----------------------------
Load.LuaRequire(path .. "payment.PaymentRequire")

---------------------公共模块(注意已经要最后加载)----------------------
Load.LuaRequire(path .. "commondialog.CommDialogRequire")

--------------------人个信息-----------------------
Load.LuaRequire(path .. "userinfo.UserinfoRequire")
--------------------appstrore分享-----------------------
Load.LuaRequire(path .. "appstoreratings.logic.AppstoreRatingsLogic");
----------------------------自建房间---------------------------
Load.LuaRequire(path .. "createRoom.CreateRoomRequire");


------------------------麻将------------------------------------------------
Load.LuaRequire(path .. "buycard.logic.BuyCardLogic");
Load.LuaRequire(path .. "buycard.logic.ExchangeRoomCardLogic");
Load.LuaRequire(path .. "recommend.logic.InviteCodeLogic");
Load.LuaRequire(path .. "recommend.logic.RecommendLogic");
--战绩
Load.LuaRequire(path .. "record.logic.RoomRecordListLogic");
Load.LuaRequire(path .. "record.logic.TableRecordListLogic");

GameLoadModuleConfig.loadGameModule();
