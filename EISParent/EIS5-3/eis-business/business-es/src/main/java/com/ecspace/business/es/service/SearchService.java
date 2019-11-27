package com.ecspace.business.es.service;

import com.ecspace.business.es.pojo.entity.PageData;

import java.util.List;

/**
 * 搜索服务
 *
 * @author zhangch
 * @date 2019/11/4 0004 上午 11:13
 */
public interface SearchService {

    /**
     * 获取跨库表头
     * @param indexNames
     * @return
     */
    List getSearchTitle(List<String> indexNames);

    /**
     * 跨库检索
     * @param indexNames
     * @param json
     * @param page
     * @param rows
     * @param sort
     * @param order
     * @return
     */
    PageData searchAll(String[] indexNames, String json, Integer page, Integer rows, String sort, String order);
}
