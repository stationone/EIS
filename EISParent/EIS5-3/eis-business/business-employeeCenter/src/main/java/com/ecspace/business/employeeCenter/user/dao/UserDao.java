package com.ecspace.business.employeeCenter.user.dao;

import com.ecspace.business.employeeCenter.entity.User;

import java.util.HashMap;
import java.util.List;

public interface UserDao {

    List<User> list(HashMap<String, Object> map);
}
