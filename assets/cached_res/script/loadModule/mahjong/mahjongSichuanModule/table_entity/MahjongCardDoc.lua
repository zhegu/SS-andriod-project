module("MahjongCardDoc", package.seeall)

MJ_DIR_FRONT = 0; --正面
MJ_DIR_RIGHT = 1; --右面
MJ_DIR_BACK = 2; --对面
MJ_DIR_LEFT = 3; --左面
MJ_DIR_MAX = 4; --牌桌提示牌(最高层级)
MJ_DIR_GAME_RESULT = 5;--结算界面的牌

--0牌墙,1手牌,2放在桌上的手牌,3打出去的牌,4胡牌
MJ_FACE_WALL_CARD = 0; --0牌墙
MJ_FACE_HAND_CARD = 1; --1手牌
MJ_FACE_PUTDOWN_CARD = 2; --2放在桌上的手牌(吃碰明杠)
MJ_FACE_OUT_CARD = 3; --3打出去的牌
MJ_FACE_HU_CARD = 4; --4胡牌
MJ_FACE_TING_CARD = 5; --5听牌背(亮牌面)
MJ_FACE_TING_BACK_CARD = 6;--亮牌时的手牌(听牌背)
MJ_FACE_PUTDOWN_AN_CARD = 7;--放下的牌(暗杠)

-- 麻将总张数 144
CARD_COUNT = 144;
-- 万牌
TYPE_CHARACTER = 0;
-- 饼牌
TYPE_DOT = 1;
-- 条牌
TYPE_BAMBOO = 2;
-- 风牌
TYPE_WIND = 3;
-- 箭牌
TYPE_DRAGON = 4;
-- 花牌
TYPE_FLOWER = 5;

--m_number;--客户端用的牌面值
COLOR = { "万", "饼", "条", "风", "箭", "花" };
NUM = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
WIND_WORD = { "东", "南", "西", "北", "中", "发", "白" };
FLOWER_WORD = { "春", "夏", "秋", "冬", "梅", "兰", "竹", "菊" };

--打出去牌的最大行列
MaxRow = 3;--最大行
NormalMaxColumn = 8;--普通最大列
LastMaxColumn = 11;--最后一行最大列

--[[--
--通过牌的数值，获取牌的花色和大小
--]]
function getCardInfoByValue(m_nValue)
	local m_nColor = -1;
	local m_nWhat = -1;
	if (0 <= m_nValue and m_nValue <= 35) then
		--万牌
		m_nColor = MahjongCardDoc.TYPE_CHARACTER;
		m_nWhat = (m_nValue % 36) % 9;
	elseif (36 <= m_nValue and m_nValue <= 71) then
		--饼牌
		m_nColor = MahjongCardDoc.TYPE_DOT;
		m_nWhat = (m_nValue % 36) % 9;
	elseif (72 <= m_nValue and m_nValue <= 107) then
		--条牌
		m_nColor = MahjongCardDoc.TYPE_BAMBOO;
		m_nWhat = (m_nValue % 36) % 9;
	elseif (108 <= m_nValue and m_nValue <= 123) then
		--风牌
		m_nColor = MahjongCardDoc.TYPE_WIND;
		m_nWhat = (m_nValue - 108) % 4;
	elseif (124 <= m_nValue and m_nValue <= 135) then
		--箭牌
		m_nColor = MahjongCardDoc.TYPE_DRAGON;
		m_nWhat = (m_nValue - 124) % 3 + 4;
	elseif (136 <= m_nValue and m_nValue <= 143) then
		--花牌
		m_nColor = MahjongCardDoc.TYPE_FLOWER;
		m_nWhat = (m_nValue - 136);
	end
	return m_nColor, m_nWhat;
end

--[[--
--获取麻将牌文本
--]]
function getMahjongCardTxt(m_nValue)
	local m_sTxt = "";
	local m_nColor, m_nWhat = getCardInfoByValue(m_nValue)
	if (m_nColor == TYPE_CHARACTER or m_nColor == TYPE_BAMBOO or m_nColor == TYPE_DOT) then
		-- 万牌/饼牌/条牌
		m_sTxt = NUM[m_nWhat + 1] .. COLOR[m_nColor + 1] .. "(" .. m_nValue .. ")";
	elseif (m_nColor == TYPE_WIND or m_nColor == TYPE_DRAGON) then
		-- 风牌/箭牌
		m_sTxt = WIND_WORD[m_nWhat + 1] .. COLOR[m_nColor + 1] .. "(" .. m_nValue .. ")";
	elseif (m_nColor == TYPE_FLOWER) then
		-- 花牌
		m_sTxt = FLOWER_WORD[m_nWhat + 1] .. COLOR[m_nColor + 1] .. "(" .. m_nValue .. ")";
	end
	return m_sTxt;
end

local SelfCardsInfo = {
	["HandCard"] = {
		{"img_normal_card","184","996","0.82","0","0","0","0.9"},
		{"img_normal_card","300","996","0.82","0","0","0","0.9"},
		{"img_normal_card","416","996","0.82","0","0","0","0.9"},
		{"img_normal_card","532","996","0.82","0","0","0","0.9"},
		{"img_normal_card","648","996","0.82","0","0","0","0.9"},
		{"img_normal_card","764","996","0.82","0","0","0","0.9"},
		{"img_normal_card","880","996","0.82","0","0","0","0.9"},
		{"img_normal_card","996","996","0.82","0","0","0","0.9"},
		{"img_normal_card","1112","996","0.82","0","0","0","0.9"},
		{"img_normal_card","1228","996","0.82","0","0","0","0.9"},
		{"img_normal_card","1344","996","0.82","0","0","0","0.9"},
		{"img_normal_card","1460","996","0.82","0","0","0","0.9"},
		{"img_normal_card","1576","996","0.82","0","0","0","0.9"},
		{"img_normal_card","1738","996","0.82","0","0","0","0.9"},
	},
	["TingFrontCard"] = {
		{"Frame_ziji_pingpaizheng_1","261","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_2","337","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_3","414","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_4","491","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_5","567","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_6","644","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_7","721","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_8","797","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_9","873","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_10","949","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_11","1026","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_12","1103","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_13","1180","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_14","1300","1002","0","0","0","20","50"},
	},
	["PutDownCard"] = {
		{"Frame_ziji_pingpaizheng_1","129","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_2","206","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_3","282","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_2","195","976","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_4","377","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_5","454","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_6","530","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_5","444","976","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_7","626","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_8","703","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_9","779","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_8","698","976","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_10","873","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_11","949","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_12","1026","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_11","948","976","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_13","1180","1002","0","0","0","20","50"},
		{"Frame_ziji_pingpaizheng_14","1300","1002","0","0","0","20","50"},
	},
	["HuCard"] = {
		{"Frame_ziji_xuezhan_1","1400","857","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_2","1466","857","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_3","1533","857","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_4","1600","857","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_1","1410","835","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_2","1476","835","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_3","1543","835","0","0","4","19","42"},
		{"Frame_ziji_xuezhan_4","1609","835","0","0","4","19","42"},
	},
	["OutCard"] = {
		{"Frame_ziji_dachupai_1","806","626","0.86","0","0","19","38"},
		{"Frame_ziji_dachupai_2","863","626","0.86","0","0","19","38"},
		{"Frame_ziji_dachupai_3","921","626","0.86","0","0","19","38"},
		{"Frame_ziji_dachupai_4","979","626","0.86","0","0","19","38"},
		{"Frame_ziji_dachupai_3","1037","626","0.86","1","0","19","38"},
		{"Frame_ziji_dachupai_2","1095","626","0.86","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1152","626","0.86","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1209","626","0.86","1","0","19","38"},
		{"Frame_ziji_dachupai_1","803","692","0.88","0","0","19","38"},
		{"Frame_ziji_dachupai_2","861","692","0.88","0","0","19","38"},
		{"Frame_ziji_dachupai_3","920","692","0.88","0","0","19","38"},
		{"Frame_ziji_dachupai_4","979","692","0.88","0","0","19","38"},
		{"Frame_ziji_dachupai_3","1038","692","0.88","1","0","19","38"},
		{"Frame_ziji_dachupai_2","1097","692","0.88","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1156","692","0.88","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1213","692","0.88","1","0","19","38"},
		{"Frame_ziji_dachupai_1","800","762","0.9","0","0","19","38"},
		{"Frame_ziji_dachupai_2","859","762","0.9","0","0","19","38"},
		{"Frame_ziji_dachupai_3","918","762","0.9","0","0","19","38"},
		{"Frame_ziji_dachupai_4","978","762","0.9","0","0","19","38"},
		{"Frame_ziji_dachupai_3","1037","762","0.9","1","0","19","38"},
		{"Frame_ziji_dachupai_2","1096","762","0.9","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1155","762","0.9","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1215","762","0.9","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1275","762","0.9","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1335","762","0.9","1","0","19","38"},
		{"Frame_ziji_dachupai_1","1395","762","0.9","1","0","19","38"},
	},
	["TingBackCard"] = {
		{"Frame_shangjia_pingpai_zheng_1","395","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_2","449","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_3","504","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_4","558","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_5","612","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_6","667","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_7","739","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_8","775","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_9","829","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_10","884","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_11","938","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_12","992","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_13","1047","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_14","1128","66","0","0","0","0","0"},
	},
	["PutDownAnCard"] = {
		{"Frame_ziji_pingpaibei_1","129","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_2","206","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_3","282","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaizheng_2","195","976","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_4","377","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_5","454","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_6","530","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaizheng_5","454","976","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_7","626","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_8","703","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_9","779","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaizheng_8","698","976","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_10","873","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_11","949","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaibei_12","1026","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaizheng_11","948","976","0","0","0","17","50"},
		{"Frame_ziji_pingpaizheng_13","1180","1002","0","0","0","17","50"},
		{"Frame_ziji_pingpaizheng_14","1300","1002","0","0","0","17","50"},
	},

}

local RightCardsInfo = {
	["HandCard"] = {
		{"Frame_zuojia_shupai_14","1810","804","0","1","0","0","0"},
		{"Frame_zuojia_shupai_13","1799","748","0","1","0","0","0"},
		{"Frame_zuojia_shupai_12","1788","693","0","1","0","0","0"},
		{"Frame_zuojia_shupai_11","1776","639","0","1","0","0","0"},
		{"Frame_zuojia_shupai_10","1765","587","0","1","0","0","0"},
		{"Frame_zuojia_shupai_9","1755","538","0","1","0","0","0"},
		{"Frame_zuojia_shupai_8","1745","491","0","1","0","0","0"},
		{"Frame_zuojia_shupai_7","1736","443","0","1","0","0","0"},
		{"Frame_zuojia_shupai_6","1726","399","0","1","0","0","0"},
		{"Frame_zuojia_shupai_5","1717","355","0","1","0","0","0"},
		{"Frame_zuojia_shupai_4","1707","311","0","1","0","0","0"},
		{"Frame_zuojia_shupai_3","1699","269","0","1","0","0","0"},
		{"Frame_zuojia_shupai_2","1690","228","0","1","0","0","0"},
		{"Frame_zuojia_shupai_1","1678","172","0","1","0","0","0"},
	},
	["TingFrontCard"] = {
		{"Frame_zuojia_pingpai_zheng_1","1729","795","0","1","8","17","100"},
		{"Frame_zuojia_pingpai_zheng_2","1719","738","0","1","8","17","99"},
		{"Frame_zuojia_pingpai_zheng_3","1709","684","0","1","8","17","98"},
		{"Frame_zuojia_pingpai_zheng_4","1699","631","0","1","8","17","97"},
		{"Frame_zuojia_pingpai_zheng_5","1689","579","0","1","8","17","96"},
		{"Frame_zuojia_pingpai_zheng_6","1679","530","0","1","8","17","95"},
		{"Frame_zuojia_pingpai_zheng_7","1670","483","0","1","8","17","94"},
		{"Frame_zuojia_pingpai_zheng_8","1662","436","0","1","8","17","93"},
		{"Frame_zuojia_pingpai_zheng_9","1653","392","0","1","8","17","92"},
		{"Frame_zuojia_pingpai_zheng_10","1644","346","0","1","8","17","91"},
		{"Frame_zuojia_pingpai_zheng_11","1635","304","0","1","8","17","90"},
		{"Frame_zuojia_pingpai_zheng_12","1627","261","0","1","8","17","89"},
		{"Frame_zuojia_pingpai_zheng_13","1619","220","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1607","160","0","1","8","17","88"},
	},
	["PutDownCard"] = {
		{"Frame_zuojia_pingpai_zheng_2","1735","829","0","1","8","17","99"},
		{"Frame_zuojia_pingpai_zheng_3","1725","772","0","1","8","17","98"},
		{"Frame_zuojia_pingpai_zheng_4","1714","718","0","1","8","17","97"},
		{"Frame_zuojia_pingpai_zheng_5","1734","750","0","1","8","17","96"},
		{"Frame_zuojia_pingpai_zheng_6","1703","656","0","1","8","17","95"},
		{"Frame_zuojia_pingpai_zheng_7","1693","604","0","1","8","17","94"},
		{"Frame_zuojia_pingpai_zheng_8","1683","555","0","1","8","17","93"},
		{"Frame_zuojia_pingpai_zheng_9","1702","584","0","1","8","17","92"},
		{"Frame_zuojia_pingpai_zheng_10","1671","494","0","1","8","17","91"},
		{"Frame_zuojia_pingpai_zheng_11","1663","447","0","1","8","17","90"},
		{"Frame_zuojia_pingpai_zheng_12","1654","403","0","1","8","17","89"},
		{"Frame_zuojia_pingpai_zheng_13","1672","425","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1644","346","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1635","304","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1627","261","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1643","281","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1611","180","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1607","160","0","1","8","17","88"},
	},
	["HuCard"] = {
		{"Frame_youjia_xuezhan_1","1414","202","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_2","1407","168","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_3","1480","202","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_4","1473","168","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_1","1421","173","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_2","1414","144","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_3","1487","179","0","0","2","16","80"},
		{"Frame_youjia_xuezhan_4","1480","144","0","0","2","16","80"},
	},
	["OutCard"] = {
		{"Frame_zuojia_1_1","1198","528","0","1","1","15","100"},
		{"Frame_zuojia_1_2","1194","481","0","1","1","15","98"},
		{"Frame_zuojia_1_3","1190","434","0","1","1","15","96"},
		{"Frame_zuojia_1_4","1187","389","0","1","1","15","94"},
		{"Frame_zuojia_1_5","1184","346","0","1","1","15","92"},
		{"Frame_zuojia_1_6","1180","302","0","1","1","15","90"},
		{"Frame_zuojia_1_7","1177","261","0","1","1","15","88"},
		{"Frame_zuojia_1_7","1175","222","0","1","1","15","86"},
		{"Frame_zuojia_2_1","1274","527","0","1","1","15","100"},
		{"Frame_zuojia_2_2","1269","481","0","1","1","15","98"},
		{"Frame_zuojia_2_3","1264","434","0","1","1","15","96"},
		{"Frame_zuojia_2_4","1261","389","0","1","1","15","94"},
		{"Frame_zuojia_2_5","1256","346","0","1","1","15","92"},
		{"Frame_zuojia_2_6","1252","302","0","1","1","15","90"},
		{"Frame_zuojia_2_7","1247","261","0","1","1","15","88"},
		{"Frame_zuojia_2_7","1244","222","0","1","1","15","86"},
		{"Frame_zuojia_3_1","1344","528","0","1","1","15","100"},
		{"Frame_zuojia_3_2","1339","481","0","1","1","15","98"},
		{"Frame_zuojia_3_3","1334","435","0","1","1","15","96"},
		{"Frame_zuojia_3_4","1330","390","0","1","1","15","94"},
		{"Frame_zuojia_3_5","1325","348","0","1","1","15","92"},
		{"Frame_zuojia_3_6","1320","306","0","1","1","15","90"},
		{"Frame_zuojia_3_7","1316","266","0","1","1","15","88"},
		{"Frame_zuojia_3_7","1312","225","0","1","1","15","86"},
		{"Frame_zuojia_3_7","1308","186","0","1","1","15","84"},
		{"Frame_zuojia_3_7","1304","146","0","1","1","15","82"},
		{"Frame_zuojia_3_7","1300","107","0","1","1","15","80"},
	},
	["TingBackCard"] = {
		{"Frame_shangjia_pingpai_zheng_1","395","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_2","449","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_3","504","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_4","558","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_5","612","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_6","667","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_7","739","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_8","775","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_9","829","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_10","884","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_11","938","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_12","992","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_13","1047","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_14","1128","66","0","0","0","0","0"},
	},
	["PutDownAnCard"] = {
		{"Frame_zuojia_pingpai_fan_2","1735","829","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_3","1725","772","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_4","1714","718","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_5","1734","750","0","1","8","17","96"},
		{"Frame_zuojia_pingpai_fan_6","1703","656","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_7","1693","604","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_8","1683","555","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_9","1702","584","0","1","8","17","92"},
		{"Frame_zuojia_pingpai_fan_10","1671","494","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_11","1663","447","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_12","1654","403","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_13","1672","425","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_fan_14","1644","346","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_14","1635","304","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_fan_14","1627","261","0","1","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_14","1643","281","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1611","180","0","1","8","17","88"},
		{"Frame_zuojia_pingpai_zheng_14","1607","160","0","1","8","17","88"},
	},

}

local UpCardsInfo = {
	["HandCard"] = {
		{"Frame_shangjia_shupai_14","1000","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_13","948","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_12","896","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_11","845","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_10","794","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_9","743","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_8","692","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_7","641","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_6","590","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_5","538","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_4","486","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_3","435","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_2","384","43","0","0","0","0","0",},
		{"Frame_shangjia_shupai_1","309","43","0","0","0","0","0",},
	},
	["TingFrontCard"] = {
		{"Frame_shangjia_pingpai_zheng_14","1041","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_13","986","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_12","932","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_11","878","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_10","825","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_9","772","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_8","719","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_7","665","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_6","611","66","0","0","-1","0","0",},
		{"Frame_shangjia_pingpai_zheng_5","557","66","0","0","-2","0","0",},
		{"Frame_shangjia_pingpai_zheng_4","503","66","0","0","-3","0","0",},
		{"Frame_shangjia_pingpai_zheng_3","449","66","0","0","-4","0","0",},
		{"Frame_shangjia_pingpai_zheng_2","395","66","0","0","-5","0","0",},
		{"Frame_shangjia_pingpai_zheng_1","320","66","0","0","-5","0","0",},
	},
	["PutDownCard"] = {
		{"Frame_shangjia_pingpai_zheng_14","1139","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_13","1085","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_12","1031","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_13","1085","39","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_11","963","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_10","908","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_9","855","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_10","906","39","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_8","787","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_7","733","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_6","680","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_7","730","39","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_5","612","66","0","0","-3","0","0",},
		{"Frame_shangjia_pingpai_zheng_4","558","66","0","0","-3","0","0",},
		{"Frame_shangjia_pingpai_zheng_3","505","66","0","0","-3","0","0",},
		{"Frame_shangjia_pingpai_zheng_4","554","39","0","0","-3","0","0",},
		{"Frame_shangjia_pingpai_zheng_2","395","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_1","320","66","0","0","0","0","0",},
	},
	["HuCard"] = {
		{"Frame_shangjia_xuezhan_1","570","188","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_2","519","188","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_3","577","139","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_4","526","139","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_1","566","164","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_2","514","164","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_3","573","115","0","0","-2","0","0",},
		{"Frame_shangjia_xuezhan_4","521","115","0","0","-2","0","0",},
	},
	["OutCard"] = {
		{"Frame_ziji_dachupai_1","1092","284","0.8","1","2","14","33",},
		{"Frame_ziji_dachupai_2","1039","284","0.8","1","0","14","33",},
		{"Frame_ziji_dachupai_3","986","284","0.8","1","0","14","33",},
		{"Frame_ziji_dachupai_4","933","284","0.8","0","0","14","33",},
		{"Frame_ziji_dachupai_3","880","284","0.8","0","0","14","33",},
		{"Frame_ziji_dachupai_2","827","284","0.8","0","2","14","33",},
		{"Frame_ziji_dachupai_1","775","284","0.8","0","2","14","33",},
		{"Frame_ziji_dachupai_1","723","284","0.8","0","2","14","33",},
		{"Frame_ziji_dachupai_1","1089","220","0.78","1","0","14","33",},
		{"Frame_ziji_dachupai_2","1037","220","0.78","1","0","14","33",},
		{"Frame_ziji_dachupai_3","985","220","0.78","1","0","14","33",},
		{"Frame_ziji_dachupai_4","933","220","0.78","0","0","14","33",},
		{"Frame_ziji_dachupai_3","881","220","0.78","0","0","14","33",},
		{"Frame_ziji_dachupai_2","829","220","0.78","0","0","14","33",},
		{"Frame_ziji_dachupai_1","777","220","0.78","0","2","14","33",},
		{"Frame_ziji_dachupai_1","726","220","0.78","0","2","14","33",},
		{"Frame_ziji_dachupai_1","1085","159","0.76","1","2","14","33",},
		{"Frame_ziji_dachupai_2","1035","159","0.76","1","0","14","33",},
		{"Frame_ziji_dachupai_3","985","159","0.76","1","0","14","33",},
		{"Frame_ziji_dachupai_4","934","159","0.76","0","0","14","33",},
		{"Frame_ziji_dachupai_3","884","159","0.76","0","0","14","33",},
		{"Frame_ziji_dachupai_2","833","159","0.76","0","0","14","33",},
		{"Frame_ziji_dachupai_1","782","159","0.76","0","2","14","33",},
		{"Frame_ziji_dachupai_1","731","159","0.76","0","2","14","33",},
		{"Frame_ziji_dachupai_1","680","159","0.76","0","2","14","33",},
		{"Frame_ziji_dachupai_1","629","159","0.76","0","2","14","33",},
		{"Frame_ziji_dachupai_1","578","159","0.76","0","2","14","33",},
	},
	["TingBackCard"] = {
		{"Frame_shangjia_pingpai_zheng_1","395","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_2","449","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_3","504","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_4","558","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_5","612","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_6","667","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_7","739","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_8","775","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_9","829","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_10","884","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_11","938","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_12","992","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_13","1047","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_14","1128","66","0","0","0","0","0",},
	},
	["PutDownAnCard"] = {
		{"Frame_shangjia_pingpai_fan_14","1139","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_13","1085","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_12","1031","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_13","1085","39","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_11","963","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_10","908","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_9","855","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_10","906","39","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_8","787","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_7","733","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_6","680","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_7","730","39","0","0","-2","0","0",},
		{"Frame_shangjia_pingpai_fan_5","612","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_4","558","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_3","505","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_zheng_4","554","39","0","0","-3","0","0",},
		{"Frame_shangjia_pingpai_fan_2","395","66","0","0","0","0","0",},
		{"Frame_shangjia_pingpai_fan_1","320","66","0","0","0","0","0",},
	},
}

local LeftCardsInfo = {
	["HandCard"] = {
		{"Frame_zuojia_shupai_1","239","185","0","0","0","0","0"},
		{"Frame_zuojia_shupai_2","231","226","0","0","0","0","0"},
		{"Frame_zuojia_shupai_3","222","266","0","0","0","0","0"},
		{"Frame_zuojia_shupai_4","213","309","0","0","0","0","0"},
		{"Frame_zuojia_shupai_5","203","352","0","0","0","0","0"},
		{"Frame_zuojia_shupai_6","194","397","0","0","0","0","0"},
		{"Frame_zuojia_shupai_7","185","441","0","0","0","0","0"},
		{"Frame_zuojia_shupai_8","175","487","0","0","0","0","0"},
		{"Frame_zuojia_shupai_9","165","536","0","0","0","0","0"},
		{"Frame_zuojia_shupai_10","155","585","0","0","0","0","0"},
		{"Frame_zuojia_shupai_11","144","637","0","0","0","0","0"},
		{"Frame_zuojia_shupai_12","133","690","0","0","0","0","0"},
		{"Frame_zuojia_shupai_13","122","744","0","0","0","0","0"},
		{"Frame_zuojia_shupai_14","107","817","0","0","0","0","0"},
	},
	["TingFrontCard"] = {
		{"Frame_zuojia_pingpai_zheng_14","301","214","0","0","-8","17","88"},
		{"Frame_zuojia_pingpai_zheng_12","293","254","0","0","-8","17","89"},
		{"Frame_zuojia_pingpai_zheng_11","284","295","0","0","-8","17","90"},
		{"Frame_zuojia_pingpai_zheng_10","276","338","0","0","-8","17","91"},
		{"Frame_zuojia_pingpai_zheng_9","267","380","0","0","-8","17","92"},
		{"Frame_zuojia_pingpai_zheng_8","258","426","0","0","-8","17","96"},
		{"Frame_zuojia_pingpai_zheng_7","250","470","0","0","-8","17","94"},
		{"Frame_zuojia_pingpai_zheng_6","241","517","0","0","-8","17","95"},
		{"Frame_zuojia_pingpai_zheng_5","232","564","0","0","-8","17","96"},
		{"Frame_zuojia_pingpai_zheng_4","223","613","0","0","-8","17","97"},
		{"Frame_zuojia_pingpai_zheng_3","213","665","0","0","-8","17","98"},
		{"Frame_zuojia_pingpai_zheng_2","202","718","0","0","-8","17","99"},
		{"Frame_zuojia_pingpai_zheng_1","192","772","0","0","-8","17","100"},
		{"Frame_zuojia_pingpai_zheng_1","177","853","0","0","-8","17","100"},
	},
	["PutDownCard"] = {
		{"Frame_zuojia_pingpai_zheng_13","307","180","0","0","-8","17","84"},
		{"Frame_zuojia_pingpai_zheng_12","298","220","0","0","-8","17","85"},
		{"Frame_zuojia_pingpai_zheng_11","290","263","0","0","-8","17","86"},
		{"Frame_zuojia_pingpai_zheng_12","291","197","0","0","-8","17","87"},
		{"Frame_zuojia_pingpai_zheng_9","279","316","0","0","-8","17","88"},
		{"Frame_zuojia_pingpai_zheng_8","271","360","0","0","-8","17","89"},
		{"Frame_zuojia_pingpai_zheng_7","263","404","0","0","-8","17","90"},
		{"Frame_zuojia_pingpai_zheng_8","264","335","0","0","-8","17","91"},
		{"Frame_zuojia_pingpai_zheng_5","252","464","0","0","-8","17","92"},
		{"Frame_zuojia_pingpai_zheng_4","242","511","0","0","-8","17","93"},
		{"Frame_zuojia_pingpai_zheng_3","233","560","0","0","-8","17","94"},
		{"Frame_zuojia_pingpai_zheng_4","235","489","0","0","-8","17","95"},
		{"Frame_zuojia_pingpai_zheng_1","220","623","0","0","-8","17","96"},
		{"Frame_zuojia_pingpai_zheng_1","210","675","0","0","-8","17","97"},
		{"Frame_zuojia_pingpai_zheng_1","199","729","0","0","-8","17","98"},
		{"Frame_zuojia_pingpai_zheng_1","202","652","0","0","-8","17","99"},
		{"Frame_zuojia_pingpai_zheng_1","182","829","0","0","-8","17","100"},
		{"Frame_zuojia_pingpai_zheng_1","205","853","0","0","-8","17","100"},
	},
	["HuCard"] = {
		{"Frame_zuojia_xuezhan_1","406","782","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_2","397","838","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_3","323","782","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_4","312","838","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_1","398","763","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_2","389","819","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_3","345","763","0","0","-5","16","0"},
		{"Frame_zuojia_xuezhan_4","304","819","0","0","-5","16","0"},
	},
	["OutCard"] = {
		{"Frame_zuojia_1_7","727","366","0","0","-1","15","88"},
		{"Frame_zuojia_1_6","724","407","0","0","-1","15","90"},
		{"Frame_zuojia_1_5","721","451","0","0","-1","15","92"},
		{"Frame_zuojia_1_4","718","494","0","0","-1","15","94"},
		{"Frame_zuojia_1_3","714","539","0","0","-1","15","96"},
		{"Frame_zuojia_1_2","710","586","0","0","-1","15","98"},
		{"Frame_zuojia_1_1","707","633","0","0","-1","15","100"},
		{"Frame_zuojia_1_1","704","681","1.02","0","-1","15","102"},
		{"Frame_zuojia_2_7","656","366","0","0","-1","15","88"},
		{"Frame_zuojia_2_6","653","407","0","0","-1","15","90"},
		{"Frame_zuojia_2_5","649","451","0","0","-1","15","92"},
		{"Frame_zuojia_2_4","644","494","0","0","-1","15","94"},
		{"Frame_zuojia_2_3","640","539","0","0","-1","15","96"},
		{"Frame_zuojia_2_2","636","586","0","0","-1","15","98"},
		{"Frame_zuojia_2_1","632","632","0","0","-1","15","100"},
		{"Frame_zuojia_2_1","627","681","1.02","0","-1","15","102"},
		{"Frame_zuojia_3_7","586","366","0","0","-1","15","88"},
		{"Frame_zuojia_3_6","581","407","0","0","-1","15","90"},
		{"Frame_zuojia_3_5","576","451","0","0","-1","15","92"},
		{"Frame_zuojia_3_4","571","495","0","0","-1","15","94"},
		{"Frame_zuojia_3_3","567","540","0","0","-1","15","96"},
		{"Frame_zuojia_3_2","560","586","0","0","-1","15","98"},
		{"Frame_zuojia_3_1","555","633","0","0","-1","15","100"},
		{"Frame_zuojia_3_1","550","681","1.02","0","-1","15","102"},
		{"Frame_zuojia_3_1","545","731","1.04","0","-1","15","104"},
		{"Frame_zuojia_3_1","540","781","1.06","0","-1","15","106"},
		{"Frame_zuojia_3_1","535","833","1.08","0","-1","15","108"},
	},
	["TingBackCard"] = {
		{"Frame_shangjia_pingpai_zheng_1","395","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_2","449","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_3","504","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_4","558","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_5","612","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_6","667","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_7","739","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_8","775","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_9","829","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_10","884","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_11","938","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_12","992","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_13","1047","66","0","0","0","0","0"},
		{"Frame_shangjia_pingpai_zheng_14","1128","66","0","0","0","0","0"},
	},
	["PutDownAnCard"] = {
		{"Frame_zuojia_pingpai_fan_13","307","180","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_12","298","220","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_11","290","263","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_12","291","197","0","0","-8","17","87"},
		{"Frame_zuojia_pingpai_fan_9","279","316","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_8","271","360","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_7","263","404","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_8","264","335","0","0","-8","17","91"},
		{"Frame_zuojia_pingpai_fan_5","252","464","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_4","242","511","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_3","233","560","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_4","235","489","0","0","-8","17","95"},
		{"Frame_zuojia_pingpai_fan_1","220","623","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_1","210","675","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_fan_1","199","729","0","0","0","0","0"},
		{"Frame_zuojia_pingpai_zheng_1","202","652","0","0","-8","17","99"},
		{"Frame_zuojia_pingpai_zheng_1","182","829","0","0","-8","17","100"},
		{"Frame_zuojia_pingpai_zheng_1","205","853","0","0","-8","17","100"},
	},

}

local HandCard = "HandCard";--手牌
local TingFrontCard = "TingFrontCard";--亮牌时的手牌(听牌面)
local PutDownCard = "PutDownCard"; --放下的牌(明杠)
local HuCard = "HuCard"; --胡牌
local OutCard = "OutCard"; --打出的牌
local TingBackCard = "TingBackCard";--亮牌时的手牌(听牌背)
local PutDownAnCard = "PutDownAnCard";--放下的牌(暗杠)

CardBackName = 1; --白板命名
CardBackX = 2; --白板位置x
CardBackY = 3; --白板位置y
CardBackScale = 4; --白板缩放
isRotate = 5; --是否旋转（0或者1,0是不旋转，1是旋转）
CardFaceX = 6; --花色相对白板坐标x
CardFaceY = 7; --花色相对白板坐标y
CardFaceScale = 8; --花色缩放

--[[--
-- 获取牌桌麻将牌信息
-- ]]
function getMJCardInfo(nDir, nFaceState, nInfo, nColumn)
	-- 获取自己的麻将牌信息
	local CardInfo = {};
	if nDir == MJ_DIR_FRONT or nDir == MJ_DIR_MAX then
		CardInfo = SelfCardsInfo;
	elseif nDir == MJ_DIR_RIGHT then
		CardInfo = RightCardsInfo;
	elseif nDir == MJ_DIR_BACK then
		CardInfo = UpCardsInfo;
	elseif nDir == MJ_DIR_LEFT then
		CardInfo = LeftCardsInfo;
	end

	local sType = "";
	if nFaceState == MJ_FACE_WALL_CARD then
	--0牌墙
	elseif nFaceState == MJ_FACE_HAND_CARD then
		--1手牌
		sType = HandCard;
	elseif nFaceState == MJ_FACE_PUTDOWN_CARD then
		--2放在桌上的手牌(吃碰杠)
		sType = PutDownCard;
	elseif nFaceState == MJ_FACE_OUT_CARD then
		--3打出去的牌
		sType = OutCard;
	elseif nFaceState == MJ_FACE_HU_CARD then
		--4胡牌
		sType = HuCard;
	elseif nFaceState == MJ_FACE_TING_CARD then
		--5听牌
		sType = TingFrontCard;
	elseif nFaceState == MJ_FACE_TING_BACK_CARD then
		--6亮牌时的手牌(听牌背)
		sType = TingBackCard;
	elseif nFaceState == MJ_FACE_PUTDOWN_AN_CARD then
		--7放下的牌(暗杠)
		sType = PutDownAnCard;
	end

	--Common.log("sType ======= "..sType .." nColumn ======= "..nColumn.." nInfo ======= "..nInfo);

	if nInfo == CardBackName then
		--白板命名
		return CardInfo[sType][nColumn][nInfo];
	elseif nInfo == CardBackScale then
		--白板缩放
		local cardScale = tonumber(CardInfo[sType][nColumn][nInfo]);
		if cardScale == 0 then
			cardScale = 1;
		end
		if cardScale > 5 then
			cardScale = cardScale / 100;
		end
		return cardScale;
	elseif nInfo == isRotate then
		local isRotate = tonumber(CardInfo[sType][nColumn][nInfo]);
		if isRotate == 1 then
			return -1;
		end
		return 1;
	elseif nInfo == CardBackY then
		--白板位置y
		return MahjongTableConfig.TableDefaultHeight - tonumber(CardInfo[sType][nColumn][nInfo]);
	elseif nInfo == CardFaceScale then
		--花色缩放
		local cardFaceScale = tonumber(CardInfo[sType][nColumn][nInfo]);
		if cardFaceScale == 0 then
			cardFaceScale = 1;
		end
		if cardFaceScale > 5 then
			cardFaceScale = cardFaceScale / 100;
		end
		if sType == OutCard then
			local cardScale = tonumber(CardInfo[sType][nColumn][CardBackScale]);
			if cardScale == 0 then
				cardScale = 1;
			end
			if cardScale > 5 then
				cardScale = cardScale / 100;
			end
			return cardFaceScale/cardScale;
		else
			return cardFaceScale;
		end
	else
		return tonumber(CardInfo[sType][nColumn][nInfo]);
	end
end


