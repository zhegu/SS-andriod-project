module("HallRedPointManager",package.seeall)

local HallRedPointLayoutTable = {}--大厅各模块控件Table
local HallRedPointTable = {}--添加到大厅控件上的红点控件table

--[[--任务--]]
function setTaskBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.ACHIEVEMENTTASK.."_"..profile.HongDian.DAILYTASK] = btn
	end
end

--[[--月卡--]]
function setMonthCardBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.MONTHCARD] = btn
	end
end

--[[--个人信息--]]
function setUserInfoBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.WECHATBIND.."_"..profile.HongDian.PHONEBIND] = btn
	end
end

--[[--排行榜--]]
function setPaiHangBangBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.CHARMRANK.."_"..profile.HongDian.COINRANK.."_"..profile.HongDian.RECHARGERANK.."_"..profile.HongDian.EARNRANK.."_"..profile.HongDian.ARENARANK] = btn
	end
end






--[[--充值--]]
function setRechargeBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.RECHARGEDOUBLE] = btn
	end
end

--[[--活动--]]
function setHuoDongBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.HUODONG] = btn
	end
end


--[[--好友--]]
function setFriendBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.FRIENDUNREAD.."_"..profile.HongDian.FRIENDTRACK.."_"..profile.HongDian.PAIHANGBANG] = btn
	end
end

----[[--财神--]]
--function setCaiShenBtn(btn)
--	if btn ~= nil then
--		HallRedPointLayoutTable[profile.HongDian.CAISHEN] = btn
--	end
--end

--[[--竞技场--]]
function setArenaBtn(btn)
	if btn ~= nil then
		HallRedPointLayoutTable[profile.HongDian.ARENA] = btn
	end
end


--[[--
--添加大厅红点
--@param #var layout 需要添加小红点的控件(父控件)
--@param #string name 按钮名称
--@param #int posX 按钮控件X坐标
--@param #int posY 按钮控件Y坐标
--]]
local function showHallRedPoint(layout, name, image, posX, posY)
	Common.log("showHallRedPoint name == "..name)
	if HallRedPointTable[name] ~= nil then
		Common.log("添加大厅红点======================no nil")
		return
	end
	local size = layout:getContentSize();
	posX = size.width*0.35;
	posY = size.height*0.4
	if name == (profile.HongDian.WECHATBIND.."_"..profile.HongDian.PHONEBIND) then
		posX = 35
		posY = 30
	end
	local HallRedPoint = UIImageView:create()
	if image == nil or image == "" then
		HallRedPoint:loadTexture(Common.getResourcePath("gift_tan_hao.png"))
	else
		HallRedPoint:loadTexture(Common.getResourcePath(image))
	end
	HallRedPoint:setPosition(ccp(posX, posY));
	HallRedPointTable[name] = HallRedPoint
	layout:addChild(HallRedPoint)
	Common.log("showHallRedPoint posX == "..posX)
	Common.log("showHallRedPoint posY == "..posY)
end


--[[--
--显示大厅红点
--@param #var layoutTable 大厅需要添加红点的控件
--]]
function showHallRedPointWithLayout()
	local HallShowRedPointTable = profile.HongDian.getHallShowRedPointTable()
	for layoutId, HongDianItem in pairs(HallShowRedPointTable) do
--		Common.log("showHallRedPointWithLayout layoutId == "..layoutId)
		if HallRedPointLayoutTable[layoutId] ~= nil then
--			Common.log("showHallRedPointWithLayout not nil == ")
			showHallRedPoint(HallRedPointLayoutTable[layoutId], ""..layoutId, "", 25, 30)
		end
	end
end

--[[--
--删除大厅红点(用于二级界面子节点红点消除后及时删除大厅红点，例如福利内红点消除后刷新大厅红点)
--]]
function removeHallRedPoint()
	if GameConfig.getTheCurrentBaseLayer() ~= GUI_HALL then
		return;
	end
	local HallRemoveRedPointTable = profile.HongDian.getHallRemoveRedPointTable()
	for layoutId, isRemove in pairs(HallRemoveRedPointTable) do
		if isRemove == 0 then
			if HallRedPointTable[layoutId] ~= nil then
				HallRedPointLayoutTable[layoutId]:removeChild(HallRedPointTable[layoutId])
				HallRedPointTable[layoutId] = nil
			end
		end
	end
end

--删除大厅所有红点
function deleteAllHallRedPoint()
	HallRedPointLayoutTable = {}
	HallRedPointTable = {}
end

