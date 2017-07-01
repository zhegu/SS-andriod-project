module("RechargeCenterLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_TableView = nil;--
Panel_21 = nil;--
Panel_dialog = nil;--
Image_titel = nil;--
btn_back = nil;--
Panel_tab = nil;--
img_alipay = nil;--
img_alipaytitle = nil;--
img_duanxin = nil;--
img_duanxintitle = nil;--
img_wechat = nil;--
img_weixintitle = nil;--
img_iap = nil;--
img_iaptitle = nil;--
Panel_23 = nil;--
Button_vipInfo = nil;--
ProgressBar_vip = nil;--
AtlasLabel_vipInfo = nil;--
Image_now_vip = nil;--
Image_next_vip = nil;--

local RECHARGE_LIST_ALIPAY = 1 --支付宝充值列表状态
local RECHARGE_LIST_UNION = 2 --银联充值列表状态
local RECHARGE_LIST_SMS = 3 --短信充值列表状态
local RECHARGE_CARD = 4 --充值卡支付列表状态
local RECHARGE_WEIXIN = 5 --微信支付列表状态
local RECHARGE_91 = 11 --91支付
local RECHARGE_LIST_NEW_UNION = 29 --新银联
local RECHARGE_IAP = 59 --iap支付
local RECHARGE_HAIMA = 49 --海马ios支付

RechargeTableView = nil;
rechargeTableMenuListLayer = {};

local is1920 = false --适配1920

function onKeypad(event)
	if event == "backClicked" then
		--返回键
		callback_btn_back(RELEASE_UP)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_RECHARGECENTER;
	if GameConfig.ScreenWidth >= 1920 then
		--适配1920*1080
		view = cocostudio.createView("RechargeCenter_1920_1080.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
		is1920 = true ;
	else
		if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
			--适配方案 1136x640
			view = cocostudio.createView("RechargeCenter.json");
			GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
		elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
			--适配方案 Pad加黑边
			view = cocostudio.createView("RechargeCenter.json");
			GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
		end
	end

end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_TableView = cocostudio.getUIPanel(view, "Panel_TableView");
	Panel_21 = cocostudio.getUIPanel(view, "Panel_21");
	Panel_dialog = cocostudio.getUIPanel(view, "Panel_dialog");
	Image_titel = cocostudio.getUIImageView(view, "Image_titel");
	btn_back = cocostudio.getUIButton(view, "btn_back");
	Panel_tab = cocostudio.getUIPanel(view, "Panel_tab");
	img_alipay = cocostudio.getUIImageView(view, "img_alipay");
	img_alipaytitle = cocostudio.getUIImageView(view, "img_alipaytitle");
	img_duanxin = cocostudio.getUIImageView(view, "img_duanxin");
	img_duanxintitle = cocostudio.getUIImageView(view, "img_duanxintitle");
	img_wechat = cocostudio.getUIImageView(view, "img_wechat");
	img_weixintitle = cocostudio.getUIImageView(view, "img_weixintitle");
	img_iap = cocostudio.getUIImageView(view, "img_iap");
	img_iaptitle = cocostudio.getUIImageView(view, "img_iaptitle");
	Panel_23 = cocostudio.getUIPanel(view, "Panel_23");
	Button_vipInfo = cocostudio.getUIButton(view, "Button_vipInfo");
	ProgressBar_vip = cocostudio.getUILoadingBar(view, "ProgressBar_vip");
	AtlasLabel_vipInfo = cocostudio.getUILabelAtlas(view, "AtlasLabel_vipInfo");
	Image_now_vip = cocostudio.getUIImageView(view, "Image_now_vip");
	Image_next_vip = cocostudio.getUIImageView(view, "Image_next_vip");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();

	GamePub.showDialogAmin(Panel_dialog);

	chooseRechargeShow();
end

function requestMsg()
	sendDOUNIU_VIPINFO()
	local rechargeRebateDate = profilePay.PayChannelData.getRECHARGE_REBATE_INFO()
	if next(rechargeRebateDate) == nil then
		sendRECHARGE_REBATE_INFO()
	end
end

--[[--
--获取短代支付的支付列表和渠道
--@return #table CurrentList 支付列表
--@return number PayChannel 支付渠道
--]]
function getSMSPayListAndPayChannel()
	local CurrentList = {}
	local PayChannel = nil
	if Common.getOperater() == Common.CHINA_MOBILE then
		--移动
		--移动短代
		CurrentList = profilePay.PayChannelData.getSMSOnlineShowListData()
		PayChannel = profilePay.PayChannelData.SMS_ONLINE
		--		if PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_MM_OTHERS then
		--			--MM
		--			CurrentList = profilePay.PayChannelData.getMMShowListData();
		--			PayChannel = profilePay.PayChannelData.MM_PAY_V2;
		--		elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_SMSONLINE_OTHERS then
		--			--移动短代
		--			CurrentList = profilePay.PayChannelData.getSMSOnlineShowListData()
		--			PayChannel = profilePay.PayChannelData.SMS_ONLINE
		--		elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_EPAY then
		--			--宜支付
		--			CurrentList = profilePay.PayChannelData.getEPayShowListData()
		--			PayChannel = profilePay.PayChannelData.EPAY
		--		end

	elseif Common.getOperater() == Common.CHINA_UNICOM then
		--联通
		--联通短代
		CurrentList = profilePay.PayChannelData.getHuaJianUnicomTableShowListData()
		PayChannel = profilePay.PayChannelData.HUAJIAN_LIANTONG_PAY
		--		if PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_WOSTORE_OTHERS then
		--			--沃商店
		--			CurrentList = profilePay.PayChannelData.getUnicomShowListData()
		--			PayChannel = profilePay.PayChannelData.SMS_UNICOM
		--		elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS then
		--			--联通短代
		--			CurrentList = profilePay.PayChannelData.getHuaJianUnicomTableShowListData()
		--			PayChannel = profilePay.PayChannelData.HUAJIAN_LIANTONG_PAY
		--		elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_EPAY then
		--			--宜支付
		--			CurrentList = profilePay.PayChannelData.getEPayShowListData()
		--			PayChannel = profilePay.PayChannelData.EPAY
		--		end
	elseif Common.getOperater() == Common.CHINA_TELECOM then
		--电信短代
		CurrentList = profilePay.PayChannelData.getHuaJianTelecomTableShowListData()
		PayChannel = profilePay.PayChannelData.HUAJIAN_DIANXIN_PAY
		--		if PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_HUAJIAN_OTHERS then
		--			--电信短代
		--			CurrentList = profilePay.PayChannelData.getHuaJianTelecomTableShowListData()
		--			PayChannel = profilePay.PayChannelData.HUAJIAN_DIANXIN_PAY
		--		elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_EPAY then
		--			--宜支付
		--			CurrentList = profilePay.PayChannelData.getEPayShowListData()
		--			PayChannel = profilePay.PayChannelData.EPAY
		--		end
	end

	return CurrentList, PayChannel;
end

--[[--
--选择显示的模式
--]]
function chooseRechargeShow()
	GameConfig.setRechargeShowState(0);
	--ios平台的话直接显示列表,andorid的话，显示支付宝
	if Common.platform == Common.TargetIos then
		if GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
			if not ServerConfig.isAppstoreReview() then
				--不是评审
				Common.setButtonVisible(img_duanxin, false);
				Common.setButtonVisible(img_iap, true);
				Common.setButtonVisible(img_alipay, true);
				Common.setButtonVisible(img_wechat, true);
				changeRechargeShow(RECHARGE_WEIXIN)
			else
				--AppStore评审中
				Common.setButtonVisible(img_duanxin, false);
				Common.setButtonVisible(img_iap, false);
				Common.setButtonVisible(img_alipay, false);
				Common.setButtonVisible(img_wechat, false);
				changeRechargeShow(RECHARGE_IAP)
			end
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
			Common.setButtonVisible(img_duanxin, false);
			Common.setButtonVisible(img_alipay, false);
			Common.setButtonVisible(img_wechat, false);
			Common.setButtonVisible(img_iap, true);
			changeRechargeShow(RECHARGE_91)
		elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
			Common.setButtonVisible(img_duanxin, false);
			Common.setButtonVisible(img_alipay, false);
			Common.setButtonVisible(img_wechat, false);
			Common.setButtonVisible(img_iap, true);
			changeRechargeShow(RECHARGE_HAIMA)
		end
	elseif Common.platform == Common.TargetAndroid then
		--android 支付
		Common.setButtonVisible(img_iap, false);
		Common.setButtonVisible(img_alipay, true);
		Common.setButtonVisible(img_wechat, true);
		--如果有手机卡，显示短信充值
		--运营商
		local operator = Common.getOperater()
		if operator ~= 0 then
			local CurrentList, payChannel = getSMSPayListAndPayChannel()
			if CurrentList == nil or #CurrentList == 0 or payChannel == nil then
				Common.setButtonVisible(img_duanxin, false);
				changeRechargeShow(RECHARGE_WEIXIN)
			else
				Common.setButtonVisible(img_duanxin, true);
				changeRechargeShow(RECHARGE_LIST_SMS)
			end
		else
			changeRechargeShow(RECHARGE_WEIXIN)
		end
	end
end


--[[--
--改变支付中心显示状态
--#number state 要显示的状态
--]]
function changeRechargeShow(state)
	if GameConfig.getRechargeShowState() == state then
		return;
	end
	GameConfig.setRechargeShowState(state)
	if GameConfig.getRechargeShowState() == RECHARGE_LIST_SMS then
		--短信支付
		img_duanxin:loadTexture("DN_HALL_information_btn_brownbig_bg.png",1)
		img_wechat:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_alipay:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_iap:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)

		local CurrentList, payChannel = getSMSPayListAndPayChannel()
		if CurrentList~= nil and #CurrentList > 0 and payChannel~= nil then
			showPayScrollView(CurrentList, payChannel)
		else
			--未知运营商
			Common.showToast("设备无法使用短信支付！", 2)
		end
	elseif GameConfig.getRechargeShowState() == RECHARGE_WEIXIN then
		--微信支付
		img_duanxin:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_wechat:loadTexture("DN_HALL_information_btn_brownbig_bg.png",1)
		img_alipay:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_iap:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)

		local CurrentList = profilePay.PayChannelData.getWeiXinShowListData()
		showPayScrollView(CurrentList, profilePay.PayChannelData.WEIXIN_PAY)
	elseif GameConfig.getRechargeShowState() == RECHARGE_LIST_ALIPAY then
		--支付宝支付
		img_duanxin:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_wechat:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_alipay:loadTexture("DN_HALL_information_btn_brownbig_bg.png",1)
		img_iap:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)

		local CurrentList = profilePay.PayChannelData.getAliPayShowListData()
		showPayScrollView(CurrentList, profilePay.PayChannelData.ALI_PAY)
	elseif GameConfig.getRechargeShowState() == RECHARGE_IAP then
		--iap
		img_duanxin:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_wechat:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_alipay:loadTexture("DN_HALL_information_btn_brownsmall_bg.png",1)
		img_iap:loadTexture("DN_HALL_information_btn_brownbig_bg.png",1)

		local CurrentList = profilePay.PayChannelData.getIAPShowListData()
		showPayScrollView(CurrentList, profilePay.PayChannelData.IAP_PAY)
	end
end


--[[--
--设置元宝充值tableview是否可触摸/Menu是否可点击
--]]
function setAllMenuEnabled(Enabled)
	if RechargeTableView ~= nil then
		RechargeTableView:setTouchEnabled(Enabled)
		for i = 1, table.maxn(rechargeTableMenuListLayer) do
			if rechargeTableMenuListLayer[i] ~= nil then
				rechargeTableMenuListLayer[i]:setTouchEnabled(Enabled);
			end
		end
	end

end

function deleteAllClickedLayer()
	--推荐家族
	if RechargeTableView ~= nil then
		for i = 1, table.maxn(rechargeTableMenuListLayer) do
			if rechargeTableMenuListLayer[i] ~= nil then
				rechargeTableMenuListLayer[i]:setTouchEnabled(false)
				rechargeTableMenuListLayer[i]:removeFromParentAndCleanup(true)
				rechargeTableMenuListLayer[i] = nil
			end
		end
	end
end

function showPayScrollView(CurrentList, PayTypeID)
	deleteAllClickedLayer()
	rechargeTableMenuListLayer = {}
	Common.log("showPayScrollView === ")
	if CurrentList == nil or CurrentList == "" then
		Common.log("showPayScrollView === return")
		return;
	end
	Common.log("showPayScrollView === Success")
	local tableSize = 0 --元素数量
	local TableView_W = 695 --TableView的显示宽度
	local TableView_H = 295 --TableView的显示高度
	local TableView_X = 221 --* GameConfig.ScaleAbscissa; --TableView的左下角X坐标
	local TableView_Y = 149 --* GameConfig.ScaleOrdinate; --TableView的左下角Y坐标
	local rowSize = 1; --一共多少行(行、列中有一个数为常量,需要计算的数初始化为0)
	local columnSize = 0; --一共多少列(行、列中有一个数为常量,需要计算的数初始化为0)
	local spacingW = 2; --横向间隔
	local spacingH = 2 --纵向间隔
	local loadCellSize = 0;--已经加载的元素数
	local cellWidth = 170; --每个元素的宽
	if GameConfig.RealProportion < GameConfig.SCREEN_PROPORTION_GREAT and GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		cellWidth = 200
	end
	local cellHeight = 250; --每个元素的高

	if is1920 == true then
		TableView_W = 1190 --TableView的显示宽度
		TableView_H = 520 --TableView的显示高度
		TableView_X = 363 --TableView的左下角X坐标
		TableView_Y = 258 --* GameConfig.ScaleOrdinate; --TableView的左下角Y坐标
		cellWidth = 170 * 1.69
		cellHeight = 250 * 1.69
	end

	if RechargeTableView ~= nil then
		RechargeTableView:removeFromParentAndCleanup(true)
	end

	--TableView_X = TableView_X - TableView_W * (1 - GameConfig.ScaleAbscissa) / 2
	--TableView_Y = TableView_Y - TableView_H * (1 - GameConfig.ScaleOrdinate) / 2

	local loadCellSize = 0;--已经加载的元素数
	RechargeTableView = ccTableView.create(CCSize(TableView_W, TableView_H), kCCScrollViewDirectionHorizontal);
	RechargeTableView:setPosition(TableView_X + TableView_W / 2, TableView_Y + TableView_H / 2);

	function RechargeTableView.initTableViewData()
		loadCellSize = 0;
		if CurrentList ~= nil and #CurrentList > 0 then
			--接收排行榜数量
			tableSize = #CurrentList
			--计算一共多少行
			-- rowSize = math.floor((tableSize + (columnSize - 1)) / columnSize)

			columnSize = #CurrentList
		end
	end

	function RechargeTableView.getTableViewInfo()
		local TableViewInfo = {}

		TableViewInfo.TableView_X = TableView_X * GameConfig.ScaleAbscissa;--TableView的左下角X坐标
		TableViewInfo.TableView_Y = TableView_Y * GameConfig.ScaleOrdinate;--TableView的左下角Y坐标
		TableViewInfo.TableView_W = TableView_W * GameConfig.ScaleAbscissa;--TableView的显示宽度
		TableViewInfo.TableView_H = TableView_H * GameConfig.ScaleOrdinate;--TableView的显示高度
		TableViewInfo.rowSize = rowSize;--一共多少行
		TableViewInfo.columnSize = columnSize;--一共多少列
		TableViewInfo.spacingW = spacingW; --横向间隔
		TableViewInfo.spacingH = spacingH; --纵向间隔

		return TableViewInfo
	end

	function RechargeTableView.getCellWidth()
		return cellWidth * GameConfig.ScaleAbscissa;--每个元素的宽
	end

	function RechargeTableView.numberOfrow()
		return columnSize;
	end

	function RechargeTableView.HeightOfCellAtNumberOfRow(i)
		return cellHeight * GameConfig.ScaleOrdinate;--每个元素的高
	end

	local PayRechargeList = {}
	function RechargeTableView.CellOfAtNumberOfRow(cell, i)
		-- 商品名称
		local goodsName = CurrentList[i].goodsName
		-- 价格(单位：分)
		local price = CurrentList[i].price
		--元宝数量
		local goodsCnt = string.match(goodsName, "%d+")
		-- 商品的具体描述
		local goodsDetail = CurrentList[i].goodsDetail
		-- 本次支付的总费
		local goodsPriceDetail = CurrentList[i].goodsPriceDetail
		-- 优惠百分比(%) 例：10
		local mnDiscount = CurrentList[i].mnDiscount
		-- 是否可显示
		local mbIsShow = CurrentList[i].mbIsShow
		-- 支付子类型 默认为0
		local Subtype = CurrentList[i].mnSubtype
		Common.log(" 商品price === "..price)
		Common.log(" 商品名称goodsName === "..goodsName)
		Common.log(" 商品个数goodsCnt === "..goodsCnt)
		Common.log(" 商品的具体描述goodsDetail === "..goodsDetail)
		Common.log(" 本次支付的总费goodsPriceDetail === "..goodsPriceDetail)
		Common.log(" 优惠百分mnDiscount === "..mnDiscount)
		Common.log(" 价格(单位：分)price === "..price)

		--按钮事件
		local function buttonCallBack()
			if(RechargeTableView.isMoved)then
				return
			end
			Common.log("RechargeTableView.buttonCallBack == "..i)
			local isExchange = false
			local function callPaymentFunc()
				PaymentMethod.callPayment(CurrentList[i],PayTypeID,0,isExchange,0)
			end
			callPaymentFunc()
		end

		--父节点layer
		local itemParentNode = CCSprite:create(Common.getResourcePath("px1.png"))
		itemParentNode:setPosition(ccp(cellWidth / 2, cellHeight / 2 + 20))
		itemParentNode:setCascadeOpacityEnabled(true);
		cell:addChild(itemParentNode)

		local layerClick = CCLayer:create()
		rechargeTableMenuListLayer[i] = layerClick;
		cell:addChild(layerClick)
		ccTableView.initTableViewClickedListener(i, 1, itemParentNode, RechargeTableView, buttonCallBack, layerClick)
		--背景图片
		local bg = CCSprite:createWithSpriteFrameName("DN_HALL_recharge_mid_goldframe.png")
		bg:setPosition(ccp(0,0));
		bg:setCascadeOpacityEnabled(true);
		itemParentNode:addChild(bg);

		--元宝图标
		local yuanbaoIcon = "DN_HALL_excharge_cover_gold_4.png"
		if price < 1800 then
			yuanbaoIcon = "DN_HALL_excharge_cover_diamond.png"
		elseif price < 5000 then
			yuanbaoIcon = "DN_HALL_excharge_cover_gold_2.png"
		elseif price < 15000 then
			yuanbaoIcon = "DN_HALL_excharge_cover_gold_3.png"
		else
			yuanbaoIcon = "DN_HALL_excharge_cover_gold_4.png"
		end
		local iconSp = CCSprite:createWithSpriteFrameName(yuanbaoIcon);
		iconSp:setPosition(ccp(0, cellHeight/4));
		itemParentNode:addChild(iconSp);
		--元宝数
		local yuanbaoNumTTF = CCLabelAtlas:create(""..goodsCnt, Common.getResourcePath("DN_HALL_number_gray.png"), 30, 55, 48);
		yuanbaoNumTTF:setScale(0.6)
		yuanbaoNumTTF:setAnchorPoint(ccp(0.5, 0.5));
		yuanbaoNumTTF:setPosition(ccp(0, cellHeight/16));
		itemParentNode:addChild(yuanbaoNumTTF);
		--rmb价格
		local rmbNumTTF = CCLabelAtlas:create("@"..price/100, Common.getResourcePath("DN_HALL_number_golden.png"), 30, 55, 48);
		rmbNumTTF:setAnchorPoint(ccp(0.5, 0.5));
		rmbNumTTF:setScale(0.6);
		rmbNumTTF:setPosition(ccp(0, -cellHeight/4 - 5));
		itemParentNode:addChild(rmbNumTTF);

		--vip加成及首充翻倍
		local totalCnt = goodsCnt
		--首充翻倍。
		if profilePay.PayChannelData.IsRechargeRebate() then
			local doubleSp = CCSprite:createWithSpriteFrameName("DN_HALL_excharge_cover_x2.png")
			doubleSp:setPosition(ccp(cellWidth*0.1+doubleSp:getContentSize().width/2,cellHeight*0.15+doubleSp:getContentSize().height/2))
			itemParentNode:addChild(doubleSp)
			totalCnt = goodsCnt*2;
			if is1920 then
				doubleSp:setScale(1.69)
			end
		end
		--总数量先乘vip加成，向下取整后
		local addCnt = 0
		local percent = profilePay.PayChannelData.getVipAddingPercent()
		if percent > 0 then
			local doubleVipBottomSp = CCSprite:createWithSpriteFrameName("DN_HALL_recharge_mid_goldframe_cover.png")
			doubleVipBottomSp:setPosition(ccp(0, 103))
			itemParentNode:addChild(doubleVipBottomSp)
			if is1920 then
				doubleVipBottomSp:setScale(1.69)
				doubleVipBottomSp:setPosition(ccp(0, 180))
			end

			addCnt = math.floor(goodsCnt*percent/100) --向下取整
			local valueLab= CCLabelTTF:create("加送"..addCnt.."元宝", "Arial", 20)
			valueLab:setColor(ccc3(0xe2,0xff,0xd1))
			valueLab:setAnchorPoint(ccp(0.5,0.5))
			valueLab:setPosition(ccp(doubleVipBottomSp:getContentSize().width*0.5,doubleVipBottomSp:getContentSize().height*0.5))
			doubleVipBottomSp:addChild(valueLab)
			totalCnt = totalCnt + addCnt

		end


		--可兑换多少金币
		local coinCnt = totalCnt * 100 * ServerConfig.getConversionCoefficient()
		local coinStr = ""
		if coinCnt >= 10000 then
			coinCnt = coinCnt / 10000
			coinStr = "可兑换"..coinCnt.."万金币";
		else
			coinStr = "可兑换"..coinCnt.."金币";
		end

		local goodsDetailLab = CCLabelTTF:create(coinStr, "Arial", 18)
		goodsDetailLab:setColor(ccc3(0xff,0xef,0xa6))
		goodsDetailLab:setPosition(ccp(0, -cellHeight/12))
		itemParentNode:addChild(goodsDetailLab);

		if is1920 then
			bg:setScale(1.69)
			iconSp:setScale(1.69)
			yuanbaoNumTTF:setScale(1)
			rmbNumTTF:setScale(1);
			goodsDetailLab:setScale(1.69)
		end

		PayRechargeList[i] = itemParentNode;
		PayRechargeList[i]:setVisible(false);

		if i == tableSize then
			--加载完毕
			local function callbackShowImage(index)
				if PayRechargeList[index] ~= nil then
					PayRechargeList[index]:setVisible(true);
				end
			end

			GamePub.showLandscapeList(PayRechargeList, callbackShowImage);
		end
	end

	--RechargeTableView:setScaleX(GameConfig.ScaleAbscissa);
	--RechargeTableView:setScaleY(GameConfig.ScaleOrdinate);
	view:addChild(RechargeTableView)
	ccTableView.reloadData(RechargeTableView)
end


local function close()
	mvcEngine.destroyModule(GUI_RECHARGE_CENTER);
end

function callback_btn_back(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		GamePub.closeDialogAmin(Panel_dialog, close);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_img_alipay(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		changeRechargeShow(RECHARGE_LIST_ALIPAY)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_img_duanxin(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if Common.getOperater() == Common.CHINA_MOBILE or Common.getOperater() == Common.CHINA_UNICOM
			or Common.getOperater() == Common.CHINA_TELECOM then
			changeRechargeShow(RECHARGE_LIST_SMS)
		else
			--未知运营商
			Common.showToast("设备无法使用短信支付！", 2)
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_img_wechat(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		changeRechargeShow(RECHARGE_WEIXIN);
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_img_iap(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		changeRechargeShow(RECHARGE_IAP)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_vipInfo(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.createModule(GUI_VIPINFO)
	elseif component == CANCEL_UP then
	--取消

	end
end

function updataIAPPay()
	local result = profileCommon.IAPPayResult.getResult()
	local msg = profileCommon.IAPPayResult.getResultText()
	--orderID	Text	订单号	支付的订单号（透传）
	local orderID = profileCommon.IAPPayResult.getResultOrder()
	--0 成功  1 失败
	-- Common.showToast(msg, 2)
	--通知验证成功  取消标记
	Common.log("IAP支付 服务器验证完成 消除订单验证标记")
	profilePay.PaymentResult.removeIapOrderIdVerifyMark(orderID)
end


--展示VIP信息
local function showVipInfo()
	local VipInfoTable = profile.NiuNiuVip.getVipDataTable()
	if VipInfoTable == nil then
		Common.showToast("VIP信息出错,请重试",2)
		return
	end

	local vipLevel = profile.User.getSelfVipLevel()
	local CurrentRecharge = VipInfoTable["CurrentRecharge"] --已充值金额
	local nextLevelRecharge = VipInfoTable["nextLevelRecharge"] --升到下一级所需金额

	local vipBgStr, vipAtlasStr = NiuNiuVipConfig.getVipDetail(vipLevel)
	Image_now_vip:loadTexture(vipBgStr,1)
	if vipAtlasStr ~= "" then
		local nowVipLable = UILabelAtlas:create()
		nowVipLable:setProperty(";"..vipLevel,NiuNiuTableConfig.getResPath(vipAtlasStr), 30, 55, "0")
		nowVipLable:setScale(0.4)
		Image_now_vip:addChild(nowVipLable)
		nowVipLable:setPosition(ccp(-24,0))
	end
	local nextVipBgStr, nextVipAtlasStr = NiuNiuVipConfig.getVipDetail(vipLevel + 1)
	Image_next_vip:loadTexture(nextVipBgStr,1)
	if nextVipAtlasStr ~= "" then
		local nextVipLable = UILabelAtlas:create()
		nextVipLable:setProperty(";"..(vipLevel+1),NiuNiuTableConfig.getResPath(nextVipAtlasStr), 30, 55, "0")
		nextVipLable:setScale(0.4)
		Image_next_vip:addChild(nextVipLable)
		nextVipLable:setPosition(ccp(-24,0))
	end

	ProgressBar_vip:setPercent(CurrentRecharge * 100 / nextLevelRecharge)
	AtlasLabel_vipInfo:setStringValue(CurrentRecharge .. "=" .. nextLevelRecharge)
end

--[[--
--首充翻倍
--]]--
local function slotRECHARGE_REBATE_INFO()
	if profilePay.PayChannelData.IsRechargeRebate() then
		Image_titel:loadTexture("DN_HALL_recharge_bg_bigbrown_mainfnt_double.png",1)
	end

	deleteAllClickedLayer()
	rechargeTableMenuListLayer = {}
	ccTableView.reloadData(RechargeTableView);
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	is1920 = false
end

function addSlot()
	framework.addSlot2Signal(DOUNIU_VIPINFO, showVipInfo)
	framework.addSlot2Signal(RECHARGE_REBATE_INFO, slotRECHARGE_REBATE_INFO);
end

function removeSlot()
	framework.removeSlotFromSignal(DOUNIU_VIPINFO, showVipInfo)
	framework.removeSlotFromSignal(RECHARGE_REBATE_INFO, slotRECHARGE_REBATE_INFO);
end
