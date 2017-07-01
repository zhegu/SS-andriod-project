module("GameArmature", package.seeall)

--首页动画
ARMATURE_HALL_QUICKBEGIN = "DN_HALL_btn_begin_new";--快速开始动画集
ARMATURE_HALL_QUICKBEGIN_ACTION = "hall_quickplay_action"

ARMATURE_HALL_BOMB = "DN_HALL_game_bomb";--炸金牛动画集
ARMATURE_HALL_BOMB_ACTION = "bomb"

ARMATURE_HALL_BRNN = "DN_HALL_game_bulls";--百人牛牛动画集
ARMATURE_HALL_BRNN_ACTION = "brnn_action"

ARMATURE_HALL_LUCKYGAME = "DN_HALL_game_dice";--幸运游戏动画集
ARMATURE_HALL_LUCKYGAME_ACTION = "lucky_game_action";

ARMATURE_HALL_DOUNIU = "DN_HALL_game_goldbull";--看牌抢庄动画集
ARMATURE_HALL_DOUNIU_ACTION = "niuniu_action";

ARMATURE_HALL_YUANBAO = "DN_HALL_game_yuanbao";--大厅元宝动画集
ARMATURE_HALL_YUANBAO_ACTION = "hall_yuanbao_action";

ARMATURE_HALL_COIN = "DN_HALL_game_coins";--大厅金币动画集
ARMATURE_HALL_COIN_ACTION = "hall_coin_action";

ARMATURE_HALL_PK = "Animation_Hall_JingjichangrukouA";--大厅竞技场动画集
ARMATURE_HALL_PK_ACTION = "hall_pk_action";

ARMATURE_HALL_YAOQIANSHU = "DN_Hall_Yaoqianshu_Action_Enter_Animation";--大厅竞技场动画集
ARMATURE_HALL_YAOQIANSHU_ACTION = "Yaoqianshu_Enter_Action_Animation";

local hallBtnArmature = {};--大厅按钮骨骼动画

local mArmatureGameLoading = nil--游戏中loading动画loading
local quickBeginArmature = nil;--快速开始骨骼动画
local bombArmature = nil;--炸金牛骨骼动画
local luckyGameArmature = nil;--幸运游戏骨骼动画
local douniuGameArmature = nil;--看牌抢庄骨骼动画
local hallYuanBaoArmature = nil;--大厅元宝骨骼动画
local hallCoinArmature = nil;--大厅金币骨骼动画
local hallPkArmature = nil;--大厅竞技场骨骼动画
local brnnArmature = nil;--百人牛牛骨骼动画
local chaiHongBaoBtnArmature = nil;--拆红包动画
local hallYaoqianshuArmature = nil;--大厅摇钱树骨骼动画

MovementEventType = {
	START = 0,
	COMPLETE = 1,
	LOOP_COMPLETE = 2,
}

local function animationEvent(armatureBack, movementType, movementID)
	--	Common.log("movementType == "..movementType)
	--	Common.log("movementID == "..movementID)
	local id = movementID
	if movementType == MovementEventType.LOOP_COMPLETE then
	--循环动画结束一次
	elseif movementType == MovementEventType.COMPLETE then
	--动画结束一次
	end
end

---------大厅按钮骨骼动画----------------
--[[--
--按钮骨骼动画事件回调
--@param #CCArmature armature 骨骼动画
--@param #number movementType 是否循环
--@param #String movementID 播放动画的name
--]]
local function hallBtnAnimationEvent(armatureBack, movementType, movementID)
	--延时播放骨骼动画
	local function delayPlayBrmature()
		if HallLogic.view ~= nil and armatureBack ~= nil then
			--大厅模式才播放动画
			armatureBack:getAnimation():play(movementID);
		end
	end

	if movementType == MovementEventType.LOOP_COMPLETE then
	--循环动画结束一次
	elseif movementType == MovementEventType.COMPLETE then
		--动画结束一次

		armatureBack:stopAllActions();

		if HallLogic.view ~= nil then
			--大厅模式才执行回调
			local array = CCArray:create();
			local time = 16  --大厅动画10秒循环一次
			array:addObject(CCDelayTime:create(time));
			if movementID == ARMATURE_HALL_BOMB_ACTION then
				array:addObject(CCCallFuncN:create(playBombBtnArmature));
			elseif movementID == ARMATURE_HALL_BRNN_ACTION then
				array:addObject(CCCallFuncN:create(playBrnnBtnArmature));
			elseif movementID == ARMATURE_HALL_LUCKYGAME_ACTION then
				array:addObject(CCCallFuncN:create(playLuckyGameBtnArmature));
			elseif movementID == ARMATURE_HALL_DOUNIU_ACTION then
				array:addObject(CCCallFuncN:create(playDouNiuGameBtnArmature));
			end
			HallLogic.view:runAction(CCSequence:create(array))
		end

	elseif movementType == MovementEventType.START then
	end
end

--[[--
--隐藏按钮骨骼动画
--@param #CCArmature btnArmature 按钮骨骼动画
--]]
local function hideBtnArmature(btnArmature)
	if btnArmature ~= nil and btnArmature:isVisible() then
		btnArmature:stopAllActions();
		btnArmature:setVisible(false);
	end
end

--[[--
--显示按钮骨骼动画
--@param #CCArmature btnArmature 按钮骨骼动画
--]]
local function showBtnArmature(btnArmature)
	if btnArmature ~= nil and btnArmature:isVisible() == false then
		btnArmature:setVisible(true);
	end
end

--[[--
--在大厅按钮骨骼动画table中移除骨骼动画
--@param #CCArmature btnArmature 按钮骨骼动画
--]]
local function removeArmatureInHallBtnArmatureTable(btnArmature)
	for key, value in pairs(hallBtnArmature) do
		if value == btnArmature then
			table.remove(hallBtnArmature, key);
			break;
		end
	end
end

--[[--
--隐藏游戏中loading界面
--]]
function hideGameLoadingAnim(view)
	if mArmatureGameLoading ~= nil then
		mArmatureGameLoading:stopAllActions()
		mArmatureGameLoading:setVisible(false)
		view:removeChild(mArmatureGameLoading, true);
		mArmatureGameLoading = nil;
	end
end

--[[--
--显示游戏中loading界面
--]]
function showGameLoadingAnim(view, x, y)
	if mArmatureGameLoading == nil then
		mArmatureGameLoading = CCArmature:create("loading")
		mArmatureGameLoading:getAnimation():playByIndex(0)--play("loading")
		if x ~= nil and y ~= nil then
			mArmatureGameLoading:setPosition(x, y)
		else
			mArmatureGameLoading:setPosition(GameConfig.ScreenWidth / 2, GameConfig.ScreenHeight / 2)
		end
		mArmatureGameLoading:setVisible(true)
		view:addChild(mArmatureGameLoading)
	end
end


--[[--
--显示快速开始按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showQuickBeginBtnArmature(view,x,y)
	if quickBeginArmature == nil then
		--如果骨骼动画不存在,create
		quickBeginArmature = CCArmature:create(ARMATURE_HALL_QUICKBEGIN);
		table.insert(hallBtnArmature, quickBeginArmature);
		view:addChild(quickBeginArmature);
	else
		--如果骨骼动画存在,show
		quickBeginArmature:stopAllActions();
		showBtnArmature(quickBeginArmature);
	end
	--开启可能会转换位置
	quickBeginArmature:setPosition(ccp(x,y));
	quickBeginArmature:getAnimation():play(ARMATURE_HALL_QUICKBEGIN_ACTION);
	quickBeginArmature:setZOrder(10)
--	quickBeginArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

--[[--
--移除快速开始按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeQuickBeginBtnArmature(view)
	if quickBeginArmature ~= nil then
		quickBeginArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(quickBeginArmature);
		view:removeChild(quickBeginArmature, true);
		quickBeginArmature = nil;
	end
end

--[[--
--显示炸金牛按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showBombBtnArmature(view,x,y)
	if bombArmature == nil then
		--如果骨骼动画不存在,create
		bombArmature = CCArmature:create(ARMATURE_HALL_BOMB);
		table.insert(hallBtnArmature, bombArmature);
		view:addChild(bombArmature);
	else
		--如果骨骼动画存在,show
		bombArmature:stopAllActions();
		showBtnArmature(bombArmature);
	end
	--开启可能会转换位置
	bombArmature:setPosition(ccp(x,y));
	playBombBtnArmature();
	bombArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

function playBombBtnArmature()
	if HallLogic.view ~= nil and bombArmature ~= nil then
		bombArmature:getAnimation():play(ARMATURE_HALL_BOMB_ACTION);
	end
end

--[[--
--移除炸金牛按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeBombBtnArmature(view)
	if bombArmature ~= nil then
		bombArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(bombArmature);
		view:removeChild(bombArmature, true);
		bombArmature = nil;
	end
end

--[[--
--显示百人牛牛按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showBrnnBtnArmature(view,x,y)
	if brnnArmature == nil then
		--如果骨骼动画不存在,create
		brnnArmature = CCArmature:create(ARMATURE_HALL_BRNN);
		table.insert(hallBtnArmature, brnnArmature);
		view:addChild(brnnArmature);
	else
		--如果骨骼动画存在,show
		brnnArmature:stopAllActions();
		showBtnArmature(brnnArmature);
	end
	--开启可能会转换位置
	brnnArmature:setPosition(ccp(x,y));

	if HallLogic.view ~= nil then
		--大厅模式才执行回调
		local array = CCArray:create();
		local time = 6  --延迟6秒开始播放
		array:addObject(CCDelayTime:create(time));
		array:addObject(CCCallFuncN:create(playBrnnBtnArmature));
		HallLogic.view:runAction(CCSequence:create(array))
	end
	brnnArmature:setVisible(false);
--	playBrnnBtnArmature();
	brnnArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

function playBrnnBtnArmature()
	if HallLogic.view ~= nil and brnnArmature ~= nil then
		brnnArmature:setVisible(true)
		brnnArmature:getAnimation():play(ARMATURE_HALL_BRNN_ACTION);
	end
end

--[[--
--移除百人牛牛按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeBrnnBtnArmature(view)
	if brnnArmature ~= nil then
		brnnArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(brnnArmature);
		view:removeChild(brnnArmature, true);
		brnnArmature = nil;
	end
end

--[[--
--显示幸运游戏按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showLuckyGameBtnArmature(view,x,y)
	if luckyGameArmature == nil then
		--如果骨骼动画不存在,create
		luckyGameArmature = CCArmature:create(ARMATURE_HALL_LUCKYGAME);
		table.insert(hallBtnArmature, luckyGameArmature);
		view:addChild(luckyGameArmature);
	else
		--如果骨骼动画存在,show
		luckyGameArmature:stopAllActions();
		showBtnArmature(luckyGameArmature);
	end
	--开启可能会转换位置
	luckyGameArmature:setPosition(ccp(x,y));
	if HallLogic.view ~= nil then
		--大厅模式才执行回调
		local array = CCArray:create();
		local time = 12  --延迟12秒开始播放
		array:addObject(CCDelayTime:create(time));
		array:addObject(CCCallFuncN:create(playLuckyGameBtnArmature));
		HallLogic.view:runAction(CCSequence:create(array))
	end
--	playLuckyGameBtnArmature()
	luckyGameArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

function playLuckyGameBtnArmature()
	if HallLogic.view ~= nil and luckyGameArmature ~= nil then
		luckyGameArmature:getAnimation():play(ARMATURE_HALL_LUCKYGAME_ACTION)
	end
end

--[[--
--移除幸运游戏按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeLuckyGameBtnArmature(view)
	if luckyGameArmature ~= nil then
		luckyGameArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(luckyGameArmature);
		view:removeChild(luckyGameArmature, true);
		luckyGameArmature = nil;
	end
end

--[[--
--显示看牌抢庄按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showDouNiuGameBtnArmature(view,x,y)
	if douniuGameArmature == nil then
		--如果骨骼动画不存在,create
		douniuGameArmature = CCArmature:create(ARMATURE_HALL_DOUNIU);
		table.insert(hallBtnArmature, douniuGameArmature);
		view:addChild(douniuGameArmature);
	else
		--如果骨骼动画存在,show
		douniuGameArmature:stopAllActions();
		showBtnArmature(douniuGameArmature);
	end
	--开启可能会转换位置
	douniuGameArmature:setPosition(ccp(x,y));
	playDouNiuGameBtnArmature()
	douniuGameArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

function playDouNiuGameBtnArmature()
	if HallLogic.view ~= nil and douniuGameArmature ~= nil then
		douniuGameArmature:getAnimation():play(ARMATURE_HALL_DOUNIU_ACTION)
	end
end

--[[--
--移除看牌抢庄按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeDouNiuGameBtnArmature(view)
	if douniuGameArmature ~= nil then
		douniuGameArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(douniuGameArmature);
		view:removeChild(douniuGameArmature, true);
		douniuGameArmature = nil;
	end
end


--[[--
--显示大厅元宝按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showHallYuanbaoBtnArmature(view,x,y)
	if hallYuanBaoArmature == nil then
		--如果骨骼动画不存在,create
		hallYuanBaoArmature = CCArmature:create(ARMATURE_HALL_YUANBAO);
		table.insert(hallBtnArmature, hallYuanBaoArmature);
		view:addChild(hallYuanBaoArmature);
	else
		--如果骨骼动画存在,show
		hallYuanBaoArmature:stopAllActions();
		showBtnArmature(hallYuanBaoArmature);
	end
	--开启可能会转换位置
	hallYuanBaoArmature:setPosition(ccp(x,y));
	hallYuanBaoArmature:getAnimation():play(ARMATURE_HALL_YUANBAO_ACTION)
	--	hallYuanBaoArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

--[[--
--移除大厅元宝按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeHallYuanbaoBtnArmature(view)
	if hallYuanBaoArmature ~= nil then
		hallYuanBaoArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(hallYuanBaoArmature);
		view:removeChild(hallYuanBaoArmature, true);
		hallYuanBaoArmature = nil;
	end
end


--[[--
--显示大厅金币按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showHallCoinBtnArmature(view,x,y)
	if hallCoinArmature == nil then
		--如果骨骼动画不存在,create
		hallCoinArmature = CCArmature:create(ARMATURE_HALL_COIN);
		table.insert(hallBtnArmature, hallCoinArmature);
		view:addChild(hallCoinArmature);
	else
		--如果骨骼动画存在,show
		hallCoinArmature:stopAllActions();
		showBtnArmature(hallCoinArmature);
	end
	--开启可能会转换位置
	hallCoinArmature:setPosition(ccp(x,y));
	hallCoinArmature:getAnimation():play(ARMATURE_HALL_COIN_ACTION)
	--	hallCoinArmature:getAnimation():setMovementEventCallFunc(hallBtnAnimationEvent);
end

--[[--
--移除大厅金币按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeHallCoinBtnArmature(view)
	if hallCoinArmature ~= nil then
		hallCoinArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(hallCoinArmature);
		view:removeChild(hallCoinArmature, true);
		hallCoinArmature = nil;
	end
end

--[[--
--显示大厅竞技场按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showHallPkBtnArmature(view,x,y)
	if hallPkArmature == nil then
		--如果骨骼动画不存在,create
		hallPkArmature = CCArmature:create(ARMATURE_HALL_PK);
		table.insert(hallBtnArmature, hallPkArmature);
		view:addChild(hallPkArmature);
	else
		--如果骨骼动画存在,show
		hallPkArmature:stopAllActions();
		showBtnArmature(hallPkArmature);
	end
	--开启可能会转换位置
	hallPkArmature:setPosition(ccp(x,y));
	hallPkArmature:getAnimation():play(ARMATURE_HALL_PK_ACTION)
end

--[[--
--移除大厅竞技场按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeHallPkBtnArmature(view)
	if hallPkArmature ~= nil then
		hallPkArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(hallPkArmature);
		view:removeChild(hallPkArmature, true);
		hallPkArmature = nil;
	end
end

--[[--
--显示大厅竞技场按钮骨骼动画
--@param #UILayer view 动画所在view
--@param #number x X轴
--@param #number y Y轴
--]]
function showHallYaoqianshuBtnArmature(view,x,y)
	if hallYaoqianshuArmature == nil then
		--如果骨骼动画不存在,create
		hallYaoqianshuArmature = CCArmature:create(ARMATURE_HALL_YAOQIANSHU);
		table.insert(hallBtnArmature, hallYaoqianshuArmature);
		view:addChild(hallYaoqianshuArmature);
		hallYaoqianshuArmature:setScale(0.8)
	else
		--如果骨骼动画存在,show
		hallYaoqianshuArmature:stopAllActions();
		showBtnArmature(hallYaoqianshuArmature);
	end
	--开启可能会转换位置
	hallYaoqianshuArmature:setPosition(ccp(x,y));
	hallYaoqianshuArmature:getAnimation():play(ARMATURE_HALL_YAOQIANSHU_ACTION)
end

--[[--
--移除大厅竞技场按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeHallYaoqianshuBtnArmature(view)
	if hallYaoqianshuArmature ~= nil then
		hallYaoqianshuArmature:stopAllActions();
		removeArmatureInHallBtnArmatureTable(hallYaoqianshuArmature);
		view:removeChild(hallYaoqianshuArmature, true);
		hallYaoqianshuArmature = nil;
	end
end


--[[--
--隐藏大厅按钮骨骼动画
--]]
function hideHallBtnArmature()
	for i = 1, #hallBtnArmature do
		hideBtnArmature(hallBtnArmature[i]);
	end
end

--[[--
--移除大厅按钮按钮骨骼动画
--@param #UILayer view 动画所在view
--]]
function removeHallBtnArmature(view)
	--移除快速开始按钮骨骼动画
	removeQuickBeginBtnArmature(view)
	--移除炸金牛按钮骨骼动画
	removeBombBtnArmature(view)
	--移除百人牛牛按钮骨骼动画
	removeBrnnBtnArmature(view)
	--移除幸运游戏按钮骨骼动画
	removeLuckyGameBtnArmature(view)
	--移除看牌抢庄按钮骨骼动画
	removeDouNiuGameBtnArmature(view)
	--移除大厅元宝按钮骨骼动画
	removeHallYuanbaoBtnArmature(view)
	--移除大厅金币按钮骨骼动画
	removeHallCoinBtnArmature(view)
	--移除大厅竞技场按钮骨骼动画
	removeHallPkBtnArmature(view)
	--移除大厅摇钱树按钮骨骼动画
	removeHallYaoqianshuBtnArmature(view)
end


local function getGameCommonAnimPath(name)
	return Common.getResourcePath("gameCommon_anim/"..name)
end

local function getHallAnimPath(name)
	return Common.getResourcePath("mahjong_hallAnim/"..name)
end

local function loadArmatureData(PngPath, PlistPath, ExportJsonPath)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(PngPath, PlistPath, ExportJsonPath)
end

--[[--
--预加载大厅动画
--]]
function loadHallArmature()
	--loading动画
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(getGameCommonAnimPath("loading0.pvr.ccz"),getGameCommonAnimPath("loading0.plist"),getGameCommonAnimPath("loading.ExportJson"))

--	--快速开始按钮动画
--	loadArmatureData(getHallAnimPath("DN_HALL_btn_begin_new0.pvr.ccz"),getHallAnimPath("DN_HALL_btn_begin_new0.plist"),getHallAnimPath("DN_HALL_btn_begin_new.ExportJson"));
--	--炸金牛
--	loadArmatureData(getHallAnimPath("DN_HALL_game_bomb0.pvr.ccz"),getHallAnimPath("DN_HALL_game_bomb0.plist"),getHallAnimPath("DN_HALL_game_bomb.ExportJson"));
--	--百人牛牛
--	loadArmatureData(getHallAnimPath("DN_HALL_game_bulls0.pvr.ccz"),getHallAnimPath("DN_HALL_game_bulls0.plist"),getHallAnimPath("DN_HALL_game_bulls.ExportJson"));
--	--幸运游戏
--	loadArmatureData(getHallAnimPath("DN_HALL_game_dice0.pvr.ccz"),getHallAnimPath("DN_HALL_game_dice0.plist"),getHallAnimPath("DN_HALL_game_dice.ExportJson"));
--	--看牌抢庄
--	loadArmatureData(getHallAnimPath("DN_HALL_game_goldbull0.pvr.ccz"),getHallAnimPath("DN_HALL_game_goldbull0.plist"),getHallAnimPath("DN_HALL_game_goldbull.ExportJson"));
--	--大厅元宝
--	loadArmatureData(getHallAnimPath("DN_HALL_game_yuanbao0.pvr.ccz"),getHallAnimPath("DN_HALL_game_yuanbao0.plist"),getHallAnimPath("DN_HALL_game_yuanbao.ExportJson"));
--	--大厅金币
--	loadArmatureData(getHallAnimPath("DN_HALL_game_coins0.pvr.ccz"),getHallAnimPath("DN_HALL_game_coins0.plist"),getHallAnimPath("DN_HALL_game_coins.ExportJson"));
--	--大厅竞技场
--	loadArmatureData(getHallAnimPath("Animation_Hall_JingjichangrukouA0.pvr.ccz"),getHallAnimPath("Animation_Hall_JingjichangrukouA0.plist"),getHallAnimPath("Animation_Hall_JingjichangrukouA.ExportJson"));
--	--大厅摇钱树
--	loadArmatureData(getHallAnimPath("DN_Hall_Yaoqianshu_Action_Enter_Animation0.pvr.ccz"),getHallAnimPath("DN_Hall_Yaoqianshu_Action_Enter_Animation0.plist"),getHallAnimPath("DN_Hall_Yaoqianshu_Action_Enter_Animation.ExportJson"));

end
