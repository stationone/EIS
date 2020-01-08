package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileTemp;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhangch
 * @date 2019/12/12 0012 下午 20:27
 */
@Repository
public interface FileTempDao extends ElasticsearchRepository<FileTemp, String> {
}
