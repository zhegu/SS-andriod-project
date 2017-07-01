module("MahjongAudioManager", package.seeall)

local SOUND = -1; -- 音效(不分男女)
local SECRECY = 0; -- 保密
local MAN = 1; -- 男
local WOMAN = 2; -- 女

SoundType = 1; --音效类型
local SOUND_TYPE_PERSONAL = 0; --普通话
local SOUND_TYPE_SICHUAN = 1; --四川话

local SOUND_EFFECT_PATH = "mahjongSichuanAudio/SoundVoice"; -- 音效
local SOUND_PERSONAL_PATH = "mahjongSichuanAudio/PersonalVoice"; -- 普通话
local SOUND_SICHUAN_PATH = "mahjongSichuanAudio/SiChuanVoice"; -- 四川话

TableVoice = {} --游戏的音效

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
--停止背景音乐
--@param #bool release 是否释放资源 default is true
--]]
function stopBgMusic(release)
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic(release);
end

--[[--
--播放音效
--@param #string soundFilePath 音效路径
--@param #bool loop 是否循环 --default is false
--]]
function playSound(soundFilePath, loop)
	Common.log("播放音效 soundFilePath ====== " .. soundFilePath)
	local FilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(soundFilePath);
	local soundId = SimpleAudioEngine:sharedEngine():playEffect(FilePath, loop);
end

--数组长度 #a，等价于table.getn(a)，返回从1开始的连续整数下标个数。另有maxn返回最大的整数下标（可以不连续）。
--[[--
--初始化牌桌音乐
--]]
function initMahjongTableAudio()
	--人声
	TableVoice["MING_GANE"] = "_gang_1.mp3"; --明杠
	TableVoice["AN_GANE"] = "_gang_2.mp3"; --暗杠
	TableVoice["BU_GANE"] = "_gang_3.mp3"; --补杠
	TableVoice["HU_PAI"] = "_hupai.mp3"; --胡牌
	TableVoice["PENG"] = "_peng.mp3"; --碰
	TableVoice["TIAN_HU"] = "_tianhu.mp3"; --天胡
	TableVoice["TING"] = "_ting.mp3"; --听
	TableVoice["ZI_MO"] = "_zimo.mp3"; --自摸

	--音效
	TableVoice["MJ_BEGIN"] = "mj_begin.mp3"; --开始
	TableVoice["MJ_DAPAI"] = "mj_dapai.mp3"; --打牌
	TableVoice["MJ_TUIPAI"] = "mj_tuipai.mp3"; --推牌
	TableVoice["MJ_XUANIPAI"] = "mj_xuanpai.mp3"; --选牌

	TableVoice["SOUND_TOMATO"] = "interaction_tomato.mp3" -- 互动表情西红柿
	TableVoice["SOUND_FLOWER"] = "interaction_flower.mp3" -- 互动表情鲜花
	TableVoice["SOUND_BOMB"] = "interaction_bomb.mp3" -- 互动表情炸弹
	TableVoice["SOUND_KISS"] = "interaction_kiss.mp3" -- 互动表情吻
	TableVoice["SOUND_SHIT"] = "interaction_tomato.mp3" -- 互动大便
	TableVoice["SOUND_GUN"] = "interaction_gun.mp3" -- 互动表情机枪

	--背景音乐
	--TableVoice["TABLE_BACKGROUND"] = "mj_bg_01.mp3"; -- 房间背景音乐
	Common.log("初始化音效 ======== ")
end


--[[--
* 播放音效
* @param soundName文件名
* @param sex性别 1男 2女;0保密;-1不分男女
--]]
function playMahjongSound(soundName, sex)
	if (GameConfig.getGameSoundOff()) then
		local sFileName = "";
		if sex < 0 then
			--音效
			sFileName = SOUND_EFFECT_PATH .. "/" .. TableVoice[soundName];
		else
			local FileDir = "";
			if SoundType == SOUND_TYPE_PERSONAL then
				--普通话版
				FileDir = SOUND_PERSONAL_PATH
			elseif SoundType == SOUND_TYPE_SICHUAN then
				--四川话版
				FileDir = SOUND_SICHUAN_PATH
			end

			if (sex == MAN or sex == SECRECY) then
				-- 男
				sFileName = FileDir .. "/nan" .. TableVoice[soundName];
			elseif (sex == WOMAN) then
				-- 女
				sFileName = FileDir .. "/nv" .. TableVoice[soundName];
			end
		end

		playSound(MahjongTableConfig.getResPath(sFileName), false)
	end
end


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

--[[--
* 播放麻将牌人声音效
* @param soundName文件名
* @param looploop mode (0 = no loop, -1 = loop forever)
* @param sex性别 1男 2女;0保密;-1不分男女
--]]

function playMahjongCardSound(cardValue, sex)
	if (GameConfig.getGameSoundOff()) then
		local sFileName = "";
		local FileDir = "";
		local nColor, nWhat = MahjongCardDoc.getCardInfoByValue(cardValue);
		local SoundIndex = string.format("%s%d.mp3", getImgColorIndex(nColor), nWhat + 1);
		if SoundType == SOUND_TYPE_PERSONAL then
			--普通话版
			FileDir = SOUND_PERSONAL_PATH
		elseif SoundType == SOUND_TYPE_SICHUAN then
			--四川话版
			FileDir = SOUND_SICHUAN_PATH
		end

		if (sex == MAN or sex == SECRECY) then
			-- 男
			sFileName = FileDir .. "/nanCardVoice_" .. SoundIndex;
		elseif (sex == WOMAN) then
			-- 女
			sFileName = FileDir .. "/nvCardVoice_" .. SoundIndex;
		end

		playSound(MahjongTableConfig.getResPath(sFileName), false)
	end
end

--[[--
--播放背景音乐
--]]
function playTableBackgroundMusic()
--	if (GameConfig.getGameMusicOff()) then
--		local MusicName = SOUND_EFFECT_PATH .. "/" .. TableVoice["TABLE_BACKGROUND"];
--		playBgMusic(MahjongTableConfig.getResPath(MusicName), true)
--	end
end
