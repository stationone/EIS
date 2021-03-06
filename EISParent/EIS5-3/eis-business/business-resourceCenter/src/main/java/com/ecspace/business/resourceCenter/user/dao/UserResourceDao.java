package com.ecspace.business.resourceCenter.user.dao;

import com.ecspace.business.resourceCenter.user.service.entity.Resource;

import java.util.List;
import java.util.Map;

/**
 * 资源操作
 */
public interface UserResourceDao {

    /**
     * 条件查询方法
     * @param map
     * @return
     */
    List<Resource> list(Map<String, Object> map);

    /**
     * 条件查询目录资源关联表
     * @param map
     * @return
     */
    List<Resource> listByCatalogResLink(Map<String, Object> map);

    /**
     * 条件查询目录资源关联表数量
     * @param map
     * @return
     */
    Long listByCatalogResLinkTotal(Map<String, Object> map);

    /**
     * 查询最大编号
     * @return
     */
    String listMaxId(String resId);

    /**
     * 批量删除
     * @param list
     * @return
     */
    long createBatch(List<Resource> list);

    /**
     * 批量更新
     * @param list
     * @return
     */
    long updateBatch(List<Resource> list);


}
