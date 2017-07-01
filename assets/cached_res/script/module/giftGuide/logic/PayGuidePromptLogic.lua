module("PayGuidePromptLogic",package.seeall)

Panel_20 = nil
view = nil
Panel_exchange_box = nil --
--Panel_exchange_info = nil --

label_pay_prompt = nil
label_goods_name = nil;--
Panel_40 = nil;--
label_goods_price_detail = nil--
CheckBox_exchange = nil
iv_photo = nil
AtlasLabel_exchange_coin = nil--兑换金币数量
Label_exchange_info = nil--是否直接兑换金币描述
ImageView_41 = nil
Label_GiveIngot = nil;--已加送元宝数
Panel_numInfo = nil;--数值
panelNunInfoPosition = nil;

Button_close = nil
Button_sms_ok = nil
Button_weixin = nil;--
ImageView_weixin = nil;--
Button_alipay = nil;--
ImageView_alipay = nil;--
panel = nil
Label_26 = nil
ImageView_38 = nil

local PaymentTable = nil--支付信息
local PayGuidePosition = nil--位置信息
panel = nil
needOpenView = nil
local goodsNameText = nil --商品名称
local enterType = nil --如果是加号进入换金币则为true

function onKeypad(event)
	if event == "backClicked" then
	--返回键
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	view = cocostudio.createView("PayGuidePrompt.json")
	local gui = GUI_PAYGUIDEPROMPT
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_SMALL then
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	else
		--设置当前屏幕的分辨率
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	end
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag())
	GameStartConfig.addChildForScene(view)

	panel = cocostudio.getUIPanel(view, "Panel_48")
	initView()
	enterType = false --如果是加号进入换金币则为true其他为false
	GamePub.showDialogAmin(Panel_40)
end

function requestMsg()

end

function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20")
	Panel_exchange_box = cocostudio.getUIPanel(view, "Panel_exchange_box") --
	--	Panel_exchange_info = cocostudio.getUIPanel(view, "Panel_exchange_info") --
	Panel_40 = cocostudio.getUIPanel(view, "Panel_40");
	iv_photo = cocostudio.getUIImageView(view, "iv_photo")
	ImageView_41 = cocostudio.getUIImageView(view, "ImageView_41")
	label_pay_prompt = cocostudio.getUILabel(view, "label_pay_prompt")--购买提示
	label_goods_name = cocostudio.getUILabel(view, "label_goods_name")--名称
	label_goods_price_detail = cocostudio.getUILabel(view, "label_goods_price_detail")--价格描述
	AtlasLabel_exchange_coin = cocostudio.getUILabelAtlas(view, "AtlasLabel_exchange_coin")--兑换金币数量
	Label_exchange_info = cocostudio.getUILabel(view, "Label_exchange_info")
	Label_GiveIngot = cocostudio.getUILabel(view, "Label_GiveIngot");--已加送元宝数
	CheckBox_exchange = cocostudio.getUICheckBox(view, "CheckBox_exchange")
	Image_sale = cocostudio.getUIImageView(view, "Image_sale")
	Label_sale = cocostudio.getUILabel(view, "Label_sale")
	ImageView_38 = cocostudio.getUIImageView(view, "ImageView_38")
	Button_close = cocostudio.getUIButton(view, "Button_close")
	Button_sms_ok = cocostudio.getUIButton(view, "Button_sms_ok")
	Button_weixin = cocostudio.getUIButton(view, "Button_weixin");
	ImageView_weixin = cocostudio.getUIImageView(view, "ImageView_weixin");
	Button_alipay = cocostudio.getUIButton(view, "Button_alipay");
	ImageView_alipay = cocostudio.getUIImageView(view, "ImageView_alipay");
	Panel_numInfo = cocostudio.getUIPanel(view, "Panel_numInfo");
	panelNunInfoPosition = Panel_numInfo:getPosition();


	CheckBox_exchange:setSelectedState(true)
end

--[[--
--获取万人金花充值引导提示语
--@param #number position 充值引导的位置信息
--]]
local function getWanRenJinHuaRechargeTips(PayGuidePosition)
	local TextPayPrompt_Front = ""
	--万人金花金币不足触发充值
	if PayGuidePosition == RechargeGuidePositionID.WanRenJinHuaPositionB then
		TextPayPrompt_Front = "至少要10000金币才能下注，"

		--万人金花下注金币大于拥有金币的1/10触发充值
	elseif PayGuidePosition == RechargeGuidePositionID.WanRenJinHuaPositionC then
		TextPayPrompt_Front = "下注额不能超过携带金币的10%，"

		--万人金花点击下注按钮金币不足触发充值
	elseif  PayGuidePosition == RechargeGuidePositionID.WanRenJinHuaPositionD then
		TextPayPrompt_Front = "至少要".. needCurrencyNum .. "金币才能下注，"
	else
		TextPayPrompt_Front = "您当前金币不足，"
	end
	return TextPayPrompt_Front;
end

--[[--
--设置充值引导数据
--@param #number GuideType 引导类型
--@param #number needCurrencyNum 需要的货币数量
--@param #number position 充值引导的位置信息
--@param boolean isSearchSMS 是否检索短代支付列表
]]
function setPayGuideData(GuideType, needCurrencyNum, position, isSearchSMS, tipsText)
	profilePay.PaymentResult.setGuideData(GuideType, needCurrencyNum, position)
	PaymentTable = {}
	PayGuidePosition = position

	local TextPayPrompt_Front = ""
	local TextPayPrompt_Back = ""

	PaymentTable = QuickPay.getPaymentTable(GuideType, needCurrencyNum, 0, isSearchSMS);

	if PaymentTable ~= nil then
		--ios  显示的界面  没有银联和支付宝
		if Common.platform == Common.TargetIos then
			if GuideType == QuickPay.Pay_Guide_need_coin_GuideTypeID then
				--购买金币
				if GameConfig.getTheLastBaseLayer() == GUI_WANRENJINHUA then
					TextPayPrompt_Front = getWanRenJinHuaRechargeTips(PayGuidePosition)
				else
					TextPayPrompt_Front = "您当前金币不足，"
				end

				if PayGuidePosition == RechargeGuidePositionID.MatchListPositionJ then
					TextPayPrompt_Front = "您的押金不足，"
				end

				Panel_exchange_box:setVisible(true)
				CheckBox_exchange:setSelectedState(true)

				if PayGuidePosition == RechargeGuidePositionID.ReliveStoneB then
					if profile.CrazyStage.getCrazyBaseInfo() ~= nil and profile.CrazyStage.getCrazyBaseInfo().MinCoin ~= nil then
						TextPayPrompt_Front = "【疯狂闯关】至少需要" .. profile.CrazyStage.getCrazyBaseInfo().MinCoin .. "金币才能开始,"
					end
					if profile.CrazyStage.getCrazyStageValidateTable() ~= nil and profile.CrazyStage.getCrazyStageValidateTable().Amount ~= nil then
						TextPayPrompt_Front = "【疯狂闯关】至少需要" .. profile.CrazyStage.getCrazyStageValidateTable().Amount .. "金币才能开始,"
					end
				end
			elseif GuideType == QuickPay.Pay_Guide_need_yuanbao_GuideTypeID then
				--购买元宝
				TextPayPrompt_Front = "您当前元宝不足，"
				Panel_exchange_box:setVisible(true)
				CheckBox_exchange:setSelectedState(false)
			else
				--非购买金币元宝
				label_pay_prompt:setVisible(true)
				Panel_exchange_box:setVisible(false)
				Panel_exchange_box:setTouchEnabled(false)
				CheckBox_exchange:setTouchEnabled(false)
				--				Panel_exchange_info:setVisible(false)
			end

			--android显示界面
		elseif Common.platform == Common.TargetAndroid then
			if GuideType == QuickPay.Pay_Guide_need_coin_GuideTypeID then
				--购买金币
				if GameConfig.getTheLastBaseLayer() == GUI_WANRENJINHUA then
					TextPayPrompt_Front = getWanRenJinHuaRechargeTips(PayGuidePosition);
				else
					TextPayPrompt_Front = "您当前金币不足，"
				end
				Panel_exchange_box:setVisible(true)
				CheckBox_exchange:setSelectedState(true)
				if PayGuidePosition == RechargeGuidePositionID.ReliveStoneB then
					if profile.CrazyStage.getCrazyBaseInfo() ~= nil and profile.CrazyStage.getCrazyBaseInfo().MinCoin ~= nil then
						TextPayPrompt_Front = "【疯狂闯关】至少需要" .. profile.CrazyStage.getCrazyBaseInfo().MinCoin .. "金币才能开始,"
					end
					if profile.CrazyStage.getCrazyStageValidateTable() ~= nil and profile.CrazyStage.getCrazyStageValidateTable().Amount ~= nil then
						TextPayPrompt_Front = "【疯狂闯关】至少需要" .. profile.CrazyStage.getCrazyStageValidateTable().Amount .. "金币才能开始,"
					end
				end
			elseif GuideType == QuickPay.Pay_Guide_need_yuanbao_GuideTypeID then
				--购买元宝
				TextPayPrompt_Front = "您当前元宝不足，"
				Panel_exchange_box:setVisible(true)
				CheckBox_exchange:setSelectedState(false)
			else
				--非购买金币元宝
				label_pay_prompt:setVisible(true)
				Panel_exchange_box:setVisible(false)
				Panel_exchange_box:setTouchEnabled(false)
				CheckBox_exchange:setTouchEnabled(false)
				--				Panel_exchange_info:setVisible(false)
			end
		end

		if PaymentTable.PayTypeID == profilePay.PayChannelData.WEIXIN_PAY or PaymentTable.PayTypeID == profilePay.PayChannelData.NEW_UNION_PAY or PaymentTable.PayTypeID == profilePay.PayChannelData.ALI_PAY then
			--支付宝、银联、微信
			TextPayPrompt_Back = "是否充值？"
			Common.setButtonVisible(Button_sms_ok, false)
			Common.setButtonVisible(Button_weixin, true)
			Common.setButtonVisible(Button_alipay, true)
		else
			--			TextPayPrompt_Back = "是否使用话费充值？"
			TextPayPrompt_Back = "是否充值？"

			if not ServerConfig.isAppstoreReview() then
				Common.setButtonVisible(Button_sms_ok, false)
				Common.setButtonVisible(Button_weixin, true)
				Common.setButtonVisible(Button_alipay, true)
--				Button_sms_ok:setPosition(ccp(Button_alipay:getPosition().x,Button_alipay:getPosition().y))

			else
				Common.setButtonVisible(Button_sms_ok, true)
				ImageView_38:loadTexture(Common.getResourcePath("ui_queding.png"))
				Common.setButtonVisible(Button_weixin, false)
				Common.setButtonVisible(Button_alipay, false)
			end

		end

		Common.log("PaymentTable.GiftID ============= "..PaymentTable.GiftID)
		Common.log("PaymentTable.PayTypeID ============= "..PaymentTable.PayTypeID)
		Common.log("PaymentTable.goodsName = " .. PaymentTable.goodsName)-- 商品名称
		Common.log("PaymentTable.goodsDetail = " .. PaymentTable.goodsDetail)-- 商品的具体描述
		Common.log("PaymentTable.goodsPriceDetail = " .. PaymentTable.goodsPriceDetail)-- 本次支付的总费
		Common.log("PaymentTable.mnDiscount = " .. PaymentTable.mnDiscount)-- 优惠百分比(%) 例：10
		Common.log("PaymentTable.mnSubtype = " .. PaymentTable.mnSubtype)-- 支付子类型 默认为0
		Common.log("PaymentTable.price = " .. PaymentTable.price) -- 价格(单位：分)

		if GuideType == QuickPay.Pay_Guide_jipai_GiftTypeID then
			label_pay_prompt:setText("知己知彼防炸弹，全靠【记牌器】")
		elseif GuideType == QuickPay.Pay_Guide_biaoqing_GuideTypeID then
			label_pay_prompt:setText("【超萌表情】:特权牌桌表情随意用")
		elseif GuideType == QuickPay.Pay_Guide_no_vip_GuideTypeID then
			local myVipNumber = VIPPub.getUserVipType(profile.User.getSelfVipLevel())
			if myVipNumber < 7 then
				label_pay_prompt:setText("您再充值" .. PaymentTable.price / 100 .. "元即可免费成为VIP" .. myVipNumber + 1 .. "。")
			elseif myVipNumber == 7 then
				label_pay_prompt:setText("充值" .. PaymentTable.price / 100 .. "元," .. "获得" .. PaymentTable.goodsName .. "。")
			end
		elseif GuideType == QuickPay.Pay_Guide_no_pk_GuideTypeID or GuideType == QuickPay.Pay_Guide_changecard_GuideTypeID then
			label_pay_prompt:setText("确认购买" .. PaymentTable.goodsName .. "?")
		else
			label_pay_prompt:setText(TextPayPrompt_Front..TextPayPrompt_Back);
		end

		if tipsText ~= nil then
			label_pay_prompt:setText(tipsText);
		end

		label_goods_name:setText(PaymentTable.goodsName);
		--商品价格细节将"价格：xxx元"的"价格："去掉
		local priceDetail = string.gsub(PaymentTable.goodsPriceDetail , "价格:", "");
		label_goods_price_detail:setText(priceDetail);

		local tempCoin = string.match(PaymentTable.goodsName, "%d+");
		if tempCoin ~= nil then
			AtlasLabel_exchange_coin:setStringValue("" .. (tempCoin * 100 * ServerConfig.getConversionCoefficient()))
		else
			AtlasLabel_exchange_coin:setStringValue("" .. (PaymentTable.price * 10 * ServerConfig.getConversionCoefficient()))
		end

		--需求要价格左对齐,所以不用描边的处理了
		PaymentTable.mnDiscount = 0;
		if tonumber(PaymentTable.mnDiscount) > 0 then
			local nGiveIngot = tempCoin * PaymentTable.mnDiscount / (PaymentTable.mnDiscount + 100);--加送的元宝数
			Label_GiveIngot:setText("(已加送 " .. nGiveIngot .. "元宝)");
		else
			-- Panel_numInfo:setPosition(ccp(190, panelNunInfoPosition.y));
		end
	else
		label_pay_prompt:setText("支付功能暂未开通！");
		Common.setButtonVisible(Button_sms_ok, false)
		Panel_exchange_box:setVisible(false)
		Panel_exchange_box:setTouchEnabled(false)
		CheckBox_exchange:setTouchEnabled(false)
	end

end

--设置商品名称(如购买复活石时用到)
function setGoodsName(goodsNameV)
	goodsNameText = goodsNameV
end

function setEnterType(type)
	enterType = type;
end

local function close()
	mvcEngine.destroyModule(GUI_PAYGUIDEPROMPT)
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
		local myyuanbao = profile.User.getSelfYuanBao()
		if needOpenView ~= nil and needOpenView ~= "" then
			mvcEngine.createModule(needOpenView)
		elseif enterType and myyuanbao ~= 0 then
			CommDialogConfig.openConvertCoin()
		end
		sendMANAGERID_GET_RED_PACKETS_INFO()
	elseif component == CANCEL_UP then
	--取消
	end
end

function setNeedOpenView(needOpenViewV)
	needOpenView = needOpenViewV
end

function callback_CheckBox_exchange(component)

end

--[[--
--短信支付
]]
function callback_Button_sms_ok(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if PaymentTable == nil then
			return
		end
		local isExchange = CheckBox_exchange:getSelectedState()
		QuickPay.PayGuide(PaymentTable, PaymentTable.PayTypeID, PayGuidePosition, isExchange)
		mvcEngine.destroyModule(GUI_PAYGUIDEPROMPT)
	elseif component == CANCEL_UP then
	--取消
	end
end

function callback_Button_weixin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if PaymentTable == nil then
			return
		end
		local isExchange = CheckBox_exchange:getSelectedState()
		if Common.getCurrentNameOfAppPackageIsTQ() then
			--如果当前的包名为"com.shuashuaent.client.lord", 则使用微信支付
			QuickPay.PayGuide(PaymentTable, profilePay.PayChannelData.WEIXIN_PAY, PayGuidePosition, isExchange);
		else
			--如果当前的包名不是"com.shuashuaent.client.lord", 则使用银联支付
			QuickPay.PayGuide(PaymentTable, profilePay.PayChannelData.NEW_UNION_PAY, PayGuidePosition, isExchange);
		end
		mvcEngine.destroyModule(GUI_PAYGUIDEPROMPT)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_alipay(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if PaymentTable == nil then
			return
		end
		local isExchange = CheckBox_exchange:getSelectedState()
		QuickPay.PayGuide(PaymentTable, profilePay.PayChannelData.ALI_PAY, PayGuidePosition, isExchange)
		mvcEngine.destroyModule(GUI_PAYGUIDEPROMPT)
	elseif component == CANCEL_UP then
	--取消

	end
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	_strPrompt = nil
end

function addSlot()
end

function removeSlot()
end
