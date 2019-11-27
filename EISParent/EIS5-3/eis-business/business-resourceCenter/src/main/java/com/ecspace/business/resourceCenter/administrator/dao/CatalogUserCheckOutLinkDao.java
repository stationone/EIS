package com.ecspace.business.resourceCenter.administrator.dao;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserCheckOutLink;

import java.util.List;
import java.util.Map;

/**
 * 用户检出目录副本
 */
public interface CatalogUserCheckOutLinkDao {

    /**
     * 条件查询
     * @param map
     * @return
     */
    List<CatalogUserCheckOutLink> list(Map<String, Object> map);

    /**
     * 批量删除目录通过用户编号
     * @param list
     * @return
     */
    long deleteBatchByUserTNO(List<CatalogUserCheckOutLink> list);

    /**
     * 更新属性字段
     * @param map
     * @return
     */
    long update(Map<String, Object> map);

}
