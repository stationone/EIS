package com.ecspace.business.resourceCenter.user.dao;

import com.ecspace.business.resourceCenter.user.service.entity.Resource;

import java.util.List;

public interface UserCatalogResourceLinkDao {

    long create(Resource resource);

    long createBatch(List<Resource> list);
}
