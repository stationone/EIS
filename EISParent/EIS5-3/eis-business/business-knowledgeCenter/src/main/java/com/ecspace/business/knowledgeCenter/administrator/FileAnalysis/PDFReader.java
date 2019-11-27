package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfCopy;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.text.PDFTextStripper;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;

/**
 * 解析PDF文档  （itext）
 * 1、读取PDF文件的文本内容
 * 2、将PDF文件的指定范围页生成新的PDF文件
 * @author tongy
 *
 */
public class PDFReader {
	
    public static void main(String[] args) {
        /************************获取PDF总页数*****************************/
        System.out.println(getPageCount("C:\\Users\\Administrator\\Desktop\\file\\word\\100808.pdf"));
        /******************读取PDF文件的文本内容**********************/
        String s = readPdfText("C:\\Users\\Administrator\\Desktop\\file\\word\\100808.pdf", 1, 13);
        System.out.println(s);
        /**********************将PDF文件的指定范围页生成新的PDF文件**************************/
//    	String pdfFilePath = "C:\\Users\\Administrator\\Desktop\\file\\pdf/TEST201709.pdf";
//    	String savePath = "C:\\Users\\Administrator\\Desktop\\file\\pdf\\splitFile/TEST201709.pdf";
//    	splitPdfFile(pdfFilePath, savePath, 1, 2);
    	
    	/*****************************将PDF文件转换成图片(.png)*********************************/
//    	String pdfPath = "C:\\Users\\Administrator\\Desktop\\file\\pdf/TEST201709.pdf";
//    	String imgPath = "C:\\Users\\Administrator\\Desktop\\file\\pdf\\pdfImg/TEST201709.png";
//        int pageCount = getPageCount(pdfFilePath);
//        for (int i = 0; i < pageCount; i++) {
//            pdf2Image(pdfPath, imgPath);
//            imgPath = "C:\\Users\\Administrator\\Desktop\\file\\pdf\\pdfImg/TEST201709"+i+".png";
//        }
    }

    /**
     * 获取PDF文件的总页数
     * @param pdfFilePath   PDF文件路径
     * @return
     */
    public static int getPageCount(String pdfFilePath) {
        PdfReader pdfReader = null;
        int pages = 0;
        try {
            pdfReader = new PdfReader(new FileInputStream(pdfFilePath));
            pages = pdfReader.getNumberOfPages();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return pages;
    }

    /**
     * 读取PDF文件的文本内容
     * @param pdfFilePath   pdf文件路径
     * @param startPage     开始提取页
     * @param endPage       结束提取页
     * @throws Exception
     */
    public static String readPdfText(String pdfFilePath, int startPage, int endPage){
        String content = null;
    	// 是否排序(文本和页码)
        boolean sort = true;
        PDDocument document = null;
        try {
        	// 从本地装载文件
            File pdfFile = new File(pdfFilePath);
        	document = PDDocument.load(pdfFile);
        	// PDFTextStripper提取文本
        	PDFTextStripper stripper = null;
        	stripper = new PDFTextStripper();
        	// 设置是否排序
        	stripper.setSortByPosition(sort);
        	// 设置起始页
        	stripper.setStartPage(startPage);
        	// 设置结束页
        	stripper.setEndPage(endPage);
        	// 调用PDFTextStripper的writeText提取文本
            content = stripper.getText(document);
            System.out.println(content);
        }catch (Exception e) {
        	e.printStackTrace();
        }finally {
        	if (document != null) {
        		// 关闭PDF Document
                try {
                    document.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return content;
    }
    
    /** 
     * 截取pdfFile的第from页至第end页，组成一个新的文件名 
     * @param pdfFilePath  	需要分割的PDF路径
     * @param savePath  	新生成的PDF路径
     * @param startPage  	起始页
     * @param endPage  		结束页
     */  
    public static boolean splitPdfFile(String pdfFilePath, String savePath, int startPage, int endPage) {
        boolean flag = false;
        Document document = null;  
        PdfCopy copy = null;          
        try {  
            PdfReader reader = new PdfReader(pdfFilePath);            
            int n = reader.getNumberOfPages();            
            if(endPage == 0){  
            	endPage = n;  
            }  
//            System.out.println("开始截取");
            document = new Document(reader.getPageSize(1));  
            copy = new PdfCopy(document, new FileOutputStream(savePath));
            document.open();
            for(int i = startPage; i <= endPage; i++) {  
                document.newPage();   
                PdfImportedPage page = copy.getImportedPage(reader, i);  
                copy.addPage(page);  
            }  
            document.close();  
//            System.out.println("截取完成");
            flag = true;
        } catch (IOException e) {  
            e.printStackTrace();  
        } catch(Exception e) {
            e.printStackTrace();  
        }
        return flag;
    }
    
    /**
     * 将PDF文件转换成图片
     * @param pdfPath	pdf文件路径
     * @param imgPath	图片路径
     */
    public static void pdf2Image(String pdfPath, String imgPath) {
    	File file = new File(pdfPath);
    	try{
    		PDDocument doc = PDDocument.load(file);
    		PDFRenderer renderer = new PDFRenderer(doc);
    		int pageCount = doc.getNumberOfPages();
    		for(int i=0;i<pageCount;i++){
    			BufferedImage image = renderer.renderImageWithDPI(i, 296);
//    	          BufferedImage image = renderer.renderImage(i, 2.5f);
    			ImageIO.write(image, "PNG", new File(imgPath));
    		}
    	} catch (IOException e) {  
            e.printStackTrace();  
        }
    }
    
}
