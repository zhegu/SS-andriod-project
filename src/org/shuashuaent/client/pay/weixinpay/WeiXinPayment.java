package org.shuashuaent.client.pay.weixinpay;

import java.util.HashMap;

import org.shuashuaent.client.utils.Pub;

import com.tencent.mm.sdk.constants.Build;
import com.tencent.mm.sdk.modelpay.PayReq;

public class WeiXinPayment {

	public static WeiXinPayment mWeiXinPayment;

	public static WeiXinPayment getInstance() {
		if (mWeiXinPayment == null) {
			mWeiXinPayment = new WeiXinPayment();
		}
		return mWeiXinPayment;
	}

	/**
	 * 是否支持支付
	 *
	 * @return
	 */
	public boolean isPaySupported() {
		boolean isPaySupported = WechatConfig.getInstance().getWechatAPI().getWXAppSupportAPI() >= Build.PAY_SUPPORTED_SDK_INT;
		return isPaySupported;
	}

	public void sendPayReq(HashMap<String, String> weixinMap) {
		if (weixinMap == null) {
			return;
		}
		PayReq req = new PayReq();
		req.appId = weixinMap.get("appid");// Constants.APP_ID;
		req.partnerId = weixinMap.get("partnerid");// Constants.PARTNER_ID;
		req.prepayId = weixinMap.get("prepayid");// result.prepayId;
		req.nonceStr = weixinMap.get("noncestr");// nonceStr;
		req.timeStamp = weixinMap.get("timestamp");// String.valueOf(timeStamp);
		req.packageValue = weixinMap.get("package");// "Sign=" +
		req.sign = weixinMap.get("sign");

		Pub.LOG("appId === " + req.appId);
		Pub.LOG("partnerId === " + req.partnerId);
		Pub.LOG("prepayId === " + req.prepayId);
		Pub.LOG("nonceStr === " + req.nonceStr);
		Pub.LOG("timeStamp === " + req.timeStamp);
		Pub.LOG("packageValue === " + req.packageValue);
		Pub.LOG("sign === " + req.sign);

		// 在支付之前，如果应用没有注册到微信，应该先调用IWXMsg.registerApp将应用注册到微信
		WechatConfig.getInstance().getWechatAPI().sendReq(req);
	}
}
