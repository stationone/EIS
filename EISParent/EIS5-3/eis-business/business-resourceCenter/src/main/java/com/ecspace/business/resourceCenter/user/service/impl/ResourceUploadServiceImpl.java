package com.ecspace.business.resourceCenter.user.service.impl;


import com.ecspace.business.resourceCenter.user.dao.ResourceUploadDao;
import com.ecspace.business.resourceCenter.user.service.ResourceUploadService;
import com.ecspace.business.resourceCenter.user.service.entity.ResUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Service("resourceUploadService")
public class ResourceUploadServiceImpl implements ResourceUploadService {

    @Autowired
    private ResourceUploadDao resourceUploadDao;


    @Override
    public List<ResUpload> list(Map<String, Object> map) {
        List<ResUpload> list = resourceUploadDao.list(map);
        return list !=null && list.size() > 0 ? list : null;
    }

    @Override
    public boolean add(ResUpload resUpload) {
        int result =  resourceUploadDao.add(resUpload);
        return result > 0 ;
    }

    @Override
    public boolean delete(Map<String, Object> map) {
        int result = resourceUploadDao.delete(map);
        return result > 0 ;
    }

    @Override
    public boolean deleteAll(List<ResUpload> list) {
        int result = resourceUploadDao.deleteAll(list);
        return result > 0 ;
    }

    @Override
    public boolean updateByUserId(String userId) {
        int result = resourceUploadDao.updateByUserId(userId);
        return result > 0;
    }
}
