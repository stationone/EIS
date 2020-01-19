package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.UserInfo;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

/**
 * @author zhangch
 * @date 2020/1/17 0017 下午 15:22
 */
@Repository
public interface UserInfoDao extends ElasticsearchRepository<UserInfo,String> {

}
