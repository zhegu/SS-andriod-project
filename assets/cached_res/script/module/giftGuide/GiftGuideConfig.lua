module("GiftGuideConfig", package.seeall)

--[[--
--展示充值引导
--@param #number GuideType 引导类型
--@param #number needCurrencyNum 需要的货币数量
--@param #number position 充值引导的位置信息
--@param #number RechargeMode 0双按钮 1短代
]]
function showPayGuide(GuideType, needCurrencyNum, position, RechargeMode, tipsText)
	if next(profilePay.PayChannelData.getAllPayDataList()) == nil then
		Common.showToast("数据加载中，请稍后",3);
		return
	end

	Common.log("GuideType = "..GuideType)
	Common.log("position = "..position)

	if GuideType == QuickPay.Pay_Guide_Native_need_coin_GuideTypeID then
		needCurrencyNum = needCurrencyNum * ServerConfig.getConversionCoefficient();
	end

	Common.log("needCurrencyNum = "..needCurrencyNum)

	if ServerConfig.getQuickPayIsShow() then
		--可以显示充值引导
		local isSearchSMS = true;
		if RechargeMode ~= nil and RechargeMode == 0 then
			--第三方支付
			isSearchSMS = false;
		else
			--短代
			isSearchSMS = true;
		end

		mvcEngine.createModule(GUI_PAYGUIDEPROMPT)
		PayGuidePromptLogic.setPayGuideData(GuideType, needCurrencyNum, position, isSearchSMS, tipsText)
	else
		--不显示充值引导
		local sMsg = "您当前金币/元宝不足，请进入充值获取！"
		mvcEngine.createModule(GUI_SYSTEMPROMPTDIALOG);
		SystemPromptDialogLogic.setDialogData(SystemPromptDialogLogic.getSystemDialogType().NORMAL, "充值提示", sMsg);
	end
end

--[[--
--展示礼包
--]]
function showGiftView()
	--	if not ServerConfig.getGiftIsShow() then
	--		return;
	--	end
	local giftData = profile.Gift.getGiftDataTable()
	local num = profile.User.getSelfRound()--盘数
	Common.log("xwh libao giftData.mGiftBagType is " .. giftData.mGiftBagType)
	if giftData.mGiftBagType == QuickPay.GIFTID_MONTHCARD then
		mvcEngine.createModule(GUI_MONTHCARD)
		return
	end
--	elseif giftData.mGiftBagType == QuickPay.GIFTID_FIRSTRECHARGE then
--		shouchongLogic.setTable(giftData)
--		mvcEngine.createModule(GUI_SHOUCHONG)
--		return
--	elseif giftData.mGiftBagType == QuickPay.GIFTID_BANKRUPTCY_5 then
--		pochanLogic.setType(pochanLogic.getTypeTable().TYPE_POCHAN_5,giftData)
--		mvcEngine.createModule(GUI_POCHAN)
--		return
--	elseif giftData.mGiftBagType == QuickPay.GIFTID_BANKRUPTCY_10 then
--		pochanLogic.setType(pochanLogic.getTypeTable().TYPE_POCHAN_10,giftData)
--		mvcEngine.createModule(GUI_POCHAN)
--		return
--	elseif giftData.mGiftBagType == QuickPay.GIFTID_BANKRUPTCY_30 then
--		pochanLogic.setType(pochanLogic.getTypeTable().TYPE_POCHAN_30,giftData)
--		mvcEngine.createModule(GUI_POCHAN)
--		return
--	end
	if GamePub.isInJinHuaGameTable() and giftData.mnAllowTableShow ~= 1 then
	--如果当前在牌桌并且此礼包不可以在牌桌中弹出,暂存礼包
	else
		DelayShowGiftConfig.resetGiftAtMiniGame();
		mvcEngine.createModule(GUI_GIFT_SHOW_VIEW)
		HallGiftShowLogic.setGiftData(giftData)
	end
end

--[[--
--处理元宝购买礼包
--]]
function BuyGoodsByYuanbao()
	CommDialogConfig.closeProgressDialog()
	local giftData = profile.Gift.getGiftResultForYuanbao()
	--result  是否成功1是0否
	Common.log("是否成功1是0否 = " .. giftData["result"])
	--resultMsg
	Common.log(" = " .. giftData["resultMsg"])
	Common.showToast(giftData["resultMsg"], 2)
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
	--profile.Gift.sendFirstGiftIconMsg(1);
	elseif GamePub.isInJinHuaGameTable() then
	--profile.Gift.sendFirstGiftIconMsg(2);
	end
	sendGIFTBAGID_GET_GIFTBAG_MSG()--请求礼包状态
	sendGIFTBAGID_GIFTBAG_LIST()
end

--[[--
--更新用户礼包状态
--]]
function updataGiftType()
	if GamePub.isInJinHuaGameTable() then
--		TableLogic.showGiftIcon()
	end
	if GameConfig.getTheCurrentBaseLayer() == GUI_HALL then
--		HallLogic.isShowCountDownGiftPackage()
	end
end