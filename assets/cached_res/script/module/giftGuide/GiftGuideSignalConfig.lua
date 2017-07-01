--显示礼包消息
framework.addSlot2Signal(GIFTBAGID_PUSH_DUAL_GIFTBAG, GiftGuideConfig.showGiftView, true)

--首充礼包状态更新
framework.addSlot2Signal(GIFTBAGID_SHOW_FIRSTPAY_ICON, GiftGuideConfig.updataGiftType, true)

--礼包请求应答
framework.addSlot2Signal(GIFTBAGID_REQUIRE_GIFTBAG, GiftGuideConfig.updataGiftType, true)

--元宝购买礼包应答
framework.addSlot2Signal(GIFTBAGID_BUY_GIFTBAG, GiftGuideConfig.BuyGoodsByYuanbao, true)