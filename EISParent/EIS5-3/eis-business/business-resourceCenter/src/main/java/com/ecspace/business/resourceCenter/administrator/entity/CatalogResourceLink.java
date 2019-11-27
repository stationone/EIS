package com.ecspace.business.resourceCenter.administrator.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class CatalogResourceLink {
    private String tNO;	//流水号
    private String catalogNO;	//目录编号
    private	String resId;	//资源编号
    private String inputUser;	//录入人员
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date inputDate;	//录入日期
    private String editUser;	//编辑人员
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date editDate;	//编辑日期
    public CatalogResourceLink() {
        super();
    }
    public CatalogResourceLink(String tNO, String catalogNO, String resId,
                               String inputUser, Date inputDate, String editUser, Date editDate) {
        super();
        this.tNO = tNO;
        this.catalogNO = catalogNO;
        this.resId = resId;
        this.inputUser = inputUser;
        this.inputDate = inputDate;
        this.editUser = editUser;
        this.editDate = editDate;
    }
    public String gettNO() {
        return tNO;
    }
    public void settNO(String tNO) {
        this.tNO = tNO == null ? null : tNO.trim();
    }
    public String getCatalogNO() {
        return catalogNO;
    }
    public void setCatalogNO(String catalogNO) {
        this.catalogNO = catalogNO == null ? null : catalogNO.trim();
    }
    public String getResId() {
        return resId;
    }
    public void setResId(String resId) {
        this.resId = resId == null ? null : resId.trim();
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
    @Override
    public String toString() {
        return "CatalogResourceLink [tNO=" + tNO + ", catalogNO=" + catalogNO
                + ", resId=" + resId + ", inputUser=" + inputUser
                + ", inputDate=" + inputDate + ", editUser=" + editUser
                + ", editDate=" + editDate + "]";
    }
}
