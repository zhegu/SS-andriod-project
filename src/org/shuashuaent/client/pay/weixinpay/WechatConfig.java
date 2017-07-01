package org.shuashuaent.client.pay.weixinpay;

import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.shuashuaent.client.game.TQLuaAndroidConsole;

public class WechatConfig {
	public static WechatConfig mWechatConfig;
	private IWXAPI api;

	public static WechatConfig getInstance() {
		if (mWechatConfig == null) {
			mWechatConfig = new WechatConfig();
		}
		return mWechatConfig;
	}

	public WechatConfig() {
		// 通过WXAPIFactory工厂，获取IWXAPI的实例
		api = WXAPIFactory.createWXAPI(TQLuaAndroidConsole.getGameSceneInstance(), TQLuaAndroidConsole.getWXAppID(), false);
		api.registerApp(TQLuaAndroidConsole.getWXAppID());
	}

	public IWXAPI getWechatAPI() {
		return api;
	}
}
