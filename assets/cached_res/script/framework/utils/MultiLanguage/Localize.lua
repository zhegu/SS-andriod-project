module("Localize", package.seeall)

function getLocalizeString(text, ...)
    local textParams = function(...)
        return ...
    end

    return string.format(text, textParams(...))
end

--根据系统语言，启动后重新分配客户端文本翻译内容，默认为英文
function initLocalizeStrings()
    local languageType = Common.LanguageType
    local replaceFileTable = {}
    if Common.LanguageType == Common.Language_TW then
        replaceFileTable = LocalizeStrings_TW.strings
    elseif Common.LanguageType == Common.Language_CN then
        replaceFileTable = LocalizeStrings_CN.strings
    elseif Common.LanguageType == Common.Language_EN then
        replaceFileTable = LocalizeStrings_EN.strings
    end

    if replaceFileTable then
        for normalKey, normalVar in pairs(LocalizeStrings.strings) do
            for newKey, newVar in pairs(replaceFileTable) do
                if normalKey == newKey then
                    LocalizeStrings.strings[normalKey] = newVar
                    break;
                end
            end

            if replaceFileTable[normalKey] == nil then
                Common.log("当前语言(1:简体中文;2:英文;3繁体中文)" .. Common.LanguageType .. "; 没有找到key === " .. normalKey)
            end
        end

    end
end