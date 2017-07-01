module("LogFileUtils",package.seeall)

local LogFileList = {};

--[[--
--获取文件列表
--]]
function loadFileList(path)
	local lfs = require("lfs"); --载入lfs
	-- 定义一个目录迭代器
	for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local filePath = path.."/"..file
            --Common.log("fileName ====== "..file);
            --Common.log("filePath ====== "..filePath);
            local attr = lfs.attributes(filePath)
            assert(type(attr) == "table")
            if attr.mode == "directory" then
                loadFileList(filePath)
            else
                local length = lengthOfFile(filePath);
                if length > 0 then
                    local fileInfo = {};
                    fileInfo.name = file;
                    fileInfo.path = filePath;
                    fileInfo.length = length;
                    table.insert(LogFileList, fileInfo);
                end
            end
        end
	end
end

--[[--
--获取文件长度
--]]
function lengthOfFile(path)
	local fh = assert(io.open(path, "rb"))
	local len = assert(fh:seek("end"))
	fh:close()
	return len
end

--[[--
--获取文件数据
--]]
function readFile(path)
	--Common.log("path ================ "..path);
	local file = io.open(path, "rb")
	local text = file:read("*a")
	--log("text ================ "..text);
	file:close()
	return text;
end

--[[--
--删除文件
--]]
function deleteFile(path)
	os.remove(path)
end

--[[--
--获取log文件列表(只读取有数据的文件)
--]]
function LoadLogFileList()
	LogFileList = {};
	if Common.platform == Common.TargetIos then
		loadFileList(Common.getIOSDocumentDirectoryPath("LuaLog/" .. Load.APP_NAME));
	elseif Common.platform == Common.TargetAndroid then
		loadFileList(Common.getTrendsSaveFilePath("LuaLog/" .. Load.APP_NAME));
	end
	Common.log("LogFileList =========== size == "..#LogFileList)
	while #LogFileList > 50 do
		table.remove(LogFileList, 1);
	end
	Common.log("LogFileList =========== remove size == "..#LogFileList)
	--	for i = 1, #LogFileList do
	--		Common.log("LogFileList["..i.."].name === " .. LogFileList[i].name);
	--		Common.log("LogFileList["..i.."].path === " .. LogFileList[i].path);
	--		Common.log("LogFileList["..i.."].length === " .. LogFileList[i].length);
	--	local length = lengthOfFile(path);
	--	Common.log("length ================ ".. length);
	--	Common.log("length ================ ".. length/1024 .."k");
	--	if length == 0 then
	--		deleteFile(path)
	--		return;
	--	end
	--	end

	return LogFileList;
end
