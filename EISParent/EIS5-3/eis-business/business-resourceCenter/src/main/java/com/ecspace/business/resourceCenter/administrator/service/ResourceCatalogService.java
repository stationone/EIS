package com.ecspace.business.resourceCenter.administrator.service;

import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalog;

import java.util.List;
import java.util.Map;

/**
 * 资源目录
 */
public interface ResourceCatalogService {

    /**
     * 条件查询
     * @param map
     * @return
     */
    List<ResourceCatalog> list(Map<String, Object> map);

    /**
     * 条件查询
     * 数量
     * @param map
     * @return
     */
    long listTotal(Map<String, Object> map);

    /**
     * 创建目录
     * @param resourceCatalog
     * @return
     */
    boolean create(ResourceCatalog resourceCatalog);

    /**
     * 查询最大编号
     * @param parentNO
     * @return
     */
    String listMaxNO(String parentNO);

    /**
     * 批量删除目录编号的
     * @param map
     * @return
     */
    boolean deleteBatchByCatalogNO(Map<String, Object> map);




}
