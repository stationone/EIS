package com.ecspace.business.knowledgeCenter.administrator.service.impl;

import com.ecspace.business.knowledgeCenter.administrator.dao.IndexMenuDao;
import com.ecspace.business.knowledgeCenter.administrator.pojo.IndexMenu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.service.IndexMenuService;
import com.ecspace.business.knowledgeCenter.administrator.util.TNOGenerator;
import org.apache.commons.collections.IteratorUtils;
import org.apache.commons.collections.ListUtils;
import org.elasticsearch.action.admin.indices.exists.indices.IndicesExistsResponse;
import org.elasticsearch.client.IndicesAdminClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zhangch
 * @date 2019/12/3 0003 下午 14:20
 */
@Service
public class IndexMenuServiceImpl implements IndexMenuService {
    @Autowired
    private IndexMenuDao indexMenuDao;
    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;

    //列表
    @Override
    public List<IndexMenu> listIndexMenu() {
        Iterable<IndexMenu> iterable = indexMenuDao.findAll();
        ArrayList<IndexMenu> indexMenus = new ArrayList<>();
        iterable.forEach(indexMenus::add);
        return indexMenus;
    }

    //添加/更新
    @Override
    public GlobalResult save(IndexMenu indexMenu){
        if (indexMenu == null) {
            return null;
        }
        if (indexMenu.getIndexName() == null || "".equals(indexMenu.getIndexName())) {
            return null;
        }
        String id = indexMenu.getIndexId() == null ? TNOGenerator.generateId():indexMenu.getIndexId();
        //将索引库名称变为小写
        String indexName = indexMenu.getIndexName().toLowerCase();
        //判断索引库是否存在
        IndicesAdminClient indices = elasticsearchTemplate.getClient().admin().indices();
        IndicesExistsResponse response = indices.prepareExists(indexName).get();
        if (response.isExists()) {
            return new GlobalResult(false, 4000, "false");
        }

        //使用模板对象操作es
        Map<String, Object> settings = new HashMap<>();
        settings.put("number_of_shards", 1);

        settings.put("number_of_replicas", 0);
        //创建索引
        boolean index = elasticsearchTemplate.createIndex(indexName, settings);

        IndexMenu menu = new IndexMenu();
        menu.setIndexId(id);
        menu.setIndexName(indexName);

        //添加document
        IndexMenu im = indexMenuDao.save(menu);
        if (index && im != null) {
            return new GlobalResult(true, 2000, "ok",im);
        }
        return new GlobalResult(false, 4000, "false");

    }

    @Override
    public GlobalResult delete(String indexName){
        //删除document
        indexMenuDao.deleteByIndexName(indexName);
        //删除索引库
        boolean index = elasticsearchTemplate.deleteIndex(indexName);
        //删除文件目录

        //删除文件


        return new GlobalResult(true, 2000, "ok");
    }
}
