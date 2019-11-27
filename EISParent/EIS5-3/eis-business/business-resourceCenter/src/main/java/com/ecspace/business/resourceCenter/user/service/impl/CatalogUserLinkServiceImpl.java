package com.ecspace.business.resourceCenter.user.service.impl;

import com.ecspace.business.resourceCenter.user.dao.UserCatalogUserLinkDao;
import com.ecspace.business.resourceCenter.user.service.CatalogUserLinkService;
import com.ecspace.business.resourceCenter.user.service.entity.CatalogUserLink;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userCatalogUserLinkService")
public class CatalogUserLinkServiceImpl implements CatalogUserLinkService {

    @Autowired
    private UserCatalogUserLinkDao userCatalogUserLinkDao;

    @Override
    public List<CatalogUserLink> list(Map<String, Object> map) {
        List<CatalogUserLink> list = userCatalogUserLinkDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public List<CatalogUserLink> listOwnJurisdictionUserByCatalogNO(Map<String, Object> map) {
        List<CatalogUserLink> list = userCatalogUserLinkDao.listOwnJurisdictionUserByCatalogNO(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public boolean createBatch(List<CatalogUserLink> links) {
        long total = userCatalogUserLinkDao.createBatch(links);
        return total > 0;
    }
}
