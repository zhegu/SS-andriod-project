package com.shuashuaent.client.mj.android;

import java.util.ArrayList;

import org.shuashuaent.client.utils.Pub;
import org.shuashuaent.client.utils.res.RemoteResMgr;

import android.app.Application;
import android.app.Service;


public class GameApplication extends Application {

	private RemoteResMgr mRemoteResourceMgr;

	private static GameApplication instance;


	public static GameApplication getInstance() {
		return instance;
	}

	@Override
	public void onCreate() {
		super.onCreate();

		instance = this;

		mRemoteResourceMgr = new RemoteResMgr(this);
		Thread th = new Thread(mRemoteResourceMgr);
		th.start();
		Pub.getSaveFilePath();
	}

	// 服务列表
	private ArrayList<Service> serviceList = new ArrayList<Service>();

	public void addService(Service service) {
		serviceList.add(service);
	}

	public void removeService(Service service) {
		serviceList.remove(service);
	}

	public int getServiceCnt() {
		return serviceList.size();
	}
}
