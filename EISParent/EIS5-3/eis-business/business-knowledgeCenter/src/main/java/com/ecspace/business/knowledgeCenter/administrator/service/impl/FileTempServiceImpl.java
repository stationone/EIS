package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.FileAnalysis.Office2Html;
import com.ecspace.business.knowledgeCenter.administrator.FileAnalysis.PDFReader;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileInfoDao;
import com.ecspace.business.knowledgeCenter.administrator.dao.FileTypeDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTempService;
import com.ecspace.business.knowledgeCenter.administrator.util.FileHashCode;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 20:31
 */
@Transactional
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
                src = FileHashCode.getSrc(webPath);
//                FileUtils.copyInputStreamToFile(new File(path).getInputStream(), new File(webPath));
                //文件转存
                FileUtils.copyFile(new File(path), new File(webPath));
                flag = true;
                //存储至服务器other中
//                path = "E:/knowledgeCenterFileManger/other/" + filename;
                break;
        }
        FileInfo info = null;
        if (flag) {
            fileInfo.setWebPath(webPath);
            fileInfo.setSrc(src);
//            fileInfo.setIndexName("");
            fileInfo.setStatus(1);//解析完成未审批

            info = fileInfoDao.save(fileInfo);
        }
        return new GlobalResult(flag, 0000, String.valueOf(flag), info);
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
//        System.out.println(preName);
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
        Date date = new Date();
        fileInfo.setCreationTime(date);
        fileInfo.setLastUpdateTime(date);
        fileInfo.setFileSize(size);
        fileInfo.setFilePath(path);
        fileInfo.setHashCode(FileHashCode.generate(path));
        fileInfo.setStatus(0);//状态, 初始为0 , 未解析

        FileInfo info = fileInfoDao.save(fileInfo);
        return new GlobalResult(true, 2000, "true", info);
    }

    @Override
    public GlobalResult fileTempUpload(MultipartFile file, String indexName, String menuId) throws Exception {
        //获取当前登录用户
        String uploadUser = "系统管理员";
        //文件名
        String filename = file.getOriginalFilename();
        String[] split = filename != null ? filename.split("\\.") : new String[0];//split切割 . | * : ^ \ 需要加\\转义
        if (split.length == 0) {
            return new GlobalResult(false, 4000, "false", filename);
        }
        String preName = split[0];
//        System.out.println(preName);
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
        Date date = new Date();
        fileInfo.setCreationTime(date);
        fileInfo.setLastUpdateTime(date);
        fileInfo.setFileSize(size);
        fileInfo.setFilePath(path);
        fileInfo.setHashCode(FileHashCode.generate(path));
        fileInfo.setStatus(0);//状态, 初始为0 , 未解析
        fileInfo.setUploadUser(uploadUser);

        fileInfo.setIndexName(indexName);
        fileInfo.setMenuId(menuId);

        FileInfo info = fileInfoDao.save(fileInfo);


        return new GlobalResult(true, 2000, "true", info);
    }

    @Override
    public GlobalResult deleteFile(String id) {
        boolean deleteFilePath = false;
        boolean deleteWebPath = false;
        try {
            //删除本地文件
            FileInfo fileInfo = fileInfoDao.findById(id).orElse(new FileInfo());
            String filePath = fileInfo.getFilePath();
            String webPath = fileInfo.getWebPath();
            deleteFilePath = new File(filePath).delete();
            deleteWebPath = new File(webPath).delete();
            //删除数据库存储
            fileInfoDao.deleteById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return new GlobalResult(false, 4000, e.getMessage());
        }
        if (deleteFilePath && deleteWebPath) {
            return new GlobalResult(true, 2000, "ok");
        }
        return new GlobalResult(false, 4000, "文件不存在");
    }
}
