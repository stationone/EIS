package com.ecspace.business.accountCenter.administrator.service;

import com.ecspace.business.accountCenter.administrator.entity.Users;

import java.util.List;
import java.util.Map;

public interface UsersService {

    /**
     * 基础查询
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
     * 创建用户
     * @param users
     * @return
     */
    boolean create(Users users);

    /**
     * 批量创建用户
     * @param list
     * @return
     */
    boolean create(List<Users> list);

    /**
     * 更新用户
     * @param users
     * @return
     */
    boolean update(Users users);

    /**
     * 批量更新用户
     * @param list
     * @return
     */
    boolean update(List<Users> list);



}
