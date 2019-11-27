package com.ecspace.business.accountCenter.administrator.entity;

import java.util.Date;

public class Users {
    private String tNO;	//流水号
    private String userId;	//登录名
    private String userName;	//用户名
    private String userPassword;	//用户密码
    private String empNO;	//员工编号
    private String companyName;	//公司名称
    private String userType;	//用户类型
    private String inputUser;	//录入人员
    private Date inputDate;	//录入日期
    private String editUser;	//编辑人员
    private Date editDate;	//编辑日期
    private String status;	//状态
    private String description;	//说明
    private String rw;	//权限
    private String deleteMark; //删除状态

    public Users() {
        super();
    }

    public Users(String tNO, String userId, String userName,
                 String userPassword, String empNO, String companyName,
                 String userType, String inputUser, Date inputDate, String editUser,
                 Date editDate, String status, String description, String rw,
                 String deleteMark) {
        super();
        this.tNO = tNO;
        this.userId = userId;
        this.userName = userName;
        this.userPassword = userPassword;
        this.empNO = empNO;
        this.companyName = companyName;
        this.userType = userType;
        this.inputUser = inputUser;
        this.inputDate = inputDate;
        this.editUser = editUser;
        this.editDate = editDate;
        this.status = status;
        this.description = description;
        this.rw = rw;
        this.deleteMark = deleteMark;
    }
    public String gettNO() {
        return tNO;
    }
    public void settNO(String tNO) {
        this.tNO = tNO == null ? null : tNO.trim();
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }
    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName == null ? null : userName.trim();
    }
    public String getUserPassword() {
        return userPassword;
    }
    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword == null ? null : userPassword.trim();
    }
    public String getEmpNO() {
        return empNO;
    }
    public void setEmpNO(String empNO) {
        this.empNO = empNO == null ? null : empNO.trim();
    }
    public String getCompanyName() {
        return companyName;
    }
    public void setCompanyName(String companyName) {
        this.companyName = companyName == null ? null : companyName.trim();
    }
    public String getUserType() {
        return userType;
    }
    public void setUserType(String userType) {
        this.userType = userType == null ? null : userType.trim();
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
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }
    public String getRw() {
        return rw;
    }
    public void setRw(String rw) {
        this.rw = rw == null ? null : rw.trim();
    }

    public String getDeleteMark() {
        return deleteMark;
    }

    public void setDeleteMark(String deleteMark) {
        this.deleteMark = deleteMark;
    }

    @Override
    public String toString() {
        return "Users [tNO=" + tNO + ", userId=" + userId + ", userName="
                + userName + ", userPassword=" + userPassword + ", empNO="
                + empNO + ", companyName=" + companyName + ", userType="
                + userType + ", inputUser=" + inputUser + ", inputDate="
                + inputDate + ", editUser=" + editUser + ", editDate="
                + editDate + ", status=" + status + ", description="
                + description + ", rw=" + rw + ", deleteMark=" + deleteMark
                + "]";
    }
}
