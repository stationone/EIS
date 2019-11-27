package com.ecspace.business.resourceCenter.administrator.entity;

import java.util.Date;

/**
 * 资源用户
 * 用于设定用户是否有访问资源中心的权限
 */
public class ResourceCatalogUser {
    private String tNO;

    private String userTNO;

    private String userName;

    private String resCataTNO; //资源目录流水号

    private String resCataName;

    private String inputUser;

    private Date inputDate;

    private String editUser;

    private Date editDate;

    private String status;

    public ResourceCatalogUser() {
    }

    public ResourceCatalogUser(String tNO, String userTNO, String userName, String resCataTNO, String resCataName, String inputUser, Date inputDate, String editUser, Date editDate, String status) {
        this.tNO = tNO;
        this.userTNO = userTNO;
        this.userName = userName;
        this.resCataTNO = resCataTNO;
        this.resCataName = resCataName;
        this.inputUser = inputUser;
        this.inputDate = inputDate;
        this.editUser = editUser;
        this.editDate = editDate;
        this.status = status;
    }

    public String gettNO() {
        return tNO;
    }

    public void settNO(String tNO) {
        this.tNO = tNO;
    }

    public String getUserTNO() {
        return userTNO;
    }

    public void setUserTNO(String userTNO) {
        this.userTNO = userTNO;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getResCataTNO() {
        return resCataTNO;
    }

    public void setResCataTNO(String resCataTNO) {
        this.resCataTNO = resCataTNO;
    }

    public String getResCataName() {
        return resCataName;
    }

    public void setResCataName(String resCataName) {
        this.resCataName = resCataName;
    }

    public String getInputUser() {
        return inputUser;
    }

    public void setInputUser(String inputUser) {
        this.inputUser = inputUser;
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
        this.editUser = editUser;
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
        this.status = status;
    }

    @Override
    public String toString() {
        return "ResCataUser{" +
                "tNO='" + tNO + '\'' +
                ", userTNO='" + userTNO + '\'' +
                ", userName='" + userName + '\'' +
                ", resCataTNO='" + resCataTNO + '\'' +
                ", resCataName='" + resCataName + '\'' +
                ", inputUser='" + inputUser + '\'' +
                ", inputDate=" + inputDate +
                ", editUser='" + editUser + '\'' +
                ", editDate=" + editDate +
                ", status='" + status + '\'' +
                '}';
    }
}
