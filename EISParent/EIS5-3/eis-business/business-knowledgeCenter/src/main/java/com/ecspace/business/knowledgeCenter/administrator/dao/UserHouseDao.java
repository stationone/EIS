package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.UserHouse;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


/**
 * 用户收藏
 * @author zhangch
 * @date 2020/1/17 0017 下午 17:45
 */
@Repository
public interface UserHouseDao extends ElasticsearchRepository<UserHouse, String> {

    int countMenuByPid(String pid);

    List<UserHouse> findByPidAndUserName(String pid, String userName);

    List<UserHouse> findByPid(String pid);
}
