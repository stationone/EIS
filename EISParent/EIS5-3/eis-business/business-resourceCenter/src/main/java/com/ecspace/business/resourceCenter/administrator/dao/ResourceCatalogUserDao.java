package com.ecspace.business.resourceCenter.administrator.dao;

import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalogUser;

import java.util.List;
import java.util.Map;

/**
 * 资源目录用户
 */
public interface ResourceCatalogUserDao {
    /**
     * 查询已存在的
     * 根据资源目录用户和用户表查询已存在用户信息
     * @param map
     * @return
     */
    List<ResourceCatalogUser> list(Map<String, Object> map);

    /**
     * 查询已存在的数量
     * 根据资源目录用户和用户表查询已存在用户数量
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
    long deleteBatch(List<ResourceCatalogUser> list);

    /**
     * 批量新增
     * @param list
     * @return
     */
    long saveBatch(List<ResourceCatalogUser> list);
}
