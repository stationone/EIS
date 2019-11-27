package com.ecspace.business.es.pojo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 索引信息
 */
public class Index {
    //索引名称
    private String indexName;
    //索引type
    private String typeName;
    //索引库的数据
    private List list;
    //字段列表
    private String fieldList;
    //数据总数
    private Integer totals;
    //分片数
    private String shards;
    //副本数
    private String replicas;
    //创建日期的字符串
    private String createTime;


    public Index() {
    }

    public String getShards() {
        return shards;
    }

    public void setShards(String shards) {
        this.shards = shards;
    }

    public String getReplicas() {
        return replicas;
    }

    public void setReplicas(String replicas) {
        this.replicas = replicas;
    }

    public String getFieldList() {
        return fieldList;
    }

    public void setFieldList(String fieldList) {
        this.fieldList = fieldList;
    }

    public Index(List list, Integer totals) {
        this.list = list;
        this.totals = totals;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public Index(List list) {
        this.list = list;
    }

    public Index(String indexName) {
        this.indexName = indexName;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public List getList() {
        return list;
    }

    public void setList(List list) {
        this.list = list;
    }



    public Integer getTotals() {
        return totals;
    }

    public void setTotals(Integer totals) {
        this.totals = totals;
    }
}
