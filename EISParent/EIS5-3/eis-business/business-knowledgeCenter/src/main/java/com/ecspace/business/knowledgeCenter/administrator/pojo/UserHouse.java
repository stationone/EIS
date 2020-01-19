package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.elasticsearch.annotations.Document;

import java.util.List;

/**
 * 用户收藏
 * @author zhangch
 * @date 2020/1/17 0017 下午 17:42
 */
@Document(indexName = "user_house", type = "user_house", shards = 1, replicas = 0)
public class UserHouse {

    private String id;

    private String pid;

    private String text;

    private String url;

    private String state;

    private String userName;//用户名

    private String userId;

    private List<Menu> children;//子节点

    public UserHouse() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<Menu> getChildren() {
        return children;
    }

    public void setChildren(List<Menu> children) {
        this.children = children;
    }
}
