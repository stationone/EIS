package com.ecspace.business.accountCenter.administrator.service.impl;

import com.ecspace.business.accountCenter.administrator.dao.DepartmentDao;
import com.ecspace.business.accountCenter.administrator.entity.Department;
import com.ecspace.business.accountCenter.administrator.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("departmentService")
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentDao departmentDao;

    @Override
    public List<Department> list(Map<String, Object> map) {
        List<Department> list = departmentDao.list(map);
        return list != null && list.size() != 0 ? list: null;
    }

    @Override
    public boolean save(Department department) {
        int result = departmentDao.save(department);
        return result > 0;
    }

    @Override
    public boolean update(Department department) {
        int result = departmentDao.update(department);
        return result > 0;
    }

    @Override
    public boolean delete(String tNO) {
        int result = departmentDao.delete(tNO);
        return result > 0;
    }

    @Override
    public boolean deleteOrChild(String tNO) {
        int result = departmentDao.deleteOrChild(tNO);
        return result > 0;
    }
}
