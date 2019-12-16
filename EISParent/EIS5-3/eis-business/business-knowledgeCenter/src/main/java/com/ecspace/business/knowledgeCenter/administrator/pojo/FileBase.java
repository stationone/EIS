package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

/**
 * 文档基本类型
 *
 * @author zhangch
 * @date 2019/11/29 0029 下午 20:34
 */
@Document(indexName = "file_base", type = "file_base", shards = 1, replicas = 0)
public class FileBase {
    @Id
    private String id;
    private String filename;
    private String type;//整数,字符串, 枚举
    private String scope;//1~100等
    private String desc;
    private String indexName;//哪个库的属性

    public FileBase() {
    }

    public String getIndexName() {
        return indexName;
    }

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
