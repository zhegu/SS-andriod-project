module("MahjongTableArmature", package.seeall)

--换牌动画
ARMATURE_CHANGECARD = "anim_mj_table_huanpai";--换牌动画集
ARMATURE_CHANGECARD_ACTION_ROTATE = "anim_mj_table_huanpai_rotate"
ARMATURE_CHANGECARD_ACTION_CHANGE = "anim_mj_table_huanpai_change"

--开始动画
ARMATURE_BEGIN = "anim_mj_table_kaishi";--开始动画集
ARMATURE_BEGIN_ACTION = "anim_mj_table_kaishi_01"
ARMATURE_BEGIN_ACTION_BLEND = "anim_mj_table_kaishi_add"

--骰子动画
ARMATURE_DICE = "anim_mj_table_shaizi";--骰子动画集
ARMATURE_DICE_ACTION = "anim_mj_table_dice"

--定缺万筒条动画
ARMATURE_DINGQUE = "anim_mj_table_wantongtiao";--定缺万筒条动画集
ARMATURE_DINGQUE_ACTION = "anim_mj_table_wantongtiao_add"

--用户状态动画
ARMATURE_PLAYERSTATE = "anim_mj_table_zhunbeizhong";--用户状态动画集
ARMATURE_PLAYERSTATE_ACTION_XUANPAI = "anim_mj_table_xuanpaizhong"
ARMATURE_PLAYERSTATE_ACTION_DINGQUE = "anim_mj_table_dingquezhong"

--方向动画
ARMATURE_DIRECTION = "anim_mj_table_chupai";--用户状态动画集

--获取动画Action
local directionAnimationStr = {
	{"dong", "xia"},
	{"nan", "you"},
	{"xi", "shang"},
	{"bei", "zuo"}
}

ARMATURE_CHATEMOTION = "MJ_TableEmotion" --聊天表情动画集

--胡牌动画
ARMATURE_HUPAI = "anim_mj_table_hupai_texiao";--胡牌动画集
ARMATURE_HUPAI_ACTION_BLEND = "anim_mj_table_hupai_texiao_add";

--打牌特效字提示
ARMATURE_CARD_ZI = "anim_mj_table_xiaoguozi"--打牌特效
ARMATURE_CARD_ZI_PENG = "anim_mj_table_xiaoguozi_peng_"--碰
ARMATURE_CARD_ZI_GANE = "anim_mj_table_xiaoguozi_gang_"--杠
ARMATURE_CARD_ZI_TING = "anim_mj_table_xiaoguozi_ting_"--听
ARMATURE_CARD_ZI_HU = "anim_mj_table_xiaoguozi_hu_"--胡
ARMATURE_CARD_ZI_ZIMO = "anim_mj_table_xiaoguozi_zimo_"--自摸
ARMATURE_CARD_ZI_QIANGGANGHU = "anim_mj_table_xiaoguozi_qiangganghu_"--抢杠胡
ARMATURE_CARD_ZI_CHI = "anim_mj_table_xiaoguozi_chi_"--吃
ARMATURE_CARD_ZI_YIPAODUOXIANG = "anim_mj_table_xiaoguozi_yipaoduoxiang_"--一炮多响
ARMATURE_CARD_ZI_YIPAOSHUANGXIANG = "anim_mj_table_xiaoguozi_yipaoshuangxiang_"--一炮双响
ARMATURE_CARD_ZI_GANGSHANGKAIHUA = "anim_mj_table_xiaoguozi_gangshangkaihua_"--杠上开花
ARMATURE_CARD_ZI_HAIDILAOYUE = "anim_mj_table_xiaoguozi_haidilaoyue_"--海底捞月
ARMATURE_CARD_ZI_HUJIAOZHUANYI = "anim_mj_table_xiaoguozi_hujiaozhuanyi_"--呼叫转移


local xuanpai_armatures = {}
local dingque_armatures = {}

local directionArmatures = nil; --方向动画
local dingQueArmatures = nil; --定缺动画
local HuPaiAnimList = {};--每个用户的胡牌动画(下标是牌桌的位置+1 ====== pos+1)
local changeCardLogoSprite = nil; --换牌Logo标志

MovementEventType = {
	START = 0,
	COMPLETE = 1,
	LOOP_COMPLETE = 2,
}

local function animationEvent(armatureBack, movementType, movementID)
	local id = movementID
	if movementType == MovementEventType.LOOP_COMPLETE then
	--循环动画结束一次
	elseif movementType == MovementEventType.COMPLETE then
		--动画结束一次
		if id == ARMATURE_BEGIN_ACTION then
			--游戏开始动画集
			--			showDiceAnim()
			MahjongTableConsole.callbackBeginAni()
		elseif id == ARMATURE_CHANGECARD_ACTION_ROTATE or id == ARMATURE_CHANGECARD_ACTION_CHANGE then
			removeChangeCardLogoSprite()
			MahjongTableConsole.callBackChangeCardAni()
		elseif id == ARMATURE_DICE_ACTION then
			--骰子动画
			MahjongTableElementLayer.showDice()
		elseif id == ARMATURE_HUPAI_ACTION_BLEND then
		--胡牌动画
		end
		armatureBack:stopAllActions();
		armatureBack:setVisible(false);
		MahjongTableElementLayer.getTableElementLayer():removeChild(armatureBack, true);
		armatureBack = nil;
	end
end

--[[--
--聊天表情动画
--]]
function showChatEmotionAnim(emotionIndex , posX, posY)

	-- 隐藏移除动画
	local function hideAnim(sender)
		MahjongTableElementLayer.getTableElementLayer():removeChild(sender, true)
	end

	--    然后创建armature类，并将进行初始化
	local armature = CCArmature:create(ARMATURE_CHATEMOTION)
	--    然后选择播放动画0，并进行缩放和位置设置
	armature:getAnimation():playByIndex(emotionIndex - 1)
	armature:setPosition(ccp(posX,posY));
	armature:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(3.0),CCCallFuncN:create(hideAnim)))
	armature:setZOrder(32)
	MahjongTableElementLayer.getTableElementLayer():addChild(armature)
end

--[[--
--换牌动画
--]]
function showChangeCardAnim(Type)
	--Type Byte 0顺时针，1逆时针，2对家
	local animType = ""
	if Type == 0 or Type == 1 then
		animType = ARMATURE_CHANGECARD_ACTION_ROTATE
	else
		animType = ARMATURE_CHANGECARD_ACTION_CHANGE;
	end

	local logoStr = ""
	if Type == 0 then
		logoStr = "MJ_table_changecard_bg_shunshizhen.png"
	elseif Type == 1 then
		logoStr = "MJ_table_changecard_bg_nishizhen.png"
	elseif Type == 2 then
		logoStr = "MJ_table_changecard_bg_duijia.png"
	end
	changeCardLogoSprite = CCSprite:createWithSpriteFrameName(logoStr);
	changeCardLogoSprite:setPosition(ccp(MahjongTableConfig.TableDefaultWidth/2, MahjongTableConfig.TableDefaultHeight/2))
	MahjongTableElementLayer.getTableElementLayer():addChild(changeCardLogoSprite)

	local mArmature = CCArmature:create(ARMATURE_CHANGECARD);
	mArmature:getAnimation():play(animType);
	mArmature:setPosition(MahjongTableConfig.TableDefaultWidth/2, MahjongTableConfig.TableDefaultHeight/2);
	MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
	mArmature:getAnimation():setMovementEventCallFunc(animationEvent);
	if Type == 1 then
		mArmature:setScaleX(-1)
	end

end

function removeChangeCardLogoSprite()
	if changeCardLogoSprite ~= nil then
		changeCardLogoSprite:removeFromParentAndCleanup(true);
		changeCardLogoSprite = nil
	end
end

--[[--
--开始动画
--]]
function showBeginAnim()
	local mArmature = CCArmature:create(ARMATURE_BEGIN);
	mArmature:getAnimation():play(ARMATURE_BEGIN_ACTION);
	mArmature:setPosition(MahjongTableConfig.TableDefaultWidth/2, MahjongTableConfig.TableDefaultHeight/2);
	MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
	mArmature:getAnimation():setMovementEventCallFunc(animationEvent);

	local __mb = ccBlendFunc()
	__mb.src = GL_ONE
	__mb.dst = GL_DST_ALPHA
	local mBlendArmature = CCArmature:create(ARMATURE_BEGIN);
	mBlendArmature:getAnimation():play(ARMATURE_BEGIN_ACTION_BLEND);
	mBlendArmature:setPosition(MahjongTableConfig.TableDefaultWidth/2, MahjongTableConfig.TableDefaultHeight/2);
	mBlendArmature:setBlendFunc(__mb);
	MahjongTableElementLayer.getTableElementLayer():addChild(mBlendArmature);
	mBlendArmature:getAnimation():setMovementEventCallFunc(animationEvent);

end

--[[--
--骰子动画
--]]
function showDiceAnim()

	local mArmature = CCArmature:create(ARMATURE_DICE);
	mArmature:getAnimation():play(ARMATURE_DICE_ACTION);
	mArmature:setPosition(MahjongTableConfig.TableDefaultWidth/2, MahjongTableConfig.TableDefaultHeight/2);
	MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
	mArmature:getAnimation():setMovementEventCallFunc(animationEvent);
end

--[[--
--定缺万筒条动画
--]]
function showDingQueAnim(type)
	dingQueArmatures = CCArmature:create(ARMATURE_DINGQUE);
	dingQueArmatures:getAnimation():play(ARMATURE_DINGQUE_ACTION);
	dingQueArmatures:setPosition(MahjongTableConfig.DingQueAniXY[type][1], MahjongTableConfig.DingQueAniXY[type][2]);
	MahjongTableElementLayer.getTableElementLayer():addChild(dingQueArmatures);
--	dingQueArmatures:getAnimation():setMovementEventCallFunc(animationEvent);
end

function removeDingQueAnim()
	if dingQueArmatures ~= nil then
		dingQueArmatures:stopAllActions();
		MahjongTableElementLayer.getTableElementLayer():removeChild(dingQueArmatures, true);
		dingQueArmatures = nil;
	end
end

--[[--
--用户选牌状态动画
--]]
function showPlayerXuanPaiAnim(pos)
	Common.log("showPlayerXuanPaiAnim pos == "..pos)
	Common.log("showPlayerXuanPaiAnim posX == "..MahjongTableConfig.playerGameStateXY[pos][1])
	Common.log("showPlayerXuanPaiAnim posY == "..MahjongTableConfig.playerGameStateXY[pos][2])
	removePlayerXuanPaiAnim(pos)
	local mArmature = CCArmature:create(ARMATURE_PLAYERSTATE);
	mArmature:getAnimation():play(ARMATURE_PLAYERSTATE_ACTION_XUANPAI);
	mArmature:setPosition(MahjongTableConfig.playerGameStateXY[pos][1], MahjongTableConfig.playerGameStateXY[pos][2]);
	MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
	mArmature:getAnimation():setMovementEventCallFunc(animationEvent);
	xuanpai_armatures[pos] = mArmature;
end

function removePlayerXuanPaiAnim(pos)
	local mArmature = xuanpai_armatures[pos];
	if mArmature ~= nil then
		mArmature:stopAllActions();
		MahjongTableElementLayer.getTableElementLayer():removeChild(mArmature, true);
		xuanpai_armatures[pos] = nil;
	end
end

--[[--
--用户定缺状态动画
--]]
function showPlayerDingQueAnim(pos)
	removePlayerDingQueAnim(pos)
	local mArmature = CCArmature:create(ARMATURE_PLAYERSTATE);
	mArmature:getAnimation():play(ARMATURE_PLAYERSTATE_ACTION_DINGQUE);
	mArmature:setPosition(MahjongTableConfig.playerGameStateXY[pos][1], MahjongTableConfig.playerGameStateXY[pos][2]);
	MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
	mArmature:getAnimation():setMovementEventCallFunc(animationEvent);
	dingque_armatures[pos] = mArmature;
end

function removePlayerDingQueAnim(pos)
	local mArmature = dingque_armatures[pos];
	if mArmature ~= nil then
		mArmature:stopAllActions();
		MahjongTableElementLayer.getTableElementLayer():removeChild(mArmature, true);
		dingque_armatures[pos] = nil;
	end
end


--[[--
--牌桌方向动画
--]]
function showTableDirectionAnim(pos, directionInd)
	removeTableDirectionAnim();
	local actionStr = "anim_mj_table_chupai_"..directionAnimationStr[directionInd][1].."_"..directionAnimationStr[pos][2].."_add";
	Common.log("showTableDirectionAnim actionStr == "..actionStr);
	directionArmatures = CCArmature:create(ARMATURE_DIRECTION);
	directionArmatures:getAnimation():play(actionStr);
	directionArmatures:setPosition(960, 627);
	MahjongTableLogic.view:addChild(directionArmatures);
end

function removeTableDirectionAnim()
	if directionArmatures ~= nil then
		directionArmatures:stopAllActions();
		MahjongTableLogic.view:removeChild(directionArmatures, true);
		directionArmatures = nil;
	end
end

--[[--
--显示胡牌动画
--]]
function showHuPaiAnim(PlayerPos, cardX, cardY)
	local __mb = ccBlendFunc()
	__mb.src = GL_ONE
	__mb.dst = GL_DST_ALPHA
	local mBlendArmature = CCArmature:create(ARMATURE_HUPAI);
	mBlendArmature:getAnimation():play(ARMATURE_HUPAI_ACTION_BLEND);
	mBlendArmature:setPosition(cardX, cardY);
	mBlendArmature:setBlendFunc(__mb);
	MahjongTableElementLayer.getTableElementLayer():addChild(mBlendArmature);
	mBlendArmature:getAnimation():setMovementEventCallFunc(animationEvent);
end

--[[--
--显示打牌字特效
--]]
function showCardZiAnim(PlayerPos, ActionName)
	local mArmature = CCArmature:create(ARMATURE_CARD_ZI);
	mArmature:getAnimation():play(ActionName .. "01");
	mArmature:setPosition(MahjongTableConfig.playerCardAnimXY[PlayerPos+1][1], MahjongTableConfig.playerCardAnimXY[PlayerPos+1][2]);
	MahjongTableElementLayer.getTableElementLayer():addChild(mArmature);
	mArmature:getAnimation():setMovementEventCallFunc(animationEvent);

	local __mb = ccBlendFunc()
	__mb.src = GL_ONE
	__mb.dst = GL_DST_ALPHA
	local mBlendArmature = CCArmature:create(ARMATURE_CARD_ZI);
	mBlendArmature:getAnimation():play(ActionName .. "add");
	mBlendArmature:setPosition(MahjongTableConfig.playerCardAnimXY[PlayerPos+1][1], MahjongTableConfig.playerCardAnimXY[PlayerPos+1][2]);
	mBlendArmature:setBlendFunc(__mb);
	MahjongTableElementLayer.getTableElementLayer():addChild(mBlendArmature);
	mBlendArmature:getAnimation():setMovementEventCallFunc(animationEvent);
end

--[[--
--重置牌桌动画数据
--]]
function releaseAllTableAnimation()
	removeTableDirectionAnim();
	xuanpai_armatures = {}
	dingque_armatures = {}
	HuPaiAnimList = {}
	directionArmatures = nil
	dingQueArmatures = nil
	changeCardLogoSprite = nil
end

local function loadArmatureData(PngPath, PlistPath, ExportJsonPath)
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(PngPath, PlistPath, ExportJsonPath)
end

local function getloadTableAnimPath(name)
	return MahjongTableConfig.getResPath("tableAnim/"..name)
end

--[[--
--加载牌桌动画文件
--]]
function loadTableAnim()
	--换牌动画
	loadArmatureData(getloadTableAnimPath("anim_mj_table_huanpai0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_huanpai0.plist"), getloadTableAnimPath("anim_mj_table_huanpai.ExportJson"))
	loadArmatureData(getloadTableAnimPath("anim_mj_table_huanpai0.pvr.ccz"), getloadTableAnimPath("lizi_mj_table_huanpai_jiantou.plist"), getloadTableAnimPath("anim_mj_table_huanpai.ExportJson"))
	loadArmatureData(getloadTableAnimPath("anim_mj_table_huanpai0.pvr.ccz"), getloadTableAnimPath("lizi_mj_table_huanpai_jiantou_zhi.plist"), getloadTableAnimPath("anim_mj_table_huanpai.ExportJson"))
	loadArmatureData(getloadTableAnimPath("anim_mj_table_huanpai0.pvr.ccz"), getloadTableAnimPath("lizi_mj_table_huanpai_jiantou_02.plist"), getloadTableAnimPath("anim_mj_table_huanpai.ExportJson"))
	--骰子动画
	loadArmatureData(getloadTableAnimPath("anim_mj_table_shaizi0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_shaizi0.plist"), getloadTableAnimPath("anim_mj_table_shaizi.ExportJson"))
	--开始动画
	loadArmatureData(getloadTableAnimPath("anim_mj_table_kaishi0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_kaishi0.plist"), getloadTableAnimPath("anim_mj_table_kaishi.ExportJson"))
	loadArmatureData(getloadTableAnimPath("anim_mj_table_kaishi0.pvr.ccz"), getloadTableAnimPath("lizi_mj_table_kaishi_bao.plist"), getloadTableAnimPath("anim_mj_table_kaishi.ExportJson"))
	--聊天表情
	loadArmatureData(getloadTableAnimPath("MJ_TableEmotion0.pvr.ccz"), getloadTableAnimPath("MJ_TableEmotion0.plist"), getloadTableAnimPath("MJ_TableEmotion.ExportJson"))
	--定缺万筒条
	loadArmatureData(getloadTableAnimPath("anim_mj_table_wantongtiao0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_wantongtiao0.plist"), getloadTableAnimPath("anim_mj_table_wantongtiao.ExportJson"))
	--定缺万筒条
	loadArmatureData(getloadTableAnimPath("anim_mj_table_zhunbeizhong0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_zhunbeizhong0.plist"), getloadTableAnimPath("anim_mj_table_zhunbeizhong.ExportJson"))
	--方向
	loadArmatureData(getloadTableAnimPath("anim_mj_table_chupai0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_chupai0.plist"), getloadTableAnimPath("anim_mj_table_chupai.ExportJson"))
	--胡牌动画
	loadArmatureData(getloadTableAnimPath("anim_mj_table_hupai_texiao0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_hupai_texiao0.plist"), getloadTableAnimPath("anim_mj_table_hupai_texiao.ExportJson"))
	--胡牌文字
	loadArmatureData(getloadTableAnimPath("anim_mj_table_xiaoguozi0.pvr.ccz"), getloadTableAnimPath("anim_mj_table_xiaoguozi0.plist"), getloadTableAnimPath("anim_mj_table_xiaoguozi.ExportJson"))

	MahjongInteractionAnim.loadInteractionAnim();
end

local function removeTableAnimTextureCache()
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_huanpai0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_shaizi0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_kaishi0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("MJ_TableEmotion0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_wantongtiao0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_zhunbeizhong0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_chupai0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_hupai_texiao0.pvr.ccz"))
	CCTextureCache:sharedTextureCache():removeTextureForKey(getloadTableAnimPath("anim_mj_table_xiaoguozi0.pvr.ccz"))
end

local function clearArmatureData(ExportJsonPath)
	CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(ExportJsonPath);
end
--[[--
--清理牌桌动画文件
--]]
function clearTableAnim()
	clearArmatureData(getloadTableAnimPath("anim_mj_table_huanpai.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_shaizi.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_kaishi.ExportJson"));
	clearArmatureData(getloadTableAnimPath("MJ_TableEmotion.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_wantongtiao.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_zhunbeizhong.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_chupai.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_hupai_texiao.ExportJson"));
	clearArmatureData(getloadTableAnimPath("anim_mj_table_xiaoguozi.ExportJson"));

	removeTableAnimTextureCache();

	MahjongInteractionAnim.clearInteractionAnim();
end