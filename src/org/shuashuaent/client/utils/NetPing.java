package org.shuashuaent.client.utils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.os.AsyncTask;

import com.shuashuaent.client.game.TQLuaAndroidConsole;

public class NetPing extends AsyncTask<String, String, String> {

	private String mIPAddr;// ip地址
	public static int javaCallBackLua = -1;

	public NetPing(String ipAddr, int callBack) {
		mIPAddr = ipAddr;
		javaCallBackLua = callBack;
	}

	/**
	 * ping方法
	 *
	 * @param ip
	 * @return
	 */
	public String Ping(String ip) {
		Pub.LOG("ping ====== " + ip);
		String resault = "";
		Process p;
		try {
			// ping -c 1 -w 4 中 ，-c 是指ping的次数 1是指ping 1次 ，-w 4
			// 以秒为单位指定超时间隔，是指超时时间为4秒
			p = Runtime.getRuntime().exec("ping -c 1 -w 4 " + ip);
			int status = p.waitFor();
			InputStream input = p.getInputStream();
			BufferedReader in = new BufferedReader(new InputStreamReader(input));
			StringBuffer buffer = new StringBuffer();
			String line = "";
			while ((line = in.readLine()) != null) {
				buffer.append(line);
			}
			Pub.LOG(buffer.toString());
			if (status == 0) {
				resault = "YES#" + ip;
			} else {
				resault = "NO#error";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resault;
	}

	public static void javaCallbackToLua(final String pingResult) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(javaCallBackLua, pingResult);
				//Cocos2dxLuaJavaBridge.releaseLuaFunction(javaCallBackLua);
			}
		});
	}

	@Override
	protected String doInBackground(String... params) {
		String pingResult = Ping(mIPAddr);
		javaCallbackToLua(pingResult);
		return pingResult;
	}
}