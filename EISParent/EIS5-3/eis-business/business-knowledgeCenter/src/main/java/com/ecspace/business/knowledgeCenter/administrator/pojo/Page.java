package com.ecspace.business.knowledgeCenter.administrator.pojo;


import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.util.List;

/**
 * file文件的page单页面
 *
 * @author zhangch
 * @date 2019/11/7 0007 下午 15:04
 */
@Document(indexName = "page",type = "page", shards = 1, replicas = 0)
public class Page {
    @Id
    @Field(index = false, store = true,type = FieldType.Long)
    private Long tNO;//pageID
    @Field(index = false, store = true,type = FieldType.Integer)
    private Integer pageNO;//page页码
    @Field(index = true, store = true, type = FieldType.Text, analyzer = "ik_smart", searchAnalyzer = "ik_smart")
    private String content;//page内容
    private java.io.File pdfPage;//文件对象,
    private FileInfo knowledge;//page所属的file
    private List<FileDirectoryNode> nodeList;//目录列表
    private String directoryNodeIds; //目录id列表
    @Field(index = false,store = true, type = FieldType.Keyword)
    private String fileId;//page所属的file的Id
    private String path;//本地路径
    private String webPath;//预览路径(离散后的web虚拟映射路径)

    public String getWebPath() {
        return webPath;
    }

    public void setWebPath(String webPath) {
        this.webPath = webPath;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public void setPageNO(Integer pageNO) {
        this.pageNO = pageNO;
    }

    public String getDirectoryNodeIds() {
        return directoryNodeIds;
    }

    public void setDirectoryNodeIds(String directoryNodeIds) {
        this.directoryNodeIds = directoryNodeIds;
    }

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public void settNO(Long tNO) {
        this.tNO = tNO;
    }

    public Long gettNO() {
        return tNO;
    }

    public void setPageNO(int pageNO) {
        this.pageNO = pageNO;
    }

    public int getPageNO() {
        return pageNO;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

    public void setPdfPage(java.io.File pdfPage) {
        this.pdfPage = pdfPage;
    }

    public java.io.File getPdfPage() {
        return pdfPage;
    }

    public void setKnowledge(FileInfo knowledge) {
        this.knowledge = knowledge;
    }

    public FileInfo getKnowledge() {
        return knowledge;
    }

    public void setNodeList(List<FileDirectoryNode> nodeList) {
        this.nodeList = nodeList;
    }

    public List<FileDirectoryNode> getNodeList() {
        return nodeList;
    }

}
