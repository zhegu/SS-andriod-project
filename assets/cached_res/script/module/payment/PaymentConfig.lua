module("PaymentConfig", package.seeall)

--移动支付方式定义
PAYMENT_ONLY_MM = 1;-- 只显示MM
PAYMENT_ONLY_SMSONLINE = 2;-- 只显示网游基地
PAYMENT_NO_MM_NO_SMSONLINE_SHOW_OTHERS = 3;-- 不显示MM,不显示网游基地,显示其他支付
PAYMENT_SHOW_MM_OTHERS = 4;-- 显示MM及其他支付
PAYMENT_SHOW_SMSONLINE_OTHERS = 5;-- 显示网游基地及其他支付
PAYMENT_ONLY_PURSE = 6; --显示手机钱包支付
PAYMENT_SHOW_EPAY = 7;--显示宜支付
PAYMENT_SHOW_YINBEIKE_CMCC = 76 --银贝壳移动
PAYMENT_SHOW_HONGRUAN_SDK_CMCC = 83 --红软移动

--电信支付方式定义
PAYMENT_NO_SHOW_TELECOM = 0;--不显示电信支付
PAYMENT_SHOW_HUAJIAN_OTHERS = 1; -- 显示华健电信
PAYMENT_SHOW_CTESTORE_OTHERS = 2; -- 显示天翼空间
PAYMENT_SHOW_YINBEIKE_CT = 78 --银贝壳电信
PAYMENT_SHOW_HONGRUAN_SDK_CT = 85 --红软电信

--联通支付方式定义
PAYMENT_NO_SHOW_UNICOM = 0;--不显示电信支付
PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS = 1; -- 显示联通短代
PAYMENT_SHOW_WOSTORE_OTHERS = 2; -- 显示联通沃商店
PAYMENT_SHOW_WOJIA = 6; -- 显示同趣联通WO+
PAYMENT_SHOW_YINBEIKE_UNI = 77 --银贝壳联通
PAYMENT_SHOW_HONGRUAN_SDK_UNICOM = 84 --红软联通

--移动支付方式,默认显示MM支付(4)的包，才可以切换;默认显示游戏基地支付(5)的包，不切换
PAYMENT_METHOD_STATUS = 5;-- 显示支付方式的模式
--联通支付方式,可切换
PAYMENT_METHOD_STATUS_LIANTONG = 1;-- 显示支付方式的模式
--电信支付方式,可切换
PAYMENT_METHOD_STATUS_DIANXIN = 1;-- 显示支付方式的模式

--[[--
--更新移动支付方式
--]]
function updataMobilePaymentMode()
	--PaymentMode int 移动支付方式 0：不显示移动支付1：显示MM支付2：显示短代支付3：带验证码的短代（已废弃）
	local PaymentMode = profilePay.PaymentMode.getMobilePaymentMode()
	Common.log("移动支付方式PaymentMode ====== " .. PaymentMode);
	if PaymentMode == 0 then
		PAYMENT_METHOD_STATUS = PAYMENT_NO_MM_NO_SMSONLINE_SHOW_OTHERS;
	elseif PaymentMode == 1 then
		PAYMENT_METHOD_STATUS = PAYMENT_SHOW_MM_OTHERS;
	elseif PaymentMode == 2 then
		PAYMENT_METHOD_STATUS = PAYMENT_SHOW_SMSONLINE_OTHERS;
	elseif PaymentMode == 3 then
		PAYMENT_METHOD_STATUS = PAYMENT_ONLY_PURSE;
	elseif PaymentMode == 4 then
		PAYMENT_METHOD_STATUS = PAYMENT_SHOW_EPAY;
	elseif 	PaymentMode == 5 then
		PAYMENT_METHOD_STATUS = PAYMENT_SHOW_YINBEIKE_CMCC;
	elseif PaymentMode == 6 then
		PAYMENT_METHOD_STATUS = PAYMENT_SHOW_HONGRUAN_SDK_CMCC
	else
		PAYMENT_METHOD_STATUS = PAYMENT_NO_MM_NO_SMSONLINE_SHOW_OTHERS;
	end
end

--[[--
--更新联通支付方式
--]]
function updataUnicomPaymentMode()
	--PaymentMode int 联通支付方式 0：不显示联通支付1：显示联通短代支付2：显示沃商店支付
	local PaymentMode = profilePay.PaymentMode.getUnicomMPaymentMode()
	Common.log("联通支付方式PaymentMode ====== " .. PaymentMode);
	if PaymentMode == 0 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_NO_SHOW_UNICOM;
	elseif PaymentMode == 1 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS;
	elseif PaymentMode == 2 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_SHOW_WOSTORE_OTHERS;
	elseif PaymentMode == 3 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_SHOW_EPAY;
	elseif PaymentMode == 4 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_SHOW_YINBEIKE_UNI;
	elseif PaymentMode == 5 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_SHOW_HONGRUAN_SDK_UNICOM;
	elseif PaymentMode == 6 then
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_SHOW_WOJIA;
	else
		PAYMENT_METHOD_STATUS_LIANTONG = PAYMENT_NO_SHOW_UNICOM;
	end
end

--[[--
--更新电信支付方式
--]]
function updataTelecomPaymentMode()
	--PaymentMode int 电信支付方式 0：不显示电信支付1：显示华建支付2：显示天翼空间支付
	local PaymentMode = profilePay.PaymentMode.getTelecomPaymentMode()
	Common.log("电信支付方式PaymentMode ====== " .. PaymentMode);
	if PaymentMode == 0 then
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_NO_SHOW_TELECOM;
	elseif PaymentMode == 1 then
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_SHOW_HUAJIAN_OTHERS;
	elseif PaymentMode == 2 then
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_SHOW_CTESTORE_OTHERS;
	elseif PaymentMode == 3 then
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_SHOW_EPAY;
	elseif PaymentMode == 4 then
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_SHOW_YINBEIKE_CT;
	elseif PaymentMode == 5 then
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_SHOW_HONGRUAN_SDK_CT;
	else
		PAYMENT_METHOD_STATUS_DIANXIN = PAYMENT_NO_SHOW_TELECOM;
	end
end

--[[--
--显示充值结果弹窗
--]]
function showRechargeResult()
	local RechargeResultTable = {};

	RechargeResultTable = profilePay.RechargeResult.getRechargeResultTable();
	--充值结果类型0：失败 1：购买金币成功2：购买元宝成功3：购买礼包成功
	local result = RechargeResultTable.result;
	--本次充值元宝数量
	local yuanbaoCount = RechargeResultTable.yuanbaoCount;
	--充值结果提示语
	local resultMsg = RechargeResultTable.resultMsg;
	--是否短代充值  0：非短代 1：短代
	local isSmsRecharge = RechargeResultTable.isSmsRecharge;
	--当前VIP等级
	local newVipLevel = RechargeResultTable.newVipLevel;
	--充值引导ID
	local rechargeID = RechargeResultTable.rechargeID;
	--Giftype	Int	礼包类型
	local Giftype = RechargeResultTable.Giftype
	--price	int	人民币价格（分）	单位：分
	local price = RechargeResultTable.price
	--IsGift	byte	是否为礼包	0不是，1是礼包
	local IsGift = RechargeResultTable.IsGift
	--IsExchange	byte	是否兑换金币
	local IsExchange = RechargeResultTable.IsExchange

    Common.log("yuanbaoCount === "..yuanbaoCount)
	Common.log("result === "..result)
	Common.log("isSmsRecharge === "..isSmsRecharge)
	Common.log("Giftype === "..Giftype)
	Common.log("price === "..price)
	Common.log("IsGift === "..IsGift)
	Common.log("IsExchange === "..IsExchange)

	if result == 0 then
		--0：失败
		if isSmsRecharge == 1 then
			-- 1：短代
			if IsGift == 1 then
				--1是礼包
				sendGIFTBAGID_REQUIRE_GIFTBAG(Giftype, 0, 1)
			else
				--0不是礼包
				if Giftype == 0 then
					if rechargeID > 0 then
						local GuideType = QuickPay.getGuideTypeByGiftID(rechargeID)
						if GuideType ~= nil and GuideType ~= "" and GuideType ~= 0 then
							GiftGuideConfig.showPayGuide(GuideType, (price / 100) * 0.7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您支付失败了，请用以下方式再来一次！");
							return;
						end
					else
						if IsExchange == 0 then
							--金币
							GiftGuideConfig.showPayGuide(QuickPay.Pay_Guide_need_coin_GuideTypeID, price * 7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您支付失败了，请用以下方式再来一次！");
						else
							--元宝
							GiftGuideConfig.showPayGuide(QuickPay.Pay_Guide_need_yuanbao_GuideTypeID, (price / 100) * 0.7 , RechargeGuidePositionID.PatternSelectPositionG, 0, "您支付失败了，请用以下方式再来一次！");
						end
					end
				end
			end
		else
			mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
			SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, nil, resultMsg);
		end
		return
	end

	if result == 2 then
		--2：购买元宝成功
		if rechargeID > 0 then
			--充值引导
			mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
			SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, nil, resultMsg);
		else
			--充值列表
			mvcEngine.createModule(GUI_RECHARGE_RESULT);
			RechargeResultLogic.setDialogData(resultMsg, yuanbaoCount);
		end
	else
		--1：购买金币成功 3：购买礼包成功
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, nil, resultMsg);
	end
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
	--profile.Gift.sendFirstGiftIconMsg(1);
	elseif GamePub.isInJinHuaGameTable() then
--		profile.Gift.sendFirstGiftIconMsg(2);
	end
	sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态
	sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_ID_SUPERIORFACE)
	sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_ID_CHANGECARD)
	sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_ID_NO_PK)
	sendDBID_BACKPACK_LIST()--背包

	sendGIFTBAGID_GIFTBAG_LIST()
	sendDOUNIU_MONTH_CARD_V2() --月卡
	sendRECHARGE_REBATE_INFO()	--充值翻倍信息
	sendDOUNIU_MGR_INDEX_ACTIVITY()
end

--[[--
--显示支付本地提示
--]]
function showRechargePrompt(text)
	if text ~= nil and text ~= "" then
		RechargePromptLogic.setValue(text)
		mvcEngine.createModule(GUI_RECHARGEPROMPT)
	end
end
