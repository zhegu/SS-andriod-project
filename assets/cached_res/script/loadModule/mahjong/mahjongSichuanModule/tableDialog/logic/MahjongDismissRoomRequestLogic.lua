module("MahjongDismissRoomRequestLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_24 = nil;--
Panel_17 = nil;--
Label_content_title = nil;--
Label_content1 = nil;--
Label_content2 = nil;--
Label_content3 = nil;--
AtlasLabel_time = nil;--

local lableContents = {};

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGDISMISSROOMREQUEST)
end

function onKeypad(event)
	if event == "backClicked" then
		--返回键
--		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_MAHJONGDISMISSROOMREQUEST;
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongDismissRoomRequest.json"));
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		GameConfig.setCurrentScreenResolution(view, gui, 1920, 1080, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_20 = cocostudio.getUIPanel(view, "Panel_20");
	Panel_24 = cocostudio.getUIPanel(view, "Panel_24");
	Panel_17 = cocostudio.getUIPanel(view, "Panel_17");
	Label_content_title = cocostudio.getUILabel(view, "Label_content_title");
	Label_content1 = cocostudio.getUILabel(view, "Label_content1");
	Label_content2 = cocostudio.getUILabel(view, "Label_content2");
	Label_content3 = cocostudio.getUILabel(view, "Label_content3");
	AtlasLabel_time = cocostudio.getUILabelAtlas(view, "AtlasLabel_time");

	lableContents = {Label_content1, Label_content2, Label_content3}
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
	initData();
end

function requestMsg()

end

function initData()
	local dismissRoomData = MahjongLoadProfile.MahjongCreateRoomInfo.getDismissRoomReqTable()
	local DismissUserId = dismissRoomData["DismissUserId"]  --解散发起人
	local surplusTime = dismissRoomData["surplusTime"]  --剩余时间	秒
	local dismissInfo = dismissRoomData["dismissInfo"]  --文字提示
	local selfStatus = dismissRoomData["selfStatus"]  --状态	0=拒绝，1=同意，2=未选择
	local UserStatusList = dismissRoomData["UserStatusList"]  --玩家状态
	Label_content_title:setText(dismissInfo);
	AtlasLabel_time:setStringValue(surplusTime)
	showCountdown(surplusTime)

	for index=1, #lableContents do
		if UserStatusList ~= nil and UserStatusList[index] ~= nil then
			local userId = UserStatusList[index]["userId"]  --玩家
			local userName = UserStatusList[index]["userName"]  --玩家
			local status = UserStatusList[index]["status"]  --玩家状态	0=拒绝，1=同意，2=未选择
			local statusStr = "等待选择"
			if status == 1 then
				statusStr = "已同意"
			end
			local str = userName.."   "..statusStr;
			lableContents[index]:setText(str);
		end
	end

end

--开始倒计时
function showCountdown(timer)
	local nCountDownTime = 0;--倒计时15秒
	local DelayTime = 1;--每次刷新间隔时间
	local function CountdownTime()
		nCountDownTime = nCountDownTime + DelayTime;
		AtlasLabel_time:setStringValue(tostring(timer - math.floor(nCountDownTime)))
		if nCountDownTime>= timer then
			--超时结束
			closeCountdown()
		end
	end
	local delay = CCDelayTime:create(DelayTime)
	local array = CCArray:create()
	array:addObject(delay)
	array:addObject(CCCallFuncN:create(CountdownTime))
	local seq = CCSequence:create(array)
	view:runAction(CCRepeatForever:create(seq));
end

--关闭倒计时
function closeCountdown()
	AtlasLabel_time:setStringValue("0")
	view:stopAllActions();
end

function waitClose()
	Common.log("waitClose waitClose waitClose")
	closeCountdown();
	view:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3.0),CCCallFuncN:create(close)))
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	lableContents = {};
	view:stopAllActions();
end

function addSlot()
	framework.addSlot2Signal(MJ_SC_GAME_DISMISS_ROOM, initData)
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_GAME_DISMISS_ROOM, initData)
end
