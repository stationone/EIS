package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Page;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhangch
 * @date 2019/11/20 0020 下午 21:10
 */

@Repository
public interface PageDao extends ElasticsearchRepository<Page, Long> {
}
