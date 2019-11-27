package com.ecspace.business.resourceCenter.administrator.dao;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserLink;

import java.util.List;
import java.util.Map;

/**
 * 目录用户关联表
 */
public interface CatalogUserLinkDao {
    /**
     * 条件查询
     * @param map
     * @return
     */
    List<CatalogUserLink> list(Map<String, Object> map);

    /**
     * 条件查询
     * 数量
     * @param map
     * @return
     */
    long listTotal(Map<String, Object> map);

    /**
     * 查询拥有目录权限的用户
     * @param map
     * @return
     */
    List<CatalogUserLink> listOwnJurisdictionUserByCatalogNO(Map<String, Object> map);

    /**
     * 查询拥有目录权限的用户数量
     * @param map
     * @return
     */
    long listTotalOwnJurisdictionUserByCatalogNO(Map<String, Object> map);

    /**
     * 查询未拥有目录权限的用户
     * @param map
     * @return
     */
    List<CatalogUserLink> listNotOwnJurisdictionUserByCatalogNO(Map<String, Object> map);

    /**
     * 批量添加
     * @param links
     * @return
     */
    long createBatch(List<CatalogUserLink> links);

    /**
     * 批量删除通过用户编号
     * @param links
     * @return
     */
    long deleteBatchByUserTNO(List<CatalogUserLink> links);


    /**
     * 批量删除通过用户编号和目录编号
     * 包括子目录
     * @param links
     * @return
     */
    long deleteBatchByUserIdAndCatalogNO(List<CatalogUserLink> links);

    /**
     * 批量删除目录和子目录
     * 通过用户tNO 和 目录tNO
     * @Author lv
     * @param list
     * @return
     */
    int deleteBatchByUserIdAndCatalogNOAll(List<Map<String, Object>> list);

    /**
     * 批量删除和目录有关的记录
     * @param map
     * @return
     */
    long deleteBatchByCatalogNO(Map<String, Object> map);

    /**
     * 根据用户和目录编号查询用户拥有目录和子目录的权限
     * @param map
     * @return
     */
    List<CatalogUserLink> listByUserTNOorCatalogNO(Map<String, Object> map);

    /**
     * 批量更新
     * @param links
     * @return
     */
    long updateBatch(List<CatalogUserLink> links);
}
