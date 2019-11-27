package com.ecspace.business.resourceCenter.user.service.entity;

/**
 * 资源上传记录表
 * 用于记录用户上传文件存储的位置及文件的状态
 */
public class ResUpload {
    private String tNO;

    private String userId; //上传用户的id

    private String resName; //文件名称 如 text.txt

    private String fileWorkCopyPath; //文件保存在服务器的地址

    private String status; //文件状态，未写入版本库

    private String catalogNO; //上级目录编号

    private String catalogName; //上传目录的版本库名称

    private String fileSize; //上传文件大小

    public ResUpload() {
    }

    public ResUpload(String tNO, String userId, String resName, String fileWorkCopyPath, String status, String catalogNO, String catalogName, String fileSize) {
        this.tNO = tNO;
        this.userId = userId;
        this.resName = resName;
        this.fileWorkCopyPath = fileWorkCopyPath;
        this.status = status;
        this.catalogNO = catalogNO;
        this.catalogName = catalogName;
        this.fileSize = fileSize;
    }

    public String gettNO() {
        return tNO;
    }

    public void settNO(String tNO) {
        this.tNO = tNO;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getResName() {
        return resName;
    }

    public void setResName(String resName) {
        this.resName = resName;
    }

    public String getFileWorkCopyPath() {
        return fileWorkCopyPath;
    }

    public void setFileWorkCopyPath(String fileWorkCopyPath) {
        this.fileWorkCopyPath = fileWorkCopyPath;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCatalogNO() {
        return catalogNO;
    }

    public void setCatalogNO(String catalogNO) {
        this.catalogNO = catalogNO;
    }

    public String getCatalogName() {
        return catalogName;
    }

    public void setCatalogName(String catalogName) {
        this.catalogName = catalogName;
    }

    public String getFileSize() {
        return fileSize;
    }

    public void setFileSize(String fileSize) {
        this.fileSize = fileSize;
    }

    @Override
    public String toString() {
        return "ResUpload{" +
                "tNO='" + tNO + '\'' +
                ", userId='" + userId + '\'' +
                ", resName='" + resName + '\'' +
                ", fileWorkCopyPath='" + fileWorkCopyPath + '\'' +
                ", status='" + status + '\'' +
                ", catalogNO='" + catalogNO + '\'' +
                ", catalogName='" + catalogName + '\'' +
                ", fileSize='" + fileSize + '\'' +
                '}';
    }
}
