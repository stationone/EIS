package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.FileAnalysis.Office2Html;
import com.ecspace.business.knowledgeCenter.administrator.FileAnalysis.PDFReader;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileTypeDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileTemp;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTempService;
import com.ecspace.business.knowledgeCenter.administrator.util.FileHashCode;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 20:31
 */
@Service
public class FileTempServiceImpl implements FileTempService {


    @Value("${value.fileTemp}")
    private String fileTempPath;
    @Value("${value.fileWeb}")
    private String fileWebPath;
    @Autowired
    private FileTypeDao fileTypeDao;
    @Autowired
    private FileInfoDao fileInfoDao;


//    @Override
//    public GlobalResult file2Html(FileInfo fileInfo) {
//        Menu menu = menuDao.findById(fileInfo.getMenuId()).orElse(new Menu());
//        String menuUrl = menu.getUrl();
//        String indexName = menu.getIndexName();
//        fileInfo.setIndexName(indexName);
//
//
//        return null;
//    }


    @Override
    public GlobalResult file2Html(FileInfo fileInfo) throws IOException {
        String preName = fileInfo.getFileNamePrefix();
        String fileNameSuffix = fileInfo.getFileNameSuffix();
        String path = fileInfo.getFilePath();
        String fileName = fileInfo.getFileName();
        //html路径
        String webPath = fileWebPath + preName + ".html";
        String src = FileHashCode.getSrc(webPath);
        //定义转换标签
        boolean flag = false;
        //转为html
        switch (fileNameSuffix) {
            case "doc":
            case "docx":
                flag = Office2Html.word2Html(path, webPath);
//                存储至服务器word中
//                path = "E:/knowledgeCenterFileManger/word/" + filename;
                break;
            case "xls":
            case "xlsx":
                flag = Office2Html.excel2Html(path, webPath);
                //存储至服务器excel中
//                path = "E:/knowledgeCenterFileManger/excel/" + filename;
                break;
            case "ppt":
            case "pptx":
                flag = Office2Html.ppt2Html(path, webPath);
                //存储至服务器ppt中
//                path = "E:/knowledgeCenterFileManger/ppt/" + filename;
                break;
            default:
                List<String> list = PDFReader.pdf2Image(path, fileTempPath);//list中是每页的图片路径
                webPath = fileWebPath + fileName;
//                FileUtils.copyInputStreamToFile(new File(path).getInputStream(), new File(webPath));
                //文件转存
                FileUtils.copyFile(new File(path),new File(webPath));
                flag = true;
                //存储至服务器other中
//                path = "E:/knowledgeCenterFileManger/other/" + filename;
                break;
        }
        FileInfo info = null;
        if (flag) {
            fileInfo.setWebPath(webPath);
            fileInfo.setSrc(src);

            info = fileInfoDao.save(fileInfo);
        }


        return new GlobalResult(flag, 0000, String.valueOf(flag),info);
    }

    //上传文件
    @Override
    public GlobalResult fileTemp(MultipartFile file) throws Exception {
        //文件名
        String filename = file.getOriginalFilename();
        String[] split = filename != null ? filename.split("\\.") : new String[0];//split切割 . | * : ^ \ 需要加\\转义
        if (split.length == 0) {
            return new GlobalResult(false, 4000, "false", filename);
        }
        String preName = split[0];
        System.out.println(preName);
        //组装文件路径
        String path = fileTempPath + filename;

        long size = file.getSize();//文件大小

        //存储至临时文件夹
        FileUtils.copyInputStreamToFile(file.getInputStream(), new File(path));

        FileInfo fileInfo = new FileInfo();
        fileInfo.setId(TNOGenerator.generateId());
        fileInfo.setFileName(filename);
        fileInfo.setFileNamePrefix(preName);
        fileInfo.setFileNameSuffix(split[1]);
        fileInfo.setCreationTime(new Date());
        fileInfo.setFileSize(size);
        fileInfo.setFilePath(path);
        fileInfo.setHashCode(FileHashCode.generate(path));


//        //html路径
//        String webPath = fileWebPath + preName + ".html";
//        //定义转换标签
//        boolean flag = false;
//        //转为html
//        switch (filename.substring(filename.lastIndexOf(".") + 1)) {
//            case "doc":
//            case "docx":
//                flag = Office2Html.word2Html(path, webPath);
////                存储至服务器word中
////                path = "E:/knowledgeCenterFileManger/word/" + filename;
//                break;
//            case "xls":
//            case "xlsx":
//                flag = Office2Html.excel2Html(path, webPath);
//                //存储至服务器excel中
////                path = "E:/knowledgeCenterFileManger/excel/" + filename;
//                break;
//            case "ppt":
//            case "pptx":
//                flag = Office2Html.ppt2Html(path, webPath);
//                //存储至服务器ppt中
////                path = "E:/knowledgeCenterFileManger/ppt/" + filename;
//                break;
//            default:
//                List<String> list = PDFReader.pdf2Image(path, fileTempPath);//list中是每页的图片路径
//                webPath = fileWebPath + filename;
//                FileUtils.copyInputStreamToFile(file.getInputStream(), new File(webPath));
//                flag = true;
//                //存储至服务器other中
////                path = "E:/knowledgeCenterFileManger/other/" + filename;
//                break;
//        }
//        FileTemp fileTemp = new FileTemp();
//        fileTemp.setFileName(filename);
//        fileTemp.setPath(path);
//        String src = FileHashCode.getSrc(webPath);
//        fileTemp.setWebPath(src);
//        fileTemp.setId(TNOGenerator.generateId());

        FileInfo info = fileInfoDao.save(fileInfo);
        return new GlobalResult(true, 2000, "true", info);
    }
}
