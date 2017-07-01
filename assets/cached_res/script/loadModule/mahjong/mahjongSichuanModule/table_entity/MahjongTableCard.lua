MahjongTableCard = {
	-- 牌值
	m_nValue = 0,
	-- 花色
	m_nColor = 0,
	-- 牌面大小
	m_nWhat = 0,
	-- 牌在屏幕上的中心点坐标X
	m_nScreenX = 0,
	-- 牌在屏幕上的中心点坐标Y
	m_nScreenY = 0,
	-- 牌在屏幕上的中心点坐标Z,0第一层,1第二层(2D游戏,Z会影响Y坐标)
	m_nScreenZ = 0,
	-- 是否被选中
	m_bSelected = false,
	-- 是否触摸按下
	m_bTouchMarked = false,
	-- 标记，用于对牌的检索
	m_bMarked = false,
	-- 牌的精灵
	m_CardSprite = nil,
	-- 牌的方位: 0正面,1右面,2对面,3左面,4最高层级
	m_nDir = 0,
	-- 牌的显示类型: 0牌墙,1手牌,2放在桌上的手牌,3打出去的牌,4胡牌,5听牌
	m_nFaceState = 0,
	-- 牌摆放位置在第几行
	m_nRow = 1,
	-- 牌摆放位置在第几列
	m_nColumn = 1,
	-- 是否横向
	m_bLandscape = false;
	--牌的缩放
	m_CardScale = 1,
	--相同牌的数量
	m_nSameCardCnt = -1,
	--牌的类型 牌型1：顺子 牌型3：碰牌 型4：明杠 牌型5：暗杠 牌型6：手牌 牌型7：胡牌
	m_nCardType = -1,
	--牌的指向
	m_nFromSeatID = -1,
}

MahjongTableCard.__index = MahjongTableCard

--[[--
--创建一张新牌
--]]
function MahjongTableCard:newCard(nVal, nDir, nFace)
	local self = {};

	setmetatable(self, MahjongTableCard);

	-- 牌的方位: 0正面,1右面,2对面,3左面
	self.m_nDir = nDir;
	-- 牌的显示类型: 0牌墙,1手牌,2放在桌上的手牌(吃碰杠),3打出去的牌,4胡牌,5听牌
	self.m_nFaceState = nFace;

	self.m_CardSprite = self:createCardSprite();

	self:setCardValue(nVal);

	return self; --返回自身
end

function MahjongTableCard:setCardValue(nVal)
	self.m_nValue = nVal;
	self.m_nColor, self.m_nWhat = MahjongCardDoc.getCardInfoByValue(self.m_nValue);
--Common.log("self.m_nValue ======== "..self.m_nValue);
--Common.log("self.m_nColor ======== "..self.m_nColor);
--Common.log("self.m_nWhat ======== "..self.m_nWhat);
end

--[[--
--获得牌值
--]]
function MahjongTableCard:getValue()
	return self.m_nValue;
end

--[[--
--判断是否选中
--]]
function MahjongTableCard:click(x, y)
	if not self.m_CardSprite:isVisible() then
		--当前不显示
		return false
	end
	--    Common.log("x =========== "..x);
	--    Common.log("y =========== "..y);
	--
	--    Common.log("self.m_nScreenX =========== "..self.m_nScreenX);
	--    Common.log("self.m_nScreenY =========== "..self.m_nScreenY);

	if x > self.m_nScreenX - self:getContentSizeWidth() / 2 and x < self.m_nScreenX + self:getContentSizeWidth() / 2
		and y < self.m_nScreenY + self:getContentSizeHeight() / 2 and y > self.m_nScreenY - self:getContentSizeHeight() / 2 then
		return true
	else
		return false
	end
end

--[[--
-- 标记此牌
--]]
function MahjongTableCard:Mark()
	self.m_bMarked = true;
end

--[[--
-- 取消标记
--]]
function MahjongTableCard:Unmark()
	self.m_bMarked = false;
end

--[[--
-- 是否被标记
--]]
function MahjongTableCard:IsMarked()
	return self.m_bMarked;
end

--[[--
-- 是否被标记不可选中
--]]
function MahjongTableCard:IsTouchMarked()
	return self.m_bTouchMarked;
end

--[[--
--设置是否触摸到
--]]
function MahjongTableCard:setTouchMarked(isTouchMarked)
	self.m_bTouchMarked = isTouchMarked;
	if self.m_bTouchMarked then
		self.m_CardSprite.setFrontColor(125, 125, 125);
	else
		self.m_CardSprite.setFrontColor(255, 255, 255);
	end
end

function MahjongTableCard:showCardIdentify()
	self.m_CardSprite.setFrontColor(0x17,0xae,0xdf);
end

function MahjongTableCard:clearCardIdentify()
	self.m_CardSprite.setFrontColor(255, 255, 255);
end

function MahjongTableCard:setCardOpacity(opacity)
	self.m_CardSprite.setCardOpacity(opacity);
end

--[[--
--处理牌的选中逻辑
--]]
function MahjongTableCard:OnSelected()
	if self.m_bSelected then
		self:setSelected(false)
	else
		self:setSelected(true)
	end
end

--[[--
--设置选中状态
--]]
function MahjongTableCard:setSelected(isSelected)
	if self.m_bSelected == isSelected then
		return;
	end
	self.m_bSelected = isSelected
	if self.m_bSelected then
		self.m_CardSprite:setPosition(self.m_nScreenX, self.m_nScreenY + self:getContentSizeHeight() / 4);
	else
		self.m_CardSprite:setPosition(self.m_nScreenX, self.m_nScreenY);
	end
end

function MahjongTableCard:setCardScale(scale)
	self.m_CardScale = scale;
	self.m_CardSprite:setScale(self.m_CardScale);
end

function MahjongTableCard:setCardPosition(x, y)
	self.m_nScreenX = x;
	self.m_nScreenY = y;
	--Common.log("self.m_nCardX ========= "..self.m_nCardX);
	--Common.log("self.m_nCardY ========= "..self.m_nCardY);
	self.m_CardSprite:setPosition(self.m_nScreenX, self.m_nScreenY);

	local BaseNumber = MahjongTableConfig.TableDefaultWidth + MahjongTableConfig.TableDefaultHeight;

	if self.m_nDir == MahjongCardDoc.MJ_DIR_MAX or self.m_nDir == MahjongCardDoc.MJ_DIR_GAME_RESULT then
		--最高层级的牌(提示牌)
		self.m_CardSprite:setZOrder(BaseNumber*2 + (self.m_nScreenX + self.m_nScreenY))
	else
		--其他牌，从左往右层级依次递减
		if (self.m_nFaceState == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD or self.m_nFaceState == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD) and self.m_nColumn % 4 == 0 then
			--杠牌顶端的牌
			self.m_CardSprite:setZOrder(BaseNumber + (self.m_nScreenX + self.m_nScreenY));
		else
			if (self.m_nDir == MahjongCardDoc.MJ_DIR_FRONT or self.m_nDir == MahjongCardDoc.MJ_DIR_BACK) and
				(self.m_nFaceState == MahjongCardDoc.MJ_FACE_HAND_CARD or
				self.m_nFaceState == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD or
				self.m_nFaceState == MahjongCardDoc.MJ_FACE_TING_CARD or
				self.m_nFaceState == MahjongCardDoc.MJ_FACE_TING_BACK_CARD or
				self.m_nFaceState == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD) then
				--自己和对面的手牌屏幕左侧
				if self.m_nScreenX < MahjongTableConfig.TableDefaultWidth / 2 then
					self.m_CardSprite:setZOrder(BaseNumber + (self.m_nScreenX + self.m_nScreenY))
				else
					self.m_CardSprite:setZOrder(BaseNumber - (self.m_nScreenX + self.m_nScreenY))
				end
			elseif self.m_nDir == MahjongCardDoc.MJ_DIR_LEFT and self.m_nFaceState == MahjongCardDoc.MJ_FACE_OUT_CARD then
				--左侧用户打出的牌
				self.m_CardSprite:setZOrder(BaseNumber + self.m_nScreenX - self.m_nScreenY)
			else
				self.m_CardSprite:setZOrder(BaseNumber - (self.m_nScreenX + self.m_nScreenY))
			end
		end
	end
end

-- 牌摆放位置在第几行
-- 牌摆放位置在第几列
function MahjongTableCard:setCardRanks(row, column)
	self.m_nRow = row;
	self.m_nColumn = column;
	--Common.log("self.m_nRow ========= "..self.m_nRow);
	--Common.log("self.m_nColumn ========= "..self.m_nColumn);
	--self.m_CardSprite:setZOrder(WordPlateTableConfig.MaxRow * WordPlateTableConfig.MaxColumn - ((self.m_nColumn - 1) * WordPlateTableConfig.MaxRow + self.m_nRow));
	if self.m_CardSprite ~= nil then
		self.m_CardSprite.setValue(self.m_nColor, self.m_nWhat, self.m_nDir, self.m_nFaceState, self.m_nRow, self.m_nColumn);
	end

	if self.m_nDir ~= MahjongCardDoc.MJ_DIR_MAX and self.m_nDir ~= MahjongCardDoc.MJ_DIR_GAME_RESULT then
		local CardScale = MahjongCardDoc.getMJCardInfo(self.m_nDir, self.m_nFaceState, MahjongCardDoc.CardBackScale, self.m_nColumn);
		self:setCardScale(CardScale);
		local cardx = 0;
		local cardy = 0;
		if self.m_nFaceState == MahjongCardDoc.MJ_FACE_OUT_CARD then
			cardx = MahjongCardDoc.getMJCardInfo(self.m_nDir, self.m_nFaceState, MahjongCardDoc.CardBackX, (self.m_nRow - 1) * MahjongCardDoc.NormalMaxColumn + self.m_nColumn);
			cardy = MahjongCardDoc.getMJCardInfo(self.m_nDir, self.m_nFaceState, MahjongCardDoc.CardBackY, (self.m_nRow - 1) * MahjongCardDoc.NormalMaxColumn + self.m_nColumn);
		else
			cardx = MahjongCardDoc.getMJCardInfo(self.m_nDir, self.m_nFaceState, MahjongCardDoc.CardBackX, self.m_nColumn);
			cardy = MahjongCardDoc.getMJCardInfo(self.m_nDir, self.m_nFaceState, MahjongCardDoc.CardBackY, self.m_nColumn);
		end
		self:setCardPosition(cardx, cardy);
	end
	self:setTouchMarked(self.m_bTouchMarked);
end

function MahjongTableCard:getContentSizeWidth()
	return self.m_CardSprite.getCardWidth() * self.m_CardScale;
end

function MahjongTableCard:getContentSizeHeight()
	return self.m_CardSprite.getCardHeight() * self.m_CardScale;
end

--[[--
--设置牌阴影
--]]
function MahjongTableCard:setCardShadow()
	self.m_CardSprite.setFrontColor(125, 125, 125)
end

--[[--
--设置牌变亮
--]]
function MahjongTableCard:setCardBright()
	self.m_CardSprite.setFrontColor(255, 255, 255)
end

--[[--
--设置牌的听口标识
--]]
function MahjongTableCard:setTingHint(visible)
	if visible then
		self.m_CardSprite.showTingHint()
	else
		self.m_CardSprite.hideTingHint()
	end
end

--[[--
--@param #number Color 颜色
--@param #number What 数字
--@param #boolean  是否是癞子
--]]
function MahjongTableCard:createCardSprite()
	local CardSprite = nil;
	local front = nil
	local valueSprite = nil;
	local TingHintSprite = nil;

	CardSprite = CCSprite:createWithSpriteFrameName("img_cardback.png");

	--[[--
	--绘制麻将牌
	--@param #number Color 花色
	--@param #number What 数字
	--@param #number Dir 方位
	--@param #number Face 麻将牌类型
	--@param #number Row 行
	--@param #number Column 列
	--]]
	function CardSprite.setValue(Color, What, Dir, Face, Row, Column)

		CardSprite:removeAllChildrenWithCleanup(true);
		valueSprite = nil

		local CardFrontName = nil;--白板命名
		local isRotate = nil;--白板是否旋转
		local cardValueX = nil;
		local cardValueY = nil;
		local CardFaceScale = nil;

		if Dir == MahjongCardDoc.MJ_DIR_GAME_RESULT then
			--结算界面的展示牌
			if Face == MahjongCardDoc.MJ_FACE_HAND_CARD then
				--1手牌
				CardFrontName = "img_normal_card.png";
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD then
				--2放在桌上的手牌(吃碰杠)
				CardFrontName = "Frame_ziji_pingpaizheng_12.png";
			elseif Face == MahjongCardDoc.MJ_FACE_HU_CARD then
				--4胡牌
				CardFrontName = "Frame_ziji_pingpaizheng_12.png";
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD then
				--7放下的牌(暗杠)
				if Column % 4 == 0 then
					CardFrontName = "Frame_ziji_pingpaizheng_12.png";
				else
					CardFrontName = "Frame_ziji_pingpaibei_12.png";
				end
			end
			front = CCSprite:createWithSpriteFrameName(CardFrontName);
		else
			CardFrontName = MahjongCardDoc.getMJCardInfo(Dir, Face, MahjongCardDoc.CardBackName, Column) .. ".png";
			isRotate = MahjongCardDoc.getMJCardInfo(Dir, Face, MahjongCardDoc.isRotate, Column);
			cardValueX = MahjongCardDoc.getMJCardInfo(Dir, Face, MahjongCardDoc.CardFaceX, Column);
			cardValueY = MahjongCardDoc.getMJCardInfo(Dir, Face, MahjongCardDoc.CardFaceY, Column);
			CardFaceScale = MahjongCardDoc.getMJCardInfo(Dir, Face, MahjongCardDoc.CardFaceScale, Column);

			front = CCSprite:createWithSpriteFrameName(CardFrontName);
			front:setScaleX(isRotate);
		end

		--[[--
		--根据花色获取花色图片的下标
		--]]
		local function getImgColorIndex(nColor)
			if nColor == MahjongCardDoc.TYPE_CHARACTER then
				--万牌
				return "";
			elseif nColor == MahjongCardDoc.TYPE_WIND or nColor == MahjongCardDoc.TYPE_DRAGON then
				--风牌--箭牌
				return "3";
			elseif nColor == MahjongCardDoc.TYPE_FLOWER then
				--花牌
				return "4";
			else
				--饼牌--条牌
				return ""..nColor;
			end
		end

		local function setSelfCardColor()
			--显示正面
			valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_cardvalue%s%d.png", getImgColorIndex(Color), What + 1));

			if Face == MahjongCardDoc.MJ_FACE_WALL_CARD then
				--0牌墙
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_HAND_CARD then
				--1手牌
				TingHintSprite = CCSprite:createWithSpriteFrameName("MJ_use_Table_btn_bz_jt_xia.png");
				TingHintSprite:setPosition(0, front:getContentSize().height / 2);
				TingHintSprite:setVisible(false);
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD then
				--2放在桌上的手牌(吃碰杠)
				local SkewX = 12 - Column;
				if SkewX < 0 then
					SkewX = 0
				end
				valueSprite:setSkewX(SkewX);
			elseif Face == MahjongCardDoc.MJ_FACE_OUT_CARD then
				--3打出去的牌
				valueSprite:setSkewX(-(Column - 4));
			elseif Face == MahjongCardDoc.MJ_FACE_HU_CARD then
				--4胡牌
				valueSprite:setSkewX(-8 - Column);
			elseif Face == MahjongCardDoc.MJ_FACE_TING_CARD then
				--5听牌背(亮牌面)
				valueSprite:setSkewX(12 - Column);
			elseif Face == MahjongCardDoc.MJ_FACE_TING_BACK_CARD then
			--6亮牌时的手牌(听牌背)
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD then
				--7放下的牌(暗杠)
				if Column % 4 == 0 then
					local SkewX = 12 - Column;
					if SkewX < 0 then
						SkewX = 0
					end
					valueSprite:setSkewX(SkewX);
				else
					valueSprite = nil;
				end
			end
			if valueSprite ~= nil then
				valueSprite:setScale(CardFaceScale);
				valueSprite:setPosition(cardValueX, cardValueY);
			end
		end

		local function setRightCardColor()
			--显示右面
			if Face == MahjongCardDoc.MJ_FACE_WALL_CARD then
				--0牌墙
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_HAND_CARD then
				--1手牌
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD then
				--2放在桌上的手牌(吃碰杠)
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_youjia_y_%s%d.png", getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_OUT_CARD then
				--3打出去的牌
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_youjia_%d_%s%d.png", Row, getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_HU_CARD then
				--4胡牌
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_youjia_y_%s%d.png", getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_TING_CARD then
				--5听牌背(亮牌面)
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_youjia_y_%s%d.png", getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_TING_BACK_CARD then
			--6亮牌时的手牌(听牌背)
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD then
				--7放下的牌(暗杠)
				if Column%4 == 0 then
					valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_youjia_y_%s%d.png", getImgColorIndex(Color), What + 1));
				else
					valueSprite = nil;
				end
			end
			if valueSprite ~= nil then
				valueSprite:setScale(CardFaceScale);
				valueSprite:setPosition(cardValueX, cardValueY);
			end
		end

		local function setUpCardColor()
			--显示背面
			if Face == MahjongCardDoc.MJ_FACE_WALL_CARD then
				--0牌墙
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_HAND_CARD then
				--1手牌
				valueSprite = nil
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD then
				--2放在桌上的手牌(吃碰杠)
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_shangjia_pingpai_zheng_%s%d.png", getImgColorIndex(Color), What + 1));
				valueSprite:setSkewX(Column - 4);
			elseif Face == MahjongCardDoc.MJ_FACE_OUT_CARD then
				--3打出去的牌
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_cardvalue%s%d.png", getImgColorIndex(Color), What + 1));
				valueSprite:setScale(-1 * CardFaceScale);
				valueSprite:setSkewX(Column - 4);
			elseif Face == MahjongCardDoc.MJ_FACE_HU_CARD then
				--4胡牌
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_shangjia_pingpai_zheng_%s%d.png", getImgColorIndex(Color), What + 1));
				valueSprite:setSkewX(5 + Column);
			elseif Face == MahjongCardDoc.MJ_FACE_TING_CARD then
				--5听牌背(亮牌面)
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_shangjia_pingpai_zheng_%s%d.png", getImgColorIndex(Color), What + 1));
				valueSprite:setSkewX(Column - 4);
			elseif Face == MahjongCardDoc.MJ_FACE_TING_BACK_CARD then
			--6亮牌时的手牌(听牌背)
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD then
				--7放下的牌(暗杠)
				if Column % 4 == 0 then
					local tempC = math.ceil(Column/4) * 3 + 2
					local SkewX = tempC - 4;
					valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_shangjia_pingpai_zheng_%s%d.png", getImgColorIndex(Color), What + 1));
					valueSprite:setSkewX(SkewX);
				else
					valueSprite = nil;
				end
			end

			if valueSprite ~= nil then
				valueSprite:setPosition(cardValueX, cardValueY);
			end
		end

		local function setLeftCardColor()
			--显示左面
			if Face == MahjongCardDoc.MJ_FACE_WALL_CARD then
				--0牌墙
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_HAND_CARD then
				--1手牌
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD then
				--2放在桌上的手牌(吃碰杠)
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_zuojia_z_%s%d.png", getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_OUT_CARD then
				--3打出去的牌
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_zuojia_%d_%s%d.png", Row, getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_HU_CARD then
				--4胡牌
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_zuojia_z_%s%d.png", getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_TING_CARD then
				--5听牌背(亮牌面)
				valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_zuojia_z_%s%d.png", getImgColorIndex(Color), What + 1));
			elseif Face == MahjongCardDoc.MJ_FACE_TING_BACK_CARD then
			--6亮牌时的手牌(听牌背)
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD then
				--7放下的牌(暗杠)
				if Column % 4 == 0 then
					valueSprite = CCSprite:createWithSpriteFrameName(string.format("ing_zuojia_z_%s%d.png", getImgColorIndex(Color), What + 1));
				else
					valueSprite = nil;
				end
			end
			if valueSprite ~= nil then
				valueSprite:setScale(CardFaceScale);
				valueSprite:setPosition(cardValueX, cardValueY);
			end
		end

		local function setGameResultCardColor()
			--显示正面
			valueSprite = CCSprite:createWithSpriteFrameName(string.format("img_cardvalue%s%d.png", getImgColorIndex(Color), What + 1));

			if Face == MahjongCardDoc.MJ_FACE_WALL_CARD then
				--0牌墙
				valueSprite = nil;
			elseif Face == MahjongCardDoc.MJ_FACE_HAND_CARD then
				--1手牌
				valueSprite:setScale(1);
				valueSprite:setPosition(0, 0);
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_CARD then
				--2放在桌上的手牌(吃碰杠)
				valueSprite:setScale(0.5);
				valueSprite:setPosition(0, 16);
			elseif Face == MahjongCardDoc.MJ_FACE_OUT_CARD then
			--3打出去的牌
			elseif Face == MahjongCardDoc.MJ_FACE_HU_CARD then
				--4胡牌
				valueSprite:setScale(0.5);
				valueSprite:setPosition(0, 16);
			elseif Face == MahjongCardDoc.MJ_FACE_TING_CARD then
			--5听牌背(亮牌面)
			elseif Face == MahjongCardDoc.MJ_FACE_TING_BACK_CARD then
			--6亮牌时的手牌(听牌背)
			elseif Face == MahjongCardDoc.MJ_FACE_PUTDOWN_AN_CARD then
				--7放下的牌(暗杠)
				if Column%4 == 0 then
					valueSprite:setScale(0.5);
					valueSprite:setPosition(0, 16);
				else
					valueSprite = nil;
				end
			end
		end

		if Color ~= -1 then
			if Dir == MahjongCardDoc.MJ_DIR_FRONT or Dir == MahjongCardDoc.MJ_DIR_MAX then
				setSelfCardColor();
			elseif Dir == MahjongCardDoc.MJ_DIR_RIGHT then
				setRightCardColor();
			elseif Dir == MahjongCardDoc.MJ_DIR_BACK then
				setUpCardColor();
			elseif Dir == MahjongCardDoc.MJ_DIR_LEFT then
				setLeftCardColor();
			elseif Dir == MahjongCardDoc.MJ_DIR_GAME_RESULT then
				setGameResultCardColor();
			end
		end

		if front ~= nil then
			CardSprite:addChild(front)
		end

		if valueSprite ~= nil then
			CardSprite:addChild(valueSprite)
		end

		if TingHintSprite ~= nil then
			CardSprite:addChild(TingHintSprite)
		end
	end

	function CardSprite.showBack()
	--		back:setVisible(true)
	--		if front ~= nil then
	--			front:setVisible(false)
	--		end
	end

	function CardSprite.showFront()
	--		if front ~= nil then
	--			front:setVisible(true)
	--			back:setVisible(false)
	--		end
	end

	function CardSprite.showTingHint()
		if TingHintSprite ~= nil then
			TingHintSprite:setVisible(true)
		end
	end

	function CardSprite.hideTingHint()
		if TingHintSprite ~= nil then
			TingHintSprite:setVisible(false)
		end
	end

	function CardSprite.setFrontColor(R, G, B)
		if CardSprite ~= nil then
			CardSprite:setColor(ccc3(R, G, B))
		end
		if front ~= nil then
			front:setColor(ccc3(R, G, B))
		end
		if valueSprite ~= nil then
			valueSprite:setColor(ccc3(R, G, B))
		end
	end

	function CardSprite.setCardOpacity(opacity)
		if CardSprite ~= nil then
			CardSprite:setOpacity(opacity);
		end
		if front ~= nil then
			front:setOpacity(opacity);
		end
		if valueSprite ~= nil then
			valueSprite:setOpacity(opacity);
		end
	end

	function CardSprite.getCardWidth()
		return front:getContentSize().width;
	end

	function CardSprite.getCardHeight()
		return front:getContentSize().height;
	end

	CardSprite:setAnchorPoint(ccp(0.5, 0.5));

	return CardSprite
end








