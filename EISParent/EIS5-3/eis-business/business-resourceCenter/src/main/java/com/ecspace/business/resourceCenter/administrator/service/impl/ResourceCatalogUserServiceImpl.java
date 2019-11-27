package com.ecspace.business.resourceCenter.administrator.service.impl;

import com.ecspace.business.resourceCenter.administrator.dao.ResourceCatalogUserDao;
import com.ecspace.business.resourceCenter.administrator.service.ResourceCatalogUserService;
import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalogUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("resourceCatalogUserService")
public class ResourceCatalogUserServiceImpl implements ResourceCatalogUserService {
    @Autowired
    private ResourceCatalogUserDao resourceCatalogUserDao;

    @Override
    public List<ResourceCatalogUser> list(Map<String, Object> map) {
        List<ResourceCatalogUser> list = resourceCatalogUserDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public long listTotal(Map<String, Object> map) {
        return resourceCatalogUserDao.listTotal(map);
    }

    @Override
    public List<ResourceCatalogUser> listNotResourceUser(Map<String, Object> map) {
        List<ResourceCatalogUser> list = resourceCatalogUserDao.listNotResourceUser(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public boolean deleteBatch(List<ResourceCatalogUser> list) {
        long total = resourceCatalogUserDao.deleteBatch(list);
        return total > 0;
    }

    @Override
    public boolean saveBatch(List<ResourceCatalogUser> list) {
        long total = resourceCatalogUserDao.saveBatch(list);
        return total > 0;
    }
}
