package com.ecspace.business.knowledgeCenter.administrator.controller;

import com.ecspace.business.knowledgeCenter.administrator.aop.LogAnno;
import com.ecspace.business.knowledgeCenter.administrator.pojo.SearchLog;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.FileSearchService;
import com.ecspace.business.knowledgeCenter.administrator.service.SearchLogService;
import com.ecspace.business.knowledgeCenter.administrator.util.IPUtil;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
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

    @Autowired
    private HttpServletRequest httpServletRequest;

    @Autowired
    private SearchLogService searchLogService;

    /**
     * 获取page内容 0
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

    @LogAnno(operateType = "全文检索")
    @GetMapping(value = "/fileList")
    public PageData fileList(@RequestParam(value = "search") String search, Integer page, Integer rows) throws Exception {
        PageData pageData = null;
        try {
            //没有请求参数时,  展示全部文件列表
            if (StringUtils.isBlank(search)) {//非空判断
                pageData = fileSearchService.fileList(page, rows);
            } else {
                //DSL全文检索
                pageData = fileSearchService.fileList(search, page, rows);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            return pageData;
        }
    }

    @GetMapping(value = "/treeList")
    public List treeList(){

        return null;
    }


}
