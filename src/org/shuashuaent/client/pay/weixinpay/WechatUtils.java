package org.shuashuaent.client.pay.weixinpay;

import java.io.ByteArrayOutputStream;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.shuashuaent.client.utils.Pub;

import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.widget.Toast;

import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.shuashuaent.client.game.TQLuaAndroidConsole;

public class WechatUtils {

	public static WechatUtils mWXShareUtils;

	public static WechatUtils getInstance() {
		if (mWXShareUtils == null) {
			mWXShareUtils = new WechatUtils();
		}
		return mWXShareUtils;
	}

	// ------------------微信登录start------------------------//
	public static int WeChatLoginCallBackLua = -1;// 微信登录回调

	public static void getWechatUserinfo(final int callBack, final String loginState) {
		if (hasWechatAPP() == false) {
			Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "没有微信不能使用【微信登录】哦！", Toast.LENGTH_LONG).show();
			return;
		}
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				WeChatLoginCallBackLua = callBack;
				WechatUtils.getInstance().startWechatLogin(loginState);
			}
		});
	}

	/**
	 * 微信登录接口
	 *
	 * @param state
	 */
	public void startWechatLogin(String state) {
		final SendAuth.Req req = new SendAuth.Req();
		req.scope = "snsapi_userinfo";
		req.state = state;
		WechatConfig.getInstance().getWechatAPI().sendReq(req);
	}

	/**
	 * 微信登录回调
	 *
	 * @param WeChatLoginToken
	 */
	public void callBackWechatLogin(final String WeChatLoginToken) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Pub.LOG("resp  WeChatLoginToken  ============== " + WeChatLoginToken);
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(WeChatLoginCallBackLua, WeChatLoginToken);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(WeChatLoginCallBackLua);
			}
		});
	}

	// ------------------微信登录end------------------------//

	// ------------------微信分享start------------------------//

	private int shareCallBack = -1;// 分享后的回调方法

	// private static String AppDownLoadURL = "";// 游戏分享后的下载地址

	// 设置微信分享的app下载URL
	// public static void setWeChatShareAppDownLoadURL(String sAppDownLoadURL) {
	// AppDownLoadURL = sAppDownLoadURL;
	// Pub.LOG("test setWeChatShareAppDownLoadURL URI == " + AppDownLoadURL);
	// }

	public static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		bmp.compress(CompressFormat.JPEG, 100, output);
		if (needRecycle) {
			bmp.recycle();
		}

		byte[] result = output.toByteArray();
		try {
			output.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 调用微信分享功能
	 *
	 * @param isCircle
	 *            是否分享到朋友圈,1为朋友圈,0为好友
	 * @return
	 */
	public static void luaCallWXShare(final float isCircle, final float userID, final int callBack, final String showTitle, final String showMessage, final String shareUrl) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				WechatUtils.getInstance().shareToWX((int) isCircle, (int) userID, callBack, showTitle, showMessage, shareUrl);
			}
		});
	}

	/**
	 * 调用微信分享功能
	 *
	 * @param isCircle
	 *            是否分享到朋友圈,1为朋友圈,0为好友
	 */
	public void shareToWX(int isCircle, int userID, int callBack, String showTitle, String showMessage, String shareUrl) {
		shareCallBack = callBack;

		// 判断是否安装了微信
		if (WechatConfig.getInstance().getWechatAPI().isWXAppInstalled() == false) {
			Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "不装微信不能分享给好友哦！", Toast.LENGTH_LONG).show();
			return;
		}

		WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = shareUrl;
		WXMediaMessage msg = new WXMediaMessage(webpage);
		msg.title = showTitle;
		msg.description = showMessage;
		// 图片不能超过32K,否则无法弹出微信页面
		Bitmap thumb = TQLuaAndroidConsole.getWXShareBitmap();
		msg.thumbData = WechatUtils.getInstance().bmpToByteArray(thumb, true);
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		if (isCircle == 1) {
			// 分享到朋友圈
			// isTimelineCb.isChecked();
			// SendMessageToWX.Req.WXSceneTimeline;
			// SendMessageToWX.Req.WXSceneSession;
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
		} else {
			// 分享到好友
			req.scene = SendMessageToWX.Req.WXSceneSession;
		}
		req.openId = null;
		WechatConfig.getInstance().getWechatAPI().sendReq(req);
	}
	/**
	 * 调用微信分享图片功能
	 *
	 * @param isCircle
	 *            是否分享到朋友圈,1为朋友圈,0为好友
	 * @return
	 */
	public static void luaCallWXSharePic(final float isCircle, final float userID, final int callBack, final String iconPath, final String picPath) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				WechatUtils.getInstance().shareToWXPic((int) isCircle, (int) userID, callBack, iconPath, picPath);
			}
		});
	}
	/**
	 * 调用微信分享图片功能
	 *
	 * @param isCircle
	 *            是否分享到朋友圈,1为朋友圈,0为好友
	 */
	public void shareToWXPic(int isCircle, int userID, int callBack, String iconPath, String picPath) {
		shareCallBack = callBack;

		// 判断是否安装了微信
		if (WechatConfig.getInstance().getWechatAPI().isWXAppInstalled() == false) {
			Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "不装微信不能分享给好友哦！", Toast.LENGTH_LONG).show();
			return;
		}

		Bitmap bmp = BitmapFactory.decodeFile(picPath);
		//初始化WXImageObject和WXMediaMessage对象
		WXImageObject imgObj = new WXImageObject(bmp);
		WXMediaMessage msg = new WXMediaMessage();
		msg.mediaObject = imgObj;

		//设置缩略图
		Bitmap thumbBmp = BitmapFactory.decodeFile(iconPath);
		bmp.recycle();
		msg.thumbData =  WechatUtils.getInstance().bmpToByteArray(thumbBmp,true);

		//构造一个Req
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("img");//transaction 字段用于唯一标识一个请求
		req.message = msg;
		if (isCircle == 1) {
			// 分享到朋友圈
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
		} else {
			// 分享到好友
			req.scene = SendMessageToWX.Req.WXSceneSession;
		}

		//调用api接口 发送数据到微信
		WechatConfig.getInstance().getWechatAPI().sendReq(req);
	}

	private String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}

	/**
	 * 微信分享回调
	 *
	 * @param callBackString
	 */
	public void callBackWechatShare(final String callBackString) {
		TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(shareCallBack, callBackString);
				Cocos2dxLuaJavaBridge.releaseLuaFunction(shareCallBack);
			}
		});
	}

	// ------------------微信分享end------------------------//

	/**
	 * 判断当前设备是否安装微信客户端
	 *
	 * @return
	 */
	public static boolean hasWechatAPP() {
		return WechatConfig.getInstance().getWechatAPI().isWXAppInstalled();
	}
}
