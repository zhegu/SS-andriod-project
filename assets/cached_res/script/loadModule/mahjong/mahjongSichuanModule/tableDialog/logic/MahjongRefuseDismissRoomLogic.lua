module("MahjongRefuseDismissRoomLogic",package.seeall)

view = nil;

Panel_20 = nil;--
Panel_24 = nil;--
Panel_17 = nil;--
Label_content = nil;--
Button_done = nil;--

local function close()
	mvcEngine.destroyModule(GUI_MAHJONGREFUSEDISMISSROOM)
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
	local gui = GUI_MAHJONGREFUSEDISMISSROOM;
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("MahjongRefuseDismissRoom.json"));
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
	Label_content = cocostudio.getUILabel(view, "Label_content");
	Button_done = cocostudio.getUIButton(view, "Button_done");
end

function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);
	initView();
end

function requestMsg()

end

function setContent(str)
	Label_content:setText(str);
end

function callback_Button_done(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
		--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end



--[[--
--释放界面的私有数据
--]]
function releaseData()

end

function addSlot()
--framework.addSlot2Signal(signal, slot)
end

function removeSlot()
--framework.removeSlotFromSignal(signal, slot)
end
