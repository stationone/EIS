package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

import java.io.IOException;

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
    PageData getFilePageList(String menuId, String search, Integer page, Integer rows) throws IOException;

    /**
     * 展示全部文档
     * @param page
     * @param rows
     * @return
     */
    PageData fileList(Integer page, Integer rows);

    /**
     * DSL全文检索
     * @param search
     * @param page
     * @param rows
     * @return
     */
    PageData fileList(String search, Integer page, Integer rows);
}
