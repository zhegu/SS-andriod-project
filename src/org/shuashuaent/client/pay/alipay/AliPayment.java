package org.shuashuaent.client.pay.alipay;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.shuashuaent.client.entity.ProductDetail;
import org.shuashuaent.client.utils.DownloadFollowUp;
import org.shuashuaent.client.utils.Downloader;
import org.shuashuaent.client.utils.Pub;

import android.content.pm.PackageInfo;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.widget.Toast;

import com.alipay.sdk.app.PayTask;
import com.shuashuaent.client.game.TQLuaAndroidConsole;

public class AliPayment {

	public static AliPayment mAliPayment;

	public static AliPayment getInstance() {
		if (mAliPayment == null) {
			mAliPayment = new AliPayment();
		}
		return mAliPayment;
	}

	private static final int SDK_PAY_FLAG = 1;

	private static final int SDK_CHECK_FLAG = 2;

	private Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case SDK_PAY_FLAG: {
				PayResult payResult = new PayResult((String) msg.obj);

				// 支付宝返回此次支付结果及加签，建议对支付宝签名信息拿签约时支付宝提供的公钥做验签
				String resultInfo = payResult.getResult();

				String resultStatus = payResult.getResultStatus();

				// 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
				if (TextUtils.equals(resultStatus, "9000")) {
					Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "支付成功", Toast.LENGTH_SHORT).show();
				} else {
					// 判断resultStatus 为非“9000”则代表可能支付失败
					// “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
					if (TextUtils.equals(resultStatus, "8000")) {
						Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "支付结果确认中", Toast.LENGTH_SHORT).show();

					} else {
						// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
						Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "支付失败", Toast.LENGTH_SHORT).show();

					}
				}
				break;
			}
			case SDK_CHECK_FLAG: {
				Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), "检查结果为：" + msg.obj, Toast.LENGTH_SHORT).show();
				break;
			}
			default:
				break;
			}
		};
	};

	/**
	 * call alipay sdk pay. 调用SDK支付
	 *
	 */
	public void startAliPay(String orderInfo) {
		// 对订单做RSA 签名
		String sign = sign(orderInfo);
		try {
			// 仅需对sign 做URL编码
			sign = URLEncoder.encode(sign, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		// 完整的符合支付宝参数规范的订单信息
		final String payInfo = orderInfo + "&sign=\"" + sign + "\"&" + getSignType();

		Runnable payRunnable = new Runnable() {

			@Override
			public void run() {
				// 构造PayTask 对象
				PayTask alipay = new PayTask(TQLuaAndroidConsole.getGameSceneInstance());
				// 调用支付接口，获取支付结果
				String result = alipay.pay(payInfo);

				Message msg = new Message();
				msg.what = SDK_PAY_FLAG;
				msg.obj = result;
				mHandler.sendMessage(msg);
			}
		};

		// 必须异步调用
		Thread payThread = new Thread(payRunnable);
		payThread.start();
	}

	/**
	 * check whether the device has authentication alipay account.
	 * 查询终端设备是否存在支付宝认证账户
	 *
	 */
	public void check() {
		Runnable checkRunnable = new Runnable() {

			@Override
			public void run() {
				// 构造PayTask 对象
				PayTask payTask = new PayTask(TQLuaAndroidConsole.getGameSceneInstance());
				// 调用查询接口，获取查询结果
				boolean isExist = payTask.checkAccountIfExist();

				Message msg = new Message();
				msg.what = SDK_CHECK_FLAG;
				msg.obj = isExist;
				mHandler.sendMessage(msg);
			}
		};

		Thread checkThread = new Thread(checkRunnable);
		checkThread.start();

	}

	/**
	 * get the sdk version. 获取SDK版本号
	 *
	 */
	public void getSDKVersion() {
		PayTask payTask = new PayTask(TQLuaAndroidConsole.getGameSceneInstance());
		String version = payTask.getVersion();
		Toast.makeText(TQLuaAndroidConsole.getGameSceneInstance(), version, Toast.LENGTH_SHORT).show();
	}

	/**
	 * create the order info. 创建订单信息
	 *
	 */
	public String getOrderInfo(ProductDetail product, String orderID) {

		// 签约合作者身份ID
		String orderInfo = "partner=" + "\"" + mAliPayMap.get("PARTNER") + "\"";

		// 签约卖家支付宝账号
		orderInfo += "&seller_id=" + "\"" + mAliPayMap.get("SELLER") + "\"";

		// 商户网站唯一订单号
		orderInfo += "&out_trade_no=" + "\"" + orderID + "\"";

		// 商品名称
		orderInfo += "&subject=" + "\"" + product.goodsName + "\"";

		// 商品详情
		orderInfo += "&body=" + "\"" + product.goodsDetail + "\"";

		// 商品金额
		orderInfo += "&total_fee=" + "\"" + product.goodsPriceDetail.replace("价格:￥", "") + "\"";

		// 服务器异步通知页面路径
		orderInfo += "&notify_url=" + "\"" + mAliPayMap.get("SERVER_URL") + "\"";

		// 服务接口名称， 固定值
		orderInfo += "&service=\"" + mAliPayMap.get("SERVICE") + "\"";

		// 支付类型， 固定值
		orderInfo += "&payment_type=\"" + mAliPayMap.get("PAYMENT_TYPE") + "\"";

		// 参数编码， 固定值
		orderInfo += "&_input_charset=\"" + mAliPayMap.get("INPUT_CHARSET") + "\"";

		// 设置未付款交易的超时时间
		// 默认30分钟，一旦超时，该笔交易就会自动被关闭。
		// 取值范围：1m～15d。
		// m-分钟，h-小时，d-天，1c-当天（无论交易何时创建，都在0点关闭）。
		// 该参数数值不接受小数点，如1.5h，可转换为90m。
		orderInfo += "&it_b_pay=\"30m\"";

		// extern_token为经过快登授权获取到的alipay_open_id,带上此参数用户将使用授权的账户进行支付
		// orderInfo += "&extern_token=" + "\"" + extern_token + "\"";

		// 支付宝处理完请求后，当前页面跳转到商户指定页面的路径，可空
		orderInfo += "&return_url=\"m.alipay.com\"";

		// 调用银行卡支付，需配置此参数，参与签名， 固定值 （需要签约《无线银行卡快捷支付》才能使用）
		// orderInfo += "&paymethod=\"expressGateway\"";

		return orderInfo;
	}

	/**
	 * sign the order info. 对订单信息进行签名
	 *
	 * @param content
	 *            待签名订单信息
	 */
	public String sign(String content) {
		return SignUtils.sign(content, mAliPayMap.get("RSA_PRIVATE"));
	}

	/**
	 * get the sign type we use. 获取签名方式
	 *
	 */
	public String getSignType() {
		return "sign_type=\"RSA\"";
	}

	public int mnCallLuaFunction;

	private ProductDetail mProduct = null;

	/**
	 * lua调用获取支付宝订单信息
	 *
	 * @param goodsName
	 * @param goodsDetail
	 * @param goodsPriceDetail
	 * @param mnDiscount
	 * @param mnSubtype
	 * @param price
	 * @param isExchange
	 * @param goodsID
	 */
	public void luaCallAliPayGetOrderID(String goodsName, String goodsDetail, String goodsPriceDetail, int mnDiscount, int mnSubtype, int price, int callLuaFunction) {
		ProductDetail product = new ProductDetail();
		product.goodsName = goodsName;
		product.goodsDetail = goodsDetail;
		product.goodsPriceDetail = goodsPriceDetail;
		product.mnDiscount = mnDiscount;
		product.mnSubtype = mnSubtype;
		product.price = price;
		mnCallLuaFunction = callLuaFunction;
		mProduct = product;
		getAliPayOrderInfo();
	}

	/**
	 * 是否支持支付
	 *
	 * @return
	 */
	public boolean isPaySupported() {
		// check to see if the MobileSecurePay is already installed.
		// 检测安全支付服务是否安装
		PackageInfo pkg = Pub.getPkgInfoByName("com.alipay.android.app");
		PackageInfo pkgGphone = Pub.getPkgInfoByName("com.eg.android.AlipayGphone");
		if (pkg == null && pkgGphone == null) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * ailipay支付
	 *
	 */
	public void getAliPayOrderInfo() {
		if (isPaySupported()) {
			// prepare the order info.
			TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(mnCallLuaFunction, "");
					Cocos2dxLuaJavaBridge.releaseLuaFunction(mnCallLuaFunction);
				}
			});
		} else {
			Pub.closeProgressDialog();
			Downloader.getInst().getDownloadFile(PartnerConfig.ALIPAY_PLUGIN_NAME_URL, "download", DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_A, false, true);
		}
	}

	public int mnCallBackLua;

	public HashMap<String, String> mAliPayMap;

	public void readDBID_EXCHANGE_AliPay(String orderID, HashMap<String, String> aliPayMap, int callBackLua) {
		mAliPayMap = aliPayMap;
		mnCallBackLua = callBackLua;
		// 给服务器发送订单信息
		String orderInfo = getOrderInfo(mProduct, orderID);
		// prepare the order info.
		// 准备订单信息
		startAliPay(orderInfo);
		mProduct = null;
	}

}
