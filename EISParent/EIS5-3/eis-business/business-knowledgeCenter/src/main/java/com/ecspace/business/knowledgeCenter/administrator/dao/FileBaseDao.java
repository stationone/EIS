package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhangch
 * @date 2019/11/29 0029 下午 20:38
 */
@Repository
public interface FileBaseDao extends ElasticsearchRepository<FileBase, String> {

}
