package com.ecspace.business.resourceCenter.administrator.service;

import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalogUser;

import java.util.List;
import java.util.Map;

/**
 * 资源目录用户
 */
public interface ResourceCatalogUserService {

    /**
     * 查询已存在的
     * @param map
     * @return
     */
    List<ResourceCatalogUser> list(Map<String, Object> map);

    /**
     * 查询已存在的
     * 数量
     * @param map
     * @return
     */
    long listTotal(Map<String, Object> map);

    /**
     * 查询未存在的
     * @param map
     * @return
     */
    List<ResourceCatalogUser> listNotResourceUser(Map<String, Object> map);

    /**
     * 批量删除
     * @param list
     * @return
     */
    boolean deleteBatch(List<ResourceCatalogUser> list);

    /**
     * 批量新增
     * @param list
     * @return
     */
    boolean saveBatch(List<ResourceCatalogUser> list);
}
