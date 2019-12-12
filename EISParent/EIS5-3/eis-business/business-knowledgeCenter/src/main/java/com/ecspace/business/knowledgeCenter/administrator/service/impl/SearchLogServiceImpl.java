package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.SearchLogDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.SearchLog;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.SearchLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 13:46
 */
@Service
public class SearchLogServiceImpl implements SearchLogService {

    @Autowired
    private SearchLogDao searchLogDao;


    @Override
    public GlobalResult insert(SearchLog searchLog) {
        SearchLog log = searchLogDao.save(searchLog);
        return new GlobalResult(true, 2000, "true", log);
    }

    @Override
    public GlobalResult update(SearchLog searchLog) {
        SearchLog log = searchLogDao.save(searchLog);
        return new GlobalResult(true, 2000, "true", log);
    }

    @Override
    public GlobalResult delete(String id) {
        searchLogDao.deleteById(id);
        return new GlobalResult(true, 2000, "true");
    }

    @Override
    public GlobalResult listLog() {
        Iterable<SearchLog> logs = searchLogDao.findAll();
        return null;
    }
}
