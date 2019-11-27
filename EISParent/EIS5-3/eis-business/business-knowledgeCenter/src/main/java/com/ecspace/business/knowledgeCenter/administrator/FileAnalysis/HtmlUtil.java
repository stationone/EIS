package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import javax.swing.text.html.HTMLEditorKit;
import java.io.File;

/**
 * HTML文件的相关操作（jsoup）
 * @Author tongy
 */
public class HtmlUtil extends HTMLEditorKit.ParserCallback {
    /**
     * 获取HTML文件的文本内容（jsoup）
     * @param htmlPath      HTML文件路径
     * @return
     */
    public static String getText(String htmlPath) {
        StringBuffer sb = null;
        File file = new File(htmlPath);
        Document doc = null;
        try {
            doc = Jsoup.parse(file, "gbk");
            Elements eles = doc.getElementsByTag("body");
            sb = new StringBuffer();
            for (Element ele : eles) {
                sb.append(ele.text());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sb.toString();
    }

    public static String formatSheetHtmlNum(int i){
        String num = String.valueOf(i);
        if(num.length() == 1) {
            num = "00" + num;
        } else if(num.length() == 2) {
            num = "0" + num;
        }
        return num;
    }

    public static void main (String[] args) {
        String s = getText("C:\\Users\\Administrator\\Desktop\\file\\html/basic.html");
        System.out.println(s);
        System.out.println(formatSheetHtmlNum(59));
    }
}
