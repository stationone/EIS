package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.util.Date;
import java.util.List;

/**
 * 日志
 * @author zhangch
 * @date 2020/1/3 0012 上午 11:03
 */
@Document(indexName = "log", shards = 1, replicas = 0)
public class Log {
    @Id
    private String id;
    @Field(index = true, store = true, type = FieldType.Keyword)
    private String operator;//操作人

    @Field(index = true, store = true, type = FieldType.Keyword)
    private String operationType;//操作类型

    private Date operationDate;//操作时间

    private String operationResult;//操作结果

    private String ip;//操作人ip

    private String search;//全文检索的检索词
    @Field(index = true, store = true, type = FieldType.Keyword)
    private String dateStr;//例: 2019-10-21

    private String timeStr;//例: 08:56:04

    private String _parentId;//有用,

    private String text;

    private List<Log> children;

    private String state;

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getText() {
        return text;
    }

    public void setText(String text){
        this.text = text;

    }

    public String get_parentId() {
        return _parentId;
    }

    public void set_parentId(String _parentId) {
        this._parentId = _parentId;
    }

    public Log(String id, String operator, String operationType, Date operationDate, String operationResult, String ip, String search, String dateStr, String timeStr) {
        this.id = id;
        this.operator = operator;
        this.operationType = operationType;
        this.operationDate = operationDate;
        this.operationResult = operationResult;
        this.ip = ip;
        this.search = search;
        this.dateStr = dateStr;
        this.timeStr = timeStr;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator == null ? null : operator.trim();
    }

    public String getOperationType() {
        return operationType;
    }

    public void setOperationType(String operationType) {
        this.operationType = operationType == null ? null : operationType.trim();
    }

    public Date getOperationDate() {
        return operationDate;
    }

    public void setOperationDate(Date operationDate) {
        this.operationDate = operationDate;
    }

    public String getOperationResult() {
        return operationResult;
    }

    public void setOperationResult(String operationResult) {
        this.operationResult = operationResult == null ? null : operationResult.trim();
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip == null ? null : ip.trim();
    }

    public Log() {
    }

    public String getSearch() {
        return search;
    }

    public void setSearch(String search) {
        this.search = search;
    }

    public String getDateStr() {
        return dateStr;
    }

    public void setDateStr(String dateStr) {
        this.dateStr = dateStr;
    }

    public String getTimeStr() {
        return timeStr;
    }

    public void setTimeStr(String timeStr) {
        this.timeStr = timeStr;
    }
}