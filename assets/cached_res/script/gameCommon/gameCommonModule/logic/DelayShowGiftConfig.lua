module("DelayShowGiftConfig",package.seeall)

isMiniGameState = false --现在是否是小游戏界面
hasShowHallGiftAtMiniGame = false --是否有礼包可以展示
isDelayShowGiftAtMiniGame = true --是否是延迟显示的礼包（非点击礼包）

--[[--
--小游戏结果结束后弹出小游戏内暂存的礼包
--]]
function showHallGiftAfterMiniGameResult()

	--如果小游戏结果后有礼包则显示暂存的礼包
	if hasShowHallGiftAtMiniGame then
		hasShowHallGiftAtMiniGame = false
		local giftData = profile.Gift.getGiftDataTable()
		mvcEngine.createModule(GUI_GIFT_SHOW_VIEW)
		HallGiftShowLogic.setGiftData(giftData)
	end
end

--[[--
--重置为需要暂存礼包状态
--]]
function resetGiftAtMiniGame()
	isDelayShowGiftAtMiniGame = true
end

--[[--
--不延迟显示的礼包（主动请求礼包则不延时）
--]]
function setShowGiftAtMiniGame()
	isDelayShowGiftAtMiniGame = false
end

--[[--
--初始化小游戏暂存礼包状态
--]]
function initMiniGameGiftState()
	isMiniGameState = true
	isDelayShowGiftAtMiniGame = true
end

--显示暂存的礼包
--DelayShowGiftConfig.showHallGiftAfterMiniGameResult()
