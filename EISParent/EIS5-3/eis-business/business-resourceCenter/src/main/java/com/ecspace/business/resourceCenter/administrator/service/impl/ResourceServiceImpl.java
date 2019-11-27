package com.ecspace.business.resourceCenter.administrator.service.impl;

import com.ecspace.business.resourceCenter.administrator.dao.ResourceDao;
import com.ecspace.business.resourceCenter.administrator.service.ResourceService;
import com.ecspace.business.resourceCenter.administrator.entity.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("resourceService")
public class ResourceServiceImpl implements ResourceService {

    @Autowired
    private ResourceDao resourceDao;

    @Override
    public List<Resource> list(Map<String, Object> map) {
        List<Resource> list = resourceDao.list(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public List<Resource> listByCatalogResLink(Map<String, Object> map) {
        List<Resource> list = resourceDao.listByCatalogResLink(map);
        return list != null && list.size() > 0 ? list : null;
    }

    @Override
    public Long listByCatalogResLinkTotal(Map<String, Object> map) {
        return resourceDao.listByCatalogResLinkTotal(map);
    }

    @Override
    public boolean deleteBatch(List<Resource> list) {
        long total = resourceDao.deleteBatch(list);
        return total > 0;
    }


}
