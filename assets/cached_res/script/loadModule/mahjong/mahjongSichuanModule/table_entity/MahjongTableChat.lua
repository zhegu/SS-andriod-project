module("MahjongTableChat", package.seeall)

--移除聊天气泡
local function showTextEnd(sender)
	MahjongTableElementLayer.getTableElementLayer():removeChild(sender,true)
end

--添加历史记录
function addHistoryChat(nickName, msg)
	local data = {}
	data.nickName = nickName
	data.msg = msg
	table.insert(MahjongChatPopLogic.getChatLog(),data)
end

--显示聊天气泡
function showChatText(seatId, msg)
	local player = MahjongTableConsole.getPlayer(seatId)
	--此玩家不存在
	if not player then
		return
	end

	local posX = MahjongTableConfig.playerChatBubbleXY[player.m_nPos + 1][1]
	local posY = MahjongTableConfig.playerChatBubbleXY[player.m_nPos + 1][2]

	local MaxWordNum = 10;--每一行最大字的个数
	local fontSize = 36;--字号
	local ONE_ROW_HEIGHT = 60;

	local txtLength = Common.getFontStringLen(msg, 36);

	local rowSize = math.floor(txtLength / (MaxWordNum * fontSize));
	if txtLength % (MaxWordNum * fontSize) ~= 0 then
--		Common.log("showChatText  ============================ ")
		rowSize = rowSize + 1;
	end

--	Common.log("showChatText  txtLength == "..txtLength)
--	Common.log("showChatText  MaxWordNumLen == "..MaxWordNum * fontSize)
--	Common.log("showChatText  rowSize == "..rowSize)
--	Common.log("showChatText  %  == "..(txtLength % (MaxWordNum * fontSize) ))

	local mLabelWidth = txtLength
	local mLabelHeight = ONE_ROW_HEIGHT * rowSize;
	if rowSize == 1 then
		mLabelWidth = txtLength + fontSize * 1.5
		mLabelHeight = mLabelHeight + 5
	end

	local textBg = nil;
	local textPosX = 0;
	if player.m_nPos == 0 or player.m_nPos == 3 then
		textBg = GamePub.createPointNineSpriteByScaleWH(MahjongTableConfig.getResPath("MJ_btn_liaotianqipao_left.png"), 35, 35, 20, 20, mLabelWidth, mLabelHeight);
		textBg:setAnchorPoint(ccp(0, 1))
		textPosX = textBg:getContentSize().width/2 + 20
	else
		textBg = GamePub.createPointNineSpriteByScaleWH(MahjongTableConfig.getResPath("MJ_btn_liaotianqipao_right.png"), 20, 35, 35, 20, mLabelWidth, mLabelHeight);
		textBg:setAnchorPoint(ccp(1, 1))
		textPosX = textBg:getContentSize().width/2
	end

	textBg:setPosition(ccp(posX, posY))
	MahjongTableElementLayer.getTableElementLayer():addChild(textBg)

	local labelText = CCLabelTTF:create(msg, "Arial", fontSize, CCSizeMake(mLabelWidth * 0.9, textBg:getContentSize().height*0.9),kCCTextAlignmentLeft)
	labelText:setPosition(textPosX, textBg:getContentSize().height/2 - 1)
	textBg:addChild(labelText)
	labelText:setColor(ccc3(0,0,0))
	textBg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(4),CCCallFuncN:create(showTextEnd)))
end

-- 检测并播放聊天语音
function checkAndPlayerChatSound(seatId,playerChatMsg)
	local commonChatIndex = -1;
	local quickChatIndex = -1;

	local player = MahjongTableConsole.getPlayer(seatId)
	if player then
		--普通聊天
		if player.mSex == MahjongLoadProfile.MahjongUserInfo.MALE then
			for i=1,#MahjongChatPopLogic.gettableMaleChatCommonText() do
				if MahjongChatPopLogic.gettableMaleChatCommonText()[i] == playerChatMsg then
					commonChatIndex = i
				end
			end
		else
			for i=1,#MahjongChatPopLogic.gettableFeMaleChatCommonText() do
				if MahjongChatPopLogic.gettableFeMaleChatCommonText()[i] == playerChatMsg then
					commonChatIndex = i
				end
			end
		end
		if commonChatIndex > 0 then
			MahjongAudioManager.playPlayerChatSound(commonChatIndex, player.mSex)
			return
		end

		--快捷聊天
		for i=1, #MahjongTableConfig.QuickChat do
			if MahjongTableConfig.QuickChat[i][1] == playerChatMsg then
				quickChatIndex = i
			end
		end
		if quickChatIndex > 0 then
			MahjongAudioManager.playPlayerQuickChatSound(quickChatIndex, player.mSex)
			return
		end
	end
end

--播放普通表情声音
function checkAndPlayCommonSound(emotionIndex)
--	JinHuaTableSound.playPlayerEmotiontSound(emotionIndex)
end

--播放普通表情
function playChatCommonEmotion(seatId, emotionIndex)
	local player = MahjongTableConsole.getPlayer(seatId)
	if player then
		MahjongTableArmature.showChatEmotionAnim(emotionIndex , MahjongTableConfig.playerPhotoXY[player.m_nPos + 1][1], MahjongTableConfig.playerPhotoXY[player.m_nPos + 1][2])
	end
end
