package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileType;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author zhangch
 * @date 2019/12/5 0005 下午 20:23
 */
@RequestMapping("/fileType")
@RestController
public class FileTypeController {

    @Autowired
    private FileTypeService fileTypeService;

    /**
     * 获取 树菜单
     * @return
     */
    @GetMapping("/listFileType")
    public List<FileType> listTree(){
        return fileTypeService.listFileType();
    }

    //类型内容
    @LogAnno(operateType = "类型定义/添加")
    @PostMapping("/insert")
    public GlobalResult insert(FileType fileType){
        return fileTypeService.insertField(fileType);
    }


    /**
     * 目录表单操作
     */
    @LogAnno(operateType = "类型定义/添加或修改")

    @PostMapping("/submit")
    public GlobalResult create(FileType fileType){
        if (fileType == null || "".equals(fileType.getText())) {
            return new GlobalResult(false, 2001,"非法参数");
        }
        if (fileType.getId() == null || "".equals(fileType.getId())) {
            //新建
            return fileTypeService.insert(fileType);
        } else {
            //编辑
//            return menuService.insertMenu(menu);
            return fileTypeService.update(fileType);

        }
    }

    /**
     * 删除
     */
    @LogAnno(operateType = "类型定义/删除")

    @PostMapping("/delete")
    public GlobalResult delete(String id){
        if (id == null) {
            return new GlobalResult(false, 2001,"非法参数");
        }

        return fileTypeService.delete(id);
    }

    //根据树id, 查询index中的field信息
    @PostMapping("/fileTypeList")
    public PageData fileTypeList(String id, Integer page, Integer size){

        return fileTypeService.fileTypeDetail(id ,page, size);
    }


}
