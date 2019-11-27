package com.ecspace.business.accountCenter.administrator.service;

import com.ecspace.business.accountCenter.administrator.entity.Department;

import java.util.List;
import java.util.Map;

public interface DepartmentService {

    /**
     * 查询全部
     * @param map
     * @return
     */
    List<Department> list(Map<String, Object> map);

    /**
     * 部门新建
     * @param department
     * @return
     */
    boolean save(Department department);

    /**
     * 更新
     * 通过tNO
     * @param department
     * @return
     */
    boolean update(Department department);

    /**
     * 删除
     * 通过TNO
     * @param tNO
     * @return
     */
    boolean delete(String tNO);

    /**
     * 删除部门及其子节点
     * 通过TNO
     * @param tNO
     * @return
     */
    boolean deleteOrChild(String tNO);
}
