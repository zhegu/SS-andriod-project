package com.shuashuaent.client.game;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.shuashuaent.client.mj.android.GameApplication;
import com.shuashuaent.client.mj.android.LoadActivity;
import com.shuashuaent.client.mj.android.TQGameMainScene;
import com.shuashuaent.client.mj.android.R;

public class TQLuaAndroidConsole {

	public static String PackName = null;
	// 应用包名
	public static final String APP_NAME = "MahjongSichuan";
	// 游戏ID 1:斗地主 ,4:扎金花
	public static final int GAME_ID = 50;

	// public static final String APP_NAME = "lord";
	// public static final int GAME_ID = 1;
	// public static final String APP_NAME = "poker";
	// public static final int GAME_ID = 2;
	// public static final String APP_NAME = "jinhua";
	// public static final int GAME_ID = 4;

	public static TQGameMainScene getGameSceneInstance() {
		return TQGameMainScene.getInstance();
	}

	public static GameApplication getApplicationInstance() {
		return GameApplication.getInstance();
	}

	public static Class<TQGameMainScene> getGameMainSceneClass() {
		return TQGameMainScene.class;
	}

	public static Class<LoadActivity> getLoadActivityClass() {
		return LoadActivity.class;
	}

	/**
	 * 获取微信ID
	 *
	 * @return
	 */
	public static String getWXAppID() {
		return TQLuaAndroidConsole.getGameSceneInstance().getString(R.string.wx_app_id);
	}

	/**
	 * 获取微信分享图标
	 *
	 * @return
	 */
	public static Bitmap getWXShareBitmap() {
		//图片不能超过32K,否则无法弹出微信页面
		Bitmap thumb = BitmapFactory.decodeResource(TQLuaAndroidConsole.getApplicationInstance().getResources(), R.drawable.icon_96_jpg);
		return thumb;
	}

}
