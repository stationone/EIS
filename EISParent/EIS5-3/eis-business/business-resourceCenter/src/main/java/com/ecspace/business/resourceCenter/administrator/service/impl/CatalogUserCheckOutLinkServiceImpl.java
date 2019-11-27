package com.ecspace.business.resourceCenter.administrator.service.impl;

import com.ecspace.business.resourceCenter.administrator.dao.CatalogUserCheckOutLinkDao;
import com.ecspace.business.resourceCenter.administrator.service.CatalogUserCheckOutLinkService;
import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserCheckOutLink;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("catalogUserCheckOutLinkService")
public class CatalogUserCheckOutLinkServiceImpl implements CatalogUserCheckOutLinkService {

    @Autowired
    private CatalogUserCheckOutLinkDao catalogUserCheckOutLinkDao;

    @Override
    public List<CatalogUserCheckOutLink> list(Map<String, Object> map) {
        List<CatalogUserCheckOutLink> list = catalogUserCheckOutLinkDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public boolean deleteBatchByUserTNO(List<CatalogUserCheckOutLink> links) {
        long total = catalogUserCheckOutLinkDao.deleteBatchByUserTNO(links);
        return total > 0;
    }

    @Override
    public boolean update(Map<String, Object> map) {
        long total = catalogUserCheckOutLinkDao.update(map);
        return total > 0;
    }
}
