module("SelfUserInfoLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_24 = nil;--
Panel_22 = nil;--
ImageView_head_box = nil;--
ImageView_head = nil;--
ImageView_sex = nil;--
Label_name = nil;--
Label_ip = nil;--
Label_id = nil;--
Button_close = nil;--
Panel_15 = nil;--


function onKeypad(event)
	if event == "backClicked" then
	--返回键
		closeDialogAmin(Panel_24, closePanel)
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_SELFUSERINFO;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("SelfUserInfo.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("SelfUserInfo.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_24 = cocostudio.getUIPanel(view, "Panel_24");
	Panel_22 = cocostudio.getUIPanel(view, "Panel_22");
	ImageView_head_box = cocostudio.getUIImageView(view, "ImageView_head_box");
	ImageView_head = cocostudio.getUIImageView(view, "ImageView_head");
	ImageView_sex = cocostudio.getUIImageView(view, "ImageView_sex");
	Label_name = cocostudio.getUILabel(view, "Label_name");
	Label_ip = cocostudio.getUILabel(view, "Label_ip");
	Label_id = cocostudio.getUILabel(view, "Label_id");
	Button_close = cocostudio.getUIButton(view, "Button_close");
	Panel_15 = cocostudio.getUIPanel(view, "Panel_15");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view)

	initView();


	--获取个人消息
	sendMJ_SC_MGR_PLAYER_INFO(profile.User.getSelfUserID())


	showDialogAmin(Panel_24)
end

function requestMsg()

end

--[[--
--显示对话框动画
--]]
function showDialogAmin(m_view, isCentre, callBack)
	if m_view == nil then
		return
	end

	m_view:setScale(0.2)
	if not(isCentre ~= nil and isCentre) then
		m_view:setAnchorPoint(ccp(0.5, 0.5))
		m_view:setPosition(ccp(m_view:getPosition().x + m_view:getSize().width / 2,m_view:getPosition().y + m_view:getSize().height / 2))
	end
	local action = CCScaleTo:create(0.3, 1);
	local array = CCArray:create()
	array:addObject(CCEaseBackOut:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	m_view:runAction(CCSequence:create(array))
end

--[[--
--隐藏对话框动画
--]]
function closeDialogAmin(m_view, callBack)
	-- local action1 = CCScaleTo:create(0.1, 1.2);
	local action = CCScaleTo:create(0.3, 0.2);
	local array = CCArray:create()
	-- array:addObject(CCEaseBackIn:create(action1))
	array:addObject(CCEaseBackIn:create(action))
	if(callBack)then
		array:addObject(CCCallFuncN:create(callBack))
	end
	if m_view ~= nil then
		m_view:runAction(CCSequence:create(array))
	end
end


function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		closeDialogAmin(Panel_24, closePanel)
	elseif component == CANCEL_UP then
	--取消

	end
end
function closePanel()
	mvcEngine.destroyModule(GUI_SELFUSERINFO)
end

--[[--
--更新个人头像
--]]
local function updataUserPhoto(path)
	local photoPath = nil
	local id = nil
	if Common.platform == Common.TargetIos then
		photoPath = path["useravatorInApp"]
		id = path["id"]
	elseif Common.platform == Common.TargetAndroid then
		--在目标字符串中搜索一个模式，如果找到，则返回匹配的起始索引和结束索引，否则返回nil。
		local i, j = string.find(path, "#")
		local id = string.sub(path, 1, i - 1)
		photoPath = string.sub(path, j + 1, -1)
	end
	if (photoPath ~= nil and photoPath ~= "" and ImageView_head ~= nil) then
		ImageView_head:loadTexture(photoPath)
	end
end

local function slot_MJ_SC_MGR_PLAYER_INFO()
	local UserInfoData = profile.User.getSelfUserInfo()

	-- nickName	Text	昵称
	local nickName = UserInfoData["NickName"]
	if nickName == nil or nickName == "" then
		return;
	end
	nickName = Common.SubUTF8String(nickName,1,10)
	-- photoUrl	Text	头像
	local photoUrl = UserInfoData["PhotoUrl"]
	-- userID	Int	用户ID
	local userID = UserInfoData["UserID"]
	-- sex	Byte	性别	1男 2女
	local sex = UserInfoData["Sex"]
	-- ip	Text	IP地址
	local ip = UserInfoData["ip"]


	if photoUrl ~= nil and photoUrl ~= "" then
		Common.getPicFile(photoUrl, 0, true, updataUserPhoto, true)
	end
	Label_name:setText(nickName)
	Label_ip:setText("IP:"..ip)
	Label_id:setText("ID:"..userID)
	if sex == 1 then
		ImageView_sex:loadTexture("MJ_outgame_infomation_ic_nan.png",1)
	else
		ImageView_sex:loadTexture("MJ_outgame_infomation_ic_nv.png",1)
	end
end


--[[--
--释放界面的私有数据
--]]
function releaseData()
end


function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_PLAYER_INFO, slot_MJ_SC_MGR_PLAYER_INFO)
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_PLAYER_INFO, slot_MJ_SC_MGR_PLAYER_INFO)
end
