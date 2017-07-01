package org.shuashuaent.client.utils.res;

public class DownloadTask {

	public int mResID;
	public String mUrl;
	public boolean done;
	public boolean mbIsRoundPhoto;

	public DownloadTask(int resID, String url, boolean isRoundPhoto) {
		mResID = resID;
		mUrl = url;
		mbIsRoundPhoto = isRoundPhoto;
	}

	public String toString() {
		return "下载任务" + mResID + "(" + mUrl + ")";
	}
}
