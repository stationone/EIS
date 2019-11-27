package com.ecspace.business.resourceCenter.administrator.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 目录用户检出表
 */
public class CatalogUserCheckOutLink {
    private String tNO;

    private String catalogNO;

    private String catalogName; //目录原始名称

    private String parentNO;

    private String userTNO;

    private String userCheckoutName; //用户检出名称

    private String inputUser;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date inputDate;

    private String editUser;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date editDate;

    private String status;

    private String explain;  //等于3时，意味着目录不存在

    public CatalogUserCheckOutLink() {
    }

    public CatalogUserCheckOutLink(String tNO, String catalogNO, String catalogName, String parentNO, String userTNO, String userCheckoutName, String inputUser, Date inputDate, String editUser, Date editDate, String status, String explain) {
        this.tNO = tNO;
        this.catalogNO = catalogNO;
        this.catalogName = catalogName;
        this.parentNO = parentNO;
        this.userTNO = userTNO;
        this.userCheckoutName = userCheckoutName;
        this.inputUser = inputUser;
        this.inputDate = inputDate;
        this.editUser = editUser;
        this.editDate = editDate;
        this.status = status;
        this.explain = explain;
    }

    public String gettNO() {
        return tNO;
    }

    public void settNO(String tNO) {
        this.tNO = tNO;
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

    public String getParentNO() {
        return parentNO;
    }

    public void setParentNO(String parentNO) {
        this.parentNO = parentNO;
    }

    public String getUserTNO() {
        return userTNO;
    }

    public void setUserTNO(String userTNO) {
        this.userTNO = userTNO;
    }

    public String getUserCheckoutName() {
        return userCheckoutName;
    }

    public void setUserCheckoutName(String userCheckoutName) {
        this.userCheckoutName = userCheckoutName;
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

    public String getExplain() {
        return explain;
    }

    public void setExplain(String explain) {
        this.explain = explain;
    }

    @Override
    public String toString() {
        return "CatalogUserCheckOutLink{" +
                "tNO='" + tNO + '\'' +
                ", catalogNO='" + catalogNO + '\'' +
                ", catalogName='" + catalogName + '\'' +
                ", parentNO='" + parentNO + '\'' +
                ", userTNO='" + userTNO + '\'' +
                ", userCheckoutName='" + userCheckoutName + '\'' +
                ", inputUser='" + inputUser + '\'' +
                ", inputDate=" + inputDate +
                ", editUser='" + editUser + '\'' +
                ", editDate=" + editDate +
                ", status='" + status + '\'' +
                ", explain='" + explain + '\'' +
                '}';
    }
}
