package org.shuashuaent.client.utils;

import org.android.agoo.net.async.AsyncHttpClient;
import org.android.agoo.net.async.AsyncHttpResponseHandler;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import com.shuashuaent.client.game.TQLuaAndroidConsole;

public class PingConfig {

	/**
	 * ping IP地址
	 *
	 * @param ipAddr
	 * @param callBack
	 */
	public static void startPing(final String ipAddr, final int callBack) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				new NetPing(ipAddr, callBack).execute();
			}
		});
	}

	/**
	 * 获取联网IP
	 *
	 * @param ipUrl
	 * @param callBack
	 */
	public static void getNetWorkIP(final String ipUrl, final int callBack) {

		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AsyncHttpClient client = new AsyncHttpClient();
				client.get(TQLuaAndroidConsole.getGameSceneInstance(), ipUrl, new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(final String response) {
						TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
							@Override
							public void run() {
								Cocos2dxLuaJavaBridge.callLuaFunctionWithString(callBack, response);
								Cocos2dxLuaJavaBridge.releaseLuaFunction(callBack);
							}
						});
					}
				});
			}
		});

	}
}
