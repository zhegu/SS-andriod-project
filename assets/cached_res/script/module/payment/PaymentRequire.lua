local path = "script.module.payment."

Load.LuaRequire(path .. "PaymentModuleConfig")

Load.LuaRequire(path .. "logic.RechargePromptLogic")
Load.LuaRequire(path .. "logic.RechargeResultLogic")

Load.LuaRequire(path .. "PaymentConfig")
Load.LuaRequire(path .. "PaymentMethod")
Load.LuaRequire(path .. "QuickPay")
Load.LuaRequire(path .. "PaymentSignalConfig")
Load.LuaRequire(path .. "RechargeGuidePositionID")