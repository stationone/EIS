package com.ecspace.business.es.controller;

import com.alibaba.fastjson.JSON;
import com.ecspace.business.es.pojo.*;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.service.ElasticsearchService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

/**
 * 对Elasticsearch索引库的操作类
 * (待解决问题1: 无法在web端指定一个字段是否分词)
 *
 * @author zhangch
 * @date 2019/10/15 0015 上午 10:58
 */
@RestController
@RequestMapping("/elasticsearch")
public class ElasticsearchController {

    @Autowired
    @Qualifier("elasticsearchService")
    private ElasticsearchService elasticsearchService;

    /**
     * 创建索引库
     *
     * @param indexName 索引名称
     * @param shardNum 分片数
     * @param replicaNum 副本数
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/createIndex")
    public Ajax createIndex(String indexName, String shardNum, String replicaNum) throws Exception {
        if (StringUtils.isBlank(indexName)) {
            return new Ajax("参数异常", false);
        }
        return elasticsearchService.createIndex(indexName, shardNum, replicaNum);
    }

    /**
     * 干掉索引库
     *
     * @param indexName
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteIndex")
    public Ajax deleteIndex(String indexName) throws Exception {
        if (StringUtils.isBlank(indexName)) {
            return new Ajax("参数异常", false);
        }

        return elasticsearchService.deleteIndex(indexName);
    }

    /**
     * 获取全部索引库列表
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getIndexList")
    public List<T> getIndexList() throws Exception {

        return elasticsearchService.getIndexList();
    }


    /**
     * 获取该索引库详情
     *
     * @throws Exception
     */
    @RequestMapping(value = "/getIndexDetail")
    public PageData getIndexDetail(String indexName) throws Exception {
        if (StringUtils.isBlank(indexName)) {
            return new PageData(new ArrayList());
        }
        return elasticsearchService.getIndexDetail(indexName);
    }


    /**
     * 获取index的mapping信息
     *
     * @param indexName
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getIndexField")
    public PageData getIndexField(String indexName) throws Exception {
        if (StringUtils.isBlank(indexName)) {
            return new PageData(new ArrayList());
        }
        return elasticsearchService.getFieldAndMapping(indexName);
    }


    /**
     * 创建字段映射
     *
     * @param indexName
     * @param filedName
     * @param filedType
     * @param isIndex
     * @param isSplit
     * @param ikSave
     * @param ikSearch
     * @return
     */
    @RequestMapping(value = "/createMapping")
    public Ajax createMapping(String indexName, String filedName, String filedType, String isIndex, String isSplit, String ikSave, String ikSearch) {
        if (StringUtils.isBlank(filedName)) {
            return new Ajax("参数异常", false);
        }
        return elasticsearchService.createMapping(indexName, filedName, filedType, isIndex, isSplit, ikSave, ikSearch);
    }

    /*
     * 查看当前索引库的字段列表 该字段需用作表头,
     *
     * @param indexNames
     * @return
     */
    @RequestMapping(value = "/getTitle")
    public List getTitle(String indexName) {
        if (StringUtils.isBlank(indexName)) {
//            不查数据
            return new ArrayList();
        }

        List columnList = elasticsearchService.getTitle(indexName);
//        System.out.println(columnList);
        return columnList;
    }


    /**
     * 获取数据
     *
     * @param indexName
     * @param json
     * @return pageData
     * @throws Exception
     */
    @RequestMapping(value = "/getList")
    public PageData getList(String indexName, String json, Integer page, Integer rows) throws Exception {
        if (StringUtils.isBlank(indexName)) {
            return new PageData();
        }
        //没有请求参数时, 数据全部搜索出来
        if (StringUtils.isBlank(json) || JSON.parseObject(json).isEmpty() || StringUtils.isBlank(JSON.parseObject(json).get("search").toString()) ) {
            return elasticsearchService.getByIndex(indexName, json ,page, rows);
        }
        //条件查询
        return elasticsearchService.query(indexName, json, page, rows);
    }

    /**
     * 添加数据
     * @param json
     * @param indexName
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/addDocument")
    public Ajax addDocument(String json, String indexName) throws Exception{
        if (StringUtils.isBlank(json) || StringUtils.isBlank(indexName)) {
            return new Ajax("非法参数", false);
        }
        return elasticsearchService.addDocument(json, indexName);
    }

    /**
     * 删除文档
     * @param indexName
     * @param type
     * @param gridId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteDocument")
    public Ajax deleteDocument(String indexName, String type, String gridId) throws Exception{
        if (StringUtils.isBlank(type) || StringUtils.isBlank(indexName) || StringUtils.isBlank(gridId)) {
            return new Ajax("非法参数", false);
        }
        return elasticsearchService.deleteDocument(indexName, type, gridId);
    }

    /**
     * 更新文档
     * @param indexName
     * @param json
     * @param id
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/updateDocument")
    public Ajax updateDocument(String json, String indexName, String id) throws Exception{
        if (StringUtils.isBlank(json) || StringUtils.isBlank(indexName) ) {
            return new Ajax("非法参数", false);
        }
        return elasticsearchService.updateDocument(json, indexName, id);
    }


}
