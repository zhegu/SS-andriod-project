module("QrcodeUtil", package.seeall)

--推荐系统二维码图片名
RECOMMEND_QRCODE_NAME = "recommend_qrcode"
--推荐系统二维码图片名 有背景（如果修改二维码背景  修改此文件明即可）
--微信分享缩略图
RECOMMEND_QRCODE_BG_NAME = "recommend_qrcode_bg_scale_1.png"
--微信分享实际图片
RECOMMEND_QRCODE_BG_SCALE_NAME = "recommend_qrcode_bg_1.png"

--[[--
--获取二维码的图片名
--]]
function getRECOMMEND_QRCODE_NAME()
	local cdKey = ""
	if GameConfig.GAME_ID == GamePub.MAHJONG_SICHUAN_GAMEID then
		cdKey = profile.MahjongRecommend.getShareToWxKey()
	else
		cdKey = profile.ShareToWXJinhua.getShareToWxKey()
	end
	return RECOMMEND_QRCODE_NAME..cdKey..".png"
end
--[[--
--生成一个二维码
--参数1 = 二维码代表的字符串
--参数2 = 二维码中心显示的图片路径
--参数3 = 二维码的尺寸 正方形
--参数4 = 生成二维码保存的名字
--]]
function createQRCodePicAndSaveToFile(codeStrOrUrl,iconPath,size,qrcodeName)
	local erweimaColorLayerTemp = QRSprite:create(""..codeStrOrUrl,iconPath,size);
	erweimaColorLayerTemp:saveQRcodeToFile(qrcodeName)
end

--[[--
--获取二维码图片的路径
--]]
function getQRCodePicPath(qrcodeName)
	return CCFileUtils:sharedFileUtils():getWritablePath()..qrcodeName
end

--[[--
--图片是否存在
--]]
function getQRCodePicIsExist(qrcodefullpath)
	-- if CCFileUtils:sharedFileUtils():isFileExist(qrcodefullpath) then
	-- 	Common.log("getQRCodePicIsExist == true")
	-- else
	-- 	Common.log("getQRCodePicIsExist == false")
	-- end
	return CCFileUtils:sharedFileUtils():isFileExist(qrcodefullpath)
end

--[[--
--获取二维码精灵
--]]
function getQRCodeSprite(qrcodeName)
	--获取二维码图片路径
	local qrcodefullpath = getQRCodePicPath(qrcodeName)
	-- Common.log("qrcodefullpath == "..qrcodefullpath)
	return CCSprite:create(qrcodefullpath);
end

--[[--
--截取一张图片（把两张图片合在一起）
--参数1：底图路径
--参数2：内容图片路径
--参数3、4：底图宽 高
--参数5、6：内容图在底图上的位置
--参数7：新生成图片的名字
--参数8：整体缩放值
--]]
function drawCreatePng(fileNameBg,fileNameCon,newFileName,w,h,x,y,mSclae)
	if mSclae == nil then
		mSclae = 1
	end
	--创建一个层
	local tempLayer = CCLayer:create()
	--创建背景精灵
	local bgSprite = CCSprite:create(fileNameBg)
	bgSprite:setAnchorPoint(ccp(0,0))
	bgSprite:setPosition(ccp(0,0))
	tempLayer:addChild(bgSprite)
	--创建内容精灵
	--清除精灵缓存
	CCTextureCache:sharedTextureCache():removeTextureForKey(fileNameCon)
	local conSprite = CCSprite:create(fileNameCon)
	conSprite:setPosition(ccp(x,y))
	tempLayer:addChild(conSprite)

    tempLayer:setAnchorPoint(ccp(0, 0));
    tempLayer:setPosition(ccp(0, 0));
    tempLayer:setScale(mSclae)

    local renderTexture = CCRenderTexture:create(w*mSclae,h*mSclae);
    renderTexture:begin();
    tempLayer:visit();--将当前的二维码绘出来
    renderTexture:endToLua();
    renderTexture:saveToFile(newFileName, kCCImageFormatPNG);

end

function drawSencePng(newFileName,mSclae)
	if mSclae == nil then
		mSclae = 1
	end
    local renderTexture = CCRenderTexture:create(GameConfig.ScreenWidth*mSclae,GameConfig.ScreenHeight*mSclae);
    renderTexture:begin();
    CCDirector:sharedDirector():getRunningScene():visit();--将当前的二维码绘出来
    renderTexture:endToLua();
    renderTexture:saveToFile(newFileName, kCCImageFormatPNG);
end

function drawScaleSencePng(fileNameCon,newFileName,mSclae)
	if mSclae == nil then
		mSclae = 1
	end
	--创建一个层
	local tempLayer = CCLayer:create()
	--创建背景精灵
	--清除精灵缓存
	CCTextureCache:sharedTextureCache():removeTextureForKey(fileNameCon)
	local bgSprite = CCSprite:create(fileNameCon)
	bgSprite:setAnchorPoint(ccp(0,0))
	bgSprite:setPosition(ccp(0,0))
	tempLayer:addChild(bgSprite)

    tempLayer:setAnchorPoint(ccp(0, 0));
    tempLayer:setPosition(ccp(0, 0));
    tempLayer:setScale(mSclae)

    local renderTexture = CCRenderTexture:create(GameConfig.ScreenWidth*mSclae,GameConfig.ScreenHeight*mSclae);
    renderTexture:begin();
    tempLayer:visit();--将当前的二维码绘出来
    renderTexture:endToLua();
    renderTexture:saveToFile(newFileName, kCCImageFormatPNG);
end
