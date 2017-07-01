module("JoinRoomLogic",package.seeall)

view = nil;

Panel_14 = nil;--
Panel_1 = nil;--
Panel_24 = nil;--
AtlasLabel_num1 = nil;--
AtlasLabel_num2 = nil;--
AtlasLabel_num3 = nil;--
AtlasLabel_num4 = nil;--
AtlasLabel_num5 = nil;--
AtlasLabel_num6 = nil;--
Panel_39 = nil;--
Button_num_reset = nil;--
Button_num_del = nil;--
Button_close = nil;--

AtlasLabelTable = {}

posTable = {}

NumIndex = 1

local function close()
	mvcEngine.destroyModule(GUI_JOINROOM)
end

function onKeypad(event)
	if event == "backClicked" then
	--返回键
		close()
	elseif event == "menuClicked" then
	--菜单键
	end
end

--[[--
--初始化当前界面
--]]
local function initLayer()
	local gui = GUI_JOINROOM;
	CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(MahjongTableConfig.getResPath("MJ_join.plist"));
	view = cocostudio.createScriptView(MahjongTableConfig.getJsonPath("JoinRoom.json"));
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
	Panel_14 = cocostudio.getUIPanel(view, "Panel_14");
	Panel_1 = cocostudio.getUIPanel(view, "Panel_1");
	Panel_24 = cocostudio.getUIPanel(view, "Panel_24");
	AtlasLabel_num1 = cocostudio.getUILabelAtlas(view, "AtlasLabel_num1");
	AtlasLabel_num2 = cocostudio.getUILabelAtlas(view, "AtlasLabel_num2");
	AtlasLabel_num3 = cocostudio.getUILabelAtlas(view, "AtlasLabel_num3");
	AtlasLabel_num4 = cocostudio.getUILabelAtlas(view, "AtlasLabel_num4");
	AtlasLabel_num5 = cocostudio.getUILabelAtlas(view, "AtlasLabel_num5");
	AtlasLabel_num6 = cocostudio.getUILabelAtlas(view, "AtlasLabel_num6");
	Panel_39 = cocostudio.getUIPanel(view, "Panel_39");
	Button_num_reset = cocostudio.getUIButton(view, "Button_num_reset");
	Button_num_del = cocostudio.getUIButton(view, "Button_num_del");
	Button_close = cocostudio.getUIButton(view, "Button_close");

	AtlasLabelTable = {}
	AtlasLabelTable[1] = AtlasLabel_num1
	AtlasLabelTable[2] = AtlasLabel_num2
	AtlasLabelTable[3] = AtlasLabel_num3
	AtlasLabelTable[4] = AtlasLabel_num4
	AtlasLabelTable[5] = AtlasLabel_num5
	AtlasLabelTable[6] = AtlasLabel_num6

	for i=1,#AtlasLabelTable do
		AtlasLabelTable[i]:setStringValue("")
	end


	posTable = {}
	posTable[1] = {}
	posTable[1].x = 962
	posTable[1].y = 839

	posTable[2] = {}
	posTable[2].x = 689
	posTable[2].y = 515
	posTable[3] = {}
	posTable[3].x = 962
	posTable[3].y = 515
	posTable[4] = {}
	posTable[4].x = 1235
	posTable[4].y = 515

	posTable[5] = {}
	posTable[5].x = 689
	posTable[5].y = 623
	posTable[6] = {}
	posTable[6].x = 962
	posTable[6].y = 623
	posTable[7] = {}
	posTable[7].x = 1235
	posTable[7].y = 623

	posTable[8] = {}
	posTable[8].x = 689
	posTable[8].y = 731
	posTable[9] = {}
	posTable[9].x = 962
	posTable[9].y = 731
	posTable[10] = {}
	posTable[10].x = 1235
	posTable[10].y = 731

end



function createView()
	--初始化当前界面
	initLayer();
	view:setTag(getDiffTag());
	GameStartConfig.addChildForScene(view);

	initView();

	NumIndex = 1


	initKeyboard()
end

function requestMsg()

end




function setNumByKeyBoard(keyIdx)
	Common.log("setNumByKeyBoard  keyIdx == "..keyIdx)
	if keyIdx == 10 then
		--重置
		for i=1,#AtlasLabelTable do
			AtlasLabelTable[i]:setStringValue("")
		end
		NumIndex = 1
	elseif keyIdx == 11 then
		--删除
		NumIndex = NumIndex - 1
		if NumIndex < 1 then
			NumIndex = 1
		end

		AtlasLabelTable[NumIndex]:setStringValue("")
	else
		if NumIndex > 6 then
			-- Common.showToast("输入错误",2)
			return
		end
		--输入
		AtlasLabelTable[NumIndex]:setStringValue(""..keyIdx)

		NumIndex = NumIndex + 1

		if NumIndex - 1 >= 6 then
			--自动发消息
			local passWord = ""
			for i=1,#AtlasLabelTable do
				passWord = passWord..AtlasLabelTable[i]:getStringValue()
			end
			passWord = tonumber(passWord)

			Common.log("passWord ==== == = = = = "..passWord)


			Common.showToast("正在进入房间...",2)

			local array = CCArray:create()
			array:addObject(CCDelayTime:create(0.2))
			array:addObject(CCCallFuncN:create(
				function()
					--延迟0.2秒  为了能看见最后一位数
--					sendMJ_SC_MGR_ENTER_ROOM(passWord)
					GameLoadModuleConfig.startMiniGameByID(MahjongConfig.MahjongSichuanGameID, MahjongConfig.MahjongSichuanPackage,"2#"..passWord);
				end
			))
			local seq = CCSequence:create(array)
			view:runAction(seq)

		end

	end
end

function initKeyboard()
	for i=1,10 do
		local nFileName = "MJ_btn_suzianniu_zhong_nor.png.png"
		if i == 2 then
			nFileName = "MJ_btn_suzianniu_zuo_nor.png"
		elseif i == 4 then
			nFileName = "MJ_btn_suzianniu_you_nor.png.png"
		end

		local pRibbon0_1 = CCSprite:createWithSpriteFrameName(nFileName);
		local pRibbon0_2 = CCSprite:createWithSpriteFrameName(nFileName);

		local diSpriteItem0 = CCMenuItemSprite:create(pRibbon0_1, pRibbon0_2, nil)
		local functionStr = "JoinRoomLogic_callback_Button_num"..(i-1)
		diSpriteItem0:registerScriptTapHandler(_G[functionStr])
		diSpriteItem0:setAnchorPoint(ccp(0.5, 0.5))


		local idxLabel = CCLabelAtlas:create(""..(i-1), MahjongTableConfig.getResPath("MJ_pz_fangj_shuizi.png"), 44, 66, 48);
		idxLabel:setAnchorPoint(ccp(0.5,0.5))
		idxLabel:setPosition(ccp(diSpriteItem0:getContentSize().width/2, diSpriteItem0:getContentSize().height /2))
		diSpriteItem0:addChild(idxLabel)

		local menuCell0 = CCMenu:create()
		local x = posTable[i].x
		local y = GameConfig.ScreenHeight - posTable[i].y
		menuCell0:setPosition(ccp(x, y))
		menuCell0:addChild(diSpriteItem0)
		view:addChild(menuCell0)
	end
end


function callback_Button_num_reset(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		setNumByKeyBoard(10)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_num_del(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		setNumByKeyBoard(11)
	elseif component == CANCEL_UP then
	--取消

	end
end

function callback_Button_close(component)
	if component == PUSH_DOWN then
	--按下

	elseif component == RELEASE_UP then
	--抬起
		close()
	elseif component == CANCEL_UP then
	--取消

	end
end


local function slot_MJ_SC_MGR_ENTER_ROOM()
	local joinRoomCallBackData = MahjongLoadProfile.MahjongCreateRoomInfo.getEnterRoomTable()
	local Result = joinRoomCallBackData["Result"]
	local Message = joinRoomCallBackData["Message"]

	if Result == 0 then
		setNumByKeyBoard(10)
	else
		close()
	end
	Common.showToast(Message,2)
end

--[[--
--释放界面的私有数据
--]]
function releaseData()
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(MahjongTableConfig.getResPath("MJ_join.plist"));

end

function addSlot()
	framework.addSlot2Signal(MJ_SC_MGR_ENTER_ROOM, slot_MJ_SC_MGR_ENTER_ROOM)
end

function removeSlot()
	framework.removeSlotFromSignal(MJ_SC_MGR_ENTER_ROOM, slot_MJ_SC_MGR_ENTER_ROOM)
end
