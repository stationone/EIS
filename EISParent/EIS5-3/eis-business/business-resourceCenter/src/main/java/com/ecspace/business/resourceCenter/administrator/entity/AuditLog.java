package com.ecspace.business.resourceCenter.administrator.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.sql.Timestamp;

/**
 * 资源日志
 * @author tongy
 * 存储资源历史记录，主要用于资源历史版本的存储。
 */
public class AuditLog {
	private int actionId;	//流水号
	private String histEntityId;	//操作对象编号
	private String histVersion;	//版本号
	private String userId;	//用户名
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Timestamp histTime;	//操作时间
	private String histAction;	//操作
	private String histEntityType;	//操作实体名
	private String histDescription;	//说明
	private String histResURL;	//svn历史资源路径
	private String histResName;	//历史资源名称
	private String resId;	//资源编号
	
	public AuditLog() {
		super();
	}

	public AuditLog(int actionId, String histEntityId, String histVersion,
                    String userId, Timestamp histTime, String histAction,
                    String histEntityType, String histDescription, String histResURL,
                    String histResName, String resId) {
		super();
		this.actionId = actionId;
		this.histEntityId = histEntityId;
		this.histVersion = histVersion;
		this.userId = userId;
		this.histTime = histTime;
		this.histAction = histAction;
		this.histEntityType = histEntityType;
		this.histDescription = histDescription;
		this.histResURL = histResURL;
		this.histResName = histResName;
		this.resId = resId;
	}

	public int getActionId() {
		return actionId;
	}

	public void setActionId(int actionId) {
		this.actionId = actionId;
	}

	public String getHistEntityId() {
		return histEntityId;
	}

	public void setHistEntityId(String histEntityId) {
		this.histEntityId = histEntityId == null ? null : histEntityId.trim();
	}

	public String getHistVersion() {
		return histVersion;
	}

	public void setHistVersion(String histVersion) {
		this.histVersion = histVersion == null ? null : histVersion.trim();
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId == null ? null : userId.trim();
	}

	public Timestamp getHistTime() {
		return histTime;
	}

	public void setHistTime(Timestamp histTime) {
		this.histTime = histTime;
	}

	public String getHistAction() {
		return histAction;
	}

	public void setHistAction(String histAction) {
		this.histAction = histAction == null ? null : histAction.trim();
	}

	public String getHistEntityType() {
		return histEntityType;
	}

	public void setHistEntityType(String histEntityType) {
		this.histEntityType = histEntityType == null ? null : histEntityType.trim();
	}

	public String getHistDescription() {
		return histDescription;
	}

	public void setHistDescription(String histDescription) {
		this.histDescription = histDescription == null ? null : histDescription.trim();
	}

	public String getHistResURL() {
		return histResURL;
	}

	public void setHistResURL(String histResURL) {
		this.histResURL = histResURL == null ? null : histResURL.trim();
	}

	public String getHistResName() {
		return histResName;
	}

	public void setHistResName(String histResName) {
		this.histResName = histResName == null ? null : histResName.trim();
	}

	public String getResId() {
		return resId;
	}

	public void setResId(String resId) {
		this.resId = resId == null ? null : resId.trim();
	}

	@Override
	public String toString() {
		return "AuditLog [actionId=" + actionId + ", histEntityId="
				+ histEntityId + ", histVersion=" + histVersion + ", userId="
				+ userId + ", histTime=" + histTime + ", histAction="
				+ histAction + ", histEntityType=" + histEntityType
				+ ", histDescription=" + histDescription + ", histResURL="
				+ histResURL + ", histResName=" + histResName + ", resId="
				+ resId + "]";
	}
}
