module("RisenMsg",package.seeall)

local isFlyText = false;--是否正在显示飘字
local flyLabel = nil;--飘字label
local flyWords = {}--飘字

--[[--
--隐藏飘字
--]]
local function hideFlyText()
	if CCDirector:sharedDirector():getRunningScene() ~= nil then
		CCDirector:sharedDirector():getRunningScene():removeChild(flyLabel, true);
	end
	flyLabel = nil;
	isFlyText = false;
	showServerMsg();
end

--[[--
--显示飘字
--]]
function showServerMsg()
	if not isFlyText and flyWords ~= nil and #flyWords > 0 then
		isFlyText = true;
		local msg = flyWords[1];
		table.remove(flyWords, 1);
		msg = string.gsub(msg,"|","\n")
		msg = string.gsub(msg,"-","")
		flyLabel = FontStyle.CCLabelTTFAddStroke(nil, msg, "", 36, ccc3(255, 241, 127), ccc3(132, 60 ,8), 2)
		flyLabel = FontStyle.CCLabelTTFAddOutlineAndShadow(flyLabel, msg, "", 36, ccc3(255, 241, 127), ccc3(132, 60 ,8), 2, 4, 191)
		flyLabel:setPosition(ccp(GameConfig.ScreenWidth / 2, GameConfig.ScreenHeight / 4))
		flyLabel:setZOrder(100)
		--		JinHuaTableBarrageLayer:addChild(flyLabel);
		if CCDirector:sharedDirector():getRunningScene() ~= nil then
			CCDirector:sharedDirector():getRunningScene():addChild(flyLabel);
			local ccmove = CCMoveBy:create(3,ccp(0, GameConfig.ScreenHeight / 2))
			local arr = CCArray:create()
			arr:addObject(ccmove)
			arr:addObject(CCCallFuncN:create(hideFlyText))
			local seq = CCSequence:create(arr)
			flyLabel:runAction(seq)
		end

	end
end

--[[--
--添加飘字
--]]
function addServerMsg(ServerMsg)
	table.insert(flyWords, ServerMsg);
	showServerMsg();
end