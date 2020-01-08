package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
//import org.springframework.data.domain.Page;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * @author zhangch
 * @date 2019/11/29 0029 下午 20:38
 */
@Repository
public interface FileBaseDao extends ElasticsearchRepository<FileBase, String> {
    //字段详情
    Optional<FileBase> findByFilename(String filename);

    //库字段列表
    List<FileBase> findByIndexName(String indexName);

    //库字段列表
    Page<FileBase> findByIndexName(String indexName, Pageable pageable);


}
