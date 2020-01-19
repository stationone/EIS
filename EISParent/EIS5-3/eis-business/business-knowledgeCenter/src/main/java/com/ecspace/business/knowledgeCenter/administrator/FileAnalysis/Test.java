
package com.ecspace.business.knowledgeCenter.administrator.FileAnalysis;


import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileDirectoryNode;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Page;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;

import java.util.ArrayList;
import java.util.List;


/**
 * @Author tongy
 */

public class Test {
//    @Resource
//    private static ISvnService svnService;

    public static void main(String[] args) {
        //定义本地文件的路径
        String localPath = "C:\\Users\\Administrator\\Desktop\\file\\word/100801.docx";
        //创建一个文件对象, 作为被转换的pdf
        FileInfo knowledge = new FileInfo();
        //将给文件起名字,
        knowledge.setFileName("TEST201709");
//        Knowledge pageKnowledge = new Knowledge();
//        pageKnowledge.setResCode("test");
        //定义一个集合, 存储file对象被离散后的page页
        List<Page> pageList = new ArrayList<>();
        //word或ppt文件(转成PDF)
        if(localPath.endsWith("doc") || localPath.endsWith("docx") ||
                localPath.endsWith("ppt") || localPath.endsWith("pptx") || localPath.endsWith("pdf")) {
            //转换后的PDF文件路径("E:\pdf\aaa.pdf")
                    //String pdfFilePath =  E:/pdfFile/TEST201709.pdf
            String pdfFilePath = "C:\\Users\\Administrator\\Desktop\\file\\word\\" + knowledge.getFileName() + ".pdf";
            //截取的PDF存放的位置("E:\pdf\splitPdf")
                    //String splitPdfPath = E:/pdfFile/splitPdfFile
            String splitPdfPath = "C:\\Users\\Administrator\\Desktop\\file\\word\\splitPdfFile\\";
/*            if (!new java.io.File(splitPdfPath).exists()) {//分类文件夹不存在
                new java.io.File(splitPdfPath).mkdir();//创建文件夹
            }*/
            boolean exchangeFlag = false;
            //word转换成PDF
            if(localPath.endsWith(".doc") || localPath.endsWith(".docx")){
                exchangeFlag = Office2Pdf.word2pdf(localPath, pdfFilePath);
                //ppt转换成PDF
            } else if(localPath.endsWith(".ppt") || localPath.endsWith(".pptx")) {
                exchangeFlag = Office2Pdf.ppt2pdf(localPath, pdfFilePath);
            } else if(localPath.endsWith(".pdf")) {
                exchangeFlag = true;
                //将PDF文件原本的路径赋值给存储PDF文件的路径
                pdfFilePath = localPath;
            }
            if(exchangeFlag) {  //转换成功
                //获取当前转换后的PDF文件的总页数
                int pageCount = PDFReader.getPageCount(pdfFilePath);
                //循环遍历PDF文件的每一页，提取并封装信息
                for(int i = 0; i < pageCount; i++) {
                    Page page = new Page();
                    page.settNO(TNOGenerator.generateId());
                    page.setPageNO(i + 1);
                    page.setContent(PDFReader.readPdfText(pdfFilePath, i + 1, i + 1));
                    //截取的PDF文件路径("E:\pdf\splitPdf\1.pdf")
                    String splitPdfFilePath = splitPdfPath + knowledge.getFileName() + "_" + String.valueOf(i + 1) + ".pdf";
                    //将PDF文件的页生成新的PDF文件
                    if(PDFReader.splitPdfFile(pdfFilePath, splitPdfFilePath, i + 1, i + 1)) {
                        page.setPdfPage(new java.io.File(splitPdfFilePath));     //转换成文件封装进对象
                    }
                    page.setKnowledge(knowledge);//page所在的file
                    //存在问题：文档未从第一页开始编码 则page解析与node解析的页码无法匹配
                    if(localPath.endsWith(".doc") || localPath.endsWith(".docx")){
                        //正文开始位置（即第一个目录的实际页码而非目录对应页码）
//                        int startPageNum = 1;
//                        int D_value = startPageNum - 1;     //目录实际页码与目录对应页码的差值
                        //所有解析的目录, 遍历与page解析的页面进行对应
                        List<FileDirectoryNode> nodeList = WordUtil.getWordNodes(localPath);
                        List<FileDirectoryNode> pageNodeList = new ArrayList<>();
                        for(FileDirectoryNode node : nodeList) {
//                            node.getPage().setPageNO(node.getPage().getPageNO() + D_value);     //目录对应页码+差值即为目录实际的页码
                            if(node.getPage().getPageNO() == page.getPageNO()) {
                                pageNodeList.add(node);
                            }
                        }
                        page.setNodeList(pageNodeList);
                    }
                    pageList.add(page);
                }
            }
            //excel文件(转成HTML)
        } else if(localPath.endsWith(".xls") || localPath.endsWith(".xlsx")) {
            //转换后的HTML存放的位置（"E:\html"）
            String htmlPath = "C:\\Users\\Administrator\\Desktop\\file\\excel";
            //转换后的HTML文件路径（"E:\html\aaa.html"）
            String htmlFilePath = htmlPath + knowledge.getFileName() + ".html";
            //相应的子HTML文件存放的位置（"E:\html\aaa.files"）
            String subHtmlPath = htmlPath + knowledge.getFileName() + ".files\\";
            //“E://htmlFile//日志及周报模板.html”报错    “E:\\htmlFile\\日志及周报模板.html”正常
            boolean exchangeFlag = Office2Html.excel2Html(localPath, htmlFilePath);
            if(exchangeFlag) {
                //获取当前Excel文档的所有sheet页
                int pageCount = ExcelUtil.getSheets(localPath);
                for(int i = 0; i < pageCount; i++) {
                    Page page = new Page();
                    page.settNO((TNOGenerator.generateId()));
                    page.setPageNO(i + 1);
                    //子HTML文件路径（"E:\html\aaa.files\sheet001.html"）
                    String num = HtmlUtil.formatSheetHtmlNum(i + 1);
                    String subHtmlFilePath = subHtmlPath + "sheet" + num + ".html";
                    page.setContent(HtmlUtil.getText(subHtmlFilePath));
                    page.setPdfPage(new java.io.File(subHtmlFilePath));     //转换成文件封装进对象
                    page.setKnowledge(knowledge);
                    pageList.add(page);
                }
            }
        }
        knowledge.setPageList(pageList);

        for(int i = 0; i < knowledge.getPageList().size(); i++ ) {
            System.out.println("第" + knowledge.getPageList().get(i).getPageNO() + "页");
            System.out.println("content：" + knowledge.getPageList().get(i).getContent());
            List<FileDirectoryNode> nodeList = knowledge.getPageList().get(i).getNodeList();
            if(nodeList == null || nodeList.size() == 0) {
                System.out.println("    node：无");
            } else {
                for (FileDirectoryNode node : nodeList) {
                    System.out.println("    nodeName：" + node.getNodeName());
                    System.out.println("        level：" + node.getLevel());
                    if(node.getParentNode() != null) {
                        System.out.println("        parentNode：" + node.getParentNode().getNodeName());
                    } else {
                        System.out.println("        parentNode：无");
                    }
                    List<FileDirectoryNode> subNodeList = node.getSubNodeList();
                    if(subNodeList == null || subNodeList.size() == 0) {
                        System.out.println("        subNode：无");
                    } else {
                        for (FileDirectoryNode subNode : subNodeList) {
                            System.out.println("        subNode：" + subNode.getNodeName());
                        }
                    }
                    if(node.getPreviousNode() != null) {
                        System.out.println("        previoousNode：" + node.getPreviousNode().getNodeName());
                    } else {
                        System.out.println("        previoousNode：无");
                    }
                    if(node.getNextNode() != null) {
                        System.out.println("        nextNode：" + node.getNextNode().getNodeName());
                    } else {
                        System.out.println("        nextNode：无");
                    }
                }
            }
        }
    }

}

