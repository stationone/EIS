package com.ecspace.business.resourceCenter.util;

/**
 * 分页
 * @author tongy
 * 分页信息定义
 */
public class PageBean {
	private int page; 		// 页码(当前页)
    private int pageSize; 	// 单页数据量
    private int startTemp;	//起始点
	public PageBean() {
		super();
	}
	public PageBean(int page, int pageSize) {
		super();
		this.page = page;
		this.pageSize = pageSize;
	}
	public PageBean(int page, int pageSize, int startTemp) {
		super();
		this.page = page;
		this.pageSize = pageSize;
		this.startTemp = startTemp;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getStartTemp() {
		return (page - 1) * pageSize;
	}
	public void setStartTemp(int startTemp) {
		this.startTemp = startTemp;
	}
}
