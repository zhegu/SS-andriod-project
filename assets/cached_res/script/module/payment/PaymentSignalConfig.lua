
--充值结果通知
framework.addSlot2Signal(DBID_RECHARGE_RESULT_NOTIFICATION, PaymentConfig.showRechargeResult, true)

--移动支付方式
framework.addSlot2Signal(MANAGERID_MOBILE_PAYMENT_MODE, PaymentConfig.updataMobilePaymentMode, true)

--联通支付方式
framework.addSlot2Signal(MANAGERID_CU_PAYMENT_MODE, PaymentConfig.updataUnicomPaymentMode, true)

--电信支付方式
framework.addSlot2Signal(MANAGERID_CT_PAYMENT_MODE, PaymentConfig.updataTelecomPaymentMode, true)
