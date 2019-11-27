package com.ecspace.business.es.pojo;

/**
 * 基础字段实体类
 *
 * @author zhangch
 * @date 2019/10/30 0030 下午 19:25
 */
public class BaseField {
    private Integer id;  //id
    private String name;     //名称
    private String type;           //类型
    private String valueScope;           //取值范围
    private String description;                    //备注描述

    public BaseField() {
    }

    public BaseField(String name, String type, String valueScope, String description) {
        this.name = name;
        this.type = type;
        this.valueScope = valueScope;
        this.description = description;
    }

    public BaseField(String name, String type, String description) {
        this.name = name;
        this.type = type;
        this.description = description;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getValueScope() {
        return valueScope;
    }

    public void setValueScope(String valueScope) {
        this.valueScope = valueScope;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "BaseField{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", type='" + type + '\'' +
                ", valueScope='" + valueScope + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
