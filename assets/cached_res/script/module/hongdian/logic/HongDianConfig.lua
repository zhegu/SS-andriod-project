module("HongDianConfig",package.seeall)

-------------------- 新版红点系统 --------------------

local parentLayoutWithParentIdTable = {} --保存父节点id对应的layout（按钮标签）
local childRedPointSpriteTable = {} --子节点红点控件table（列表）
local SPRITETAG = 90001 --红点的tag

COMMONCHILDID = 1 --非列表红点通用ID为1＊＊＊
IMAGEVIEWTYPE = 1 --红点是ImageView类型
CCSPRITETYPE = 2 --红点是CCSprite类型


--[[--
--初始化红点控件table
--]]
local function initRedPointBaseTable()
	local HongDian_datatable = profile.HongDian.getMANAGERID_REQUEST_REDP_HongDian_Table()
	if HongDian_datatable ~= nil then
		for key, var in pairs(HongDian_datatable) do
			childRedPointSpriteTable[key] = {}
			parentLayoutWithParentIdTable[key] = {}
		end
	end
end

--[[--
--初始化红点基本信息
--]]
function initAllRedPointBaseInfo()
	--初始化子节点红点控件table
	initRedPointBaseTable()
end

--[[--
--以ImageView的方式创建红点
--@param #var image 红点图片
--@param #number posX 红点X坐标
--@param #number posY 红点Y坐标
--]]
local function createRedPointByImageView(image, posX, posY, scale)
	local redPoint = nil
	local redPointImage = nil
	--如果图片为空默认为小红点，否则自定义红点图片
	if image ~= "" then
		redPointImage = image
	else
		redPointImage = "gift_tan_hao.png"
	end
	redPoint = UIImageView:create()
	redPoint:loadTexture(Common.getResourcePath(redPointImage))
	if redPoint ~= nil then
		redPoint:setPosition(ccp(posX, posY))
		redPoint:setTag(SPRITETAG)
		redPoint:setZOrder(10)
		if scale ~= nil and scale ~= "" then
			redPoint:setScale(scale)
		end
	end
	return redPoint
end

--[[--
--以CCSprite的方式创建红点
--@param #var image 红点图片
--@param #number posX 红点X坐标
--@param #number posY 红点Y坐标
--]]
local function createRedPointBySprite(image, posX, posY, scale)
	local redPoint = nil
	local redPointImage = nil
	--如果图片为空默认为小红点，否则自定义红点图片
	if image ~= "" then
		redPointImage = image
	else
		redPointImage = "gift_tan_hao.png"
	end
	redPoint = CCSprite:create(Common.getResourcePath(redPointImage))
	if redPoint ~= nil then
		redPoint:setPosition(ccp(posX, posY))
		redPoint:setTag(SPRITETAG)
		redPoint:setZOrder(10)
		if scale ~= nil and scale ~= "" then
			redPoint:setScale(scale)
		end
	end

	return redPoint
end

--[[--
--删除红点
--]]
local function deleteRedPointFromLayout(layout, redPointType)
	if layout == nil or layout == "" then
		return
	end
	--这一行
	local redPoint = layout:getChildByTag(SPRITETAG)

	if redPoint == nil or redPoint == "" then
		return
	end
	if redPointType == IMAGEVIEWTYPE then
		Common.log("删除红点deleteRedPointFromLayout ============ redPoint")
		layout:removeChild(redPoint)
	elseif redPointType == CCSPRITETYPE then
		--使用tolua.cast进行强转,否则无法识别
		tolua.cast(redPoint, "CCSprite")
		layout:removeChild(redPoint, true)
	else
	--其他类型的控件请自行添加
	end
end


--[[--
--刷新父节点红点
--@param #String parentId 红点父节点ID
--]]
local function removeParentRedPoint(parentId)
	--刷新一级父节点layoutTable
	if parentLayoutWithParentIdTable[parentId] == nil or next(parentLayoutWithParentIdTable[parentId]) == nil then
		return
	end
	local RedPointTableByParentId = profile.HongDian.getChildRedPointTableByParentID(parentId);
	if RedPointTableByParentId == nil or next(RedPointTableByParentId) == nil then
		for key, parentLayout in pairs(parentLayoutWithParentIdTable[parentId]) do
			--获得父节点红点所在ui
			local layout = parentLayout.layout
			--获得父节点红点类型
			local redPointType = parentLayout.redPointType
			--删除红点ui
			deleteRedPointFromLayout(layout, redPointType)
		end

		profile.HongDian.removeParentRedPointDataByPointId(parentId)

		parentLayoutWithParentIdTable[parentId] = {}
	end
end

--[[--
--添加父节点红点到指定控件
--@param #var image 红点图片
--@param #var layout 添加红点的控件
--@param #var redPointType 红点类型 1:imageView 2:Sprite
--@param #String parentId 红点父节点ID
--@param #number posX X坐标
--@param #number posY Y坐标
--]]
function showRedPointToParentUI(image, layout, redPointType, parentId, posX, posY)
	local redPoint = nil
	Common.log("showRedPointToParentUI   parentId = " .. parentId)
	if parentLayoutWithParentIdTable[parentId] == nil then
		return
	end
	if profile.HongDian.getIsHaveRedForModuleId(parentId) then
		--创建红点
		if redPointType == IMAGEVIEWTYPE then
			--imageview方式
			redPoint = createRedPointByImageView(image, posX, posY)
		elseif redPointType == CCSPRITETYPE then
			--ccsprite方式
			redPoint = createRedPointBySprite(image, posX, posY)
		else
		--其他方式红点自行添加
		end
		if redPoint ~= nil then
			for i = 1, #parentLayoutWithParentIdTable[parentId] do
				if(layout == parentLayoutWithParentIdTable[parentId][i].layout) then
					return
				end
			end
			layout:addChild(redPoint)
			local layoutTable = {
				["layout"] = layout,
				["redPointType"] = redPointType,
			}
			if next(parentLayoutWithParentIdTable[parentId]) == nil then
				Common.log("showRedPointToParentUI   parentLayoutWithParentIdTable next = nil")
				parentLayoutWithParentIdTable[parentId] = {layoutTable};
			else
				table.insert(parentLayoutWithParentIdTable[parentId], layoutTable)
				Common.log("showRedPointToParentUI   parentLayoutWithParentIdTable insert = success")
			end
		end
	end
end

--[[--
--移除界面红点控件数据
--@param #num parentId 红点父节点ID
--]]
function removeRedPointToParentUI(parentId)
	parentLayoutWithParentIdTable[parentId] = {}
end


--[[--
--添加子节点红点到指定控件(比如：商城列表)
--@param #var image 红点图片
--@param #var layout 添加红点的控件
--@param #var redPointType 红点类型 1:imageView 2:Sprite
--@param #number parentId 红点父节点ID
--@param #number redPointId 红点ID
--@param #number posX X坐标
--@param #number posY Y坐标
--]]
function showRedPointToChildUI(image, layout, redPointType, parentId, redPointId, posX, posY, scale)
	local RedPointTableByParentId = profile.HongDian.getChildRedPointTableByParentID(parentId);
	local redPointWidget = nil
	if RedPointTableByParentId ~= nil then
		for i = 1, #RedPointTableByParentId do
			if tonumber(redPointId) == tonumber(RedPointTableByParentId[i]) then
				--创建红点
				if redPointType == IMAGEVIEWTYPE then
					--imageview方式
					redPointWidget = createRedPointByImageView(image, posX, posY, scale)
				elseif redPointType == CCSPRITETYPE then
					--ccsprite方式
					redPointWidget = createRedPointBySprite(image, posX, posY, scale)
				else
				--其他方式红点自行添加
				end

				if redPointWidget ~= nil then
					--如果控件上已经有标记为90001的红点或是其他控件，则不添加红点
					if layout:getChildByTag(SPRITETAG) == nil or layout:getChildByTag(SPRITETAG) == "" then
						layout:addChild(redPointWidget)
						if childRedPointSpriteTable[parentId] ~= nil then
							childRedPointSpriteTable[parentId][redPointId] = redPointWidget
						end
					end
				end
			end
		end
	end
end

--[[--
--删除子节点红点
--@param #var layout 红点所在控件
--@param #String parentId 红点父节点ID
--@param #number redPointId 红点子节点id,在点击就消除红点的模块中，redPointId传默认值 1
--@param #number redPointType 红点类型 1:imageView 2:CCSprite
--]]
function removeChildRedPoint(layout, parentId, redPointId, redPointType)
	Common.log("删除子节点红点 parentId =============== " .. parentId);
	Common.log("删除子节点红点 redPointId ============= " .. redPointId);

	--删除本地红点数据
	profile.HongDian.removeChildRedPointDataByPointId(parentId, redPointId);

	--删除红点控件
	deleteRedPointFromLayout(layout, redPointType);

	--删除子节点后刷新一遍父节点
	removeParentRedPoint(parentId);

	--发送删除红点消息
	sendMANAGERID_REMOVE_REDP(tonumber(parentId), redPointId);

end

--[[--
--设置红点的显示与隐藏
--@param #var layout 添加红点的控件
--@param #var redPointType 红点类型 1:imageView 2:Sprite
--@param #bool status 红点显示与否
--]]
function setChildRedPointDisplay(layout, redPointType, status)
	local redPoint = layout:getChildByTag(SPRITETAG)
	if redPoint == nil or redPoint == "" then
		return
	end
	if redPointType == IMAGEVIEWTYPE then

	elseif redPointType == CCSPRITETYPE then
		--使用tolua.cast进行强转,否则无法识别
		tolua.cast(redPoint, "CCSprite")
	else
	--其他类型的控件请自行添加
	end
	redPoint:setVisible(status)
end

--[[--
--删除不在列表中的红点（解决老版本和新版本登陆红点数据不对应的bug）
--功能待定
--]]
function deleteRedPointIsNoteExit(parentId, listIDTable)
	local childIdTable = profile.HongDian.getChildRedPointTableByParentID(parentId);
	if childIdTable ~= nil then
		for childKey, childId in pairs(childIdTable) do
			local removeID = childId
			for listKey, listID in pairs(listIDTable) do
				--如果相等则存在该红点
				if tonumber(childId) == tonumber(listID) then
					removeID = nil;
				end
			end
			--如果列表中没有该红点
			if removeID ~= nil then
				Common.log("删除不在列表中的红点 removeID ========= " .. removeID)
				--发送删除红点消息
				sendMANAGERID_REMOVE_REDP(parentId, tonumber(removeID))
				--删除本地红点数据
				profile.HongDian.removeChildRedPointDataByPointId(parentId, removeID);
			end
		end

		--删除子节点后刷新一遍父节点
		removeParentRedPoint(parentId);

		--刷新大厅红点（即时消除红点）
		HallRedPointManager.removeHallRedPoint();
	end
end

--[[--
-- 判断控件上是否有红点
--]]--
function isHaveRedPointOnLayout(layout)
    local redPoint = layout:getChildByTag(SPRITETAG)
    if redPoint == nil or redPoint == "" then
        return false
    end
    return true
end

local function processMANAGERID_PUSH_REDP()
	Common.log("processMANAGERID_PUSH_REDP processMANAGERID_PUSH_REDP")
	sendMANAGERID_REQUEST_REDP(profile.HongDian.getRedPointConstant())
end

framework.addSlot2Signal(MANAGERID_PUSH_REDP, processMANAGERID_PUSH_REDP, true);
