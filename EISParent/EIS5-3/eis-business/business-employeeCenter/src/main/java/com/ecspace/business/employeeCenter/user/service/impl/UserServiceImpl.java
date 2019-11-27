package com.ecspace.business.employeeCenter.user.service.impl;

import com.ecspace.business.employeeCenter.entity.User;
import com.ecspace.business.employeeCenter.user.dao.UserDao;
import com.ecspace.business.employeeCenter.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    public List<User> list() {

        return userDao.list(new HashMap<String ,Object>());
    }
}
