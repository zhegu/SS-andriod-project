package org.shuashuaent.client.utils;

import java.io.File;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.shuashuaent.client.utils.unzip.UnzipAsyncTaskForLua;

import com.shuashuaent.client.game.TQLuaAndroidConsole;

public class LuaUpdateConsole {
	private static final String zipDownloadDir = "LoadScript" + File.separator + "downLoad";// 下载的zip包存放目录
	private static final String ScriptDir = "LoadScript" + File.separator + "LuaScript";// 脚本文件存放目录
	private static final String zipFilePath = Pub.getTrendsSaveFilePath(zipDownloadDir);// 下载的zip包的路径
	private static final String ScriptFilePath = Pub.getTrendsSaveFilePath(ScriptDir);// 脚本文件存放的路径
	private static final String MiniGameScriptFilePath = Pub.getTrendsSaveFilePath(ScriptDir) + "script/loadModule/";// 小游戏脚本文件存放的路径
	private static final String MainScriptPackage = "cached_res";//

	public static int unZipProgressCallback = -1;
	public static UnzipAsyncTaskForLua mUnzipAsyncTask = null;

	// private static LuaUpdateInfo mLuaUpdateInfo = null;// lua升级信息
	private static String mUnZipFileName = null;// 需要解压的zip文件路径
	private static int unZipScriptDoneCallback = -1;// 解压删除文件完成后，回调lua

	public static String DownloadTips = "";// 下载提示文字

	/**
	 * 下载的zip包存放目录
	 *
	 * @return
	 */
	public static String getZipDownloadDir() {
		return zipDownloadDir;
	}

	/**
	 * 下载的zip包的路径
	 *
	 * @return
	 */
	public static String getZipFilePath() {
		return zipFilePath;
	}

	/**
	 * 脚本文件存放的路径
	 *
	 * @return
	 */
	public static String getScriptFilePath() {
		return ScriptFilePath;
	}

	/**
	 * 复制所有的脚本文件
	 */
	public static void copyScriptFile() {
		if (Pub.mbIsDeBug) {
			Pub.LOG("DeBug模式脚本文件不复制 ======== ");
			return;
		}
		long startTime = System.currentTimeMillis();
		Pub.LOG("开始复制脚本...........................");

		Pub.CopyAssets("cached_res", getScriptFilePath());
		// 复制脚本版本号到SD卡
		Pub.copyBigDataToSD("scriptConfig.json", getScriptFilePath(), "scriptConfig.json");
		Pub.LOG("复制脚本所用的时间......................." + (System.currentTimeMillis() - startTime) + "毫秒");
	}

	/**
	 * 复制MD5文件
	 */
	public static void copyMD5ListFile() {
		if (Pub.mbIsDeBug) {
			Pub.LOG("DeBug模式脚本文件不复制 ======== ");
			return;
		}
		long startTime = System.currentTimeMillis();
		Pub.LOG("开始复制MD5...........................");

		// 复制公共模块的MD5列表到SD卡
		Pub.CopyAssets("cached_res/NativeCommonFileMD5List", getScriptFilePath() + "/NativeCommonFileMD5List");
		// 复制主游戏模块的MD5列表到SD卡
		Pub.copyBigDataToSD("cached_res/cached_res_AllListMD5.data", getScriptFilePath(), "cached_res_AllListMD5.data");
		Pub.copyBigDataToSD("cached_res/cached_res_FileMD5List.data", getScriptFilePath(), "cached_res_FileMD5List.data");
		// 复制脚本版本号到SD卡
		Pub.copyBigDataToSD("scriptConfig.json", getScriptFilePath(), "scriptConfig.json");
		Pub.LOG("复制MD5所用的时间......................." + (System.currentTimeMillis() - startTime) + "毫秒");
	}

	/**
	 * 下载文件
	 *
	 * @param url
	 *            下载地址
	 * @param dir
	 *            存放路径
	 * @param handler
	 *            下载后通知
	 * @param engineId
	 *            通知ID
	 * @param isRestriction
	 *            是否限速
	 * @param boolean 是否显示现在进度界面
	 * @param sDownloadTips
	 *            下载时的提示语
	 *
	 */
	public static void LuaCallGetDownloadFile(final String url, final String dir, final float engineId, final boolean isRestriction, final boolean isShowDialog, final String sDownloadTips) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				DownloadTips = sDownloadTips;
				Downloader.getInst().getDownloadFile(url, dir, DownloadFollowUp.getInst().mDownloadActionHandler, (int) engineId, isRestriction, isShowDialog);
			}
		});
	}

	/**
	 * 下载lua脚本升级文件
	 *
	 * @param zipUrl
	 *            zip下载地址
	 * @param delUrl
	 *            删除目录下载地址
	 * @param dir
	 *            存放路径
	 * @param handler
	 *            下载后通知
	 * @param engineId
	 *            通知ID
	 * @param isRestriction
	 *            是否限速
	 * @param boolean 是否显示现在进度界面
	 * @param sDownloadTips
	 *            下载时的提示语
	 * @param callback
	 *            下载完成后回调
	 * @param restart
	 *            是否需要重启更新
	 */
	public static void getDownloadLuaUpdateFile(final String zipUrl, final int callback, final String gamePackage) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				// 下载zip
				Downloader.getInst().getScriptDownloadFile(zipUrl, getZipDownloadDir(), callback, gamePackage);
			}
		});
	}

	/**
	 * 解压下载的zip包&&删除多余文件
	 */
	public static void unZipScriptFile() {
		Pub.LOG("解压下载的zip包 === " + mUnZipFileName);
		// 解压
		String ScriptZipPath = getZipFilePath() + mUnZipFileName + ".zip";

		Pub.LOG("ScriptZipPath ============ " + ScriptZipPath);

		String UnzipScriptZipPath = "";
		if (mUnZipFileName.contains(MainScriptPackage)) {
			UnzipScriptZipPath = getScriptFilePath();
		} else {
			UnzipScriptZipPath = MiniGameScriptFilePath;
		}
		File zipFile = new File(ScriptZipPath);
		if (zipFile.exists()) {
			// 如果有zip包，则解压
			if (mUnzipAsyncTask == null) {
				mUnzipAsyncTask = new UnzipAsyncTaskForLua(ScriptZipPath, UnzipScriptZipPath, TQLuaAndroidConsole.getGameSceneInstance().mLoadhandler);
				mUnzipAsyncTask.execute();
			}
		}
	}

	/**
	 * 结束当前更新lua任务
	 */
	public static void closeCurrentTask() {
		if (mUnzipAsyncTask != null) {
			mUnzipAsyncTask.cancel(true);
			mUnzipAsyncTask = null;
		}
	}

	/**
	 * 通知lua层，脚本更新完毕
	 *
	 * @param type
	 */
	public static void callBackLuaUpdateDone(final String type) {
		Pub.LOG("unZipScriptDoneCallback ========== " + unZipScriptDoneCallback);
		if (unZipScriptDoneCallback > 0) {
			TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Pub.LOG("type#mUnZipFileName ==== " + (type + "#" + mUnZipFileName));
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(unZipScriptDoneCallback, type + "#" + mUnZipFileName);
					Cocos2dxLuaJavaBridge.releaseLuaFunction(unZipScriptDoneCallback);
					unZipScriptDoneCallback = -1;
					mUnZipFileName = null;
				}
			});
		}
	}

	/**
	 * 删除解压完成的zip文件
	 */
	public static void deleteScriptZip() {
		String ScriptZipPath = getZipFilePath() + mUnZipFileName + ".zip";

		Pub.LOG("ScriptZipPath ============ " + ScriptZipPath);
		// 删除zip包
		File zipFile = new File(ScriptZipPath);
		if (zipFile.isFile() && zipFile.exists()) {
			zipFile.delete();
		}
	}

	/**
	 * 判断是否完成解压删除文件
	 */
	public static void UpdateFileSuccess() {
		// 完成解压删除文件
		if (mUnZipFileName == null) {
			Pub.LOG("UpdateFileSuccess ======== 信息错误");
			return;
		}

		deleteScriptZip();

		closeCurrentTask();
		// 通知lua升级完成
		callBackLuaUpdateDone("Success");
	}

	/**
	 * 更新脚本失败
	 */
	public static void UpdateFileError() {

		if (mUnZipFileName == null) {
			Pub.LOG("UpdateFileError ======== 信息错误");
			return;
		}

		deleteScriptZip();

		closeCurrentTask();

		callBackLuaUpdateDone("Error");
	}

	/**
	 * 判断lua升级文件(更新脚本入口)
	 *
	 * @param gamePackage
	 * @param UpdateDoneCallback
	 */
	public static void logicLuaUpdateFile(String gamePackage, int UpdateDoneCallback) {
		if (mUnZipFileName != null) {
			Pub.LOG("有解压任务正在进行...........");
			return;
		}
		mUnZipFileName = gamePackage;

		unZipScriptDoneCallback = UpdateDoneCallback;

		unZipScriptFile();
	}
}
