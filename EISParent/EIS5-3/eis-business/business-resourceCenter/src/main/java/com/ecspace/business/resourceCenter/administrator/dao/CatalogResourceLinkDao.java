package com.ecspace.business.resourceCenter.administrator.dao;

import com.ecspace.business.resourceCenter.administrator.entity.CatalogResourceLink;

import java.util.List;
import java.util.Map;

/**
 * 目录资源关联
 */
public interface CatalogResourceLinkDao {

    /**
     * 批量查询，查询编号前几位数和目录编号一致的数据
     * @param map
     * @return
     */
    List<CatalogResourceLink> listBatchByCatalogNO(Map<String, Object> map);

    /**
     * 删除
     * @param links
     * @return
     */
    long deleteBatch(List<CatalogResourceLink> links);

    /**
     * 批量删除
     * 通过目录编号
     * @param map
     * @return
     */
    long deleteBatchByCatalogNO(Map<String, Object> map);


}
