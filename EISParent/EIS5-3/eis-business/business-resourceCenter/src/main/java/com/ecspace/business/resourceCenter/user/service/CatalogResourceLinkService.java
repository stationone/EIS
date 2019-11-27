package com.ecspace.business.resourceCenter.user.service;

import com.ecspace.business.resourceCenter.user.service.entity.Resource;

import java.util.List;

public interface CatalogResourceLinkService {

    boolean create(Resource resource);

    boolean createBatch(List<Resource> list);
}
