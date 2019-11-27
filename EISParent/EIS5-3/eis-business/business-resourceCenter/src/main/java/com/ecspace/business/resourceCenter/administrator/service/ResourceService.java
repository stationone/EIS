package com.ecspace.business.resourceCenter.administrator.service;

import com.ecspace.business.resourceCenter.administrator.entity.Resource;

import java.util.List;
import java.util.Map;

public interface ResourceService {

    /**
     * 条件查询方法
     * @param map
     * @return
     */
    List<Resource> list(Map<String, Object> map);

    /**
     * 条件查询目录资源关联表
     * @param map
     * @return
     */
    List<Resource> listByCatalogResLink(Map<String, Object> map);

    /**
     * 条件查询目录资源关联表数量
     * @param map
     * @return
     */
    Long listByCatalogResLinkTotal(Map<String, Object> map);

    /**
     * 批量删除
     * @param list
     * @return
     */
    boolean deleteBatch(List<Resource> list);

}
