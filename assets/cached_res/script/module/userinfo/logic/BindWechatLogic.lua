module("BindWechatLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
Label_details = nil;--
btn_bindWechat = nil;--
btn_close = nil;--


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
--	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(Common.getResourcePath("personalinfo_outgame.plist"))
	local gui = GUI_BINDWECHAT;
	if GameConfig.RealProportion > GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 1136x640
		view = cocostudio.createView("BindWechat.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionExactFit);
	elseif GameConfig.RealProportion <= GameConfig.SCREEN_PROPORTION_SMALL then
		--适配方案 Pad加黑边
		view = cocostudio.createView("BindWechat.json");
		GameConfig.setCurrentScreenResolution(view, gui, 1136, 640, kResolutionShowAll);
	end
end

--[[--
--初始化控件
--]]
local function initView()
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Label_details = cocostudio.getUILabel(view, "Label_details");
	btn_bindWechat = cocostudio.getUIButton(view, "btn_bindWechat");
	btn_close = cocostudio.getUIButton(view, "btn_close");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();

	Label_details:setText(""..profileCommon.BindWechat.getAwardCoin());
end

function requestMsg()

end

function callback_btn_bindWechat(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		if Common.hasWechatAPP() then
			Common.getWeChatUserinfo(LoginConfig.WECHAT_BIND);
		else
			Common.showToast("请安装微信!", 2);
		end
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_btn_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		mvcEngine.destroyModule(GUI_BINDWECHAT);
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()
--	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(Common.getResourcePath("personalinfo_outgame.plist"))
end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
