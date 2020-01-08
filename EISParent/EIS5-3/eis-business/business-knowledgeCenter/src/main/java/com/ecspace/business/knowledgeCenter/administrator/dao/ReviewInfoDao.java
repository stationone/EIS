package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.ReviewInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

/**
 * @author zhangch
 * @date 2020/1/6 0006 下午 12:00
 */
public interface ReviewInfoDao extends ElasticsearchRepository<ReviewInfo,String> {

    /**
     * 查找文件的审批记录
     * @param fileId
     * @param pageable
     * @return
     */
    Page<ReviewInfo> findByFileId(String fileId, Pageable pageable);

    Integer countByFileId(String fileId);

}
