package com.ecspace.business.accountCenter.administrator.dao;

import com.ecspace.business.accountCenter.administrator.entity.Users;

import java.util.List;
import java.util.Map;

/**
 * 用户类接口
 */
public interface UsersDao {
    /**
     * 基础查询
     * 含条件分页
     * @param map
     * @return
     */
    List<Users> list(Map<String, Object> map);

    /**
     * 基础查询
     * 数量
     * @param map
     * @return
     */
    long listTotal(Map<String, Object> map);

    /**
     * 批量创建
     * @param list
     * @return
     */
    long createBatch(List<Users> list);

    /**
     * 批量更新
     * @param list
     * @return
     */
    long updateBatch(List<Users> list);
}
