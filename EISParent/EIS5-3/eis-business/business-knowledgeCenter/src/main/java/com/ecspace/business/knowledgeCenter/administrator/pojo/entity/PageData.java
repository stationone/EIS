package com.ecspace.business.knowledgeCenter.administrator.pojo.entity;

import java.util.List;

/**
 * 返回的页面数据
 * @author zhangch
 * @date 2019/10/17 0017 下午 18:04
 */
public class PageData {

    private Integer total;

    private List rows;

    public PageData() {
    }

    public PageData(List rows) {
        this.rows = rows;
    }

    public PageData(Integer total, List rows) {
        this.total = total;
        this.rows = rows;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public List getRows() {
        return rows;
    }

    public void setRows(List rows) {
        this.rows = rows;
    }
}
