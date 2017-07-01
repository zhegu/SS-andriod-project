package org.shuashuaent.client.utils.res;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Random;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.RectF;

/**
 * 当没有存储卡时，缓存管理
 */
public class NullDiskCache implements DiskCache {
	private static final String TAG = "NullDiskCache";
	// private static final int MIN_FILE_SIZE_IN_BYTES = 100;

	private File mFilesCache;

	public NullDiskCache(Context context, String dirPath, String name) {
		// Lets make sure we can actually cache things!
		File baseDirectory = new File(context.getFilesDir().getAbsolutePath(), dirPath);

		File storageDirectory = new File(baseDirectory, name);
		createDirectory(storageDirectory);
		mFilesCache = storageDirectory;
		cleanupSimple();
		// clear();
	}

	/*
     *
     *
     */
	@Override
	public boolean exists(String key) {
		return getFile(key).exists();
	}

	public File getFile(String hash) {
		// Pub.LOG("filepath............:"+mFilesCache.toString() +
		// File.separator + hash);
		return new File(mFilesCache.toString() + File.separator + hash);
	}

	public InputStream getInputStream(String hash) throws IOException {
		if (exists(hash))
			return (InputStream) new FileInputStream(getFile(hash));
		else
			return null;
	}

	public InputStream Bitmap2InputStream(Bitmap bm, int quality) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		bm.compress(Bitmap.CompressFormat.PNG, quality, baos);
		InputStream is = new ByteArrayInputStream(baos.toByteArray());
		return is;
	}

	/**
	 * 把bitmap转成圆形
	 * */
	public Bitmap toRoundBitmap(Bitmap bitmap) {
		int width = bitmap.getWidth();
		int height = bitmap.getHeight();
		int r = 0;
		// 取最短边做边长
		if (width < height) {
			r = width;
		} else {
			r = height;
		}
		// 构建一个bitmap
		Bitmap backgroundBm = Bitmap.createBitmap(width, height, Config.ARGB_8888);
		// new一个Canvas，在backgroundBmp上画图
		Canvas canvas = new Canvas(backgroundBm);
		Paint p = new Paint();
		// 设置边缘光滑，去掉锯齿
		p.setAntiAlias(true);
		RectF rect = new RectF(0, 0, r, r);
		// 通过制定的rect画一个圆角矩形，当圆角X轴方向的半径等于Y轴方向的半径时，
		// 且都等于r/2时，画出来的圆角矩形就是圆形
		canvas.drawRoundRect(rect, r / 2, r / 2, p);
		// 设置当两个图形相交时的模式，SRC_IN为取SRC图形相交的部分，多余的将被去掉
		p.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		// canvas将bitmap画在backgroundBmp上
		canvas.drawBitmap(bitmap, null, rect, p);
		return backgroundBm;
	}

	public void store(String key, InputStream is, boolean isNeedRoundPhoto) {
		// Pub.LOG("store....path:"+getFile(key).getPath());
		is = new BufferedInputStream(is);
		FileOutputStream fos = null;
		OutputStream os = null;
		try {
			if (isNeedRoundPhoto) {
				Bitmap bitmap = BitmapFactory.decodeStream(is);
				// 把bitmap转成圆形
				bitmap = toRoundBitmap(bitmap);

				is = Bitmap2InputStream(bitmap, 100);
			}

			fos = new FileOutputStream(getFile(key));
			os = new BufferedOutputStream(fos);
			byte[] b = new byte[2048];
			int count;
			int total = 0;

			while ((count = is.read(b)) > 0) {
				os.write(b, 0, count);
				total += count;
			}

		} catch (IOException e) {
			return;
		} finally {
			try {
				if (os != null) {
					os.close();
					os = null;
				}
				if (fos != null) {
					fos.close();
					fos = null;
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void invalidate(String key) {
		// getFile(key).delete();
	}

	/**
	 * 存储的文件过多，随机删除其中的20个文件
	 *
	 */
	public void cleanupSimple() {
		final int maxNumFiles = 500;
		final int delNumFiles = 20;
		String[] children = mFilesCache.list();

		if (children != null) {

			if (children.length > maxNumFiles) {
				Random random = new Random();
				int length = children.length;
				int interval = 0;
				if (length > 0) {
					interval = Math.abs(random.nextInt()) % length;
				}
				for (int i = 0; i < delNumFiles; i++) {
					int index = (interval + i) % maxNumFiles;
					File child = new File(mFilesCache, children[index]);
					child.delete();

				}
			}
		}
	}

	/*
	 *
	 * 将缓存中的文件全部删除
	 */
	public void clear() {
		String[] children = mFilesCache.list();
		if (children != null) { // children will be null if hte directyr does
			// not exist.
			for (int i = 0; i < children.length; i++) {
				File child = new File(mFilesCache, children[i]);
				child.delete();
			}
		}
		// mFilesCache.delete();//暂时不删除目录
	}

	/*
	 * 建立存储目录
	 */
	private static final void createDirectory(File storageDirectory) {
		if (!storageDirectory.exists()) {
			storageDirectory.mkdirs();
		}
	}

	@Override
	public void cleanup() {
		// TODO Auto-generated method stub

	}

}
