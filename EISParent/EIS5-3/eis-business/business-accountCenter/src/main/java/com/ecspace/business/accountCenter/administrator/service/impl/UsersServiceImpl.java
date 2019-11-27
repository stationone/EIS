package com.ecspace.business.accountCenter.administrator.service.impl;

import com.ecspace.business.accountCenter.administrator.service.UsersService;
import com.ecspace.business.accountCenter.administrator.dao.UsersDao;
import com.ecspace.business.accountCenter.administrator.entity.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Service("usersService")
public class UsersServiceImpl implements UsersService {

    @Autowired
    private UsersDao usersDao;

    @Override
    public List<Users> list(Map<String, Object> map) {
        List<Users> list = usersDao.list(map);
        return list != null && list.size() > 0 ? list : null ;
    }

    @Override
    public long listTotal(Map<String, Object> map) {
        return usersDao.listTotal(map);
    }

    @Override
    public boolean create(Users users) {
        if(users == null){
            return false;
        }
        List<Users> list = new LinkedList<>();
        list.add(users);
        long total = usersDao.createBatch(list);
        return total > 0;
    }

    @Override
    public boolean create(List<Users> list) {
        if(list == null){
            return false;
        }
        long total = usersDao.createBatch(list);
        return total > 0;
    }

    @Override
    public boolean update(Users users) {
        if(users == null){
            return false;
        }
        List<Users> list = new LinkedList<>();
        list.add(users);
        long total = usersDao.updateBatch(list);
        return total > 0;
    }

    @Override
    public boolean update(List<Users> list) {
        if(list == null){
            return false;
        }
        long total = usersDao.updateBatch(list);
        return total > 0;
    }


}
