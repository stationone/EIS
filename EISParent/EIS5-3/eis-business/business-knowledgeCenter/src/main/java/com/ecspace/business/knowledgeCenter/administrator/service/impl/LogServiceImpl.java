package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.LogDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.Log;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;
import com.ecspace.business.knowledgeCenter.administrator.service.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

/**
 * @author zhangch
 * @date 2020/1/3 0003 下午 13:46
 */
@Service
public class LogServiceImpl implements LogService {

    @Autowired
    private LogDao logDao;

    /**
     * 获取全部
     * @param page
     * @param size
     * @return
     */
    public PageData logList(Integer page, Integer size){
        Pageable pageable = PageRequest.of(page, size);
        Page<Log> logPage = logDao.findAll(pageable);
        Long totalElements = logPage.getTotalElements();
        PageData pageData = new PageData();
        pageData.setTotal(totalElements.intValue());
        pageData.setRows(logPage.getContent());
        return pageData;
    }

    /**
     * 删除
     * @return
     */
    public GlobalResult deleteLog(String id){
        logDao.deleteById(id);
        return new GlobalResult(true, 200, "ok", null);
    }

    /**
     * 删除全部
     * @return
     */
    public GlobalResult deleteAll(){
        logDao.deleteAll();
        return new GlobalResult(true, 200, "ok", null);
    }

    @Override
    public GlobalResult save(Log log) {
        Log save = logDao.save(log);
        return new GlobalResult(true, 200, "ok", save);
    }
}
