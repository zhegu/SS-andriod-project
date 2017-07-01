module("EmailUtils",package.seeall)

local emailName = "tongquclient@163.com";
local emailPassword = "tongqu123";

--[[--
--发送邮件
--]]
function sendMessageByEmail(text, addressee)
	local smtp = Load.LuaRequire("script.framework.socket.smtp");

	local from = "<".. emailName ..">" -- 发件人

	-- 发送列表
	local rcpt = {
		"<".. addressee ..">",
	}

	local mesgt = {
		headers = {
			to = addressee, -- 收件人
			cc = '', -- 抄送
			subject = "This is Mail Title"
		},
		body = text
	}

	local r, e = smtp.send{
		server = "smtp.163.com",
		user = emailName,
		password = emailPassword,
		from = from,
		rcpt = rcpt,
		source = smtp.message(mesgt)
	}

	if not r then
		Common.log("邮件发送失败: "..e);
		Common.showToast(e, 2);
	else
		--Common.log("send ok! ================ ")
		Common.showToast("邮件已发送!", 2);
	end
end

--[[--
--发送带文本附件的邮件
--]]
function sendTXTAttachmentByEmail(logPath, fileName, addressee, isBug, UserName, LogInfo)
    Common.log("fileName ====== "..fileName);
    Common.log("logPath ====== "..logPath);
    Common.log("addressee ====== "..addressee);
	Common.log("UserName ====== "..UserName);
	Common.log("LogInfo ====== "..LogInfo);

	local smtp = Load.LuaRequire("script.framework.socket.smtp");
	local mime = Load.LuaRequire("script.framework.socket.mime");
	local ltn12 = Load.LuaRequire("script.framework.socket.ltn12");

	local from = "<".. emailName ..">" -- 发件人

	-- 发送列表
	local rcpt = {
		"<".. addressee ..">",
	}

	local CRLF = "\013\010";
	local platform = "";
	if Common.platform == Common.TargetIos then
		platform = "IOS";
	elseif Common.platform == Common.TargetAndroid then
		platform = "Android";
	end

	--local strEmulator = Common.isEmulator() and "模拟器" or "真机";

	local message = "发件人: ".. UserName ..
                    "\n游戏中遇到的问题: ".. LogInfo ..
                    "\n请查看附件中的日志文件: \n".. fileName .. (isBug and "  (有lua异常)" or "") ..
					"\n由 UserID: " .. profile.User.getSelfUserID() .. " NickName: " .. profile.User.getSelfNickName().." 发送."..
					"\n版本号: "..Common.getVersionName().."."..Common.getChannelID()..
					"\nImei: "..Common.getImei()..
					"\n手机型号: "..Common.getModel()..
					"\n系统型号: "..Common.getSystemVersion();

	local mesgt = {
		headers = {
			to = addressee,
			subject = platform.." "..Load.APP_NAME.." 日志文件: " .. fileName .. (isBug and "  (有lua异常)" or "")},
		body = {
			preamble = "请查看附件中的日志文件" .. CRLF,
			[1] = {
				body = message .. CRLF},
			[2] = {
				headers = {
					["content-type"] = "text/plain; name = " .. fileName,
					["content-disposition"] = "attachment; filename = " .. fileName,
					["content-description"] = fileName,
					["content-transfer-encoding"] = "BASE64"},
				body = ltn12.source.chain(
					ltn12.source.file(io.open(logPath, "rb")),
					ltn12.filter.chain(
						mime.encode("base64"),
						mime.wrap()))}}
	}

	local r, e = smtp.send{
		server = "smtp.163.com",
		user = emailName,
		password = emailPassword,
		from = from,
		rcpt = rcpt,
		source = smtp.message(mesgt)
	}

	if not r then
		Common.log("邮件发送失败: "..e);
		Common.showToast(e, 2);
	else
		--Common.log("send ok! ================ ")
		Common.showToast("邮件已发送!", 2);
	end
end