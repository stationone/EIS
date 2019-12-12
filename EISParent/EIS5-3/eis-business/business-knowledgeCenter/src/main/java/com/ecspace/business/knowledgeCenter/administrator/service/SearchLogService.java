package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.SearchLog;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 13:45
 */
public interface SearchLogService {

    GlobalResult insert(SearchLog searchLog);

    GlobalResult update(SearchLog searchLog);

    GlobalResult delete(String id);

    GlobalResult listLog();
}
