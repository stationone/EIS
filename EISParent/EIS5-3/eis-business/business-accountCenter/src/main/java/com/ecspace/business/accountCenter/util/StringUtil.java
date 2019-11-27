package com.ecspace.business.accountCenter.util;

/**
 * 字符串相关公共方法
 */
public class StringUtil {

	//判断是否为空
	public static boolean isEmpty(String str) {
		if(str == null || "".equals(str.trim())) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 去空格
	 * @Author lv
	 * @param string
	 * @return
	 */
	public static String goOutSpace(String string){
		if(string == null || string.isEmpty()){
			return null;
		}
		String resulr = string.trim();
		if(resulr.isEmpty()){
			return null;
		}
		return resulr;
	}





}
