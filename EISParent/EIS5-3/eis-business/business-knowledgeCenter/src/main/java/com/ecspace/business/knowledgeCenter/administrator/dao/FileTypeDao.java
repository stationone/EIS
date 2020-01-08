package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhangch
 * @date 2019/12/5 0005 下午 20:21
 */
@Repository
public interface FileTypeDao extends ElasticsearchRepository<FileType, String> {

    Page<FileType> findByTypeName(String typeName, Pageable pageable);

}
