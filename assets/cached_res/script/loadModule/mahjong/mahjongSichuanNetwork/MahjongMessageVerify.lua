module("MahjongMessageVerify", package.seeall)

local gameTimeStamp = 0;--用户加入牌局的时间戳（每新开一局，时间戳更新为牌局开局时间戳）

function getGameTimeStamp()
	return gameTimeStamp;
end

function setGameTimeStamp(timeStamp)
	gameTimeStamp = timeStamp;
end

--[[--
--消息是否合法
--]]
function messageIsLegal(timeStamp, messageName)
	if tonumber(timeStamp) > gameTimeStamp then
		Common.log("本地时间戳 setGameTimeStamp == "..gameTimeStamp);
		Common.log(messageName .. "修改本地时间戳 setGameTimeStamp == "..timeStamp);
		setGameTimeStamp(tonumber(timeStamp));
		return true;
	elseif tonumber(timeStamp) == gameTimeStamp then
		return true
	else
		Common.log("本地时间戳 gameTimeStamp == "..gameTimeStamp);
		Common.log(messageName .. " 时间戳不合法 timeStamp == "..timeStamp);
		return false;
	end
end

function clearGameTimeStamp()
	gameTimeStamp = 0;
end