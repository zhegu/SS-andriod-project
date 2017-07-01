module(..., package.seeall)


local UserTable = {} --个人信息

--设置自己的userid
function setUserID(UserId)
	if UserId ~= nil then
		UserTable["UserID"] = UserId
	end
end
--获取自己的userid
function getUserID()
	if UserTable["UserID"] ~= nil then
		return UserTable["UserID"]
	else
		return nil
	end
end

--设置自己的NickName
function setNickName(NickName)
	if NickName ~= nil then
		UserTable["NickName"] = NickName
	end
end
--获取自己的NickName
function getNickName()
	if UserTable["NickName"] ~= nil then
		return UserTable["NickName"]
	else
		return ""
	end
end

--设置自己的头像地址
function setPhotoUrl(PhotoUrl)
	if PhotoUrl ~= nil then
		UserTable["PhotoUrl"] = PhotoUrl
	end
end
--获取自己的PhotoUrl
function getPhotoUrl()
	if UserTable["PhotoUrl"] ~= nil then
		return UserTable["PhotoUrl"]
	else
		return ""
	end
end

--设置自己的房卡数量
function setCardNum(CardNum)
	if PhotoUrl ~= nil then
		UserTable["CardNum"] = CardNum
	end
end
--获取自己房卡数量
function getCardNum()
	if UserTable["CardNum"] ~= nil then
		return UserTable["CardNum"]
	else
		return 0
	end
end

local function readMAHJONG_LOGIN(dataTable)
	Common.log("接收个人信息 =======readMAHJONG_LOGIN======= ")
	
	if dataTable ~= nil and next(dataTable) ~= 0 and dataTable.Result == 0 then
		--UserID	int	用户ID
		UserTable["UserID"] = dataTable.UserID
		--NickName	text	昵称
		UserTable["NickName"] = dataTable.NickName
		--PhotoUrl	text	头像URL
		UserTable["PhotoUrl"] = dataTable.PhotoUrl
		--CardNum	long	房卡数量	
		UserTable["CardNum"] = dataTable.CardNum
	end
	
	framework.emit(MAHJONG_LOGIN)
end

function getUserInfo()
	return UserTable;
end

registerMessage(MAHJONG_LOGIN, readMAHJONG_LOGIN)
