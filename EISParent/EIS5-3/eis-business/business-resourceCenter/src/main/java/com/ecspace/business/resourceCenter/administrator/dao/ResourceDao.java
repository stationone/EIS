package com.ecspace.business.resourceCenter.administrator.dao;

import com.ecspace.business.resourceCenter.administrator.entity.Resource;

import java.util.List;
import java.util.Map;

public interface ResourceDao {
    /**
     * 基础查询
     * 含条件和分页
     * @param map
     * @return
     */
    List<Resource> list(Map<String, Object> map);

    /**
     * 条件查询目录资源关联表
     * 通过资源表和目录资源关联表查询目录下的资源
     * @param map
     * @return
     */
    List<Resource> listByCatalogResLink(Map<String, Object> map);

    /**
     * 条件查询目录资源关联表数量
     * 通过资源表和目录资源关联表查询目录下的资源数量
     * @param map
     * @return
     */
    long listByCatalogResLinkTotal(Map<String, Object> map);

    /**
     * 批量删除
     * @param list
     * @return
     */
    long deleteBatch(List<Resource> list);

}
