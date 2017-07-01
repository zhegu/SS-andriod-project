--用lua进行面向对象的编程,声明方法和调用方法统一用冒号,对于属性的调用全部用点号

--声明，这里声明了类名还有属性，并且给出了属性的初始值。
MahjongTablePlayer = {
	mSeatID = -1,--座位号
	mUserID = 0,--用户ID
	mNickName = "",
	mPhotoUrl = "",
	mScore = 0,--积分数
	mSex = -1,-- 性别
	m_nPos = -1,-- 玩家位置，0，1，2...自己的位置永远是0,顺时针旋转

	mIsOffline = 0, --是否是离线状态	1是0不是
	mDingQueColor = -3, --用户定缺状态 -1没定缺 -2已定缺，不广播 0万，1筒，2条
	mIsSendChangeCard = -1, --用户上行换三张状态 0否 1是
	mIsReady = -1, --用户是否准备 0否 1是


	PlayerSprite = nil,--用户信息
}

MahjongTablePlayer.__index = MahjongTablePlayer

function MahjongTablePlayer:new(userId)
	local self = {}  --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
	setmetatable(self, MahjongTablePlayer)  --将self的元表设定为MahjongTablePlayer

	self.PlayerSprite = self:createPlayerSprite(userId)

	return self  --返回自身
end

--[[--
--设置用户头像
--]]
function MahjongTablePlayer:setPhoto(image)
	self.PlayerSprite.setPhoto(image)
end

--[[--
--设置用户提示信息（姓名，牌桌动作）
--]]
function MahjongTablePlayer:setPromptLabel(text, r, g, b, size)
	self.PlayerSprite.setPromptLabel(text, r, g, b, size)
end

--[[--
--获取当前提示信息
--]]
function MahjongTablePlayer:getPromptLabel()
	return self.PlayerSprite.getPromptLabel()
end

--[[--
--重置用户控件位置
--]]
function MahjongTablePlayer:updatePlayerPos(pos)
	self.PlayerSprite.updatePlayerPos(pos)
end

--[[--
--设置用户筹码信息
--]]
function MahjongTablePlayer:setScoreLable(chip)
	self.PlayerSprite.setScoreLable(chip)
end

--[[--
--设置离线状态
--]]
function MahjongTablePlayer:setIsOfflineState(state)
	self.PlayerSprite.setIsOfflineState(state)
end

--[[--
--设置游戏状态
--]]
function MahjongTablePlayer:setGameState(typeStr, seatID)
	self.PlayerSprite.setGameState(typeStr, seatID)
end

--[[--
--隐藏游戏状态
--]]
function MahjongTablePlayer:hideGameState()
	self.PlayerSprite.hideGameState()
end

--[[--
--更新用户筹码数
--]]
function MahjongTablePlayer:updateBetchip(chip, pos)
	self.PlayerSprite.updateBetchip(chip, pos)
end

--[[--
--隐藏用户筹码数
--]]
function MahjongTablePlayer:hideBetchip()
	self.PlayerSprite.hideBetchip()
end

--[[--
--设置牌型数据
--]]
function MahjongTablePlayer:setCardTypeLabel(type)
	self.PlayerSprite.setCardTypeLabel(type)
end

--[[--
--隐藏牌型数据
--]]
function MahjongTablePlayer:hideCardTypeLabel()
	self.PlayerSprite.hideCardTypeLabel()
end

--[[--
--显示dealer
--]]
function MahjongTablePlayer:showDealer(pos)
	self.PlayerSprite.showDealer(pos)
end

--[[--
--隐藏dealer
--]]
function MahjongTablePlayer:hideDealer()
	self.PlayerSprite.hideDealer()
end

--[[--
--设置头像是否可点击
--]]
function MahjongTablePlayer:setPhotoEnabled(isTouchEnabled)
	self.PlayerSprite.setPhotoEnabled(isTouchEnabled)
end

--[[--
--设置阴影
--]]
function MahjongTablePlayer:setPlayerShadow()
	self.PlayerSprite.setPlayerOpacity(127)
	self.PlayerSprite.setPlayerScale(0.8)
	--self.PlayerSprite.setPlayerShadow(150)
end

--[[--
--设置变亮
--]]
function MahjongTablePlayer:setPlayerBright()
	self.PlayerSprite.setPlayerOpacity(255)
	self.PlayerSprite.setPlayerScale(1)
	--self.PlayerSprite.setPlayerShadow(255)
end

--[[--
--抖动
--]]
function MahjongTablePlayer:showPlayerShake()
	self.PlayerSprite.showPlayerShake()
end

--[[--
--重置用户提示数据
--]]
function MahjongTablePlayer:resetPlayerPrompt()
	self.PlayerSprite.resetPlayerPrompt()
end

--[[--
--创建背景图
--]]
function MahjongTablePlayer:createPlayerSprite(userId)
	local function portraitCallback()
		if MahjongTableConsole.isTableRecordMode then
			return;
		end
		Common.log("MahjongTablePlayer userId == ".. self.mUserID)
		--		if self.mUserID == profile.User.getSelfUserID() then
		--			mvcEngine.createModule(GUI_TABLEPLAYERINFOSELF);
		--			TablePlayerInfoSelfLogic.setPlayerUserID(self.mUserID, MahjongTableConsole.mRoomID);
		--		else
		mvcEngine.createModule(GUI_MAHJONGTABLEUSERINFO);
		MahjongTableUserInfoLogic.setPlayerUserID(self.mUserID);
	--		end
	end

	local photoBgStr = "MJ_Table_button_headframe.png"
	if userId == profile.User.getSelfUserID() then
		photoBgStr = "MJ_Table_button_headframe_heng.png"
	end

--	local PlayerSprite = CCSprite:createWithSpriteFrameName(photoBgStr)
--	local Player_W = PlayerSprite:getContentSize().width
--	local Player_H = PlayerSprite:getContentSize().height
	local PlayerSprite = CCSprite:create(MahjongTableConfig.getResPath("table0.png"))
	local Player_W = 128
	local Player_H = 163

	--头像
	local photoSprite = CCSprite:create(MahjongTableConfig.getResPath("MJ_image_man.png"))
	photoSprite:setPosition(ccp(Player_W / 2, Player_H /2))
	PlayerSprite:addChild(photoSprite)

	local SpriteFrameCache = CCSpriteFrameCache:sharedSpriteFrameCache();
	local iv_photo_bg = CCMenuItemImage:create();
	iv_photo_bg:setNormalSpriteFrame(SpriteFrameCache:spriteFrameByName(photoBgStr));
	iv_photo_bg:setSelectedSpriteFrame(SpriteFrameCache:spriteFrameByName(photoBgStr));

	iv_photo_bg:setAnchorPoint(ccp(0.5, 0.5));
	iv_photo_bg:registerScriptTapHandler(portraitCallback);
	local menu = CCMenu:createWithItem(iv_photo_bg)
--	menu:setPosition(Player_W / 2, Player_H / 2)
	menu:setPosition(0, 0)
	PlayerSprite:addChild(menu);

	local promptLabel = CCLabelTTF:create("", "", 20)
	promptLabel:setColor(ccc3(197, 161, 104))
	promptLabel:setPosition(ccp(0, -24))
	PlayerSprite:addChild(promptLabel)

	--	local promptSprite = CCSprite:create(MahjongTableConfig.getResPath("label_allin.png"))
	--	promptSprite:setPosition(ccp(Player_W / 2, Player_H * 8 / 9))
	--	PlayerSprite:addChild(promptSprite)
	--	promptSprite:setVisible(false);

	--积分
	--	local scoreLable = MahjongTableTypeface.getTypefaceSprite(0, MahjongTableTypeface.TYPE_FACE_YELLOW);
	--	scoreLable:setScale(0.75)
	--	scoreLable:setPosition(ccp(Player_W / 2, Player_H * 0.15))
	--	PlayerSprite:addChild(scoreLable)
	local scoreLable = CCLabelAtlas:create("0", MahjongTableConfig.getResPath("MJ_pz_fangj_shuizi.png"), 44, 66, 48);
	scoreLable:setAnchorPoint(ccp(0.5, 0.5));
	scoreLable:setScale(0.4)
	scoreLable:setPosition(ccp(0, -66))
	PlayerSprite:addChild(scoreLable)


	--离线标志
	local offlineState = CCSprite:createWithSpriteFrameName("MJ_Table_button_headframe_cover_offline.png")
	offlineState:setPosition(ccp(Player_W , Player_H ))
	PlayerSprite:addChild(offlineState)
	offlineState:setVisible(false)

	--状态标志
	local gameState = CCSprite:createWithSpriteFrameName("MJ_table_fnt_yidingque.png")
	gameState:setPosition(ccp(Player_W , Player_H ))
	PlayerSprite:addChild(gameState)
	gameState:setVisible(false)

	--	local Countdown = CCProgressTimer:create(CCSprite:createWithSpriteFrameName("countdown_blue.png"));
	--	Countdown:setPosition(ccp(Player_W / 2, Player_H / 2));
	--	--设置进度条的样式
	--	Countdown:setType(kCCProgressTimerTypeRadial);
	--	--设置进度值范围[0,100]
	--	Countdown:setPercentage(100);
	--	Countdown:setReverseProgress(true);
	--	Countdown:setVisible(false);
	--	PlayerSprite:addChild(Countdown);

	--	--下注筹码
	--	local betChipBgSprite = CCSprite:createWithSpriteFrameName("pot_bg.png")
	--
	--	local chipIcon = CCSprite:createWithSpriteFrameName("chip.png");
	--	betChipBgSprite:addChild(chipIcon);
	--
	--	local betscoreLable = PokerTableTypeface.getTypefaceSprite(0, PokerTableTypeface.TYPE_FACE_WHITE);
	--	betscoreLable:setScale(0.75)
	--	betChipBgSprite:addChild(betscoreLable);
	--	betChipBgSprite:setVisible(false);
	--	PlayerSprite:addChild(betChipBgSprite);
	--
	--	--牌型
	--	local cardTypeLabel = CCLabelTTF:create("", "", 20)
	--	cardTypeLabel:setColor(ccc3(112, 221, 94))
	--	cardTypeLabel:setPosition(ccp(Player_W / 2 + 80, 20))
	--	PlayerSprite:addChild(cardTypeLabel)
	--
	--	--Dealer
	--	local DealerSprite = CCSprite:createWithSpriteFrameName("Dealer.png")
	--	PlayerSprite:addChild(DealerSprite)
	--	DealerSprite:setVisible(false);
	--
	--	--比赛名次 Sprite
	--	local rankSprite = CCSprite:createWithSpriteFrameName("bg_rank.png")
	--	rankSprite:setPosition(ccp(Player_W / 2, Player_H / 2))
	--	PlayerSprite:addChild(rankSprite)
	--	rankSprite:setVisible(false);
	--	--比赛名次 Label
	--	local rankNumLabel = CCLabelTTF:create("", "", 20)
	--	rankNumLabel:setColor(ccc3(183, 183, 183))
	--	rankNumLabel:setPosition(ccp(Player_W / 2, Player_H / 2))
	--	PlayerSprite:addChild(rankNumLabel)
	--	rankNumLabel:setVisible(false)

	--	function PlayerSprite.setRankVisible(flag)
	--		rankSprite:setVisible(flag)
	--		rankNumLabel:setVisible(flag)
	--	end
	--
	--	function PlayerSprite.updateRankNumLabel(rankNum)
	--		rankNumLabel:setString(""..rankNum)
	--	end

	function PlayerSprite.setPhotoEnabled(isTouchEnabled)
		if iv_photo_bg ~= nil then
			iv_photo_bg:setEnabled(isTouchEnabled)
		end
	end

	--	function PlayerSprite.updateBetchip(chip, pos)
	--		if tonumber(chip) > 0 then
	--			betChipBgSprite:removeChild(betscoreLable, true);
	--			betscoreLable = PokerTableTypeface.getTypefaceSprite(chip, PokerTableTypeface.TYPE_FACE_WHITE);
	--			betscoreLable:setScale(0.75)
	--			betChipBgSprite:addChild(betscoreLable);
	--			if pos >= 5 then
	--				--右侧的用户
	--				betscoreLable:setPosition(ccp(betChipBgSprite:getContentSize().width / 2 - chipIcon:getContentSize().width/4, betChipBgSprite:getContentSize().height/2))
	--				chipIcon:setPosition(ccp(betChipBgSprite:getContentSize().width - chipIcon:getContentSize().width/2, betChipBgSprite:getContentSize().height/2))
	--			else
	--				--左侧的用户
	--				betscoreLable:setPosition(ccp(betChipBgSprite:getContentSize().width / 2 + chipIcon:getContentSize().width/4, betChipBgSprite:getContentSize().height/2))
	--				chipIcon:setPosition(ccp(chipIcon:getContentSize().width/2, betChipBgSprite:getContentSize().height/2))
	--			end
	--			--betscoreLable:setString(PokerTableConfig.getChipFormat(chip))
	--			betChipBgSprite:setVisible(true);
	--			local BetChip_x = Player_W / 2 + PokerTableConfig.BetChipPos[pos + 1][1] - PokerTableConfig.PlayerPos[pos + 1][1]
	--			local BetChip_y = Player_H / 2 + PokerTableConfig.BetChipPos[pos + 1][2] - PokerTableConfig.PlayerPos[pos + 1][2]
	--			betChipBgSprite:setPosition(ccp(BetChip_x, BetChip_y));
	--		else
	--			betChipBgSprite:setVisible(false);
	--		end
	--	end
	--
	--	function PlayerSprite.hideBetchip()
	--		betChipBgSprite:setVisible(false);
	--	end

	function PlayerSprite.setPhoto(image)
		local texture = CCTextureCache:sharedTextureCache():addImage(image)
		photoSprite:setTexture(texture)
	end

	--	function PlayerSprite.resetPlayerPrompt()
	--		promptLabel:setVisible(true);
	--		promptSprite:setVisible(false);
	--		promptLabel:setFontSize(17)
	--		promptLabel:setColor(ccc3(255, 255, 255))
	--		local ContentLength = Common.utfstrlen(self.mNickName)
	--		if ContentLength > 6 then
	--			promptLabel:setString(Common.SubUTF8String(self.mNickName, 1, 5).."...")
	--		else
	--			promptLabel:setString(self.mNickName)
	--		end
	--	end

	function PlayerSprite.setPromptLabel(text, r, g, b, size)
		Common.log("setPromptLabel ======== "..text);
		promptLabel:setVisible(true)

		local txtLength = Common.getFontStringLen(text, 20);
		if txtLength > 5 then
			text = Common.SubUTF8String(text,1,5).."...";
		end
		promptLabel:setString(text)
	end

	function PlayerSprite.updatePlayerPos(pos)
		if pos == 1 or pos == 3 then
			scoreLable:setPosition(ccp(45, -21))
			promptLabel:setPosition(ccp(45, 21))
			iv_photo_bg:setNormalSpriteFrame(SpriteFrameCache:spriteFrameByName("MJ_Table_button_headframe_heng.png"));
			iv_photo_bg:setSelectedSpriteFrame(SpriteFrameCache:spriteFrameByName("MJ_Table_button_headframe_heng.png"));
--			PlayerSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("MJ_Table_button_headframe_heng.png"))
			Player_W = 216
			Player_H = 91
		end
--		local photoPosX = MahjongTableConfig.playerPhotoXY[pos][1] - MahjongTableConfig.playerPhotoBGXY[pos][1] + Player_W/2;
--		local photoPosY = MahjongTableConfig.playerPhotoXY[pos][2]  - MahjongTableConfig.playerPhotoBGXY[pos][2] + Player_H/2;
		local photoPosX = MahjongTableConfig.playerPhotoXY[pos][1] - MahjongTableConfig.playerPhotoBGXY[pos][1];
		local photoPosY = MahjongTableConfig.playerPhotoXY[pos][2]  - MahjongTableConfig.playerPhotoBGXY[pos][2];
		photoSprite:setPosition(photoPosX, photoPosY);
		offlineState:setPosition(photoPosX, photoPosY);
--		gameState:setPosition(MahjongTableConfig.playerGameStateXY[pos][1] - MahjongTableConfig.playerPhotoBGXY[pos][1] + Player_W/2, MahjongTableConfig.playerGameStateXY[pos][2]  - MahjongTableConfig.playerPhotoBGXY[pos][2] + Player_H/2);
		gameState:setPosition(MahjongTableConfig.playerGameStateXY[pos][1] - MahjongTableConfig.playerPhotoBGXY[pos][1], MahjongTableConfig.playerGameStateXY[pos][2]  - MahjongTableConfig.playerPhotoBGXY[pos][2]);
	end

	function PlayerSprite.setScoreLable(chip)
		--		if scoreLable ~= nil then
		--			PlayerSprite:removeChild(scoreLable, true);
		--			scoreLable = nil;
		--		end
		--		scoreLable = MahjongTableTypeface.getTypefaceSprite(chip, MahjongTableTypeface.TYPE_FACE_YELLOW);
		--		scoreLable:setScale(0.75)
		--		scoreLable:setPosition(ccp(Player_W / 2, Player_H / 9))
		--		PlayerSprite:addChild(scoreLable);
		local chipStr = tostring(chip)
		if chip < 0 then
			chipStr = ";"..math.abs(chip)
		end
		scoreLable:setString(chipStr)
	end

	function PlayerSprite.setIsOfflineState(state)
		--是否是离线状态	1是0不是
		if state == 1 then
			offlineState:setVisible(true)
		else
			offlineState:setVisible(false)
		end
	end

	function PlayerSprite.setGameState(typeStr, seatID)
		gameState:setVisible(true)
		gameState:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(typeStr))
	end

	function PlayerSprite.hideGameState()
		gameState:setVisible(false)
	end

	--	function PlayerSprite.setCardTypeLabel(type)
	--		if type ~= nil then
	--			cardTypeLabel:setVisible(true);
	--			cardTypeLabel:setString(type);
	--		end
	--	end
	--
	--	function PlayerSprite.hideCardTypeLabel()
	--		cardTypeLabel:setVisible(false);
	--	end
	--
	--	function PlayerSprite.setPlayerOpacity(Opacity)
	--		PlayerSprite:setOpacity(Opacity);
	--		iv_photo_bg:setOpacity(Opacity);
	--		photoSprite:setOpacity(Opacity);
	--		betChipBgSprite:setOpacity(Opacity);
	--		chipIcon:setOpacity(Opacity);
	--		promptLabel:setOpacity(Opacity);
	--		scoreLable:setOpacity(Opacity);
	--	end
	--
	--	function PlayerSprite.setPlayerShadow(parameters)
	--		PlayerSprite:setColor(ccc3(parameters, parameters, parameters))
	--		iv_photo_bg:setColor(ccc3(parameters, parameters, parameters))
	--		photoSprite:setColor(ccc3(parameters, parameters, parameters))
	--		betChipBgSprite:setColor(ccc3(parameters, parameters, parameters))
	--		chipIcon:setColor(ccc3(parameters, parameters, parameters))
	--		promptLabel:setColor(ccc3(parameters, parameters, parameters))
	--		scoreLable:setColor(ccc3(parameters, parameters, parameters))
	--	end

	function PlayerSprite.setPlayerScale(scale)
		local array = CCArray:create()
		array:addObject(CCScaleTo:create(0.2, scale))
		local seq = CCSequence:create(array)
		PlayerSprite:runAction(seq)
	end

	function PlayerSprite.showPlayerShake()
		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.1, ccp(0, -15)))
		array:addObject(CCMoveBy:create(0.1, ccp(0, 15)))
		array:addObject(CCMoveBy:create(0.1, ccp(0, -15)))
		array:addObject(CCMoveBy:create(0.1, ccp(0, 15)))
		local seq = CCSequence:create(array)
		photoSprite:runAction(seq)

		local array = CCArray:create()
		array:addObject(CCMoveBy:create(0.1, ccp(0, -15)))
		array:addObject(CCMoveBy:create(0.1, ccp(0, 15)))
		array:addObject(CCMoveBy:create(0.1, ccp(0, -15)))
		array:addObject(CCMoveBy:create(0.1, ccp(0, 15)))
		local seq = CCSequence:create(array)
		iv_photo_bg:runAction(seq)
	end

	PlayerSprite:setAnchorPoint(ccp(0.5, 0.5));

	return PlayerSprite
end
