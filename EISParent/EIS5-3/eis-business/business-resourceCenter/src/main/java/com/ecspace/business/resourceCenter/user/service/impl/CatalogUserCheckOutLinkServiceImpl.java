package com.ecspace.business.resourceCenter.user.service.impl;

import com.ecspace.business.resourceCenter.user.dao.UserCatalogUserCheckOutLinkDao;
import com.ecspace.business.resourceCenter.user.service.CatalogUserCheckOutLinkService;
import com.ecspace.business.resourceCenter.user.service.entity.CatalogUserCheckOutLink;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userCatalogUserCheckOutLinkService")
public class CatalogUserCheckOutLinkServiceImpl implements CatalogUserCheckOutLinkService {
    @Autowired
    private UserCatalogUserCheckOutLinkDao userCatalogUserCheckOutLinkDao;

    @Override
    public List<CatalogUserCheckOutLink> list(Map<String, Object> map) {
        List<CatalogUserCheckOutLink> list = userCatalogUserCheckOutLinkDao.list(map);
        return list != null && list.size() > 0 ? list:null ;
    }

    @Override
    public boolean deleteBatch(List<CatalogUserCheckOutLink> links) {
        long total = userCatalogUserCheckOutLinkDao.deleteBatch(links);
        return total > 0;
    }

    @Override
    public boolean create(CatalogUserCheckOutLink catalogUserCheckOutLink) {
        long total = userCatalogUserCheckOutLinkDao.create(catalogUserCheckOutLink);
        return total > 0;
    }
}
