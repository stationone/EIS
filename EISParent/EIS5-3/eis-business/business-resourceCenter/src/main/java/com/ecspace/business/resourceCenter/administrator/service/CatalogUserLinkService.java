package com.ecspace.business.resourceCenter.administrator.service;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserLink;

import java.util.List;
import java.util.Map;

/**
 * 目录用户关联表
 */
public interface CatalogUserLinkService {

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
    Long listTotalOwnJurisdictionUserByCatalogNO(Map<String, Object> map);

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
    boolean createBatch(List<CatalogUserLink> links);

    /**
     * 批量删除通过用户编号
     * @param links
     * @return
     */
    boolean deleteBatchByUserTNO(List<CatalogUserLink> links);

    /**
     * 批量删除目录和子目录
     * 通过用户tNO 和 目录tNO
     * @Author lv
     * @param userTNO ['123123123']
     * @param catalogNO 0808
     * @return
     */
    boolean deleteBatchByUserIdAndCatalogNOAll(List<String> userTNO, String catalogNO);


    /**
     * 批量删除通过用户编号和目录编号
     * @param links
     * @return
     */
    boolean deleteBatchByUserIdAndCatalogNO(List<CatalogUserLink> links);

    /**
     * 批量删除和目录有关的记录
     * @param map
     * @return
     */
    boolean deleteBatchByCatalogNO(Map<String, Object> map);

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
    boolean updateBatch(List<CatalogUserLink> links);
}
