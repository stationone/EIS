package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


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
     * 上传文件
     *
     * @param file
     * @return
     */
    @PostMapping(value = "fileUpload")
    public GlobalResult handleFileUpload(@RequestParam("file") MultipartFile file) throws Exception {
        //非空判断
        if (file.isEmpty()) {
            return new GlobalResult(false, 2001, "非法参数");
        }

        //调用文件服务
        return fileService.saveFile(file);
    }


    /**
     * 保存文件参数
     *
     * @param json
     * @return
     */
    @PostMapping(value = "fileForm")
    public GlobalResult fileForm(String json) throws Exception {
        if (json == null) {
            return new GlobalResult(false,4000,"非法参数");
        }
        //解析json
        JSONObject jsonObject = JSON.parseObject(json);
        if ("".equals(jsonObject.get("filePath"))) {
            return new GlobalResult(false,4000,"没有文件");
        }
//        if ("".equals(jsonObject.get("indexName"))) {
//            return new GlobalResult(false,4000,"没选类型");
//        }

        //调用文件服务
        FileInfo fileInfo = fileService.saveFileInfo(jsonObject);
        System.out.println(json);
        return new GlobalResult(true, 2000, "true", fileInfo);
    }


//    /**
//     * 文件离散
//     *
//     * @param fileInfo
//     * @return
//     * @throws Exception
//     */
//    @PostMapping(value = "fileAnalyzer")
//    public GlobalResult fileAnalyzer(@RequestBody FileInfo fileInfo) throws Exception {
//
//        //调用文件服务
////        return fileService.fileAnalyzer(fileInfo);
//        return fileService.file2Html(fileInfo);
//    }

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

    @GetMapping(value = "getFormField")
    public List<FileBase> getFormField(String indexName) throws Exception{

//        return fileService.getFormField(indexName);
        //表单列由之前的mapping优化为document
        return fileService. listTypeField(indexName);
    }



}
