local path = "script.module.userinfo."


Load.LuaRequire(path .. "logic.AddressConfig")
--绑定手机
Load.LuaRequire(path .. "logic.BindPhoneLogic")
Load.LuaRequire(path .. "logic.BindPhoneMsgLogic")
Load.LuaRequire(path .. "logic.BindWechatLogic")
--个人信息
Load.LuaRequire(path .. "logic.SelfUserInfoLogic")
