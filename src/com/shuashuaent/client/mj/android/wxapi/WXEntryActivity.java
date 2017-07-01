package com.shuashuaent.client.mj.android.wxapi;

import org.shuashuaent.client.pay.weixinpay.WechatUtils;
import org.shuashuaent.client.utils.Pub;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.widget.Toast;

import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.shuashuaent.client.game.TQLuaAndroidConsole;
import com.shuashuaent.client.mj.android.R;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

	// IWXAPI 是第三方app和微信通信的openapi接口
	private IWXAPI api;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_wxentry);
		// 通过WXAPIFactory工厂，获取IWXAPI的实例
		api = WXAPIFactory.createWXAPI(this, TQLuaAndroidConsole.getWXAppID(), false);
		api.registerApp(TQLuaAndroidConsole.getWXAppID());
		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		setIntent(intent);
		api.handleIntent(intent, this);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.wxentry, menu);
		return true;
	}

	@Override
	public void onReq(BaseReq req) {
		// TODO Auto-generated method stub
		Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "req openid = " + req.openId, Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onResp(BaseResp resp) {
		// TODO Auto-generated method stub

		if (resp.getType() == ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX) {
			// 分享
			String result = "";
			switch (resp.errCode) {
			case BaseResp.ErrCode.ERR_OK:
				result = "OK";
				break;
			case BaseResp.ErrCode.ERR_USER_CANCEL:
				result = "CANCEL";
				break;
			case BaseResp.ErrCode.ERR_AUTH_DENIED:
				result = "DENIED";
				break;
			default:
				result = "OTHER";
				break;
			}
			WechatUtils.getInstance().callBackWechatShare(result);
		} else if (resp.getType() == ConstantsAPI.COMMAND_SENDAUTH) {
			// 登陆发送广播
			String code = ((SendAuth.Resp) resp).code;
			String openId = ((SendAuth.Resp) resp).openId;
			String state = ((SendAuth.Resp) resp).state;
			String transaction = ((SendAuth.Resp) resp).transaction;
			String url = ((SendAuth.Resp) resp).url;
			Pub.LOG("resp.code ============== " + code);
			Pub.LOG("resp.openId ============== " + openId);
			Pub.LOG("resp.state ============== " + state);
			Pub.LOG("resp.transaction ============== " + transaction);
			Pub.LOG("resp.url ============== " + url);

			if (code == null) {
				code = "-1";
			}
			if (state == null) {
				state = "-1";
			}

			final String WeChatLoginToken = code + "#" + openId + "#" + state + "#" + transaction + "#" + url;
			WechatUtils.getInstance().callBackWechatLogin(WeChatLoginToken);
		} else if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
			// 微信支付回调
			// if (resp.errCode == BaseResp.ErrCode.ERR_OK) {
			// // 微信支付成功
			// // 成功
			// } else {
			// }
		}
		finish();
	}
}
