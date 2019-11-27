package com.ecspace.business.knowledgeCenter.user.service.impl;

import com.ecspace.business.employeeCenter.entity.User;
import com.ecspace.business.knowledgeCenter.user.dao.TextDao;
import com.ecspace.business.knowledgeCenter.user.service.TextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service("textService")
public class TextServiceImpl implements TextService {

    @Autowired
    private TextDao userDao;

    public List<User> list() {

        return userDao.list(new HashMap<String ,Object>());
    }
}
