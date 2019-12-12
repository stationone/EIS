package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.SearchLog;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhangch
 * @date 2019/12/12 0012 上午 11:18
 */
@Repository
public interface SearchLogDao extends ElasticsearchRepository<SearchLog, String> {

}
