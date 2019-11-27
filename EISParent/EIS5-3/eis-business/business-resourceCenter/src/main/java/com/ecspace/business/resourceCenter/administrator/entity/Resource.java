package com.ecspace.business.resourceCenter.administrator.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 资源
 */
public class Resource {

    private String tNO;	//流水号
    private String resId;	//资源编号
    private String resName;	//资源名称
    @DateTimeFormat(pattern = "yyyy-MM-dd HHmmss")
    private Date endDate;	//完成时间
    private String testPlace;	//试验地点
    private String testType;	//试验件类型
    private String testProportion;	//试验件比例
    private String testLeadMan;	//试验负责人
    private String testTrainNum;	//试验总车次
    private String testTrainList;	//试验车次表
    private String svnURL;	//资源URL
    private String resType;	//资源类型
    private String inputUser;	//上传者
    @DateTimeFormat(pattern = "yyyy-MM-dd HHmmss")
    private Date inputDate;	//创建日期
    private String editUser;	//编辑人员
    @DateTimeFormat(pattern = "yyyy-MM-dd HHmmss")
    private Date editDate;	//编辑日期
    private String resVersion;	//资源版本号
    private String svnVersion;	//SVN版本号
    private String remark;	//备注
    private String status;	//资源状态（1未入库，2审批中，3已驳回，4审批通过）
    private String catalogNO;	//目录编号
    private String catalogName;	//目录名称
    private String extend; //扩展属性


    public Resource() {
        super();
    }
    public Resource(String tNO, String resId, String resName, Date endDate,
               String testPlace, String testType, String testProportion,
               String testLeadMan, String testTrainNum, String testTrainList,
               String svnURL, String resType, String inputUser, Date inputDate,
               String editUser, Date editDate, String resVersion,
               String svnVersion, String remark, String status, String catalogNO,
               String catalogName) {
        super();
        this.tNO = tNO;
        this.resId = resId;
        this.resName = resName;
        this.endDate = endDate;
        this.testPlace = testPlace;
        this.testType = testType;
        this.testProportion = testProportion;
        this.testLeadMan = testLeadMan;
        this.testTrainNum = testTrainNum;
        this.testTrainList = testTrainList;
        this.svnURL = svnURL;
        this.resType = resType;
        this.inputUser = inputUser;
        this.inputDate = inputDate;
        this.editUser = editUser;
        this.editDate = editDate;
        this.resVersion = resVersion;
        this.svnVersion = svnVersion;
        this.remark = remark;
        this.status = status;
        this.catalogNO = catalogNO;
        this.catalogName = catalogName;
    }
    public String gettNO() {
        return tNO;
    }
    public void settNO(String tNO) {
        this.tNO = tNO == null ? null : tNO.trim();
    }
    public String getResId() {
        return resId;
    }
    public void setResId(String resId) {
        this.resId = resId == null ? null : resId.trim();
    }
    public String getResName() {
        return resName;
    }
    public void setResName(String resName) {
        this.resName = resName == null ? null : resName.trim();
    }
    public Date getEndDate() {
        return endDate;
    }
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    public String getTestPlace() {
        return testPlace;
    }
    public void setTestPlace(String testPlace) {
        this.testPlace = testPlace == null ? null : testPlace.trim();
    }
    public String getTestType() {
        return testType;
    }
    public void setTestType(String testType) {
        this.testType = testType == null ? null : testType.trim();
    }
    public String getTestProportion() {
        return testProportion;
    }
    public void setTestProportion(String testProportion) {
        this.testProportion = testProportion == null ? null : testProportion.trim();
    }
    public String getTestLeadMan() {
        return testLeadMan;
    }
    public void setTestLeadMan(String testLeadMan) {
        this.testLeadMan = testLeadMan == null ? null : testLeadMan.trim();
    }
    public String getTestTrainNum() {
        return testTrainNum;
    }
    public void setTestTrainNum(String testTrainNum) {
        this.testTrainNum = testTrainNum == null ? null : testTrainNum.trim();
    }
    public String getTestTrainList() {
        return testTrainList;
    }
    public void setTestTrainList(String testTrainList) {
        this.testTrainList = testTrainList == null ? null : testTrainList.trim();
    }
    public String getSvnURL() {
        return svnURL;
    }
    public void setSvnURL(String svnURL) {
        this.svnURL = svnURL == null ? null : svnURL.trim();
    }
    public String getResType() {
        return resType;
    }
    public void setResType(String resType) {
        this.resType = resType == null ? null : resType.trim();
    }
    public String getInputUser() {
        return inputUser;
    }
    public void setInputUser(String inputUser) {
        this.inputUser = inputUser == null ? null : inputUser.trim();
    }
    public Date getInputDate() {
        return inputDate;
    }
    public void setInputDate(Date inputDate) {
        this.inputDate = inputDate;
    }
    public String getEditUser() {
        return editUser;
    }
    public void setEditUser(String editUser) {
        this.editUser = editUser == null ? null : editUser.trim();
    }
    public Date getEditDate() {
        return editDate;
    }
    public void setEditDate(Date editDate) {
        this.editDate = editDate;
    }
    public String getResVersion() {
        return resVersion;
    }
    public void setResVersion(String resVersion) {
        this.resVersion = resVersion == null ? null : resVersion.trim();
    }
    public String getSvnVersion() {
        return svnVersion;
    }
    public void setSvnVersion(String svnVersion) {
        this.svnVersion = svnVersion == null ? null : svnVersion.trim();
    }
    public String getRemark() {
        return remark;
    }
    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }
    public String getCatalogNO() {
        return catalogNO;
    }
    public void setCatalogNO(String catalogNO) {
        this.catalogNO = catalogNO == null ? null : catalogNO.trim();
    }
    public String getCatalogName() {
        return catalogName;
    }
    public void setCatalogName(String catalogName) {
        this.catalogName = catalogName == null ? null : catalogName.trim();
    }
    public String getExtend() {
        return extend;
    }
    public void setExtend(String extend) {
        this.extend = extend;
    }




    @Override
    public String toString() {
        return "ResultRes [tNO=" + tNO + ", resId=" + resId + ", resName=" + resName
                + ", endDate=" + endDate + ", testPlace=" + testPlace
                + ", testType=" + testType + ", testProportion="
                + testProportion + ", testLeadMan=" + testLeadMan
                + ", testTrainNum=" + testTrainNum + ", testTrainList="
                + testTrainList + ", svnURL=" + svnURL + ", resType=" + resType
                + ", inputUser=" + inputUser + ", inputDate=" + inputDate
                + ", editUser=" + editUser + ", editDate=" + editDate
                + ", resVersion=" + resVersion + ", svnVersion=" + svnVersion
                + ", remark=" + remark + ", status=" + status + ", catalogNO="
                + catalogNO + ", catalogName=" + catalogName + ", extend="
                + extend + "]";
    }

}
