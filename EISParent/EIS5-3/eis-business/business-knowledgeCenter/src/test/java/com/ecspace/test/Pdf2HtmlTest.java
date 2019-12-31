package com.ecspace.test;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.fit.pdfdom.PDFDomTree;
import org.junit.Test;

import javax.xml.parsers.ParserConfigurationException;
import java.io.*;

/**
 * @author zhangch
 * @date 2019/12/27 0027 下午 19:37
 */
public class Pdf2HtmlTest {
    /*
    pdf转换html
     */
    @Test
    public void pdfToHtmlTest()  {
        String outputPath = "D:\\code\\pdf\\HashMap.html";
        byte[] bytes = getBytes("D:\\code\\pdf\\HashMap.pdf");
//        try() 写在()里面会自动关闭流
        try (BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(outputPath)),"UTF-8"));){
            //加载PDF文档
            PDDocument document = PDDocument.load(bytes);
            PDFDomTree pdfDomTree = new PDFDomTree();
            pdfDomTree.writeText(document,out);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /*
    将文件转换为byte数组
     */
    private byte[] getBytes(String filePath){
        byte[] buffer = null;
        try {
            File file = new File(filePath);
            FileInputStream fis = new FileInputStream(file);
            ByteArrayOutputStream bos = new ByteArrayOutputStream(1000);
            byte[] b = new byte[1000];
            int n;
            while ((n = fis.read(b)) != -1) {
                bos.write(b, 0, n);
            }
            fis.close();
            bos.close();
            buffer = bos.toByteArray();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return buffer;
    }
}
