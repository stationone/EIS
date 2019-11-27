package com.ecspace.business.resourceCenter.administrator.service.impl;

import com.ecspace.business.resourceCenter.administrator.dao.CatalogResourceLinkDao;
import com.ecspace.business.resourceCenter.administrator.service.CatalogResourceLinkService;
import com.ecspace.business.resourceCenter.administrator.entity.CatalogResourceLink;
import com.ecspace.business.resourceCenter.util.MapUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("catalogResourceLinkService")
public class CatalogResourceLinkServiceImpl implements CatalogResourceLinkService {

    @Autowired
    private CatalogResourceLinkDao catalogResourceLinkDao;

    @Override
    public boolean deleteBatch(List<CatalogResourceLink> links) {
        long total = catalogResourceLinkDao.deleteBatch(links);
        return total > 0;
    }

    @Override
    public boolean deleteBatchByCatalogNO(Map<String, Object> map) {
        Map<String, Object> map1 = MapUtil.assembleMap(map);
        if(map1 == null){
            return false;
        }
        long total = catalogResourceLinkDao.deleteBatchByCatalogNO(map1);
        return total > 0;
    }

    @Override
    public List<CatalogResourceLink> listBatchByCatalogNO(Map<String, Object> map) {
        Map<String, Object> map1 = MapUtil.assembleMap(map);
        if(map1 == null){
            return null;
        }
        List<CatalogResourceLink> list = catalogResourceLinkDao.listBatchByCatalogNO(map1);
        return list != null && list.size() > 0 ? list : null;
    }
}
