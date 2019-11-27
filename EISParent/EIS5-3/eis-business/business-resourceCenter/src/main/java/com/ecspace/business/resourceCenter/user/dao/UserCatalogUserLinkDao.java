package com.ecspace.business.resourceCenter.user.dao;

import com.ecspace.business.resourceCenter.user.service.entity.CatalogUserLink;

import java.util.List;
import java.util.Map;

/**
 * 目录用户关联表
 */
public interface UserCatalogUserLinkDao {

    /**
     * 条件查询
     * @param map
     * @return
     */
    List<CatalogUserLink> list(Map<String, Object> map);

    /**
     * 查询拥有目录权限的用户
     * @param map
     * @return
     */
    List<CatalogUserLink> listOwnJurisdictionUserByCatalogNO(Map<String, Object> map);


    /**
     * 批量添加
     * @param links
     * @return
     */
    long createBatch(List<CatalogUserLink> links);

}
