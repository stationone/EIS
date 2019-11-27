package com.ecspace.business.resourceCenter.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

/**
 * 自动生成TNO
 *
 */
public class IdGenerator {

	/**
	 * 前八位数（20150826）是年月日格式化：yyyyMMdd
	 * 接下来的9位数是（617496123）：时分秒毫秒的格式化HHmmssSSS
	 * 最后两位是（94）：随机生成
	 * @return
	 */
	public static String generate() {
	    String date = new SimpleDateFormat("yyMMdd").format(new Date());
	    String seconds = new SimpleDateFormat("HHmmSSS").format(new Date());
	    String tNO = date+seconds+getRandomSix();
	    return tNO;
	}

	/**
	 * 随机生成6位
	 * @return
	 */
	public static String getRandomSix(){
		Random rad=new Random();
		StringBuffer result = new StringBuffer();
		for(int i = 0 ;i<6;i++){
			result.append(rad.nextInt(10));
		}
		return result.toString();
	}

	/**
	 * 生成资源编号
	 * @param parentNO
	 * @param maxNO
	 * @return
	 */
	public static String getResourceNO(String parentNO, String maxNO) {
		String NO = "";
		if(!("0").equals(parentNO)) {
			NO += parentNO;
		}
		if(maxNO == null) {
			maxNO = "0";
		} else {
			maxNO = maxNO.substring(maxNO.length() - 2);
		}
		if(Integer.parseInt(maxNO) < 9) {
			NO += "0" + (Integer.parseInt(maxNO) + 1) + "";
		} else {
			NO += (Integer.parseInt(maxNO) + 1) + "";
		}
		return NO;
	}


}
