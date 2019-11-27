package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.alibaba.fastjson.JSON;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileSearchService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * DSL文档检索
 *
 * @author zhangch
 * @date 2019/11/26 0026 下午 14:20
 */
@RestController
@RequestMapping("/fileSearch")
public class FileSearchController {

    @Autowired
    private FileSearchService fileSearchService;

    /**
     * 获取page内容
     *
     * @param search
     * @return pageData
     * @throws Exception
     */
    @GetMapping(value = "/filePageList")
    public PageData filePageList(String menuId, String search, Integer page, Integer rows) throws Exception {
//        if (StringUtils.isBlank(menuId)) {
//            return new PageData();
//        }
        //没有请求参数时,  搜索page内容
        if (StringUtils.isBlank(search)) {//非空判断
            return fileSearchService.getFilePageList(menuId, page, rows);
        }
        //DSL全文检索
        return fileSearchService.getFilePageList(menuId, search, page, rows);
    }


}
