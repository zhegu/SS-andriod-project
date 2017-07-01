module("CommSqliteConfig", package.seeall)

--绑定手机弹出提示框弹出时间
BindPhonePoptipTime = "BindPhonePoptipTime"
--礼包类型ID
GiftBagType = "giftBagType_"
--appStore评价
appStorePingJia = "appStorePingJia_"
--在充值中心显示首充礼包
RechargeCenterShowFirstGiftTime = "RechargeCenterShowFirstGiftTime_"

--寄奖品的用户名、地址、手机号
SendAwardUsername = "SendAwardUsername_"
SendAwardPhone = "SendAwardPhone_"
SendAwardAddress = "SendAwardAddress_"
SendAwardEmail = "SendAwardEmail_"

--本地存储的充值卡卡号 密码
GetCardKhInGameName = "GetCardKhInGameName_"
GetCardKh = "GetCardKh_"
GetCardPass = "GetCardPass_"

--记录每个登录用户的昵称和密码
UserNicknameAndPassword = "UserIDAndPassword_"

--音乐默认适时开启  1开启, 0关闭
GameMusicOffData = "GameMusicOffData"

--音效默认是开启   1开启, 0关闭
GameSoundOffData = "GameSoundOffData"

--自动提示是开启   1开启, 0关闭
GameAutomationData = "GameAutomationData"

--游戏震动是否开启   1开启, 0关闭
GameVibrateData = "GameVibrateData"

--新手引导是否完成
IsUserGuidComeplete_ = "IsUserGuidComeplete_"

--个人头像下载下来之后在本地的位置
SelfAvatorInSD = "SelfAvatorInSD_"

--显示礼包关闭提示时间戳
ShowGiftCloseTimeStamp = "ShowGiftCloseTimeStamp"

--ios海马平台非强制更新的时间戳
LogicVersionIOSHaiMaTimeStamp = "LogicVersionIOSHaiMaTimeStamp_"

--新手引导是否结束 1结束, 0未结束
NewUserGuideIsEnd = "NewUserGuide_"

--新手任务是否结束 1结束, 0未结束
NewUserTaskIsEnd = "NewUserTask_"

--发送公共消息时间戳
SendCommonMsgTimeStamp = "SendCommonMsgTimeStamp_"

--最近一次支付所用方式 alipay：支付宝 union：银联 weixin:微信
RECENT_RECHARGE_MEHTOD = "recent_recharge_method_type_data_";

--记录是否完成新手引导 true为完成，其他情况都是未完成
CommSqliteConfig.UserGuideComplete = "UserGuideComplete_"

--ios版本中AppStore渠道中的使用的IDFA
IOS_APPSTORE_IDFA = "IOS_APPSTORE_IDFA";

--推荐系统 微信分享的url
WXShareDownloadUrl = "WXShareDownloadUrl_";

--token数据存储标示
LAST_LOGIN_TOKEN = "lastLoginToken";

--验证码是否输入过
INVITE_CODE_USED = "inviteCodeUsed"
--第一次打开游戏
IS_FIRST_GAME = "isFirstGame"