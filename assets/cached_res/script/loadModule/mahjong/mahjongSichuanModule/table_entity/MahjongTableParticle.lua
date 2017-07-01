module("MahjongTableParticle", package.seeall)

local CountDownParticle = nil;

--[[--
--显示倒计时粒子效果
--]]
function showCountDownParticle(x, y)
	if CountDownParticle == nil then
		CountDownParticle = CCParticleSystemQuad:create(PokerTableConfig.getResPath("particle_countdown1.plist"))
		CountDownParticle:setPosition(ccp(x, y))
		CountDownParticle:setZOrder(5)
		PokerTablePlayerLayer.getTablePlayerLayer():addChild(CountDownParticle) -- 加到显示对象上就开始播放了
		--particleClicked:setAutoRemoveOnFinish(true)
	else
		CountDownParticle:setPosition(ccp(x, y))
		CountDownParticle:setVisible(true);
	end
end

--[[--
--隐藏倒计时粒子效果
--]]
function hideCountDownParticle()
	if CountDownParticle ~= nil and CountDownParticle:isVisible() then
		CountDownParticle:setVisible(false);
	end
end

--[[--
--移除倒计时粒子效果
--]]
function removeCountDownParticle()
	if CountDownParticle ~= nil then
		PokerTablePlayerLayer.getTablePlayerLayer():removeChild(CountDownParticle, true);
		CountDownParticle = nil;
	end
end

--[[--
--显示倒计时粒子效果
--]]
function showVipSitDownParticle(x, y)
	local mParticle = CCParticleSystemQuad:create(PokerTableConfig.getResPath("vipsitdown.plist"))
	mParticle:setPosition(ccp(x, y))
	mParticle:setZOrder(-1)
	PokerTablePlayerLayer.getTablePlayerLayer():addChild(mParticle) -- 加到显示对象上就开始播放了
	mParticle:setAutoRemoveOnFinish(true)
end