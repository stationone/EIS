package com.ecspace.business.resourceCenter.user.service.impl;

import com.ecspace.business.resourceCenter.user.dao.UserResourceDao;
import com.ecspace.business.resourceCenter.user.service.ResourceService;
import com.ecspace.business.resourceCenter.user.service.entity.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userResourceService")
public class ResourceServiceImpl implements ResourceService {

    @Autowired
    private UserResourceDao userResourceDao;

    @Override
    public List<Resource> list(Map<String, Object> map) {
        List<Resource> list = userResourceDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public List<Resource> listByCatalogResLink(Map<String, Object> map) {
        List<Resource> list = userResourceDao.listByCatalogResLink(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public Long listByCatalogResLinkTotal(Map<String, Object> map) {
        return userResourceDao.listByCatalogResLinkTotal(map);
    }

    @Override
    public String listMaxId(String resId) {
        return userResourceDao.listMaxId(resId);
    }

    @Override
    public boolean createBatch(List<Resource> list) {
        long a = userResourceDao.createBatch(list);
        return a != -1;
    }

    @Override
    public boolean updateBatch(List<Resource> list) {
        long a = userResourceDao.updateBatch(list);
        return a != -1;
    }

}
