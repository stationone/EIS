package com.ecspace.business.es.pojo;

/**
 * 用来封装获取出来的索引库列表
 */
public class T {
    private String text;
    private boolean checked;

    public T() {
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public T(String text, boolean checked) {
        this.text = text;
        this.checked = checked;
    }

    public T(String text) {
        this.text = text;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}
