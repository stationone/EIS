package com.ecspace.business.resourceCenter.user.service.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 资源目录用户关系表
 * @author tongy
 * 用于存储资源目录和用户之间的关系
 */
public class CatalogUserLink {
	private String tNO;	//流水号
	private String catalogNO;	//目录编号
	private String userId;	//用户账号(userId用于存userTNO)
	private String userName;//用户名称
	private String rw;	//权限
	private String inputUser;	//录入人员
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date inputDate;	//录入日期
	private String editUser;	//编辑人员
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date editDate;	//编辑日期

	public CatalogUserLink() {
		super();
	}
	public CatalogUserLink(String tNO, String catalogNO, String userId, String userName, String rw,
                           String inputUser, Date inputDate, String editUser, Date editDate) {
		super();
		this.tNO = tNO;
		this.catalogNO = catalogNO;
		this.userId = userId;
		this.userName = userName;
		this.rw = rw;
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
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId == null ? null : userId.trim();
	}
	public String getRw() {
		return rw;
	}
	public void setRw(String rw) {
		this.rw = rw == null ? null : rw.trim();
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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Override
	public String toString() {
		return "CatalogUserLink{" +
				"tNO='" + tNO + '\'' +
				", catalogNO='" + catalogNO + '\'' +
				", userId='" + userId + '\'' +
				", userName='" + userName + '\'' +
				", rw='" + rw + '\'' +
				", inputUser='" + inputUser + '\'' +
				", inputDate=" + inputDate +
				", editUser='" + editUser + '\'' +
				", editDate=" + editDate +
				'}';
	}
}
