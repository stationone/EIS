package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Log;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.Optional;

/**
 * @author zhangch
 * @date 2020/1/3 0003 下午 13:37
 */
public interface LogDao extends ElasticsearchRepository<Log,String> {

    Page<Log> findAll(Pageable pageable);

}
