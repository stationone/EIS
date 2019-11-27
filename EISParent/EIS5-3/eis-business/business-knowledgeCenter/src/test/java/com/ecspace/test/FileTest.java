//package com.ecspace.test;
//
//import com.ecspace.business.knowledgeCenter.administrator.util.FileHashCode;
//import com.ecspace.business.knowledgeCenter.administrator.util.FileUtils;
//import org.junit.Test;
//
//import java.io.File;
//import java.io.IOException;
//
///**
// * 文件操作测试
// * @author zhangch
// * @date 2019/11/12 0012 下午 15:25
// */
//public class FileTest {
//    private String fileName = "C:\\Users\\Administrator\\Desktop\\file\\word\\TEST201709.pdf";
//    private String directoryName = "C:\\Users\\Administrator\\Desktop\\file\\word\\zhangchi";
//    private String copyDirectory = "C:\\Users\\Administrator\\Desktop\\file\\word\\copy";
//    private String copyFile = "C:\\Users\\Administrator\\Desktop\\file\\word\\copyFile.pdf";
//
//    @Test
//    public void test1() throws Exception {
//        //文件大小
//        int fileSize = FileUtils.getFileSize(fileName);
//        System.out.println(fileSize);
//
//        boolean b = FileUtils.forceDirectory(directoryName);
//        System.out.println(b);
//
//
//        FileUtils.copyDirectiory(directoryName,copyDirectory);
//
//        FileUtils.copyFile(new File(fileName),new File(copyFile));
//
//        boolean b1 = FileUtils.existsDirectory(copyDirectory);
//        System.out.println(b1);
//
//        String word = FileUtils.changeFileExt(copyFile, ".docx");
//        System.out.println(word);
//        FileUtils.copyFile(new File(copyFile),new File(word));
//
//        String generate = FileHashCode.generate(copyFile);
//        System.out.println(generate);
//
//    }
//
//}
