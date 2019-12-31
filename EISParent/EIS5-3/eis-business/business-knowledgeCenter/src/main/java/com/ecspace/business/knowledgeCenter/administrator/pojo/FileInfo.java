package com.ecspace.business.knowledgeCenter.administrator.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.io.File;
import java.util.Date;
import java.util.List;

/**
 * 文件信息类
 *
 * @author zhangch
 * @date 2019/11/19 0019 下午 15:25
 */

/*
   属性分配:
    1. 文件存入本地文件夹
    2. 文件名fileName, 文件路径名filePath, 文件后缀名fileNameSuffix,
        文件上传时间戳creationTime, 文件最后访问时间戳lastAccessTime, 文件大小fileSize
          离散后的页面集合pageList, 用以检索的关键词keyword, 等等
            文件下载量\访问量\检索量(待添加)
 */
@Document(indexName = "file",type = "file", shards = 1, replicas = 0)
public class FileInfo {

    /**
     * 文件id
     */
    @Id
    private String id;
    /**
     * 文件哈希扣得值
     */
    private String hashCode;
    /**
     * 文件本身
     */
    private File file;
    /**
     * 文件名
     */
    private String fileName;
    /**
     * 文件路径名
     */
    private String filePath;
    /**
     * 文件名后缀
     */
    private String fileNameSuffix;
    /**
     * 文件名前缀
     */
    @Field(index = true, store = true, type = FieldType.Text, analyzer = "ik_smart", searchAnalyzer = "ik_smart")
    private String fileNamePrefix ;
    /**
     * 文件创建时间戳
     */
    private Date creationTime;
    /**
     * 文件最后访问时间戳
     */
    private Date lastAccessTime;

    /**
     * 文件最后更新时间
     */
    private Date lastUpdateTime;
    /**
     * 文件大小
     */
    private Long fileSize;
    /**
     * 总页数
     */
    private Integer pageTotal;
    /**
     * 关键词
     */
    @Field(index = true, store = true, type = FieldType.Text, analyzer = "ik_smart", searchAnalyzer = "ik_smart")
    private String keyword;

    private String content;//文档内容(一小段)
    /**
     * 文件所处目录id
     */
    private String menuId;
    /**
     * 上传人员
     */
    private String uploadUser;
    /**
     * 页面列表
     */
    private List<Page> pageList;
    /**
     * 页面id数组
     */
    private String pageIds;

    private String pdfFilePath;

    /**
     * 下载地址(源文件访问路径
     */
    private String downloadPath;
    /**
     * 文件离散后的的web路径
     */
    private String fileHtml;

    /**
     * 文件转换后的pdf虚拟地址
     */
    private String filePdf;

    /**
     * 下载次数, 初始0
     */
    private Integer downloadCount = 0;

    private String fileId;

    //作者
    private String author;

    //专业
    private String professional;

    //摘要
    private String fileAbstract;


    /**
     * 文件所处的索引库对象
     */
    private String indexName;

    //成员类型
    private String memberType;

    //成员
    private String members;
    //离散工具
    private String discreteTool;
    //轻量化转换工具
    private String lightWeightConversion;

    //对应轻量化文件的地址
    private String lightWeightURL;
    //对应文档的展示工具
    private String jsp;

    private String webPath;

    private String src;

    private String libraryPath;

    private Integer status;//状态 (解析中0, 未审核1, 已审核2)  更新为----->>>  上传中5、离散中0、待提交1、待审核2、驳回3、入库4 6种状态

    public Integer getStatus() {
        return status;
    }

    public Date getLastUpdateTime() {
        return lastUpdateTime;
    }

    public void setLastUpdateTime(Date lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getLibraryPath() {
        return libraryPath;
    }

    public void setLibraryPath(String libraryPath) {
        this.libraryPath = libraryPath;
    }

    public String getWebPath() {
        return webPath;
    }

    public void setWebPath(String webPath) {
        this.webPath = webPath;
    }

    public String getSrc() {
        return src;
    }

    public void setSrc(String src) {
        this.src = src;
    }

    public String getFileAbstract() {
        return fileAbstract;
    }

    public void setFileAbstract(String fileAbstract) {
        this.fileAbstract = fileAbstract;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getProfessional() {
        return professional;
    }

    public void setProfessional(String professional) {
        this.professional = professional;
    }

    public String getMemberType() {
        return memberType;
    }

    public void setMemberType(String memberType) {
        this.memberType = memberType;
    }

    public String getMembers() {
        return members;
    }

    public void setMembers(String members) {
        this.members = members;
    }

    public String getDiscreteTool() {
        return discreteTool;
    }

    public void setDiscreteTool(String discreteTool) {
        this.discreteTool = discreteTool;
    }

    public String getLightWeightConversion() {
        return lightWeightConversion;
    }

    public void setLightWeightConversion(String lightWeightConversion) {
        this.lightWeightConversion = lightWeightConversion;
    }

    public String getLightWeightURL() {
        return lightWeightURL;
    }

    public void setLightWeightURL(String lightWeightURL) {
        this.lightWeightURL = lightWeightURL;
    }

    public String getJsp() {
        return jsp;
    }

    public void setJsp(String jsp) {
        this.jsp = jsp;
    }

    public String getIndexName() {
        return indexName;
    }

    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }

    public String getFileId() {
        this.fileId = id;
        return fileId;
    }

    public String getDownloadPath() {
        return downloadPath;
    }

    public void setDownloadPath(String downloadPath) {
        this.downloadPath = downloadPath;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getFileHtml() {
        return fileHtml;
    }

    public void setFileHtml(String fileHtml) {
        this.fileHtml = fileHtml;
    }

    public String getFilePdf() {
        return filePdf;
    }

    public void setFilePdf(String filePdf) {
        this.filePdf = filePdf;
    }

    public Integer getDownloadCount() {
        return downloadCount;
    }

    public void setDownloadCount(Integer downloadCount) {
        this.downloadCount = downloadCount;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getPageTotal() {
        return pageTotal;
    }

    public void setPageTotal(Integer pageTotal) {
        this.pageTotal = pageTotal;
    }

    public String getPdfFilePath() {
        return pdfFilePath;
    }

    public void setPdfFilePath(String pdfFilePath) {
        this.pdfFilePath = pdfFilePath;
    }

    public FileInfo() {
    }

    public String getFileNamePrefix() {
        return fileNamePrefix;
    }

    public void setFileNamePrefix(String fileNamePrefix) {
        this.fileNamePrefix = fileNamePrefix;
    }

    public String getUploadUser() {
        return uploadUser;
    }

    public void setUploadUser(String uploadUser) {
        this.uploadUser = uploadUser;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getHashCode() {
        return hashCode;
    }

    public void setHashCode(String hashCode) {
        this.hashCode = hashCode;
    }

    public File getFile() {
        return file;
    }

    public void setFile(File file) {
        this.file = file;
    }

    public String getPageIds() {
        return pageIds;
    }

    public void setPageIds(String pageIds) {
        this.pageIds = pageIds;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileNameSuffix() {
        return fileNameSuffix;
    }

    public void setFileNameSuffix(String fileNameSuffix) {
        this.fileNameSuffix = fileNameSuffix;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getLastAccessTime() {
        return lastAccessTime;
    }

    public void setLastAccessTime(Date lastAccessTime) {
        this.lastAccessTime = lastAccessTime;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public List<Page> getPageList() {
        return pageList;
    }

    public void setPageList(List<Page> pageList) {
        this.pageList = pageList;
    }

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

}
