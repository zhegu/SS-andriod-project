module("MahjongTableTypeface",package.seeall)

TYPE_FACE_WHITE = 0--白色字体
TYPE_FACE_YELLOW = 1--黄色字体

--[[--
--获取数字格式化数据
--]]
local function getTypefaceFormat(chip)
	local chipFormat = chip;
	if chip/100000000 > 1 then
		local num = chip/100000000
		if math.floor(num) < num then
			--小数
			if num < math.floor(num) + 0.1 then
				chipFormat = math.floor(num).."y";
			else
				chipFormat = GamePub.getPreciseDecimal(num, 2).."y";
			end
		else
			--整数
			chipFormat = num.."y";
		end
	elseif chip/10000 >= 1 then
		local num = chip/10000
		if math.floor(num) < num then
			--小数
			if num < math.floor(num) + 0.1 then
				chipFormat = math.floor(num).."w";
			else
				chipFormat = GamePub.getPreciseDecimal(num, 2).."w";
			end
		else
			--整数
			chipFormat = num.."w";
		end
	else
		chipFormat = ""..chipFormat
	end

	return chipFormat;
end

--[[--
--获取白色字体
--]]
local function getWhiteImageName(str)
	if str == nil then
		return "niuniu_typeface_bg.png";
	end
	if str == "0" then
		return "num_genzhu_0.png";
	elseif str == "1" then
		return "num_genzhu_1.png";
	elseif str == "2" then
		return "num_genzhu_2.png";
	elseif str == "3" then
		return "num_genzhu_3.png";
	elseif str == "4" then
		return "num_genzhu_4.png";
	elseif str == "5" then
		return "num_genzhu_5.png";
	elseif str == "6" then
		return "num_genzhu_6.png";
	elseif str == "7" then
		return "num_genzhu_7.png";
	elseif str == "8" then
		return "num_genzhu_8.png";
	elseif str == "9" then
		return "num_genzhu_9.png";
	elseif str == "." then
		return "num_genzhu_dot.png";
	elseif str == "w" then
		return "num_genzhu_wan.png";
	elseif str == "y" then
		return "num_genzhu_yi.png";
	else
		return "niuniu_typeface_bg.png";
	end
end

--[[--
--获取黄色字体
--]]
local function getYellowImageName(str)
	if str == nil then
		return "niuniu_typeface_bg.png";
	end
	if str == "0" then
		return "DN_public_number_golden_0.png";
	elseif str == "1" then
		return "DN_public_number_golden_1.png";
	elseif str == "2" then
		return "DN_public_number_golden_2.png";
	elseif str == "3" then
		return "DN_public_number_golden_3.png";
	elseif str == "4" then
		return "DN_public_number_golden_4.png";
	elseif str == "5" then
		return "DN_public_number_golden_5.png";
	elseif str == "6" then
		return "DN_public_number_golden_6.png";
	elseif str == "7" then
		return "DN_public_number_golden_7.png";
	elseif str == "8" then
		return "DN_public_number_golden_8.png";
	elseif str == "9" then
		return "DN_public_number_golden_9.png";
	elseif str == "." then
		return "DN_public_number_golden_point.png";
	elseif str == "+" then
		return "DN_public_number_golden_add.png";
	elseif str == "w" then
		return "DN_public_number_golden_10k.png";
	elseif str == "y" then
		return "DN_public_number_golden_m.png";
	else
		return "niuniu_typeface_bg.png";
	end
end

--[[--
--获取白色自定义字体
--@param #number What 数字
--]]
function getTypefaceSprite(value, type)
	local str = getTypefaceFormat(value);

	--	if type == TYPE_FACE_YELLOW then
	--		str = "+" .. str
	--	end

	local len = string.len(str)
	local SpriteBG = CCSprite:createWithSpriteFrameName("niuniu_typeface_bg.png")
	local imageTable = {}
	local SpriteBG_width = 0
	local SpriteBG_height = 0
	for i = 1, len do
		imageTable[i] = {}
		local new_str = string.sub(str,i,i)
		local ImageName = "";
		if type == TYPE_FACE_WHITE then
		--			ImageName = getWhiteImageName(new_str);
		elseif type == TYPE_FACE_YELLOW then
			ImageName = getYellowImageName(new_str);
		else
			ImageName = getYellowImageName(new_str);
		end
		local imageSprite = CCSprite:createWithSpriteFrameName(ImageName)
		local sprSizeWidth = imageSprite:getContentSize().width
		local sprSizeHeight = imageSprite:getContentSize().height
		if type == TYPE_FACE_YELLOW then
			imageSprite:setScale(0.73)
			sprSizeWidth = sprSizeWidth * 0.73
			SpriteBG_height = sprSizeHeight * 0.73
		end
		SpriteBG_width = SpriteBG_width + sprSizeWidth
		SpriteBG_height = sprSizeHeight

		imageTable[i].Sprite = imageSprite
		imageTable[i].PositionX = SpriteBG_width - sprSizeWidth + sprSizeWidth / 2
	end

	SpriteBG:setContentSize(CCSizeMake(SpriteBG_width, SpriteBG_height))

	for index = 1, #imageTable do
		imageTable[index].Sprite:setPosition(ccp(imageTable[index].PositionX, SpriteBG_height / 2))
		SpriteBG:addChild(imageTable[index].Sprite);
	end

	SpriteBG:setAnchorPoint(ccp(0.5, 0.5));

	return SpriteBG
end

