module("MahjongTableConfig", package.seeall)

TableDefaultWidth = 1920 -- 牌桌默认宽度
TableDefaultHeight = 1080 -- 牌桌默认高度
TableScaleX = 1 -- 牌桌缩放比例x
TableScaleY = 1 -- 牌桌缩放比例y
cardWidth = 144 -- 纸牌宽
cardHeight = 204 -- 纸牌高

--------------聊天类型----------------------
--聊天类型：文字
TYPE_CHAT_TEXT = 1
--聊天类型：高级表情
TYPE_CHAT_EMOTION = 2

animation_scale = 1.68

--用户头像底框位置坐标(牌桌位置pos+1,自己是0,逆时针,下右上左)
playerPhotoBGXY = {
	{130, 246},
	{1835, 655},
	{1472, 1023},
	{100, 655}
}

--用户头像位置坐标(牌桌位置pos+1,自己是0,逆时针,下右上左)
playerPhotoXY = {
	{67, 246},
	{1835, 691},
	{1409, 1023},
	{100, 691}
}

--用户游戏状态位置坐标(牌桌位置pos+1,自己是0,逆时针,下右上左)
playerGameStateXY = {
	{960, 100},
	{1647, 627},
	{960, 957},
	{273, 627}
}

--用户定缺标识位置坐标(牌桌位置pos+1,自己是0,逆时针,下右上左)
DingQueXY = {
	{36, 277},
	{1872, 717},
	{1378, 1044},
	{67, 717}
}

--骰子的位置
DiceXY = {
	{TableDefaultWidth/2-14, TableDefaultHeight/2+2},
	{TableDefaultWidth/2+34, TableDefaultHeight/2-38},
}

--定缺的万筒条的位置
DingQueAniXY = {
	{560, 339},
	{960, 339},
	{1360, 339},
}

--用户打牌特效的位置
playerCardAnimXY = {
	{960, 370},
	{1496, 630},
	{960, 893},
	{426, 630}
}

--用户已换的三张牌的位置
playerChangeCardsXY = {
	{960, 376},
	{1288, 630},
	{960, 781},
	{631, 630}
}

--用户聊天气泡位置坐标(牌桌位置pos+1,自己是0,逆时针,下右上左)
playerChatBubbleXY = {
	{107, 266},
	{1787, 711},
	{1366, 1043},
	{137, 711}
}

--[[--
--获取筹码格式化数据
--]]
function getChipFormat(chip)
	local chipFormat = chip;
	if chip/100000000 > 1 then
		local num = chip/100000000
		if math.floor(num) < num then
			--小数
			if num < math.floor(num) + 0.1 then
				chipFormat = math.floor(num).."亿";
			else
				chipFormat = string.format("%.1f", num).."亿";
			end
		else
			--整数
			chipFormat = num.."亿";
		end
	elseif chip/10000 >= 1 then
		local num = chip/10000
		if math.floor(num) < num then
			--小数
			if num < math.floor(num) + 0.1 then
				chipFormat = math.floor(num).."万";
			else
				chipFormat = string.format("%.1f", num).."万";
			end
		else
			--整数
			chipFormat = num.."万";
		end
		--	elseif chip/1000 > 1 then
		--		local num = chip/1000
		--		if math.floor(num) < num then
		--			--小数
		--			chipFormat = string.format("%.1f", num).."k";
		--		else
		--			--整数
		--			chipFormat = num.."k";
		--		end
	end
	return chipFormat;
end

function getJsonPath(name)
	return "loadModule/mahjongSichuan/mahjongSichuanRes/"..name;
end

--[[--
--获取麻将牌桌的资源路径
--]]
function getResPath(name)
	return Common.getScriptPath("loadModule/mahjongSichuan/mahjongSichuanRes/"..name);
end
--[[--
--获取麻将牌的资源路径
--]]
function getCardResPath(name)
	return Common.getScriptPath("loadModule/mahjongSichuan/mahjongSichuanRes/card/"..name);
end