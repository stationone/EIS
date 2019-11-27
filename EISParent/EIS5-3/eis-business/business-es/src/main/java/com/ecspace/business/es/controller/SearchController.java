package com.ecspace.business.es.controller;

import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.service.BaseFieldService;
import com.ecspace.business.es.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 搜索服务
 *
 * @author zhangch
 * @date 2019/10/15 0015 上午 10:58
 */
@RestController
@RequestMapping("/search")
public class SearchController {
    @Autowired
    private SearchService searchService;

    /**
     * 查看所有选中索引库的字段列表 该字段需用作内容的表头,
     *
     * @param indexNames
     * @return
     */
    @RequestMapping(value = "/getTitle")
    public List getTitle(String[] indexNames) {
        if (Arrays.asList(indexNames).contains("null")||indexNames == null || indexNames.length == 0) {
//            不查数据
            return new ArrayList();
        }

        List<String> list = Arrays.asList(indexNames);
        return searchService.getSearchTitle(list);
    }

    /**
     * 跨库检索
     *
     * @param indexNames 索引库数组
     * @param json searchForm表单
     * @param page 分页参数
     * @param rows 分页参数
     * @param sort 排序字段
     * @param order 排序规则
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getList")
    public PageData getList(String[] indexNames, String json, Integer page, Integer rows, String sort, String order) throws Exception {
//        没选中索引库不进行搜索
        if (indexNames == null || indexNames.length == 0) {
            //返回空list
            return new PageData(new ArrayList());
        }

//        List<String> list = Arrays.asList(indexNames);
        //没有请求参数时, 数据全部搜索出来

        return searchService.searchAll(indexNames,json,page,rows,sort,order);
        //        //条件查询
//        return searchService.searchList(indexNames, json, page, rows, sort, order);
    }

    @Autowired
    private BaseFieldService baseFieldService;
    /**
     * 获取高级检索字段列表
     * @return
     */
    @RequestMapping(value = "/getSearchField")
    public List getSearchField() {
        List rows = baseFieldService.findAll().getRows();
        return rows;
    }

}
