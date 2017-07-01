module("MahjongInteractionAnim", package.seeall)

MovementEventType = {
	START = 0,
	COMPLETE = 1,
	LOOP_COMPLETE = 2,
}

--互动表情动画集
--普通
INTERACTION_Flower = "MJ_FlowerAnimation"--1鲜花
Action_Flower_Start = "FlowerStart"
Action_Flower_End = "FlowerEnd"

INTERACTION_Tomato = "MJ_TomatoAnimation"--2西红柿
Action_Tomato_Start = "TomatoStart"
Action_Tomato_End = "TomatoEnd"

--高级

INTERACTION_Bomb = "MJ_BombAnimation"--3炸弹
Action_Bomb_Start = "BombStart"
Action_Bomb_End = "BombEnd"

INTERACTION_Kiss = "MJ_KissAnimation"--4亲吻
Action_Kiss_Start = "KissStart"
Action_Kiss_End = "KissEnd"

--大便
INTERACTION_Shit = "MJ_ShitAnimation"--5大便
Action_Shit_Start = "ShitStart"
Action_Shit_End = "ShitEnd"

--机枪
INTERACTION_Gun = "MJ_GunAnimation"--6机枪
Action_Gun_Start = "GunStart"
Action_Gun_From_End = "GunFromEnd"
Action_Gun_To_End = "GunToEnd"


--[[--
--显示互动道具开始阶段
--@param #type number 动画类型
--@param #fromPos number 发起者位置
--@param #toPos number 目标者位置
--]]
function showInteractionAnimStart(type, fromX, fromY, toX, toY, isMoveToRight)
	--位移结束
	local function moveEndCallBack(sender)

		sender:setVisible(false);
		MahjongTableElementLayer.getTableElementLayer():removeChild(sender, true);
		sender = nil;
		showInteractionAnimEnd(type, fromX, fromY, toX, toY, isMoveToRight);
	end

	--位移动画
	local function moveAnimation(armature)
		local move = CCMoveTo:create(0.5, ccp(toX, toY))
		local arr = CCArray:create()
		arr:addObject(move)
		arr:addObject(CCCallFuncN:create(moveEndCallBack))
		armature:runAction(CCSequence:create(arr))
	end

	--动画结束回调
	local function startCallBack(armatureBack, movementType, movementID)
		local id = movementID
		if movementType == MovementEventType.LOOP_COMPLETE then
		--循环动画结束一次
		elseif movementType == MovementEventType.COMPLETE then
			--动画结束一次
			if id == Action_Tomato_Start or
				--西红柿
				id == Action_Flower_Start or
				--鲜花
				id == Action_Bomb_Start or
				--炸弹
				id == Action_Kiss_Start or
				--亲吻
				id == Action_Shit_Start then
				--大便
				armatureBack:stopAllActions();
				moveAnimation(armatureBack);
			elseif id == Action_Gun_Start then
				--机枪

				armatureBack:stopAllActions();
				armatureBack:setVisible(false);
				MahjongTableElementLayer.getTableElementLayer():removeChild(armatureBack, true);
				armatureBack = nil;

				showInteractionAnimEnd(type, fromX, fromY, toX, toY, isMoveToRight);

			--				armatureBack:stopAllActions();
			--				moveEndCallBack(armatureBack)
			end
		end
	end

	local mArmature = nil

	if type == MahjongLoadProfile.MahjongUserInfo.Tpye_Tomato then
		--西红柿
		mArmature = CCArmature:create(INTERACTION_Tomato);
		mArmature:getAnimation():play(Action_Tomato_Start);
	--		if isMoveToRight then
	--			mArmature:setScaleX(1)
	--		else
	--			mArmature:setScaleX(-1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Flower then
		--鲜花
		mArmature = CCArmature:create(INTERACTION_Flower);
		mArmature:getAnimation():play(Action_Flower_Start);
	--		if isMoveToRight then
	--			mArmature:setScaleX(1)
	--		else
	--			mArmature:setScaleX(-1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Bomb then
		--炸弹
		mArmature = CCArmature:create(INTERACTION_Bomb);
		mArmature:getAnimation():play(Action_Bomb_Start);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Kiss then
		--亲吻
		mArmature = CCArmature:create(INTERACTION_Kiss);
		mArmature:getAnimation():play(Action_Kiss_Start);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Shit then
		--大便
		mArmature = CCArmature:create(INTERACTION_Shit);
		mArmature:getAnimation():play(Action_Shit_Start);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Gun then
		--6机枪
		mArmature = CCArmature:create(INTERACTION_Gun);
		mArmature:getAnimation():play(Action_Gun_Start);
	--		if isMoveToRight then
	--			mArmature:setScaleX(1)
	--		else
	--			mArmature:setScaleX(-1)
	--		end
	end

	if mArmature ~= nil then
		mArmature:setPosition(fromX, fromY);
		mArmature:setZOrder(99)
		if isMoveToRight then
			mArmature:setScaleX(1 * MahjongTableConfig.animation_scale)
		else
			mArmature:setScaleX(-1 * MahjongTableConfig.animation_scale)
		end
		mArmature:setScaleY(1 * MahjongTableConfig.animation_scale)
		MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
		mArmature:getAnimation():setMovementEventCallFunc(startCallBack);
	end
end

--[[--
--显示互动道具结束阶段
--@param #type number 动画类型
--@param #fromPos number 发起者位置
--@param #toPos number 目标者位置
--]]
function showInteractionAnimEnd(type, fromX, fromY, toX, toY, isMoveToRight)
	--动画结束回调
	local function endCallBack(armatureBack, movementType, movementID)
		local id = movementID
		if movementType == MovementEventType.LOOP_COMPLETE then
		--循环动画结束一次
		elseif movementType == MovementEventType.COMPLETE then
			--动画结束一次
			if id == Action_Tomato_End or
				--西红柿
				id == Action_Flower_End or
				--鲜花
				id == Action_Bomb_End or
				--炸弹
				id == Action_Kiss_End or
				--亲吻
				id == Action_Shit_End or
				--大便
				id == Action_Gun_From_End or
				id == Action_Gun_To_End then
				--机枪
				armatureBack:stopAllActions();
				armatureBack:setVisible(false);
				MahjongTableElementLayer.getTableElementLayer():removeChild(armatureBack, true);
				armatureBack = nil;
			end
		end
	end

	--	local isMoveToRight = false;
	--
	--	if PokerTableConfig.PlayerPos[fromPos + 1][1] - PokerTableConfig.PlayerPos[toPos + 1][1] > 0 then
	--		--目标用户位于左侧
	--		isMoveToRight = false;
	--	else
	--		--目标用户位于右侧
	--		isMoveToRight = true;
	--	end

	local mArmature = nil
	local mArmatureFrom = nil
	if type == MahjongLoadProfile.MahjongUserInfo.Tpye_Tomato then
		--西红柿
		local function showTomatoSound()
			MahjongAudioManager.playMahjongSound("SOUND_TOMATO", -1);
		end
		loadGameConfig.delayDoFunc(showTomatoSound, 1)
		mArmature = CCArmature:create(INTERACTION_Tomato);
		mArmature:getAnimation():play(Action_Tomato_End);
	--		if isMoveToRight then
	--			mArmature:setScaleX(1)
	--		else
	--			mArmature:setScaleX(-1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Flower then
		--鲜花
		MahjongAudioManager.playMahjongSound("SOUND_FLOWER", -1);
		mArmature = CCArmature:create(INTERACTION_Flower);
		mArmature:getAnimation():play(Action_Flower_End);
	--		if isMoveToRight then
	--			mArmature:setScaleX(1)
	--		else
	--			mArmature:setScaleX(-1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Bomb then
		--炸弹
		local function showBombSound()
			MahjongAudioManager.playMahjongSound("SOUND_BOMB", -1);
		end
		loadGameConfig.delayDoFunc(showBombSound, 1)
		mArmature = CCArmature:create(INTERACTION_Bomb);
		mArmature:getAnimation():play(Action_Bomb_End);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Kiss then
		--亲吻
		MahjongAudioManager.playMahjongSound("SOUND_KISS", -1);
		mArmature = CCArmature:create(INTERACTION_Kiss);
		mArmature:getAnimation():play(Action_Kiss_End);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Shit then
		--大便
		MahjongAudioManager.playMahjongSound("SOUND_SHIT", -1);
		mArmature = CCArmature:create(INTERACTION_Shit);
		mArmature:getAnimation():play(Action_Shit_End);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	elseif type == MahjongLoadProfile.MahjongUserInfo.Tpye_Gun then
		--6机枪
		MahjongAudioManager.playMahjongSound("SOUND_GUN", -1);
		mArmatureFrom = CCArmature:create(INTERACTION_Gun);
		mArmatureFrom:getAnimation():play(Action_Gun_From_End);
		mArmature = CCArmature:create(INTERACTION_Gun);
		mArmature:getAnimation():play(Action_Gun_To_End);
	--		if isMoveToRight then
	--			mArmature:setScaleX(-1)
	--		else
	--			mArmature:setScaleX(1)
	--		end
	end

	if mArmature ~= nil then
		mArmature:setPosition(toX, toY);
		mArmature:setZOrder(99)
		if isMoveToRight then
			mArmature:setScaleX(1 * MahjongTableConfig.animation_scale)
		else
			mArmature:setScaleX(-1 * MahjongTableConfig.animation_scale)
		end
		mArmature:setScaleY(1 * MahjongTableConfig.animation_scale)
		MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
		mArmature:getAnimation():setMovementEventCallFunc(endCallBack);
	end
	if mArmatureFrom ~= nil then
		mArmatureFrom:setPosition(fromX, fromY);
		mArmatureFrom:setZOrder(99)
		if isMoveToRight then
			mArmatureFrom:setScaleX(1 * MahjongTableConfig.animation_scale)
		else
			mArmatureFrom:setScaleX(-1 * MahjongTableConfig.animation_scale)
		end
		MahjongTableElementLayer.getTableElementLayer():addChild(mArmatureFrom);
		mArmatureFrom:getAnimation():setMovementEventCallFunc(endCallBack);
	end
end

local function animationEvent(armatureBack, movementType, movementID)
	local id = movementID
	if movementType == MovementEventType.LOOP_COMPLETE then
	--循环动画结束一次
	elseif movementType == MovementEventType.COMPLETE then
		--动画结束一次
		armatureBack:stopAllActions();
		armatureBack:setVisible(false);
		MahjongTableElementLayer.getTableElementLayer():removeChild(armatureBack, true);
		armatureBack = nil;
	end
end

--[[--
--显示赠送礼物动画
--]]
function showSendGiftAmin(type,x,y)
	local armature = CCArmature:create("DN_sendgift")
	MahjongTableElementLayer.getTableElementLayer():addChild(armature)
	armature:setPosition(ccp(x,y))
	if type == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_FLOWER then
		armature:getAnimation():play("flower")
	elseif type == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_CAR then
		armature:getAnimation():play("car")
	elseif type == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_HOUSE then
		armature:getAnimation():play("house")
	elseif type == MahjongLoadProfile.MahjongUserInfo.GIFT_TYPE_YACHT then
		armature:getAnimation():play("yacht")
	end
	armature:getAnimation():setMovementEventCallFunc(animationEvent);
end

--[[--
--显示踢人动画
--]]
function showKickOutAmin(x,y)
	local armature = CCArmature:create("DN_kpqz_kick")
	MahjongTableElementLayer.getTableElementLayer():addChild(armature)
	armature:setPosition(ccp(x,y))
	armature:getAnimation():play("hoofkick")
	armature:getAnimation():setMovementEventCallFunc(animationEvent);
--	NiuNiuAudioManager.playNiuNiuSound(NiuNiuAudioManager.TableSound.kick_out, false, AudioManager.SOUND)
end


--[[--
--加载动画
--]]--
local function loadArmatureData(PngPath, PlistPath, ExportJsonPath)
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(PngPath, PlistPath, ExportJsonPath)
end

--[[--
--互动道具动画
--]]
local function getInteraction(name)
    return MahjongTableConfig.getResPath("interaction_anim/"..name)
end

--[[--
--加载牌桌动画文件
--]]
function loadInteractionAnim()
    --互动道具动画
    loadArmatureData(getInteraction("MJ_TomatoAnimation0.pvr.ccz"), getInteraction("MJ_TomatoAnimation0.plist"), getInteraction("MJ_TomatoAnimation.ExportJson"))
    loadArmatureData(getInteraction("MJ_FlowerAnimation0.pvr.ccz"), getInteraction("MJ_FlowerAnimation0.plist"), getInteraction("MJ_FlowerAnimation.ExportJson"))
    loadArmatureData(getInteraction("MJ_BombAnimation0.pvr.ccz"), getInteraction("MJ_BombAnimation0.plist"), getInteraction("MJ_BombAnimation.ExportJson"))
    loadArmatureData(getInteraction("MJ_BombAnimation1.pvr.ccz"), getInteraction("MJ_BombAnimation1.plist"), getInteraction("MJ_BombAnimation.ExportJson"))
    loadArmatureData(getInteraction("MJ_KissAnimation0.pvr.ccz"), getInteraction("MJ_KissAnimation0.plist"), getInteraction("MJ_KissAnimation.ExportJson"))
    loadArmatureData(getInteraction("MJ_ShitAnimation0.pvr.ccz"), getInteraction("MJ_ShitAnimation0.plist"), getInteraction("MJ_ShitAnimation.ExportJson"))
    loadArmatureData(getInteraction("MJ_GunAnimation0.pvr.ccz"), getInteraction("MJ_GunAnimation0.plist"), getInteraction("MJ_GunAnimation.ExportJson"))
end

local function removeInteractionAnimTextureCache()
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_TomatoAnimation0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_FlowerAnimation0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_BombAnimation0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_BombAnimation1.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_KissAnimation0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_ShitAnimation0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getInteraction("MJ_GunAnimation0.pvr.ccz"))
end

--[[--
--清理动画
--]]--
local function clearArmatureData(ExportJsonPath)
    CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(ExportJsonPath)
end

--[[--
--清理互动道具动画文件
--]]
function clearInteractionAnim()
    clearArmatureData(getInteraction("MJ_TomatoAnimation.ExportJson"));
    clearArmatureData(getInteraction("MJ_FlowerAnimation.ExportJson"));
    clearArmatureData(getInteraction("MJ_BombAnimation.ExportJson"));
    clearArmatureData(getInteraction("MJ_KissAnimation.ExportJson"));
    clearArmatureData(getInteraction("MJ_ShitAnimation.ExportJson"));
    clearArmatureData(getInteraction("MJ_GunAnimation.ExportJson"));

    removeInteractionAnimTextureCache();
end