--
--大厅消息预读管理类
--
module("MessagesPreReadManage", package.seeall)
--1,金花用户新进,斗地主进来应该能进行新手引导
--2,公告先消息回来,也应该先出月签

local isMonthSignMsgBackAndNorCom = false;--月签消息是否回来,且正常完成新手引导

--[[--
--发送预读消息(顺序：新手引导、月签、公告与活动)
--]]
function sendPreReadingMessages()
	if(GameConfig.isRegister == false)then
	--		if(CommDialogConfig.getNewUserGiudeFinish() == true)then
	--			--获取是否有新活动
	--			MeiRiDengLuTiShiLogic.setIsFirstSign(false)
	--		else
	--			--请求新手引导方案
	--			sendCOMMONS_GET_NEWUSERGUIDE_SCHEME();
	--		end
	--		--获取是否有新活动
	--		MeiRiDengLuTiShiLogic.setIsFirstSign(false)
	--		--获取是否有新活动
	--		sendMANAGERID_GET_HAVE_NEW_HUODONG(profile.MeiRiDengLu.getActityTimeStamp());
	--
	--		--获取是否有新公告
	--		sendMANAGERID_GET_HAVE_NEW_GONGGAO(profile.ShouYeGongGao.getLastNoticeTimeStamp());

	--获取活动网址
	--		sendMANAGERID_V3_GET_ACTIVITY_LIST(profile.MeiRiDengLu.getActityTimeStamp());
	--		--获取弹出公告消息
	--		sendBASEID_V2_GET_POP_NOTICE();
	--		--获取本期之星数据
	--		sendMATID_STAR_INFO();

	elseif(GameConfig.isRegister == true) then
--			CommShareConfig.setNewUserEnabled(true)
	--		--设置新手引导是否继续状态
	--		CommShareConfig.setContinueNewGuideEnabled(true)
	--		--请求新手引导，并请求奖励
	--		sendCOMMONS_GET_BASEINFO_NEWUSERGUIDE();
	--		sendCOMMONS_GET_NEWUSERGUIDE_SCHEME();

--			if not CommShareConfig.isOpenRedGiftShare() then
--				sendCOMMONS_GET_NEWUSERGUIDE_AWARD(1);
--			end
	--
	--		--宝盒V4新手预读奖励
	--		sendOPERID_PREREADING_BAOHEV4_NEW_PERSON_REWARD();
	end

	--查看记牌器信息
	--	sendDBID_BACKPACK_GOODS_COUNT(GameConfig.GOODS_JIPAIQI)

	--月签基本信息
--	sendMONTH_SIGN_REWARD_LIST(profileCommon.MonthSign.getMonthSignRewardListTimeStamp());
	--发送用户月签消息
--	sendUSERS_MONTH_SIGN_BASIC_INFO(profile.User.getSelfUserID());
--分享V2分享下载地址预读
--	sendOPERID_SHARINGV2_PRE_READING_DOWNLOAD_URL();
end

--[[--
--应答用户月签基本信息消息
--]]
function processUSERS_MONTH_SIGN_BASIC_INFO()
	isMonthSignMsgBackAndNorCom = true;
	--首页解锁动画正在进行中,则抛弃月签、公告弹出框
	if  HallLogic.isUnlockAnimationPlay then
		return;
	end
	--未完成新手引导,则抛弃月签、公告弹出框
	--	if CommDialogConfig.getNewUserGiudeFinish() == false then
	--		return;
	--	end
	--当前不是大厅,return
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL then
		return;
	end
	if not profileCommon.MonthSign.isSignToday() then
		--今天没签到, 弹出月签界面
        if ServerConfig.isAppstoreReview() == false then
--            mvcEngine.createModule(GUI_MONTHSIGN);
--            MonthSignLogic.setAutomaticPopUpValue(true);
        end
	else
		--今天已签, 创建每日登陆提示界面
		createDailyLoginPromptView();
	end
end

--[[--
--应答获取新活动消息
--]]
function processMANAGERID_GET_HAVE_NEW_HUODONG()
	--未完成新手引导,则抛弃月签、公告弹出框
	--	if CommDialogConfig.getNewUserGiudeFinish() == false then
	--		return;
	--	end
	--如果月签消息未回来,且今天未签到,return
	if not isMonthSignMsgBackAndNorCom or not profileCommon.MonthSign.isSignToday() then
		return;
	end
	--创建每日登陆提示界面
	createDailyLoginPromptView();
end

--[[--
--应答获取新公告消息
--]]
function processMANAGERID_GET_HAVE_NEW_GONGGAO()
	--未完成新手引导,则抛弃月签、公告弹出框
	--	if CommDialogConfig.getNewUserGiudeFinish() == false then
	--		return;
	--	end
	--如果月签消息未回来,且今天未签到,return
	if not isMonthSignMsgBackAndNorCom or not profileCommon.MonthSign.isSignToday() then
		return;
	end
	--创建每日登陆提示界面
	createDailyLoginPromptView();
end

--[[--
--创建每日登陆提示界面
--]]
function createDailyLoginPromptView()
	--首页解锁动画正在进行中,则抛弃月签、公告弹出框
	if  HallLogic.isUnlockAnimationPlay then
		return;
	end
	--未完成新手引导,则抛弃月签、公告弹出框
	--	if not CommDialogConfig.getNewUserGiudeFinish() then
	--		return;
	--	end
	--当前不是大厅,return
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL and HallModeConfig.getHallShowMode() ~= HallLogic.getHallModeValue() then
		return;
	end
	--如果每天提示框正在显示,return
--	if MeiRiDengLuTiShiLogic.getShowDailyValue() then
--		return;
--	end
--
--	if profile.MeiRiDengLu.hasNewActivity() or profile.MeiRiDengLu.hasNewAnnouncement() then
--		--如果有新活动或新公共,主动弹出每日提示框
--		mvcEngine.createModule(GUI_MEIRIDENGLUTISHI);
--		MeiRiDengLuTiShiLogic.setShowDailyValue(true);
--	end
end

--[[--
--显示预读消息的有关弹窗
--]]
function showPopupsAboutPreReadMessages()
	--刚注册的用户跳过新手引导,不弹出月签(意外中断的用户、没有本地数据的老用户,再进游戏,应该弹出月签)
	if GameConfig.isRegister == true then
		return;
	end
	--当前不是大厅,return
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL then
		return;
	end
	--月签消息未回来,且正常的完成新手引导(第三方注册不是),return
	if not isMonthSignMsgBackAndNorCom then
		return;
	end
    if ServerConfig.isAppstoreReview() == false then
        if not profileCommon.MonthSign.isSignToday() then
            --今天没签到
--            mvcEngine.createModule(GUI_MONTHSIGN);
        else
            --今天已签,则弹每天登陆提示
            createDailyLoginPromptView();
        end
    end
end

--[[--
--清除数据
--]]
function clearData()
	isMonthSignMsgBackAndNorCom = false;
end