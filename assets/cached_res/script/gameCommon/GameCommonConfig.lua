module("GameCommonConfig",package.seeall)

--[[--
--显示debug信息
--]]
function showDebugInfo(info, isBug, fileName)
	if info == nil or info == "" then
		return;
	end
	mvcEngine.createModule(GUI_BUGINFOVIEW);
	BugInfoViewLogic.showDebugInfo(info, isBug, fileName);
end

--[[--
--重连成功以后判断是否有断线续玩
--]]
function logicGameSync()
--	if GamePub.isInPokerGameTable() then
--		--德州牌桌
--		PokerTableConsole.logicGameSync();
--	elseif GamePub.isInJinHuaGameTable() then
--		--金花牌桌
--		JinHuaTableLogic.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_BACCARAT_TABLE then
--		--百家乐牌桌
--		BaccaratTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_SEVENSLOTS then
--		--777slots牌桌
--		SevenSlotsTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_DRAGONSLOTS then
--		--dragonslots牌桌
--		DragonSlotsTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_NINJIASLOTS then
--		--ninjiaslots牌桌
--		NinjiaSlotsTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_MOMOTAROSLOTS then
--		--momotaroslots牌桌
--		MomotaroSlotsTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_KOSHIENSLOTS then
--		--koshienslots牌桌
--		KoshienSlotsTableConsole.logicGameSync();
--	elseif GamePub.isInNiuNiuGameTable() then
--		--斗牛
--		NiuNiuTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_MILLIONNIUNIUTABLE then
--		--百人牛牛
--		MillionNiuNiuTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_WANRENJINHUA then
--		--万人金花
--		MillionJinHuaTableConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_FISH then
--		--捕鱼
--		FishConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_HHMF then
--		--黑红梅方
--		HhmfConsole.logicGameSync();
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_TABLE then
--		--斗地主牌桌
--		TableConsole.logicGameSync();
--	elseif GamePub.isInZiPaiGameTable() then
--		WordPlateTableConsole.logicGameSync()
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_BLACKJACKTABLE then
--		--21点牌桌
--		BlackJackTableConsole.logicGameSync()
--	elseif GamePub.isInSicboGame() then
--		--骰宝牌桌
--		SicboConsole.logicGameSync()
--	elseif GameConfig.getTheCurrentBaseLayer() == GUI_MAHJONGTABLE then
--		--麻将牌桌
--		MahjongTableConsole.logicGameSync()
--	end
end

--[[--
--显示日志信息列表
--]]
function showLogListView()
	mvcEngine.createModule(GUI_BUGINFOLISTVIEW);
end

--[[--
-- 修改Android包名前缀
-- ]]
local function changeAndroidPackage()
	if GameConfig.GAME_ID == GamePub.ZIPAI_GAME_ID then
		Common.AndroidGamePackage = "com.thirdparty.client";
	end
end

--[[--
-- 初始化游戏公共配置信息
-- ]]
function initGameCommonConfig()
	changeAndroidPackage();
end