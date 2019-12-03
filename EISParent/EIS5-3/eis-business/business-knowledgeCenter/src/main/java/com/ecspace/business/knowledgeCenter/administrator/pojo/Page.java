package com.ecspace.business.knowledgeCenter.administrator.pojo;


import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.util.List;

/*
PUT http://localhost:9200/file/file/_mapping
{
    "properties": {"content":{"type":"text","store" : true,"index":"true","analyzer":"ik_smart","search_analyzer":"ik_smart","term_vector": "with_positions_offsets_payloads"}}
}
 */

/**
 * file文件的page单页面
 *
 * @author zhangch
 * @date 2019/11/7 0007 下午 15:04
 */
@Document(indexName = "page",type = "page", shards = 1, replicas = 0)
public class Page {
    @Id
    @Field(index = true, store = true,type = FieldType.Long)
    private Long tNO;//pageID
    @Field(index = true, store = true,type = FieldType.Integer)
    private Integer pageNO;//page页码
//    @Field( index = true, store = true, type = FieldType.Text, analyzer = "ik_smart", searchAnalyzer = "ik_smart")
    private String content;//page内容
    private java.io.File pdfPage;//文件对象,
    private FileInfo knowledge;//page所属的file
    private List<FileDirectoryNode> nodeList;//目录列表
    private String directoryNodeIds; //目录id列表
    @Field(index = true,store = true, type = FieldType.Keyword)
    private String fileId;//page所属的file的Id
    private String path;//本地路径
    private String pageWebPath;//预览路径(离散后的PDF文件web虚拟映射路径)

    public Page() {
    }

    public String getPageWebPath() {
        return pageWebPath;
    }

    public void setPageWebPath(String pageWebPath) {
        this.pageWebPath = pageWebPath;
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
