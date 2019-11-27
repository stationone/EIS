package com.ecspace.business.accountCenter.administrator.dao;

import com.ecspace.business.accountCenter.administrator.entity.Department;

import java.util.List;
import java.util.Map;

public interface DepartmentDao {
    /**
     * 查询
     * @param map
     * @return
     */
    List<Department> list(Map<String, Object> map);

    /**
     * 新建
     * @param department
     * @return
     */
    int save(Department department);

    /**
     * 更新
     * 通过tNO
     * @param department
     * @return
     */
    int update(Department department);

    /**
     * 删除
     * 通过tNO
     * @param tNO
     * @return
     */
    int delete(String tNO);

    /**
     * 删除及其子节点
     * 通过tNO
     * @param tNO
     * @return
     */
    int deleteOrChild(String tNO);

}
