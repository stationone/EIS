package com.ecspace.business.resourceCenter.administrator.service.impl;

import com.ecspace.business.resourceCenter.administrator.dao.CatalogUserLinkDao;
import com.ecspace.business.resourceCenter.administrator.service.CatalogUserLinkService;
import com.ecspace.business.resourceCenter.administrator.entity.CatalogUserLink;
import com.ecspace.business.resourceCenter.util.MapUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("catalogUserLinkService")
public class CatalogUserLinkServiceImpl implements CatalogUserLinkService {

    @Autowired
    private CatalogUserLinkDao catalogUserLinkDao;

    @Override
    public List<CatalogUserLink> list(Map<String, Object> map) {
        List<CatalogUserLink> list = catalogUserLinkDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public long listTotal(Map<String, Object> map) {
        return catalogUserLinkDao.listTotal(map);
    }

    @Override
    public List<CatalogUserLink> listOwnJurisdictionUserByCatalogNO(Map<String, Object> map) {
        List<CatalogUserLink> list = catalogUserLinkDao.listOwnJurisdictionUserByCatalogNO(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public Long listTotalOwnJurisdictionUserByCatalogNO(Map<String, Object> map) {
        return catalogUserLinkDao.listTotalOwnJurisdictionUserByCatalogNO(map);
    }

    @Override
    public List<CatalogUserLink> listNotOwnJurisdictionUserByCatalogNO(Map<String, Object> map) {
        List<CatalogUserLink> list = catalogUserLinkDao.listNotOwnJurisdictionUserByCatalogNO(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public boolean createBatch(List<CatalogUserLink> links) {
        long total = catalogUserLinkDao.createBatch(links);
        return total > 0;
    }

    @Override
    public boolean deleteBatchByUserTNO(List<CatalogUserLink> links) {
        long total = catalogUserLinkDao.deleteBatchByUserTNO(links);
        return total > 0;
    }

    @Override
    public boolean deleteBatchByUserIdAndCatalogNOAll(List<String> userTNO, String catalogNO) {
        if(userTNO == null || userTNO.size() == 0 || catalogNO == null || "".equals(catalogNO)){
            return false;
        }
        int start = 1;
        int length = catalogNO.length();

        List<Map<String, Object>> list = new ArrayList<>();
        for(String users: userTNO){
            Map<String, Object> map = new HashMap<>();
            map.put("start",start);
            map.put("length",length);
            map.put("catalogNO",catalogNO);
            map.put("userTNO",users);
            list.add(map);
        }

        int result = catalogUserLinkDao.deleteBatchByUserIdAndCatalogNOAll(list);
        return result > 0;
    }

    @Override
    public boolean deleteBatchByUserIdAndCatalogNO(List<CatalogUserLink> links) {
        System.out.println("有错误");
        long total = catalogUserLinkDao.deleteBatchByUserIdAndCatalogNO(links);
        return total > 0;
    }

    @Override
    public boolean deleteBatchByCatalogNO(Map<String, Object> map) {
        Map<String, Object> map1 = MapUtil.assembleMap(map);
        if(map1 == null){
            return false;
        }
        long total = catalogUserLinkDao.deleteBatchByCatalogNO(map1);
        return total > 0;
    }

    @Override
    public List<CatalogUserLink> listByUserTNOorCatalogNO(Map<String, Object> map) {
        String catalogNO = map.get("catalogNO").toString();
        if(catalogNO == null || "".equals(catalogNO)){
            return null;
        }
        catalogNO = catalogNO.trim();
        map.put("start",1);
        map.put("length",catalogNO.length());
        map.put("catalogNO",catalogNO);
        List<CatalogUserLink> links = catalogUserLinkDao.listByUserTNOorCatalogNO(map);
        return links != null && links.size()> 0 ? links : null;
    }

    @Override
    public boolean updateBatch(List<CatalogUserLink> links) {
        long total = catalogUserLinkDao.updateBatch(links);
        return total > 0;
    }
}
