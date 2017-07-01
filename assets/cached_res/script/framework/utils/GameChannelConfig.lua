module("GameChannelConfig",package.seeall)

--[[--
--获取根目录下logo图片
--]]
function getLogoUrl()
	local filePath = "package_logo.png"
	if Load.isFilePathExist(filePath) then
		return filePath;
	end
	return nil
end

--[[--
--是否是AppStore渠道
--]]
function isAppStoreChannelID()
	if Common.platform == Common.TargetIos then
		return true
	end
	return false;
end


--[[--
--获取是不是联运版本
--@return #bool
--]]
function getChannelIsLianYun()
    --0:主版本; 1:联运版
    local strIsLianYun = "0";
    --脚本配置信息文件：包内目录在根目录,包外在cached_res文件夹下
    local filePath = ""
    if Load.logicScriptInSD() then
        filePath = Load.getScriptDirectory();
    else
        filePath = "";
        if Common.platform == Common.TargetAndroid then
            strIsLianYun = Load.getScriptDataFromAssets("IsLianYun");
            if strIsLianYun == "1" then
                --是联运版本
                Common.log("此版本是联运版 ============== ");
                return true;
            else
                Common.log("此版本是主版本 ============== ");
                return false;
            end
        end
    end

    local scriptConfig = Load.getJsonData(filePath, "scriptConfig.json");
    if scriptConfig ~= nil then
        Common.log("scriptConfig.IsLianYun ==== "..scriptConfig.IsLianYun)
        strIsLianYun = scriptConfig.IsLianYun;
    else
        strIsLianYun = "0";
    end

    if strIsLianYun == "1" then
        --是联运版本
        Common.log("此版本是联运版 ============== ");
        return true;
    else
        Common.log("此版本是主版本 ============== ");
        return false;
    end
end

function getVersionName()

end