package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.alibaba.fastjson.JSON;
import com.ecspace.business.knowledgeCenter.administrator.dao.PageDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.xml.ws.Action;
import java.io.File;
import java.io.IOException;

/**
 * 文件管理接口
 *
 * @author zhangch
 * @date 2019/11/12 0012 下午 16:24
 */
@RestController
@RequestMapping("/file")
public class FileController {

    @Autowired
    private FileService fileService;


    /**
     * 上传文件 ****************************文件名正则, 不能有特殊字符*****************************
     *
     * @param file
     * @return
     */
    @PostMapping(value = "fileUpload")
    public GlobalResult handleFileUpload(@RequestParam("file") MultipartFile file ,String menuId, String keyword , String author , String filetype, String professional ,String switchbutton) throws Exception {
        //非空判断
        if (file.isEmpty() || "".equals(menuId)) {
            return new GlobalResult(false, 2001, "非法参数");
        }

        //调用文件服务
        return fileService.saveFile(file, menuId, keyword);
    }


    /**
     * 文件离散
     *
     * @param fileInfo
     * @return
     * @throws Exception
     */
    @PostMapping(value = "fileAnalyzer")
    public GlobalResult fileAnalyzer(@RequestBody FileInfo fileInfo) throws Exception {

//        Thread.sleep(10000);//加载一会

        //调用文件服务
        return fileService.fileAnalyzer(fileInfo);
    }

    /**
     * 获取目录文件
     *
     * @param menuId
     * @param json
     * @param page
     * @param rows
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "fileList")
    public PageData fileList(String menuId, String json, Integer page, Integer rows) throws Exception {

        if (StringUtils.isBlank(menuId)) {
            return new PageData();
        }
        //没有请求参数时, 数据全部搜索出来
        if (StringUtils.isBlank(json) || JSON.parseObject(json).isEmpty() || StringUtils.isBlank(JSON.parseObject(json).get("search").toString()) ) {
            //查询所有
            return fileService.getFileList(menuId, page, rows);
        }
        //条件查询
        return fileService.getFileList(menuId, json, page, rows);
    }


    /**
     * 查看文件详情
     * @param fileId
     * @return
     * @throws Exception
     */
    @GetMapping(value = "fileDetail")
    public FileInfo fileDetail(String fileId) throws Exception {

       return fileService.getFileDetail(fileId);
    }



}
