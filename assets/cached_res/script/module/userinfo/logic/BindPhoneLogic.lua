module("BindPhoneLogic",package.seeall)

view = nil
local scene = nil
local flag = 0 --1绑定,2解绑,-1非手机绑定,-2非手机解绑
phonenumList = {}
local phone = 0
local operator = 0  ---运营商
sendmsg = nil

BindPhone = {}

Panel_14 = nil;--
Panel_16 = nil;--
btn_close = nil;--
Image_name = nil;--
lab_content1 = nil;--
btn_bind = nil;--
Image_bind = nil;--
Panel_bind = nil;--
AtlasLabel_rewards = nil;--

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
	view = cocostudio.createView("BindPhone.json")
	local gui = GUI_BINDPHONE
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

	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(view)

	Panel_16 = cocostudio.getUIPanel(view, "Panel_16");
	btn_close = cocostudio.getUIButton(view, "btn_close");
	Image_name = cocostudio.getUIImageView(view, "Image_name");
	lab_content1 = cocostudio.getUILabel(view, "lab_content1");
	btn_bind = cocostudio.getUIButton(view, "btn_bind");
	Image_bind = cocostudio.getUIImageView(view, "Image_bind");
	Panel_bind = cocostudio.getUIPanel(view, "Panel_bind");
	AtlasLabel_rewards = cocostudio.getUILabelAtlas(view, "AtlasLabel_rewards");

	initView()
	GamePub.showDialogAmin(Panel_16)
end

function initView()
	local ydnum = 0
	local ltnum = 0
	local dxnum = 0
	local num = #phonenumList
	if(num > 2 ) then
		ydnum = phonenumList[1].SmsNumber
		ltnum = phonenumList[2].SmsNumber
		dxnum = phonenumList[3].SmsNumber
	end
	if(flag == 1) then
		--绑定手机
--		lab_name:setText("绑定手机号")
		Image_name:loadTexture("DN_HALL_information_bg_bigbrown_mainfnt_bliding.png",1)
		Panel_bind:setVisible(true)

	elseif(flag == 2) then
		--解绑手机
--		lab_name:setText("解绑手机号")
		Image_name:loadTexture("DN_HALL_information_bg_bigbrown_mainfnt_spell.png",1)
		Panel_bind:setVisible(false)
		lab_content1:setText("解除绑定后，您将不再享受手机号找回密码功能。")
		btn_bind:loadTextures("DN_HALL_btn_spiralred.png","DN_HALL_btn_spiralred.png","",1)
		Image_bind:loadTexture("DN_HALL_information_btn_red_fnt_spell.png",1)
	end
	sendMANAGERID_GET_BINDING_PHONE_RANDOM()
end
function requestMsg()
	sendDOUNIU_MGR_BINDPHONE_REWARDS()
end

--绑定手机还是解绑手机  1绑定,2解绑,-1非手机绑定,-2非手机解绑
--手机号码list
--运营商
function setFlag(flagvalue,phonenumvalue,operatorvalue)
	flag = flagvalue
	phonenumList = phonenumvalue
	operator = operatorvalue
	local phonenumListlength = #phonenumList
	if(operator > 0 and phonenumListlength > 2) then
		phone = phonenumList[operator].SmsNumber
	end
end
--1 2 打开发短信界面
-- -1 -2 关闭界面
function callback_btn_bind(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		if sendmsg == nil or sendmsg == ""   then
			if flag == 1 then
				Common.showToast("请先获取验证码", 2)
				return
			end
		end
		if(flag == 1) then
			if(phone ~= "" and phone ~= nil and sendmsg ~= "" and sendmsg ~=nil ) then
				Common.log("绑定手机信息你发出"..phone..sendmsg)
				Common.sendSMSMessage(phone, sendmsg)
				Common.showToast("绑定手机信息已发出，请稍后", 2)
				close()
			end
		elseif(flag == 2) then
			if(phone ~= "" and phone ~= nil ) then
				Common.log("解绑定手机信息你发出"..phone)
				Common.sendSMSMessage(phone, "JB"..profile.User.getSelfUserID())
				Common.showToast("解除绑定手机信息已发出，请稍后", 2)
				close()
			end
		end

	elseif component == CANCEL_UP then
	--取消
	end
end
--关闭
function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下
	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消
	end
end
function close()
	GamePub.closeDialogAmin(Panel_16,closePanel)
end
function closePanel()
	mvcEngine.destroyModule(GUI_BINDPHONE)
end

function slot_BindMsg()
	sendmsg = profileCommon.BindPhone.getBindPhoneMsg()
	--lab_yzm:setText(sendmsg)
end

local function slot_DOUNIU_MGR_BINDPHONE_REWARDS()
	local rewards = profileCommon.BindPhone.getBindPhoneRewards()
	AtlasLabel_rewards:setStringValue(rewards)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
	--framework.addSlot2Signal(signal, slot)
	framework.addSlot2Signal(MANAGERID_GET_BINDING_PHONE_RANDOM, slot_BindMsg)
	framework.addSlot2Signal(DOUNIU_MGR_BINDPHONE_REWARDS, slot_DOUNIU_MGR_BINDPHONE_REWARDS)
end

function removeSlot()
	--framework.removeSlotFromSignal(signal, slot)
	framework.removeSlotFromSignal(MANAGERID_GET_BINDING_PHONE_RANDOM, slot_BindMsg)
	framework.removeSlotFromSignal(DOUNIU_MGR_BINDPHONE_REWARDS, slot_DOUNIU_MGR_BINDPHONE_REWARDS)

end
