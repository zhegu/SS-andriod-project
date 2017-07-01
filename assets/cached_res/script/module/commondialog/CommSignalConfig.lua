--登录消息
framework.addSlot2Signal(BASEID_LOGIN, CommDialogConfig.logicLogin, true)

--注册消息
framework.addSlot2Signal(BASEID_REGISTER, CommDialogConfig.logicRegister, true)

--心跳消息
framework.addSlot2Signal(MSG_IDLE, CommDialogConfig.msgIdle, true)

