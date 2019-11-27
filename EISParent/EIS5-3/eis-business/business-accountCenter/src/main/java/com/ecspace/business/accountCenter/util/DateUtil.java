package com.ecspace.business.accountCenter.util;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * 日期工具类
 * @author tongy
 *
 */
public class DateUtil {

	private static final String format = "yyyy-MM-dd HH:mm:ss";

	/**
	 * 日期转字符串
	 * @param date
	 * @return
	 */
	public static String formatDateToString(Date date){
		if(date == null){
			return "";
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		return simpleDateFormat.format(date);
	}

	//日期格式化为字符串
	public static String formatDateToString(Date date, String format) {
		String result = "";
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		if(date != null) {
			result = sdf.format(date);
		}
		return result;
	}
	
	//字符串格式化为日期类型
	public static Date formatStringToDate(String str, String format) throws ParseException {
		if(StringUtil.isEmpty(str)) {
			return null;
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.parse(str);
	}
	
	//获取当前时间
	public static String getCurrentDateStr(String format) {
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}

	/**
	 * 获取日期
	 * @return
	 */
	public static Date getDate(){
		Date date = null;
		try {
			date = formatStringToDate(getCurrentDateStr(format),format);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	/**
	 * 字符串日期转Timestamp格式
	 * @param time 2019-01-01 00:00:00
	 */
	public static Timestamp stringDateToTimestamp(String time){
		DateFormat formats = new SimpleDateFormat(format);
		formats.setLenient(false);
        Timestamp ts = null;
		try {
			ts = new Timestamp(formats.parse(time).getTime());
		} catch (ParseException e) {

			e.printStackTrace();
		}
		return ts;
	}
}
