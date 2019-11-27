package com.ecspace.business.resourceCenter.user.service.impl;

import com.ecspace.business.resourceCenter.user.dao.UserCatalogResourceLinkDao;
import com.ecspace.business.resourceCenter.user.service.CatalogResourceLinkService;
import com.ecspace.business.resourceCenter.user.service.entity.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("userCatalogResourceLinkService")
public class CatalogResourceLinkServiceImpl implements CatalogResourceLinkService {

    @Autowired
    private UserCatalogResourceLinkDao userCatalogResourceLinkDao;
    @Override
    public boolean create(Resource resource) {
        long total = userCatalogResourceLinkDao.create(resource);
        return total > 0;
    }

    @Override
    public boolean createBatch(List<Resource> list) {
        long total = userCatalogResourceLinkDao.createBatch(list);
        return total > 0;
    }
}
