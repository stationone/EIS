package com.ecspace.business.resourceCenter.administrator.service.impl;

import com.ecspace.business.resourceCenter.administrator.dao.ResourceCatalogDao;
import com.ecspace.business.resourceCenter.administrator.service.ResourceCatalogService;
import com.ecspace.business.resourceCenter.administrator.entity.ResourceCatalog;
import com.ecspace.business.resourceCenter.util.MapUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("resourceCatalogService")
public class ResourceCatalogServiceImpl implements ResourceCatalogService {

    @Autowired
    private ResourceCatalogDao resourceCatalogDao;

    @Override
    public List<ResourceCatalog> list(Map<String, Object> map) {
        List<ResourceCatalog> list = resourceCatalogDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public long listTotal(Map<String, Object> map) {
        return 0;
    }


    @Override
    public boolean create(ResourceCatalog resourceCatalog) {
        long total = resourceCatalogDao.create(resourceCatalog);
        return total > 0;
    }

    @Override
    public String listMaxNO(String parentNO) {
        return resourceCatalogDao.listMaxNO(parentNO);
    }

    @Override
    public boolean deleteBatchByCatalogNO(Map<String, Object> map) {
        Map<String, Object> map1 = MapUtil.assembleMap(map);
        if(map1 == null){
            return false;
        }
        long total = resourceCatalogDao.deleteBatchByCatalogNO(map1);
        return total > 0;
    }
}
