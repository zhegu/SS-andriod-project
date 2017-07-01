module("ServerConfig", package.seeall)

--服务器通用配置名称

-- 斗地主：不显示平台的渠道
LORD_NO_SHOW_PLATFORM_CHANNEL = "lord_is_show_platform_for_lua";
-- 斗地主：不显示礼包的渠道
LORD_IS_SHOW_GIFT_FOR_LUA = "lord_is_show_gift_for_lua";
-- 斗地主：不显示充值引导的渠道
LORD_IS_SHOW_QUICK_PAY_FOR_LUA = "lord_is_show_quick_pay_for_lua";
-- 渠道是否显示所有支付
SHOW_SMS_PAY_SWITCH = "lord_only_show_sms_way_channel_236";
-- 下载pad版本提示信息
LORD_DOWNLOAD_PAD_PROMPT_MSG = "lord_download_pad_prompt_msg";
-- 关闭/显示老虎机的开关
LORD_SHOW_SLOT_SWITCH = "lord_show_slot_switch";
-- MM APPID和APPKEY
LORD_MM_V2_APPID_AND_APPKEY = "lord_mm_v2_appid_and_appkey";
-- 显示移动快捷支付的二次确认框
LORD_SHOW_YIDONG_RECHARGE_SECONDARY_CONFIRMATION = "lord_show_yidong_recharge_secondary_confirmation";
-- 显示一键注册
LORD_SHOW_AUTO_REGISTER = "lord_show_auto_register";
--是否显示一键注册 否则显示找回密码
isShowAutoRegister = false;

LORD_CMPAY_MT_FILTER = "lord_cmpay_mt_filter" --手机钱包正则表达式配置
HAS_GET_PURES_MATCHES = false --手机钱包正则表达式配置是否已经获取

LORD_OPRATIONAL_BTN_URL = "lord_oprational_btn_url" --获取首页活动icon地址配置
Has_GET_OPRATIONAL_BTN_URL = false  --是否已经获取首页活动icon地址配置

LORD_DENY_SMS_LIST = "lord_deny_sms_list" --获取手机钱包2正则表达式配置

LORD_GIFT_CAN_USE_SMS = "lord_gift_can_use_sms" --礼包和充值引导是否使用短信购买

LORD_IS_APPSTORE_REVIEW = "lord_is_appstore_review" --是否为appstore审核版本
ENABLE_CROSS_PROMOTION = "enable_cross_promotion" --交叉推广开关

APPSTORE_GAME_URL = "appstore_game_url" --appStore评价引导地址

APPSTORE_COMMENT_GUIDE = "appstore_comment_guide" --appStore评价引导提示语

--ENABLE_UPLOAD_LUA_EX = "enable_upload_lua_ex"--是否可以上传lua异常

--ENABLE_WEIXIN_LOGIN = "enable_weixin_login" --是否可以使用微信登录及微信绑定

CONVERSION_COEFFICIENT = "yuanbao_to_coin_coefficient"--1元宝转100金币*转换系数

maMessage = {
	LORD_IS_SHOW_GIFT_FOR_LUA,
	LORD_IS_SHOW_QUICK_PAY_FOR_LUA,
	LORD_GIFT_CAN_USE_SMS,
	LORD_DENY_SMS_LIST,
	LORD_IS_APPSTORE_REVIEW,
	ENABLE_CROSS_PROMOTION,
	APPSTORE_GAME_URL,
	APPSTORE_COMMENT_GUIDE,
	CONVERSION_COEFFICIENT
}

--[[--
--获取元宝转金币系数,1元宝转100金币*转换系数
--]]
function getConversionCoefficient()
	local coefficient = profileCommon.ServerConfig.getServerConfigDataTable(CONVERSION_COEFFICIENT)
	if coefficient == nil or next(coefficient) == nil or coefficient.VarValue == nil or coefficient.VarValue == "" then
		return 1
	end
	return tonumber(coefficient.VarValue);
end

--[[--
--是否可以使用微信登录
--]]
function isWechatLogin()
	if not Common.hasWechatAPP() then
		return false
	end
	if not GameChannelConfig.isAppStoreChannelID() then
		--不是AppStore版本，则不使用微信登录
		return false
	end
    local wechatLogin = profileCommon.ServerConfig.getServerConfigDataTable(ENABLE_WEIXIN_LOGIN)
	if wechatLogin ~= nil and wechatLogin.VarValue ~= nil and wechatLogin.VarValue ~= "" then
		if wechatLogin.VarValue == "1" then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

--[[--
--是否可以上传lua异常
--]]
function getEnableUploadLuaEx()
	local UploadLuaEx = profileCommon.ServerConfig.getServerConfigDataTable(ENABLE_UPLOAD_LUA_EX)
	if UploadLuaEx ~= nil and UploadLuaEx.VarValue ~= nil and UploadLuaEx.VarValue ~= "" then
		if UploadLuaEx.VarValue == "1" then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

--[[--
--appStore评价引导提示语
--]]
function getAppstoreCommentGuide()

	local mAppstoreCommentGuide = profileCommon.ServerConfig.getServerConfigDataTable(APPSTORE_COMMENT_GUIDE) --获取服务器返回的table

	if mAppstoreCommentGuide ~= nil and mAppstoreCommentGuide.VarValue ~= nil and mAppstoreCommentGuide.VarValue ~= "" then
		return mAppstoreCommentGuide.VarValue
	else
		return ""
	end
end

--[[--
--appStore评价引导地址
--]]
function getAppstoreGameUrl()

	local mAppstoreGameUrl = profileCommon.ServerConfig.getServerConfigDataTable(APPSTORE_GAME_URL) --获取服务器返回的table

	if mAppstoreGameUrl ~= nil and mAppstoreGameUrl.VarValue ~= nil and mAppstoreGameUrl.VarValue ~= "" then
		return mAppstoreGameUrl.VarValue
	end
end

--[[--
--获取是否在礼包充值引导上使用短信
--]]
function getGiftCanUseSms()
	local giftCanUseSms = profileCommon.ServerConfig.getServerConfigDataTable(LORD_GIFT_CAN_USE_SMS) --获取服务器返回的table
	if giftCanUseSms ~= nil and giftCanUseSms.VarValue ~= nil and giftCanUseSms.VarValue ~= "" then
		if giftCanUseSms.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[--
--获取是否显示礼包
--]]
function getGiftIsShow()
	local GiftIsShow = profileCommon.ServerConfig.getServerConfigDataTable(LORD_IS_SHOW_GIFT_FOR_LUA) --获取服务器返回的table
	if GiftIsShow ~= nil and GiftIsShow.VarValue ~= nil and GiftIsShow.VarValue ~= "" then
		if GiftIsShow.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[--
--获取是否显示充值引导
--]]
function getQuickPayIsShow()
	local QuickPayIsShow = profileCommon.ServerConfig.getServerConfigDataTable(LORD_IS_SHOW_QUICK_PAY_FOR_LUA) --获取服务器返回的table
	if QuickPayIsShow ~= nil and QuickPayIsShow.VarValue ~= nil and QuickPayIsShow.VarValue ~= "" then
		if QuickPayIsShow.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[--
--是否是appstore审核版本
--]]
function isAppstoreReview()
	if not GameChannelConfig.isAppStoreChannelID() then
		--不是AppStore版本，则不是评审版本
		return false
	end
	local isAppstoreReview = profileCommon.ServerConfig.getServerConfigDataTable(LORD_IS_APPSTORE_REVIEW) --获取服务器返回的table
	if isAppstoreReview ~= nil and isAppstoreReview.VarValue ~= nil and isAppstoreReview.VarValue ~= "" then
		if isAppstoreReview.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end

--[[--
--获取是否开启交叉推广
--]]
function getCrossPromotionIsShow()
	local CrossPromotionIsShow = profileCommon.ServerConfig.getServerConfigDataTable(ENABLE_CROSS_PROMOTION)
	if CrossPromotionIsShow ~= nil and CrossPromotionIsShow.VarValue ~= nil and CrossPromotionIsShow.VarValue ~= "" then
		if CrossPromotionIsShow.VarValue == "1" then
			return true
		else
			return false
		end
	else
		return false
	end
end
