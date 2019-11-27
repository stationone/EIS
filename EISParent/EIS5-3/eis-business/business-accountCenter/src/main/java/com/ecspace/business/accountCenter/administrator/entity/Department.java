package com.ecspace.business.accountCenter.administrator.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 部门
 */
public class Department {

    private String tNO; //流水号

    private String departmentName; //名称

    private String pDepartmentTNO; //上级部门流水号

    private String inputUser;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date inputDate;

    private String editUser;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date editDate;

    private String status; //1表示没有子节点，2表示有子节点

    private String explain; //说明

    public Department() {
    }

    public Department(String tNO, String departmentName, String pDepartmentTNO, String inputUser, Date inputDate, String editUser, Date editDate, String status, String explain) {
        this.tNO = tNO;
        this.departmentName = departmentName;
        this.pDepartmentTNO = pDepartmentTNO;
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

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getpDepartmentTNO() {
        return pDepartmentTNO;
    }

    public void setpDepartmentTNO(String pDepartmentTNO) {
        this.pDepartmentTNO = pDepartmentTNO;
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
        return "Department{" +
                "tNO='" + tNO + '\'' +
                ", departmentName='" + departmentName + '\'' +
                ", pDepartmentTNO='" + pDepartmentTNO + '\'' +
                ", inputUser='" + inputUser + '\'' +
                ", inputDate=" + inputDate +
                ", editUser='" + editUser + '\'' +
                ", editDate='" + editDate + '\'' +
                ", status='" + status + '\'' +
                ", explain='" + explain + '\'' +
                '}';
    }
}