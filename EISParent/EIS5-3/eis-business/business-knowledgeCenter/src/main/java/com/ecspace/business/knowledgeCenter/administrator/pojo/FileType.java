package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

/**
 * 文件类型定义
 *
 * @author zhangch
 * @date 2019/12/5 0005 下午 19:26
 */
@Document(indexName = "file_type", type = "file_type", shards = 1, replicas = 0)
public class FileType {
    @Id
    private String id;

    private String text;//树文名

    private String typeName;//类型名

    public FileType() {
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

}
