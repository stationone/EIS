package com.ecspace.business.resourceCenter.user.service.impl;

import com.ecspace.business.resourceCenter.user.dao.UserResourceCatalogDao;
import com.ecspace.business.resourceCenter.user.service.ResourceCatalogService;
import com.ecspace.business.resourceCenter.user.service.entity.ResourceCatalog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userResourceCatalogService")
public class ResourceCatalogServiceImpl implements ResourceCatalogService {
    @Autowired
    private UserResourceCatalogDao userResourceCatalogDao;
    @Override
    public List<ResourceCatalog> list(Map<String, Object> map) {
        List<ResourceCatalog> list = userResourceCatalogDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public List<ResourceCatalog> listUserCheckOutByUserTNO(Map<String, Object> map) {
        List<ResourceCatalog> list = userResourceCatalogDao.listUserCheckOutByUserTNO(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public List<ResourceCatalog> listUserCatalogJurisdictionByUserTNOorParentNO(Map<String, Object> map) {
        List<ResourceCatalog> list = userResourceCatalogDao.listUserCatalogJurisdictionByUserTNOorParentNO(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public boolean create(ResourceCatalog resourceCatalog) {
        long total = userResourceCatalogDao.create(resourceCatalog);
        return total > 0;
    }

    @Override
    public String listMaxNO(String parentNO) {
        return userResourceCatalogDao.listMaxNO(parentNO);
    }

    @Override
    public boolean update(ResourceCatalog resourceCatalog) {
        long total = userResourceCatalogDao.update(resourceCatalog);
        return total > 0;
    }
}
