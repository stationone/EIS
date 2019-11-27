package com.ecspace.business.knowledgeCenter.user.dao;




import com.ecspace.business.employeeCenter.entity.User;

import java.util.HashMap;
import java.util.List;


public interface TextDao {

    List<User> list(HashMap<String, Object> map);
}
