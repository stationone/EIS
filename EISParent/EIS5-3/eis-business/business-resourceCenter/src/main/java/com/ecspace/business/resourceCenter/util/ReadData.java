package com.ecspace.business.resourceCenter.util;

import java.io.*;
import java.util.Properties;

public class ReadData {
	//去读取配置文件
//	public static String WEBPATH ="src/data.properties";//在本地运行时
	public static String WEBPATH ="/WEB-INF/classes/data.properties";//其启动tomcat时

//    public static String webPath = "src/data.properties";
	public static String webPath = WEBPATH;

	private static Properties prop = null;

	//超级管理员
	public static String administrator = null;

	//超级管理员
	public static String superAdmin = null;

	//文件管理员(后期需从数据库中选择)
	public static String fileManager = null;

	//tomcat地址
	public static String tomcatPath = null;

	//svn本地版本仓库 E:/Repositories
	public static String repositories = null;

	//版本库	 pdm_zongti
	@Deprecated
	public static String repository = null;

	//svn_Service发布路径
	@Deprecated
	public static String svn_Service = null;

	//svn路径
	public static String svnURL = null;

	//密码，用户登录密码
	public static String password = null;

	//设置svn用户默认密码
	public static String svnPassword = null;

	//svn工作副本
	public static String svnWorkCopy = null;

	//svn工作副用户组
	public static String userGroup = "userGroup";

	//下载地址
	public static String download = null;

	//服务器目录
	private static String workingPath = null;

	//webService访问地址
	public static String webServiceURL = null;

	//项目classPath地址
	public static String classPath = null;


	static {
		if(prop == null){
			File file = new File(webPath);
			if(file.exists()){
				load();
//				try {
//					FileInputStream fis = new FileInputStream(file);
//					BufferedInputStream buf=new BufferedInputStream(fis);
//
//					prop=new Properties();
//					prop.load(new InputStreamReader(buf,"utf-8"));
//
//					//系统管理员
//					administrator = prop.getProperty("superAdmin").trim();
//
//					//超级管理员
//					superAdmin = prop.getProperty("superAdmin").trim();
//
//					//文件管理员(此数据后期需要从数据库中选择)
//					fileManager = prop.getProperty("fileManager").trim();
//
//					tomcatPath = prop.getProperty("tomcatPath").trim();
//
//					repositories = prop.getProperty("repositories").trim();
//
////					svn_Service = prop.getProperty("Svn_Service").trim();
//
//					svnURL = prop.getProperty("svnURL").trim();
//
//                    password = prop.getProperty("password").trim();
//
//					svnPassword = prop.getProperty("svnDefaultPassword").trim();
//
//					workingPath = prop.getProperty("workingPath").trim();
//
//					svnWorkCopy = workingPath + SvnConfigUtil.fileSeparate + prop.getProperty("svnWorkCopy").trim();
//
//					download = workingPath + SvnConfigUtil.fileSeparate + prop.getProperty("download").trim();
//
//					webServiceURL = prop.getProperty("PDM_Service").trim();
//
//
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
			}

		}

	}

	/**
	 *
	 * @throws Exception
	 */
	public static void load(){
		InputStream in= null;
		try {
			in = new BufferedInputStream(new FileInputStream(webPath));
			prop=new Properties();
			prop.load(new InputStreamReader(new BufferedInputStream(in),"utf-8"));
		}catch (IOException e) {
			System.err.println("读取配置文件错误，请检查配置文件：data.properties 是否存在");
			return;
		}finally {
			if(in != null){
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		//系统管理员
		administrator = prop.getProperty("superAdmin").trim();

		//超级管理员
		superAdmin = prop.getProperty("superAdmin").trim();

		//文件管理员(此数据后期需要从数据库中选择)
		fileManager = prop.getProperty("fileManager").trim();

		tomcatPath = prop.getProperty("tomcatPath").trim();

		repositories = prop.getProperty("repositories").trim();

		svnURL = prop.getProperty("svnURL").trim();

		password = prop.getProperty("password").trim();

		svnWorkCopy = prop.getProperty("svnWorkCopy").trim();

		download = prop.getProperty("download").trim();

		workingPath = tomcatPath + SvnConfigUtil.fileSeparate + prop.getProperty("workingPath").trim();
		System.out.println("工作副本地址:"+workingPath);
		svnWorkCopy = workingPath + SvnConfigUtil.fileSeparate + prop.getProperty("svnWorkCopy").trim();

		download = workingPath + SvnConfigUtil.fileSeparate + prop.getProperty("download").trim();

		webServiceURL = prop.getProperty("PDM_Service").trim();

		classPath = tomcatPath + SvnConfigUtil.fileSeparate + prop.getProperty("classPath").trim();

	}

	
	/*读取pdm发布的webservice路径*/
	public  static String readPdmServiceURL() {
		String PDM_SERVICE = "";
		try{
			if(prop == null){
				load();
				 PDM_SERVICE = prop.getProperty("PDM_Service").trim();
			}else{
				  PDM_SERVICE = prop.getProperty("PDM_Service").trim();
			}
		}catch(Exception e){
			System.out.println("读取PDM_SERVICE出错....");
			e.printStackTrace();
		}
		return PDM_SERVICE;
	}
	
	
	/*读取svn的webservice路径*/
	public  static String readSvnServiceURL(){
		String SVN_SERVICE = "";
		try{
			if(prop == null){
				load();
				 SVN_SERVICE = prop.getProperty("Svn_Service").trim();
			}else{
				SVN_SERVICE = prop.getProperty("Svn_Service").trim();
			}
		}catch(Exception e){
			System.out.println("读取PDM_SERVICE出错....");
			e.printStackTrace();
		}
		return SVN_SERVICE;
	}
	
	
	public static String readName(){
		String NAME = "";
		try{
			if(prop == null){
				load();
				 NAME =prop.getProperty("name").trim();
			}else{
				 NAME =prop.getProperty("name").trim();
			}
		}catch(Exception e){
			System.out.println("读取NAME出错....");
			e.printStackTrace();
		}
		return NAME;
	}
	@Deprecated
	public static String readPassword(){
		String PASSWORD = "";
		try{
			if(prop == null){
				load();
				 PASSWORD =prop.getProperty("password").trim();
			}else{
				 PASSWORD =prop.getProperty("password").trim();
			}
		}catch(Exception e){
			System.out.println("读取PASSWORD出错....");
			e.printStackTrace();
		}
		return PASSWORD;
	}
	/**
	 * 读取配置文件中的地址
	 * @return svn 的url地址
	 */
	@Deprecated
	public static String readurl(){
		String URL = "";
//		try{
//			//判断
//			if(prop == null){
//				  URL=prop.getProperty("url").trim();
//			}else{
//				  URL=prop.getProperty("url").trim();
//			}
//		}catch(Exception e){
//			System.out.println("读取URL出错....");
//			e.printStackTrace();
//		}
		return URL;
	}

	@Deprecated
	public static String readLocalPath(){
		String LOCALPATH = "";
//		try{
//			if(prop == null){
//				load();
//				 LOCALPATH=prop.getProperty("localpath").trim();
//			}else{
//				LOCALPATH=prop.getProperty("localpath").trim();
//			}
//		}catch(Exception e){
//			System.out.println("读取localpath出错....");
//			e.printStackTrace();
//		}
		return LOCALPATH;
	}


	//版本库
	@Deprecated
	public static String readRoom() {
		String ROOM = "";
		try {
			if (prop == null) {
				load();
				ROOM = prop.getProperty("defaultroom").trim();
			} else {
				ROOM = prop.getProperty("defaultroom").trim();
			}
		} catch (Exception e) {
			System.out.println("读取ROOM出错....");
			e.printStackTrace();
		}
		return ROOM;
	}

	public static String readUploadDir() {
		String UPLOADTEMPDIR = "";
		try {
			if (prop == null) {
				load();
				UPLOADTEMPDIR = prop.getProperty("uploadTempDir").trim();
			} else {
				  UPLOADTEMPDIR = prop.getProperty("uploadTempDir").trim();
			}
		} catch (Exception e) {
			System.out.println("读取ROOM出错....");
			e.printStackTrace();
		}
		return UPLOADTEMPDIR;
	}

	@Deprecated
	public static String readDownPath() {
		String DOWNLOADBASE = "";
		try {
			if (prop == null) {
				load();
				  DOWNLOADBASE = prop.getProperty("downLoadBase").trim();
			} else {
				  DOWNLOADBASE = prop.getProperty("downLoadBase").trim();
			}
		} catch (Exception e) {
			System.out.println("读取DOWNLOADBASE出错....");
			e.printStackTrace();
		}
		return DOWNLOADBASE;
	}

	/**
	 * 获取工作副本地址
	 * @return 返回本地工作副本地址 如: E:/pdm/WorkCopy
	 */
	@Deprecated
	public static String readWorkCopy(){
		String WORKCOPY = "";
		System.out.println("这是获取本地工作副本地址：-----------------------");
		try {
			if (prop == null) {
				  load();
				  WORKCOPY = prop.getProperty("LocalWorkCopy").trim();
			} else {
				  WORKCOPY = prop.getProperty("LocalWorkCopy").trim();
			}
			System.out.println("获取的地址："+WORKCOPY);
		} catch (Exception e) {
			System.out.println("读取ROOM出错....");
			e.printStackTrace();
		}
		return WORKCOPY;
	}

	public static int readMaxUploadSize(){
		String MAX= "";
		try {
			if (prop == null) {
				load();
				MAX = prop.getProperty("MaxUploadSize").trim();
			} else {
				MAX = prop.getProperty("MaxUploadSize").trim();
			}
		} catch (Exception e) {
			System.out.println("读取MAX出错....");
			e.printStackTrace();
		}
		int max = 1;
		String[] strs= MAX.split("\\*");
		for(int i = 0 ; i < strs.length; i ++){
			max = max * Integer.valueOf(strs[i]);
		}
		return max;
	}

	public static String readTomcatPath(){
		String TOMCATPATH = "";
		try{
			if(prop == null){
					load();
				 TOMCATPATH = prop.getProperty("tomcatPath").trim();
			}else{
				 TOMCATPATH = prop.getProperty("tomcatPath").trim();
			}
		}catch(Exception e){
			System.out.println("读取TOMCATPATH出错....");
			e.printStackTrace();
		}
		return TOMCATPATH;
	}


	public static void main(String[] args) {

		String name = "fileManagser";

		boolean flag = true;
//		if("admin".equals(name)){
//			flag = false;
//		}
//		if("fileManager".equals(name)){
//			flag = false;
//		}
//		if(flag){
//			System.out.println("不相同:"+name);
//		}


		if(!"admin".equals(name) & !"fileManager".equals(name)){
			System.out.println("不相同:"+name);
		}



//		String catalogPath = "text1/text-2/text-2-1/文件测试";
//
//		catalogPath = catalogPath.substring(catalogPath.indexOf("/"),catalogPath.length());
//		System.out.println(catalogPath);

//		SvnClientManage svnClientManage = new SvnClientManage("1903121443285768940",ReadData.password,ReadData.svnURL);
//		System.out.println(ReadData.svnURL);
//		SvnImpl svn = svnClientManage.getMethod();
//		svn.setSvnClientManage(svnClientManage);
////		String fileName = "StarUML%20Setup%203.0.2.exe";
////		String fileName = "navicat121_premium_cs_x64.exe";
//		String fileName = "StarUML 20Setup 203.0.2.exe";
//		List<FileInfo> fileInfos = svn.getFileHistoryInfos("https://lvkailiang/svn/pdm_1/text/text1-2", fileName);
//		System.out.println(fileInfos);

//		String fileName = "pdm_1/%E7%89%B9%E6%95%88%E5%9B%BE/StarUML%20Setup%203.0.2.exe";
//		String fileName = "pdm_1/%E7%89%B9%E6%95%88%E5%9B%BE/%E7%89%B9%E6%95%88%E5%9B%BE%20%E7%A9%BA%E6%A0%BC%20%E6%B5%8B%E8%AF%95/FiddlerSetup.exe";
////		String fileName = "pdm_1/%E7%89%B9%E6%95%88%E5%9B%BE/%E7%89%B9%E6%95%88%E5%9B%BE%20%E7%A9%BA%E6%A0%BC%20%E6%B5%8B%E8%AF%95/%E5%B8%A6%E7%A9%BA%E6%A0%BC%E7%9A%84%E4%B8%AD%E6%96%87%E6%96%87%20%E4%BB%B6%E6%B5%8B%E8%AF%95.txt";
//
//		System.out.println(fileName.replaceAll("%20"," "));


//		String asd = "%E7%89%B9%E6%95%88%E5%9B%BE";
//		try {
//			byte[] bytes = asd.getBytes("gbk");
//			String aa = new String(bytes,"utf-8");
//			System.out.println("sout:"+aa);
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}


	}


}
