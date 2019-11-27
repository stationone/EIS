package com.ecspace.business.es.pojo;

/**
 * @Auther: menb
 * @Date: 2019/8/9
 * @Description: com.ecspace.business.es.pojo
 * @version:
 */
public class Column {
    private String field;//列字段名称
    private String title;//列标题文本
    private Integer width;
    private String align;//指明如何对齐列数据。可以使用的值有：'left','right','center'
    //是否可以排序
    private boolean sortable;

    public boolean getSortable() {
        return sortable;
    }

    public void setSortable(boolean sortable) {
        this.sortable = sortable;
    }

    public Integer getWidth() {
        return width;
    }

    public void setWidth(Integer width) {
        this.width = width;
    }

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAlign() {
        return align;
    }

    public void setAlign(String align) {
        this.align = align;
    }
}
