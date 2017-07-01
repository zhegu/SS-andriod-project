module("CommUploadConfig",package.seeall)

iosExceptionFileName = "iosExceptionFile"-- ios异常信息储存路径

local lookTimer = nil --定时器

--[[--
--上传上一次退出前保存下来的错误信息
--如果没有错误信息,则不传
--如果有错误信息,每条之间间隔1秒发送
--不需要服务器应答
--]]
function sendException()
	if not ServerConfig.getEnableUploadLuaEx() then
		return;
	end
	local iosExceptionTable = Common.LoadShareTable(iosExceptionFileName)
	--如果本地存有错误信息
	local function send()
		--发送错误信息方法
		if iosExceptionTable ~= nil and #iosExceptionTable > 0 then
			local dataTable = {}
			dataTable["userId"] = profile.User.getSelfUserID()
			dataTable["exceptionInfo"] = iosExceptionTable[1]
			if dataTable["exceptionInfo"] == nil then
				return
			end
			sendSTATID_COMMIT_EXCEPTION_INFO(dataTable)
			table.remove(iosExceptionTable, 1)
		else
			iosExceptionTable = {};
			--如果已经全部传完,将本地错误数据清空,并且将定时器停止
			Common.SaveShareTable(iosExceptionFileName, iosExceptionTable)
			if lookTimer ~= nil then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(lookTimer);
				lookTimer = nil;
			end
		end
	end
	if lookTimer == nil then
		--设置定时器,每1秒钟发送一次上传错误信息请求
		lookTimer = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(send, 1 ,false)
	end
end
