--动态加载模块配置文件
module("GameLoadModuleConfig", package.seeall)

--老虎机收集字牌 collectcharactercard
CollectCharacterCardGameID = 11;
CollectCharacterCardPackage = "collectcharactercard"
--福星高照GameID fuxingGaozhao
BlessingGameID = 3;
BlessingPackage = "fuxingGaozhao";
--幸运转盘GameID
LuckyTurnTableGameID = 6;
--开箱寻宝GameID openbox
OpenBoxID = 8;
OpenBoxPackage = "openbox";
--积分活动GameID score
ScoreActivityGameID = 9;
ScoreActivityPackage = "score";
--推荐系统ID
RecommendGameID = 10;
--神兽ID
GodBeastGameID = 12;
GodBeastPackage = "godbeast"

--------------------活动/小游戏分割线--------------------

--海外德州GameID
PokerGlobalGameID = 2;
PokerGlobalPackage = "poker";
--牛牛GameID NiuNiu
NiuNiuGameID = 5;
NiuNiuPackage = "NiuNiu";
--21点
BlackJackGameID = 6;
BlackJackPackage = "blackJack"
--百家乐GameID baccarat
BaccaratGameID = 7;
BaccaratPackage = "baccarat";
--百人牛牛GameID MillionNiuNiu
MillionNiuNiuGameID = 8;
MillionNiuNiuPackage = "MillionNiuNiu";
--黑红梅方 GameID hhmf
HhmfGameID = 9;
HhmfPackage = "hhmf";
--炸金牛GameID JinNiu
JinNiuGameID = 10;
JinNiuPackage = "JinNiu";
--字牌游戏 GameID wordPlate
WordPlateID = 12;
WordPlatePackage = "wordPlate";
--骰宝ID
SicboGameID = 14
SicboPackage = "sicbo"
--dragonslots GameID slots
DragonSlotsGameID = 50;
DragonSlotsPackage = "dragonSlots";
--777slots GameID slots
SevenSlotsGameID = 51;
SevenSlotsPackage = "sevenSlots";
--sushislots GameID slots
SushiSlotsGameID = 52;
SushiSlotsPackage = "sushiSlots";
--sushislots GameID slots
NinjiaSlotsGameID = 53;
NinjiaSlotsPackage = "ninjiaSlots";
--momotaroSlots GameID slots
MomotaroSlotsGameID = 54;
MomotaroSlotsPackage = "momotaroSlots";
--koshienSlots GameID slots
KoshienSlotsGameID = 55;
KoshienSlotsPackage = "koshienSlots";
--水果机GameID fruitandgold
FruitGameID = 102;
FruitPackage = "fruitandgold";
--金皇冠GameID fruitandgold
JinHuangGuanGameID = 103;
JinHuangGuanPackage = "fruitandgold";
--万人金花GameID MillionJinHua
WanRenJinHuaGameID = 104;
WanRenJinHuaPackage = "MillionJinHua";
--万人水果派GameID wanrenfriut
WanRenFruitGameID = 105;
WanRenFruitGPackage = "wanrenfriut";
--炸金花GameID jinhua
JinHuaGameID = 106;
JinHuaPackage = "jinhua";
--德州扑克GameID poker
PokerGameID = 107;
PokerPackage = "poker";
--捕鱼GameID crazyFish
FishGameID = 108;
FishPackage = "crazyFish";

--小游戏四川麻将GameID
MahjongSichuanGameID = 109;
MahjongSichuanPackage = "mahjongSichuan";

--[[--
--黑红梅方模块是否存在
--]]
--function getHhmfIsExists()
--	return Common.isFileExist("script/loadModule/hhmf","hhmfConfig.lua");
--end
--[[--
--模块是否存在百家乐
--]]
--function getBaccaratIsExists()
--	return Common.isFileExist("script/loadModule/baccarat","baccaratConfig.lua");
--end
--[[--
--积分活动模块是否存在
--]]
--function getScoreActivityIsExists()
--	return Common.isFileExist("script/loadModule/score","scoreActivityConfig.lua");
--end

--[[--
--老虎机收集字牌是否存在
--]]
function getCollectCharacterCardIsExists()
	return Common.isFileExist("script/privateModule/collectcharactercard","collectcharactercardConfig.lua");
end

--[[--
--福星高照模块是否存在
--]]
--function getBlessingIsExists()
--	return Common.isFileExist("script/loadModule/fuxingGaozhao","fuxingGaozhaoConfig.lua");
--end

--[[--
--开箱寻宝模块是否存在
--]]
--function getOpenBoxIsExists()
--	return Common.isFileExist("script/loadModule/openbox","openboxConfig.lua");
--end

--[[--
--金皇冠和老虎机模块是否存在
--]]
function getFruitAndGoldIsExists()
	return Common.isFileExist("script/loadModule/fruitandgold","fruitandgoldConfig.lua");
end

--[[--
--万人水果派模块是否存在
--]]
--function getWanRenFruitIsExists()
--	return Common.isFileExist("script/loadModule/wanrenfriut","wanrenfriutConfig.lua");
--end

--[[--
--万人金花模块是否存在
--]]
--function getWanRenJinHuaIsExists()
--	return Common.isFileExist("script/loadModule/MillionJinHua","MillionJinHuaConfig.lua");
--end

--[[--
--21点模块是否存在
--]]
function getBlackJackExists()
	return Common.isFileExist("script/loadModule/blackJack","blackJackConfig.lua")
end

--[[--
--捕鱼模块是否存在
--]]
function getFishIsExists()
	return Common.isFileExist("script/loadModule/crazyFish","crazyFishConfig.lua");
end
--[[--
--炸金花模块是否存在
--]]
function getJinHuaIsExists()
	return Common.isFileExist("script/loadModule/jinhua","jinhuaConfig.lua");
end

--[[--
--德州模块是否存在
--]]
function getPokerIsExists()
	return Common.isFileExist("script/loadModule/poker","pokerConfig.lua");
end

--[[--
--财神模块是否存在
--]]
function getCaiShenIsExists()
	return Common.isFileExist("script/privateModule/caishen","CaiShenConfig.lua");
end

--[[--
--牛牛模块是否存在
--]]
function getNiuNiuIsExists()
	return Common.isFileExist("script/loadModule/NiuNiu","NiuNiuConfig.lua");
end

--[[--
--百人牛牛模块是否存在
--]]
function getMillionNiuNiuIsExists()
	return Common.isFileExist("script/loadModule/MillionNiuNiu","MillionNiuNiuConfig.lua");
end

--[[--
--炸金牛模块是否存在
--]]
function getJinNiuIsExists()
	return Common.isFileExist("script/loadModule/JinNiu","JinNiuConfig.lua");
end

--[[--
--竞技场模块是否存在
--]]
function getArenaExists()
	return Common.isFileExist("script/privateModule/arena","ArenaConfig.lua");
end

--[[--
--摇钱树模块是否存在
--]]
function getYaoQianShuExists()
	return Common.isFileExist("script/privateModule/yaoqianshu","YaoQianShuConfig.lua");
end

--[[--
--神兽模块是否存在
--]]
function getGodBeastExists()
	return Common.isFileExist("script/privateModule/godbeast","GodBeastConfig.lua");
end

--[[--
--骰宝模块是否存在
--]]
function getSicboExists()
	return Common.isFileExist("script/loadModule/sicbo","SicboConfig.lua");
end

--[[--
--字牌游戏模块是否存在
--]]
function getWordPlateExists()
	return Common.isFileExist("script/loadModule/wordPlate","wordPlateConfig.lua")
end

--[[--
-- 加载活动模块
--]]--
function loadPrivateModule()
	local path = "script.privateModule."

	if (GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID or GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID)
		and getArenaExists() then
		--竞技场存在
		Load.LuaRequire(path .. "arena.ArenaConfig")
	end

	if (GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID or GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID or GameConfig.GAME_ID == GamePub.FISH_GAME_ID)
		and getYaoQianShuExists() then
		--摇钱树存在
		Load.LuaRequire(path .. "yaoqianshu.YaoQianShuConfig")
	end

	if getGodBeastExists() then
		--神兽存在
		Load.LuaRequire(path .. "godbeast.GodBeastConfig")
	end

	if getCaiShenIsExists() then
		--财神存在
		Load.LuaRequire(path .. "caishen.CaiShenConfig")
	end

	if GameConfig.GAME_ID ==  GamePub.LORD_GAME_ID and getCollectCharacterCardIsExists() then
		--斗地主中收集字牌
		Load.LuaRequire(path .. "collectcharactercard.collectcharactercardConfig")
	end

end

--[[--
--加载小游戏模块
--]]--
function loadMiniGameModule()
	local path = "script.loadModule."
	if GameConfig.GAME_ID == GamePub.POKER_GAME_ID and  getPokerIsExists() then
		--德州扑克存在
		Load.LuaRequire(path .. "poker.pokerConfig");
	end

	if GameConfig.GAME_ID == GamePub.FISH_GAME_ID and getFishIsExists() then
		--捕鱼存在
		Load.LuaRequire(path .. "crazyFish.crazyFishConfig")
	end

	if GameConfig.GAME_ID == GamePub.JINHUA_GAME_ID and getJinHuaIsExists() then
		--炸金花存在
		Load.LuaRequire(path .. "jinhua.jinhuaConfig")
	end

	if GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID and getNiuNiuIsExists() then
		--牛牛存在
		Load.LuaRequire(path .. "NiuNiu.NiuNiuConfig")
	end

	if GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID and getMillionNiuNiuIsExists() then
		--百人牛牛存在
		Load.LuaRequire(path .. "MillionNiuNiu.MillionNiuNiuConfig")
	end

	if GameConfig.GAME_ID == GamePub.DOUNIU_GAME_ID and getJinNiuIsExists() then
		--炸金牛存在
		Load.LuaRequire(path .. "JinNiu.JinNiuConfig")
	end

	if GameConfig.GAME_ID == GamePub.ZIPAI_GAME_ID and getWordPlateExists() then
		--字牌存在
		Load.LuaRequire(path .. "wordPlate.wordPlateConfig")
	end

	if getSicboExists() then
		--骰宝存在
		Load.LuaRequire(path .. "sicbo.SicboConfig")
	end

	if getBlackJackExists() then
		--21点存在
		Load.LuaRequire(path .. "blackJack.blackJackConfig")
	end
end

--[[--
--加载游戏模块
--]]
function loadGameModule()
	--加载小游戏模块
	loadMiniGameModule()
	--加载活动模块
	loadPrivateModule()
end

--[[--
--获取小游戏GameID列表
--]]
function getMiniGameConfigList()
	local miniGameConfigList = {}

	return miniGameConfigList;
end

--[[--
--获取活动GameID列表
--]]
function getTaskGameConfigList()
	local miniTaskConfigList = {}

	return miniTaskConfigList;
end

local mCurrentMiniGameID = 0;--当前启动的小游戏ID

--[[--
--设置当前启动的小游戏ID
--]]
function setCurrentMiniGameID(miniGameID)
	mCurrentMiniGameID = miniGameID
end

local mCurrentActivityID = 0;--当前启动的活动ID

--[[--
--设置当前启动的活动ID
--]]
function setCurrentActivityID(activityID)
	mCurrentActivityID = activityID
end

--[[--
-- 是否启动过小游戏
-- ]]
function isLaunchedMiniGame(miniGamePackage)
	local isLaunched = Common.getDataForSqlite("Launched_MiniGame_"..miniGamePackage);
	if isLaunched == nil then
		return false;
	else
		return true;
	end
end

--[[--
-- 设置启动过的小游戏
-- ]]
local function setLaunchedMiniGame(miniGamePackage)
	local isLaunched = Common.getDataForSqlite("Launched_MiniGame_"..miniGamePackage);
	if isLaunched == nil then
		Common.setDataForSqlite("Launched_MiniGame_"..miniGamePackage, "1");
	end
end

--[[--
-- 加载小游戏脚本代码
-- ]]
function loadMiniGameByPackage(package, isReLoad)
	local fileDir = "script/loadModule/" .. package;
	local fileConfig = package.."Config.lua";
	local filePath = fileDir .. "." .. package .. "Config";

	Common.log("loadMiniGameByPackage path ============= "..filePath);

	if Common.isFileExist(fileDir, fileConfig) then
		if isReLoad ~= nil then
			Load.isReLoadLua = isReLoad;
			Common.log("重新加载小游戏脚本代码 ======== "..package);
		else
			Load.isReLoadLua = false;
		end
		Load.LuaRequire(filePath);
		Load.isReLoadLua = false;
	end
end

--[[--
--启动小游戏by小游戏ID
--@param #number nMiniGameID 小游戏ID
--@param #string nPackage 小游戏包名(可以是nil)
--@param #string launchParam 游戏启动参数(用于启动游戏的不同玩法,可以是nil,默认是快速开始)
--]]
function startMiniGameByID(nMiniGameID, nPackage, launchParam)
	local miniGameID = nMiniGameID;
	local package = nil;
	if nPackage ~= nil then
		package = nPackage;
	else
		package = GameCommonProfile.MiniGame.getMiniGamePackageByID(miniGameID);
	end

	if package == nil then
		Common.log("startMiniGameByID package ============= "..package);
		return;
	end

	local isCanLaunch, downloadState = GameCommonProfile.LuaScriptUpdate.logicMiniGameLaunch(package);

	if not isCanLaunch then
		--不可以启动
		--没有下载
		LuaUpdateConfig.showMiniGameLuaUpdatePrompt(downloadState, miniGameID, package);

		return;
	end

	launchMiniGameByID(miniGameID, package, launchParam);
end

--[[--
--跳过更新判断直接启动小游戏
--@param #number nMiniGameID 小游戏ID
--@param #string nPackage 小游戏包名(可以是nil)
--@param #string launchParam 游戏启动参数(用于启动游戏的不同玩法,可以是nil,默认是快速开始)
--]]
function launchMiniGameByID(miniGameID, package, launchParam)
	loadMiniGameByPackage(package);

	local startMiniGame = "startMiniGameBy" .. miniGameID;

	if _G[startMiniGame] ~= nil then
		setLaunchedMiniGame(package);
		--找到了启动游戏的方法
		_G[startMiniGame](launchParam);--启动
	else
		--未找到启动方法
		if Common.isDebugState() then
			Common.showToast("仅debug阶段可见 启动小游戏失败 "..miniGameID, 2);
		end
	end
end

--[[--
--启动活动by活动ID
--]]
function startActivityByID(activityID)
	local package = nil;

	if activityID == CollectCharacterCardGameID then
		--老虎机收集字牌
		package = CollectCharacterCardPackage;
	elseif activityID == BlessingGameID then
		--福星高照
		package = BlessingPackage;
	elseif activityID == OpenBoxID then
		--开箱寻宝
		package = OpenBoxPackage;
	elseif activityID == ScoreActivityGameID then
		--积分活动
		package = ScoreActivityPackage;
	elseif activityID == GodBeastGameID then
		--神兽活动
		package = GodBeastPackage
	end

	if package == nil then
		Common.log("startActivityByID package ============= "..package);
		return;
	end

	local fileDir = "script/privateModule/" .. package;
	local fileConfig = package.."Config.lua";
	local filePath = fileDir .. "." .. package .. "Config";

	Common.log("startActivityByID path ============= "..filePath);

	if Common.isFileExist(fileDir, fileConfig) then
		Load.LuaRequire(filePath);
	end

	local startActivity = "startActivityBy" .. activityID;

	if _G[startActivity] ~= nil then
		--找到了启动游戏的方法
		_G[startActivity]();--启动
		setCurrentActivityID(activityID);
	else
		--未找到启动方法
		if Common.isDebugState() then
			Common.showToast("仅debug阶段可见 启动活动失败 "..activityID, 2);
		end
	end
end

--[[--
--获取加载模块的gameID
--]]
function getLoadModuleGameID()
	if mCurrentMiniGameID > 0 then
		return mCurrentMiniGameID;
	end

	if mCurrentActivityID > 0 then
		return mCurrentActivityID;
	end

	return 0
end

--[[--
--释放lua缓存
--]]
function releaseLuaCache(_mname)
	if package.loaded[_mname] ~= nil then
		--Load.log(string.format("releaseLuaCache module[%s] ", _mname))
		package.loaded[_mname] = nil
	end
end
