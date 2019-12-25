package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.FileService;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTempService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 20:28
 */
@RestController
@RequestMapping("fileTemp")
public class FileTempController {
    @Autowired
    FileTempService fileTempService;

    @PostMapping(value = "fileTemp")
    public GlobalResult fileTemp(@RequestParam("file") MultipartFile file) throws Exception {
        //非空判断
        if (file.isEmpty()) {
            return new GlobalResult(false, 2001, "非法参数");
        }
        //调用文件服务
        return fileTempService.fileTemp(file);
    }

    @PostMapping(value = "file2Html")
    public GlobalResult file2Html(@RequestBody FileInfo fileInfo) throws Exception {
        //非空判断
        if ("".equals(fileInfo.getId())) {
            return new GlobalResult(false, 2001, "非法参数");
        }
        if ("".equals(fileInfo.getFilePath())) {
            return new GlobalResult();
        }
        //调用文件服务
        return fileTempService.file2Html(fileInfo);
    }

    @PostMapping(value = "deleteFile")
    public GlobalResult deleteFile(String id) throws Exception {
        if (id == null || "".equals(id)) {
            return new GlobalResult(false, 4000, "非法参数");
        }

        return fileTempService.deleteFile(id);

    }
}
