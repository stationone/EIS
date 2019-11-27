package com.ecspace.business.es.pojo;

/**
 * 字段信息
 */
public class IndexField {
    //字段名称
    private String fieldName;
    //字段类型
    private String type;
    //存储时分词
    private String analyzer;
    //搜索词分词
    private String searchAnalyzer;
    //是否建立索引
    private String index;

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAnalyzer() {
        return analyzer;
    }

    public void setAnalyzer(String analyzer) {
        this.analyzer = analyzer;
    }

    public String getSearchAnalyzer() {
        return searchAnalyzer;
    }

    public void setSearchAnalyzer(String searchAnalyzer) {
        this.searchAnalyzer = searchAnalyzer;
    }

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
    }
}
