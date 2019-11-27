package com.ecspace.business.resourceCenter.administrator.service;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserCheckOutLink;

import java.util.List;
import java.util.Map;

/**
 * 用户检出目录副本
 */
public interface CatalogUserCheckOutLinkService {

    /**
     * 条件查询
     * @param map
     * @return
     */
    List<CatalogUserCheckOutLink> list(Map<String, Object> map);

    /**
     * 批量删除目录通过用户编号
     * @param links
     * @return
     */
    boolean deleteBatchByUserTNO(List<CatalogUserCheckOutLink> links);

    /**
     * 更新属性字段
     * @param map
     * @return
     */
    boolean update(Map<String, Object> map);



}
