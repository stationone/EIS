package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

/**
 * 索引目录类, 用来记录用户创建的, 管理文件及文件所处目录的类
 * @author zhangch
 * @date 2019/12/3 0003 下午 13:58
 */
@Document(indexName = "indexmenu",type = "indexmenu", shards = 1, replicas = 0)
public class IndexMenu {
    //库id
    @Id
    private String indexId;
    //库名称
    private String indexName;
    //库的文件根目录
    private String menuRoot;
    //树名
    private String text;

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = indexName;
    }

    public IndexMenu() {
    }

    public IndexMenu(String indexId, String indexName) {

    }

    public String getIndexId() {
        return indexId;
    }

    public void setIndexId(String indexId) {
        this.indexId = indexId;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getMenuRoot() {
        return menuRoot;
    }

    public void setMenuRoot(String menuRoot) {
        this.menuRoot = menuRoot;
    }
}
