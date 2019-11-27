package com.ecspace.business.knowledgeCenter.administrator.dao;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * @author zhangch
 * @date 2019/11/14 0014 下午 19:30
 */
@Repository
public interface MenuDao extends ElasticsearchRepository<Menu, String> {

    /**
     * 获取树节点数据
     *
     * @param pid
     * @return
     */
    List<Menu> findByPid(String pid);
//    Optional<Menu> findByPid(String pid);


    /**
     * 获取子节点的数量, 判断该目录下是否还有目录
     *
     * @param pid
     * @return
     */
    int countMenuByPid(String pid);






}
