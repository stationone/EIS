package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * @author zhangch
 * @date 2019/11/19 0019 下午 15:35
 */
@Repository
public interface FileInfoDao extends ElasticsearchRepository<FileInfo, String> {

    Page<FileInfo> findByMenuId(String menuId, Pageable pageable);

    @Override
    Optional<FileInfo> findById(String id);

    List<FileInfo> findByMenuId(String menuId);
}
