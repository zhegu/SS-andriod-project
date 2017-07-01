module("EditBoxListener",package.seeall)

local oldStrFmt = "";
local FinishCallBack = {};
local ChangeCallBack = {};

local realEditBox = nil

function setRealEditBox(editBox)
	realEditBox = editBox
end

--[[--
--设置输入完毕后的回调方法(无回调方法则传nil)
--]]
function setEditBoxFinishCallBack(pSender, callback)
	if pSender == nil or callback == nil then
		return;
	end
	FinishCallBack[pSender] = callback;
end

function setEditBoxChangeCallBack(pSender, callback)
	if pSender == nil or callback == nil then
		return;
	end
	ChangeCallBack[pSender] = callback;
end

--[[--
--监听EditBox输入
--]]
function editBoxTextEventHandle(strEventName, pSender)
	--local edit = tolua.cast(pSender,"CCEditBox")
	local strFmt = pSender:getText();
	if strEventName == "began" then
		oldStrFmt = strFmt;
	elseif strEventName == "ended" then

	elseif strEventName == "changed" then
		if Common.logicEmoji(strFmt) then
			--有表情符
			pSender:setText(oldStrFmt);
			Common.log("initChatInputBox changed 有表情符");
			if Common.platform == Common.TargetAndroid then
				Common.showToast("亲，某些特殊表情或字符无法识别，请您重新输入", 2);
			end
		else
			oldStrFmt = strFmt;
		end
		if ChangeCallBack[pSender] ~= nil then
			ChangeCallBack[pSender]();
		end
		Common.log("initChatInputBox changed"..pSender:getText());
		if realEditBox then
			realEditBox:setText(pSender:getText())
		end
	elseif strEventName == "return" then
		Common.log("initChatInputBox return"..strFmt);
		oldStrFmt = "";
		if FinishCallBack[pSender] ~= nil then
			FinishCallBack[pSender]();
		end
	end
end
