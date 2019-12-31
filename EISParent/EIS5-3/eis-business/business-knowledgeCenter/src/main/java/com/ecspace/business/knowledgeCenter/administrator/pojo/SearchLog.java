package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.util.Date;

/**
 * 检索日志
 * @author zhangch
 * @date 2019/12/12 0012 上午 11:03
 */
@Document(indexName = "search_log", shards = 1, replicas = 0)
public class SearchLog {

    @Id
    private String id;

    private String userId;//用户id

    private String userName;//用户真实姓名

    private Integer level;//日志级别

    private String method;//操作方式

    private String remoteHost;//操作IP地址

    private String requestUrl; //请求地址

    private String param;//请求参数

    private String result; //请求结果

    private Long spent;//耗费时间, 请求处理时长

    private Date creationTime; //创建时间

    public SearchLog() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getRemoteHost() {
        return remoteHost;
    }

    public void setRemoteHost(String remoteHost) {
        this.remoteHost = remoteHost;
    }

    public String getRequestUrl() {
        return requestUrl;
    }

    public void setRequestUrl(String requestUrl) {
        this.requestUrl = requestUrl;
    }

    public String getParam() {
        return param;
    }

    public void setParam(String param) {
        this.param = param;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public Long getSpent() {
        return spent;
    }

    public void setSpent(Long spent) {
        this.spent = spent;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }
}
