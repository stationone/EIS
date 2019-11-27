package com.ecspace.business.es.service;

import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.IndexField;
import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.pojo.T;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

/**
 * @author zhangch
 * @date 2019/10/15 0015 下午 13:39
 */
public interface ElasticsearchService {

    /**
     * 新建索引库
     * @param indexName
     * @param shardNum
     * @param replicaNum
     * @return
     */
    Ajax createIndex(String indexName, String shardNum, String replicaNum);

    /**
     * 创建字段映射
     * @param indexName
     * @param filedName
     * @param filedType
     * @param isIndex
     * @param isSplit
     * @param ikSave
     * @param ikSearch
     * @return
     */
    Ajax createMapping(String indexName, String filedName, String filedType, String isIndex, String isSplit, String ikSave, String ikSearch);

    /**
     * 数据查询
     * @param indexName
     * @param json
     * @param page
     * @param size
     * @return
     */
    PageData getByIndex(String indexName, String json, Integer page, Integer size) throws Exception;


    /**
     * 查询数据库中字段信息
     * @param indexNames
     * @return
     */
    List getTitle(String indexNames);

    /**
     * 获取索引库列表
     * @return
     */
    List<T> getIndexList();

    /**
     * 获取该索引库详细信息
     */
    PageData getIndexDetail(String indexName);

    /**
     * 获取该索引库所有的字段
     * @param indexName
     * @return
     */
    List getIndexField(String indexName);

    /**
     * 获取字段及映射信息
     * @param indexName
     * @return
     */
    PageData getFieldAndMapping(String indexName);


    /**
     * 干掉索引库
     * @param indexName
     * @return
     */
    Ajax deleteIndex(String indexName);

    /**
     * 添加数据
     * @param json
     * @param indexName
     * @return
     */
    Ajax addDocument(String json, String indexName);

    /**
     * 删除一条数据
     * @param indexName
     * @param type
     * @param gridId
     * @return
     */
    Ajax deleteDocument(String indexName, String type, String gridId);


    /**
     * 全文检索
     * 
     * @param indexName
     * @param json
     * @param page
     * @param rows
     * @return
     * @throws ParseException
     */
    PageData query(String indexName, String json, Integer page, Integer rows) throws ParseException;

    /**
     * 更新文档
     *
     * @param indexName
     * @param json
     * @param gridId
     * @return
     */
    Ajax updateDocument(String json, String indexName, String gridId);

    /**
     * 获取索引库数组的可被查询的字段字符串
     *
     * @param indexNames
     * @return {"analyzerArr":""}{"notAnalyzerArr":""}
     */
    HashMap<String, String[]> getStringHashMap(String[] indexNames);

    /**
     * 拼接可被查询且分词的字段名, 和可被查询但不分词的字段名
     *
     * @param indexFieldList
     * @param indexAndAnalyzer
     * @param indexNotAnalyzer
     */
    void joint(List<IndexField> indexFieldList, StringBuilder indexAndAnalyzer, StringBuilder indexNotAnalyzer);

    JSONObject getMappingInfo(String indexName);

    JSONObject getFieldType(String indexName);
}
