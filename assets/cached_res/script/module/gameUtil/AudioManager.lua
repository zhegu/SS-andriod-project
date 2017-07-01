module("AudioManager", package.seeall)

local msOldMusicName = nil--当前正在播放的音乐名称

function getOldMusicName()
	return msOldMusicName;
end

--[[--
--预加载背景音乐
--@param #string musicFilePath 背景音乐路径
--]]
function preLoadBgMusic(musicFilePath)

	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(musicFilePath);

	SimpleAudioEngine:sharedEngine():preloadBackgroundMusic(FilePath);
end

--[[--
--预加载音效
--@param #string musicFilePath 音效路径
--]]
function preLoadSound(soundFilePath)

	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(soundFilePath);

	SimpleAudioEngine:sharedEngine():preloadEffect(FilePath);
end


--[[--
--播放背景音乐
--@param #string musicFilePath 音效路径
--@param #bool loop 是否循环 --default = true
--]]
function playBgMusic(musicFilePath, loop)

	if (SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying()) then
		--先判断是否已经在播放,如果在播放，则切换播放
		stopBgMusic(false)
	end
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(musicFilePath);
	SimpleAudioEngine:sharedEngine():playBackgroundMusic(FilePath, loop);
end

--[[--
--播放音效
--@param #string soundFilePath 音效路径
--@param #bool loop 是否循环 --default is false
--]]
function playSound(soundFilePath, loop)
	Common.log("播放音效 soundFilePath ====== "..soundFilePath)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(soundFilePath);
	local soundId = SimpleAudioEngine:sharedEngine():playEffect(FilePath, loop);
end

--[[--
--暂停背景音乐
--]]
function pauseBgMusic()
	SimpleAudioEngine:sharedEngine():pauseBackgroundMusic();
end

--[[--
--暂停音效
--]]
function pauseSound(soundId)
	SimpleAudioEngine:sharedEngine():pauseEffect(soundId);
end

--[[--
--停止背景音乐
--@param #bool release 是否释放资源 default is true
--]]
function stopBgMusic(release)
	if release then
		msOldMusicName = nil;
	end
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic(release);
end

--[[--
--停止音效
--]]
function stopSound(soundId)
	SimpleAudioEngine:sharedEngine():stopEffect(soundId);
end

--[[--
--停止所有音效
--]]
function stopAllSound()
	SimpleAudioEngine:sharedEngine():stopAllEffects();
end

--[[--
--恢复背景音乐
--]]
function resumeBgMusic()
	SimpleAudioEngine:sharedEngine():resumeBackgroundMusic();
end

function AudioEnd()
--    SimpleAudioEngine:sharedEngine():end();
end

mbIsloadSDMusic = true;-- 是否可以加载SD卡上的音乐资源
mbIsloadStart = false;-- 资源是否开始加载
mbIsloadEnd = false;-- 资源是否加载完毕

SOUND = -1;-- 音效(不分男女)
SECRECY = 0;-- 保密
MAN = 1;-- 男
WOMAN = 2;-- 女

SOUND_BACKGOUND = "mahjongAudio/background";-- 背景音乐
SOUND_EFFECT = "mahjongAudio/background";-- 音效
SOUND_MAN = "LordAudio/sound_man";-- 男声
SOUND_WOMAN = "LordAudio/sound_woman";-- 女声

TableSound = {}--游戏的音效
TableBgMusic = {}--背景音乐

--数组长度 #a，等价于table.getn(a)，返回从1开始的连续整数下标个数。另有maxn返回最大的整数下标（可以不连续）。

local function loadSystemAudio()
	TableSound["CLICK"] = "click.mp3";-- 点击按钮
	TableSound["BACK"] = "back.mp3";-- 返回按钮
	TableSound["GET_AWARD"] = "getaward.mp3";-- 获取奖励
	TableSound["GET_COIN"] = "getcoin.mp3";-- 获取金币
end

--[[--
--初始化牌桌音乐
--]]
function initGameAudio()
	loadSystemAudio();

	TableBgMusic["HALL_BACKGROUND"] = "mahjongAudio/mj_bg_01.mp3";-- 大厅背景音乐

	Common.log("初始化音效 ======== ")
end

--[[--
--加载音效
--]]
function loadTableEffect()
	if (mbIsloadSDMusic) then
		-- 音效
		for key, var in pairs(TableSound) do
			local soundFilePath = SOUND_EFFECT .. "/" .. var
			Common.log(soundFilePath)
			preLoadSound(Common.getResourcePath(soundFilePath))
		end
		-- 背景音乐
		for key, var in pairs(TableBgMusic) do
			local soundFilePath = SOUND_BACKGOUND .. "/" .. var
			Common.log(soundFilePath)
			preLoadBgMusic(Common.getResourcePath(soundFilePath))
		end
	end
end

--[[--
--是否是牌桌聊天音效
--]]
local function isTableChatVoice(soundName)
	for i = 1, 12 do
		if soundName == "chat_"..(i - 1)..".mp3" then
			return true
		end
	end
end

--[[--
* 播放音效
*
* @param soundName
*            文件名
* @param loop
*            loop mode (0 = no loop, -1 = loop forever)
* @param sex
*            性别 1男 2女;0保密;-1不分男女
--]]

function playGameSound(soundName, loop, sex)
	if (GameConfig.getGameSoundOff()) then
		local sFileName = "";
		if (sex == MAN or sex == SECRECY) then
			-- 男
			sFileName = SOUND_MAN .. "/" .. soundName;
		elseif (sex == WOMAN) then
			-- 女
			sFileName =  SOUND_WOMAN .. "/" .. soundName;
		else
			sFileName = SOUND_EFFECT .. "/" .. soundName;
		end

		playSound(Common.getResourcePath(sFileName), loop)
	end

end

--[[--
* 暂停音效
*
* @param soundName
*            如果是nil,则全部停止
--]]
function stopSound(soundName)
	soundName = SOUND_EFFECT .. "/" .. soundName;
end

--[[--
--播放背景音乐
--]]
function playBackgroundMusic(Name)
	if (GameConfig.getGameMusicOff()) then
		local MusicName = Common.getResourcePath(Name);
		playBgMusic(MusicName, true)
	end
end

--[[--
--继续上次播放的音乐
--]]
function resumeBackgroundMusic()
	if GameConfig.getGameMusicOff() then
		local MusicName = Common.getResourcePath(TableBgMusic.HALL_BACKGROUND);
		playBgMusic(MusicName, true)
	end
end
