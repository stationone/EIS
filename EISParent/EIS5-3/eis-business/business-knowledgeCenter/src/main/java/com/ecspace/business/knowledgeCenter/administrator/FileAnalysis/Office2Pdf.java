package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;

import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.ComThread;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;

/**
 * word  excel  ppt 转pdf  (jacob)
 * @author tongy
 *
 */
public class Office2Pdf {
    private static final Integer WORD_TO_PDF = 17;
    private static final Integer PPT_TO_PDF  = 32;
    private static final Integer EXCEL_TO_PDF  = 0;

    /**
     * word文件转换成PDF文件
     * @param wordFilePath      word文件绝对路径
     * @param pdfFilePath       PDF文件的生成路径
     * @throws Exception
     */
    public static boolean word2pdf(String wordFilePath, String pdfFilePath) {
        boolean flag = false;
        ActiveXComponent app = null;  
        Dispatch doc = null;  
        try {  
            ComThread.InitSTA();  
            app = new ActiveXComponent("Word.Application");  
            app.setProperty("Visible", false);  
            Dispatch docs = app.getProperty("Documents").toDispatch(); 
            Object[] obj = new Object[]{
                    wordFilePath,
                    new Variant(false),  
                    new Variant(false),//是否只读  
                    new Variant(false),   
                    new Variant("pwd")
            };
            doc = Dispatch.invoke(docs, "Open", Dispatch.Method, obj, new int[1]).toDispatch();  
//          Dispatch.put(doc, "Compatibility", false);  //兼容性检查,为特定值false不正确
            Dispatch.put(doc, "RemovePersonalInformation", false);  
            Dispatch.call(doc, "ExportAsFixedFormat", pdfFilePath, WORD_TO_PDF); // word保存为pdf格式宏，值为17  
            flag = true;
        }catch (Exception e) {  
            e.printStackTrace();
            throw e;
        } finally {  
            if (doc != null) {  
                Dispatch.call(doc, "Close", false);  
            }  
            if (app != null) {  
                app.invoke("Quit", 0);  
            }  
            ComThread.Release();  
        }
        return flag;
    }

    /**
     * ppt文件转换成PDF文件
     * @param pptFilePath       ppt文件绝对路径
     * @param pdfFilePath       PDF文件的生成路径
     * @throws Exception
     */
    public static boolean ppt2pdf(String pptFilePath, String pdfFilePath) {
        boolean flag = false;
        ActiveXComponent app = null;
        Dispatch ppt = null;
        try {
            ComThread.InitSTA();
            app = new ActiveXComponent("PowerPoint.Application");	//创建一个ppt对象
            Dispatch ppts = app.getProperty("Presentations").toDispatch();	//获取文档属性
            //调用Documents对象中Open方法打开文档，并返回打开的文档对象Document
            ppt = Dispatch.call(ppts, "Open", pptFilePath,
            		true,	// ReadOnly
                    true,	// Untitled指定文件是否有标题
                    false	// WithWindow指定文件是否可见
            		).toDispatch();
            Dispatch.call(ppt, "SaveAs", pdfFilePath, PPT_TO_PDF); // 特定值32
            flag = true;
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (ppt != null) {
                Dispatch.call(ppt, "Close");
            }
            if (app != null) {
                app.invoke("Quit");
            }
            ComThread.Release();
        }
        return flag;
    }

    /**
     * Excel文件转换成PDF文件
     * @param excelFilePath     Excel文件绝对路径
     * @param pdfFilePath       PDF文件的生成路径
     * @throws Exception
     */
    public static boolean excel2Pdf(String excelFilePath, String pdfFilePath) {
        boolean flag = false;
        ActiveXComponent ax = null;		//创建Excel对象
        Dispatch excel = null;
        try {
            ComThread.InitSTA();
            ax = new ActiveXComponent("Excel.Application");
            ax.setProperty("Visible", new Variant(false));
            ax.setProperty("AutomationSecurity", new Variant(3)); // 禁用宏
            Dispatch excels = ax.getProperty("Workbooks").toDispatch();

            Object[] obj = new Object[]{
                    excelFilePath,
                    new Variant(false),
                    new Variant(false) 
             };
            excel = Dispatch.invoke(excels, "Open", Dispatch.Method, obj, new int[9]).toDispatch();
            
            //此处可按sheet进行提取，但仅限当前活动页
//            Dispatch currentSheet = Dispatch.get((Dispatch) excel, "ActiveSheet").toDispatch();
//            Dispatch pageSetup = Dispatch.get(currentSheet, "PageSetup").toDispatch();
//            Dispatch.put(pageSetup, "Orientation", new Variant(2));
//            Dispatch.put(pageSetup, "Zoom", false); // 值为100或false
//            Dispatch.put(pageSetup, "FitToPagesWide", 1); // 所有列为一页(1或false)
            
            // 转换格式
            Object[] obj2 = new Object[]{ 
                    new Variant(EXCEL_TO_PDF), // PDF格式=0
                    pdfFilePath,
                    new Variant(0)  //0=标准 (生成的PDF图片不会变模糊) ; 1=最小文件
            };
            //Dispatch.invoke(currentSheet, "ExportAsFixedFormat", Dispatch.Method,obj2, new int[1]);
            Dispatch.invoke(excel, "ExportAsFixedFormat", Dispatch.Method,obj2, new int[1]);
            flag = true;
        } catch (Exception es) {
            es.printStackTrace();
            throw es;
        } finally {
            if (excel != null) {
                Dispatch.call(excel, "Close", new Variant(false));
            }
            if (ax != null) {
                ax.invoke("Quit", new Variant[] {});
                ax = null;
            }
            ComThread.Release();
        }
        return flag;
    }
    
    public static void main(String[] args) throws Exception {
        word2pdf("C:\\Users\\Administrator\\Desktop\\file\\word\\100801.docx",
        		"C:\\Users\\Administrator\\Desktop\\file\\word\\100808.pdf");
//    	excel2Pdf("C:\\Users\\Administrator\\Desktop\\file\\excel\\100529.xlsx",
//    			"C:\\Users\\Administrator\\Desktop\\file\\excel\\100529.pdf");
//    	ppt2pdf("C:\\Users\\Administrator\\Desktop\\file\\ppt\\00314C28-BA0  CAE report-20140806.pptx",
//    			"C:\\Users\\Administrator\\Desktop\\file\\ppt\\00314C28-BA0  CAE report-20140806.pdf");
    }
    


}