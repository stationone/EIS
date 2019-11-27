package com.ecspace.business.resourceCenter.user.service.entity;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 资源目录
 */
public class ResourceCatalog {
    private String catalogNO;	//目录编号
    private String catalogName;	//目录名称
    private String parentNO;	//父目录
    private String catalogPath;	//目录路径
    private String svnURL;	//目录URL(SVN目标路径)
    private String prototcol;	//协议
    private String inputUser;	//上传者
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date inputDate;	//创建日期
    private String editUser;	//编辑人员
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date editDate;	//编辑日期
    private String rw; //权限 P：只是占位，没有任何权限 R：只读 RW：读写
    private String status; //1表示没有子节点，2表示有子节点

    public ResourceCatalog() {
        super();
    }
    public ResourceCatalog(String catalogNO, String catalogName, String parentNO,
                           String catalogPath, String svnURL, String prototcol,
                           String inputUser, Date inputDate, String editUser, Date editDate,
                           String rw, String status) {
        super();
        this.catalogNO = catalogNO;
        this.catalogName = catalogName;
        this.parentNO = parentNO;
        this.catalogPath = catalogPath;
        this.svnURL = svnURL;
        this.prototcol = prototcol;
        this.inputUser = inputUser;
        this.inputDate = inputDate;
        this.editUser = editUser;
        this.editDate = editDate;
        this.rw = rw;
        this.status = status;
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
    public String getParentNO() {
        return parentNO;
    }
    public void setParentNO(String parentNO) {
        this.parentNO = parentNO == null ? null : parentNO.trim();
    }
    public String getCatalogPath() {
        return catalogPath;
    }
    public void setCatalogPath(String catalogPath) {
        this.catalogPath = catalogPath == null ? null : catalogPath.trim();
    }

    public String getSvnURL() {
        return svnURL;
    }
    public void setSvnURL(String svnURL) {
        this.svnURL = svnURL == null ? null : svnURL.trim();
    }
    public String getPrototcol() {
        return prototcol;
    }
    public void setPrototcol(String prototcol) {
        this.prototcol = prototcol == null ? null : prototcol.trim();
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
    public String getRw() {
        return rw;
    }
    public void setRw(String rw) {
        this.rw = rw;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ResCatalog{" +
                "catalogNO='" + catalogNO + '\'' +
                ", catalogName='" + catalogName + '\'' +
                ", parentNO='" + parentNO + '\'' +
                ", catalogPath='" + catalogPath + '\'' +
                ", svnURL='" + svnURL + '\'' +
                ", prototcol='" + prototcol + '\'' +
                ", inputUser='" + inputUser + '\'' +
                ", inputDate=" + inputDate +
                ", editUser='" + editUser + '\'' +
                ", editDate=" + editDate +
                ", rw='" + rw + '\'' +
                ", status='" + status + '\'' +
                '}';
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((catalogNO == null) ? 0 : catalogNO.hashCode());
        result = prime * result
                + ((catalogName == null) ? 0 : catalogName.hashCode());
        result = prime * result
                + ((catalogPath == null) ? 0 : catalogPath.hashCode());
        result = prime * result
                + ((editDate == null) ? 0 : editDate.hashCode());
        result = prime * result
                + ((editUser == null) ? 0 : editUser.hashCode());
        result = prime * result
                + ((inputDate == null) ? 0 : inputDate.hashCode());
        result = prime * result
                + ((inputUser == null) ? 0 : inputUser.hashCode());
        result = prime * result
                + ((parentNO == null) ? 0 : parentNO.hashCode());
        result = prime * result
                + ((prototcol == null) ? 0 : prototcol.hashCode());
//		result = prime * result + ((rw == null) ? 0 : rw.hashCode());
        result = prime * result + ((svnURL == null) ? 0 : svnURL.hashCode());
        return result;
    }
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ResourceCatalog other = (ResourceCatalog) obj;
        if (catalogNO == null) {
            if (other.catalogNO != null)
                return false;
        } else if (!catalogNO.equals(other.catalogNO))
            return false;
        if (catalogName == null) {
            if (other.catalogName != null)
                return false;
        } else if (!catalogName.equals(other.catalogName))
            return false;
        if (catalogPath == null) {
            if (other.catalogPath != null)
                return false;
        } else if (!catalogPath.equals(other.catalogPath))
            return false;
        if (editDate == null) {
            if (other.editDate != null)
                return false;
        } else if (!editDate.equals(other.editDate))
            return false;
        if (editUser == null) {
            if (other.editUser != null)
                return false;
        } else if (!editUser.equals(other.editUser))
            return false;
        if (inputDate == null) {
            if (other.inputDate != null)
                return false;
        } else if (!inputDate.equals(other.inputDate))
            return false;
        if (inputUser == null) {
            if (other.inputUser != null)
                return false;
        } else if (!inputUser.equals(other.inputUser))
            return false;
        if (parentNO == null) {
            if (other.parentNO != null)
                return false;
        } else if (!parentNO.equals(other.parentNO))
            return false;
        if (prototcol == null) {
            if (other.prototcol != null)
                return false;
        } else if (!prototcol.equals(other.prototcol))
            return false;
//		if (rw == null) {
//			if (other.rw != null)
//				return false;
//		} else if (!rw.equals(other.rw))
//			return false;
        if (svnURL == null) {
            if (other.svnURL != null)
                return false;
        } else if (!svnURL.equals(other.svnURL))
            return false;
        return true;
    }
}
