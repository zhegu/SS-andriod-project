module("QuickPay", package.seeall)

CurrencyType_COIN = 0--金币（货币类型）
CurrencyType_YUANBAO = 1--元宝（货币类型）

First_Pay_GiftTypeID = 10;-- 首充大礼包
Overflow_Pay_GiftTypeID = 12;-- 超值大礼包
Experience_GiftTypeID = 13;-- 体验大礼包
XianYu_GiftTypeID = 14;-- 咸鱼翻身大礼包
LaoHuJi_GiftTypeID = 1006;-- 老虎机大礼包
QuanEFanHuan_GiftTypeID = 1004;-- 全额返还大礼包
DongShanZaiQi_GiftTypeID = 1005;-- 东山再起大礼包

Pay_Guide_biaoqing_GuideTypeID = 100001;-- 高级表情引导
Pay_Guide_need_coin_GuideTypeID = 100002;-- 游戏中金币不足
Pay_Guide_need_yuanbao_GuideTypeID = 100003;-- 游戏中元宝不足
Pay_Guide_jipai_GiftTypeID = 100004;-- 记牌器引导
Pay_Guide_no_vip_GuideTypeID = 100006;-- 游戏vip不足
Pay_Guide_stone_small_GuideTypeID = 100007; --复活石引导1
Pay_Guide_stone_middle_GuideTypeID = 100008; --复活石引导2
Pay_Guide_stone_large_GuideTypeID = 100009; --复活石引导3
Pay_Guide_changecard_GuideTypeID = 100010;-- 游戏中换牌卡不足
Pay_Guide_no_pk_GuideTypeID = 100011;-- 游戏中禁比卡不足
Pay_Guide_Native_need_coin_GuideTypeID = 100012;-- 游戏中金币不足

Pay_Guide_relive_stone_GuideTypeID = 200001; --购买复活石

Pay_Guide_month_card_GuideTypeID = 200002;--购买月卡

Pay_Guide_first_recharge_GuideTypeID = 200003;--购买首冲

Pay_Guide_pochan_5_GuideTypeID = 200004;--购买破产5元
Pay_Guide_pochan_10_GuideTypeID = 200005;--购买破产10元
Pay_Guide_pochan_30_GuideTypeID = 200006;--购买破产30元

Pay_Guide_week_card_GuideTypeID = 200007;--购买周卡
Pay_Guide_year_card_GuideTypeID = 200008;--购买年卡

GOODS_TYPE_TIME = 1 --时效型道具，单位：天
GOODS_TYPE_NUM = 2 --数量型道具，单位：个

GIFTID_MONTHCARD = 1626 --月卡
GIFTID_FIRSTRECHARGE = 1401 --首冲
GIFTID_BANKRUPTCY_5 = 1455 --破产礼包5元
GIFTID_BANKRUPTCY_10 = 1456 --破产礼包10元
GIFTID_BANKRUPTCY_30 = 1457 --破产礼包30元

local QuickPayDataTable = {}

local function initQuickPayData()
	local productDetail = nil


	--appstore审核版本
	productDetail = {}
	productDetail.name = "高级表情包7天";
	productDetail.price = 6;
	productDetail.GiftID = 3402;
	productDetail.type = GOODS_TYPE_TIME
	productDetail.picName = "ic_shop_item_gaojibiaoqing.png"
	productDetail.GuideType = Pay_Guide_biaoqing_GuideTypeID;
	productDetail.Operater = Common.UNKNOWN;
	productDetail.isChangeCoin = 0;
	table.insert(QuickPayDataTable, productDetail)

	productDetail = {}
	productDetail.name = "禁比卡";
	productDetail.price = 6;
	productDetail.GiftID = 3701;--商品编号
	productDetail.GoodsId = 38;
	productDetail.num = 6
	productDetail.type = GOODS_TYPE_NUM
	productDetail.picName =  "ic_shop_item_jinbi.png"
	productDetail.GuideType = Pay_Guide_no_pk_GuideTypeID;
	productDetail.Operater = Common.UNKNOWN;
	productDetail.isChangeCoin = 0;
	table.insert(QuickPayDataTable, productDetail)

	productDetail = {}
	productDetail.name = "换牌卡";
	productDetail.price = 12;
	productDetail.GiftID = 3702;--商品编号
	productDetail.GoodsId = 37;
	productDetail.num = 12
	productDetail.type = GOODS_TYPE_NUM
	productDetail.picName =  "ic_shop_item_huanpai.png"
	productDetail.GuideType = Pay_Guide_changecard_GuideTypeID;
	productDetail.Operater = Common.UNKNOWN;
	productDetail.isChangeCoin = 0;
	table.insert(QuickPayDataTable, productDetail)

--	--[[----------------------月卡----------------]]--
--
--	productDetail = {}
--	productDetail.name = "月卡";
--	productDetail.price = 30;
--	productDetail.GiftID = 144501;
--	productDetail.num = 1
--	productDetail.type = GOODS_TYPE_NUM
--	productDetail.picName =  "ui_chaozhiyueka.png"
--	productDetail.GuideType = Pay_Guide_month_card_GuideTypeID;
--	productDetail.Operater = Common.UNKNOWN;
--	productDetail.isChangeCoin = 0;
--	table.insert(QuickPayDataTable, productDetail)

	--[[----------------------周卡----------------]]--

	productDetail = {}
	productDetail.name = "周卡";
	productDetail.price = 12;
	productDetail.GiftID = 162702;
	productDetail.num = 1
	productDetail.type = GOODS_TYPE_NUM
--	productDetail.picName =  "ui_chaozhiyueka.png"
	productDetail.picName =  ""
	productDetail.GuideType = Pay_Guide_week_card_GuideTypeID;
	productDetail.Operater = Common.UNKNOWN;
	productDetail.isChangeCoin = 0;
	table.insert(QuickPayDataTable, productDetail)

	--[[----------------------月卡----------------]]--

	productDetail = {}
	productDetail.name = "月卡";
	productDetail.price = 68;
	productDetail.GiftID = 162601;
	productDetail.num = 1
	productDetail.type = GOODS_TYPE_NUM
--	productDetail.picName =  "ui_chaozhiyueka.png"
	productDetail.picName =  ""
	productDetail.GuideType = Pay_Guide_month_card_GuideTypeID;
	productDetail.Operater = Common.UNKNOWN;
	productDetail.isChangeCoin = 0;
	table.insert(QuickPayDataTable, productDetail)

	--[[----------------------年卡----------------]]--

	productDetail = {}
	productDetail.name = "年卡";
	productDetail.price = 648;
	productDetail.GiftID = 162802;
	productDetail.num = 1
	productDetail.type = GOODS_TYPE_NUM
--	productDetail.picName =  "ui_chaozhiyueka.png"
	productDetail.picName =  ""
	productDetail.GuideType = Pay_Guide_year_card_GuideTypeID;
	productDetail.Operater = Common.UNKNOWN;
	productDetail.isChangeCoin = 0;
	table.insert(QuickPayDataTable, productDetail)



	--[[--*********************** 高级表情引导 ***********************]]
	-- MM
	-- productDetail = {}
	-- productDetail.name = "高级表情包10天";
	-- productDetail.price = 5;
	-- productDetail.num = 10;
	-- productDetail.GiftID = 3401;--商品编号
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName = "ic_shop_item_gaojibiaoqing.png"
	-- productDetail.GuideType = Pay_Guide_biaoqing_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "高级表情包10天";
	-- productDetail.price = 5;
	-- productDetail.num = 10;
	-- productDetail.GiftID = 3401;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName = "ic_shop_item_gaojibiaoqing.png"
	-- productDetail.GuideType = Pay_Guide_biaoqing_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "高级表情包10天";
	-- productDetail.price = 5;
	-- productDetail.num = 10;
	-- productDetail.GiftID = 3401;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName = "ic_shop_item_gaojibiaoqing.png"
	-- productDetail.GuideType = Pay_Guide_biaoqing_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "高级表情包10天";
	-- productDetail.price = 5;
	-- productDetail.num = 10;
	-- productDetail.GiftID = 3401;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName = "ic_shop_item_gaojibiaoqing.png"
	-- productDetail.GuideType = Pay_Guide_biaoqing_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- --支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "高级表情包10天";
	-- productDetail.price = 5;
	-- productDetail.num = 10;
	-- productDetail.GiftID = 3401;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName = "ic_shop_item_gaojibiaoqing.png"
	-- productDetail.GuideType = Pay_Guide_biaoqing_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --[[--*********************** 记牌器引导 ***********************]]
	-- -- MM
	-- productDetail = {}
	-- productDetail.name = "记牌器5天";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 3301;--商品编号
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_jipai_GiftTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "记牌器5天";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 3301;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_jipai_GiftTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "记牌器5天";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 3301;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_jipai_GiftTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "记牌器5天";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 3301;
	-- productDetail.num = 10
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_jipai_GiftTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "记牌器5天";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 3301;
	-- productDetail.type = GOODS_TYPE_TIME
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_jipai_GiftTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --[[--*********************** 复活石引导 ***********************]]
	-- -- MM
	-- productDetail = {}
	-- productDetail.name = "复活石5个";
	-- productDetail.price = 6;
	-- productDetail.GiftID = 4203;--商品编号
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_small_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "复活石5个";
	-- productDetail.price = 6;
	-- productDetail.GiftID = 4203;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_small_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "复活石5个";
	-- productDetail.price = 6;
	-- productDetail.GiftID = 4201;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_small_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "复活石5个";
	-- productDetail.price = 6;
	-- productDetail.GiftID = 4202;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_small_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "复活石5个";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 4212;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_small_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- -- MM
	-- productDetail = {}
	-- productDetail.name = "复活石8个";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 4206;--商品编号
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_middle_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "复活石8个";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 4206;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_middle_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "复活石8个";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 4204;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_middle_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "复活石8个";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 4205;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_middle_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "复活石10个";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 4207;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_middle_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- -- MM
	-- productDetail = {}
	-- productDetail.name = "复活石17个";
	-- productDetail.price = 20;
	-- productDetail.GiftID = 4210;--商品编号
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_large_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "复活石17个";
	-- productDetail.price = 20;
	-- productDetail.GiftID = 4210;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_large_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "复活石17个";
	-- productDetail.price = 20;
	-- productDetail.GiftID = 4208;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_large_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "复活石13个";
	-- productDetail.price = 15;
	-- productDetail.GiftID = 4209;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_large_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "复活石20个";
	-- productDetail.price = 20;
	-- productDetail.GiftID = 4211;
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_chuangguan_fuhuoshi.png"
	-- productDetail.GuideType = Pay_Guide_stone_large_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --[[--*********************** 换牌卡引导 ***********************]]
	-- -- MM
	-- productDetail = {}
	-- productDetail.name = "换牌卡";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 37;--商品编号
	-- productDetail.num = 10
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_changecard_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "换牌卡";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 37;
	-- productDetail.num = 10
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_changecard_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "换牌卡";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 37;
	-- productDetail.num = 10
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_changecard_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "换牌卡";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 37;
	-- productDetail.num = 10
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_changecard_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "换牌卡";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 37;
	-- productDetail.num = 10
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_huanpai.png"
	-- productDetail.GuideType = Pay_Guide_changecard_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- --[[--*********************** 禁比卡引导 ***********************]]
	-- -- MM
	-- productDetail = {}
	-- productDetail.name = "禁比卡";
	-- productDetail.price = 3;
	-- productDetail.GiftID = 38;--商品编号
	-- productDetail.num = 3
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_jinbi.png"
	-- productDetail.GuideType = Pay_Guide_no_pk_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = false;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 移动基地
	-- productDetail = {}
	-- productDetail.name = "禁比卡";
	-- productDetail.price = 3;
	-- productDetail.GiftID = 38;
	-- productDetail.num = 3
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_jinbi.png"
	-- productDetail.GuideType = Pay_Guide_no_pk_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_MOBILE;
	-- productDetail.isChangeCoin = 0;
	-- productDetail.isSmsOnline = true;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 联通
	-- productDetail = {}
	-- productDetail.name = "禁比卡";
	-- productDetail.price = 3;
	-- productDetail.GiftID = 38;
	-- productDetail.num = 3
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_jinbi.png"
	-- productDetail.GuideType = Pay_Guide_no_pk_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_UNICOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 天翼空间电信
	-- productDetail = {}
	-- productDetail.name = "禁比卡";
	-- productDetail.price = 3;
	-- productDetail.GiftID = 38;
	-- productDetail.num = 3
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_jinbi.png"
	-- productDetail.GuideType = Pay_Guide_no_pk_GuideTypeID;
	-- productDetail.Operater = Common.CHINA_TELECOM;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)
	-- -- 支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "禁比卡";
	-- productDetail.price = 3;
	-- productDetail.GiftID = 38;
	-- productDetail.num = 3
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ic_shop_item_jinbi.png"
	-- productDetail.GuideType = Pay_Guide_no_pk_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --[[----------------------月卡----------------]]--
	-- --支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "月卡";
	-- productDetail.price = 30;
	-- productDetail.GiftID = 144501;
	-- productDetail.num = 1
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ui_chaozhiyueka.png"
	-- productDetail.GuideType = Pay_Guide_month_card_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --[[----------------------首冲礼包----------------]]--
	-- --支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "首冲礼包";
	-- productDetail.price = 10;
	-- productDetail.GiftID = 140101;
	-- productDetail.num = 1
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ui_chaozhiyueka.png"
	-- productDetail.GuideType = Pay_Guide_first_recharge_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --[[----------------------破产礼包----------------]]--
	-- --支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "破产礼包5元";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 145501;
	-- productDetail.num = 1
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ui_chaozhiyueka.png"
	-- productDetail.GuideType = Pay_Guide_pochan_5_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "破产礼包10元";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 145601;
	-- productDetail.num = 1
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ui_chaozhiyueka.png"
	-- productDetail.GuideType = Pay_Guide_pochan_10_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)

	-- --支付宝/银联
	-- productDetail = {}
	-- productDetail.name = "破产礼包30元";
	-- productDetail.price = 5;
	-- productDetail.GiftID = 145701;
	-- productDetail.num = 1
	-- productDetail.type = GOODS_TYPE_NUM
	-- productDetail.picName =  "ui_chaozhiyueka.png"
	-- productDetail.GuideType = Pay_Guide_pochan_30_GuideTypeID;
	-- productDetail.Operater = Common.UNKNOWN;
	-- productDetail.isChangeCoin = 0;
	-- table.insert(QuickPayDataTable, productDetail)


end

initQuickPayData()


--[[--
-- 根据GiftID，获取GuideType
-- @param GuideType
-- @return
]]
function getGuideTypeByGiftID(GiftID)
	for key, var in ipairs(QuickPayDataTable) do
		if GiftID  == QuickPayDataTable[key].GiftID then
			Common.log("GiftIDmmm  = " .. GiftID)
			return QuickPayDataTable[key].GuideType;
		end
	end
end

--[[--
-- 根据礼包类型及价格，获取支付数据
-- @param GuideType
-- @return
]]
function getSMSProductDetail(GuideType)

	local mSMSData = nil

	for key, var in ipairs(QuickPayDataTable) do
		if var.GuideType == GuideType and var.Operater == Common.getOperater() then
			if Common.getOperater() == Common.CHINA_MOBILE then
				if PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_MM_OTHERS then
					--MM
					if var.isSmsOnline == false then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_SMSONLINE_OTHERS then
					--游戏基地
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_ONLY_PURSE then
					--手机钱包
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_YINBEIKE_CMCC then
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_YINBEIKE_UNI then
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_YINBEIKE_CT then
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_CMCC then
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_UNICOM then
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_CT then
					if var.isSmsOnline == true then
						mSMSData = var
						break
					end
				end
			else
				mSMSData = var
				break
			end
		end
	end

	if mSMSData == nil then
		for key, var in ipairs(QuickPayDataTable) do
			if var.GuideType == GuideType and var.Operater == Common.UNKNOWN then
				mSMSData = var
				break
			end
		end
	end

	return mSMSData;
end

--[[--
--通过价格获取支付信息
--@param #table CurrentList 支付数据
--@param #number price 价格(元)
--@return #table 获取到的支付信息
]]
local function getPaymentTableForPrice(CurrentList, price)
	local miniPaymentData = -1
	local PaymentTable = nil
	for key, var in ipairs(CurrentList) do
		if price < 0 then
			if (var.price * -1) == price then
				--满足需求
				PaymentTable = Common.copyTab(var)
				break;
			end
		else
			if var.price == price * 100 then
				--满足需求
				PaymentTable = Common.copyTab(var)
				break;
			end
		end
	end
	return PaymentTable
end

--[[--
--动态生成一个支付宝/银联支付信息
--@param #number price 价格(元)
--@param #number name 名称
--@param #number GiftID 礼包ID
]]
local function getNewPaymentTable(price, name, GiftID)
	local tempTable = {}
	--支付宝
	if price ~= nil and name ~= nil and GiftID ~= nil then
		tempTable.goodsName = name;
		tempTable.GiftID = GiftID;
	else
		tempTable.goodsName = price * 10 .. "元宝" -- 商品名称
		tempTable.GiftID = 0;
	end
	tempTable.goodsDetail = "可兑换".. price * 1000 * ServerConfig.getConversionCoefficient() .. "金币" -- 商品的具体描述
	tempTable.goodsPriceDetail = "价格:￥".. price .. ".00" -- 本次支付的总费
	tempTable.mnDiscount = 0 -- 优惠百分比(%) 例：10
	tempTable.mnSubtype = 0 -- 支付子类型 默认为0
	tempTable.price = price * 100 -- 价格(单位：分)
	tempTable.PayTypeID = profilePay.PayChannelData.ALI_PAY

	return tempTable
end

--[[--
--通过需要购买的元宝数获取支付信息
--@param #table CurrentList 支付数据
--@param #number YuanBaoNum 元宝数
--@return #table 获取到的支付信息
]]
local function getPaymentTableForYuanBao(CurrentList, YuanBaoNum)
	local miniPaymentData = -1--符合规则的最小支付信息
	local MaxYuanBao = 0;--最大支付信息
	local PaymentTable = nil
	for key, var in ipairs(CurrentList) do
		local tempYuanBao = string.match(var.goodsName, "%d+")
		if tempYuanBao ~= nil then
			tempYuanBao = tonumber(tempYuanBao)
			if tempYuanBao >= YuanBaoNum then
				--满足需求
				if miniPaymentData < 0 then
					miniPaymentData = tempYuanBao
				end
				if miniPaymentData >= tempYuanBao then
					--找到满足需求的最小值
					miniPaymentData = tempYuanBao
					PaymentTable = var
				end
			end
		end
	end

	if PaymentTable == nil then
		--无符合的支付宝/银联支付信息，取最大值
		for key, var in ipairs(CurrentList) do
			if var.PayTypeID == profilePay.PayChannelData.WEIXIN_PAY
				or var.PayTypeID == profilePay.PayChannelData.ALI_PAY
				or var.PayTypeID == profilePay.PayChannelData.NEW_UNION_PAY
				or var.PayTypeID == profilePay.PayChannelData.IAP_PAY then

				local tempYuanBao = string.match(var.goodsName, "%d+")
				if tempYuanBao ~= nil then
					tempYuanBao = tonumber(tempYuanBao)
					if tempYuanBao >= MaxYuanBao then
						MaxYuanBao = tempYuanBao
						PaymentTable = var
					end
				end

			end
		end
	end
	return PaymentTable
end

--[[--
--获取充值数据
--@param #number GuideType 引导类型
--@param #number needCurrencyNum 需要的货币数量
--@param boolean isSearchSMS 是否检索短代支付列表
--]]
function getPaymentTable(GuideType, needCurrencyNum, giftID, isSearchSMS)
	local PaymentTable = {};
	if GuideType == Pay_Guide_need_coin_GuideTypeID or GuideType == Pay_Guide_Native_need_coin_GuideTypeID then
		--购买金币
		PaymentTable = getPaymentTableForPayGuide(needCurrencyNum, GuideType, giftID, isSearchSMS);
	elseif GuideType == Pay_Guide_need_yuanbao_GuideTypeID then
		--购买元宝
		PaymentTable = getPaymentTableForPayGuide(needCurrencyNum * 100 * ServerConfig.getConversionCoefficient(), GuideType, giftID, isSearchSMS);
	elseif GuideType == Pay_Guide_no_vip_GuideTypeID then
		--购买vip
		PaymentTable = getPaymentTableForPayGuide(needCurrencyNum * 100 * ServerConfig.getConversionCoefficient(), GuideType, giftID, isSearchSMS);
	else
		PaymentTable = getPaymentTableForPayGuide(needCurrencyNum, GuideType, giftID, isSearchSMS);
	--非购买金币元宝
	end
	return PaymentTable;
end

--[[--
--获取充值引导支付信息
--@param #number CoinNum 所要购买的金币数
--@param #number GuideType 礼包类型
--@param boolean isSearchSMS 是否检索短代支付列表
--@return #table 支付信息
]]
function getPaymentTableForPayGuide(CoinNum, GuideType, giftID, isSearchSMS)
	local CurrentList = nil
	local PaymentTable = nil
	local productDetail = nil --充值引导的配置信息
	local PayTypeID = -1 --支付类型
	local GiftID = nil --礼包ID
	Common.log("CoinNum ================== "..CoinNum)
	local YuanBaoNum = math.floor((CoinNum + 99 * ServerConfig.getConversionCoefficient()) / (100 * ServerConfig.getConversionCoefficient()))--需要的元宝数
	if isSearchSMS then
		Common.log("isSearchSMS is ============== ")
	end
	Common.log("YuanBaoNum is " .. YuanBaoNum)

	if GuideType ==  Pay_Guide_biaoqing_GuideTypeID or GuideType ==  Pay_Guide_jipai_GiftTypeID
		or GuideType == Pay_Guide_stone_small_GuideTypeID or GuideType == Pay_Guide_stone_middle_GuideTypeID or GuideType == Pay_Guide_stone_large_GuideTypeID
		or GuideType == Pay_Guide_no_pk_GuideTypeID or GuideType == Pay_Guide_changecard_GuideTypeID or GuideType == Pay_Guide_month_card_GuideTypeID or GuideType == Pay_Guide_week_card_GuideTypeID or GuideType == Pay_Guide_year_card_GuideTypeID
		or GuideType == Pay_Guide_first_recharge_GuideTypeID or GuideType == Pay_Guide_pochan_5_GuideTypeID or GuideType == Pay_Guide_pochan_10_GuideTypeID or GuideType == Pay_Guide_pochan_30_GuideTypeID then
		-- 高级表情引导or记牌器引导or复活石
		productDetail = getSMSProductDetail(GuideType);
		if productDetail == nil then
			Common.log("xwh productDetail is nil")
		else
			Common.log("xwh productDetail not nil")
			GiftID = productDetail.GiftID
			Common.log("GiftID  = = " .. GiftID)
		end
	elseif GuideType ==  Pay_Guide_need_coin_GuideTypeID or GuideType == Pay_Guide_Native_need_coin_GuideTypeID or GuideType ==  Pay_Guide_need_yuanbao_GuideTypeID then
		-- 游戏中金币或者元宝不足
		productDetail = nil
		if giftID ~= nil then
			GiftID = giftID
		else
			GiftID = 0
		end
	elseif GuideType == Pay_Guide_no_vip_GuideTypeID then
		-- 游戏中充值vip
		productDetail = nil
		if giftID ~= nil then
			GiftID = giftID
		else
			GiftID = 0
		end
	end

	if Common.platform == Common.TargetIos then
		if ServerConfig.isAppstoreReview() then
			if GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
				--iap
				CurrentList = profilePay.PayChannelData.getIAPAllListData()
				PayTypeID = profilePay.PayChannelData.IAP_PAY
			elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
				--91
				CurrentList = profilePay.PayChannelData.getBaidu91AllListData()
				PayTypeID = profilePay.PayChannelData.RECHARGE_91
			elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
				CurrentList = profilePay.PayChannelData.getHaiMaAllListData()
				PayTypeID = profilePay.PayChannelData.HAIMA_PAY
			end

			if CurrentList ~= nil then
				--有sim卡
				if productDetail == nil then
					--非配置引导信息
					PaymentTable = getPaymentTableForYuanBao(CurrentList, YuanBaoNum)
				else
					--已配置的引导信息
					PaymentTable = getPaymentTableForPrice(CurrentList, productDetail.price)
					if PaymentTable ~= nil then
						PaymentTable.goodsName = productDetail.name
					end
				end
			end
		else
			if PaymentTable == nil then
				--在运营商中未找到合适的支付信息
				--未知运营商,使用支付宝、银联、微信
				if getNotSMSPaymentType() == profilePay.PayChannelData.WEIXIN_PAY then
					CurrentList = profilePay.PayChannelData.getWeiXinAllListData()
					PayTypeID = profilePay.PayChannelData.WEIXIN_PAY
				elseif getNotSMSPaymentType() == profilePay.PayChannelData.ALI_PAY then
					CurrentList = profilePay.PayChannelData.getAliPayAllListData()
					PayTypeID = profilePay.PayChannelData.ALI_PAY
				end

				if CurrentList ~= nil then
					--有sim卡
					if productDetail == nil then
						--非配置引导信息
						PaymentTable = getPaymentTableForYuanBao(CurrentList, YuanBaoNum)
					else
						--已配置的引导信息
						PaymentTable = getNewPaymentTable(productDetail.price, productDetail.name, productDetail.GiftID)
						if PaymentTable ~= nil then
							PaymentTable.goodsName = productDetail.name
						end
					end
				end
			end
		end
	elseif Common.platform == Common.TargetAndroid then
		--如果是android平台的话，要判断
		local operator = Common.getOperater()
		if operator ~= 0 and isSearchSMS and ServerConfig.getGiftCanUseSms() then
			if Common.getOperater() == Common.CHINA_MOBILE then
				--移动
				if PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_MM_OTHERS then
					--MM
					CurrentList = profilePay.PayChannelData.getMMAllListData()
					PayTypeID = profilePay.PayChannelData.MM_PAY_V2
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_SMSONLINE_OTHERS then
					--游戏基地
					CurrentList = profilePay.PayChannelData.getSMSOnlineAllListData()
					PayTypeID = profilePay.PayChannelData.SMS_ONLINE
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					CurrentList = profilePay.PayChannelData.getEPayAllListData()
					PayTypeID = profilePay.PayChannelData.EPAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_YINBEIKE_CMCC then
					CurrentList = profilePay.PayChannelData.getYINBEIKEPayShowListData()
					PayTypeID = profilePay.PayChannelData.YINBEIKEPAY_CMCC
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_CMCC then
					CurrentList = profilePay.PayChannelData.getHongRuanPayShowListData_CMCC()
					PayTypeID = profilePay.PayChannelData.HONGRUAN_SDK_CMCC
				end
			elseif Common.getOperater() == Common.CHINA_UNICOM then
				--联通
				if PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_WOSTORE_OTHERS then
					--沃商店
					CurrentList = profilePay.PayChannelData.getUnicomAllListData()
					PayTypeID = profilePay.PayChannelData.SMS_UNICOM
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS then
					CurrentList = profilePay.PayChannelData.getHuaJianUnicomAllListData()
					PayTypeID = profilePay.PayChannelData.HUAJIAN_LIANTONG_PAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					CurrentList = profilePay.PayChannelData.getEPayAllListData()
					PayTypeID = profilePay.PayChannelData.EPAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_YINBEIKE_UNI then
					--银贝壳
					CurrentList = profilePay.PayChannelData.getYINBEIKEPayShowListData_UNI()
					PayTypeID = profilePay.PayChannelData.YINBEIKEPAY_UNI
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_UNICOM then
					--红软
					CurrentList = profilePay.PayChannelData.getHongRuanPayShowListData_UNI()
					PayTypeID = profilePay.PayChannelData.HONGRUAN_SDK_UNICOM
				end
			elseif Common.getOperater() == Common.CHINA_TELECOM then
				--电信
				if PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_HUAJIAN_OTHERS then
					--华建电信
					CurrentList = profilePay.PayChannelData.getHuaJianTelecomAllListData()
					PayTypeID = profilePay.PayChannelData.HUAJIAN_DIANXIN_PAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					CurrentList = profilePay.PayChannelData.getEPayAllListData()
					PayTypeID = profilePay.PayChannelData.EPAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_YINBEIKE_CT then
					--银贝壳
					CurrentList = profilePay.PayChannelData.getYINBEIKEPayShowListData_CT()
					PayTypeID = profilePay.PayChannelData.YINBEIKEPAY_CT
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == GameConfig.HONGRUAN_SDK_CT then
					--红软
					CurrentList = profilePay.PayChannelData.getHongRuanPayShowListDataCMCC_CT()
					PayTypeID = profilePay.PayChannelData.HONGRUAN_SDK_CT
				end
			end
		end

		if CurrentList ~= nil then
			--有sim卡
			if productDetail == nil then
				--非配置引导信息
				PaymentTable = getPaymentTableForYuanBao(CurrentList, YuanBaoNum)
			else
				--已配置的引导信息
				PaymentTable = getPaymentTableForPrice(CurrentList, productDetail.price)
				if PaymentTable ~= nil then
					PaymentTable.goodsName = productDetail.name
				end
			end
		end

		if PaymentTable == nil then
			--在运营商中未找到合适的支付信息
			--未知运营商,使用支付宝、银联、微信
			if getNotSMSPaymentType() == profilePay.PayChannelData.ALI_PAY then
				CurrentList = profilePay.PayChannelData.getAliPayAllListData()
				PayTypeID = profilePay.PayChannelData.ALI_PAY
			elseif getNotSMSPaymentType() == profilePay.PayChannelData.NEW_UNION_PAY then
				CurrentList = profilePay.PayChannelData.getUnionAllListData()
				PayTypeID = profilePay.PayChannelData.NEW_UNION_PAY
			elseif getNotSMSPaymentType() == profilePay.PayChannelData.WEIXIN_PAY then
				CurrentList = profilePay.PayChannelData.getWeiXinAllListData()
				PayTypeID = profilePay.PayChannelData.WEIXIN_PAY
			end

			if CurrentList ~= nil then
				--有sim卡
				if productDetail == nil then
					--非配置引导信息
					Common.log("非配置引导信息")
					PaymentTable = getPaymentTableForYuanBao(CurrentList, YuanBaoNum)
				else
					--已配置的引导信息
					Common.log("已配置的引导信息")
					PaymentTable = getNewPaymentTable(productDetail.price, productDetail.name, productDetail.GiftID)
					if PaymentTable ~= nil then
						PaymentTable.goodsName = productDetail.name
					end
				end
			end
		end
	end

	if PaymentTable ~= nil then
		PaymentTable.GiftID = GiftID
		PaymentTable.PayTypeID = PayTypeID
	else
		Common.showToast("支付功能暂未开通！", 2);
	end

	return PaymentTable
end

--[[--
--获取礼包支付信息
--@param #number price 所要购买的价格
--@param #number GuideType 礼包ID
--@param boolean isSearchSMS 是否检索短代支付列表
--@return #table 支付信息
]]
function getPaymentTableForGift(price, GiftID, isSearchSMS)

	local CurrentList = nil
	local PaymentTable = nil
	local PayTypeID = -1 --支付类型
	if Common.platform == Common.TargetIos then
		if ServerConfig.isAppstoreReview() then
			if GameConfig.PaymentForIphone == GameConfig.PAYMENT_IAP then
				--iap
				CurrentList = profilePay.PayChannelData.getIAPAllListData()
				PayTypeID = profilePay.PayChannelData.IAP_PAY
			elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_91 then
				--91
				CurrentList = profilePay.PayChannelData.getBaidu91AllListData()
				PayTypeID = profilePay.PayChannelData.RECHARGE_91
			elseif GameConfig.PaymentForIphone == GameConfig.PAYMENT_HAIMA then
				CurrentList = profilePay.PayChannelData.getHaiMaAllListData()
				PayTypeID = profilePay.PayChannelData.HAIMA_PAY
			end

			if CurrentList ~= nil then
				--已配置的引导信息
				PaymentTable = getPaymentTableForPrice(CurrentList, price)
			end
		else
			if PaymentTable == nil then
				--在运营商中未找到合适的支付信息
				--未知运营商,使用支付宝、银联、微信
				if getNotSMSPaymentType() == profilePay.PayChannelData.ALI_PAY then
					CurrentList = profilePay.PayChannelData.getAliPayAllListData()
					PayTypeID = profilePay.PayChannelData.ALI_PAY
				elseif getNotSMSPaymentType() == profilePay.PayChannelData.NEW_UNION_PAY then
					CurrentList = profilePay.PayChannelData.getUnionAllListData()
					PayTypeID = profilePay.PayChannelData.NEW_UNION_PAY
				elseif getNotSMSPaymentType() == profilePay.PayChannelData.WEIXIN_PAY then
					CurrentList = profilePay.PayChannelData.getWeiXinAllListData()
					PayTypeID = profilePay.PayChannelData.WEIXIN_PAY
				end

				if CurrentList ~= nil then
					--有sim卡
					PaymentTable = getPaymentTableForPrice(CurrentList, price)
				end
			end

			if PaymentTable == nil then
				--运营商，支付宝银联都没有匹配价格,则动态生成支付信息
				PaymentTable = getNewPaymentTable(price)
			end
		end
	elseif Common.platform == Common.TargetAndroid then
		local operator = Common.getOperater()
		if operator ~= 0 and isSearchSMS and ServerConfig.getGiftCanUseSms() then
			if Common.getOperater() == Common.CHINA_MOBILE then
				--移动
				if PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_MM_OTHERS then
					--MM
					CurrentList = profilePay.PayChannelData.getMMAllListData()
					PayTypeID = profilePay.PayChannelData.MM_PAY_V2
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_SMSONLINE_OTHERS then
					--游戏基地
					CurrentList = profilePay.PayChannelData.getSMSOnlineAllListData()
					PayTypeID = profilePay.PayChannelData.SMS_ONLINE
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					CurrentList = profilePay.PayChannelData.getEPayAllListData()
					PayTypeID = profilePay.PayChannelData.EPAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_YINBEIKE_CMCC then
					--银贝壳移动
					CurrentList = profilePay.PayChannelData.getYINBEIKEPayShowListData()
					PayTypeID = profilePay.PayChannelData.YINBEIKEPAY_CMCC
				elseif PaymentConfig.PAYMENT_METHOD_STATUS == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_CMCC then
					--红软移动
					CurrentList = profilePay.PayChannelData.getHongRuanPayShowListData_CMCC()
					PayTypeID = profilePay.PayChannelData.HONGRUAN_SDK_CMCC
				end

			elseif Common.getOperater() == Common.CHINA_UNICOM then
				--联通
				if PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_WOSTORE_OTHERS then
					--沃商店
					CurrentList = profilePay.PayChannelData.getUnicomAllListData()
					PayTypeID = profilePay.PayChannelData.SMS_UNICOM
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_HUAJIAN_UNICOM_OTHERS then
					CurrentList = profilePay.PayChannelData.getHuaJianUnicomAllListData()
					PayTypeID = profilePay.PayChannelData.HUAJIAN_LIANTONG_PAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					CurrentList = profilePay.PayChannelData.getEPayAllListData()
					PayTypeID = profilePay.PayChannelData.EPAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_YINBEIKE_UNI then
					--银贝壳联通
					CurrentList = profilePay.PayChannelData.getYINBEIKEPayShowListData_UNI()
					PayTypeID = profilePay.PayChannelData.YINBEIKEPAY_UNI
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_LIANTONG == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_UNICOM then
					--红软联通
					CurrentList = profilePay.PayChannelData.getHongRuanPayShowListData_UNI()
					PayTypeID = profilePay.PayChannelData.HONGRUAN_SDK_UNICOM
				end
			elseif Common.getOperater() == Common.CHINA_TELECOM then
				--电信
				if PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_HUAJIAN_OTHERS then
					--华建电信
					CurrentList = profilePay.PayChannelData.getHuaJianTelecomAllListData()
					PayTypeID = profilePay.PayChannelData.HUAJIAN_DIANXIN_PAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_EPAY then
					--宜支付
					CurrentList = profilePay.PayChannelData.getEPayAllListData()
					PayTypeID = profilePay.PayChannelData.EPAY
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_YINBEIKE_CT then
					--银贝壳电信
					CurrentList = profilePay.PayChannelData.getYINBEIKEPayShowListData_CT()
					PayTypeID = profilePay.PayChannelData.YINBEIKEPAY_CT
				elseif PaymentConfig.PAYMENT_METHOD_STATUS_DIANXIN == PaymentConfig.PAYMENT_SHOW_HONGRUAN_SDK_CT then
					--红软电信
					CurrentList = profilePay.PayChannelData.getHongRuanPayShowListDataCMCC_CT()
					PayTypeID = profilePay.PayChannelData.HONGRUAN_SDK_CT
				end
			end
		end

		if CurrentList ~= nil then
			--有sim卡
			PaymentTable = getPaymentTableForPrice(CurrentList, price)
		end

		if PaymentTable == nil then
			--在运营商中未找到合适的支付信息
			--未知运营商,使用支付宝、银联、微信
			if getNotSMSPaymentType() == profilePay.PayChannelData.ALI_PAY then
				CurrentList = profilePay.PayChannelData.getAliPayAllListData()
				PayTypeID = profilePay.PayChannelData.ALI_PAY
			elseif getNotSMSPaymentType() == profilePay.PayChannelData.NEW_UNION_PAY then
				CurrentList = profilePay.PayChannelData.getUnionAllListData()
				PayTypeID = profilePay.PayChannelData.NEW_UNION_PAY
			elseif getNotSMSPaymentType() == profilePay.PayChannelData.WEIXIN_PAY then
				CurrentList = profilePay.PayChannelData.getWeiXinAllListData()
				PayTypeID = profilePay.PayChannelData.WEIXIN_PAY
			end

			if CurrentList ~= nil then
				--有sim卡
				PaymentTable = getPaymentTableForPrice(CurrentList, price)
			end
		end

		if PaymentTable == nil then
			--运营商，支付宝银联都没有匹配价格,则动态生成支付信息
			PaymentTable = getNewPaymentTable(price)
		end
	end

	if PaymentTable ~= nil then
		PaymentTable.GiftID = GiftID
		PaymentTable.PayTypeID = PayTypeID
	else
		Common.showToast("支付功能暂未开通！", 2);
	end

	return PaymentTable
end

--[[--
--支付
--@param #table PaymentTable 支付信息
--@param #number PayTypeID 支付类型
--@param #number position 位置信息
--@param #boolean isChangeCoin 是否兑换金币
--]]
function PayGuide(PaymentTable, PayTypeID, position, isChangeCoin)
	if PaymentTable ~= nil then
		PaymentMethod.callPayment(PaymentTable, PayTypeID, PaymentTable.GiftID, isChangeCoin, position)
	end
end

--[[--
--是否可以使用支付宝
--]]
function aliPayIsPaySupported()
	if Common.platform == Common.TargetWindows then
		--windows平台
		return false
	elseif Common.platform == Common.TargetIos then
		--ios平台
		return true
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local javaClassName = "org.tongqu.client.pay.PaymentConfig"
		local javaMethodName = "luaCallAliPayIsPaySupported"
		local javaParams = {  }
		local javaMethodSig = "()Z"
		local ok, IsPaySupported = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			return IsPaySupported
		else
			return false
		end
	end
end

--[[--
--是否可以使用银联
--]]
function unionIsPaySupported()
	if Common.platform == Common.TargetWindows then
		--windows平台
		return false
	elseif Common.platform == Common.TargetIos then
		--ios平台
		return false
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local javaClassName = "org.tongqu.client.pay.PaymentConfig"
		local javaMethodName = "luaCallNewUnionIsPaySupported"
		local javaParams = {  }
		local javaMethodSig = "()Z"
		local ok, IsPaySupported = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			return IsPaySupported
		else
			return false
		end
	end
end

--[[--
--是否可以使用微信
--]]
function weiXinIsPaySupported()
	if Common.platform == Common.TargetWindows then
		--windows平台
		return false
	elseif Common.platform == Common.TargetIos then
		--ios平台
		return true
	elseif Common.platform == Common.TargetAndroid then
		--android平台
		local javaClassName = "org.tongqu.client.pay.PaymentConfig"
		local javaMethodName = "luaCallWeiXinIsPaySupported"
		local javaParams = {  }
		local javaMethodSig = "()Z"
		local ok, IsPaySupported = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

		if ok then
			return IsPaySupported
		else
			return false
		end
	end
end

--[[--
--获取非短代类的支付方式(自有渠道)
--@return #number 支付方式
--]]
function getNotSMSPaymentType()
	local type = Common.getDataForSqlite(CommSqliteConfig.RECENT_RECHARGE_MEHTOD);

	if type ~= nil or type ~= "" then
		if type == "alipay" then
			--支付宝
			if aliPayIsPaySupported() then
				return profilePay.PayChannelData.ALI_PAY
			end
		--elseif type == "union" then
		--	--银联
		--	if unionIsPaySupported() then
		--		return profilePay.PayChannelData.NEW_UNION_PAY
		--	end
		elseif type == "weixin" then
			--微信
			if weiXinIsPaySupported() then
				return profilePay.PayChannelData.WEIXIN_PAY
			end
		end
	end

	--银联
	--if unionIsPaySupported() then
	--	return profilePay.PayChannelData.NEW_UNION_PAY
	--end

	--支付宝
	if aliPayIsPaySupported() then
		return profilePay.PayChannelData.ALI_PAY
	end

	--微信
	if weiXinIsPaySupported() then
		return profilePay.PayChannelData.WEIXIN_PAY
	end

	return profilePay.PayChannelData.NEW_UNION_PAY;
end
