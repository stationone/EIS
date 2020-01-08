package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.util.Date;

/**
 * 用户实体
 * @author zhangch
 * @date 2020/1/7 0007 上午 11:25
 */
@Document(indexName = "user_info",shards = 1,replicas = 0)
public class UserInfo {
    @Id
    private String id;

    private String username;

    private String password;

    private Date creationTime;

    public UserInfo() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }
}
