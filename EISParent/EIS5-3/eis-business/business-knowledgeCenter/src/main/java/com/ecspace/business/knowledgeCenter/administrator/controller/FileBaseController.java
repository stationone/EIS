package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileBaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 文档基本类型
 *
 * @author zhangch
 * @date 2019/11/29 0029 下午 20:32
 */
@RestController
@RequestMapping("/fileBase")
public class FileBaseController {

    @Autowired
    private FileBaseService fileBaseService;


    @RequestMapping(value = "fileBaseList")
    public PageData fileBaseList(String indexName ,@RequestParam(required = false) Integer page,@RequestParam(required = false) Integer size) throws Exception {

        return fileBaseService.fileBaseList(indexName, page, size);
    }

    /**
     * 保存基础字段
     * @return baseField
     */
    @LogAnno(operateType = "文档基础属性/添加或修改")
    @PostMapping("/save")
    public GlobalResult save(FileBase fileBase){
        if (fileBase == null) {
            return new GlobalResult(false, 2002,"参数异常");
        }

        return fileBaseService.saveFileBase(fileBase);
    }

    /**
     * 保存基础字段
     * @return id
     */
    @LogAnno(operateType = "文档基础属性/删除")

    @PostMapping("/deleteField")
    public GlobalResult deleteField(String id){

        return fileBaseService.deleteFileBase(id);
    }


}
