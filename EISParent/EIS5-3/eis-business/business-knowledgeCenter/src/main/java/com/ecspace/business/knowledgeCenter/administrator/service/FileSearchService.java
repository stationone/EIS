package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

/**
 * DSL接口
 * @author zhangch
 * @date 2019/11/26 0026 下午 14:24
 */
public interface FileSearchService {

    /**
     * 没搜索词
     * @param menuId
     * @param page
     * @param rows
     * @return
     */
    PageData getFilePageList(String menuId, Integer page, Integer rows);

    /**
     * 有搜索词
     * @param menuId
     * @param search
     * @param page
     * @param rows
     * @return
     */
    PageData getFilePageList(String menuId, String search, Integer page, Integer rows);

}
