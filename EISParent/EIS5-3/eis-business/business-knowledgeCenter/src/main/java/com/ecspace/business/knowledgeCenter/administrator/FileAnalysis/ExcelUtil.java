package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Excel的相关操作
 * @Author tongy
 */
public class ExcelUtil {
    /**
     * 获取Excel表格的sheet总数
     * @param excelFilePath Excel文件路径
     * @return
     */
    public static int getSheets(String excelFilePath) {
        int pages = 0;
        try {
            InputStream input = new FileInputStream(excelFilePath);
            if(excelFilePath.endsWith(".xls")){
                HSSFWorkbook workbook = new HSSFWorkbook(input);
                pages = workbook.getNumberOfSheets();
            }else if(excelFilePath.endsWith(".xlsx")){
                XSSFWorkbook workbook = new XSSFWorkbook(input);
                pages = workbook.getNumberOfSheets();
            }
            if(input != null) {
                input.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return pages;
    }

    public static void main(String[] args) {
        System.out.println(getSheets("C:\\Users\\Administrator\\Desktop\\file\\excel/测试excel.xlsx"));
    }
}
