package com.ecspace.business.resourceCenter.user.dao;

import com.ecspace.business.resourceCenter.user.service.entity.CatalogUserCheckOutLink;

import java.util.List;
import java.util.Map;

/**
 * 用户检出目录副本
 */
public interface UserCatalogUserCheckOutLinkDao {

    /**
     * 条件查询
     * @param map
     * @return
     */
    List<CatalogUserCheckOutLink> list(Map<String, Object> map);

    /**
     * 批量删除用户检出目录
     * @param links
     * @return
     */
    long deleteBatch(List<CatalogUserCheckOutLink> links);


    /**
     * 创建
     * @param catalogUserCheckOutLink
     * @return
     */
    long create(CatalogUserCheckOutLink catalogUserCheckOutLink);


}
