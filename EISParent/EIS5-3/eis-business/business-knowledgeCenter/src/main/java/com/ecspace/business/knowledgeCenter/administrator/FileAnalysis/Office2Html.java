package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;

import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.ComThread;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;
/*
jacob :
    启动报错 : Could not initialize class com.jacob.com.ComThread
    解决方案:
        将jacob-1.18-x64.dll 放在jdk1.8.0_131\bin(具体看Java环境)下.

        jacob-1.18-x64.dll是与jacob-jdk15-1.18.jar配套使用的.

        将jacob-1.18-x64.dll 放在C:\Windows\System32下.

        这样完全可以运行成功了,但是如果在Java web环境中运行,会报Could not initialize class com.jacob.com.ComThread.

        因此我们需要将jacob-1.18-x64.dll放入apache-tomcat-8.5.35\bin(具体看你tomcat)

        这样就错误也解决了.
        jacob资源地址: resources目录下jacob-1.18.zip解压获取;

    运行报错: 无法创建对象
    解决方案:
        word组件的标识, 由交互式用户改为启动用户, 本机从启动用户改为交互式用户成功解决问题, 不知道原因
        (comexp.msc -32)
        https://blog.csdn.net/hc_ttxs/article/details/82077751

 */

/**
 * office文件转换成HTML  （Jacob）
 * @author tongy
 *
 */
public class Office2Html  {
	private final static Office2Html office2Html = new Office2Html();  
	public static Office2Html getInstance() {  
		return office2Html;  
	}  
	  
    public Office2Html() {  
    }

    /**
     * 将word文件转换成HTML文件
     * @param wordPath      word文件绝对路径
     * @param htmlPath      HTML文件生成路径
     * @return
     */
    public static boolean word2Html(String wordPath, String htmlPath) {
        ComThread.InitSTA();  
        ActiveXComponent activexcomponent = new ActiveXComponent("Word.Application");  
        boolean flag = false;
        try {  
            activexcomponent.setProperty("Visible", new Variant(false));  
            Dispatch dispatch = activexcomponent.getProperty("Documents").toDispatch();  
            Dispatch dispatch1 = Dispatch.invoke(dispatch, "Open", 1,  
                    new Object[] { wordPath, new Variant(false), new Variant(true) },
                    new int[1]).toDispatch();  
            Dispatch.invoke(dispatch1, "SaveAs", 1, new Object[] { htmlPath,
                    new Variant(8) }, new int[1]);  
            Variant variant = new Variant(false);  
            Dispatch.call(dispatch1, "Close", variant);  
            flag = true;  
        } catch (Exception exception) {  
            exception.printStackTrace();  
        } finally {  
            activexcomponent.invoke("Quit", new Variant[0]);  
            ComThread.Release();  
            ComThread.quitMainSTA();  
        }  
        return flag;  
    }

    /**
     * 将ppt文件转换成HTML文件
     * @param pptPath       ppt文件绝对路径
     * @param htmlPath      HTML文件生成路径
     * @return
     */
	public static boolean ppt2Html(String pptPath, String htmlPath) {
		ComThread.InitSTA();  
        ActiveXComponent activexcomponent = new ActiveXComponent("PowerPoint.Application");  
        boolean flag = false;
        try {  
            Dispatch dispatch = activexcomponent.getProperty("Presentations").toDispatch();  
            Dispatch dispatch1 = Dispatch.call(dispatch, "Open", pptPath,
                    new Variant(-1), new Variant(-1), new Variant(0))  
                    .toDispatch();  
            Dispatch.call(dispatch1, "SaveAs", htmlPath, new Variant(12));
            Variant variant = new Variant(-1);  
            Dispatch.call(dispatch1, "Close");  
            flag = true;  
        } catch (Exception exception) {  
            System.out.println("|||" + exception.toString());  
        } finally {  
            activexcomponent.invoke("Quit", new Variant[0]);  
            ComThread.Release();  
            ComThread.quitMainSTA();  
        }  
        return flag;  
    }

    /**
     * 将Excel文件转换成HTML文件
     * @param excelPath     Excel文件绝对路径
     * @param htmlPath      HTML文件生成路径
     * @return
     */
    public static boolean excel2Html(String excelPath, String htmlPath) {
         ComThread.InitSTA();  
         ActiveXComponent activexcomponent = new ActiveXComponent("Excel.Application");  
         boolean flag = false;
         try {  
	         activexcomponent.setProperty("Visible", new Variant(false));  
	         Dispatch dispatch =  activexcomponent.getProperty("Workbooks").toDispatch();  
	         Dispatch dispatch1 = Dispatch.invoke(dispatch, "Open", 1, new Object[] {
                     excelPath, new Variant(false), new Variant(true)
	         }, new int[1]).toDispatch();  
	         Dispatch.call(dispatch1, "SaveAs", htmlPath, new Variant(44));
	         Variant variant = new Variant(false);  
	         Dispatch.call(dispatch1, "Close", variant);  
	         flag = true;  
         }  
         catch(Exception exception) {  
        	 System.out.println("|||" + exception.toString());  
         } finally  {  
        	 activexcomponent.invoke("Quit", new Variant[0]);  
        	 ComThread.Release();  
        	 ComThread.quitMainSTA();  
         }  
         return flag;  
    }  
  
    public static void main(String args[]) {  
//        boolean flag = excel2Html("C:\\Users\\Administrator\\Desktop\\test\\Excel\\2月份考勤汇总.xls",
//    			"E:\\pdfFile\\2月份考勤汇总.html");
//        boolean flag = excel2Html("C:\\Users\\Administrator\\Desktop\\test\\Excel\\日志及周报模板.xlsx",
//                "C:\\Users\\Administrator\\Desktop\\test\\Excel\\日志及周报模板.html");
//        boolean flag = excel2Html("C:\\Users\\Administrator\\Desktop\\file\\excel/测试excel.xlsx",
//                "E:/htmlFile");
        boolean flag = ppt2Html("C:\\Users\\Administrator\\Desktop\\file\\ppt\\100206.pptx", "C:\\Users\\Administrator\\Desktop\\file\\ppt\\a.html");
        if(flag){
            System.out.println("EXCEL文件转换成HTML成功！");  
        }else{  
            System.out.println("EXCEL文件转换成HTML失败！");  
        }  
    }
}  