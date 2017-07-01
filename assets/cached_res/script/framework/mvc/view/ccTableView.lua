--自定义的TableView，继承于CCScrollView
module("ccTableView",package.seeall)

--以下是开发者必须实现的方法
--tableView.initTableViewData()--初始化数据
--tableView.numberOfrow()--返回行数
--tableView.HeightOfCellAtNumberOfRow(i)--返回每行的高度,i:当前行数
--tableView.getCellWidth()--返回每个cell的宽度
--tableView.CellOfAtNumberOfRow(cell,i)--对cell进行布置
--tableView.getTableViewInfo()--获取TableView的配置信息

--此外：tableView:setDirection(kCCScrollViewDirectionHorizontal)设置滚动放向,默认是竖直方向
--设置分割线: tableView.SeparatorWidth = 2
--设置弹性:tableView:setBounceable(true)

------tableView构造函数---------
function create(scrollSize, Direction)
	local tableView = CCScrollView:create(scrollSize)
	tableView.SeparatorWidth = 2
	tableView.SeparatorHeight = 2
	tableView:ignoreAnchorPointForPosition(false)
	tableView:setBounceable(true)
	tableView:setDirection(Direction)
	tableView:setTouchPriority(-9999)
	tableView.isMoved = false;
	return tableView
end

function reloadData(tableView)

	local rowHeight = 40
	local cellWidth = 40
	local numberOfrow = 0
	local tableViewSize = tableView:boundingBox().size

	tableView.initTableViewData()

	if(tableView.numberOfrow() > 0)then
		numberOfrow = tableView.numberOfrow()
	else
		return
	end
	local container = tableView:getChildren():objectAtIndex(0)
	tolua.cast(container,"CCLayer")
	container:removeAllChildrenWithCleanup(true)

	local TheLastCell = nil
	if(tableView:getDirection() == kCCScrollViewDirectionVertical)then
		local realTableViewH = tableView.SeparatorHeight;
		for i = 1,numberOfrow do
			rowHeight = tableView.HeightOfCellAtNumberOfRow(i)
			realTableViewH = realTableViewH + rowHeight + tableView.SeparatorHeight;
		end

		for i = 1,numberOfrow do
			rowHeight = tableView.HeightOfCellAtNumberOfRow(i)
			local cell = CCLayerColor:create(ccc4(0,0,0,0), tableViewSize.width, rowHeight)
			tableView.CellOfAtNumberOfRow(cell, i)
			if(TheLastCell ~= nil)then
				cell:setPosition(0, TheLastCell:getPositionY() + TheLastCell:getContentSize().height + tableView.SeparatorHeight)
			else
				if realTableViewH < tableViewSize.height then
					cell:setPosition(0, 0 + (tableViewSize.height - realTableViewH));
				else
					cell:setPosition(0, tableView.SeparatorHeight);
				end
			end

			tableView:addChild(cell);

			TheLastCell = cell;
		end

		if(realTableViewH > tableViewSize.height)then
			tableView:setContentSize(CCSize(tableViewSize.width, realTableViewH));
		else
			tableView:setContentSize(CCSize(tableViewSize.width, tableViewSize.height));
		end

		tableView:setContentOffset(ccp(0, -tableView:getContentSize().height + tableViewSize.height))
	else
		for i = 1,numberOfrow do
			cellWidth = tableView.getCellWidth()
			local cell = CCLayerColor:create(ccc4(0,0,0,0), cellWidth,tableViewSize.height)
			tableView.CellOfAtNumberOfRow(cell,i)
			if(TheLastCell ~= nil)then
				cell:setPosition(TheLastCell:getPositionX() + TheLastCell:getContentSize().width + tableView.SeparatorWidth, 0)
			else
				cell:setPosition(tableView.SeparatorWidth, 0)
			end
			tableView:addChild(cell)
			TheLastCell = cell
			if(TheLastCell:getPositionX() + TheLastCell:getContentSize().width + tableView.SeparatorWidth > tableViewSize.width) then
				tableView:setContentSize(CCSize(TheLastCell:getPositionX() + TheLastCell:getContentSize().width + tableView.SeparatorWidth, tableViewSize.height))
			else
				tableView:setContentSize(CCSize(tableViewSize.width, tableViewSize.height))
			end
		end
		tableView:setContentOffset(ccp(0,0))
	end

	local function jianceSpeed(senter)
		tableView.isMoved = tableView:isTouchMoved()
	end

	local array = CCArray:create()
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCCallFuncN:create(function ()
		tableView:stopAllActions()
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(0.1))
		array:addObject(CCCallFuncN:create(jianceSpeed))
		tableView:runAction(CCRepeatForever:create(CCSequence:create(array)))
	end))
	tableView:runAction(CCSequence:create(array))
end

--[[--
--生成点击监听矩形框
--@param #int currentColumn 当前列的index(只有一列时设置为1)
--@param #int currentRow 当前行的index(只有一行时设置为1)
--]]
local function createTouchRect(currentColumn, currentRow, cellWidth, cellHeight, currentTableView)
	local info = currentTableView.getTableViewInfo();
	--矩形框x坐标
	local rectX = 0;
	--矩形框y坐标
	local rectY = 0;

	rectX = (currentColumn - 1) * (cellWidth) + (currentColumn - 1) * info.spacingW;
	--矩形框y坐标(currentRow * 1这个是误差处理，多行时会出现误差)
	rectY = cellHeight * (info.rowSize - currentRow) - (currentRow - 1) * info.spacingH;
	--获得元素在tableview上的矩形位置

	touchRect = CCRect(rectX , rectY, cellWidth, cellHeight)

	return touchRect
end

--[[--
--世界坐标转换tableview本地坐标
--@param #int x 世界坐标x坐标
--@param #int y 世界坐标y坐标
--@param #int cellWidth 行宽
--@param #int cellHeight 行高
--@param #var currentTableView 当前tableview
--]]
local function theWorldConvertToLocalPosition(x, y, cellWidth, cellHeight, currentTableView)
	local info = currentTableView.getTableViewInfo();
	--转换成tableview的x坐标
	local converToTableViewX = 0
	--转换成tableview的y坐标
	local converToTableViewY = 0

	if x < info.TableView_X or y > info.TableView_Y + info.TableView_H or y < info.TableView_Y then
		Common.log("theWorldConvertToLocalPosition == -1")
		return -1, -1
	end

	--纵向：默认偏移量为负，显示的第一行实际是坐标的最后一行，需要根据真实高度和显示高度调整
	--恒向：默认偏移量为0，显示的第一列即是坐标的第一列，不需要根据真实高度和显示高度调整
	converToTableViewX = x - info.TableView_X - currentTableView:getContentOffset().x;

	if info.rowSize * cellHeight <= info.TableView_H then
		--当列表当元素不足以布满整个tableview可显示的窗口
		--此处是将触摸的y坐标的世界坐标转换成tableview的精灵坐标
		converToTableViewY = info.TableView_Y - y + info.TableView_H;
	else
		--将转换后的坐标结合tableview的偏移量算得偏移后的精灵坐标
		converToTableViewY = info.TableView_Y - y + info.rowSize * cellHeight + currentTableView:getContentOffset().y;
	end

	return converToTableViewX, converToTableViewY
end


--[[--
--TableView点击监听
--@param #int currentColumn 当前列的index(只有一列时设置为1)
--@param #int currentRow 当前行的index(只有一行时设置为1)
--@param #var itemParentNode 当前监听的元素
--@param #var currentTableView 当前tableview
--@param #var buttonCallBack 点击回调
--@param #var layerClick 触摸层
--]]
function initTableViewClickedListener(currentColumn, currentRow, itemParentNode, currentTableView, buttonCallBack, layerClick)
	local info = currentTableView.getTableViewInfo();
	local cellWidth = currentTableView.getCellWidth();
	local cellHeight = currentTableView.HeightOfCellAtNumberOfRow(currentRow);
	--获得元素在tableview上的矩形位置
	local touchRect = createTouchRect(currentColumn, currentRow, cellWidth, cellHeight, currentTableView)
	local beginX = 0;
	local beginY = 0;
	local function onTouchClick(eventType, x, y)
--		Common.log("initTableViewClickedListener x = "..x)
--		Common.log("initTableViewClickedListener y = "..y)
		if eventType == "began" then
			beginX = x;
			beginY = y;
			currentTableView.isMoved = false;
			--converToTableViewX:转换后的x坐标 , converToTableViewY:转换后的y坐标
			local converToTableViewX, converToTableViewY = theWorldConvertToLocalPosition(x, y, cellWidth, cellHeight, currentTableView);
			--如果转换后的坐标在元素的矩形范围内则触发操作
			if touchRect:containsPoint(ccp(converToTableViewX, converToTableViewY)) then
				--将元素进行点击效果处理
				GamePub.showTableViewMenuBtnPress(itemParentNode);
				return true
			end
		elseif eventType == "moved" then
			if math.abs(beginX - x) > 10 or math.abs(beginY - y) > 10 then
				currentTableView.isMoved = true;
			end
		elseif eventType == "ended" then
			GamePub.showTableViewMenuBtnUp(itemParentNode);
			if currentTableView.isMoved then
				currentTableView.isMoved = false;
				return;
			end
			--点击元素后的回调函数
			buttonCallBack()
		end
	end
	--激活点击层的触摸监听（不然layerClick将失效）（解决第一次点击失效的bug）
	layerClick:setTouchEnabled(true)
	--设置点击层的监听
	layerClick:registerScriptTouchHandler(onTouchClick)
	--使用步骤
	--创建点击层（将层添加到cell层上）（删除menu按钮）
	--初始化矩形位置（initTableViewClickedListener）
	--当弹出弹出框时屏蔽点击层触摸＊//
	--隐藏tableview时屏蔽点击层触摸＊
	--reload tableview 时移除点击层
end

--[[
--tableview touch监听
]]
function addTableViewTouchCallBack(parentView, currentTableView, x, y, width, height)
	local lastPosX = 0 --上一次X的坐标
	local offsetX = 0 --每一次滑动X的偏移量
	local movedToDirection = 0 --0：未移动 1：向左 2：向右 3：无效移动

    if touchLayer ~= nil then
        parentView:removeChild(touchLayer, true)
        touchLayer = nil
    end

	-- local touchLayer = CCLayerColor:create(ccc4(222, 111, 330, 440), width, height)
	touchLayer = CCLayerColor:create(ccc4(0, 0, 0, 0), width, height)
	local touchLayerPosX = x
	local touchLayerPosY = y
	touchLayer:setTouchEnabled(true)
	touchLayer:setTouchPriority(-100)
	touchLayer:setPosition(ccp(x, y))

	local function onTouch(eventType, x, y)
--		Common.log("onTouch eventType = "..eventType.." x = "..x)

		if eventType == "began" then
			local touchRect = CCRect(touchLayerPosX , touchLayerPosY, width, height)
			if touchRect:containsPoint(ccp(x, y)) == false then
				Common.log("addTableViewTouchCallBack onTouch 不在指定区域内")
				return false
			end

			lastPosX = x
			if currentTableView.ccTouchesBegan then
				return currentTableView.ccTouchesBegan()
			end

			return false
		elseif eventType == "moved" then

--			Common.log("lastPosX = "..lastPosX)

			if x < lastPosX then
				--to left
				movedToDirection = 1
			elseif x > lastPosX then
				--to right
				movedToDirection = 2
			else
				movedToDirection = 3
			end
			offsetX = x-lastPosX

			local isInvolidMoved = false

			if math.abs(offsetX) < currentTableView.getCellWidth(1)/2 then
				isInvolidMoved = true
			end

			if isInvolidMoved then
				movedToDirection = 3
			end

			if currentTableView.ccTouchesMoved then
				currentTableView.ccTouchesMoved(offsetX, x, y)
			end
		elseif eventType == "ended" then
			if currentTableView.ccTouchesEnded then
				currentTableView.ccTouchesEnded(offsetX, x, y, movedToDirection)
			end
			lastPosX = 0
			movedToDirection = 0
			offsetX = 0
		end
	end
	touchLayer:registerScriptTouchHandler(onTouch)

	parentView:addChild(touchLayer)
end

