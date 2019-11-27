package com.ecspace.business.resourceCenter.user.service;

import com.ecspace.business.resourceCenter.user.service.entity.ResourceCatalog;

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
     * 查询用户检出工作副本
     * @param map
     * @return
     */
    List<ResourceCatalog> listUserCheckOutByUserTNO(Map<String, Object> map);

    /**
     * 查询用户对目录的权限
     * @param map
     * @return
     */
    List<ResourceCatalog> listUserCatalogJurisdictionByUserTNOorParentNO(Map<String, Object> map);

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
     * 更新目录
     * @param resourceCatalog
     * @return
     */
    boolean update(ResourceCatalog resourceCatalog);

}
