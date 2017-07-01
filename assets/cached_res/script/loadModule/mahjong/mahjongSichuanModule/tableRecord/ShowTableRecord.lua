module("ShowTableRecord", package.seeall)

local lookTimer = nil --时间计时器

local duration = 0 --总时长

local timer = 0 --计时器

local TIME_LENGTH = 0.4 --间隔时间

local RecordTimerIndex = 0; --当前的动作序列指针

local Pause = false; --录像是否暂停

local timeNodes = {}; --时间节点

local TableRecordCards = {};

function addTableRecordCards(RecordHandCards, RecordPutDownCards, RecordTakeOutCards)
	if TableRecordCards[RecordTimerIndex] ~= nil then
		return;
    end
    Common.log("addTableRecordCards RecordTimerIndex ======== "..RecordTimerIndex);
	TableRecordCards[RecordTimerIndex] = {};
	TableRecordCards[RecordTimerIndex].RecordHandCards = {};
	TableRecordCards[RecordTimerIndex].RecordPutDownCards = {};
	TableRecordCards[RecordTimerIndex].RecordTakeOutCards = {};
	--手牌数据
	if RecordHandCards ~= nil then
		for pos, cardList in pairs(RecordHandCards) do
			--Common.log("pos ============= " .. pos);
			TableRecordCards[RecordTimerIndex].RecordHandCards[pos] = {}; --按位置存放手牌数据
			for i, card in pairs(cardList) do
				TableRecordCards[RecordTimerIndex].RecordHandCards[pos][i] = {};
				TableRecordCards[RecordTimerIndex].RecordHandCards[pos][i].cardValue = card.m_nValue;
				TableRecordCards[RecordTimerIndex].RecordHandCards[pos][i].cardFace = card.m_nFaceState;
			end
		end
	end

	--放下的牌
	if RecordPutDownCards ~= nil then
		for pos, PutDownCards in pairs(RecordPutDownCards) do
			Common.log("pos ============= " .. pos);
			TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos] = {}; --按位置存放放下牌数据
			for i, cardList in pairs(PutDownCards) do
				TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos][i] = {}; --每个位置存放放下牌数据
				for j, card in pairs(cardList) do
					TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos][i][j] = {}; --每组放下牌的数据
					TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos][i][j].cardValue = card.m_nValue;
					TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos][i][j].cardFace = card.m_nFaceState;
					TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos][i][j].cardType = card.m_nCardType;
					TableRecordCards[RecordTimerIndex].RecordPutDownCards[pos][i][j].FromSeatID = card.m_nFromSeatID;
				end
			end
		end
	end

	--打出去的牌
	if RecordTakeOutCards ~= nil then
		for pos, cardList in pairs(RecordTakeOutCards) do
			--Common.log("pos ============= " .. pos);
			TableRecordCards[RecordTimerIndex].RecordTakeOutCards[pos] = {}; --按位置存放手牌数据
			for i, card in pairs(cardList) do
				TableRecordCards[RecordTimerIndex].RecordTakeOutCards[pos][i] = {};
				TableRecordCards[RecordTimerIndex].RecordTakeOutCards[pos][i].cardValue = card.m_nValue;
				TableRecordCards[RecordTimerIndex].RecordTakeOutCards[pos][i].cardFace = card.m_nFaceState;
			end
		end
	end
end

--[[--
--获取计时器时间
--]]
function getRecordTimer()
	return timer;
end

function showNextAction()
	if RecordTimerIndex < #RecordConfig.RecordInfo.actions then
		RecordTimerIndex = RecordTimerIndex + 1;
        Common.log("showNextAction RecordTimerIndex ======== "..RecordTimerIndex);
		setRecordPause();
		MahjongTableRecordButtonLayer.setRecordPauseOrResume();

		local nextTimestamp = RecordConfig.RecordInfo.actions[RecordTimerIndex].actionNo;
		timer = nextTimestamp;
		local messageName = RecordConfig.RecordInfo.actions[RecordTimerIndex].messageName;
		local actionData = RecordConfig.RecordInfo.actions[RecordTimerIndex].actionData;
		showTableRecordAction(messageName, actionData);
	else
		Common.log("showNextAction =====Max===== " .. RecordTimerIndex);
	end
end

function showLastAction()
	if RecordTimerIndex > 1 then

		RecordTimerIndex = RecordTimerIndex - 1;

        Common.log("showLastAction RecordTimerIndex ======== "..RecordTimerIndex);

		setRecordPause();
		MahjongTableRecordButtonLayer.setRecordPauseOrResume();

		local lastTimestamp = RecordConfig.RecordInfo.actions[RecordTimerIndex].actionNo;
		timer = lastTimestamp;

		if mvcEngine.logicModuleIsShow(GUI_MAHJONGGAMERESULT) then
			--关闭结算界面
			mvcEngine.destroyModule(GUI_MAHJONGGAMERESULT);
        end

        MahjongTableLogic.setImageZiVisible(true);
		MahjongTableCardLayer.removeAllCards();
		MahjongTableElementLayer.resetTableElement();

		MahjongTableCardLayer.regainRecordHandCards(TableRecordCards[RecordTimerIndex].RecordHandCards);
		MahjongTableCardLayer.regainRecordTakeOutCards(TableRecordCards[RecordTimerIndex].RecordTakeOutCards);
		MahjongTableCardLayer.regainRecordPutDownCards(TableRecordCards[RecordTimerIndex].RecordPutDownCards);
	else
		Common.log("showLastAction ========== " .. RecordTimerIndex);
	end
end

--[[--
--获取下一动作
--]]
local function getNextAction()
	--Common.log("RecordTimerIndex ============= "..RecordTimerIndex)
	--Common.log("#RecordConfig.RecordInfo.actions ============= "..#RecordConfig.RecordInfo.actions)
	if RecordTimerIndex < #RecordConfig.RecordInfo.actions then
		local timestamp = RecordConfig.RecordInfo.actions[RecordTimerIndex + 1].actionNo;
		--Common.log("timestamp ============== "..timestamp)
		if timestamp <= timer then
			--到达动作时间
			RecordTimerIndex = RecordTimerIndex + 1;
			local messageName = RecordConfig.RecordInfo.actions[RecordTimerIndex].messageName;
			local actionData = RecordConfig.RecordInfo.actions[RecordTimerIndex].actionData;
			return messageName, actionData;
		end
	end
	return nil, nil;
end

--[[--
--录像暂停
--]]
function setRecordPause()
	Pause = true;
end

--[[--
--录像继续
--]]
function setRecordResume()
	Pause = false;
end

--[[--
--获取录像是否暂停
--]]
function getRecordIsPause()
	return Pause;
end

--[[--
--处理牌桌记录逻辑
--]]
local function logicTableRecord()

	if getSocketIsPause() then
		Common.log("牌桌记录 ============== 消息暂停 == 延时")
		return;
	end

	if Pause then
		Common.log("牌桌记录 ============== 暂停")
		return;
	end

	local messageName, ActionData = getNextAction();

	timer = timer + TIME_LENGTH;
	--Common.log("播放牌桌记录 timer ============= "..timer);

	showTableRecordAction(messageName, ActionData);
end

function showTableRecordAction(messageName, ActionData)
	if messageName == nil or ActionData == nil then
		return;
	end
	Common.log("messageName ========= " .. messageName);

	if messageName == "MJ_SC_GAME_SYNC_TABLE" then
		--同步牌桌数据
		MahjongTableRecordConsole.readMJ_SC_GAME_SYNC_TABLE(ActionData);
	elseif messageName == "MJ_SC_GAME_DISCARD" then
		--推送出牌
		MahjongTableRecordConsole.readMJ_SC_GAME_DISCARD(ActionData);
	elseif messageName == "MJ_SC_GAME_DEAL_CARD" then
		--推送摸牌
		MahjongTableRecordConsole.readMJ_SC_GAME_DEAL_CARD(ActionData);
	elseif messageName == "MJ_SC_GAME_ACTION_BROADCAST" then
		--广播操作结果
		MahjongTableRecordConsole.readMJ_SC_GAME_ACTION_BROADCAST(ActionData);
	elseif messageName == "MJ_SC_GAME_HU_RESULT_BROADCAST" then
		--广播胡牌结果
		MahjongTableRecordConsole.readMJ_SC_GAME_HU_RESULT_BROADCAST(ActionData);
	elseif messageName == "MJ_SC_GAME_GAME_RESULT" then
		--解析游戏结果
		MahjongTableRecordConsole.readMJ_SC_GAME_GAME_RESULT(ActionData);
	end

	addTableRecordCards(MahjongTableCardLayer.getTableHandCards(), MahjongTableCardLayer.getTablePutDownCards(), MahjongTableCardLayer.getTableTakeOutCards());
end

--[[--
--播放牌桌记录
--]]
function playTableRecord(RecordInfoName)

	RecordConfig.resetRecordInfo();

	local isloaded = RecordConfig.loadRecordInfo(RecordInfoName);
	if not isloaded then
		--读取数据失败
		Common.showToast("读取数据失败~~", 2);
		return;
	end

	if lookTimer == nil then
		--定时器
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(logicTableRecord, TIME_LENGTH, false);
	end
end

--[[--
--停止牌桌记录
--]]
function stopTableRecord()
	Common.log("停止牌桌记录 ====================== ")
	if lookTimer ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer)
		lookTimer = nil
	end
	duration = 0 --总时长
	timer = 0 --计时器
	RecordTimerIndex = 0; --当前的动作序列指针
	Pause = false; --录像是否暂停
	timeNodes = {}; --时间节点
	TableRecordCards = {};
end