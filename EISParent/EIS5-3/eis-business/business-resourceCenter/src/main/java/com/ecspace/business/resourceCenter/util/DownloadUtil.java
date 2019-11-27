package com.ecspace.business.resourceCenter.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

/**
 * 下载资源
 * @author tongy
 *
 */
public class DownloadUtil {
	public static boolean downloadFile(HttpServletRequest request, HttpServletResponse response, String filePath) {
		File file = new File(filePath);
		String filenames = file.getName();
		InputStream inputStream;
		try {

			inputStream = new BufferedInputStream(new FileInputStream(file));
			byte[] buffer = new byte[inputStream.available()];
			inputStream.read(buffer);
			inputStream.close();
			//response.reset();
			// 先去掉文件名称中的空格,然后转换编码格式为utf-8,保证不出现乱码,这个文件名称用于浏览器的下载框中自动显示的文件名
			response.addHeader("Content-Disposition", "attachment;filename=" + new String(filenames.replaceAll(" ", "").getBytes("utf-8"), "iso8859-1"));
			response.addHeader("Content-Length", "" + file.length());
			OutputStream os = new BufferedOutputStream(response.getOutputStream());
			response.setContentType("application/octet-stream");
			os.write(buffer);// 输出文件
			os.flush();
			os.close();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}


	public static boolean downloadFiles(HttpServletRequest request, HttpServletResponse response, String filePath) {
		File file = new File(filePath);
		String filenames = file.getName();
		InputStream inputStream;
		try {

			// 先去掉文件名称中的空格,然后转换编码格式为utf-8,保证不出现乱码,这个文件名称用于浏览器的下载框中自动显示的文件名
			response.addHeader("Content-Disposition", "attachment;filename=" + new String(filenames.replaceAll(" ", "").getBytes("utf-8"), "iso8859-1"));
			response.addHeader("Content-Length", "" + file.length());

			response.setContentType("application/octet-stream");

			OutputStream os = new BufferedOutputStream(response.getOutputStream());

			inputStream = new BufferedInputStream(new FileInputStream(file));
			byte[] buffer = new byte[1024];
			int flag = 0;
			while (inputStream.read(buffer) != -1){
				os.write(buffer);// 输出文件
			}
			os.flush();
			inputStream.close();
			os.close();
			System.out.println("成功");
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("失败");
			return false;
		}
	}
}
